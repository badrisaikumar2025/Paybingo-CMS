<%@ Page Title="Admin List"
Language="C#"
MasterPageFile="~/Admin/AdminMaster.master"
AutoEventWireup="true"
CodeFile="AdminList.aspx.cs"
Inherits="Admin_AdminList" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

<div class="container-fluid mt-4">

<h3 class="fw-bold mb-4">
<i class="fa fa-users text-primary"></i> Admin List
</h3>

<!-- SEARCH -->

<div class="row mb-3">
<div class="col-md-4">

<asp:TextBox
ID="txtSearch"
runat="server"
CssClass="form-control"
Placeholder="Search admin by name/email/phone">
</asp:TextBox>

</div>

<div class="col-md-2">

<asp:Button
ID="btnSearch"
runat="server"
Text="Search"
CssClass="btn btn-primary"
OnClick="btnSearch_Click" />

</div>
</div>

<!-- GRID -->

<asp:GridView
ID="gvAdmins"
runat="server"
CssClass="table table-striped table-hover"
AutoGenerateColumns="False"
AllowPaging="true"
PageSize="10"
OnPageIndexChanging="gvAdmins_PageIndexChanging"
OnRowCommand="gvAdmins_RowCommand"
DataKeyNames="pkid"
EmptyDataText="No Admins Found">

<Columns>

<asp:BoundField DataField="pkid" HeaderText="ID" />

<asp:BoundField DataField="FullName" HeaderText="Name" />

<asp:BoundField DataField="Email" HeaderText="Email" />

<asp:BoundField DataField="Phone" HeaderText="Phone" />

<asp:TemplateField HeaderText="Status">
<ItemTemplate>

<%# Convert.ToBoolean(Eval("IsActive")) 
? "<span class='badge bg-success'>Active</span>" 
: "<span class='badge bg-danger'>Inactive</span>" %>

</ItemTemplate>
</asp:TemplateField>

<asp:BoundField
DataField="CreateDate"
HeaderText="Created"
DataFormatString="{0:dd-MM-yyyy HH:mm}" />

<asp:TemplateField HeaderText="Actions">

<ItemTemplate>

<asp:LinkButton
runat="server"
CommandName="editAdmin"
CommandArgument='<%# Eval("pkid") %>'
CssClass="btn btn-sm btn-primary me-1">
<i class="fa fa-edit"></i>
</asp:LinkButton>

<asp:LinkButton
runat="server"
CommandName="toggleAdmin"
CommandArgument='<%# Eval("pkid") %>'
CssClass="btn btn-sm btn-warning me-1">
<i class="fa fa-power-off"></i>
</asp:LinkButton>

<asp:LinkButton
runat="server"
CommandName="deleteAdmin"
CommandArgument='<%# Eval("pkid") %>'
OnClientClick="return confirm('Delete this admin?')"
CssClass="btn btn-sm btn-danger">
<i class="fa fa-trash"></i>
</asp:LinkButton>

</ItemTemplate>

</asp:TemplateField>

</Columns>

</asp:GridView>

</div>

</asp:Content>