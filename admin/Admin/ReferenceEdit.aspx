<%@ Page Language="C#" MasterPageFile="~/admin/Admin/Site.Master" AutoEventWireup="true" CodeFile="ReferenceEdit.aspx.cs" Inherits="Admin_ReferenceEdit" %>
<asp:Content ID="c1" ContentPlaceHolderID="TitleContent" runat="server">Referans Düzenle</asp:Content>
<asp:Content ID="c2" ContentPlaceHolderID="MainContent" runat="server">
    <h1 class="page-title"><asp:Literal ID="litHeader" runat="server" /></h1>

    <div class="card" style="max-width:640px;">
        <label>Kategori</label>
        <asp:DropDownList ID="ddlCategory" runat="server">
            <asp:ListItem Text="Elektrik" Value="elektrik" />
            <asp:ListItem Text="Enerji" Value="enerji" />
            <asp:ListItem Text="Asansör" Value="asansor" />
            <asp:ListItem Text="Yazılım" Value="yazilim" />
        </asp:DropDownList>

        <label>Firma / Proje Adı *</label>
        <asp:TextBox ID="txtName" runat="server" />
        <asp:RequiredFieldValidator runat="server" ControlToValidate="txtName"
            ErrorMessage="Ad zorunludur" Display="Dynamic" ForeColor="#b3261e" Font-Size="0.8em" />

        <label>Tür (ör. Tavuk Çiftliği, Çatı Tipi, Apartman)</label>
        <asp:TextBox ID="txtType" runat="server" />

        <label>Yer (il / ilçe)</label>
        <asp:TextBox ID="txtLocation" runat="server" />

        <label>Yıl</label>
        <asp:TextBox ID="txtYear" runat="server" TextMode="Number" />

        <label>Güç Değeri (kVa / kW — Elektrik ve Enerji için)</label>
        <asp:TextBox ID="txtPowerValue" runat="server" TextMode="Number" />

        <label>Güç Birimi</label>
        <asp:DropDownList ID="ddlPowerUnit" runat="server">
            <asp:ListItem Text="— seçiniz —" Value="" />
            <asp:ListItem Text="kVa" Value="kVa" />
            <asp:ListItem Text="kW" Value="kW" />
            <asp:ListItem Text="MW" Value="MW" />
        </asp:DropDownList>

        <label>ENH Uzunluğu (metre — sadece Elektrik)</label>
        <asp:TextBox ID="txtEnh" runat="server" TextMode="Number" />

        <label>Direk Adedi (sadece Elektrik)</label>
        <asp:TextBox ID="txtDirek" runat="server" TextMode="Number" />

        <label>Adet (sadece Asansör — kaç asansör)</label>
        <asp:TextBox ID="txtUnitCount" runat="server" TextMode="Number" />

        <label>Fotoğraf (opsiyonel — jpg/png, en fazla 5MB)</label>
        <asp:FileUpload ID="fuPhoto" runat="server" />
        <div style="margin-top:8px;">
            <asp:Image ID="imgCurrent" runat="server" CssClass="thumb" Visible="false" />
            <asp:Literal ID="litCurrentPhoto" runat="server" />
        </div>

        <label style="display:flex; align-items:center; gap:8px;">
            <asp:CheckBox ID="chkFeatured" runat="server" />
            "Öne Çıkan Projeler" bölümünde göster
        </label>

        <label>Sıralama (küçük sayı önce gösterilir)</label>
        <asp:TextBox ID="txtSortOrder" runat="server" TextMode="Number" Text="0" />

        <div style="margin-top:22px; display:flex; gap:10px;">
            <asp:Button ID="btnSave" runat="server" Text="Kaydet" CssClass="btn" OnClick="btnSave_Click" />
            <a class="btn secondary" href='<%= "References.aspx?cat=" + (Request.QueryString["cat"] ?? ddlCategory.SelectedValue) %>'>İptal</a>
        </div>

        <asp:Literal ID="litError" runat="server" />
    </div>
</asp:Content>
