using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

public partial class BankUser_SettlementHistory : System.Web.UI.Page
{
    string conStr = ConfigurationManager.ConnectionStrings["CMSDBConnection"].ConnectionString;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["BankID"] == null)
        {
            Response.Redirect("~/Home.aspx");
            return;
        }

        if (!IsPostBack)
        {
            LoadHistory();
        }
    }

    void LoadHistory()
    {
        int bankId = Convert.ToInt32(Session["BankID"]);

        using (SqlConnection con = new SqlConnection(conStr))
        {
            SqlCommand cmd = new SqlCommand(@"
    SELECT 
    Amount,
    Status,
    ISNULL(UTRNumber,'-') AS UTRNumber,
    RequestDate AS RequestedDate,
    ApprovedDate
    FROM WithdrawalRequest
    WHERE BankID=@BankID
    AND (@From IS NULL OR RequestDate >= @From)
    AND (@To IS NULL OR RequestDate < @To)
    AND (@Status = '' OR Status = @Status)
    ORDER BY Id DESC", con);

            cmd.Parameters.AddWithValue("@BankID", bankId);

            cmd.Parameters.AddWithValue("@From",
                string.IsNullOrEmpty(txtFrom.Text)
                ? (object)DBNull.Value
                : DateTime.Parse(txtFrom.Text));

            cmd.Parameters.AddWithValue("@To",
                string.IsNullOrEmpty(txtTo.Text)
                ? (object)DBNull.Value
                : DateTime.Parse(txtTo.Text).AddDays(1));

            cmd.Parameters.AddWithValue("@Status", ddlStatus.SelectedValue);

            SqlDataAdapter da = new SqlDataAdapter(cmd);
            DataTable dt = new DataTable();
            da.Fill(dt);

            gvHistory.DataSource = dt;
            gvHistory.DataBind();
        }
    }

    protected void btnSearch_Click(object sender, EventArgs e)
    {
        LoadHistory();
    }

    //  STATUS BADGE
    public string GetStatusBadge(string status)
    {
        status = status.ToUpper();

        if (status == "PAID")
            return "<span class='badge bg-success'>Paid</span>";

        if (status == "APPROVED")
            return "<span class='badge bg-primary'>Approved</span>";

        if (status == "FAILED")
            return "<span class='badge bg-danger'>Failed</span>";

        return "<span class='badge bg-warning text-dark'>Pending</span>";
    }
}