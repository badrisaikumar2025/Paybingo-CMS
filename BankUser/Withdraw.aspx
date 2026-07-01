<%@ Page Title="Withdraw" Language="C#" MasterPageFile="~/BankUser/UserMaster.master"
AutoEventWireup="true" CodeFile="Withdraw.aspx.cs" Inherits="BankUser_Withdraw" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

<!-- ✅ REQUIRED FOR POPUP -->
<asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>

<div class="container mt-4">

<h3 class="fw-bold mb-3">
<i class="fa fa-money-bill-transfer text-primary"></i> Request Withdrawal
</h3>

<div class="card p-4 shadow">

<asp:Label ID="lblBalance" runat="server" CssClass="fw-bold text-success fs-5"></asp:Label>

<br /><br />

   



<br />

<asp:Button ID="btnRequest" runat="server"
Text="Withdraw Full Amount"
CssClass="btn btn-danger"
OnClick="btnRequest_Click" />



        <hr class="mt-5"/>

<h5 class="fw-bold mt-3">Withdrawal History</h5>

<asp:GridView ID="gvHistory" runat="server"
CssClass="table table-bordered table-striped mt-3"
AutoGenerateColumns="False">

<Columns>

<asp:BoundField DataField="Id" HeaderText="ID" />
<asp:BoundField DataField="Amount" HeaderText="Amount" />
<asp:BoundField DataField="Status" HeaderText="Status" />
<asp:BoundField DataField="UTRNumber" HeaderText="UTR" />
<asp:BoundField DataField="RequestDate" HeaderText="Requested On" />
<asp:BoundField DataField="ApprovedDate" HeaderText="Approved On" />

</Columns>

</asp:GridView>

</div>

</div>

</asp:Content>