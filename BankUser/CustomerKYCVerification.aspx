<%@ Page Language="C#" AutoEventWireup="true"
CodeFile="CustomerKYCVerification.aspx.cs"
Inherits="BankUser_CustomerKYCVerification" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Customer KYC Verification</title>

    <style>
        body {
            font-family: Arial;
            margin: 30px;
        }

        .card {
            width: 600px;
            border: 1px solid #ddd;
            padding: 20px;
            border-radius: 5px;
        }

        .form-control {
            width: 300px;
            padding: 8px;
            margin-bottom: 10px;
        }

        .btn {
            padding: 8px 20px;
            cursor: pointer;
        }

        .result {
            margin-top: 20px;
            padding: 15px;
            background: #f5f5f5;
        }
    </style>

</head>
<body>

<form id="form1" runat="server">

<div class="card">

    <h2>Customer KYC Verification</h2>

    <label>Customer ID</label>
    <br />

    <asp:TextBox
        ID="txtCustomerId"
        runat="server"
        CssClass="form-control">
    </asp:TextBox>

    <asp:Button
        ID="btnVerify"
        runat="server"
        Text="Verify KYC"
        CssClass="btn"
        OnClick="btnVerify_Click" />

    <div class="result">

        <asp:Label
            ID="lblName"
            runat="server">
        </asp:Label>

        <br /><br />

        <asp:Label
            ID="lblMobile"
            runat="server">
        </asp:Label>

        <br /><br />

        <asp:Label
            ID="lblEmail"
            runat="server">
        </asp:Label>

        <br /><br />

        <asp:Label
            ID="lblStatus"
            runat="server">
        </asp:Label>

    </div>

</div>

</form>

</body>
</html>