using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Security.Cryptography;
using System.Text;
using System.Web;
using System.Web.Services;

public partial class ResetPassword : System.Web.UI.Page
{
    static string conStr = ConfigurationManager.ConnectionStrings["CMSDBConnection"].ConnectionString;

    protected void Page_Load(object sender, EventArgs e)
    {
        /* SECURITY CHECK */

        if (Session["ResetID"] == null)
        {
            Response.Redirect("Home.aspx");
        }
    }

    [WebMethod(EnableSession = true)]
    public static object UpdatePassword(string password)
    {
        try
        {
            if (HttpContext.Current.Session["ResetID"] == null)
            {
                return new { success = false };
            }

            string userType = HttpContext.Current.Session["ResetUser"].ToString();
            int userId = Convert.ToInt32(HttpContext.Current.Session["ResetID"]);

            using (SqlConnection con = new SqlConnection(conStr))
            {
                con.Open();

                if (userType == "Admin")
                {
                    string hash = GetSHA256(password);

                    SqlCommand cmd = new SqlCommand(
                    "UPDATE AdminUsers SET password=@p WHERE pkid=@id", con);

                    cmd.Parameters.AddWithValue("@p", hash);
                    cmd.Parameters.AddWithValue("@id", userId);

                    cmd.ExecuteNonQuery();
                }
                else
                {
                    string md5 = GetMD5(password);

                    SqlCommand cmd = new SqlCommand(
                    "UPDATE BankUsers SET Password=@p WHERE UserID=@id", con);

                    cmd.Parameters.AddWithValue("@p", md5);
                    cmd.Parameters.AddWithValue("@id", userId);

                    cmd.ExecuteNonQuery();
                }
            }

            /* CLEAR SESSION */

            HttpContext.Current.Session.Clear();
            HttpContext.Current.Session.Abandon();

            return new
            {
                success = true,
                redirect = "Home.aspx"
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

    public static string GetSHA256(string input)
    {
        using (SHA256 sha = SHA256.Create())
        {
            byte[] bytes = Encoding.UTF8.GetBytes(input);
            byte[] hash = sha.ComputeHash(bytes);

            StringBuilder sb = new StringBuilder();

            foreach (byte b in hash)
                sb.Append(b.ToString("x2"));

            return sb.ToString();
        }
    }
}