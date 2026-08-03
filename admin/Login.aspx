<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Login.aspx.cs" Inherits="Login" %>
<!DOCTYPE html>
<html lang="tr">
<head runat="server">
    <meta charset="UTF-8">
    <title>Giriş | Şahanlar Mühendislik Admin</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <style>
        body{ font-family:Arial,Helvetica,sans-serif; background:#f5f7fb; margin:0;
              display:flex; align-items:center; justify-content:center; height:100vh; }
        .box{ background:#fff; border:1px solid #e3e8f0; border-radius:8px; padding:36px;
              width:340px; box-shadow:0 10px 30px rgba(16,25,43,.08); }
        .box h1{ font-size:1.2rem; margin:0 0 6px; color:#10192b; }
        .box p.sub{ color:#8592a8; font-size:.85rem; margin:0 0 22px; }
        label{ display:block; font-size:.82rem; color:#33405c; margin-bottom:6px; }
        input[type=text], input[type=password]{
            width:100%; padding:10px 12px; border:1px solid #cdd6e6; border-radius:6px;
            font-size:.95rem; margin-bottom:16px; box-sizing:border-box;
        }
        .btn{ width:100%; padding:11px; background:#10192b; color:#fff; border:none;
              border-radius:6px; font-size:.95rem; cursor:pointer; }
        .btn:hover{ background:#2e6fe0; }
        .err{ background:#fdecec; color:#b3261e; padding:10px 12px; border-radius:6px;
              font-size:.85rem; margin-bottom:16px; }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="box">
            <h1>Şahanlar Mühendislik</h1>
            <p class="sub">Yönetim paneline giriş</p>

            <asp:Literal ID="litError" runat="server" Visible="false" />

            <label for="txtUser">Kullanıcı adı</label>
            <asp:TextBox ID="txtUser" runat="server" CssClass="" TextMode="SingleLine" />

            <label for="txtPass">Şifre</label>
            <asp:TextBox ID="txtPass" runat="server" TextMode="Password" />

            <asp:Button ID="btnLogin" runat="server" Text="Giriş Yap" CssClass="btn" OnClick="btnLogin_Click" />
        </div>
    </form>
</body>
</html>
