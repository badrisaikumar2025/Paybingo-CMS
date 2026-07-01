<%@ Page Title="Bank Reports" Language="C#" MasterPageFile="~/BankUser/UserMaster.master"
AutoEventWireup="true" CodeFile="BankReports.aspx.cs" Inherits="BankReports" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

<div class="container-fluid">

    <h3 class="fw-bold mb-4">
        <i class="fa fa-chart-line text-primary"></i> NBFC CMS Reports
    </h3>

    <!-- FILTERS -->
    <div class="card p-3 mb-3 shadow-sm">
        <div class="row g-2">

            <div class="col-md-2">
                <label>From</label>
                <asp:TextBox ID="txtFrom" runat="server" CssClass="form-control" TextMode="Date" />
            </div>

            <div class="col-md-2">
                <label>To</label>
                <asp:TextBox ID="txtTo" runat="server" CssClass="form-control" TextMode="Date" />
            </div>

            <div class="col-md-2">
                <label>Status</label>
                <asp:DropDownList ID="ddlStatus" runat="server" CssClass="form-control">
                    <asp:ListItem Value="">All</asp:ListItem>
                    <asp:ListItem Value="HOLD">Processing</asp:ListItem>
                    <asp:ListItem Value="SUCCESS">Success</asp:ListItem>
                    <asp:ListItem Value="SETTLED">Settled</asp:ListItem>
                    <asp:ListItem Value="FAILED">Failed</asp:ListItem>
                </asp:DropDownList>
            </div>

            <div class="col-md-3">
                <label>Search Mobile</label>
                <asp:TextBox ID="txtSearch" runat="server" CssClass="form-control" placeholder="Enter Mobile" />
            </div>

            <div class="col-md-3 d-flex align-items-end gap-2">
                <asp:Button ID="btnSearch" runat="server" Text="Search" CssClass="btn btn-primary" OnClick="btnSearch_Click" />
                <asp:Button ID="btnExcel" runat="server" Text="Excel" CssClass="btn btn-success" OnClick="btnExcel_Click" />
                <asp:Button ID="btnPDF" runat="server" Text="PDF" CssClass="btn btn-danger" OnClick="btnPDF_Click" />
            </div>

        </div>
    </div>

    <!-- TABLE -->
    <div class="card shadow-sm p-2">

        <asp:GridView ID="gvReport" runat="server"
            CssClass="table table-bordered table-striped"
            AutoGenerateColumns="False">

            <Columns>

                <asp:BoundField DataField="txn_id" HeaderText="Txn ID" />
                <asp:BoundField DataField="mobile" HeaderText="Mobile" />
                <asp:BoundField DataField="amount" HeaderText="Amount" DataFormatString="{0:N2}" />
                <asp:TemplateField HeaderText="Status">
                    <ItemTemplate>
                        <%# GetStatusBadge(Eval("status").ToString()) %>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:BoundField DataField="created_on" HeaderText="Date" DataFormatString="{0:dd-MM-yyyy HH:mm}" />

            </Columns>

        </asp:GridView>

    </div>

</div>

</asp:Content>