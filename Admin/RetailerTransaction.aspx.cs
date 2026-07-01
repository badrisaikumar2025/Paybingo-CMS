using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

public partial class Admin_RetailerTransaction : System.Web.UI.Page
{
    string conStr = ConfigurationManager.ConnectionStrings["CMSDBConnection"].ConnectionString;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            LoadBanks();
        }
    }

    void LoadBanks()
    {
        using (SqlConnection con = new SqlConnection(conStr))
        {
            SqlCommand cmd = new SqlCommand("SELECT BankID, BankName FROM Banks WHERE Status=1", con);
            con.Open();

            SqlDataReader dr = cmd.ExecuteReader();

            ddlBank.DataSource = dr;
            ddlBank.DataTextField = "BankName";
            ddlBank.DataValueField = "BankID";
            ddlBank.DataBind();

            ddlBank.Items.Insert(0, new System.Web.UI.WebControls.ListItem("--Select Bank--", "0"));
        }
    }

    protected void btnSend_Click(object sender, EventArgs e)
    {
        try
        {
            if (string.IsNullOrWhiteSpace(txtRetailer.Text) ||
                string.IsNullOrWhiteSpace(txtMobile.Text) ||
                string.IsNullOrWhiteSpace(txtAmount.Text))
            {
                ShowAlert("Fill all fields");
                return;
            }

            if (ddlBank.SelectedValue == "0")
            {
                ShowAlert("Select Bank");
                return;
            }

            if (!decimal.TryParse(txtAmount.Text, out decimal amount))
            {
                ShowAlert("Invalid amount");
                return;
            }

            int bankId = Convert.ToInt32(ddlBank.SelectedValue);

            using (SqlConnection con = new SqlConnection(conStr))
            {
                using (SqlCommand cmd = new SqlCommand("sp_InsertTransaction", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.AddWithValue("@mobile", txtMobile.Text.Trim());
                    cmd.Parameters.AddWithValue("@amount", amount);
                    cmd.Parameters.AddWithValue("@bankId", bankId);
                    

                    con.Open();
                    cmd.ExecuteNonQuery(); //  FIXED

                    ShowAlert("Transaction Success ✅");
                    ClearFields();
                }
            }
        }
        catch (Exception ex)
        {
            ShowAlert(ex.Message); // show real error
        }
    }

    void ClearFields()
    {
        txtRetailer.Text = "";
        txtMobile.Text = "";
        txtAmount.Text = "";
        txtBranch.Text = "";
        ddlBank.SelectedIndex = 0;
    }

    void ShowAlert(string msg)
    {
        ClientScript.RegisterStartupScript(this.GetType(), "alert",
            "alert('" + msg + "');", true);
    }
}