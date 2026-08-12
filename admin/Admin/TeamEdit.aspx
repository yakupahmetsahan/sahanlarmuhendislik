<%@ Page Language="C#" MasterPageFile="~/admin/Admin/Site.Master" AutoEventWireup="true" CodeFile="TeamEdit.aspx.cs" Inherits="Admin_TeamEdit" %>
<asp:Content ID="c1" ContentPlaceHolderID="TitleContent" runat="server">Ekip Üyesi</asp:Content>
<asp:Content ID="c2" ContentPlaceHolderID="MainContent" runat="server">
    <h1 class="page-title"><asp:Literal ID="litHeader" runat="server" /></h1>
    <div class="card" style="max-width:560px;">
        <label>Ad Soyad *</label>
        <asp:TextBox ID="txtName" runat="server" />
        <asp:RequiredFieldValidator runat="server" ControlToValidate="txtName"
            ErrorMessage="Ad Soyad zorunludur" Display="Dynamic" ForeColor="#b3261e" Font-Size="0.8em" />

        <label>Görev / Unvan (ör. "Elektrik-Elektronik Mühendisi · Şirket Sahibi")</label>
        <asp:TextBox ID="txtRole" runat="server" />

        <label>Grup</label>
        <asp:DropDownList ID="ddlGroup" runat="server">
            <asp:ListItem Text="Mühendislik Ekibi" Value="Mühendislik Ekibi" />
            <asp:ListItem Text="Koordinasyon & Ofis" Value="Koordinasyon & Ofis" />
            <asp:ListItem Text="Teknik Ekip" Value="Teknik Ekip" />
        </asp:DropDownList>

        <label>Sıralama</label>
        <asp:TextBox ID="txtSortOrder" runat="server" TextMode="Number" Text="0" />

        <div style="margin-top:22px; display:flex; gap:10px;">
            <asp:Button ID="btnSave" runat="server" Text="Kaydet" CssClass="btn" OnClick="btnSave_Click" />
            <a class="btn secondary" href="Team.aspx">İptal</a>
        </div>
        <asp:Literal ID="litError" runat="server" />
    </div>
</asp:Content>
