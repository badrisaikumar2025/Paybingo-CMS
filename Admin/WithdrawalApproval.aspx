<%@ Page Title="Withdrawal Approval"
Language="C#"
MasterPageFile="~/Admin/AdminMaster.master"
AutoEventWireup="true"
CodeFile="WithdrawalApproval.aspx.cs"
Inherits="Admin_WithdrawalApproval" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

<div class="container mt-4">

<h3 class="fw-bold mb-3">Withdrawal Requests</h3>

<asp:GridView ID="gvWithdraw" runat="server"
CssClass="table table-bordered"
AutoGenerateColumns="False"
OnRowCommand="gvWithdraw_RowCommand">

<Columns>  

<asp:BoundField DataField="Id" HeaderText="ID"/>
<asp:BoundField DataField="BankID" HeaderText="Bank"/>
<asp:BoundField DataField="Amount" HeaderText="Amount"/>
<asp:BoundField DataField="Status" HeaderText="Status"/>
<asp:BoundField DataField="RequestDate" HeaderText="Date"/>

<asp:TemplateField HeaderText="UTR"> <ItemTemplate>
<asp:TextBox ID="txtUTR" runat="server" CssClass="form-control" Width="120px"></asp:TextBox> </ItemTemplate>
</asp:TemplateField>

<asp:TemplateField HeaderText="Action"> <ItemTemplate>

<asp:Button ID="btnApprove" runat="server"
Text="Approve"
CssClass="btn btn-success btn-sm"
CommandName="Approve"
CommandArgument='<%# Eval("Id") %>' />

<asp:Button ID="btnReject" runat="server"
Text="Reject"
CssClass="btn btn-danger btn-sm"
CommandName="Reject"
CommandArgument='<%# Eval("Id") %>' />
    <asp:Button ID="btnPaid" runat="server"
Text="Mark Paid"
CssClass="btn btn-primary btn-sm"
CommandName="Paid"
CommandArgument='<%# Eval("Id") %>' />

</ItemTemplate>
</asp:TemplateField>

</Columns>

</asp:GridView>

</div>

</asp:Content>
