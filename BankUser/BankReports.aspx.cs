using iText.Kernel.Pdf;
using iText.Layout;
using iText.Layout.Element;
using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class BankReports : System.Web.UI.Page
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
            LoadReport();
        }
    }

    void LoadReport()
    {
        using (SqlConnection con = new SqlConnection(conStr))
        {
            SqlCommand cmd = new SqlCommand(@"
            SELECT txn_id, mobile, amount, status, created_on
            FROM Transactions
            WHERE BankID=@BankID
            AND (@From IS NULL OR created_on >= @From)
            AND (@To IS NULL OR created_on < @To)
            AND (@Status = '' OR status = @Status)
            AND (@Search = '' OR mobile LIKE '%' + @Search + '%')
            ORDER BY created_on DESC", con);

            cmd.Parameters.AddWithValue("@BankID", Session["BankID"]);

            cmd.Parameters.AddWithValue("@From",
                string.IsNullOrEmpty(txtFrom.Text) ? (object)DBNull.Value : DateTime.Parse(txtFrom.Text));

            cmd.Parameters.AddWithValue("@To",
                string.IsNullOrEmpty(txtTo.Text) ? (object)DBNull.Value : DateTime.Parse(txtTo.Text).AddDays(1));

            cmd.Parameters.AddWithValue("@Status", ddlStatus.SelectedValue);
            cmd.Parameters.AddWithValue("@Search", txtSearch.Text);

            SqlDataAdapter da = new SqlDataAdapter(cmd);
            DataTable dt = new DataTable();
            da.Fill(dt);

            gvReport.DataSource = dt;
            gvReport.DataBind();
        }
    }

    protected void btnSearch_Click(object sender, EventArgs e)
    {
        LoadReport();
    }

    // ✅ STATUS BADGE
    public string GetStatusBadge(string status)
    {
        status = status.ToUpper();

        if (status == "SUCCESS")
            return "<span class='badge bg-success'>Success</span>";

        if (status == "SETTLED")
            return "<span class='badge bg-primary'>Settled</span>";

        if (status == "FAILED")
            return "<span class='badge bg-danger'>Failed</span>";

        return "<span class='badge bg-warning text-dark'>Processing</span>";
    }

    // ✅ EXCEL EXPORT
    protected void btnExcel_Click(object sender, EventArgs e)
    {
        Response.Clear();
        Response.AddHeader("content-disposition", "attachment;filename=BankReport.xls");
        Response.ContentType = "application/vnd.ms-excel";

        StringWriter sw = new StringWriter();
        HtmlTextWriter hw = new HtmlTextWriter(sw);

        gvReport.RenderControl(hw);
        Response.Write(sw.ToString());
        Response.End();
    }

    // ⚠️ SIMPLE PDF (HTML)
    protected void btnPDF_Click(object sender, EventArgs e)
    {
        using (MemoryStream ms = new MemoryStream())
        {
            PdfWriter writer = new PdfWriter(ms);
            PdfDocument pdf = new PdfDocument(writer);
            Document doc = new Document(pdf);

            // Title
            doc.Add(new Paragraph("Bank Report").SetFontSize(14));

            // Table
            iText.Layout.Element.Table table = new iText.Layout.Element.Table(5);

            table.AddHeaderCell("Txn ID");
            table.AddHeaderCell("Mobile");
            table.AddHeaderCell("Amount");
            table.AddHeaderCell("Status");
            table.AddHeaderCell("Date");

            foreach (GridViewRow row in gvReport.Rows)
            {
                table.AddCell(row.Cells[0].Text);
                table.AddCell(row.Cells[1].Text);
                table.AddCell(row.Cells[2].Text);
                table.AddCell(row.Cells[3].Text);
                table.AddCell(row.Cells[4].Text);
            }

            doc.Add(table);
            doc.Close();

            Response.Clear();
            Response.ContentType = "application/pdf";
            Response.AddHeader("content-disposition", "attachment;filename=BankReport.pdf");
            Response.BinaryWrite(ms.ToArray());
            Response.End();
        }
    }

    public override void VerifyRenderingInServerForm(Control control)
    {
    }
}