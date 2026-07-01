using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Web;
using System.Web.Services;

public partial class ForgotPassword : System.Web.UI.Page
{
    static string conStr = ConfigurationManager.ConnectionStrings["CMSDBConnection"].ConnectionString;

    protected void Page_Load(object sender, EventArgs e)
    {

    }

    /* 
       SEND OTP */
    

    [WebMethod]
    public static object SendOTP(string user)
    {
        try
        {
            using (SqlConnection con = new SqlConnection(conStr))
            {
                con.Open();

                /* 
                   CHECK ADMIN
                */

                SqlCommand cmd = new SqlCommand(
                "SELECT pkid FROM AdminUsers WHERE Email=@u OR Phone=@u", con);

                cmd.Parameters.AddWithValue("@u", user);

                object admin = cmd.ExecuteScalar();

                if (admin != null)
                {
                    string otp = GenerateOTP();

                    SqlCommand otpCmd = new SqlCommand(
                    "UPDATE AdminUsers SET OTP=@otp, OTPExpire=DATEADD(MINUTE,5,GETDATE()) WHERE pkid=@id", con);

                    otpCmd.Parameters.AddWithValue("@otp", otp);
                    otpCmd.Parameters.AddWithValue("@id", admin);
                    otpCmd.ExecuteNonQuery();

                    /* RESET PASSWORD MODE */

                    HttpContext.Current.Session["ResetMode"] = true;
                    HttpContext.Current.Session["ResetUser"] = "Admin";
                    HttpContext.Current.Session["ResetID"] = admin;

                    return new
                    {
                        success = true,
                        redirect = "OtpVerify.aspx"
                    };
                }

                /* 
                   CHECK BANK USER
                */

                SqlCommand userCmd = new SqlCommand(
                "SELECT UserID FROM BankUsers WHERE Email=@u OR Phone=@u", con);

                userCmd.Parameters.AddWithValue("@u", user);

                object uid = userCmd.ExecuteScalar();

                if (uid != null)
                {
                    string otp = GenerateOTP();

                    SqlCommand otpCmd = new SqlCommand(
                    "UPDATE BankUsers SET OTP=@otp, OTPExpire=DATEADD(MINUTE,5,GETDATE()) WHERE UserID=@id", con);

                    otpCmd.Parameters.AddWithValue("@otp", otp);
                    otpCmd.Parameters.AddWithValue("@id", uid);
                    otpCmd.ExecuteNonQuery();

                    /* RESET PASSWORD MODE */

                    HttpContext.Current.Session["ResetMode"] = true;
                    HttpContext.Current.Session["ResetUser"] = "User";
                    HttpContext.Current.Session["ResetID"] = uid;

                    return new
                    {
                        success = true,
                        redirect = "OtpVerify.aspx"
                    };
                }

                return new
                {
                    success = false,
                    message = "User not found"
                };
            }
        }
        catch (Exception ex)
        {
            return new
            {
                success = false,
                message = ex.Message
            };
        }
    }

    /* 
       OTP GENERATOR
     */

    public static string GenerateOTP()
    {
        Random rnd = new Random();
        return rnd.Next(100000, 999999).ToString();
    }
}