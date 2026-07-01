using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Web.Services;

public partial class API_ReceiveTransaction : System.Web.UI.Page
{
    static string conStr = ConfigurationManager.ConnectionStrings["CMSDBConnection"].ConnectionString;

    [WebMethod]
    public static object SendTransaction(string retailerId, string mobile, decimal amount, string ifsc)
    {
        try
        {
            if (string.IsNullOrWhiteSpace(retailerId) ||
                string.IsNullOrWhiteSpace(mobile) ||
                string.IsNullOrWhiteSpace(ifsc) ||
                amount <= 0)
            {
                return new { success = false, message = "Invalid input" };
            }

            using (SqlConnection con = new SqlConnection(conStr))
            {
                con.Open();

                string prefix = ifsc.Substring(0, 4).ToUpper();

                // 🔥 Get Bank
                SqlCommand bankCmd = new SqlCommand(@"
                    SELECT TOP 1 BankID 
                    FROM Banks 
                    WHERE IFSCPrefix=@p AND Status=1", con);

                bankCmd.Parameters.AddWithValue("@p", prefix);

                object bankObj = bankCmd.ExecuteScalar();

                if (bankObj == null)
                    return new { success = false, message = "Invalid IFSC" };

                int bankId = Convert.ToInt32(bankObj);

                // CALL STORED PROCEDURE (MAIN LOGIC)
                SqlCommand cmd = new SqlCommand("sp_InsertTransaction", con);
                cmd.CommandType = System.Data.CommandType.StoredProcedure;

                cmd.Parameters.AddWithValue("@mobile", mobile);
                cmd.Parameters.AddWithValue("@amount", amount);
                cmd.Parameters.AddWithValue("@bankId", bankId);
                cmd.Parameters.AddWithValue("@retailer", retailerId);
                cmd.Parameters.AddWithValue("@ifsc", ifsc);

                cmd.ExecuteNonQuery();

                return new
                {
                    success = true,
                    message = "Transaction Success"
                };
            }
        }
        catch (Exception ex)
        {
            return new { success = false, message = ex.Message };
        }
    }
}