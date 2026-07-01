using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Web.Services;
using System.Collections.Generic;

[System.Web.Script.Services.ScriptService]
public partial class Admin_CreateBank : System.Web.UI.Page
{
    static string conStr = ConfigurationManager.ConnectionStrings["CMSDBConnection"].ConnectionString;


// ✅ ADD BANK (NO IFSC)
[WebMethod]
    public static string AddBank(string name)
    {
        if (string.IsNullOrWhiteSpace(name))
            return "Bank name required";

        using (SqlConnection con = new SqlConnection(conStr))
        {
            con.Open();

            // 🔥 Prevent duplicate bank
            SqlCommand checkCmd = new SqlCommand("SELECT COUNT(*) FROM Banks WHERE BankName = @name", con);
            checkCmd.Parameters.AddWithValue("@name", name);

            int count = (int)checkCmd.ExecuteScalar();

            if (count > 0)
                return "Bank already exists";

            // ✅ Insert bank (NO IFSC)
            SqlCommand cmd = new SqlCommand(@"
            INSERT INTO Banks (BankName, Status, Priority, DailyLimit, UsedLimit)
            VALUES (@name, 1, 1, 0, 0)", con);

            cmd.Parameters.AddWithValue("@name", name);

            cmd.ExecuteNonQuery();
        }

        return "Success";
    }

    // ✅ GET BANK LIST
    [WebMethod]
    public static List<object> GetBanks()
    {
        List<object> list = new List<object>();

        using (SqlConnection con = new SqlConnection(conStr))
        {
            SqlCommand cmd = new SqlCommand(
                "SELECT BankID, BankName FROM Banks WHERE Status = 1 ORDER BY BankID DESC", con);

            con.Open();

            SqlDataReader dr = cmd.ExecuteReader();

            while (dr.Read())
            {
                list.Add(new
                {
                    id = Convert.ToInt32(dr["BankID"]),
                    name = dr["BankName"].ToString()
                });
            }
        }

        return list;
    }

}
