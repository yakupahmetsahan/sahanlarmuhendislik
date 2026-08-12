using System;
using System.Data.SqlClient;

public partial class Login : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
    }

    protected void btnLogin_Click(object sender, EventArgs e)
    {
        string username = txtUser.Text.Trim();
        string password = txtPass.Text;

        if (string.IsNullOrEmpty(username) || string.IsNullOrEmpty(password))
        {
            ShowError("Kullanıcı adı ve şifre gerekli.");
            return;
        }

        var table = Db.Query(
            "SELECT TOP 1 id, username, password_hash, display_name FROM admin_users WHERE username = @u",
            new SqlParameter("@u", username));

        if (table.Rows.Count == 0)
        {
            ShowError("Kullanıcı adı veya şifre hatalı.");
            return;
        }

        string storedHash = table.Rows[0]["password_hash"].ToString();
        string enteredHash = Db.HashPassword(password);

        if (storedHash != enteredHash)
        {
            ShowError("Kullanıcı adı veya şifre hatalı.");
            return;
        }

        Db.Execute("UPDATE admin_users SET last_login_at = GETDATE() WHERE id = @id",
            new SqlParameter("@id", table.Rows[0]["id"]));

        // Session tabanlı giriş — Web.config'te Forms Authentication tanımlamaya
        // gerek kalmadan çalışır (bkz. App_Code/AdminBasePage.cs).
        Session["AdminUser"] = username;
        Session["AdminDisplayName"] = table.Rows[0]["display_name"].ToString();

        string returnUrl = Request.QueryString["returnUrl"];
        if (!string.IsNullOrEmpty(returnUrl) && returnUrl.StartsWith("/"))
            Response.Redirect(returnUrl, false);
        else
            Response.Redirect("~/admin/Admin/Default.aspx", false);
    }

    private void ShowError(string message)
    {
        litError.Text = "<div class='err'>" + Server.HtmlEncode(message) + "</div>";
        litError.Visible = true;
    }
}
