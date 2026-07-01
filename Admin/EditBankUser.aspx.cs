using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Security.Cryptography;
using System.Text;

public partial class Admin_EditBankUser : System.Web.UI.Page
{
    string conStr = ConfigurationManager.ConnectionStrings["CMSDBConnection"].ConnectionString;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            LoadBanks();

            if (Request.QueryString["id"] != null)
            {
                int userId = Convert.ToInt32(Request.QueryString["id"]);
                hdUserID.Value = userId.ToString();
                LoadUser(userId);
            }
        }
    }

    void LoadBanks()
    {
        using (SqlConnection con = new SqlConnection(conStr))
        {
            SqlCommand cmd = new SqlCommand(
            "SELECT BankID, BankName FROM Banks WHERE Status=1", con);

            con.Open();
            ddlBank.DataSource = cmd.ExecuteReader();
            ddlBank.DataTextField = "BankName";
            ddlBank.DataValueField = "BankID";
            ddlBank.DataBind();
        }
    }

    void LoadUser(int userId)
    {
        using (SqlConnection con = new SqlConnection(conStr))
        {
            SqlCommand cmd = new SqlCommand(
            "SELECT * FROM BankUsers WHERE UserID=@id", con);

            cmd.Parameters.AddWithValue("@id", userId);

            con.Open();
            SqlDataReader dr = cmd.ExecuteReader();

            if (dr.Read())
            {
                txtUsername.Text = dr["Username"].ToString();
                txtEmail.Text = dr["Email"].ToString();
                txtPhone.Text = dr["Phone"].ToString();
                ddlBank.SelectedValue = dr["BankID"].ToString();
                ddlStatus.SelectedValue = Convert.ToBoolean(dr["IsActive"]) ? "1" : "0";
            }
        }
    }

    protected void btnUpdate_Click(object sender, EventArgs e)
    {
        int userId = Convert.ToInt32(hdUserID.Value);

        using (SqlConnection con = new SqlConnection(conStr))
        {
            con.Open();

            string query = @"
            UPDATE BankUsers
            SET Email=@e,
                Phone=@p,
                BankID=@bank,
                IsActive=@status";

            // 🔐 password change optional
            if (!string.IsNullOrWhiteSpace(txtPassword.Text))
            {
                query += ", Password=@pass";
            }

            query += " WHERE UserID=@id";

            SqlCommand cmd = new SqlCommand(query, con);

            cmd.Parameters.AddWithValue("@e", txtEmail.Text.Trim());
            cmd.Parameters.AddWithValue("@p", txtPhone.Text.Trim());
            cmd.Parameters.AddWithValue("@bank", ddlBank.SelectedValue);
            cmd.Parameters.AddWithValue("@status", ddlStatus.SelectedValue);
            cmd.Parameters.AddWithValue("@id", userId);

            if (!string.IsNullOrWhiteSpace(txtPassword.Text))
            {
                cmd.Parameters.AddWithValue("@pass", GetMD5(txtPassword.Text));
            }

            cmd.ExecuteNonQuery();
        }

        Response.Write("<script>alert('User Updated Successfully');window.location='BankUserList.aspx';</script>");
    }

    // 🔐 MD5 HASH
    public static string GetMD5(string input)
    {
        using (MD5 md5 = MD5.Create())
        {
            byte[] bytes = md5.ComputeHash(Encoding.UTF8.GetBytes(input));
            StringBuilder sb = new StringBuilder();

            foreach (byte b in bytes)
                sb.Append(b.ToString("x2"));

            return sb.ToString();
        }
    }
}