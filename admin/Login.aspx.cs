using System;
using System.Web.Security;

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
            "SELECT id, username, password_hash, display_name FROM admin_users WHERE username = @u LIMIT 1",
            new MySql.Data.MySqlClient.MySqlParameter("@u", username));

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

        // Son giriş zamanını güncelle
        Db.Execute("UPDATE admin_users SET last_login_at = NOW() WHERE id = @id",
            new MySql.Data.MySqlClient.MySqlParameter("@id", table.Rows[0]["id"]));

        FormsAuthentication.SetAuthCookie(username, false);
        Response.Redirect("~/Admin/Default.aspx", false);
    }

    private void ShowError(string message)
    {
        litError.Text = "<div class='err'>" + Server.HtmlEncode(message) + "</div>";
        litError.Visible = true;
    }
}
