<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ForgotPassword.aspx.cs" Inherits="ForgotPassword" %>

<!DOCTYPE html>
<html>
<head runat="server">

<title>Forgot Password</title>

<meta name="viewport" content="width=device-width, initial-scale=1">

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

     <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

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
background:
linear-gradient(rgba(5,15,40,.65),rgba(5,15,40,.75)),
url('assets/Home/CMSOTP1.png');

background-size:cover;
background-position:center;
background-repeat:no-repeat;
}

/* CENTER */

.page-center{
min-height:100vh;
display:flex;
align-items:center;
justify-content:center;
}

/* CARD (GLASS STYLE LIKE OTP PAGE) */

.card{

width:380px;
padding:40px;
text-align:center;

border-radius:22px;

background: rgba(15,23,42,0.85);

backdrop-filter: blur(30px);

border:1px solid rgba(56,189,248,0.25);

box-shadow:
0 30px 90px rgba(0,0,0,0.8),
0 0 30px rgba(56,189,248,0.25);

color:white;

animation:fadeUp .5s ease;

}
/* LOGO */

.logo{

width:70px;
height:70px;
object-fit:contain;

display:block;
margin:0 auto 15px auto;

}

/* TEXT */

h2{
margin-bottom:6px;
font-weight:700;
color:white;
}

p{
color:#cbd5f5;
font-size:14px;
}

/* INPUT */



.input{

width:100%;
height:46px;

margin-top:20px;

border-radius:10px;
border:1px solid rgba(255,255,255,0.1);

background: rgba(15,23,42,0.95);

padding-left:15px;

font-size:15px;

color:white;

outline:none;

transition:.3s;

}

.input::placeholder{
color:#94a3b8;
}

.input:focus{
border-color:#3b82f6;
box-shadow:0 0 12px rgba(59,130,246,.6);
}

/* BUTTON */

button{

width:100%;
height:50px;

margin-top:22px;

border:none;
border-radius:12px;

background: linear-gradient(135deg,#3b82f6,#2563eb);

color:white;

font-size:16px;
font-weight:600;

cursor:pointer;

box-shadow: 0 10px 25px rgba(59,130,246,0.5);

transition:.3s;

}

button:hover{
transform:translateY(-2px);
box-shadow:0 15px 35px rgba(59,130,246,0.8);
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


.swal2-title{
font-size:28px !important;
font-weight:700;
color:#1e293b;
}

.swal2-html-container{
font-size:15px;
color:#475569;
}

.swal2-container{
display:flex !important;
align-items:center !important;
justify-content:center !important;
}

.swal2-popup{

background:rgba(255,255,255,.90);

border-radius:26px !important;

box-shadow:
0 30px 100px rgba(0,0,0,.45);

padding:40px 35px;

font-family:Segoe UI, sans-serif;

}
.swal2-show{
animation:popupScale .35s ease;
}

@keyframes popupScale{

0%{
opacity:0;
transform:scale(.8);
}

100%{
opacity:1;
transform:scale(1);
}

}
.swal2-confirm{

background:linear-gradient(135deg,#2563eb,#1d4ed8) !important;

border-radius:12px !important;

padding:10px 26px !important;

font-weight:600;

box-shadow:0 8px 20px rgba(37,99,235,.4);

}

.icon-box{
    width:70px;
    height:70px;
    margin:0 auto 15px;

    border-radius:50%;

    display:flex;
    align-items:center;
    justify-content:center;

    background: rgba(59,130,246,0.15);
    color:#3b82f6;

    font-size:28px;

    box-shadow:
        0 0 20px rgba(59,130,246,0.6),
        inset 0 0 10px rgba(59,130,246,0.2);
}

/* SUCCESS POPUP */

.otp-success-card{
    background: rgba(15,23,42,0.85) !important;
    backdrop-filter: blur(30px);

    border-radius:22px !important;

    border:1px solid rgba(56,189,248,0.25);

    box-shadow:
        0 30px 90px rgba(0,0,0,0.8),
        0 0 30px rgba(56,189,248,0.25);

    padding:35px !important;
}

/* ICON */

.success-icon{
    width:80px;
    height:80px;
    margin:0 auto 15px;

    border-radius:50%;

    display:flex;
    align-items:center;
    justify-content:center;

    background: rgba(34,197,94,0.15);
    color:#22c55e;

    font-size:36px;

    box-shadow:
        0 0 25px rgba(34,197,94,0.6),
        inset 0 0 12px rgba(34,197,94,0.2);

    animation: pulseGlow 1.5s infinite;
}

/* TEXT */

.otp-success-popup h2{
    color:#e2e8f0;
    font-size:24px;
    margin-bottom:5px;
}

.otp-success-popup p{
    color:#94a3b8;
    font-size:14px;
}
</style>

</head>

<body>

<form runat="server">

<div class="page-center">

<div class="card">
    <div class="icon-box">
    <i class="fa fa-key"></i>
</div>


<h2>Forgot Password</h2>
<p>Enter your registered Email or Mobile</p>

<input id="txtUser" class="input" placeholder="Email or Mobile" autocomplete="off">

<button type="button" id="btnSend">Send OTP</button>

</div>

</div>

</form>

<script>

    $("#btnSend").click(function () {

        let user = $("#txtUser").val().trim();

        if (!user) {

            Swal.fire({
                icon: "warning",
                title: "Enter Email or Mobile"
            });

            return;
        }

        /* SHOW LOADING */

        Swal.fire({
            title: "Sending OTP...",
            text: "Please wait",
            allowOutsideClick: false,
            didOpen: () => {
                Swal.showLoading();
            }
        });

        $.ajax({

            type: "POST",
            url: "ForgotPassword.aspx/SendOTP",
            data: JSON.stringify({ user: user }),
            contentType: "application/json; charset=utf-8",
            dataType: "json",

            success: function (res) {

                if (res.d && res.d.success) {

                    Swal.fire({

                        html: `
        <div class="otp-success-popup">

            <div class="success-icon">
                <i class="fa fa-check"></i>
            </div>

            <h2>OTP Sent Successfully</h2>

            <p>Redirecting to verification page...</p>

        </div>
    `,

                        showConfirmButton: false,
                        timer: 1500,

                        background: "transparent",
                        color: "#fff",
                        backdrop: "rgba(2,6,23,0.85)",

                        customClass: {
                            popup: "otp-success-card"
                        }

                    });

                    setTimeout(function () {

                        window.location = res.d.redirect || "OtpVerify.aspx";

                    }, 1500);

                }
                else {

                    Swal.fire({
                        icon: "error",
                        title: "Account not found",
                        text: "No account exists with this Email or Mobile.",
                        confirmButtonText: "Try Again",
                        confirmButtonColor: "#2563eb",
                        backdrop: `rgba(0,0,0,0.35)`
                    });

                }

            },

            error: function () {

                Swal.fire({
                    icon: "error",
                    title: "Server error",
                    text: "Please try again later"
                });

            }

        });

    });

</script>

</body>
</html>