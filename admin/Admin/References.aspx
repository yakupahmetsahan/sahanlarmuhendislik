<%@ Page Language="C#" MasterPageFile="~/admin/Admin/Site.Master" AutoEventWireup="true" CodeFile="References.aspx.cs" Inherits="Admin_References" %>
<asp:Content ID="c1" ContentPlaceHolderID="TitleContent" runat="server">Referanslar</asp:Content>
<asp:Content ID="c2" ContentPlaceHolderID="MainContent" runat="server">
    <h1 class="page-title"><asp:Literal ID="litCategoryTitle" runat="server" /> Referansları</h1>

    <asp:Literal ID="litMsg" runat="server" />

    <div class="card">
        <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:14px;">
            <span style="color:#8592a8;font-size:.85rem;">
                Toplam <asp:Literal ID="litCount" runat="server" /> kayıt
            </span>
            <a class="btn" href='<%= "ReferenceEdit.aspx?cat=" + CategoryKey %>'>+ Yeni Referans Ekle</a>
        </div>

        <asp:GridView ID="gvReferences" runat="server" CssClass="grid" AutoGenerateColumns="false"
            DataKeyNames="id" OnRowCommand="gvReferences_RowCommand" width="100%">
            <Columns>
                <asp:TemplateField HeaderText="Foto">
                    <ItemTemplate>
                        <asp:Image ID="imgThumb" runat="server" CssClass="thumb"
                            Visible='<%# !string.IsNullOrEmpty(Eval("photo_filename") as string) %>'
                            ImageUrl='<%# "~/admin/Uploads/references/" + Eval("photo_filename") %>' />
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:BoundField HeaderText="Ad" DataField="name" />
                <asp:BoundField HeaderText="Tür" DataField="ref_type" />
                <asp:BoundField HeaderText="Yer" DataField="location" />
                <asp:BoundField HeaderText="Yıl" DataField="ref_year" />
                <asp:TemplateField HeaderText="Değer">
                    <ItemTemplate><%# FormatPower(Eval("power_value"), Eval("power_unit"), Eval("enh_meters"), Eval("unit_count")) %></ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Öne Çıkan">
                    <ItemTemplate><%# (bool)Eval("is_featured") ? "<span class='badge'>Evet</span>" : "" %></ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="">
                    <ItemTemplate>
                        <a class="btn small secondary" href='<%# "ReferenceEdit.aspx?id=" + Eval("id") %>'>Düzenle</a>
                        <asp:LinkButton ID="btnDelete" runat="server" CssClass="btn small danger"
                            CommandName="DeleteRow" CommandArgument='<%# Eval("id") %>'
                            OnClientClick="return confirm('Bu referansı silmek istediğinize emin misiniz?');">Sil</asp:LinkButton>
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
            <EmptyDataTemplate>Bu kategoride henüz referans yok.</EmptyDataTemplate>
        </asp:GridView>
    </div>
</asp:Content>
