using System;

public partial class Admin_AdminMaster : System.Web.UI.MasterPage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        // Prevent browser cache (important for security)
        Response.Cache.SetCacheability(System.Web.HttpCacheability.NoCache);
        Response.Cache.SetNoStore();
        Response.Cache.SetExpires(DateTime.UtcNow.AddMinutes(-1));

        // Session security check
        if (Session["UserType"] == null || Session["UserID"] == null)
        {
            Response.Redirect("../Home.aspx");
            return;
        }

        // Allow only Admin
        if (Session["UserType"].ToString() != "Admin")
        {
            Response.Redirect("../Home.aspx");
            return;
        }

        // Show admin name
        if (!IsPostBack)
        {
            if (Session["AdminName"] != null)
            {
                lblUser.Text = Session["AdminName"].ToString();
            }
        }
    }
}