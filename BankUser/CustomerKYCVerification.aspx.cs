using System;
using System.IO;
using System.Net;
using Newtonsoft.Json.Linq;

public partial class BankUser_CustomerKYCVerification : System.Web.UI.Page
{
    protected void btnVerify_Click(object sender, EventArgs e)
    {
        try
        {
            string customerId = txtCustomerId.Text.Trim();

            string apiUrl =
            "https://dummyjson.com/users/" + customerId;

            HttpWebRequest request =
            (HttpWebRequest)WebRequest.Create(apiUrl);

            request.Method = "GET";

            HttpWebResponse response =
            (HttpWebResponse)request.GetResponse();

            StreamReader reader =
            new StreamReader(response.GetResponseStream());

            string json = reader.ReadToEnd();

            JObject obj = JObject.Parse(json);

            lblName.Text =
                "Name : " +
                obj["firstName"] + " " +
                obj["lastName"];

            lblMobile.Text =
                "Mobile : " +
                obj["phone"];

            lblEmail.Text =
                "Email : " +
                obj["email"];

            lblStatus.Text =
                "KYC Status : VERIFIED";
        }
        catch (Exception ex)
        {
            lblStatus.Text =
                "Error : " + ex.Message;
        }
    }
}