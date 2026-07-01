<%@ Page Title="Admin Wallet" Language="C#" MasterPageFile="~/Admin/AdminMaster.master" AutoEventWireup="true" CodeFile="AdminWallet.aspx.cs" Inherits="Admin_AdminWallet" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    
    <div class="container-fluid mt-4">
        <h3 class="fw-bold mb-4">
            
            <i class="fa fa-wallet text-primary"></i> CMS Wallet

        </h3>
        
        <div class="row g-4">
            
            <!-- BALANCE -->
            
            <div class="col-md-4">
                <div class="card p-4 text-center shadow">
                    <span>Current Wallet Balance</span>
                    <h2><asp:Label ID="lblWalletBalance" runat="server"></asp:Label></h2>

                </div>
                
                <asp:Button ID="btnCheckBalance" runat="server"
                    Text="Check Balance"
                    CssClass="btn btn-primary w-100 mt-2"
                    OnClientClick="checkBalance(); return false;" />

            </div>
            
            <!-- ADD MONEY -->
            <div class="col-md-4">
                <div class="card p-4 shadow">
                    <h5>Add Money</h5>
                    
                    <asp:TextBox ID="txtAmount" runat="server"
                        CssClass="form-control mb-3"
                        placeholder="Enter Amount"></asp:TextBox>
                    <asp:Button ID="btnAdd" runat="server"
                        Text="Add Money"
                        CssClass="btn btn-success w-100"
                        OnClick="btnAdd_Click" />

                </div>

            </div>
            
            <!-- WITHDRAW -->
            <div class="col-md-4">
                <div class="card p-4 shadow">
                    <h5>Withdraw Money</h5>
                    <asp:TextBox ID="txtWithdraw" runat="server"
                        CssClass="form-control mb-3"
                        placeholder="Enter Amount"></asp:TextBox>
                    <asp:Button ID="btnWithdraw" runat="server"
                        Text="Withdraw"
                        CssClass="btn btn-danger w-100"
                        OnClick="btnWithdraw_Click" />

                </div>

            </div>

        </div>
        
        <!-- HISTORY -->
        <div class="card mt-5 p-4 shadow">
            <h5 class="fw-bold mb-3">Wallet History</h5>
            <asp:GridView ID="gvWallet" runat="server"
                CssClass="table table-bordered table-striped"
                AutoGenerateColumns="False">
                
                <Columns>
                    <asp:BoundField DataField="txn_id" HeaderText="Txn ID"/>
                    <asp:BoundField DataField="type" HeaderText="Type"/>
                    <asp:BoundField DataField="amount" HeaderText="Amount" DataFormatString="₹ {0:N2}"/>
                    <asp:BoundField DataField="created_on" HeaderText="Date" DataFormatString="{0:dd-MMM-yyyy hh:mm tt}"/>

                </Columns>

            </asp:GridView>

        </div>

    </div>
    
    <script>

        // Fix voice loading issue
        speechSynthesis.onvoiceschanged = function () {
            speechSynthesis.getVoices();
        };

        //  CHECK BALANCE AJAX
        function checkBalance() {
            $.ajax({
                type: "POST",
                url: "AdminWallet.aspx/GetBalance",
                data: '{}',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (res) {
                    let balance = res.d;
                    Swal.fire({
                        title: "Wallet Balance",
                        text: "₹ " + balance,
                        confirmButtonText: "OK"
                    });

                   speakHindi(balance);
               },

               error: function () {
                   Swal.fire("Error", "Unable to fetch balance", "error");
               }
           });
       }

       //  PERFECT HINDI SPEAK FUNCTION
       function speakHindi(amount) {

           amount = parseFloat(amount);

           if (isNaN(amount)) return;

           let msgText = "";

           if (amount === 0) {
               msgText = "आपके वॉलेट में कोई बैलेंस नहीं है";
           } else {
               msgText = "आपके वॉलेट में " + amount.toFixed(2) + " रुपये उपलब्ध हैं";
           }

           let msg = new SpeechSynthesisUtterance(msgText);

           msg.lang = "hi-IN";
           msg.rate = 0.85;
           msg.pitch = 1;

           // Select Hindi voice
           let voices = speechSynthesis.getVoices();
           for (let i = 0; i < voices.length; i++) {
               if (voices[i].lang === "hi-IN") {
                   msg.voice = voices[i];
                   break;

               }
           }

           speechSynthesis.cancel();
           speechSynthesis.speak(msg);
       }

   </script>

</asp:Content>