using System;

public partial class RootDefault : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        bool loggedIn = Session["AdminUser"] != null;
        Response.Redirect(loggedIn ? "~/Admin/Default.aspx" : "~/Login.aspx", false);
    }
}
