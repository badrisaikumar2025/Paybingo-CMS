using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Web;

public class AdminAuth
{
    static string conStr = ConfigurationManager.ConnectionStrings["CMSDBConnection"].ConnectionString;

    public static object Login(string userid, string password)
    {
        using (SqlConnection con = new SqlConnection(conStr))
        {
            con.Open();

            SqlCommand cmd = new SqlCommand(@"SELECT pkid,password,Salt,FullName 
            FROM AdminUsers 
            WHERE (username=@u OR Email=@u OR Phone=@u)
            AND IsActive=1", con);

            cmd.Parameters.AddWithValue("@u", userid);

            SqlDataReader dr = cmd.ExecuteReader();

            if (dr.Read())
            {
                int adminId = Convert.ToInt32(dr["pkid"]);
                string dbHash = dr["password"].ToString();
                string salt = dr["Salt"].ToString();
                string name = dr["FullName"].ToString();

                dr.Close();

                string hash = SecurityHelper.HashPasswordSHA256(password, salt);

                if (hash == dbHash)
                {
                    string otp = SecurityHelper.GenerateOTP();

                    SqlCommand otpCmd = new SqlCommand(
                    "UPDATE AdminUsers SET OTP=@otp,OTPExpire=DATEADD(MINUTE,5,GETDATE()) WHERE pkid=@id", con);

                    otpCmd.Parameters.AddWithValue("@otp", otp);
                    otpCmd.Parameters.AddWithValue("@id", adminId);
                    otpCmd.ExecuteNonQuery();

                    HttpContext.Current.Session["UserType"] = "Admin";
                    HttpContext.Current.Session["UserID"] = adminId;
                    HttpContext.Current.Session["AdminName"] = name;

                    return new { success = true, redirect = "OtpVerify.aspx" };
                }
            }

            return new { success = false, message = "Invalid admin login" };
        }
    }
}