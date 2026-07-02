using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Web;
using System.Web.Services;

public partial class Home : System.Web.UI.Page
{
    static string conStr = ConfigurationManager.ConnectionStrings["CMSDBConnection"].ConnectionString;

    protected void Page_Load(object sender, EventArgs e)
    {
        // Logout system
        if (Request.QueryString["logout"] == "1")
        {
            Session.Clear();
            Session.Abandon();
            Response.Redirect("Home.aspx");
        }

        if (!IsPostBack)
        {
            LoadStats();
        }
    }

    //  FIXED METHOD my method to load stats from the database  
    void LoadStats()
    {
        try
        {
            using (SqlConnection con = new SqlConnection(conStr))
            {
                con.Open();

                object t = new SqlCommand("SELECT COUNT(*) FROM Transactions", con).ExecuteScalar();
                object b = new SqlCommand("SELECT COUNT(*) FROM Banks", con).ExecuteScalar();
                object c = new SqlCommand("SELECT COUNT(*) FROM BankUsers", con).ExecuteScalar();

                lblTransactions.InnerHtml = t.ToString();
                lblTransactions.Attributes["data-target"] = t.ToString();

                lblBanks.InnerHtml = b.ToString();
                lblBanks.Attributes["data-target"] = b.ToString();

                lblClients.InnerHtml = c.ToString();
                lblClients.Attributes["data-target"] = c.ToString();

                lblUptime.InnerHtml = "99.9";
                lblUptime.Attributes["data-target"] = "99.9";
            }
        }
        catch
        {
            lblTransactions.InnerHtml = "ERR";
            lblBanks.InnerHtml = "ERR";
            lblClients.InnerHtml = "ERR";
        }
    }

    //  LOGIN METHOD
    [WebMethod]
    public static object Loginadmin(string userid, string password)
    {
        var admin = AdminAuth.Login(userid, password);

        if ((bool)admin.GetType().GetProperty("success").GetValue(admin))
            return admin;

        return BankUserAuth.Login(userid, password);
    }

    //  LOCATION SAVE
    [WebMethod]
    public static string SaveLocation(double latitude, double longitude)
    {
        try
        {
            using (SqlConnection con = new SqlConnection(conStr))
            {
                con.Open();

                SqlCommand cmd = new SqlCommand(
                    @"INSERT INTO UserLocation (UserID, Latitude, Longitude, CreatedDate) 
                      VALUES (@uid, @lat, @lng, GETDATE())", con);

                object userId = HttpContext.Current.Session["UserID"];

                if (userId == null)
                    return "Session expired";

                cmd.Parameters.AddWithValue("@uid", userId);
                cmd.Parameters.AddWithValue("@lat", latitude);
                cmd.Parameters.AddWithValue("@lng", longitude);

                cmd.ExecuteNonQuery();
            }

            return "Success";
        }
        catch (Exception ex)
        {
            return ex.Message;
        }
    }
}