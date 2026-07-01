<%@ Page Title="Bank Transactions"
Language="C#"
MasterPageFile="~/BankUser/UserMaster.master"
AutoEventWireup="true"
CodeFile="Transactions.aspx.cs"
Inherits="BankUser_Transactions" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

<div class="container-fluid mt-4">

<h3 class="fw-bold mb-3">
<i class="fa fa-list text-primary"></i>
Bank Transactions
</h3>

<asp:GridView
ID="gvTxn"
runat="server"
CssClass="table table-bordered table-striped"
AutoGenerateColumns="False"
EmptyDataText="No Transactions Found">

<Columns>

<asp:BoundField DataField="txn_id" HeaderText="Txn ID"/>

<asp:BoundField DataField="mobile" HeaderText="Customer"/>

<asp:BoundField DataField="amount" HeaderText="Amount" DataFormatString="{0:N2}"/>

<asp:BoundField DataField="status" HeaderText="Status"/>

<asp:BoundField DataField="created_on" HeaderText="Date" DataFormatString="{0:dd-MM-yyyy HH:mm}"/>

</Columns>

</asp:GridView>

</div>

</asp:Content>