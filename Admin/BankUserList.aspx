<%@ Page Title="Bank User List" Language="C#" MasterPageFile="~/Admin/AdminMaster.master"
AutoEventWireup="true"
CodeFile="BankUserList.aspx.cs"
Inherits="Admin_BankUserList" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

<div class="container-fluid mt-4">

<h3 class="fw-bold mb-4">
<i class="fa fa-building-columns text-primary"></i>
Bank User List
</h3>

<asp:GridView
ID="gvBankUsers"
runat="server"
CssClass="table table-striped table-bordered"
AutoGenerateColumns="False"
EmptyDataText="No Bank Users Found"
OnRowCommand="gvBankUsers_RowCommand"
DataKeyNames="UserID">

<Columns>

<asp:BoundField DataField="UserID" HeaderText="User ID" />
<asp:BoundField DataField="Username" HeaderText="Username" />
<asp:BoundField DataField="FullName" HeaderText="Full Name" />
<asp:BoundField DataField="Email" HeaderText="Email" />
<asp:BoundField DataField="Phone" HeaderText="Phone" />

<asp:TemplateField HeaderText="Status">
<ItemTemplate>
<asp:Label 
runat="server"
Text='<%# Convert.ToBoolean(Eval("IsActive")) ? "Active" : "Blocked" %>'
CssClass='<%# Convert.ToBoolean(Eval("IsActive")) ? "badge bg-success" : "badge bg-danger" %>' />
</ItemTemplate>
</asp:TemplateField>

<asp:BoundField DataField="CreateDate"
HeaderText="Created On"
DataFormatString="{0:dd-MM-yyyy HH:mm}" />


<asp:TemplateField HeaderText="Actions">
<ItemTemplate>

<asp:Button runat="server"
Text="Edit"
CommandName="EditUser"
CommandArgument='<%# Eval("UserID") %>'
CssClass="btn btn-sm btn-primary me-1" />

<asp:Button runat="server"
Text='<%# Convert.ToBoolean(Eval("IsActive")) ? "Block" : "Activate" %>'
CommandName="Toggle"
CommandArgument='<%# Eval("UserID") %>'
CssClass='<%# Convert.ToBoolean(Eval("IsActive")) ? "btn btn-sm btn-warning me-1" : "btn btn-sm btn-success me-1" %>' />

<asp:Button runat="server"
Text="Delete"
CommandName="DeleteUser"
CommandArgument='<%# Eval("UserID") %>'
CssClass="btn btn-sm btn-danger"
OnClientClick="return confirm('Are you sure to delete?');" />

</ItemTemplate>
</asp:TemplateField>

</Columns>

</asp:GridView>

</div>

</asp:Content>