<%@ Page Language="C#" AutoEventWireup="true"
CodeFile="CreateUser.aspx.cs"
Inherits="Admin_CreateUser"
MasterPageFile="~/Admin/AdminMaster.master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
<style>

/* BACKGROUND */
body {
    background: #020617;
}

/* WRAPPER */
.user-wrapper {
    max-width: 600px;
    margin: 60px auto;
}

/* CARD */
.user-card {
    padding: 35px;
    border-radius: 22px;

    background: rgba(15,23,42,0.85);
    backdrop-filter: blur(30px);

    border: 1px solid rgba(56,189,248,0.25);

    box-shadow:
        0 25px 80px rgba(0,0,0,0.8),
        0 0 30px rgba(56,189,248,0.25);

    animation: fadeUp .5s ease;
}

/* TITLE */
.user-title {
    font-size: 26px;
    font-weight: 700;
    color: #e2e8f0;
    margin-bottom: 20px;
}

/* INPUT */
.user-input {
    width: 100%;
    height: 50px;
    margin-bottom: 15px;

    border-radius: 12px;
    border: 1px solid rgba(255,255,255,0.08);

    background: #020617;
    color: white;

    padding: 0 15px;
    outline: none;
}

.user-input:focus {
    border: 1px solid #3b82f6;
    box-shadow: 0 0 10px rgba(59,130,246,0.6);
}

/* BUTTON */
.user-btn {
    width: 100%;
    height: 50px;

    border-radius: 12px;
    border: none;

    background: linear-gradient(135deg,#2563eb,#1d4ed8);
    color: white;

    font-weight: 600;
    font-size: 16px;
}

/* POPUP (SAME AS HOME) */

.otp-popup-card {
    background: rgba(15,23,42,0.85) !important;
    backdrop-filter: blur(30px) !important;
    border-radius: 22px !important;
    padding: 40px 25px !important;
}

.otp-icon {
    width: 80px;
    height: 80px;
    margin: auto;
    border-radius: 50%;
    background: rgba(34,197,94,0.2);
    color: #22c55e;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 35px;
}

.login-error-popup {
    background: rgba(15,23,42,0.85) !important;
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

</style>


<div class="user-wrapper">

    <div class="user-card">

        <div class="user-title">
            <i class="fa fa-user-plus"></i> Create Bank User
        </div>
       

        <input id="txtEmail" class="user-input" placeholder="Email" />
        <input id="txtPhone" class="user-input" placeholder="Phone" />

        <select id="ddlBank" class="user-input"></select>

        <button id="btnCreateUser" class="user-btn">
            Create User
        </button>

    </div>

</div>


<!-- JS -->
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

<script>

    $(document).ready(function () {

        loadBanks();

        function loadBanks() {
            $.ajax({
                type: "POST",
                url: "CreateUser.aspx/GetBanks",
                data: '{}',
                contentType: "application/json",
                dataType: "json",

                success: function (res) {

                    let ddl = $("#ddlBank");
                    ddl.empty();

                    res.d.forEach(function (b) {
                        ddl.append(`<option value="${b.id}">${b.name}</option>`);
                    });
                },

                error: function () {
                    showError("Failed to load banks");
                }
            });
        }

        $("#btnCreateUser").click(function (e) {

            e.preventDefault();

            let email = $("#txtEmail").val().trim();
            let phone = $("#txtPhone").val().trim();
            let bankid = parseInt($("#ddlBank").val());

            if (!email || !phone) {
                showWarning("Enter Email & Phone");
                return;
            }

            $.ajax({
                type: "POST",
                url: "CreateUser.aspx/CreateUser",
                data: JSON.stringify({ email, phone, bankid }),
                contentType: "application/json",
                dataType: "json",

                success: function (res) {

                    if (res.d && res.d.success) {

                        // ✅ PREMIUM SUCCESS POPUP
                        Swal.fire({
                            html: `
                            <div class="otp-popup">
                                <div class="otp-icon">
                                    <i class="fa fa-check"></i>
                                </div>
                                <h2>User Created</h2>

                                <p><b>Email:</b> ${email}</p>
                                <p><b>Phone:</b> ${phone}</p>

                                <div style="margin-top:10px">
                                    <input id="pwdBox"
                                        value="${res.d.password}"
                                        style="width:100%;padding:10px;border-radius:8px;border:none" readonly/>
                                    
                                    <button id="copyBtn"
                                        style="margin-top:10px;width:100%;padding:10px;border:none;border-radius:8px;background:#22c55e;color:white">
                                        Copy Password
                                    </button>
                                </div>
                            </div>
                        `,
                            confirmButtonText: "Done",
                            backdrop: "rgba(2,6,23,0.85)",
                            customClass: { popup: "otp-popup-card" },

                            didOpen: () => {

                                document.getElementById("copyBtn").onclick = function () {

                                    let copyText = document.getElementById("pwdBox");
                                    copyText.select();
                                    document.execCommand("copy");

                                    Swal.fire({
                                        toast: true,
                                        position: 'top-end',
                                        icon: 'success',
                                        title: 'Copied!',
                                        showConfirmButton: false,
                                        timer: 1200
                                    });
                                };
                            }
                        });

                        $("#txtEmail,#txtPhone").val("");
                    }
                    else {
                        showError(res.d.message);
                    }
                },

                error: function () {
                    showError("User creation failed");
                }
            });

        });


        // 🔥 COMMON POPUPS

        function showWarning(msg) {
            Swal.fire({
                icon: "warning",
                title: msg,
                timer: 1500,
                showConfirmButton: false
            });
        }

        function showError(msg) {
            Swal.fire({
                title: "Error",
                html: `<p>${msg}</p>`,
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

</script>

</asp:Content>