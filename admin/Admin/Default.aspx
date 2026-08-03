<%@ Page Language="C#" MasterPageFile="~/Admin/Site.Master" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="Admin_Default" %>
<asp:Content ID="c1" ContentPlaceHolderID="TitleContent" runat="server">Panel</asp:Content>
<asp:Content ID="c2" ContentPlaceHolderID="MainContent" runat="server">
    <h1 class="page-title">Genel Bakış</h1>
    <div class="card">
        <table class="grid">
            <tr><th>Alan</th><th>Kayıt Sayısı</th><th></th></tr>
            <tr>
                <td>Elektrik Referansları</td>
                <td><asp:Literal ID="litElektrik" runat="server" /></td>
                <td><a class="btn small" href="References.aspx?cat=elektrik">Yönet</a></td>
            </tr>
            <tr>
                <td>Enerji Referansları</td>
                <td><asp:Literal ID="litEnerji" runat="server" /></td>
                <td><a class="btn small" href="References.aspx?cat=enerji">Yönet</a></td>
            </tr>
            <tr>
                <td>Asansör Referansları</td>
                <td><asp:Literal ID="litAsansor" runat="server" /></td>
                <td><a class="btn small" href="References.aspx?cat=asansor">Yönet</a></td>
            </tr>
            <tr>
                <td>Yazılım Referansları</td>
                <td><asp:Literal ID="litYazilim" runat="server" /></td>
                <td><a class="btn small" href="References.aspx?cat=yazilim">Yönet</a></td>
            </tr>
            <tr>
                <td>Ekip Üyeleri</td>
                <td><asp:Literal ID="litTeam" runat="server" /></td>
                <td><a class="btn small" href="Team.aspx">Yönet</a></td>
            </tr>
        </table>
    </div>
</asp:Content>
