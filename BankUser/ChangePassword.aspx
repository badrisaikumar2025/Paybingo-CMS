<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ChangePassword.aspx.cs" Inherits="BankUser_ChangePassword" %>

<!DOCTYPE html>
<html>
    <head runat="server">
        <title>Change Password</title>
        <meta name="viewport" content="width=device-width, initial-scale=1">
        
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
        <style>
            
            
         body {
    height: 100vh;
    margin: 0;

    display: flex;
    justify-content: center;
    align-items: center;

    font-family: Segoe UI;

    background:
        linear-gradient(rgba(5,15,40,0.3), rgba(5,15,40,0.4)),
        url('../assets/Home/CMSOTP1.png');

    background-size: cover;
    background-position: center;
    background-repeat: no-repeat;
}
            html,body{
                height:100%;
                margin:0;
                overflow:hidden;

            }

            


            .card{
    width:380px;
    padding:45px;
    border-radius:22px;

    background: rgba(15,23,42,0.85);

    backdrop-filter: blur(30px);

    border: 1px solid rgba(56,189,248,0.25);

    box-shadow:
        0 30px 90px rgba(0,0,0,0.8),
        0 0 30px rgba(56,189,248,0.25);

    color:white;
    text-align:center;
}

           input{
    width:90%;  /* 🔥 reduce here instead */
    margin:12px auto 0 auto; /* center */

    display:block;

    height:44px;

    border-radius:10px;

    border:1px solid rgba(255,255,255,0.1);

    background: rgba(15,23,42,0.95);
    color:white;

    padding-left:14px;

    outline:none;
    transition:.3s;
}

           input:focus{
    border:1px solid #3b82f6;
    box-shadow:0 0 10px rgba(59,130,246,0.6);
}

          button{
    width:100%;
    height:50px;
    margin-top:20px;
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
    transform: translateY(-2px);
    box-shadow: 0 15px 35px rgba(59,130,246,0.8);
}

            body.swal2-shown{
                padding-right:0 !important;
            }

            hrml.swal2-shown{
                overflow-y:hidden !important;
            }

            .icon-box{
    width:80px;
    height:80px;
    margin:0 auto 15px;

    border-radius:50%;
    display:flex;
    align-items:center;
    justify-content:center;

    background: rgba(59,130,246,0.15);
    color:#3b82f6;

    font-size:32px;

    box-shadow:
        0 0 25px rgba(59,130,246,0.6),
        inset 0 0 15px rgba(59,130,246,0.2);
}

          .inputBox{
    position:relative;
    width:100%;
    margin-top:12px;
}

.inputBox input{
    padding-right:45px;
}

.toggle-pass{
    position:absolute;
    right:15px;
    top:50%;
    transform:translateY(-50%);
    color:#94a3b8;
    cursor:pointer;
    transition:.3s;
}

.toggle-pass:hover{
    color:#3b82f6;
}

.toggle-pass{
    right:20px; /* adjust for centered input */
}

            </style>
        </head>
    <body>
        
        <form runat="server">
            
            <div class="card">
                <div class="icon-box">
    <i class="fa fa-shield-halved"></i>
</div>

<h2>Set New Password</h2>
<p>Create a secure password to continue</p>
                <div class="inputBox">
    <input type="password" id="txtpass" placeholder="New Password">
    <i class="fa fa-eye toggle-pass" data-target="txtpass"></i>
</div>

<div class="inputBox">
    <input type="password" id="txtconfirm" placeholder="Confirm Password">
    <i class="fa fa-eye toggle-pass" data-target="txtconfirm"></i>
</div>
                <button type="button" id="btnSave">Update Password</button>

            </div>

        </form>
        <script>

            $(".toggle-pass").click(function () {

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

            $("#btnSave").click(function () {

                let pass = $("#txtpass").val().trim();
                let confirm = $("#txtconfirm").val().trim();

                if (pass.length < 6) {
                    Swal.fire({
                        icon: "warning",
                        title: "Password must be at least 6 characters"
                    }).then(() => {
                        $("#txtpass").val("").focus();
                    });
                    return;
                }

                if (pass != confirm) {
                    Swal.fire({
                        icon: "error",
                        title: "Passwords do not match"
                    }).then(() => {
                        $("#txtconfirm").val("").focus();
                    });
                    return;
                }



        $.ajax({

            type: "POST",
            url: "ChangePassword.aspx/UpdatePassword",
            data: JSON.stringify({ password: pass }),
            contentType: "application/json; charset=utf-8",
            dataType: "json",

            success: function (res) {

                if (res.d.success) {
                    Swal.fire({
                        html: `
        <div style="text-align:center">
            <i class="fa fa-check-circle" style="
                font-size:60px;
                color:#22c55e;
                margin-bottom:15px;
                text-shadow:0 0 20px rgba(34,197,94,0.6);
            "></i>

            <h2 style="color:#e2e8f0">Password Updated</h2>
            <p style="color:#94a3b8">Redirecting to login...</p>
        </div>
    `,
                        showConfirmButton: false,
                        timer: 1500,
                        backdrop: "rgba(2,6,23,0.85)"
                    });

                    setTimeout(function () {

                        window.location = "../Home.aspx";

                    }, 1200);

                }

            }

        });

    });

        </script>

</body>
</html>