using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Web;

public class BankUserAuth
{
    static string conStr = ConfigurationManager.ConnectionStrings["CMSDBConnection"].ConnectionString;

    public static object Login(string userid, string password)
    {
        using (SqlConnection con = new SqlConnection(conStr))
        {
            con.Open();

            string md5 = SecurityHelper.GetMD5(password);

            SqlCommand cmd = new SqlCommand(@"
SELECT UserID, IsFirstLogin 
FROM BankUsers 
WHERE (Email=@u OR Phone=@u)
AND Password=@p AND IsActive=1", con);

            cmd.Parameters.Add("@u", System.Data.SqlDbType.VarChar).Value = userid;
            cmd.Parameters.Add("@p", System.Data.SqlDbType.VarChar).Value = md5;

            SqlDataReader dr = cmd.ExecuteReader();

            if (dr.Read())
            {
                int id = Convert.ToInt32(dr["UserID"]);
                bool first = Convert.ToBoolean(dr["IsFirstLogin"]);

                dr.Close();

                HttpContext.Current.Session["UserType"] = "BankUser";
                HttpContext.Current.Session["UserID"] = id;

                if (first)
                {
                    return new
                    {
                        success = true,
                        firstLogin = true, // 🔥 IMPORTANT FIX
                        redirect = "BankUser/ChangePassword.aspx"
                    };
                }

                string otp = SecurityHelper.GenerateOTP();

                SqlCommand otpCmd = new SqlCommand(
                "UPDATE BankUsers SET OTP=@otp,OTPExpire=DATEADD(MINUTE,5,GETDATE()) WHERE UserID=@id", con);

                otpCmd.Parameters.AddWithValue("@otp", otp);
                otpCmd.Parameters.AddWithValue("@id", id);
                otpCmd.ExecuteNonQuery();

                return new
                {
                    success = true,
                    redirect = "OtpVerify.aspx"
                };
            }

            return new { success = false, message = "Invalid user login" };
        }
    }
}