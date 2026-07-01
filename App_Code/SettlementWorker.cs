using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Threading;

public class SettlementWorker
{

    static string conStr =
    ConfigurationManager.ConnectionStrings["CMSDBConnection"].ConnectionString;

    public static void Start()
    {

        Thread worker = new Thread(() =>
        {

            while (true)
            {

                try
                {

                    using (SqlConnection con = new SqlConnection(conStr))
                    {

                        SqlCommand cmd =
                        new SqlCommand("sp_SettleTransactions", con);

                        cmd.CommandType =
                        System.Data.CommandType.StoredProcedure;

                        con.Open();

                        cmd.ExecuteNonQuery();

                    }

                }
                catch { }

                Thread.Sleep(60000); // run every 1 seconds

            }

        });

        worker.IsBackground = true;
        worker.Start();

    }

}