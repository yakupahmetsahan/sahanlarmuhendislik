using System;

/// <summary>
/// Admin klasöründeki tüm korumalı sayfalar bu sınıftan türer.
/// Web.config üzerinden değil, Session üzerinden giriş kontrolü yapar —
/// böylece "admin" klasörünün IIS'te ayrı bir Application olarak
/// tanımlanması gerekmez (paylaşımlı hostinglerde bu genelde mümkün olmaz).
/// </summary>
public class AdminBasePage : System.Web.UI.Page
{
    protected string CurrentUsername
    {
        get { return Session["AdminUser"] as string; }
    }

    protected override void OnInit(EventArgs e)
    {
        if (string.IsNullOrEmpty(CurrentUsername))
        {
            Response.Redirect("~/admin/Login.aspx?returnUrl=" + Server.UrlEncode(Request.Url.PathAndQuery), false);
            Response.End();
            return;
        }
        base.OnInit(e);
    }
}
