<%@ Page Language="C#" AutoEventWireup="False" CodeFile="Home.aspx.cs" Inherits="Home" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title>PayBingo CMS</title>

    
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <link rel="stylesheet"
        href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <style>
        /* GLOBAL */
        body {
            margin: 0;
            font-family: 'Segoe UI',sans-serif;
            background: #0b1220;
            color: white;
            overflow-x: hidden;
            scroll-behavior: smooth;
        }
        /* NAVBAR */
        .navbar {
            padding: 20px 70px;
            position: absolute;
            width: 100%;
            z-index: 10;
            background: rgba(2,6,23,0.4);
            backdrop-filter: blur(10px);
        }

        .logo {
            display: flex;
            align-items: center;
        }

            .logo span {
                color: #ff3b3b;
            }

        .login-btn {
            background: #2563eb;
            border: none;
            padding: 10px 25px;
            border-radius: 30px;
            color: white;
            font-weight: 600;
            transition: .3s;
        }
        .login-btn:hover {
             background: #1d4ed8;
             transform: translateY(-2px);
        }
        /* HERO */
        .hero {
            height: 100vh;
            display: flex;
            align-items: center;
            padding-left: 8%;
            position: relative;
            overflow: hidden;
        }

            .hero::before {
                content: "";
                position: absolute;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                background: url('assets/HOME/CMS.png') center/cover no-repeat;
                transform: translateY(0);
                z-index: -2;
            }

            .hero::after {
                content: "";
                position: absolute;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                background: linear-gradient(120deg,#020617 45%,rgba(2,6,23,.4));
                z-index: -1;
            }

            .hero h1 {
                font-size: 72px;
                font-weight: 800;
                letter-spacing: 1px;
                background: linear-gradient(90deg,#fff,#38bdf8);
                -webkit-background-clip: text;
                -webkit-text-fill-color: transparent;
            }

            .hero p {
                font-size: 20px;
                color: #cbd5e1;
                max-width: 520px;
                margin-top: 20px;
                line-height: 1.6;
            }

            .hero div {
                max-width: 700px;
            }

        /* START BUTTON */
        .start-btn {
            margin-top: 30px;
            background: linear-gradient(135deg,#22c55e,#16a34a);
            border: none;
            padding: 14px 38px;
            border-radius: 40px;
            color: white;
            font-size: 17px;
            font-weight: 600;
            box-shadow: 0 10px 25px rgba(34,197,94,0.4);
            transition: .35s;
        }

            .start-btn:hover {
                transform: translateY(-4px) scale(1.05);
                box-shadow: 0 20px 45px rgba(34,197,94,0.6);
            }
        /* STATS */
        .stats {
            padding: 120px 60px;
            display: flex;
            justify-content: center;
            gap: 40px;
            flex-wrap: wrap;
        }


        .stat-card {
            background: rgba(255,255,255,0.05);
            backdrop-filter: blur(20px);
            padding: 50px;
            border-radius: 18px;
            text-align: center;
            width: 250px;
            transition: .4s;
            border: 1px solid rgba(255,255,255,0.08);
            box-shadow: 0 15px 40px rgba(0,0,0,0.5);
        }

            .stat-card:hover {
                transform: translateY(-12px) scale(1.05);
                box-shadow: 0 25px 70px rgba(0,0,0,0.8);
                background: rgba(255,255,255,0.08);
            }

        .stat-number {
            font-size: 46px;
            font-weight: 700;
            color: #38bdf8;
            text-shadow: 0 0 15px rgba(56,189,248,0.7);
        }

        /* FEATURES */

        .features {
            padding: 120px 60px;
            background: #020617;
            text-align: center;
        }

            .features h2 {
                font-size: 40px;
                margin-bottom: 60px;
            }

        .feature-box {
            background: rgba(15,23,42,0.85);
            padding: 45px;
            border-radius: 18px;
            transition: .4s;
            border: 1px solid rgba(255,255,255,0.08);
            box-shadow: 0 10px 30px rgba(0,0,0,0.5);
        }

            .feature-box:hover {
                transform: translateY(-10px) scale(1.05);
                background: #1e293b;
                box-shadow: 0 20px 50px rgba(0,0,0,0.8);
            }

        /* PREVIEW */
        .preview {
            padding: 120px 60px;
            text-align: center;
            background: #020617;
        }

            .preview img {
                width: 100%;
                max-width: 900px;
                height: auto;
                border-radius: 16px;
                box-shadow: 0 25px 70px rgba(0,0,0,0.6);
                margin-top: 30px;
                transition: 0.3s;
            }

                .preview img:hover {
                    transform: scale(1.03);
                }

        .preview-title {
            font-size: 38px;
            font-weight: 700;
            margin-bottom: 20px;
            background: linear-gradient(90deg,#ffffff,#38bdf8);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        /* FOOTER */
        .footer {
            background: #020617;
            padding: 35px;
            text-align: center;
            color: #94a3b8;
        }

        /* LOGIN OVERLAY */
        .login-overlay {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            display: flex;
            align-items: center;
            justify-content: center;
            background: rgba(0,0,0,.55);
            backdrop-filter: blur(10px);
            opacity: 0;
            visibility: hidden;
            transition: .4s;
            z-index: 999;
        }

            .login-overlay.show {
                opacity: 1;
                visibility: visible;
            }

        /* LOGIN CARD */


        .login-card {
            width: 420px;
            padding: 45px 40px; 
            border-radius: 20px;

            background: rgba(15,23,42,0.82); /*  brighter */

            backdrop-filter: blur(30px);

            border: 1px solid rgba(56,189,248,0.25); /* glow border */

            box-shadow:
            0 25px 80px rgba(0,0,0,0.8),
            0 0 30px rgba(56,189,248,0.25); /* soft glow */

            transition: .4s;
            transform: scale(.85);
            opacity: 0;
        }

           .login-overlay.show .login-card {
              transform: scale(1);
              opacity: 1;
           }

           .login-card:hover {
              transform: translateY(-4px);
           }

           .login-logo {
              width: 260px;
              margin-bottom: 25px;
           }

            .inputBox {
               margin-bottom: 20px;
            }

            .inputBox input {
                width: 100%;
                height: 50px;
                border-radius: 12px;
                border: none;
                padding: 0 15px;
            }

        .btn-login {
            width: 100%;
            height: 50px;
            border: none;
            border-radius: 12px;
            background: linear-gradient(135deg,#2563eb,#1e40af);
            color: white;
            font-weight: 600;

        }

        /* TITLE */

        .login-title {
            font-size: 28px;
            font-weight: 700;
            margin-bottom: 5px;
            text-align: center;
            color: #f1f5f9; /* brighter */
        }

        .login-sub {
            text-align: center;
            color: #94a3b8;
            margin-bottom: 30px;
            color: #f1f5f9; /* brighter */
        }

        /* INPUT */

        .inputBox {
            position: relative;
            margin-bottom: 20px;
        }

            .inputBox i {
                position: absolute;
                left: 15px;
                top: 50%;
                transform: translateY(-50%);
                color: #94a3b8;
            }

            .inputBox input {
                width: 100%;
                height: 50px;
                padding-left: 45px;
                padding-right: 40px;
                border-radius: 10px;
                border: 1px solid rgba(255,255,255,0.1);
                background: #020617;
                color: white;
                outline: none;
                transition: .3s;

            }

                .inputBox input:focus {
                    border: 1px solid #3b82f6;
                    box-shadow: 0 0 8px rgba(59,130,246,0.5);
                }

        /* PASSWORD ICON */

        .toggle-pass {
            right: 15px;
            left: auto !important;
            cursor: pointer;
        }

        /* FORGOT */

        .forgot {
            text-align: right;
            margin-bottom: 20px;
        }

            .forgot a {
                color: #60a5fa;
                font-size: 14px;
                text-decoration: none;
            }

        /* BUTTON */

        .btn-login {
            width: 100%;
            height: 50px;
            border: none;
            border-radius: 10px;
            background: linear-gradient(135deg,#2563eb,#1d4ed8);
            font-weight: 600;
            font-size: 16px;
            transition: .3s;
        }

            .btn-login:hover {
                transform: translateY(-2px);
                box-shadow: 0 10px 25px rgba(37,99,235,0.6);
            }




        /* SWEET ALERT GLASS POPUP */

        .login-success-popup {
            background: rgba(15,23,42,0.55) !important;
            backdrop-filter: blur(25px) !important;
            -webkit-backdrop-filter: blur(25px) !important;
            border-radius: 20px !important;
            border: 1px solid rgba(255,255,255,0.08) !important;
            box-shadow: 0 30px 80px rgba(0,0,0,0.7), inset 0 1px 0 rgba(255,255,255,0.08) !important;
            padding: 35px 20px !important;
            font-family: 'Segoe UI',sans-serif;
        }

            .login-success-popup i {
                font-size: 60px;
                color: #22c55e;
                background: rgba(34,197,94,0.15);
                border-radius: 50%;
                width: 90px;
                height: 90px;
                display: flex;
                align-items: center;
                justify-content: center;
                margin: 20px auto;
                box-shadow: 0 0 20px rgba(34,197,94,0.4);
            }

        .swal2-title {
            font-size: 28px !important;
            font-weight: 700 !important;
            color: #e2e8f0 !important;
        }

        /* ERROR POPUP */

        .login-error-popup {
            background: rgba(15,23,42,0.55) !important;
            backdrop-filter: blur(25px);
            -webkit-backdrop-filter: blur(25px);
            border-radius: 20px !important;
            border: 1px solid rgba(255,255,255,0.08);
            box-shadow: 0 30px 80px rgba(0,0,0,0.7), inset 0 1px 0 rgba(255,255,255,0.08);
            padding: 35px 25px;
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
                box-shadow: 0 0 20px rgba(239,68,68,0.4);
            }

            .login-error-popup p {
                margin-top: 10px;
                color: #cbd5e1;
                font-size: 16px;
            }

        /* BUTTON */

        .login-error-btn {
            background: linear-gradient(135deg,#ef4444,#dc2626) !important;
            border-radius: 10px !important;
            padding: 10px 28px !important;
            font-weight: 600;
        }


        /* MODERN FOOTER */

        .modern-footer {
            margin-top: 120px;
            padding: 80px 20px;
            background: linear-gradient( 180deg, #020617 0%, #020617 40%, #0b1220 100% );
            border-top: 1px solid rgba(255,255,255,0.05);
        }

        .footer-content {
            max-width: 900px;
            margin: auto;
            text-align: center;
            background: rgba(15,23,42,0.6);
            padding: 50px;
            border-radius: 20px;
            backdrop-filter: blur(20px);
            border: 1px solid rgba(255,255,255,0.08);
            box-shadow: 0 20px 60px rgba(0,0,0,0.6);
        }

        .footer-logo {
            font-size: 42px;
            font-weight: 800;
            background: linear-gradient(90deg,#ffffff,#38bdf8);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            margin-bottom: 10px;
        }

        .company-name {
            color: #94a3b8;
            margin-bottom: 30px;
        }

        .footer-info p {
            margin: 12px 0;
            font-size: 16px;
            color: #e2e8f0;
        }

        .footer-info i {
            margin-right: 10px;
            color: #38bdf8;
        }

        .copyright {
            margin-top: 30px;
            font-size: 14px;
            color: #64748b;
        }


        #bgCanvas {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            z-index: -1;
        }
        /* NAV LOGO */

        .nav-logo {
            height: 200px; /* increase size */
            width: auto;
            object-fit: contain;
        }

        .logo {
            display: flex;
            align-items: center;
        }
        /* TOP RIGHT LOGO */

        .top-logo {
            position: absolute;
            top: 25px;
            left: 40px;
        }

            .top-logo img {
                height: 100px;
                filter: drop-shadow(0 0 10px rgba(56,189,248,0.6));
            }
        /* FOOTER LOGO */

        .footer-logo-img {
            height: 65px;
            width: auto;
            margin-bottom: 10px;
        }

        /* 3D FLOATING CARD */

        .stat-card {
            background: rgba(255,255,255,0.05);
            backdrop-filter: blur(20px);
            padding: 50px;
            border-radius: 18px;
            text-align: center;
            width: 250px;
            border: 1px solid rgba(255,255,255,0.08);
            box-shadow: 0 15px 40px rgba(0,0,0,0.5), inset 0 1px 0 rgba(255,255,255,0.05);
            transform-style: preserve-3d;
            transition: transform .35s ease, box-shadow .35s ease;
            position: relative;
            animation: floatCard 6s ease-in-out infinite;
        }

        /* FLOATING ANIMATION */

        @keyframes floatCard {

            0% {
                transform: translateY(0px);
            }

            50% {
                transform: translateY(-15px);
            }

            100% {
                transform: translateY(0px);
            }
        }

        /* HOVER 3D EFFECT */

        .stat-card:hover {
            transform: rotateX(8deg) rotateY(-8deg) scale(1.05);
            box-shadow: 0 30px 80px rgba(0,0,0,0.8);
        }

        .stat-card::before {
            content: "";
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: radial-gradient( circle at var(--x) var(--y), rgba(56,189,248,0.35), transparent 60% );
            opacity: 0;
            transition: opacity .3s;
            border-radius: 18px;
        }

        .stat-card:hover::before {
            opacity: 1;
        }

        .stats {
            padding: 120px 60px;
            display: flex;
            justify-content: center;
            gap: 40px;
            flex-wrap: wrap;
            perspective: 1200px; /* important for 3D */
        }

        .stat-card {
            will-change: transform;
            transform-style: preserve-3d;
            transition: transform .25s ease, box-shadow .25s ease;
        }

        /* OTP POPUP CARD */
        
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
    line-height: 1.6;
}

/* ANIMATION */

@keyframes pulseGlow {
    0% { transform: scale(1); }
    50% { transform: scale(1.08); }
    100% { transform: scale(1); }
}


/* CHANGE PASSWORD POPUP */

.change-pass-card {
    background: rgba(15,23,42,0.85) !important;
    backdrop-filter: blur(30px);
    border-radius: 22px !important;

    border: 1px solid rgba(56,189,248,0.25);

    box-shadow:
        0 30px 90px rgba(0,0,0,0.8),
        0 0 35px rgba(56,189,248,0.25);

    padding: 40px 25px !important;
}

/* ICON */

.warn-icon {
    width: 90px;
    height: 90px;
    margin: 0 auto 20px;

    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;

    background: rgba(245,158,11,0.15);
    color: #f59e0b;

    font-size: 40px;

    box-shadow:
        0 0 25px rgba(245,158,11,0.6),
        inset 0 0 15px rgba(245,158,11,0.3);

    animation: pulseGlow 1.5s infinite;
}

/* TEXT */

.change-pass-popup h2 {
    color: #e2e8f0;
    font-size: 26px;
    font-weight: 700;
    margin-bottom: 10px;
}

.change-pass-popup p {
    color: #94a3b8;
    font-size: 15px;
}

/* BUTTON */

.change-pass-btn {
    background: linear-gradient(135deg,#3b82f6,#2563eb) !important;
    border-radius: 10px !important;
    padding: 10px 30px !important;
    font-weight: 600;
    box-shadow: 0 10px 25px rgba(59,130,246,0.5);
}

.change-pass-btn:hover {
    box-shadow: 0 15px 35px rgba(59,130,246,0.8);
}
    </style>

</head>

<body>

    <form runat="server" autocomplete="off">

        <!-- NAVBAR -->

        <div class="top-logo">
            <img src="assets/logo/paybingo_transparent1.png">
        </div>

        <!-- HERO -->

        <section class="hero">

            <div>

                <h1>Welcome</h1>

                <p>
                    Secure CMS platform for managing banking operations,
                     transactions, settlements and analytics.
                </p>

                <button type="button" class="start-btn"
                    onclick="document.getElementById('loginOverlay').classList.add('show')">
                    Get Started
                </button>

            </div>

        </section>

<section class="stats">

    <div class="stat-card">
        <div id="lblTransactions" runat="server" ClientIDMode="Static" class="stat-number">0</div>
        <p>Transactions</p>
    </div>

    <div class="stat-card">
        <div id="lblBanks" runat="server" ClientIDMode="Static" class="stat-number">0</div>
        <p>Bank Partners</p>
    </div>

    <div class="stat-card">
        <div id="lblClients" runat="server" ClientIDMode="Static" class="stat-number">0</div>
        <p>Corporate Clients</p>
    </div>

    <div class="stat-card">
        <div id="lblUptime" runat="server" ClientIDMode="Static" class="stat-number">0</div>
        <p>System Uptime %</p>
    </div>

</section>






        <!-- FEATURES -->

        <section class="features">

            <h2>Powerful CMS Features</h2>

            <div class="row g-4">

                <div class="col-md-4">
                    <div class="feature-box">
                        <i class="fa fa-lock fa-2x mb-3"></i>
                        <h4>Secure Login</h4>
                        <p>OTP + JWT authentication</p>
                    </div>
                </div>

                <div class="col-md-4">
                    <div class="feature-box">
                        <i class="fa fa-chart-line fa-2x mb-3"></i>
                        <h4>Analytics</h4>
                        <p>Realtime financial dashboards</p>
                    </div>
                </div>

                <div class="col-md-4">
                    <div class="feature-box">
                        <i class="fa fa-database fa-2x mb-3"></i>
                        <h4>Transaction Engine</h4>
                        <p>High speed payment processing</p>
                    </div>
                </div>

            </div>

        </section>


        <!-- PREVIEW -->

        <section class="preview">

            <h2 class="preview-title">CMS Dashboard Preview</h2>

            <img src="assets/HOME/Screenshot 2026-03-11 153802.png" alt="CMS Dashboard">
        </section>


        <!-- FOOTER -->

        <!-- MODERN FOOTER -->

        <section class="modern-footer">

            <div class="container">

                <div class="footer-content">

                    <div class="footer-logo">
                        <img src="assets/logo/paybingo_transparent1.png" class="footer-logo-img">
                    </div>

                    <p class="company-name">® Parnav Online Solutions Pvt. Ltd.</p>

                    <div class="footer-info">

                        <p>
                            <i class="fa fa-location-dot"></i>
                            SCO 47-48, Opp. Sector 7, Near Bharat Petrol pump,
                            Kurukshetra, Haryana - 136118
                        </p>

                        <p>
                            <i class="fa fa-phone"></i>
                            +91 93780 20007
                        </p>

                        <p>
                            <i class="fa fa-envelope"></i>
                            info@paybingo.in
                        </p>

                    </div>

                    <p class="copyright">
                        © 2026 PayBingo CMS. All Rights Reserved.
                    </p>

                </div>

            </div>

        </section>


        <!-- LOGIN POPUP -->

        

        <div class="login-overlay" id="loginOverlay">

            <div class="login-card">

                <h2 class="login-title">
                    <i class="fa fa-shield-halved"></i>Secure Access
                </h2>

                <p class="login-sub">Admin & Bank User Login</p>

                <div class="inputBox">
                    <i class="fa fa-user"></i>
                    <input id="txtuserid" placeholder="Email or Mobile" autocomplete="off">
                </div>

                <div class="inputBox">
                    <i class="fa fa-lock"></i>
                    <input id="txtpassword" type="password" placeholder="Password" autocomplete="new-password">
                    <i class="fa fa-eye toggle-pass"></i>
                </div>

                <div class="forgot">
                    <a href="ForgotPassword.aspx">Forgot Password?</a>
                </div>

                <button type="button" id="btnSubmitLogin" class="btn-login">
                    Login
                </button>

            </div>

        </div>

        <canvas id="bgCanvas"></canvas>



    </form>


    

   <script>


       $(document).ready(function () {

           if (navigator.geolocation) {

               navigator.geolocation.getCurrentPosition(function (position) {

                   let lat = position.coords.latitude;
                   let lng = position.coords.longitude;

                   console.log("Lat:", lat, "Lng:", lng);

                   // CALL SERVER METHOD
                   $.ajax({
                       type: "POST",
                       url: "Home.aspx/SaveLocation",
                       data: JSON.stringify({ latitude: lat, longitude: lng }),
                       contentType: "application/json; charset=utf-8",
                       dataType: "json",
                       success: function () {
                           console.log("Location saved");
                       },
                       error: function () {
                           console.log("Error saving location");
                       }
                   });

               }, function () {
                   console.log("Permission denied");
               });

           } else {
               console.log("Geolocation not supported");
           }

       });

      

       /* AUTO FOCUS USERNAME */

       $(document).ready(function () {
           $("#txtuserid").focus();
       });


       /* CLOSE LOGIN OVERLAY */

       $("#loginOverlay").click(function (e) {
           if (e.target.id == "loginOverlay") {
               $(this).removeClass("show");
           }
       });


       /* SHOW / HIDE PASSWORD */

       $(".toggle-pass").click(function () {

           let input = $("#txtpassword");

           if (input.attr("type") == "password") {
               input.attr("type", "text");
               $(this).removeClass("fa-eye").addClass("fa-eye-slash");
           }
           else {
               input.attr("type", "password");
               $(this).removeClass("fa-eye-slash").addClass("fa-eye");
           }

       });


       /* ENTER KEY LOGIN */

       $("#txtpassword").keypress(function (e) {

           if (e.which == 13) {
               $("#btnSubmitLogin").click();
           }

       });

       /* MOUSE PARALLAX DASHBOARD */

       const stats = document.querySelector(".stats");
       const cards = document.querySelectorAll(".stat-card");

       stats.addEventListener("mousemove", function (e) {

           let rect = stats.getBoundingClientRect();

           let x = (e.clientX - rect.left) / rect.width - 0.5;
           let y = (e.clientY - rect.top) / rect.height - 0.5;

           cards.forEach((card, i) => {

               let depth = (i + 1) * 6;

               card.style.transform =
                   `rotateY(${x * 12}deg)
                  rotateX(${-y * 12}deg)
                  translateZ(${depth}px)`;

           });

       });


       stats.addEventListener("mouseleave", function () {

           cards.forEach(card => {

               card.style.transform =
                   "rotateX(0deg) rotateY(0deg) translateZ(0px)";

           });

       });


       /* PARALLAX EFFECT */

       window.addEventListener("scroll", function () {

           let scrolled = window.pageYOffset;
           let hero = document.querySelector(".hero");

           if (hero) {
               hero.style.backgroundPositionY = -(scrolled * 0.3) + "px";
           }

       });


       /* MOUSE LIGHT EFFECT */

       document.querySelectorAll(".stat-card").forEach(card => {

           card.addEventListener("mousemove", e => {

               let rect = card.getBoundingClientRect();

               let x = e.clientX - rect.left;
               let y = e.clientY - rect.top;

               card.style.setProperty("--x", x + "px");
               card.style.setProperty("--y", y + "px");

           });

       });

       /* PARTICLE BACKGROUND */

       const canvas = document.getElementById("bgCanvas");

       if (canvas) {

           const ctx = canvas.getContext("2d");

           canvas.width = window.innerWidth;
           canvas.height = window.innerHeight;

           let particles = [];

           for (let i = 0; i < 80; i++) {

               particles.push({
                   x: Math.random() * canvas.width,
                   y: Math.random() * canvas.height,
                   r: Math.random() * 2,
                   d: Math.random() * 1
               });

           }

           function draw() {

               ctx.clearRect(0, 0, canvas.width, canvas.height);
               ctx.fillStyle = "rgba(56,189,248,0.5)";

               particles.forEach(p => {

                   ctx.beginPath();
                   ctx.arc(p.x, p.y, p.r, 0, Math.PI * 2);
                   ctx.fill();

                   p.y += p.d;

                   if (p.y > canvas.height) {

                       p.y = 0;
                       p.x = Math.random() * canvas.width;

                   }

               });

               requestAnimationFrame(draw);

           }

           draw();

       }


       /* STATS COUNTER */

      
       


       /* LOGIN AJAX */

       $("#btnSubmitLogin").click(function () {

           $("#btnSubmitLogin").prop("disabled", true);

           let user = $("#txtuserid").val().trim();
           let pass = $("#txtpassword").val().trim();

           if (!user || !pass) {

               $("#btnSubmitLogin").prop("disabled", false);

               Swal.fire({
                   icon: "warning",
                   title: "Enter credentials",
                   timer: 1500,
                   showConfirmButton: false
               });

               return;
           }


           $.ajax({

               type: "POST",
               url: "Home.aspx/Loginadmin",

               data: JSON.stringify({
                   userid: user,
                   password: pass
               }),

               contentType: "application/json; charset=utf-8",
               dataType: "json",

               success: function (res) {

                   if (!res || !res.d || res.d.success !== true) {

                       $("#btnSubmitLogin").prop("disabled", false);

                       Swal.fire({

                           title: "Login Failed",
                           html: "<i class='fa fa-xmark'></i><p>Invalid email/mobile or password</p>",
                           confirmButtonText: "OK",
                           background: "transparent",
                           color: "#fff",
                           backdrop: "rgba(2,6,23,0.75)",

                           customClass: {
                               popup: "login-error-popup",
                               confirmButton: "login-error-btn"
                           }

                       }).then(() => {

                           // 🔥 CLEAR FIELDS
                           $("#txtuserid").val("");
                           $("#txtpassword").val("");

                           // 🔥 FOCUS BACK TO USERNAME
                           $("#txtuserid").focus();

                       });

                       return;
                   }


                   // 🔥 ONLY POPUP CHANGE (NO FLOW CHANGE)
                   if (res.d.firstLogin && res.d.firstLogin === true) {

                       Swal.fire({

                           html: `
        <div class="change-pass-popup">

            <div class="warn-icon">
                <i class="fa fa-exclamation"></i>
            </div>

            <h2>Change Password Required</h2>

            <p>Please update your password to continue</p>

        </div>
    `,

                           confirmButtonText: "Continue",

                           background: "transparent",
                           color: "#fff",
                           backdrop: "rgba(2,6,23,0.85)",

                           customClass: {
                               popup: "change-pass-card",
                               confirmButton: "change-pass-btn"
                           }

                       }).then(() => {
                           window.location.href = "BankUser/ChangePassword.aspx";
                       });

                       return; // VERY IMPORTANT FIX

                   }


                   Swal.fire({

                       html: `
        <div class="otp-popup">
            <div class="otp-icon">
                <i class="fa fa-shield-check"></i>
            </div>

            <h2>Verification Required</h2>

            <p>
                OTP has been sent to your<br>
                registered mobile number
            </p>
        </div>
    `,

                       showConfirmButton: false,
                       timer: 1800,
                       backdrop: "rgba(2,6,23,0.85)",

                       customClass: {
                           popup: "otp-popup-card"
                       }

                   }).then(() => {
                       window.location.href = res.d.redirect;
                   });

               },

               error: function () {

                   $("#btnSubmitLogin").prop("disabled", false);

                   Swal.fire({
                       icon: "error",
                       title: "Server Error",
                       text: "Please try again"
                   });

               }

           });

       });

       window.addEventListener("load", function () {

           const counters = document.querySelectorAll(".stat-number");

           counters.forEach(counter => {

               const target = parseFloat(counter.getAttribute("data-target"));

               if (!target || isNaN(target)) return;

               const speed = 200;

               const update = () => {

                   const count = parseFloat(counter.innerHTML);
                   const inc = target / speed;

                   if (count < target) {
                       counter.innerHTML = Math.ceil(count + inc);
                       setTimeout(update, 10);
                   } else {
                       counter.innerHTML = target;
                   }

               };

               counter.innerHTML = "0";
               update();

           });

       });

   </script>



</body>
</html>
