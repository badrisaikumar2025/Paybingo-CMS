using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Web;

public class AdminLogger
{
    static string conStr = ConfigurationManager.ConnectionStrings["CMSDBConnection"].ConnectionString;

    public static void Log(string action)
    {
        int adminId = Convert.ToInt32(HttpContext.Current.Session["AdminID"]);

        string page = HttpContext.Current.Request.Url.AbsolutePath;
        string ip = HttpContext.Current.Request.UserHostAddress;
        string browser = HttpContext.Current.Request.Browser.Browser;

        using (SqlConnection con = new SqlConnection(conStr))
        {
            SqlCommand cmd = new SqlCommand(@"INSERT INTO AdminActivityLogs
            (AdminID,Action,Page,IPAddress,Browser)
            VALUES(@AdminID,@Action,@Page,@IP,@Browser)", con);

            cmd.Parameters.AddWithValue("@AdminID", adminId);
            cmd.Parameters.AddWithValue("@Action", action);
            cmd.Parameters.AddWithValue("@Page", page);
            cmd.Parameters.AddWithValue("@IP", ip);
            cmd.Parameters.AddWithValue("@Browser", browser);

            con.Open();
            cmd.ExecuteNonQuery();
        }
    }
}