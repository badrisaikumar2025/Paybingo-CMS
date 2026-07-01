<%@ Page Language="C#" AutoEventWireup="true"
CodeFile="CreateAdmin.aspx.cs"
Inherits="Admin_CreateAdmin"
MasterPageFile="~/Admin/AdminMaster.master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <style>

     body {
    background: #020617;
     }

     /* WRAPPER */

    .admin-wrapper {
    min-height: 80vh;
    display: flex;
    justify-content: center;
    align-items: center;
    }

    /* GLASS CARD */

    .admin-card {
         width: 420px;
         padding: 45px 35px;
         border-radius: 22px;
         background: rgba(15,23,42,0.85);
         backdrop-filter: blur(30px);
         border: 1px solid rgba(56,189,248,0.25);
         box-shadow:
         0 30px 90px rgba(0,0,0,0.8),
         0 0 35px rgba(56,189,248,0.25);
         animation: fadeUp .5s ease;

    }
    
    /* TITLE */
    
    .admin-card h3 {
        
        text-align: center;
        font-size: 26px;
        
        font-weight: 700;
        margin-bottom: 25px;
        color: #e2e8f0;

    }
    
    /* INPUT */
    
    .form-input {
    width: 100%;
    height: 50px;
    margin-bottom: 18px;

    border-radius: 12px;
    border: 1px solid rgba(255,255,255,0.08);

    background: #020617;
    color: #fff;

    padding: 0 15px;
    outline: none;

    transition: .3s;
}

.form-input:focus {
    border: 1px solid #3b82f6;
    box-shadow: 0 0 8px rgba(59,130,246,0.6);
}

/* BUTTON */

.btn-primary {
    width: 100%;
    height: 50px;

    border: none;
    border-radius: 12px;

    background: linear-gradient(135deg,#2563eb,#1d4ed8);

    color: white;
    font-weight: 600;
    font-size: 16px;

    transition: .3s;
}

.btn-primary:hover {
    transform: translateY(-2px);
    box-shadow: 0 10px 25px rgba(37,99,235,0.6);
}

/* ICON TITLE */

.admin-card h3::before {
    content: "🔐 ";
}

/* ANIMATION */

@keyframes fadeUp {
    from {
        opacity: 0;
        transform: translateY(25px);
    }
    to {
        opacity: 1;
        transform: translateY(0);
    }
}

/* PANEL TRANSITION */

#adminPanel {
    animation: fadeUp .5s ease;
}


/* ===== SWEET ALERT GLASS POPUP (FIX) ===== */

.otp-popup-card {
    background: rgba(15,23,42,0.85) !important;
    backdrop-filter: blur(30px) !important;
    border-radius: 22px !important;
    padding: 40px 25px !important;

    border: 1px solid rgba(56,189,248,0.25) !important;

    box-shadow:
        0 30px 90px rgba(0,0,0,0.8),
        0 0 35px rgba(56,189,248,0.25) !important;
}

/* ICON */

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

    box-shadow:
        0 0 25px rgba(34,197,94,0.5),
        inset 0 0 15px rgba(34,197,94,0.2);

    animation: pulseGlow 1.5s infinite;
}

/* TEXT */

.otp-popup h2 {
    color: #e2e8f0;
    font-size: 26px;
    font-weight: 700;
    margin-bottom: 10px;
}

.otp-popup p {
    color: #94a3b8;
    font-size: 15px;
}

/* ERROR POPUP */

.login-error-popup {
    background: rgba(15,23,42,0.85) !important;
    backdrop-filter: blur(25px);
    border-radius: 20px !important;

    border: 1px solid rgba(255,255,255,0.08);

    box-shadow:
        0 30px 80px rgba(0,0,0,0.7),
        inset 0 1px 0 rgba(255,255,255,0.08);
}

.login-error-popup i {
    font-size: 55px;
    color: #ef4444;
    background: rgba(239,68,68,0.15);
    border-radius: 50%;
    width: 90px;
    height: 90px;
    display: flex;
    align-items: center;
    justify-content: center;
    margin: 20px auto;
}

.login-error-btn {
    background: linear-gradient(135deg,#ef4444,#dc2626) !important;
    border-radius: 10px !important;
    padding: 10px 28px !important;
}

/* ANIMATION */

@keyframes pulseGlow {
    0% { transform: scale(1); }
    50% { transform: scale(1.08); }
    100% { transform: scale(1); }
}

</style>

<div class="admin-wrapper">

<div id="keyPanel" class="admin-card">

<h3><i class="fa fa-shield-halved"></i> Security Verification</h3>

<input id="txtKey" placeholder="Enter Security Key" class="form-input"/>

<button type="button" id="btnVerify" class="btn-primary">
Verify Key
</button>

</div>


<div id="adminPanel" class="admin-card" style="display:none">

<h3><i class="fa fa-user-plus"></i> Create New Admin</h3>

<input id="txtName" placeholder="Full Name" class="form-input"/>
<input id="txtEmail" placeholder="Email Address" class="form-input"/>
<input id="txtPhone" placeholder="Phone Number" class="form-input"/>
<input id="txtPassword" type="password" placeholder="Password" class="form-input"/>

<button type="button" id="btnCreate" class="btn-primary">
Create Admin
</button>

</div>

</div>


<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

<script>

    let verifiedKey = "";

    $("#btnVerify").click(function () {

        let key = $("#txtKey").val().trim();

        if (!key) {

            Swal.fire({
                icon: "warning",
                title: "Enter Security Key",
                timer: 1500,
                showConfirmButton: false
            });

            return;
        }

        $.ajax({

            type: "POST",
            url: "CreateAdmin.aspx/VerifyKey",
            data: JSON.stringify({ key: key }),
            contentType: "application/json",
            dataType: "json",

            success: function (res) {

                if (res.d.success) {

                    verifiedKey = key;

                    $("#keyPanel").hide();
                    $("#adminPanel").show();

                    // ✅ SUCCESS GLASS POPUP (same style)
                    Swal.fire({
                        html: `
                        <div class="otp-popup">
                            <div class="otp-icon">
                                <i class="fa fa-shield-check"></i>
                            </div>
                            <h2>Access Granted</h2>
                            <p>Security key verified successfully</p>
                        </div>
                    `,
                        showConfirmButton: false,
                        timer: 1500,
                        backdrop: "rgba(2,6,23,0.85)",
                        customClass: {
                            popup: "otp-popup-card"
                        }
                    });

                }
                else {

                    // ❌ ERROR POPUP (same red glass)
                    Swal.fire({
                        title: "Invalid Key",
                        html: "<i class='fa fa-xmark'></i><p>Security key is incorrect</p>",
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

            }

        });

    });


    $("#btnCreate").click(function () {

        let name = $("#txtName").val();
        let email = $("#txtEmail").val();
        let phone = $("#txtPhone").val();
        let password = $("#txtPassword").val();

        if (!name || !email || !phone || !password) {

            Swal.fire({
                icon: "warning",
                title: "Fill all fields",
                timer: 1500,
                showConfirmButton: false
            });

            return;

        }

        $.ajax({

            type: "POST",
            url: "CreateAdmin.aspx/CreateAdmin",
            data: JSON.stringify({
                key: verifiedKey,
                name: name,
                email: email,
                phone: phone,
                password: password
            }),
            contentType: "application/json",
            dataType: "json",

            success: function (res) {

                if (res.d.success) {

                    // ✅ SUCCESS POPUP (same green style)
                    Swal.fire({
                        html: `
                        <div class="otp-popup">
                            <div class="otp-icon">
                                <i class="fa fa-check"></i>
                            </div>
                            <h2>Admin Created</h2>
                            <p>New admin added successfully</p>
                        </div>
                    `,
                        showConfirmButton: false,
                        timer: 1600,
                        backdrop: "rgba(2,6,23,0.85)",
                        customClass: {
                            popup: "otp-popup-card"
                        }
                    });

                    $("#txtName,#txtEmail,#txtPhone,#txtPassword").val("");

                }
                else {

                    Swal.fire({
                        title: "Error",
                        html: `<i class='fa fa-xmark'></i><p>${res.d.message}</p>`,
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

            }

        });

    });

</script>

</asp:Content>