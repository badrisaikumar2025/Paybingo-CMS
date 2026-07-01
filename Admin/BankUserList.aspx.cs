using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

public partial class Admin_BankUserList : System.Web.UI.Page
{
    string conStr = ConfigurationManager.ConnectionStrings["CMSDBConnection"].ConnectionString;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            LoadBankUsers();
        }
    }

    void LoadBankUsers()
    {
        using (SqlConnection con = new SqlConnection(conStr))
        {
            SqlCommand cmd = new SqlCommand(@"
            SELECT 
                UserID,
                Username,
                FullName,
                Email,
                Phone,
                IsActive,
                CreateDate
                FROM BankUsers
                ORDER BY UserID DESC", con);

            SqlDataAdapter da = new SqlDataAdapter(cmd);
            DataTable dt = new DataTable();
            da.Fill(dt);

            gvBankUsers.DataSource = dt;
            gvBankUsers.DataBind();
        }
    }

    protected void gvBankUsers_RowCommand(object sender, System.Web.UI.WebControls.GridViewCommandEventArgs e)
    {
        int userId = Convert.ToInt32(e.CommandArgument);

        using (SqlConnection con = new SqlConnection(conStr))
        {
            con.Open();

            // BLOCK / ACTIVATE
            if (e.CommandName == "Toggle")
            {
                SqlCommand cmd = new SqlCommand(@"
                UPDATE BankUsers
                SET IsActive = CASE WHEN IsActive = 1 THEN 0 ELSE 1 END
                WHERE UserID = @id", con);

                cmd.Parameters.AddWithValue("@id", userId);
                cmd.ExecuteNonQuery();
            }

            //  DELETE
            else if (e.CommandName == "DeleteUser")
            {
                SqlCommand cmd = new SqlCommand(
                "DELETE FROM BankUsers WHERE UserID=@id", con);

                cmd.Parameters.AddWithValue("@id", userId);
                cmd.ExecuteNonQuery();
            }

            //  EDIT REDIRECT
            else if (e.CommandName == "EditUser")
            {
                Response.Redirect("~/Admin/EditBankUser.aspx?id=" + userId);
            }
        }
        

        LoadBankUsers();
    }
}