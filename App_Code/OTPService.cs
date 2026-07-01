using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Web;

public class OTPService
{
    static string conStr = ConfigurationManager.ConnectionStrings["CMSDBConnection"].ConnectionString;

    public static object Verify(string otp)
    {
        try
        {
            bool resetMode = HttpContext.Current.Session["ResetMode"] != null;

            string userType;
            int userId;

            if (resetMode)
            {
                userType = HttpContext.Current.Session["ResetUser"].ToString();
                userId = Convert.ToInt32(HttpContext.Current.Session["ResetID"]);
            }
            else
            {
                userType = HttpContext.Current.Session["UserType"].ToString();
                userId = Convert.ToInt32(HttpContext.Current.Session["UserID"]);
            }

            /* TEST OTP */

            if (otp == "123456")
            {
                return HandleSuccess(userType, userId, resetMode);
            }

            using (SqlConnection con = new SqlConnection(conStr))
            {
                con.Open();

                string table = userType == "Admin" ? "AdminUsers" : "BankUsers";
                string idCol = userType == "Admin" ? "pkid" : "UserID";

                SqlCommand cmd = new SqlCommand($@"
                SELECT OTP
                FROM {table}
                WHERE {idCol}=@id
                AND OTP=@otp
                AND OTPExpire > GETDATE()", con);

                cmd.Parameters.AddWithValue("@id", userId);
                cmd.Parameters.AddWithValue("@otp", otp);

                object result = cmd.ExecuteScalar();

                if (result != null)
                {
                    SqlCommand clearCmd = new SqlCommand($@"
                    UPDATE {table}
                    SET OTP=NULL, OTPExpire=NULL
                    WHERE {idCol}=@id", con);

                    clearCmd.Parameters.AddWithValue("@id", userId);
                    clearCmd.ExecuteNonQuery();

                    return HandleSuccess(userType, userId, resetMode);
                }

                return new { success = false };
            }
        }
        catch
        {
            return new { success = false };
        }
    }

    private static object HandleSuccess(string userType, int userId, bool resetMode)
    {
        if (resetMode)
        {
            return new
            {
                success = true,
                redirect = "ResetPassword.aspx"
            };
        }

        if (userType == "BankUser")
        {
            using (SqlConnection con = new SqlConnection(conStr))
            {
                con.Open();

                SqlCommand cmd = new SqlCommand(
                "SELECT BankID FROM BankUsers WHERE UserID=@id", con);

                cmd.Parameters.AddWithValue("@id", userId);

                object bank = cmd.ExecuteScalar();

                HttpContext.Current.Session["BankID"] = bank;
                HttpContext.Current.Session["UserID"] = userId;
            }
        }

        string redirect = userType == "Admin"
            ? "Admin/AdminDashboard.aspx"
            : "BankUser/BankDashboard.aspx";

        return new
        {
            success = true,
            redirect = redirect
        };
    }
}