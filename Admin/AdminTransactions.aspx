<%@ Page Title="Admin Transactions"
Language="C#"
MasterPageFile="~/Admin/AdminMaster.master"
AutoEventWireup="true"
CodeFile="AdminTransactions.aspx.cs"
Inherits="Admin_AdminTransactions" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <meta http-equiv="refresh" content="10">

<div class="container-fluid mt-4">

<h3 class="fw-bold mb-3">
<i class="fa fa-list text-primary"></i>
All Transactions
</h3>

<asp:GridView 
ID="gvTxn"
runat="server"
CssClass="table table-striped table-bordered"
AutoGenerateColumns="False"
EmptyDataText="No Transactions Found">

<Columns>

<asp:BoundField DataField="txn_id" HeaderText="Txn ID" />

<asp:BoundField DataField="mobile" HeaderText="Mobile" />

<asp:BoundField DataField="BankName" HeaderText="Bank" />

<asp:BoundField DataField="amount" HeaderText="Amount" DataFormatString="{0:N2}" />

<asp:BoundField DataField="status" HeaderText="Status" />

<asp:BoundField DataField="created_on" HeaderText="Date" 
DataFormatString="{0:dd-MM-yyyy HH:mm}" />

</Columns>

</asp:GridView>
</div>

</asp:Content>