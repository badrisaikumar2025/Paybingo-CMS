using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

public partial class Admin_AdminWallet : System.Web.UI.Page
{
    string conStr = ConfigurationManager.ConnectionStrings["CMSDBConnection"].ConnectionString;


protected void Page_Load(object sender, EventArgs e)
    {
        // 🔒 ADMIN SECURITY
        if (Session["UserType"] == null || Session["UserType"].ToString() != "Admin")
        {
            Response.Redirect("~/Home.aspx");
            return;
        }

        if (!IsPostBack)
        {
            EnsureWalletExists();
            LoadWallet();
            LoadHistory();
        }
    }

    //  Ensure Wallet Exists
    void EnsureWalletExists()
    {
        using (SqlConnection con = new SqlConnection(conStr))
        {
            con.Open();

            SqlCommand cmd = new SqlCommand(@"
        IF NOT EXISTS (SELECT 1 FROM CMSWallet WHERE WalletID = 1)
        BEGIN
            INSERT INTO CMSWallet (WalletID, Balance, UpdatedOn)
            VALUES (1, 0, GETDATE())
        END", con);

            cmd.ExecuteNonQuery();
        }
    }
    // LOAD BALANCE
    void LoadWallet()
    {
        using (SqlConnection con = new SqlConnection(conStr))
        {
            con.Open();

            SqlCommand cmd = new SqlCommand(
                "SELECT ISNULL(Balance,0) FROM CMSWallet WHERE WalletID = 1", con);

            decimal bal = Convert.ToDecimal(cmd.ExecuteScalar());

            lblWalletBalance.Text = "₹ " + bal.ToString("N2");
        }
    }

    // ✅ AJAX BALANCE
    [System.Web.Services.WebMethod]
    public static decimal GetBalance()
    {
        string conStr = ConfigurationManager.ConnectionStrings["CMSDBConnection"].ConnectionString;

        using (SqlConnection con = new SqlConnection(conStr))
        {
            con.Open();

            SqlCommand cmd = new SqlCommand(
                "SELECT ISNULL(Balance,0) FROM CMSWallet WHERE WalletID=1", con);

            return Convert.ToDecimal(cmd.ExecuteScalar());
        }
    }

    //  LOAD HISTORY
    void LoadHistory()
    {
        using (SqlConnection con = new SqlConnection(conStr))
        {
            SqlDataAdapter da = new SqlDataAdapter(@"
SELECT txn_id, type, amount, created_on 
FROM CMSWalletTxn 
ORDER BY created_on DESC", con);

            DataTable dt = new DataTable();
            da.Fill(dt);

            gvWallet.DataSource = dt;
            gvWallet.DataBind();
        }
    }

    //  ADD MONEY
    protected void btnAdd_Click(object sender, EventArgs e)
    {
        if (!decimal.TryParse(txtAmount.Text, out decimal amt) || amt <= 0)
        {
            ShowAlert("Enter valid amount");
            return;
        }

        using (SqlConnection con = new SqlConnection(conStr))
        {
            con.Open();
            SqlTransaction tran = con.BeginTransaction();

            try
            {
                // Update balance
                SqlCommand cmd = new SqlCommand(@"
                UPDATE CMSWallet 
                SET Balance = Balance + @amt, UpdatedOn = GETDATE() 
                WHERE WalletID = 1", con, tran);

                cmd.Parameters.AddWithValue("@amt", amt);
                cmd.ExecuteNonQuery();

                // Log entry
                SqlCommand log = new SqlCommand(@"
                INSERT INTO CMSWalletTxn(wallet_id,type,amount,RefTxn,created_on)
                VALUES(1,'CREDIT',@amt,'ADMIN_ADD',GETDATE())", con, tran);

                log.Parameters.AddWithValue("@amt", amt);
                log.ExecuteNonQuery();

                tran.Commit();

                ShowAlert("Money Added Successfully ✅");
            }
            catch (Exception ex)
            {
                tran.Rollback();
                ShowAlert("Error: " + ex.Message);
            }
        }

        txtAmount.Text = "";
        LoadWallet();
        LoadHistory();
    }

    //  WITHDRAW MONEY
    protected void btnWithdraw_Click(object sender, EventArgs e)
    {
        if (!decimal.TryParse(txtWithdraw.Text, out decimal amt) || amt <= 0)
        {
            ShowAlert("Enter valid amount");
            return;
        }

        using (SqlConnection con = new SqlConnection(conStr))
        {
            con.Open();
            SqlTransaction tran = con.BeginTransaction();

            try
            {
                SqlCommand check = new SqlCommand(
                    "SELECT ISNULL(Balance,0) FROM CMSWallet WHERE WalletID=1",
                    con, tran);

                decimal balance = Convert.ToDecimal(check.ExecuteScalar());

                if (amt > balance)
                {
                    tran.Rollback();
                    ShowAlert("Insufficient Balance ❌");
                    return;
                }

                // Update balance
                SqlCommand cmd = new SqlCommand(@"
                UPDATE CMSWallet 
                SET Balance = Balance - @amt, UpdatedOn = GETDATE() 
                WHERE WalletID = 1", con, tran);

                cmd.Parameters.AddWithValue("@amt", amt);
                cmd.ExecuteNonQuery();

                // Log entry
                SqlCommand log = new SqlCommand(@"
                INSERT INTO CMSWalletTxn(wallet_id,type,amount,RefTxn,created_on)
                VALUES(1,'DEBIT',@amt,'ADMIN_WITHDRAW',GETDATE())", con, tran);

                log.Parameters.AddWithValue("@amt", amt);
                log.ExecuteNonQuery();

                tran.Commit();

                ShowAlert("Money Withdrawn Successfully ✅");
            }
            catch (Exception ex)
            {
                tran.Rollback();
                ShowAlert("Error: " + ex.Message);
            }
        }

        txtWithdraw.Text = "";
        LoadWallet();
        LoadHistory();
    }

    //  SWEET ALERT
    void ShowAlert(string msg)
    {
        ClientScript.RegisterStartupScript(this.GetType(), "alert",
            "Swal.fire('Info', '" + msg + "', 'info');", true);
    }


}
