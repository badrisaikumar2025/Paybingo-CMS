using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI.WebControls;

public partial class Admin_AdminList : System.Web.UI.Page
{

    string conStr =
    ConfigurationManager.ConnectionStrings["CMSDBConnection"].ConnectionString;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            LoadAdmins();
        }
    }

    // LOAD ADMIN LIST

    void LoadAdmins()
    {

        using (SqlConnection con = new SqlConnection(conStr))
        {

            SqlCommand cmd = new SqlCommand(@"
            SELECT pkid,FullName,Email,Phone,IsActive,CreateDate
            FROM AdminUsers
            WHERE FullName LIKE @s OR Email LIKE @s OR Phone LIKE @s
            ORDER BY pkid DESC", con);

            cmd.Parameters.AddWithValue("@s", "%" + txtSearch.Text.Trim() + "%");

            SqlDataAdapter da = new SqlDataAdapter(cmd);

            DataTable dt = new DataTable();

            da.Fill(dt);

            gvAdmins.DataSource = dt;
            gvAdmins.DataBind();

        }

    }

    // SEARCH

    protected void btnSearch_Click(object sender, EventArgs e)
    {
        LoadAdmins();
    }

    // PAGINATION

    protected void gvAdmins_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        gvAdmins.PageIndex = e.NewPageIndex;
        LoadAdmins();
    }

    // ACTION BUTTONS

    protected void gvAdmins_RowCommand(object sender, GridViewCommandEventArgs e)
    {

        int id = Convert.ToInt32(e.CommandArgument);

        if (e.CommandName == "deleteAdmin")
        {
            DeleteAdmin(id);
        }

        if (e.CommandName == "toggleAdmin")
        {
            ToggleAdmin(id);
        }

        if (e.CommandName == "editAdmin")
        {
            Response.Redirect("CreateAdmin.aspx?id=" + id);
        }

        LoadAdmins();
    }

    // DELETE ADMIN

    void DeleteAdmin(int id)
    {

        using (SqlConnection con = new SqlConnection(conStr))
        {

            SqlCommand cmd =
            new SqlCommand("DELETE FROM AdminUsers WHERE pkid=@id", con);

            cmd.Parameters.AddWithValue("@id", id);

            con.Open();
            cmd.ExecuteNonQuery();

        }

    }

    // ACTIVATE / DEACTIVATE ADMIN

    void ToggleAdmin(int id)
    {

        using (SqlConnection con = new SqlConnection(conStr))
        {

            SqlCommand cmd = new SqlCommand(@"
            UPDATE AdminUsers
            SET IsActive = CASE WHEN IsActive=1 THEN 0 ELSE 1 END
            WHERE pkid=@id", con);

            cmd.Parameters.AddWithValue("@id", id);

            con.Open();
            cmd.ExecuteNonQuery();

        }

    }

}