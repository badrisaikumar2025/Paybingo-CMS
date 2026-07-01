using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Security.Cryptography;
using System.Text;
using System.Web;
using System.Web.Services;

public partial class BankUser_ChangePassword : System.Web.UI.Page
{
    static string conStr = ConfigurationManager.ConnectionStrings["CMSDBConnection"].ConnectionString;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["UserID"] == null)
        {
            Response.Redirect("../Home.aspx");
        }
    }

    [WebMethod]
    public static object UpdatePassword(string password)
    {
        try
        {
            int userId = Convert.ToInt32(HttpContext.Current.Session["UserID"]);

            string md5 = GetMD5(password);

            using (SqlConnection con = new SqlConnection(conStr))
            {
                con.Open();

                SqlCommand cmd = new SqlCommand(
                "UPDATE BankUsers SET Password=@p, IsFirstLogin=0 WHERE UserID=@id", con);

                cmd.Parameters.AddWithValue("@p", md5);
                cmd.Parameters.AddWithValue("@id", userId);

                cmd.ExecuteNonQuery();
            }

            return new
            {
                success = true
            };
        }
        catch
        {
            return new
            {
                success = false
            };
        }
    }

    public static string GetMD5(string input)
    {
        using (MD5 md5 = MD5.Create())
        {
            byte[] bytes = Encoding.UTF8.GetBytes(input);
            byte[] hash = md5.ComputeHash(bytes);

            StringBuilder sb = new StringBuilder();

            foreach (byte b in hash)
                sb.Append(b.ToString("x2"));

            return sb.ToString();
        }
    }
}