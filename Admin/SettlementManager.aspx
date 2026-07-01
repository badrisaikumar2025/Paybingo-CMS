<%@ Page Title="Settlement Manager"
Language="C#"
MasterPageFile="~/Admin/AdminMaster.master"
AutoEventWireup="true"
CodeFile="SettlementManager.aspx.cs"
Inherits="SettlementManager" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

<div class="container-fluid mt-4">

<h3 class="fw-bold mb-3">
<i class="fa fa-hand-holding-dollar text-success"></i>
Settlement Manager
</h3>

<asp:GridView
ID="gvRequests"
runat="server"
CssClass="table table-bordered table-striped"
AutoGenerateColumns="False"
EmptyDataText="No Pending Requests">

<Columns>

<asp:BoundField DataField="Id" HeaderText="Request ID" />
<asp:BoundField DataField="BankID" HeaderText="Bank ID" />
<asp:BoundField DataField="Amount" HeaderText="Amount" DataFormatString="{0:N2}" />
<asp:BoundField DataField="RequestDate" HeaderText="Date" />

<asp:TemplateField HeaderText="UTR">
<ItemTemplate>
<asp:TextBox ID="txtUTR" runat="server" CssClass="form-control form-control-sm"></asp:TextBox>
</ItemTemplate>
</asp:TemplateField>

<asp:TemplateField HeaderText="Action">
<ItemTemplate>

<asp:Button ID="btnApprove"
runat="server"
Text="Approve"
CssClass="btn btn-success btn-sm"
CommandArgument='<%# Eval("Id") %>'
OnClick="Approve_Click" />

<asp:Button ID="btnReject"
runat="server"
Text="Reject"
CssClass="btn btn-danger btn-sm ms-2"
CommandArgument='<%# Eval("Id") %>'
OnClick="Reject_Click" />

</ItemTemplate>
</asp:TemplateField>

</Columns>

</asp:GridView>

</div>

</asp:Content>