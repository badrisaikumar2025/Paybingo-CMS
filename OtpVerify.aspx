<%@ Page Language="C#" AutoEventWireup="true" CodeFile="OtpVerify.aspx.cs" Inherits="OtpVerify" %>

<!DOCTYPE html>
<html>
    <head runat="server">
        <title>OTP Verification</title>
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
        <style>
            /* RESET */
            *{
                box-sizing:border-box;

            }
            
            html,body{
                height:100%;
                margin:0;
                font-family:Segoe UI, sans-serif;

            }
            /* BACKGROUND */
            body{
                background:linear-gradient(rgba(5,15,40,.65),rgba(5,15,40,.75)),url('assets/Home/CMSOTP1.png');
                background-size:cover;
                background-position:center;
                background-repeat:no-repeat;

            }
            /* CENTER */
            .page-center{
                min-height:100vh;
                display:flex;
                justify-content:center;
                align-items:center;

            }
            /* CARD */
            .card{
                width:420px;
                padding:45px;
                text-align:center;
                border-radius:26px;
                background:rgba(255,255,255,0.08);
                backdrop-filter:blur(28px);
                -webkit-backdrop-filter:blur(28px);
                border:1px solid rgba(255,255,255,0.18);
                box-shadow:0 30px 80px rgba(0,0,0,.65),
                    inset 0 1px 0 rgba(255,255,255,.15);
                animation:fadeUp .5s ease;

            }
            
            /* LOGO */
            
            .logo{
                width:280px;
                height:140px;
                object-fit:contain;
                display:block;
                margin:0 auto 20px auto;

            }
            
            /* TEXT */
            h2{
                margin-bottom:8px;
                font-weight:700;
                color:#ffffff;
                letter-spacing:.5px;

            }
            
            p{
                color:#cbd5f5;
                font-size:14px;
                margin-bottom:10px;

            }
            /* OTP */
            
            .otp-boxes{
                display:flex;
                justify-content:center;
                gap:12px;
                margin-top:28px;

            }
            
            .otp-input{
                width:55px;
                height:65px;
                font-size:26px;
                font-weight:700;
                text-align:center;
                border-radius:14px;
                border:1px solid rgba(255,255,255,.25);
                background:rgba(255,255,255,.12);
                color:white;
                transition:.25s;

            }
            
            .otp-input:focus{
                outline:none;
                border-color:#3b82f6;
                box-shadow:0 0 18px rgba(59,130,246,.7);
                transform:scale(1.05);
                background:rgba(255,255,255,.18);

            }
            
            /* BUTTON */
            
            button{
                
                width:100%;
                height:54px;
                margin-top:32px;
                border:none;
                border-radius:14px;
                background:linear-gradient(135deg,#3b82f6,#2563eb);
                color:white;
                font-size:18px;
                font-weight:600;
                cursor:pointer;
                transition:.3s;

            }
            
            button:hover{
                transform:translateY(-2px);
                box-shadow:0 20px 40px rgba(37,99,235,.45);

            }
            button:active{
                transform:scale(.97);

            }
            
            /* ANIMATION */
            
            @keyframes fadeUp{
                from{
                    opacity:0;
                    transform:translateY(20px);

                }
                
                to{
                    opacity:1;
                    transform:translateY(0);

                }

            }

.otp-timer{
margin-top:14px;
font-size:14px;
color:#cbd5f5;
}

.resend a{
color:#60a5fa;
font-weight:600;
text-decoration:none;
}

.resend a:hover{
text-decoration:underline;
}


/* SWEET ALERT GLASS POPUP */

/* SWEET ALERT GLASS POPUP */

.swal2-popup{

background:linear-gradient(145deg,#f0f6ff,#e6eefc) !important;

backdrop-filter:blur(22px);
-webkit-backdrop-filter:blur(22px);

border-radius:30px !important;

border:1px solid rgba(255,255,255,.6);

box-shadow:
0 35px 95px rgba(37,99,235,.35),
inset 0 1px 0 rgba(255,255,255,.9);

padding:42px 38px;

font-family:Segoe UI, sans-serif;

}

/* TITLE */

.swal2-title{
font-size:28px !important;
font-weight:700;
color:#1e293b;
}

/* TEXT */

.swal2-html-container{
font-size:15px;
color:#475569;
}

/* CHANGE SUCCESS ICON COLOR */

.swal2-icon.swal2-success{
border-color:#2563eb !important;
color:#2563eb !important;
}

.swal2-success-ring{
border-color:rgba(37,99,235,.3) !important;
}

.swal2-success-line-tip,
.swal2-success-line-long{
background-color:#2563eb !important;
}

/* ICON SIZE */

.swal2-icon{
transform:scale(1.2);
margin-bottom:10px;
}

/* POPUP ANIMATION */

.swal2-show{
animation:popupGlass .35s ease;
}

@keyframes popupGlass{

0%{
opacity:0;
transform:scale(.85);
}

100%{
opacity:1;
transform:scale(1);
}

}
</style>

</head>

<body>

<form runat="server" autocomplete="off">

<div class="page-center">

<div class="card">

<img src="assets/logo/otp_logo_HD.png" class="logo">

<h2>OTP Verification</h2>
<p>Enter the 6-digit code sent to your mobile</p>

<div class="otp-boxes">
<input class="otp-input" maxlength="1">
<input class="otp-input" maxlength="1">
<input class="otp-input" maxlength="1">
<input class="otp-input" maxlength="1">
<input class="otp-input" maxlength="1">
<input class="otp-input" maxlength="1">
</div>

<button type="button" id="btnVerify">Verify OTP</button>

    <div class="otp-timer">
OTP expires in <span id="timer">60</span>s
</div>

<div class="resend">
<a href="#" id="resendOTP">Resend OTP</a>
</div>

</div>

</div>

</form>

<script>

    /* OTP JS */

    const inputs = document.querySelectorAll(".otp-input");
    const btn = document.getElementById("btnVerify");

    if (inputs.length > 0) {
        inputs[0].focus();
    }

    inputs.forEach((input, index) => {

        input.addEventListener("input", function () {

            this.value = this.value.replace(/[^0-9]/g, '');

            let val = this.value;

            if (val.length === 1) {

                // show briefly
                setTimeout(() => {
                    this.type = "password";
                }, 500);

                this.type = "text";
            }

            if (this.value.length === 1 && index < inputs.length - 1) {
                inputs[index + 1].focus();
            }

            checkAutoSubmit();
        });

        input.addEventListener("keydown", function (e) {

            if (e.key === "Backspace" && this.value === "" && index > 0) {
                inputs[index - 1].focus();
            }

        });

    });

    let time = 60;

    setInterval(function () {

        if (time > 0) {

            time--;

            document.getElementById("timer").innerText = time;

        }

    }, 1000);

    document.addEventListener("paste", function (e) {

        let paste = (e.clipboardData || window.clipboardData).getData("text").trim();

        if (paste.length === 6 && /^[0-9]+$/.test(paste)) {

            inputs.forEach((box, i) => {
                box.value = paste[i] || "";
            });

            checkAutoSubmit();
        }

    });

    function checkAutoSubmit() {

        let otp = "";

        inputs.forEach(box => {
            otp += box.value;
        });

        if (otp.length === 6) {
            verifyOTP(otp);
        }

    }

    btn.addEventListener("click", function () {

        let otp = "";

        inputs.forEach(box => {
            otp += box.value;
        });

        if (otp.length !== 6) {

            Swal.fire({
                icon: "warning",
                title: "Enter complete OTP"
            });

            return;
        }

        verifyOTP(otp);

    });

    function verifyOTP(otp) {

        btn.disabled = true;

        $.ajax({

            type: "POST",
            url: "OtpVerify.aspx/VerifyOTP",
            data: JSON.stringify({ otp: otp }),
            contentType: "application/json; charset=utf-8",
            dataType: "json",

            success: function (res) {

                if (res.d && res.d.success) {

                    let title = "OTP Verified";
                    let message = "Redirecting...";

                    if (res.d.redirect && res.d.redirect.includes("ResetPassword")) {

                        title = "OTP Verified";
                        message = "You can now reset your password";

                    } else {

                        title = "Login Verified";
                        message = "Redirecting to dashboard";

                    }

                    Swal.fire({
                        icon: "success",
                        title: title,
                        text: message,
                        timer: 1400,
                        timerProgressBar: true,
                        showConfirmButton: false
                    });

                    setTimeout(function () {

                        window.location = res.d.redirect;

                    }, 1400);
                } else {

                    btn.disabled = false;

                    inputs.forEach(box => box.value = "");
                    inputs[0].focus();

                    Swal.fire({

                        icon: "error",

                        title: "Invalid OTP",

                        text: "Please enter the correct verification code",

                        confirmButtonColor: "#2563eb"

                    });

                }

            },

            error: function () {

                btn.disabled = false;

                Swal.fire({
                    icon: "error",
                    title: "Server Error"
                });

            }

        });

    }

</script>

</body>
</html>