<%@ Page Title="Reports"
Language="C#"
MasterPageFile="~/Admin/AdminMaster.master"
AutoEventWireup="true"
CodeFile="Reports.aspx.cs"
Inherits="Admin_Reports" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

<div class="container-fluid mt-4">

    <h3 class="fw-bold mb-4">
        <i class="fa fa-chart-line text-primary"></i> Reports
    </h3>

    <!-- FILTER SECTION -->
    <div class="card shadow-sm p-3 mb-4">
        <div class="row g-3 align-items-end">

            <!-- From Date -->
            <div class="col-md-2">
                <label>From Date</label>
                <asp:TextBox ID="txtFromDate" runat="server" CssClass="form-control" TextMode="Date"></asp:TextBox>
            </div>

            <!-- To Date -->
            <div class="col-md-2">
                <label>To Date</label>
                <asp:TextBox ID="txtToDate" runat="server" CssClass="form-control" TextMode="Date"></asp:TextBox>
            </div>

            <!-- Report Type -->
            <div class="col-md-2">
                <label>Type</label>
                <asp:DropDownList ID="ddlType" runat="server" CssClass="form-control">
                    <asp:ListItem Value="All">All</asp:ListItem>
                    <asp:ListItem Value="Employee">Employee</asp:ListItem>
                    <asp:ListItem Value="Retailer">Retailer</asp:ListItem>
                </asp:DropDownList>
            </div>

            <!-- Employee -->
            <div class="col-md-2">
                <label>Employee</label>
                <asp:DropDownList ID="ddlEmployee" runat="server" CssClass="form-control"></asp:DropDownList>
            </div>

            <!-- Retailer -->
            <div class="col-md-2">
                <label>Retailer</label>
                <asp:DropDownList ID="ddlRetailer" runat="server" CssClass="form-control"></asp:DropDownList>
            </div>

            <!-- Buttons -->
            <div class="col-md-2 d-flex gap-2">
                <asp:Button ID="btnFilter" runat="server" Text="Filter"
                    CssClass="btn btn-primary w-100" OnClick="btnFilter_Click"/>

                <asp:Button ID="btnExport" runat="server" Text="Export"
                    CssClass="btn btn-success w-100" OnClick="btnExport_Click"/>
            </div>

        </div>
    </div>

    <!-- GRID -->
    <div class="card shadow-sm p-3">
        <asp:GridView
            ID="gvReport"
            runat="server"
            CssClass="table table-hover table-bordered"
            AutoGenerateColumns="False"
            EmptyDataText="No records found">

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

</div>

</asp:Content>