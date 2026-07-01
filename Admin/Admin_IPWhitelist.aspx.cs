using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

public partial class Admin_IPWhitelist : System.Web.UI.Page
{
    string conStr = ConfigurationManager.ConnectionStrings["CMSDBConnection"].ConnectionString;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            LoadIPs();
        }
    }

    // LOAD GRID
    void LoadIPs()
    {
        using (SqlConnection con = new SqlConnection(conStr))
        {
            SqlDataAdapter da = new SqlDataAdapter("SELECT * FROM UserIPWhitelist ORDER BY Id DESC", con);
            DataTable dt = new DataTable();
            da.Fill(dt);

            gvIPs.DataSource = dt;
            gvIPs.DataBind();
        }
    }

    // ADD IP
    protected void btnAddIP_Click(object sender, EventArgs e)
    {
        using (SqlConnection con = new SqlConnection(conStr))
        {
            string query = "INSERT INTO UserIPWhitelist (UserId, AllowedIP) VALUES (@UserId, @IP)";
            SqlCommand cmd = new SqlCommand(query, con);

            cmd.Parameters.AddWithValue("@UserId", txtUserId.Text.Trim());
            cmd.Parameters.AddWithValue("@IP", txtIP.Text.Trim());

            con.Open();
            cmd.ExecuteNonQuery();
        }

        txtUserId.Text = "";
        txtIP.Text = "";

        LoadIPs();
    }

    // ACTIONS (TOGGLE / DELETE)
    protected void gvIPs_RowCommand(object sender, System.Web.UI.WebControls.GridViewCommandEventArgs e)
    {
        int id = Convert.ToInt32(e.CommandArgument);

        using (SqlConnection con = new SqlConnection(conStr))
        {
            con.Open();

            if (e.CommandName == "Toggle")
            {
                string query = "UPDATE UserIPWhitelist SET IsActive = CASE WHEN IsActive=1 THEN 0 ELSE 1 END WHERE Id=@Id";
                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@Id", id);
                cmd.ExecuteNonQuery();
            }

            if (e.CommandName == "DeleteIP")
            {
                string query = "DELETE FROM UserIPWhitelist WHERE Id=@Id";
                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@Id", id);
                cmd.ExecuteNonQuery();
            }
        }

        LoadIPs();
    }
}