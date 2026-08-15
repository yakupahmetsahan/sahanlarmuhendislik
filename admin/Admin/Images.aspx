<%@ Page Language="C#" MasterPageFile="~/admin/Admin/Site.Master" AutoEventWireup="true" CodeFile="Images.aspx.cs" Inherits="Admin_Images" %>
<asp:Content ID="c1" ContentPlaceHolderID="TitleContent" runat="server">Görsel Yönetimi</asp:Content>
<asp:Content ID="c2" ContentPlaceHolderID="MainContent" runat="server">
    <h1 class="page-title">Kategori Görselleri</h1>
    <p style="color:#8592a8;font-size:.88rem;margin-top:-10px;margin-bottom:20px;">
        Her kategori için ana sayfadaki kutucuk (kare) ve kategori sayfasındaki büyük banner (geniş) görselini buradan değiştirebilirsiniz.
        Yeni görsel yüklediğinizde eskisinin yerini otomatik alır.
    </p>
    <asp:Literal ID="litMsg" runat="server" />

    <div class="card">
        <h2 style="margin:0 0 14px;font-size:1.1rem;">Site Logosu</h2>
        <p style="color:#8592a8;font-size:.85rem;margin-top:-8px;">Tüm sayfaların üstündeki logo. PNG önerilir (şeffaf arka plan).</p>
        <img src='<%= "../assets/img/logo.png?v=" + DateTime.Now.Ticks %>'
             style="height:56px;border-radius:6px;border:1px solid #e3e8f0;margin-bottom:10px;display:block;background:#f5f7fb;padding:8px;"
             onerror="this.style.display='none'" />
        <asp:FileUpload ID="fuLogo" runat="server" />
        <div style="margin-top:16px;">
            <asp:LinkButton ID="btnSaveLogo" runat="server" CssClass="btn" OnClick="btnSaveLogo_Click">Logoyu Kaydet</asp:LinkButton>
        </div>
    </div>

    <div class="card">
        <h2 style="margin:0 0 14px;font-size:1.1rem;">Kurumsal Sayfası Fotoğrafı</h2>
        <p style="color:#8592a8;font-size:.85rem;margin-top:-8px;">Kurumsal sayfasının üst banner fotoğrafı.</p>
        <img src='<%= "../assets/img/tiles/hero-kurumsal.jpg?v=" + DateTime.Now.Ticks %>'
             style="width:220px;height:165px;object-fit:cover;border-radius:6px;border:1px solid #e3e8f0;margin-bottom:10px;display:block;"
             onerror="this.style.display='none'" />
        <asp:FileUpload ID="fuKurumsal" runat="server" />
        <div style="margin-top:16px;">
            <asp:LinkButton ID="btnSaveKurumsal" runat="server" CssClass="btn" OnClick="btnSaveKurumsal_Click">Kaydet</asp:LinkButton>
        </div>
    </div>

    <asp:Repeater ID="rptCategories" runat="server">
        <ItemTemplate>
            <div class="card">
                <h2 style="margin:0 0 14px;font-size:1.1rem;"><%# Eval("Label") %></h2>
                <div style="display:flex; gap:32px; flex-wrap:wrap;">
                    <div style="flex:1;min-width:220px;">
                        <label>Kutucuk Görseli (kare, ana sayfa)</label>
                        <img src='<%# "../assets/img/tiles/tile-" + Eval("Key") + ".jpg?v=" + DateTime.Now.Ticks %>'
                             style="width:140px;height:140px;object-fit:cover;border-radius:6px;border:1px solid #e3e8f0;margin-bottom:10px;display:block;"
                             onerror="this.style.display='none'" />
                        <asp:FileUpload ID="fuTile" runat="server" />
                    </div>
                    <div style="flex:1;min-width:280px;">
                        <label>Banner Görseli (geniş, kategori sayfası)</label>
                        <img src='<%# "../assets/img/tiles/hero-" + Eval("Key") + ".jpg?v=" + DateTime.Now.Ticks %>'
                             style="width:220px;height:165px;object-fit:cover;border-radius:6px;border:1px solid #e3e8f0;margin-bottom:10px;display:block;"
                             onerror="this.style.display='none'" />
                        <asp:FileUpload ID="fuHero" runat="server" />
                    </div>
                </div>
                <asp:HiddenField ID="hidKey" runat="server" Value='<%# Eval("Key") %>' />
                <div style="margin-top:16px;">
                    <asp:LinkButton ID="btnSaveCategory" runat="server" CssClass="btn"
                        CommandName="SaveCategory" CommandArgument='<%# Eval("Key") %>'
                        OnClick="btnSaveCategory_Click">Bu Kategoriyi Kaydet</asp:LinkButton>
                </div>
            </div>
        </ItemTemplate>
    </asp:Repeater>
</asp:Content>
