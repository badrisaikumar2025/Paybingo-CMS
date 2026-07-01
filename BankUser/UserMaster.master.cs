using System;
using System.Configuration;
using System.Data.SqlClient;

public partial class UserMaster : System.Web.UI.MasterPage
{
    string conStr = ConfigurationManager.ConnectionStrings["CMSDBConnection"].ConnectionString;

    protected void Page_Load(object sender, EventArgs e)
    {
        // 🔥 FIXED SESSION CHECK
        if (Session["UserID"] == null || Session["BankID"] == null)
        {
            Response.Redirect("~/Home.aspx");
            return;
        }

        if (Session["BankID"] != null)
        {
            int bankId = Convert.ToInt32(Session["BankID"]);

            using (SqlConnection con = new SqlConnection(conStr))
            {
                con.Open();

                // Bank Name
                SqlCommand cmd = new SqlCommand("SELECT BankName FROM Banks WHERE BankID=@id", con);
                cmd.Parameters.AddWithValue("@id", bankId);
                object bankName = cmd.ExecuteScalar();

                // 🔥 ADD BALANCE
                SqlCommand balCmd = new SqlCommand("SELECT Balance FROM BankWallet WHERE BankID=@id", con);
                balCmd.Parameters.AddWithValue("@id", bankId);
                object balance = balCmd.ExecuteScalar();

                if (bankName != null && balance != null)
                {
                    lblUser.Text = "Welcome " + bankName.ToString() +
                                   " | ₹ " + Convert.ToDecimal(balance).ToString("N2");
                }
            }
        }
        else
        {
            lblUser.Text = "Welcome Admin " + Session["UserID"];
        }
    }
}