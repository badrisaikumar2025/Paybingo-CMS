<%@ Page Title="Retailer Transaction"
Language="C#"
MasterPageFile="~/Admin/AdminMaster.master"
AutoEventWireup="true"
CodeFile="RetailerTransaction.aspx.cs"
Inherits="Admin_RetailerTransaction" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

<div class="container-fluid mt-4">

<h3 class="fw-bold mb-4">
<i class="fa fa-store text-primary"></i>
Retailer Send Transaction
</h3>

<div class="card shadow-sm p-4">

<div class="row">

<div class="col-md-4 mb-3">
<label>Retailer ID</label>
<asp:TextBox ID="txtRetailer" runat="server" CssClass="form-control" />
</div>

<div class="col-md-4 mb-3">
<label>Select Bank</label>
<asp:DropDownList ID="ddlBank" runat="server" CssClass="form-control"></asp:DropDownList>
</div>

<div class="col-md-4 mb-3">
<label>Branch ID</label>
<asp:TextBox ID="txtBranch" runat="server" CssClass="form-control" />
</div>

<div class="col-md-4 mb-3">
<label>Customer Mobile</label>
<asp:TextBox ID="txtMobile" runat="server" CssClass="form-control" />
</div>

<div class="col-md-4 mb-3">
<label>Amount</label>
<asp:TextBox ID="txtAmount" runat="server" CssClass="form-control" />
</div>

</div>

<asp:Button ID="btnSend" runat="server"
Text="Send Transaction"
CssClass="btn btn-success"
OnClick="btnSend_Click" />

</div>

</div>

</asp:Content>