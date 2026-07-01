<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/AdminMaster.master" AutoEventWireup="true" CodeFile="AdminDashboard.aspx.cs" Inherits="Admin_AdminDashboard" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    
    <asp:ScriptManager runat="server" EnablePageMethods="true" />
    
    <div class="container-fluid mt-4">
        
        <!-- HEADER -->
        
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h3 class="fw-bold m-0 text-dark">
                <i class="fa fa-chart-pie text-primary"></i> Dashboard

            </h3>
            <span class="badge bg-dark px-3 py-2">
                <%= DateTime.Now.ToString("dddd, dd MMM yyyy") %>

            </span>

        </div>
        
        <!-- KPI ROW -->
        
        <div class="row g-4 mb-4">
            
            <!-- Collection -->
 <div class="col-xl-4">
        <div class="dash-card blue text-center h-100">
            <span>Collection</span>
            <h2 id="kpiCollection">₹ 0.00</h2>
        </div>
    </div>

    <!-- Settled -->
    <div class="col-xl-4">
        <div class="dash-card green text-center h-100">
            <span>Settled</span>
            <h2 id="kpiSettled">₹ 0.00</h2>
        </div>
    </div>

    <!--  WALLET MOVED HERE -->
    <div class="col-xl-4">
        <div class="dash-card teal text-center h-100">
            <span>CMS Wallet</span>
            <h2 id="kpiWallet">₹ 0.00</h2>

            <div class="mt-3">
                <a href="AdminWallet.aspx" class="btn btn-light btn-sm fw-bold">
                    <i class="fa fa-wallet"></i> Open Wallet
                </a>
            </div>
        </div>
    </div>

</div>


<!-- WALLET + SETTLEMENT -->





<div class="row g-4 mb-4">

    <div class="col-12">

        <div class="dash-card teal h-100">

            <div class="d-flex justify-content-between align-items-center">

                <div>
                    <span>Pending Settlement to Bank</span>
                    <h2>
                        <asp:Label ID="lblPendingWithdraw" runat="server"></asp:Label>
                    </h2>
                </div>

                <i class="fa fa-hand-holding-usd fa-2x opacity-75"></i>

            </div>

            <div class="mt-3">
                <a href="WithdrawalApproval.aspx" class="btn btn-light btn-sm fw-bold">
                    <i class="fa fa-cog"></i> Manage Withdraw Request
                </a>
            </div>

        </div>

    </div>

</div>

    

   <div class="row g-4 mb-4 align-items-stretch">

<!-- SYSTEM HEALTH -->
       
       <div class="col-xl-4">
           
           <div class="table-card h-100">
               <h5 class="fw-bold mb-4">
                   <i class="fa fa-heart-pulse text-danger"></i> System Health

               </h5>
               
               <div class="health-item">
                   <span><i class="fa fa-database me-2 text-primary"></i> Database</span>
                   <span class="health-ok">Online</span>

               </div>
               
               <div class="health-item">
                   <span><i class="fa fa-cogs me-2 text-success"></i> Settlement Worker</span>
                   <span class="health-ok">Running</span>

               </div>
               
               <div class="health-item">
                   <span><i class="fa fa-layer-group me-2 text-info"></i> Transaction Queue</span>
                   <span class="health-ok">Active</span>

               </div>
               
               <div class="health-item">
                   <span><i class="fa fa-plug me-2 text-warning"></i> API Gateway</span>
                   <span class="health-warning">Pending</span>

               </div>

           </div>

       </div>
       
       <!-- SYSTEM LOAD -->
       
       <div class="col-xl-8">
           
           <div class="table-card h-100">
               
               <h5 class="fw-bold mb-4">
                   <i class="fa fa-chart-line text-success"></i> System Load

               </h5>
               
               <div class="row text-center">
                   
                   <div class="col-md-4">
                       
                       <div class="load-box">
                           
                           <div class="load-circle cpu">
                               <span id="cpuLoad">12%</span>

                           </div>
                           
                           <div class="mt-2 fw-semibold">CPU</div>


                       </div>


                   </div>
                   
                   <div class="col-md-4">
                       
                       <div class="load-box">
                           
                           <div class="load-circle ram">
                               <span id="ramLoad">38%</span>

                           </div>

<div class="mt-2 fw-semibold">Memory</div>

</div>

</div>

<div class="col-md-4">

<div class="load-box">

<div class="load-circle txn">
<span id="txnLoad">120</span>
</div>

<div class="mt-2 fw-semibold">Txn / min</div>

</div>

</div>

</div>

</div>

</div>

</div>


<!-- TODAY / YESTERDAY / MONTH / ALLTIME -->

<div class="row g-4 mb-4">

<div class="col-xl-3 col-lg-6">
<div class="dash-card blue h-100">
<span>Today</span>
<h2><asp:Label ID="lblToday" runat="server"></asp:Label></h2>
</div>
</div>

<div class="col-xl-3 col-lg-6">
<div class="dash-card green h-100">
<span>Yesterday</span>
<h2><asp:Label ID="lblYesterday" runat="server"></asp:Label></h2>
</div>
</div>

<div class="col-xl-3 col-lg-6">
<div class="dash-card purple h-100">
<span>Month Till Date</span>
<h2><asp:Label ID="lblMonth" runat="server"></asp:Label></h2>
</div>
</div>

<div class="col-xl-3 col-lg-6">
<div class="dash-card orange h-100">
<span>Year Till Date</span>
<h2><asp:Label ID="lblAllTime" runat="server"></asp:Label></h2>
</div>
</div>

</div>


<!-- LIVE FEED -->

<div class="table-card mb-4">

<h5 class="fw-bold mb-3">
<i class="fa fa-bolt text-warning"></i> Live Transactions
</h5>

<div class="live-feed" id="liveFeed">
<div class="feed-track" id="feedTrack"></div>
</div>

</div>


<!-- RECENT TRANSACTIONS -->

<div class="row mt-4">

<div class="col-md-12">

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
<asp:BoundField DataField="BankName" HeaderText="Bank" />

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

</div>

</div>


<script>

    

    setInterval(loadKPIs, 10000);
    loadKPIs();

    function animateValue(element, start, end, duration, isMoney = true) {

        let startTimestamp = null;

        const step = (timestamp) => {

            if (!startTimestamp) startTimestamp = timestamp;

            const progress = Math.min((timestamp - startTimestamp) / duration, 1);

            let value = progress * (end - start) + start;

            if (isMoney)
                element.innerText = "₹ " + value.toFixed(2);
            else
                element.innerText = value.toFixed(2);

            if (progress < 1) {
                window.requestAnimationFrame(step);
            }

        };

        window.requestAnimationFrame(step);

    }

    function loadKPIs() {

        PageMethods.GetKPIs(function (d) {

            animateValue(
                document.getElementById("kpiCollection"),
                0,
                parseFloat(d.collection),
                800
            );



            animateValue(
                document.getElementById("kpiSettled"),
                0,
                parseFloat(d.settled),
                800
            );
            animateValue(
                document.getElementById("kpiWallet"),
                0,
                parseFloat(d.wallet || 0),
                800
            );

           

        });

    }

    setInterval(loadKPIs, 10000);
    loadKPIs();


    function loadSystemHealth() {

        PageMethods.GetSystemHealth(function (d) {

            document.getElementById("cpuLoad").innerText = d.cpu + "%";
            document.getElementById("ramLoad").innerText = d.ram + "%";
            document.getElementById("txnLoad").innerText = d.txn;

        });

    }

    setInterval(loadSystemHealth, 5000);
    loadSystemHealth();

    function loadLiveFeed() {

        PageMethods.GetLiveTransactions(function (data) {

            let track = document.getElementById("feedTrack");

            if (!track) return;

            let html = "";

            data.forEach(function (txn) {

                let statusClass = "feed-success";

                if (txn.status.toLowerCase().includes("fail"))
                    statusClass = "feed-failed";

                html += `
<div class="feed-item">
<span>📱 ${txn.mobile}</span>
<span class="${statusClass}">
₹ ${parseFloat(txn.amount).toFixed(2)}
</span>
<span>${txn.status}</span>
</div>
`;

            });

            track.innerHTML = html;

        });

    }

    setInterval(loadLiveFeed, 8000);

    loadLiveFeed();;

</script>

</asp:Content>