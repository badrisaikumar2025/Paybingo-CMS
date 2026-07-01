<%@ Page Title="Settlement History" Language="C#" MasterPageFile="~/BankUser/UserMaster.master"
AutoEventWireup="true" CodeFile="SettlementHistory.aspx.cs" Inherits="BankUser_SettlementHistory" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

<div class="container mt-4">

    <h3 class="fw-bold mb-3">
        <i class="fa fa-history text-success"></i> Settlement History
    </h3>

    <!-- FILTER -->
    <div class="card p-3 mb-3 shadow-sm">
        <div class="row g-2">

            <div class="col-md-3">
                <label>From</label>
                <asp:TextBox ID="txtFrom" runat="server" CssClass="form-control" TextMode="Date" />
            </div>

            <div class="col-md-3">
                <label>To</label>
                <asp:TextBox ID="txtTo" runat="server" CssClass="form-control" TextMode="Date" />
            </div>

            <div class="col-md-3">
                <label>Status</label>
                <asp:DropDownList ID="ddlStatus" runat="server" CssClass="form-control">
                    <asp:ListItem Value="">All</asp:ListItem>
                    <asp:ListItem Value="PENDING">Pending</asp:ListItem>
                    <asp:ListItem Value="APPROVED">Approved</asp:ListItem>
                    <asp:ListItem Value="PAID">Paid</asp:ListItem>
                    <asp:ListItem Value="FAILED">Failed</asp:ListItem>
                </asp:DropDownList>
            </div>

            <div class="col-md-3 d-flex align-items-end">
                <asp:Button ID="btnSearch" runat="server" Text="Search"
                    CssClass="btn btn-primary w-100"
                    OnClick="btnSearch_Click" />
            </div>

        </div>
    </div>

    <!-- TABLE -->
    <div class="card shadow-sm p-2">

        <asp:GridView ID="gvHistory" runat="server"
            CssClass="table table-bordered table-striped"
            AutoGenerateColumns="False">

            <Columns>

                <asp:BoundField DataField="Amount" HeaderText="Amount" DataFormatString="{0:N2}" />

                <asp:TemplateField HeaderText="Status">
                    <ItemTemplate>
                        <%# GetStatusBadge(Eval("Status").ToString()) %>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:BoundField DataField="UTRNumber" HeaderText="UTR" />
                <asp:BoundField DataField="RequestedDate" HeaderText="Requested On" DataFormatString="{0:dd-MM-yyyy HH:mm}" />
                <asp:BoundField DataField="ApprovedDate" HeaderText="Processed On" DataFormatString="{0:dd-MM-yyyy HH:mm}" />

            </Columns>

        </asp:GridView>

    </div>

</div>

</asp:Content>