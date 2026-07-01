<%@ Page Title="" Language="C#" MasterPageFile="~/BankUser/UserMaster.master" AutoEventWireup="true" CodeFile="BankDashboard.aspx.cs" Inherits="BankUser_BankDashboard" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:ScriptManager runat="server" EnablePageMethods="true" />
   
    
    <div class="container-fluid mt-4">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h3 class="fw-bold m-0 text-dark">
                <i class="fa fa-chart-pie text-primary"></i> Bank Dashboard

            </h3>
            
            <span class="badge bg-dark px-3 py-2">
                <%= DateTime.Now.ToString("dddd, dd MMM yyyy") %>

            </span>

        </div>
        
        <!-- KPI CARDS -->
        <div class="row g-4 mb-5">

    <div class="col-md">
        <div class="dash-card blue text-center fade-in">
            <span>Total Collection</span>
            <h2 id="kpiCollection">₹ 0.00</h2>
        </div>
    </div>

    <div class="col-md">
        <div class="dash-card green text-center">
            <span>Total Settled</span>
            <h2 id="kpiSettled">₹ 0.00</h2>
        </div>
    </div>

    <div class="col-md">
        <div class="dash-card teal text-center">
            <span>Wallet Balance</span>
            <h2 id="kpiWallet">₹ 0.00</h2>
        </div>
    </div>

</div>
        
        <!-- SUMMARY CARDS -->
        <div class="row g-4">
            
            <div class="col-lg-3 col-md-6">
                <div class="dash-card blue">
                    <div class="d-flex justify-content-between">
                        <div>
                            <span>Today</span>
                            <h2><asp:Label ID="lblToday" runat="server"></asp:Label></h2>

                        </div>
                        <i class="fa fa-wallet fa-2x opacity-75"></i>

                    </div>

                </div>

            </div>
            <div class="col-lg-3 col-md-6">
                <div class="dash-card green">
                    <div class="d-flex justify-content-between">
                        <div>
                            <span>Yesterday</span>
                            <h2><asp:Label ID="lblYesterday" runat="server"></asp:Label></h2>

                        </div>
                        <i class="fa fa-calendar fa-2x opacity-75"></i>

                    </div>

                </div>

            </div>
            <div class="col-lg-3 col-md-6">
                <div class="dash-card purple">
                    <div class="d-flex justify-content-between">
                        <div>
                            <span>Month Till Date</span>
                            <h2><asp:Label ID="lblMonth" runat="server"></asp:Label></h2>

                        </div>
                        <i class="fa fa-chart-line fa-2x opacity-75"></i>

                    </div>

                </div>

            </div>
            
            <div class="col-lg-3 col-md-6">
                <div class="dash-card orange">
                    <div class="d-flex justify-content-between">
                        <div>
                            <span>Year Till Date</span>
                            <h2><asp:Label ID="lblAllTime" runat="server"></asp:Label></h2>

                        </div>
                        <i class="fa fa-clock fa-2x opacity-75"></i>

                    </div>

                </div>

            </div>

        </div>
        
        <!-- LIVE TRANSACTIONS -->
        <div class="table-card mt-5 mb-4">
            <h5 class="fw-bold mb-3">
                <i class="fa fa-bolt text-warning"></i> Live Transactions


            </h5>
            
            <div class="live-feed">
                <div class="feed-track" id="feedTrack"></div>

            </div>

        </div>
        
        <!-- RECENT TRANSACTIONS -->
        
        <div class="table-card">
            <h5 class="fw-bold mb-3">
                <i class="fa fa-exchange-alt text-primary"></i>
                Recent Transactions

            </h5>
            
            <asp:GridView ID="gvTxn"
                runat="server"
                CssClass="table table-striped table-hover"
                AutoGenerateColumns="False">
                <Columns>
                    
                    <asp:BoundField DataField="txn_id" HeaderText="Txn ID" />
                    <asp:BoundField DataField="mobile" HeaderText="Mobile" />
                    <asp:TemplateField HeaderText="Amount">
                        <ItemTemplate>
                            <span class="fw-semibold text-success">
                                ₹ <%# Eval("amount","{0:N2}") %>

                            </span>

                        </ItemTemplate>

                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Status">
                        <ItemTemplate>
                            <asp:Literal runat="server"
                                Text='<%# GetStatusBadge(Eval("status").ToString()) %>' />

                        </ItemTemplate>

                    </asp:TemplateField>
                    <asp:BoundField DataField="created_on" HeaderText="Date" />

                </Columns>

            </asp:GridView>

        </div>

    </div>
    
    <script>
        function animateValue(id, end) {
            let start = 0;
            let duration = 800;
            let step = end / (duration / 20);

            let el = document.getElementById(id);

            let counter = setInterval(() => {
                start += step;
                if (start >= end) {
                    start = end;
                    clearInterval(counter);
                }
                el.innerText = "₹ " + start.toFixed(2);
            }, 20);
        }

        function loadKPIs() {

            PageMethods.GetBankKPIs(function (d) {

                let data = d.d || d; // handles both cases

                let collection = parseFloat(data.collection || 0);
                let settled = parseFloat(data.settled || 0);
                let wallet = parseFloat(data.wallet || 0);

                animateValue("kpiCollection", collection);
                animateValue("kpiSettled", settled);
                animateValue("kpiWallet", wallet);

            });

        }


        setInterval(loadKPIs, 10000);
        loadKPIs();


        function loadLiveFeed() {

            PageMethods.GetBankLiveTransactions(function (res) {

                console.log("RAW RESPONSE:", res); // 🔍 debug

                let data = res.d || res;   // ✅ VERY IMPORTANT FIX

                let track = document.getElementById("feedTrack");

                let html = "";

                // ✅ handle null / error
                if (!data || data.error) {
                    track.innerHTML = "<div>No Live Data</div>";
                    return;
                }

                // ✅ if not array, convert
                if (!Array.isArray(data)) {
                    data = Object.values(data);
                }

                data.forEach(function (txn) {

                    let statusClass = "feed-success";

                    if (txn.status && txn.status.toLowerCase().includes("fail"))
                        statusClass = "feed-failed";

                    html += `
            <div class="feed-item">
                <span>📱 ${txn.mobile}</span>
                <span class="${statusClass} live-pulse">
                    ₹ ${parseFloat(txn.amount).toFixed(2)}
                </span>
                <span>${txn.status}</span>
            </div>
            `;
                });

                track.innerHTML = html;

            }, function (err) {
                console.error("AJAX ERROR:", err);
            });

        }

        setInterval(loadLiveFeed, 5000);
        loadLiveFeed();


    </script>

</asp:Content>