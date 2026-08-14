<%@ Page Language="C#" MasterPageFile="~/admin/Admin/Site.Master" AutoEventWireup="true" CodeFile="Services.aspx.cs" Inherits="Admin_Services" %>
<asp:Content ID="c1" ContentPlaceHolderID="TitleContent" runat="server">Hizmet Kartları</asp:Content>
<asp:Content ID="c2" ContentPlaceHolderID="MainContent" runat="server">
    <h1 class="page-title">Hizmet Kartları</h1>

    <div style="display:flex; gap:8px; margin-bottom:16px;">
        <a class="btn small <%= CurrentCat=="elektrik"?"":"secondary" %>" href="Services.aspx?cat=elektrik">Elektrik</a>
        <a class="btn small <%= CurrentCat=="enerji"?"":"secondary" %>" href="Services.aspx?cat=enerji">Enerji</a>
        <a class="btn small <%= CurrentCat=="asansor"?"":"secondary" %>" href="Services.aspx?cat=asansor">Asansör</a>
        <a class="btn small <%= CurrentCat=="yazilim"?"":"secondary" %>" href="Services.aspx?cat=yazilim">Yazılım</a>
    </div>

    <asp:Literal ID="litMsg" runat="server" />

    <div class="card">
        <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:14px;">
            <span style="color:#8592a8;font-size:.85rem;">Toplam <asp:Literal ID="litCount" runat="server" /> kart</span>
            <a class="btn" href='<%= "ServiceEdit.aspx?cat=" + CurrentCat %>'>+ Yeni Kart Ekle</a>
        </div>

        <asp:GridView ID="gv" runat="server" CssClass="grid" AutoGenerateColumns="false"
            DataKeyNames="id" OnRowCommand="gv_RowCommand" width="100%">
            <Columns>
                <asp:BoundField HeaderText="Sıra" DataField="sort_order" />
                <asp:BoundField HeaderText="İkon" DataField="icon_key" />
                <asp:BoundField HeaderText="Başlık" DataField="title" />
                <asp:BoundField HeaderText="Açıklama" DataField="description" />
                <asp:TemplateField HeaderText="">
                    <ItemTemplate>
                        <a class="btn small secondary" href='<%# "ServiceEdit.aspx?id=" + Eval("id") %>'>Düzenle</a>
                        <asp:LinkButton ID="btnDelete" runat="server" CssClass="btn small danger"
                            CommandName="DeleteRow" CommandArgument='<%# Eval("id") %>'
                            OnClientClick="return confirm('Bu kartı silmek istediğinize emin misiniz?');">Sil</asp:LinkButton>
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
            <EmptyDataTemplate>Bu kategoride henüz hizmet kartı yok.</EmptyDataTemplate>
        </asp:GridView>
    </div>
</asp:Content>
