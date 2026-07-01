using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

public partial class Admin_AdminTransactions : System.Web.UI.Page
{

    SqlConnection con = new SqlConnection(
        ConfigurationManager.ConnectionStrings["CMSDBConnection"].ConnectionString
    );

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            LoadTransactions();
        }
    }

    void LoadTransactions()
    {
        try
        {
            using (SqlConnection con = new SqlConnection(
                ConfigurationManager.ConnectionStrings["CMSDBConnection"].ConnectionString))
            {

                SqlCommand cmd = new SqlCommand("sp_GetAllTransactions", con);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlDataAdapter da = new SqlDataAdapter(cmd);

                DataTable dt = new DataTable();
                da.Fill(dt);

                gvTxn.DataSource = dt;
                gvTxn.DataBind();

            }
        }
        catch
        {
            Response.Write("<script>alert('Error loading transactions');</script>");
        }
    }

}