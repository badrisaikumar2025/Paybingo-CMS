using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Security.Cryptography;
using System.Text;
using System.Web;
using System.Web.Services;

public partial class Admin_CreateAdmin : System.Web.UI.Page
{

    static string conStr =
    ConfigurationManager.ConnectionStrings["CMSDBConnection"].ConnectionString;

    protected void Page_Load(object sender, EventArgs e)
    {

        if (Session["UserType"] == null || Session["UserType"].ToString() != "Admin")
        {
            Response.Redirect("../Home.aspx");
        }

    }


    [WebMethod]
    public static object VerifyKey(string key)
    {

        string secret = ConfigurationManager.AppSettings["CreateAdminKey"];

        if (key == secret)
            return new { success = true };

        return new { success = false };

    }



    [WebMethod]
    public static object CreateAdmin(string key, string name, string email, string phone, string password)
    {

        try
        {

            string secret = ConfigurationManager.AppSettings["CreateAdminKey"];
            
            if (key != secret)
             return new { success = false, message = "Invalid security key" };

            if (HttpContext.Current.Session["UserID"] == null)
                return new { success = false, message = "Unauthorized access" };



            using (SqlConnection con = new SqlConnection(conStr))
            {

                con.Open();

                SqlCommand check = new SqlCommand(
                "SELECT COUNT(*) FROM AdminUsers WHERE Email=@e", con);

                check.Parameters.AddWithValue("@e", email);

                int exists = (int)check.ExecuteScalar();

                if (exists > 0)
                    return new { success = false, message = "Email already exists" };



                string salt = Guid.NewGuid().ToString();
                string hash = HashPasswordSHA256(password, salt);



                SqlCommand cmd = new SqlCommand(@"INSERT INTO AdminUsers   (username,password,Salt,FullName,Email,Phone,IsActive,CreateDate)VALUES(@u,@p,@s,@n,@e,@ph,1,GETDATE())", con);



                cmd.Parameters.AddWithValue("@u", email);
                cmd.Parameters.AddWithValue("@p", hash);
                cmd.Parameters.AddWithValue("@s", salt);
                cmd.Parameters.AddWithValue("@n", name);
                cmd.Parameters.AddWithValue("@e", email);
                cmd.Parameters.AddWithValue("@ph", phone);

                cmd.ExecuteNonQuery();



                int adminId = Convert.ToInt32(HttpContext.Current.Session["UserID"]);

                string ip = HttpContext.Current.Request.UserHostAddress;



                SqlCommand log = new SqlCommand(@"

INSERT INTO AdminActivityLogs
(AdminID,Action,Target,IPAddress,CreatedDate)

VALUES
(@aid,'Created Admin',@target,@ip,GETDATE())
", con);



                log.Parameters.AddWithValue("@aid", adminId);
                log.Parameters.AddWithValue("@target", email);
                log.Parameters.AddWithValue("@ip", ip);

                log.ExecuteNonQuery();



                return new { success = true };

            }

        }

        catch
        {

            return new { success = false, message = "Server error" };

        }

    }



    public static string HashPasswordSHA256(string password, string salt)
    {

        using (SHA256 sha = SHA256.Create())
        {

            byte[] bytes = Encoding.UTF8.GetBytes(password + salt);

            byte[] hash = sha.ComputeHash(bytes);

            StringBuilder sb = new StringBuilder();

            foreach (byte b in hash)
                sb.Append(b.ToString("x2"));

            return sb.ToString();

        }

    }

}