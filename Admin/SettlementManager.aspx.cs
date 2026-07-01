using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI.WebControls;

public partial class SettlementManager : System.Web.UI.Page
{
    string conStr = ConfigurationManager.ConnectionStrings["CMSDBConnection"].ConnectionString;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["UserType"] == null || Session["UserID"] == null)
        {
            Response.Redirect("~/Home.aspx");
            return;
        }

        if (Session["UserType"].ToString() != "Admin")
        {
            Response.Redirect("~/Home.aspx");
            return;
        }

        if (!IsPostBack)
        {
            LoadRequests();
        }
    }

    void LoadRequests()
    {
        using (SqlConnection con = new SqlConnection(conStr))
        using (SqlCommand cmd = new SqlCommand("sp_GetPendingRequests", con))
        {
            cmd.CommandType = CommandType.StoredProcedure;

            SqlDataAdapter da = new SqlDataAdapter(cmd);
            DataTable dt = new DataTable();
            da.Fill(dt);

            gvRequests.DataSource = dt;
            gvRequests.DataBind();
        }
    }

    // APPROVE
    protected void Approve_Click(object sender, EventArgs e)
    {
        Button btn = (Button)sender;
        int requestId = Convert.ToInt32(btn.CommandArgument);

        GridViewRow row = (GridViewRow)btn.NamingContainer;
        TextBox txtUTR = (TextBox)row.FindControl("txtUTR");

        string utr = txtUTR.Text.Trim();

        if (string.IsNullOrEmpty(utr))
        {
            Response.Write("<script>alert('Enter UTR Number');</script>");
            return;
        }

        using (SqlConnection con = new SqlConnection(conStr))
        using (SqlCommand cmd = new SqlCommand("sp_ApproveSettlement", con))
        {
            cmd.CommandType = CommandType.StoredProcedure;

            cmd.Parameters.AddWithValue("@ID", requestId);
            cmd.Parameters.AddWithValue("@UTR", utr);

            con.Open();
            cmd.ExecuteNonQuery();
        }

        Response.Write("<script>alert('Settlement Approved');</script>");

        LoadRequests();
    }

    // REJECT
    protected void Reject_Click(object sender, EventArgs e)
    {
        int requestId = Convert.ToInt32(((Button)sender).CommandArgument);

        using (SqlConnection con = new SqlConnection(conStr))
        using (SqlCommand cmd = new SqlCommand("sp_RejectSettlement", con))
        {
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@RequestId", requestId);

            con.Open();
            cmd.ExecuteNonQuery();
        }

        Response.Write("<script>alert('Request Rejected');</script>");

        LoadRequests();
    }
}