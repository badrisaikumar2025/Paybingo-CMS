using System;
using System.Security.Cryptography;
using System.Text;

public partial class GenerateHash : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        string password = "AMMA143drago@@";

        string salt = Guid.NewGuid().ToString();

        using (SHA256 sha = SHA256.Create())
        {
            byte[] bytes = Encoding.UTF8.GetBytes(password + salt);
            byte[] hash = sha.ComputeHash(bytes);

            StringBuilder sb = new StringBuilder();

            foreach (byte b in hash)
                sb.Append(b.ToString("x2"));

            string finalHash = sb.ToString();

            Response.Write("Salt: " + salt + "<br>");
            Response.Write("Hash: " + finalHash);
        }
    }
}