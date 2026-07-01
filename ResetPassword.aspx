<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ResetPassword.aspx.cs" Inherits="ResetPassword" %>

<!DOCTYPE html>
<html>
<head runat="server">
<title>Reset Password</title>

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

/* SAME BACKGROUND AS FORGOT PASSWORD */

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

/* GLASS CARD */

.card{

width:460px; /* 🔥 more bigger */
padding:55px 50px;

text-align:center;

border-radius:26px;

background: rgba(15,23,42,0.92);

backdrop-filter: blur(40px);

border:1px solid rgba(56,189,248,0.25);

box-shadow:
0 50px 120px rgba(0,0,0,0.95),
0 0 50px rgba(56,189,248,0.25);

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
height:52px;

margin-top:20px;

border-radius:12px;
border:1px solid rgba(255,255,255,.25);

background:rgba(255,255,255,.12);

padding-left:15px;

font-size:15px;

color:white;

outline:none;

transition:.25s;

}


.input::placeholder{
color:#cbd5f5;
}

.input:focus{

border-color:#3b82f6;

box-shadow:0 0 15px rgba(59,130,246,.6);

background:rgba(255,255,255,.18);

}

/* BUTTON */

button{

width:100%;
height:54px;

margin-top:25px;

border:none;
border-radius:14px;

background:linear-gradient(135deg,#3b82f6,#2563eb);

color:white;

font-size:17px;
font-weight:600;

cursor:pointer;

transition:.3s;

}

button:hover{

transform:translateY(-2px);

box-shadow:0 20px 40px rgba(37,99,235,.45);

}

/* SWEET ALERT PREMIUM */

.swal2-popup{

background:linear-gradient(145deg,#f0f6ff,#e6eefc) !important;

backdrop-filter:blur(20px);
-webkit-backdrop-filter:blur(20px);

border-radius:28px !important;

border:1px solid rgba(255,255,255,.7);

box-shadow:
0 35px 95px rgba(37,99,235,.35),
inset 0 1px 0 rgba(255,255,255,.9);

padding:40px 35px;

font-family:Segoe UI;

}

.swal2-confirm{

background:#2563eb !important;

border-radius:10px !important;

padding:10px 24px !important;

font-weight:600;

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

.swal2-confirm{

background:linear-gradient(135deg,#3b82f6,#2563eb) !important;

border-radius:12px !important;

padding:10px 26px !important;

font-weight:600;

box-shadow:0 8px 20px rgba(37,99,235,.4);

}

/* POPUP ANIMATION */

.swal2-show{
animation:popupZoom .35s ease;
}

@keyframes popupZoom{

from{
opacity:0;
transform:scale(.9);
}

to{
opacity:1;
transform:scale(1);
}

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

.inputBox{
    position:relative;
    margin-top:15px;
}

.inputBox input{
    width:94%;
    margin:0 auto;
    display:block;
    height:44px;

    border-radius:10px;
    border:1px solid rgba(255,255,255,0.15);

    background: rgba(15,23,42,0.95);
    color:white;

    padding-left:14px;

    outline:none;
}
.inputBox input:focus{
    border:1px solid #3b82f6;
    box-shadow:0 0 10px rgba(59,130,246,0.6);
}

.toggle-pass{
    position:absolute;
    right:28px; /* 🔥 push slightly right */
    top:50%;
    transform:translateY(-50%);
    color:#94a3b8;
    cursor:pointer;
    font-size:15px;
}

/* DARK POPUP FIX */

.dark-popup{
    background: rgba(15,23,42,0.95) !important;

    backdrop-filter: blur(30px);

    border-radius:24px !important;

    border:1px solid rgba(56,189,248,0.25);

    box-shadow:
        0 40px 100px rgba(0,0,0,0.9),
        0 0 30px rgba(56,189,248,0.25);

    padding:35px !important;
}

/* SUCCESS ICON */

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
}

/* TEXT */

.success-popup h2{
    color:#e2e8f0;
    margin-bottom:5px;
}

.success-popup p{
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
    <i class="fa fa-lock"></i>
</div>

<h2>Reset Password</h2>
<p>Enter your new password</p>

<div class="inputBox">
    <input type="password" id="txtPass" placeholder="New Password">
    <i class="fa fa-eye toggle-pass" data-target="txtPass"></i>
</div>

<div class="inputBox">
    <input type="password" id="txtConfirm" placeholder="Confirm Password">
    <i class="fa fa-eye toggle-pass" data-target="txtConfirm"></i>
</div>

<button type="button" id="btnReset">Update Password</button>

</div>

</div>

</form>

<script>

    $("#btnReset").click(function () {

        let pass = $("#txtPass").val().trim();
        let confirm = $("#txtConfirm").val().trim();

        /* VALIDATION */

        if (pass.length < 6) {

            Swal.fire({
                icon: "warning",
                title: "Weak Password",
                text: "Password must be at least 6 characters"
            });

            return;
        }

        if (pass !== confirm) {

            Swal.fire({
                icon: "error",
                title: "Passwords do not match"
            });

            return;
        }

        /* LOADING */

        Swal.fire({
            title: "Updating Password...",
            text: "Please wait",
            allowOutsideClick: false,
            didOpen: () => {
                Swal.showLoading();
            }
        });

        

        /* AJAX */

        $.ajax({

            type: "POST",
            url: "ResetPassword.aspx/UpdatePassword",
            data: JSON.stringify({ password: pass }),
            contentType: "application/json; charset=utf-8",
            dataType: "json",

            success: function (res) {

                if (res.d.success) {

                    Swal.fire({

                        html: `
        <div class="success-popup">

            <div class="success-icon">
                <i class="fa fa-check"></i>
            </div>

            <h2>Password Updated</h2>
            <p>Redirecting to login...</p>

        </div>
    `,

                        showConfirmButton: false,
                        timer: 1500,

                        background: "transparent",
                        backdrop: "rgba(2,6,23,0.85)",

                        customClass: {
                            popup: "dark-popup"
                        }

                    });

                    setTimeout(function () {

                        window.location = "Home.aspx";

                    }, 1500);

                }
                else {

                    Swal.fire({
                        icon: "error",
                        title: "Update Failed"
                    });

                }

            },

            error: function () {

                Swal.fire({
                    icon: "error",
                    title: "Server Error"
                });

            }

        });

    });


    $(document).on("click", ".toggle-pass", function () {

        let target = $(this).data("target");
        let input = $("#" + target);

        if (input.attr("type") === "password") {
            input.attr("type", "text");
            $(this).removeClass("fa-eye").addClass("fa-eye-slash");
        } else {
            input.attr("type", "password");
            $(this).removeClass("fa-eye-slash").addClass("fa-eye");
        }

    });
</script>

</body>
</html>