using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web;
using System.Web.Services;

public partial class BankUser_BankDashboard : System.Web.UI.Page
{

    static string conStr =
    ConfigurationManager.ConnectionStrings["CMSDBConnection"].ConnectionString;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["BankID"] == null)
        {
            Response.Redirect("~/Home.aspx");
            return;
        }

        if (!IsPostBack)
        {
            LoadRecentTransactions();
            LoadSummary();
        }
    }

    /* 
       GET BANK ID SAFELY
     */

    int GetBankID()
    {
        if (Session["BankID"] == null)
            return 0;

        return Convert.ToInt32(Session["BankID"]);
    }

    /* 
       RECENT TRANSACTIONS
     */

    void LoadRecentTransactions()
    {

        int bankID = GetBankID();

        using (SqlConnection con = new SqlConnection(conStr))
        {

            SqlCommand cmd = new SqlCommand(@"
            SELECT TOP 20
            txn_id,
            mobile,
            amount,
            status,
            created_on
            FROM Transactions
            WHERE BankID = @bank
            ORDER BY txn_id DESC", con);

            cmd.Parameters.AddWithValue("@bank", bankID);

            SqlDataAdapter da = new SqlDataAdapter(cmd);

            DataTable dt = new DataTable();

            da.Fill(dt);

            gvTxn.DataSource = dt;
            gvTxn.DataBind();

        }

    }
    

    /* 
       SUMMARY CARDS
     */

    void LoadSummary()
    {

        int bankID = GetBankID();

        using (SqlConnection con = new SqlConnection(conStr))
        {

            SqlCommand cmd = new SqlCommand("sp_BankDashboardSummary", con);

            cmd.CommandType = CommandType.StoredProcedure;

            cmd.Parameters.AddWithValue("@BankID", bankID);

            con.Open();

            SqlDataReader dr = cmd.ExecuteReader();

            if (dr.Read())
            {

                decimal today = dr["today"] == DBNull.Value ? 0 : Convert.ToDecimal(dr["today"]);
                decimal yesterday = dr["yesterday"] == DBNull.Value ? 0 : Convert.ToDecimal(dr["yesterday"]);
                decimal month = dr["month"] == DBNull.Value ? 0 : Convert.ToDecimal(dr["month"]);
                decimal alltime = dr["alltime"] == DBNull.Value ? 0 : Convert.ToDecimal(dr["alltime"]);

                lblToday.Text = "₹ " + today.ToString("N2");
                lblYesterday.Text = "₹ " + yesterday.ToString("N2");
                lblMonth.Text = "₹ " + month.ToString("N2");
                lblAllTime.Text = "₹ " + alltime.ToString("N2");

            }

        }

    }

    /* 
       STATUS BADGE
     */

    public string GetStatusBadge(string status)
    {
        status = status.ToLower();

        if (status == "success")
            return "<span class='badge bg-primary'>COLLECTION</span>";

        if (status == "hold")
            return "<span class='badge bg-warning text-dark'>PROCESSING</span>";

        if (status == "settled")
            return "<span class='badge bg-success'>SETTLED</span>";

        if (status == "failed")
            return "<span class='badge bg-danger'>FAILED</span>";

        return status.ToUpper();
    }

    /* 
       KPI AJAX
     */

    [WebMethod(EnableSession = true)]
    public static object GetBankKPIs()
    {

        object sessionValue = HttpContext.Current.Session["BankID"];

        if (sessionValue == null)
        {
            return new { error = "SessionExpired" };
        }

        int bankID = Convert.ToInt32(sessionValue);

        using (SqlConnection con = new SqlConnection(conStr))
        {

            SqlCommand cmd = new SqlCommand("sp_BankDashboardKPIs", con);

            cmd.CommandType = CommandType.StoredProcedure;

            cmd.Parameters.AddWithValue("@BankID", bankID);

            con.Open();

            SqlDataReader dr = cmd.ExecuteReader();

            if (dr.Read())
            {

                return new
                {

                    collection = dr["collection"],
                    
                    settled = dr["settled"],
                    
                    
                    wallet = dr["wallet"]

                };

            }

        }

        return null;

    }




    /* 
       LIVE TRANSACTION FEED
     */

    [WebMethod(EnableSession = true)]
    public static object GetBankLiveTransactions()
    {
        int bankID = Convert.ToInt32(HttpContext.Current.Session["BankID"]);

        List<object> list = new List<object>();

        using (SqlConnection con = new SqlConnection(conStr))
        {
            SqlCommand cmd = new SqlCommand(@"
        SELECT TOP 10 mobile, amount, status
        FROM Transactions
        WHERE BankID=@bank
        ORDER BY txn_id DESC", con);

            cmd.Parameters.AddWithValue("@bank", bankID);

            con.Open();
            SqlDataReader dr = cmd.ExecuteReader();

            while (dr.Read())
            {
                list.Add(new
                {
                    mobile = dr["mobile"].ToString(),
                    amount = Convert.ToDecimal(dr["amount"]),
                    status = dr["status"].ToString()
                });
            }
        }

        return list; // ✅ clean JSON
    }

}