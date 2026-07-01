using System;
using System.Web;
using System.Web.Services;

public partial class OtpVerify : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["UserType"] == null && Session["ResetMode"] == null)
        {
            Response.Redirect("Home.aspx");
        }
    }

    [WebMethod]
    public static object VerifyOTP(string otp)
    {
        return OTPService.Verify(otp);
    }
}