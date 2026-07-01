<%@ Page Title="IP Whitelist"
Language="C#"
MasterPageFile="~/Admin/AdminMaster.master"
AutoEventWireup="true"
CodeFile="Admin_IPWhitelist.aspx.cs"
Inherits="Admin_IPWhitelist" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

<div class="container mt-4">

    <h3 class="fw-bold mb-3">🔐 IP Whitelist Management</h3>

    <!-- ADD IP -->
    <div class="card p-3 mb-4 shadow-sm">
        <h5>Add New IP</h5>

        <div class="row">
            <div class="col-md-4">
                <asp:TextBox ID="txtUserId" runat="server" CssClass="form-control" placeholder="User ID"></asp:TextBox>
            </div>

            <div class="col-md-4">
                <asp:TextBox ID="txtIP" runat="server" CssClass="form-control" placeholder="Enter IP (e.g. 122.176.45.210)"></asp:TextBox>
            </div>

            <div class="col-md-4">
                <asp:Button ID="btnAddIP" runat="server" Text="Add IP" CssClass="btn btn-primary w-100" OnClick="btnAddIP_Click" />
            </div>
        </div>
    </div>

    <!-- GRID -->
    <div class="card p-3 shadow-sm">
        <h5>Whitelisted IPs</h5>

        <asp:GridView ID="gvIPs" runat="server" CssClass="table table-bordered"
            AutoGenerateColumns="false" OnRowCommand="gvIPs_RowCommand">

            <Columns>
                <asp:BoundField DataField="UserId" HeaderText="User ID" />
                <asp:BoundField DataField="AllowedIP" HeaderText="IP Address" />
                <asp:BoundField DataField="CreatedDate" HeaderText="Added On" />

                <asp:TemplateField HeaderText="Status">
                    <ItemTemplate>
                        <%# Convert.ToBoolean(Eval("IsActive")) ? "Active" : "Blocked" %>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="Action">
                    <ItemTemplate>
                        <asp:Button runat="server" Text="Toggle"
                            CommandName="Toggle"
                            CommandArgument='<%# Eval("Id") %>'
                            CssClass="btn btn-warning btn-sm" />

                        <asp:Button runat="server" Text="Delete"
                            CommandName="DeleteIP"
                            CommandArgument='<%# Eval("Id") %>'
                            CssClass="btn btn-danger btn-sm ms-2" />
                    </ItemTemplate>
                </asp:TemplateField>

            </Columns>

        </asp:GridView>
    </div>

</div>

</asp:Content>