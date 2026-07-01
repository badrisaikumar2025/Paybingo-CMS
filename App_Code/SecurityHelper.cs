using System;
using System.Security.Cryptography;
using System.Text;

public class SecurityHelper
{
    public static string HashPasswordSHA256(string password, string salt)
    {
        using (SHA256 sha = SHA256.Create())
        {
            byte[] bytes = Encoding.UTF8.GetBytes(password + salt);
            byte[] hash = sha.ComputeHash(bytes);

            StringBuilder sb = new StringBuilder();

            foreach (byte b in hash)
                sb.Append(b.ToString("x2"));

            return sb.ToString();
        }
    }

    public static string GetMD5(string input)
    {
        using (MD5 md5 = MD5.Create())
        {
            byte[] bytes = Encoding.UTF8.GetBytes(input);
            byte[] hash = md5.ComputeHash(bytes);

            StringBuilder sb = new StringBuilder();

            foreach (byte b in hash)
                sb.Append(b.ToString("x2"));

            return sb.ToString();
        }
    }

    public static string GenerateOTP()
    {
        Random rnd = new Random();
        return rnd.Next(100000, 999999).ToString();
    }
}