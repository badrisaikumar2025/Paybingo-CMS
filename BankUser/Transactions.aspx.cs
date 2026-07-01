using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

public partial class BankUser_Transactions : System.Web.UI.Page
{

    string conStr =
    ConfigurationManager.ConnectionStrings["CMSDBConnection"].ConnectionString;

    protected void Page_Load(object sender, EventArgs e)
    {

        if (Session["BankID"] == null)
        {
            Response.Redirect("~/Home.aspx");
        }

        if (!IsPostBack)
        {
            LoadTransactions();
        }

    }

    void LoadTransactions()
    {

        using (SqlConnection con = new SqlConnection(conStr))
        {

            SqlCommand cmd = new SqlCommand(@"
               SELECT
               txn_id,
               mobile,
               amount,
               status,
               created_on
               FROM Transactions
               WHERE BankID=@bank
               ORDER BY txn_id DESC", con);

            cmd.Parameters.AddWithValue("@bank", Session["BankID"]);

            SqlDataAdapter da = new SqlDataAdapter(cmd);

            DataTable dt = new DataTable();

            da.Fill(dt);

            gvTxn.DataSource = dt;
            gvTxn.DataBind();

        }

    }

}