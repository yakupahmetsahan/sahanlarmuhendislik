<%@ Page Language="C#" MasterPageFile="~/admin/Admin/Site.Master" AutoEventWireup="true" CodeFile="ServiceEdit.aspx.cs" Inherits="Admin_ServiceEdit" %>
<asp:Content ID="c1" ContentPlaceHolderID="TitleContent" runat="server">Hizmet Kartı Düzenle</asp:Content>
<asp:Content ID="c2" ContentPlaceHolderID="MainContent" runat="server">
    <h1 class="page-title"><asp:Literal ID="litHeader" runat="server" /></h1>

    <div class="card" style="max-width:600px;">
        <label>Kategori</label>
        <asp:DropDownList ID="ddlCategory" runat="server">
            <asp:ListItem Text="Elektrik" Value="elektrik" />
            <asp:ListItem Text="Enerji" Value="enerji" />
            <asp:ListItem Text="Asansör" Value="asansor" />
            <asp:ListItem Text="Yazılım" Value="yazilim" />
        </asp:DropDownList>

        <label>İkon</label>
        <asp:DropDownList ID="ddlIcon" runat="server">
            <asp:ListItem Text="Yıldırım / Elektrik" Value="bolt" />
            <asp:ListItem Text="Nabız / Verimlilik" Value="pulse" />
            <asp:ListItem Text="Pil / Enerji" Value="battery" />
            <asp:ListItem Text="Onay / Kontrol" Value="check" />
            <asp:ListItem Text="Bina" Value="building" />
            <asp:ListItem Text="Grafik" Value="chart" />
            <asp:ListItem Text="Kod / Yazılım" Value="code" />
            <asp:ListItem Text="Güneş" Value="sun" />
            <asp:ListItem Text="Anahtar / Bakım" Value="wrench" />
            <asp:ListItem Text="Kalkan / Güvenlik" Value="shield" />
            <asp:ListItem Text="Ev / Ev Tipi" Value="home" />
            <asp:ListItem Text="Ampul" Value="bulb" />
            <asp:ListItem Text="Asansör / Yön" Value="elevator" />
            <asp:ListItem Text="Ekran / İzleme" Value="monitor" />
        </asp:DropDownList>

        <label>Başlık *</label>
        <asp:TextBox ID="txtTitle" runat="server" />
        <asp:RequiredFieldValidator runat="server" ControlToValidate="txtTitle"
            ErrorMessage="Başlık zorunludur" Display="Dynamic" ForeColor="#b3261e" Font-Size="0.8em" />

        <label>Açıklama</label>
        <asp:TextBox ID="txtDescription" runat="server" TextMode="MultiLine" Rows="3" />

        <label>Sıra (küçük sayı önce gösterilir)</label>
        <asp:TextBox ID="txtSortOrder" runat="server" TextMode="Number" Text="0" />

        <div style="margin-top:20px;">
            <asp:Button ID="btnSave" runat="server" CssClass="btn" Text="Kaydet" OnClick="btnSave_Click" />
            <a class="btn secondary" href='<%= "Services.aspx?cat=" + ddlCategory.SelectedValue %>'>Vazgeç</a>
        </div>
    </div>
</asp:Content>
