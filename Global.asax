<%@ Application Language="C#" %>

<script runat="server">

    void Application_Start(object sender, EventArgs e) 
    {
        // Runs when application starts
    }
    

    void Application_BeginRequest(object sender, EventArgs e)
    {
        // Disable browser cache (security)
        Response.Cache.SetCacheability(HttpCacheability.NoCache);
        Response.Cache.SetNoStore();
        Response.Cache.SetExpires(DateTime.UtcNow.AddMinutes(-1));
    }


    void Application_AcquireRequestState(object sender, EventArgs e)
    {
        HttpContext context = HttpContext.Current;

        if (context == null || context.Session == null)
            return;

        string url = context.Request.Url.AbsolutePath.ToLower();

        /* PUBLIC PAGES (NO LOGIN REQUIRED) */

        if (url.Contains("home.aspx") ||
            url.Contains("forgotpassword.aspx") ||
            url.Contains("otpverify.aspx") ||
            url.Contains("resetpassword.aspx") ||
            url.Contains("assets") ||
            url.Contains("css") ||
            url.Contains("js"))
        {
            return;
        }

        /* SESSION CHECK */

        if (context.Session["UserID"] == null)
        {
            context.Response.Redirect("~/Home.aspx");
        }
    }


    void Application_End(object sender, EventArgs e) 
    {
    }
        

    void Application_Error(object sender, EventArgs e) 
    { 
    }


    void Session_Start(object sender, EventArgs e) 
    {
    }


    void Session_End(object sender, EventArgs e) 
    {
    }

</script>