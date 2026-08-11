using System;
using System.Collections.Generic;
using System.IO;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Admin_Images : AdminBasePage
{
    // Kategori anahtarları dosya adlarıyla (tile-{key}.jpg / hero-{key}.jpg) birebir eşleşir.
    private static readonly List<KeyValuePair<string, string>> Categories = new List<KeyValuePair<string, string>>
    {
        new KeyValuePair<string,string>("elektrik", "Elektrik"),
        new KeyValuePair<string,string>("enerji", "Enerji"),
        new KeyValuePair<string,string>("asansor", "Asansör"),
        new KeyValuePair<string,string>("yazilim", "Yazılım"),
        new KeyValuePair<string,string>("hayvancilik", "Hayvancılık"),
        new KeyValuePair<string,string>("tarim", "Tarım"),
    };

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            var items = new List<object>();
            foreach (var c in Categories)
                items.Add(new { Key = c.Key, Label = c.Value });
            rptCategories.DataSource = items;
            rptCategories.DataBind();
        }
    }

    private string TilesFolder()
    {
        // Site kökündeki assets/img/tiles/ klasörü — admin klasörünün bir üstünde.
        string path = System.Configuration.ConfigurationManager.AppSettings["SiteTilesPath"] ?? "~/../assets/img/tiles/";
        return Server.MapPath(path);
    }

    protected void btnSaveCategory_Click(object sender, EventArgs e)
    {
        var btn = (LinkButton)sender;
        var item = (RepeaterItem)btn.NamingContainer;

        var fuTile = (FileUpload)item.FindControl("fuTile");
        var fuHero = (FileUpload)item.FindControl("fuHero");
        var hidKey = (HiddenField)item.FindControl("hidKey");

        string key = hidKey.Value;
        string folder = TilesFolder();

        try
        {
            if (!Directory.Exists(folder)) Directory.CreateDirectory(folder);

            int saved = 0;
            if (fuTile.HasFile)
            {
                ValidateImage(fuTile.FileName);
                fuTile.SaveAs(Path.Combine(folder, "tile-" + key + ".jpg"));
                saved++;
            }
            if (fuHero.HasFile)
            {
                ValidateImage(fuHero.FileName);
                fuHero.SaveAs(Path.Combine(folder, "hero-" + key + ".jpg"));
                saved++;
            }

            litMsg.Text = saved > 0
                ? "<div class='msg-ok'>" + saved + " görsel güncellendi.</div>"
                : "<div class='msg-ok' style='background:#fdecec;color:#b3261e;'>Dosya seçmediniz.</div>";
        }
        catch (Exception ex)
        {
            litMsg.Text = "<div class='msg-ok' style='background:#fdecec;color:#b3261e;'>Hata: " +
                           Server.HtmlEncode(ex.Message) + "</div>";
        }
    }

    private void ValidateImage(string filename)
    {
        string ext = Path.GetExtension(filename).ToLowerInvariant();
        if (ext != ".jpg" && ext != ".jpeg" && ext != ".png")
            throw new Exception("Sadece JPG veya PNG yükleyebilirsiniz (" + filename + ").");
    }
}
