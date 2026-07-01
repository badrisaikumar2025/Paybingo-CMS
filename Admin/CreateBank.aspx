<%@ Page Language="C#" AutoEventWireup="true"
CodeFile="CreateBank.aspx.cs"
Inherits="Admin_CreateBank"
MasterPageFile="~/Admin/AdminMaster.master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <style>

/* BACKGROUND */

body {
    background: #020617;
}

/* WRAPPER */

.bank-wrapper {
    max-width: 700px;
    margin: 60px auto;
}

/* GLASS CARD */

.bank-card {
    padding: 35px;
    border-radius: 20px;

    background: rgba(15,23,42,0.85);
    backdrop-filter: blur(30px);

    border: 1px solid rgba(56,189,248,0.25);

    box-shadow:
        0 25px 80px rgba(0,0,0,0.8),
        0 0 30px rgba(56,189,248,0.25);

    animation: fadeUp .5s ease;
}

/* TITLE */

.bank-title {
    font-size: 26px;
    font-weight: 700;
    color: #e2e8f0;
    margin-bottom: 20px;
}

/* INPUT */

.bank-input {
    width: 100%;
    height: 50px;

    border-radius: 12px;
    border: 1px solid rgba(255,255,255,0.08);

    background: #020617;
    color: white;

    padding: 0 15px;
    margin-bottom: 15px;

    outline: none;
    transition: .3s;
}

.bank-input:focus {
    border: 1px solid #3b82f6;
    box-shadow: 0 0 10px rgba(59,130,246,0.6);
}

/* BUTTON */

.bank-btn {
    width: 100%;
    height: 50px;

    border-radius: 12px;
    border: none;

    background: linear-gradient(135deg,#22c55e,#16a34a);
    color: white;

    font-weight: 600;
    font-size: 16px;

    transition: .3s;
}

.bank-btn:hover {
    transform: translateY(-2px);
    box-shadow: 0 10px 25px rgba(34,197,94,0.6);
}

/* TABLE */

.bank-table {
    margin-top: 25px;
    width: 100%;
    border-collapse: collapse;
    overflow: hidden;
    border-radius: 15px;
}

.bank-table th {
    background: rgba(56,189,248,0.15);
    color: #38bdf8;
    padding: 12px;
}

.bank-table td {
    background: rgba(15,23,42,0.7);
    color: #e2e8f0;
    padding: 12px;
}

.bank-table tr:hover td {
    background: rgba(30,41,59,0.9);
}

/* POPUP SAME AS HOME */

.otp-popup-card {
    background: rgba(15,23,42,0.85) !important;
    backdrop-filter: blur(30px) !important;
    border-radius: 22px !important;
    padding: 40px 25px !important;
    border: 1px solid rgba(56,189,248,0.25) !important;
    box-shadow:
        0 30px 90px rgba(0,0,0,0.8),
        0 0 35px rgba(56,189,248,0.25);
}

.otp-icon {
    width: 90px;
    height: 90px;
    margin: 0 auto 20px;
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    background: rgba(34,197,94,0.15);
    color: #22c55e;
    font-size: 40px;
    box-shadow: 0 0 25px rgba(34,197,94,0.5);
    animation: pulseGlow 1.5s infinite;
}

.login-error-popup {
    background: rgba(15,23,42,0.85) !important;
    backdrop-filter: blur(25px);
    border-radius: 20px !important;
}

.login-error-btn {
    background: linear-gradient(135deg,#ef4444,#dc2626) !important;
}

/* ANIMATION */

@keyframes fadeUp {
    from { opacity:0; transform: translateY(20px); }
    to { opacity:1; transform: translateY(0); }
}

@keyframes pulseGlow {
    0% { transform: scale(1); }
    50% { transform: scale(1.08); }
    100% { transform: scale(1); }
}

</style>

<div class="bank-wrapper">

    <div class="bank-card">

        <div class="bank-title">
            <i class="fa fa-building-columns"></i> Add Bank
        </div>

        <input id="txtBankName" class="bank-input" placeholder="Enter Bank Name" />

        <button id="btnAddBank" class="bank-btn">
            Add Bank
        </button>

    </div>

    <div class="bank-card mt-4">

        <div class="bank-title">
            <i class="fa fa-list"></i> Bank List
        </div>

        <table id="tblBanks" class="bank-table"></table>

    </div>

</div>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

<script>

    $(document).ready(function () {

        loadBanks();

        $("#btnAddBank").click(function () {

            let name = $("#txtBankName").val().trim();

            // ⚠ EMPTY
            if (!name) {

                Swal.fire({
                    icon: "warning",
                    title: "Enter Bank Name",
                    timer: 1500,
                    showConfirmButton: false
                });

                return;
            }

            $.ajax({
                type: "POST",
                url: "CreateBank.aspx/AddBank",
                data: JSON.stringify({ name: name }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",

                success: function () {

                    // ✅ SUCCESS POPUP
                    Swal.fire({
                        html: `
                        <div class="otp-popup">
                            <div class="otp-icon">
                                <i class="fa fa-check"></i>
                            </div>
                            <h2>Bank Added</h2>
                            <p>Bank added successfully</p>
                        </div>
                    `,
                        showConfirmButton: false,
                        timer: 1500,
                        backdrop: "rgba(2,6,23,0.85)",
                        customClass: {
                            popup: "otp-popup-card"
                        }
                    });

                    $("#txtBankName").val("");
                    loadBanks();
                },

                error: function () {

                    // ❌ ERROR POPUP
                    Swal.fire({
                        title: "Error",
                        html: "<i class='fa fa-xmark'></i><p>Something went wrong</p>",
                        confirmButtonText: "OK",
                        background: "transparent",
                        color: "#fff",
                        backdrop: "rgba(2,6,23,0.75)",
                        customClass: {
                            popup: "login-error-popup",
                            confirmButton: "login-error-btn"
                        }
                    });

                }
            });

        });


        function loadBanks() {

            $.ajax({
                type: "POST",
                url: "CreateBank.aspx/GetBanks",
                data: '{}',
                contentType: "application/json; charset=utf-8",
                dataType: "json",

                success: function (res) {

                    let table = $("#tblBanks");
                    table.empty();

                    table.append("<tr><th>ID</th><th>Name</th></tr>");

                    res.d.forEach(function (b) {
                        table.append(`
                        <tr>
                            <td>${b.id}</td>
                            <td>${b.name}</td>
                        </tr>
                    `);
                    });

                },

                error: function () {

                    // ❌ LOAD ERROR
                    Swal.fire({
                        title: "Error",
                        html: "<i class='fa fa-xmark'></i><p>Failed to load banks</p>",
                        confirmButtonText: "OK",
                        background: "transparent",
                        color: "#fff",
                        backdrop: "rgba(2,6,23,0.75)",
                        customClass: {
                            popup: "login-error-popup",
                            confirmButton: "login-error-btn"
                        }
                    });

                }
            });

        }

    });

</script>

</asp:Content>