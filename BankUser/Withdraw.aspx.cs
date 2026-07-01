using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Web.UI;

public partial class BankUser_Withdraw : System.Web.UI.Page
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
            LoadBalance();
            LoadHistory();
        }

        if (Session["SuccessMsg"] != null)
        {
            string msg = Session["SuccessMsg"].ToString();
            Session.Remove("SuccessMsg");

            string script = $@"
Swal.fire({{
    icon: 'success',
    title: 'Success',
    text: '{msg}',
    timer: 1500,
    showConfirmButton: false
}});";

            ClientScript.RegisterStartupScript(this.GetType(), "success", script, true);
        }
    }

    // ✅ LOAD WALLET BALANCE
    void LoadBalance()
    {
        int bankId = Convert.ToInt32(Session["BankID"]);

        using (SqlConnection con = new SqlConnection(conStr))
        {
            SqlCommand cmd = new SqlCommand(@"
        SELECT ISNULL(AvailableBalance,0)
        FROM BankWallet
        WHERE BankID=@BankID", con);

            cmd.Parameters.AddWithValue("@BankID", bankId);

            con.Open();

            decimal balance = Convert.ToDecimal(cmd.ExecuteScalar());

            lblBalance.Text = "₹ " + balance.ToString("N2");
        }
    }

    // ✅ WITHDRAW REQUEST (NO WALLET DEDUCTION)
    protected void btnRequest_Click(object sender, EventArgs e)
    {
        int bankId = Convert.ToInt32(Session["BankID"]);

        using (SqlConnection con = new SqlConnection(conStr))
        {
            con.Open();
            SqlTransaction tran = con.BeginTransaction();

            try
            {
                // 🔥 GET FULL AVAILABLE BALANCE
                SqlCommand chk = new SqlCommand(@"
            SELECT ISNULL(AvailableBalance,0)
            FROM BankWallet
            WHERE BankID=@BankID", con, tran);

                chk.Parameters.AddWithValue("@BankID", bankId);

                decimal balance = Convert.ToDecimal(chk.ExecuteScalar());

                if (balance <= 0)
                {
                    tran.Rollback();
                    ShowWarning("No balance to withdraw");
                    return;
                }

                // 🔥 INSERT FULL AMOUNT REQUEST
                SqlCommand cmd = new SqlCommand(@"
            INSERT INTO WithdrawalRequest (BankID, Amount, Status, RequestDate)
            VALUES (@BankID, @Amount, 'PENDING', GETDATE())", con, tran);

                cmd.Parameters.AddWithValue("@BankID", bankId);
                cmd.Parameters.AddWithValue("@Amount", balance);

                cmd.ExecuteNonQuery();

                tran.Commit();

                LoadBalance();
                LoadHistory();

                ShowSuccess("Request Sent", "Full amount withdrawal requested");
            }
            catch (Exception ex)
            {
                try { tran.Rollback(); } catch { }
                ShowError("Error: " + ex.Message);
            }
        }
    }

    // ✅ POPUPS
    void ShowSuccess(string title, string message)
    {
        string script = $@"
    Swal.fire({{
        icon: 'success',
        title: '{title}',
        text: '{message}'
    }});";

        ClientScript.RegisterStartupScript(this.GetType(), Guid.NewGuid().ToString(), script, true);
    }

    void ShowError(string message)
    {
        string script = $@"
    Swal.fire({{
        icon: 'error',
        title: 'Error',
        text: '{message}'
    }});";

        ClientScript.RegisterStartupScript(this.GetType(), Guid.NewGuid().ToString(), script, true);
    }

    void ShowWarning(string message)
    {
        string script = $@"
    Swal.fire({{
        icon: 'warning',
        title: '{message}'
    }});";

        ClientScript.RegisterStartupScript(this.GetType(), Guid.NewGuid().ToString(), script, true);
    }

    // ✅ HISTORY GRID
    void LoadHistory()
    {
        int bankId = Convert.ToInt32(Session["BankID"]);

        using (SqlConnection con = new SqlConnection(conStr))
        {
            SqlDataAdapter da = new SqlDataAdapter(@"
            SELECT 
                Id,
                Amount,
                Status,
                ISNULL(UTRNumber,'-') AS UTRNumber,
                RequestDate,
                ApprovedDate
            FROM WithdrawalRequest
            WHERE BankID=@BankID
            ORDER BY Id DESC", con);

            da.SelectCommand.Parameters.AddWithValue("@BankID", bankId);

            System.Data.DataTable dt = new System.Data.DataTable();
            da.Fill(dt);

            gvHistory.DataSource = dt;
            gvHistory.DataBind();
        }
    }
}