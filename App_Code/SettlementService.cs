using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Net;
using System.IO;
using System.Text;

public class SettlementService
{
    static string conStr = ConfigurationManager.ConnectionStrings["CMSDBConnection"].ConnectionString;

    public static void ProcessBankSettlement()
    {
        using (SqlConnection con = new SqlConnection(conStr))
        {
            con.Open();

            SqlCommand cmd = new SqlCommand(@"
            SELECT txn_id, NetAmount, TxnRef, BankID
            FROM Transactions
            WHERE status = 'PROCESSING'", con);

            SqlDataReader dr = cmd.ExecuteReader();

            while (dr.Read())
            {
                int txnId = Convert.ToInt32(dr["txn_id"]);
                decimal amount = Convert.ToDecimal(dr["NetAmount"]);
                string txnRef = dr["TxnRef"].ToString();
                int bankId = Convert.ToInt32(dr["BankID"]);

                bool success = CallBankAPI(txnRef, amount, bankId);

                UpdateStatus(txnId, success);
            }
        }
    }

    static bool CallBankAPI(string txnRef, decimal amount, int bankId)
    {
        try
        {
            string url = "https://fakebankapi.com/transfer";

            string json = $"{{\"txnRef\":\"{txnRef}\",\"amount\":{amount}}}";

            HttpWebRequest req = (HttpWebRequest)WebRequest.Create(url);
            req.Method = "POST";
            req.ContentType = "application/json";

            byte[] data = Encoding.UTF8.GetBytes(json);
            req.ContentLength = data.Length;

            using (Stream stream = req.GetRequestStream())
            {
                stream.Write(data, 0, data.Length);
            }

            using (HttpWebResponse res = (HttpWebResponse)req.GetResponse())
            {
                return res.StatusCode == HttpStatusCode.OK;
            }
        }
        catch
        {
            return false;
        }
    }

    static void UpdateStatus(int txnId, bool success)
    {
        using (SqlConnection con = new SqlConnection(conStr))
        {
            con.Open();

            SqlCommand cmd = new SqlCommand(@"
            UPDATE Transactions
            SET 
                status = @status,
                bank_status = @bankstatus,
                settled_on = GETDATE()
            WHERE txn_id = @id", con);

            cmd.Parameters.AddWithValue("@id", txnId);

            if (success)
            {
                cmd.Parameters.AddWithValue("@status", "SETTLED");
                cmd.Parameters.AddWithValue("@bankstatus", "SUCCESS");
            }
            else
            {
                cmd.Parameters.AddWithValue("@status", "FAILED");
                cmd.Parameters.AddWithValue("@bankstatus", "FAILED");
            }

            cmd.ExecuteNonQuery();
        }
    }
}