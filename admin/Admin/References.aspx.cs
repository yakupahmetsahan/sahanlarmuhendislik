using System;
using System.IO;
using System.Web.UI.WebControls;
using System.Data.SqlClient;

public partial class Admin_References : AdminBasePage
{
    private static readonly System.Collections.Generic.Dictionary<string, string> CategoryLabels =
        new System.Collections.Generic.Dictionary<string, string>
        {
            { "elektrik", "Elektrik" },
            { "enerji", "Enerji" },
            { "asansor", "Asansör" },
            { "yazilim", "Yazılım" }
        };

    public string CategoryKey
    {
        get
        {
            string cat = Request.QueryString["cat"];
            return CategoryLabels.ContainsKey(cat) ? cat : "elektrik";
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        litCategoryTitle.Text = CategoryLabels[CategoryKey];
        BindGrid();
    }

    private void BindGrid()
    {
        var table = Db.Query(
            "SELECT * FROM site_references WHERE category = @cat ORDER BY sort_order, ref_year DESC, name",
            new SqlParameter("@cat", CategoryKey));
        gvReferences.DataSource = table;
        gvReferences.DataBind();
        litCount.Text = table.Rows.Count.ToString();
    }

    protected void gvReferences_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "DeleteRow")
        {
            int id = Convert.ToInt32(e.CommandArgument);

            // Fotoğraf dosyasını da diskten sil
            var table = Db.Query("SELECT photo_filename FROM site_references WHERE id = @id",
                new SqlParameter("@id", id));
            if (table.Rows.Count > 0 && table.Rows[0]["photo_filename"] != DBNull.Value)
            {
                string filename = table.Rows[0]["photo_filename"].ToString();
                if (!string.IsNullOrEmpty(filename))
                {
                    string path = Server.MapPath("~/Uploads/references/" + filename);
                    if (File.Exists(path)) File.Delete(path);
                }
            }

            Db.Execute("DELETE FROM site_references WHERE id = @id", new SqlParameter("@id", id));
            litMsg.Text = "<div class='msg-ok'>Referans silindi.</div>";
            BindGrid();
        }
    }

    /// <summary>Kategoriye göre uygun değeri (kVa / kW / adet / ENH metre) formatlar.</summary>
    protected string FormatPower(object powerValue, object powerUnit, object enh, object unitCount)
    {
        string result = "";
        if (powerValue != DBNull.Value && powerValue != null)
        {
            result = Convert.ToDecimal(powerValue).ToString("0.##") + " " + (powerUnit as string ?? "");
        }
        if (enh != DBNull.Value && enh != null)
        {
            if (result != "") result += " · ";
            result += enh + " m ENH";
        }
        if (unitCount != DBNull.Value && unitCount != null && Convert.ToInt32(unitCount) > 0)
        {
            if (result != "") result += " · ";
            result += unitCount + " adet";
        }
        return result;
    }
}
