using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Web.Services;
using System.Collections.Generic;
using System.Security.Cryptography;
using System.Text;

[System.Web.Script.Services.ScriptService]
public partial class Admin_CreateUser : System.Web.UI.Page
{
    static string conStr = ConfigurationManager.ConnectionStrings["CMSDBConnection"].ConnectionString;

    // ✅ LOAD BANKS
    [WebMethod]
    public static List<object> GetBanks()
    {
        List<object> list = new List<object>();

        using (SqlConnection con = new SqlConnection(conStr))
        {
            SqlCommand cmd = new SqlCommand("SELECT BankID, BankName FROM Banks WHERE Status=1", con);
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

    // ✅ CREATE USER
    [WebMethod]
    public static object CreateUser(string email, string phone, int bankid)
    {
        try
        {
            string password = GeneratePassword();
            string hash = GetMD5(password);

            using (SqlConnection con = new SqlConnection(conStr))
            {
                con.Open();

                // 🔥 CHECK DUPLICATE
                SqlCommand check = new SqlCommand("SELECT COUNT(*) FROM BankUsers WHERE Email=@e OR Phone=@p", con);
                check.Parameters.AddWithValue("@e", email);
                check.Parameters.AddWithValue("@p", phone);

                int exists = Convert.ToInt32(check.ExecuteScalar());

                if (exists > 0)
                {
                    return new { success = false, message = "User already exists" };
                }

                SqlCommand cmd = new SqlCommand(@"
                INSERT INTO BankUsers
                (Email, Phone, Password, BankID, IsFirstLogin, IsActive, CreateDate)
                VALUES (@e,@p,@pass,@bank,1,1,GETDATE())", con);

                cmd.Parameters.AddWithValue("@e", email);
                cmd.Parameters.AddWithValue("@p", phone);
                cmd.Parameters.AddWithValue("@pass", hash);
                cmd.Parameters.AddWithValue("@bank", bankid);

                cmd.ExecuteNonQuery();
            }

            return new { success = true, password = password };
        }
        catch (Exception ex)
        {
            return new { success = false, message = ex.Message };
        }
    }

    //  PASSWORD GENERATOR
    static string GeneratePassword()
    {
        return Guid.NewGuid().ToString().Replace("-", "").Substring(0, 8);
    }

    //  HASH
    static string GetMD5(string input)
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