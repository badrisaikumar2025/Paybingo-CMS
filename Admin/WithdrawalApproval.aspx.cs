using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Admin_WithdrawalApproval : System.Web.UI.Page
{
    string conStr = ConfigurationManager.ConnectionStrings["CMSDBConnection"].ConnectionString;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            LoadRequests();
        }
    }

    void LoadRequests()
    {
        using (SqlConnection con = new SqlConnection(conStr))
        {
            SqlDataAdapter da = new SqlDataAdapter(@"
            SELECT Id, BankID, Amount, Status, RequestDate
            FROM WithdrawalRequest
            ORDER BY RequestDate DESC", con);

            DataTable dt = new DataTable();
            da.Fill(dt);

            gvWithdraw.DataSource = dt;
            gvWithdraw.DataBind();
        }
    }

    protected void gvWithdraw_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        int requestId = Convert.ToInt32(e.CommandArgument);

        GridViewRow row = (GridViewRow)((Control)e.CommandSource).NamingContainer;
        TextBox txtUTR = (TextBox)row.FindControl("txtUTR");
        string utr = txtUTR.Text.Trim();

        using (SqlConnection con = new SqlConnection(conStr))
        {
            con.Open();

            // ✅ APPROVE
            if (e.CommandName == "Approve")
            {
                if (string.IsNullOrEmpty(utr))
                {
                    ShowWarning("Enter UTR number");
                    return;
                }

                SqlCommand update = new SqlCommand(@"
                UPDATE WithdrawalRequest
                SET Status='APPROVED',
                    UTRNumber=@utr,
                    ApprovedDate=GETDATE()
                WHERE Id=@id", con);

                update.Parameters.AddWithValue("@utr", utr);
                update.Parameters.AddWithValue("@id", requestId);
                update.ExecuteNonQuery();

                ShowSuccess("Approved", "Request approved successfully");
            }

            // ❌ REJECT
            if (e.CommandName == "Reject")
            {
                SqlCommand cmd = new SqlCommand(@"
                UPDATE WithdrawalRequest
                SET Status='REJECTED'
                WHERE Id=@id", con);

                cmd.Parameters.AddWithValue("@id", requestId);
                cmd.ExecuteNonQuery();

                ShowError("Request Rejected");
            }

           
            // ✅ PAID (FINAL FIXED LOGIC)
            if (e.CommandName == "Paid")
            {
                SqlTransaction tran = con.BeginTransaction();

                try
                {
                    SqlCommand getCmd = new SqlCommand(@"
        SELECT BankID, Amount, Status 
        FROM WithdrawalRequest 
        WHERE Id=@id", con, tran);

                    getCmd.Parameters.AddWithValue("@id", requestId);

                    SqlDataReader dr = getCmd.ExecuteReader();

                    int bankId = 0;
                    decimal amount = 0;
                    string status = "";

                    if (dr.Read())
                    {
                        bankId = Convert.ToInt32(dr["BankID"]);
                        amount = Convert.ToDecimal(dr["Amount"]);
                        status = dr["Status"].ToString();
                    }
                    dr.Close();

                    if (status == "PAID")
                    {
                        tran.Rollback();
                        ShowWarning("Already Paid");
                        return;
                    }

                    //  Check balance
                    SqlCommand chk = new SqlCommand(@"
        SELECT ISNULL(AvailableBalance,0)
        FROM BankWallet
        WHERE BankID=@bank", con, tran);

                    chk.Parameters.AddWithValue("@bank", bankId);

                    decimal balance = Convert.ToDecimal(chk.ExecuteScalar());

                    if (amount > balance)
                    {
                        tran.Rollback();
                        ShowError("Insufficient wallet balance");
                        return;
                    }

                    // ✅ 1. Update withdrawal status
                    SqlCommand update = new SqlCommand(@"
        UPDATE WithdrawalRequest
        SET Status='PAID'
        WHERE Id=@id", con, tran);

                    update.Parameters.AddWithValue("@id", requestId);
                    update.ExecuteNonQuery();

                    // ✅ 2. Deduct Bank Wallet
                    SqlCommand wallet = new SqlCommand(@"
        UPDATE BankWallet
        SET AvailableBalance = AvailableBalance - @amt
        WHERE BankID=@bank", con, tran);

                    wallet.Parameters.AddWithValue("@amt", amount);
                    wallet.Parameters.AddWithValue("@bank", bankId);
                    wallet.ExecuteNonQuery();

                    // ✅ 3. Deduct CMS Wallet
                    SqlCommand cms = new SqlCommand(@"
        UPDATE CMSWallet
        SET Balance = Balance - @amt,
            UpdatedOn = GETDATE()
        WHERE WalletID = 1", con, tran);

                    cms.Parameters.AddWithValue("@amt", amount);
                    cms.ExecuteNonQuery();

                    // 🔥 4. VERY IMPORTANT (FIX YOUR ISSUE)
                    // Move transactions → SETTLED
                    SqlCommand txn = new SqlCommand(@"
        UPDATE Transactions
        SET status = 'SETTLED'
        WHERE BankID=@bank AND status='SUCCESS'", con, tran);

                    txn.Parameters.AddWithValue("@bank", bankId);
                    txn.ExecuteNonQuery();

                    tran.Commit();

                    ShowSuccess("Payment Done", "Wallet deducted + settlement updated");
                }
                catch (Exception ex)
                {
                    tran.Rollback();
                    ShowError("Error: " + ex.Message);
                }
            }
        }

        LoadRequests();
    }

    // SUCCESS
    void ShowSuccess(string title, string message)
    {
        string script = $@"Swal.fire({{
            icon: 'success',
            title: '{title}',
            text: '{message}',
            timer: 1500,
            showConfirmButton: false
        }});";

        ScriptManager.RegisterStartupScript(this, GetType(), "success", script, true);
    }

    // ERROR
    void ShowError(string message)
    {
        string script = $@"Swal.fire({{
            icon: 'error',
            title: 'Error',
            text: '{message}'
        }});";

        ScriptManager.RegisterStartupScript(this, GetType(), "error", script, true);
    }

    // WARNING
    void ShowWarning(string message)
    {
        string script = $@"Swal.fire({{
            icon: 'warning',
            title: '{message}',
            timer: 1500,
            showConfirmButton: false
        }});";

        ScriptManager.RegisterStartupScript(this, GetType(), "warn", script, true);
    }
}