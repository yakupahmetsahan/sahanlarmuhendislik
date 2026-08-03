<%@ Page Language="C#" MasterPageFile="~/Admin/Site.Master" AutoEventWireup="true" CodeFile="Content.aspx.cs" Inherits="Admin_Content" %>
<asp:Content ID="c1" ContentPlaceHolderID="TitleContent" runat="server">Sayfa Metinleri</asp:Content>
<asp:Content ID="c2" ContentPlaceHolderID="MainContent" runat="server">
    <h1 class="page-title">Sayfa Metinleri</h1>
    <asp:Literal ID="litMsg" runat="server" />

    <div class="card">
        <label>Sayfa</label>
        <asp:DropDownList ID="ddlPage" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlPage_Changed">
            <asp:ListItem Text="Ana Sayfa" Value="index" />
            <asp:ListItem Text="Elektrik" Value="elektrik" />
            <asp:ListItem Text="Enerji" Value="enerji" />
            <asp:ListItem Text="Asansör" Value="asansor" />
            <asp:ListItem Text="Yazılım" Value="yazilim" />
        </asp:DropDownList>

        <asp:Repeater ID="rptContent" runat="server" OnItemDataBound="rptContent_ItemDataBound">
            <ItemTemplate>
                <label><%# Eval("content_key") %></label>
                <asp:TextBox ID="txtValue" runat="server" TextMode="MultiLine" Rows="3"
                    Text='<%# Eval("content_value") %>' />
                <asp:HiddenField ID="hidKey" runat="server" Value='<%# Eval("content_key") %>' />
            </ItemTemplate>
        </asp:Repeater>

        <div style="margin-top:18px;">
            <asp:Button ID="btnSave" runat="server" Text="Kaydet" CssClass="btn" OnClick="btnSave_Click" />
        </div>
    </div>
</asp:Content>
