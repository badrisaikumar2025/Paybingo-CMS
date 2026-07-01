using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web;
using System.Web.Services;
using System.Diagnostics;

public partial class Admin_AdminDashboard : System.Web.UI.Page
{

    static string conStr =
    ConfigurationManager.ConnectionStrings["CMSDBConnection"].ConnectionString;

    protected void Page_Load(object sender, EventArgs e)
    {

        Response.Cache.SetCacheability(HttpCacheability.NoCache);
        Response.Cache.SetNoStore();
        Response.Cache.SetExpires(DateTime.UtcNow.AddMinutes(-1));
        //  ADMIN LOGIN CHECK 

        if (Session["UserType"] == null)
        {
            Response.Redirect("~/Home.aspx");
            return;
        }

        if (Session["UserType"].ToString() != "Admin")
        {
            Response.Redirect("~/Home.aspx");
            return;
        }

        if (!IsPostBack)
        {
            LoadSummary();
            LoadTransactions();
            
        }


    }


    // SUMMARY CARDS

    [WebMethod]
    public static object GetSystemHealth()
    {
        var cpu = new PerformanceCounter("Processor", "% Processor Time", "_Total");
        var ram = new PerformanceCounter("Memory", "% Committed Bytes In Use");

        float cpuUsage = cpu.NextValue();
        System.Threading.Thread.Sleep(500);
        cpuUsage = cpu.NextValue();

        float ramUsage = ram.NextValue();

        return new
        {
            cpu = Math.Round(cpuUsage, 0),
            ram = Math.Round(ramUsage, 0),
            txn = GetTxnPerMinute(),
            db = CheckDatabase(),
            worker = CheckSettlementWorker()
        };
    }
    void LoadSummary()
    {
        try
        {
            using (SqlConnection con = new SqlConnection(conStr))
            using (SqlCommand cmd = new SqlCommand("sp_dashboard_summary", con))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.CommandTimeout = 60;  // ✅ important

                con.Open();

                using (SqlDataReader dr = cmd.ExecuteReader())
                {
                    if (dr.Read())
                    {
                        lblToday.Text = Format(dr["TodayTotal"]);
                        lblYesterday.Text = Format(dr["YesterdayTotal"]);
                        lblMonth.Text = Format(dr["MonthTotal"]);
                        lblAllTime.Text = Format(dr["AllTimeTotal"]);
                       
                        lblPendingWithdraw.Text = Format(dr["PendingWithdraw"]);
                    }
                }
            }
        }
        catch (Exception ex)
        {
            lblToday.Text = "Error";
        }
    }




    // RECENT TRANSACTIONS


    void LoadTransactions()
    {
        using (SqlConnection con = new SqlConnection(conStr))
        {
            using (SqlCommand cmd = new SqlCommand("sp_GetRecentTransactions", con))
            {
                cmd.CommandType = CommandType.StoredProcedure;

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();

                da.Fill(dt); // ✅ now correct

                gvTxn.DataSource = dt;
                gvTxn.DataBind();
            }
        }
    }


    // STATUS BADGE


    private static string CheckSettlementWorker()
{
    try
    {
        Process[] p = Process.GetProcessesByName("SettlementWorker");

        if (p.Length > 0)
            return "Running";

        return "Stopped";
    }
    catch
    {
        return "Unknown";
    }
}

    protected string GetStatusBadge(string status)
    {

        if (string.IsNullOrEmpty(status))
            return "<span class='badge bg-secondary'>Unknown</span>";

        status = status.ToLower();

        if (status.Contains("success"))
            return "<span class='badge bg-success'>Completed</span>";

        if (status.Contains("pending"))
            return "<span class='badge bg-warning text-dark'>Pending</span>";

        if (status.Contains("failed"))
            return "<span class='badge bg-danger'>Failed</span>";

        return "<span class='badge bg-secondary'>" + status + "</span>";

    }

     
    // FORMAT MONEY
    

    string Format(object val)
    {

        decimal d = 0;

        decimal.TryParse(val?.ToString(), out d);

        return "₹ " + d.ToString("N2");

    }

    
    // KPI AJAX
    

    
    [WebMethod]
    public static object GetKPIs()
    {
        try
        {
            using (SqlConnection con = new SqlConnection(conStr))
            using (SqlCommand cmd = new SqlCommand("sp_dashboard_kpi", con))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.CommandTimeout = 60;   // ✅ prevent timeout crash

                con.Open();

                using (SqlDataReader dr = cmd.ExecuteReader())
                {
                    if (dr.Read())
                    {
                        return new
                        {
                            collection = dr["CollectionToday"],
                            settled = dr["SettledToday"],
                            wallet = dr["CMSWalletBalance"]
                        };
                    }
                }
            }
        }
        catch (Exception ex)
        {
            return new
            {
                error = true,
                message = ex.Message
            };
        }

        return null;
    }

    private static int GetTxnPerMinute()
    {
        string conStr = ConfigurationManager.ConnectionStrings["CMSDBConnection"].ConnectionString;

        using (SqlConnection con = new SqlConnection(conStr))
        {
            con.Open();

            SqlCommand cmd = new SqlCommand(@"SELECT COUNT(*) 
FROM Transactions WITH (NOLOCK)
WHERE created_on >= DATEADD(MINUTE,-30,GETDATE())", con);

            return (int)cmd.ExecuteScalar();
        }
    }

    private static string CheckDatabase()
    {
        try
        {
            string conStr = ConfigurationManager.ConnectionStrings["CMSDBConnection"].ConnectionString;

            using (SqlConnection con = new SqlConnection(conStr))
            {
                con.Open();
                return "Online";
            }
        }
        catch
        {
            return "Offline";
        }
    }


    // LIVE TRANSACTIONS


    [WebMethod]
    public static List<object> GetLiveTransactions()
    {
        List<object> list = new List<object>();

        try
        {
            using (SqlConnection con = new SqlConnection(conStr))
            using (SqlCommand cmd = new SqlCommand("sp_recent_transactions", con))
            {
                cmd.CommandType = CommandType.StoredProcedure;

                // ✅ Prevent timeout crash
                cmd.CommandTimeout = 60;

                con.Open();

                using (SqlDataReader dr = cmd.ExecuteReader())
                {
                    while (dr.Read())
                    {
                        list.Add(new
                        {
                            txn_id = dr["txn_id"],
                            mobile = dr["mobile"],
                            amount = dr["amount"],
                            status = dr["status"],
                            created_on = dr["created_on"] == DBNull.Value
                                ? ""
                                : Convert.ToDateTime(dr["created_on"]).ToString("dd-MM-yyyy HH:mm")
                        });
                    }
                }
            }
        }
        catch (Exception ex)
        {
            // ✅ Avoid breaking UI
            list.Add(new
            {
                error = true,
                message = ex.Message
            });
        }

        return list;
    }


    // ALERTS


    [WebMethod]

    public static List<string> GetAlerts()
    {

        return new List<string>
        {
            "High failed transaction rate detected",
            "Settlement pending from ICICI Bank",
            "System running normally"
        };

    }

     
    // SUMMARY AJAX
    

    [WebMethod]

    public static object GetSummary()
    {

        using (SqlConnection con = new SqlConnection(conStr))
        using (SqlCommand cmd = new SqlCommand("sp_dashboard_summary", con))
        {

            cmd.CommandType = CommandType.StoredProcedure;

            con.Open();

            SqlDataReader dr = cmd.ExecuteReader();

            if (dr.Read())
            {

                return new
                {
                    today = dr["TodayTotal"],
                    yesterday = dr["YesterdayTotal"],
                    month = dr["MonthTotal"],
                    all = dr["AllTimeTotal"],
                    settlement = dr["SettlementBalance"]
                };

            }

        }

        return null;

    }

}