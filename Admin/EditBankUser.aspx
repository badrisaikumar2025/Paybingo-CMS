<%@ Page Title="Edit Bank User"
Language="C#"
MasterPageFile="~/Admin/AdminMaster.master"
AutoEventWireup="true"
CodeFile="EditBankUser.aspx.cs"
Inherits="Admin_EditBankUser" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

<div class="container mt-4">

<h3 class="fw-bold mb-4">
<i class="fa fa-user-edit text-primary"></i> Edit Bank User
</h3>

<div class="card p-4">

<asp:HiddenField ID="hdUserID" runat="server" />

<div class="row">

<div class="col-md-6 mb-3">
<label>Username</label>
<asp:TextBox ID="txtUsername" runat="server" CssClass="form-control" ReadOnly="true" />
</div>

<div class="col-md-6 mb-3">
<label>Email</label>
<asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" />
</div>

<div class="col-md-6 mb-3">
<label>Phone</label>
<asp:TextBox ID="txtPhone" runat="server" CssClass="form-control" />
</div>

<div class="col-md-6 mb-3">
<label>Select Bank</label>
<asp:DropDownList ID="ddlBank" runat="server" CssClass="form-control" />
</div>

<div class="col-md-6 mb-3">
<label>New Password</label>
<asp:TextBox ID="txtPassword" runat="server" CssClass="form-control" placeholder="Leave blank if no change" />
</div>

<div class="col-md-6 mb-3">
<label>Status</label>
<asp:DropDownList ID="ddlStatus" runat="server" CssClass="form-control">
<asp:ListItem Value="1">Active</asp:ListItem>
<asp:ListItem Value="0">Blocked</asp:ListItem>
</asp:DropDownList>
</div>

</div>

<asp:Button ID="btnUpdate"
runat="server"
Text="Update User"
CssClass="btn btn-success"
OnClick="btnUpdate_Click" />

</div>

</div>

</asp:Content>