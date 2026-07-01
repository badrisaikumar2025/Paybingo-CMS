using iTextSharp.text;
using iTextSharp.text.pdf;
using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Web.UI;

public partial class Admin_Reports : System.Web.UI.Page
{
    string conStr = ConfigurationManager.ConnectionStrings["CMSDBConnection"].ConnectionString;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            LoadReports();
        }
    }

    // LOAD ALL REPORTS (WITH BANK NAME)
    void LoadReports()
    {
        using (SqlConnection con = new SqlConnection(conStr))
        {
            SqlCommand cmd = new SqlCommand("sp_AdminReports", con);
            cmd.CommandType = CommandType.StoredProcedure;

            SqlDataAdapter da = new SqlDataAdapter(cmd);
            DataTable dt = new DataTable();
            da.Fill(dt);

            gvReport.DataSource = dt;
            gvReport.DataBind();
        }
    }

    //  FILTER REPORTS (WITH BANK NAME)
    protected void btnFilter_Click(object sender, EventArgs e)
    {
        using (SqlConnection con = new SqlConnection(conStr))
        {
            DateTime fromDate, toDate;

            // Convert safely
            DateTime.TryParse(txtFromDate.Text, out fromDate);
            DateTime.TryParse(txtToDate.Text, out toDate);

            SqlCommand cmd = new SqlCommand(@"
            SELECT 
            t.txn_id,
            t.mobile,
            b.BankName,
            t.amount,
            t.status,
            t.created_on
            FROM Transactions t
            LEFT JOIN Banks b ON t.BankID = b.BankID
            WHERE t.created_on BETWEEN @from AND @to
            ORDER BY t.created_on DESC", con);

            cmd.Parameters.AddWithValue("@from", fromDate);
            cmd.Parameters.AddWithValue("@to", toDate);

            SqlDataAdapter da = new SqlDataAdapter(cmd);
            DataTable dt = new DataTable();
            da.Fill(dt);

            gvReport.DataSource = dt;
            gvReport.DataBind();
        }
    }

    // ✅ EXPORT TO EXCEL (WITH BANK NAME)
    protected void btnExport_Click(object sender, EventArgs e)
    {
        Response.Clear();
        Response.Buffer = true;
        Response.AddHeader("content-disposition", "attachment;filename=Report.xls");
        Response.Charset = "";
        Response.ContentType = "application/vnd.ms-excel";

        gvReport.AllowPaging = false;
        LoadReports(); // reload full data

        StringWriter sw = new StringWriter();
        HtmlTextWriter hw = new HtmlTextWriter(sw);

        gvReport.RenderControl(hw);

        Response.Write(sw.ToString());
        Response.End();
    }

    public override void VerifyRenderingInServerForm(Control control)
    {
        // Required for export
    }
}