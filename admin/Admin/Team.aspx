<%@ Page Language="C#" MasterPageFile="~/Admin/Site.Master" AutoEventWireup="true" CodeFile="Team.aspx.cs" Inherits="Admin_Team" %>
<asp:Content ID="c1" ContentPlaceHolderID="TitleContent" runat="server">Ekip</asp:Content>
<asp:Content ID="c2" ContentPlaceHolderID="MainContent" runat="server">
    <h1 class="page-title">Ekibimiz</h1>
    <asp:Literal ID="litMsg" runat="server" />
    <div class="card">
        <div style="display:flex; justify-content:flex-end; margin-bottom:14px;">
            <a class="btn" href="TeamEdit.aspx">+ Yeni Ekip Üyesi</a>
        </div>
        <asp:GridView ID="gvTeam" runat="server" CssClass="grid" AutoGenerateColumns="false"
            DataKeyNames="id" OnRowCommand="gvTeam_RowCommand" width="100%">
            <Columns>
                <asp:BoundField HeaderText="Ad Soyad" DataField="full_name" />
                <asp:BoundField HeaderText="Görev" DataField="role_title" />
                <asp:BoundField HeaderText="Grup" DataField="team_group" />
                <asp:TemplateField HeaderText="">
                    <ItemTemplate>
                        <a class="btn small secondary" href='<%# "TeamEdit.aspx?id=" + Eval("id") %>'>Düzenle</a>
                        <asp:LinkButton ID="btnDelete" runat="server" CssClass="btn small danger"
                            CommandName="DeleteRow" CommandArgument='<%# Eval("id") %>'
                            OnClientClick="return confirm('Bu kişiyi silmek istediğinize emin misiniz?');">Sil</asp:LinkButton>
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
            <EmptyDataTemplate>Henüz ekip üyesi eklenmemiş.</EmptyDataTemplate>
        </asp:GridView>
    </div>
</asp:Content>
