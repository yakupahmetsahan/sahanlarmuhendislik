using System;
using System.IO;
using System.Data.SqlClient;

public partial class Admin_ReferenceEdit : AdminBasePage
{
    private int? EditId
    {
        get
        {
            int id;
            return int.TryParse(Request.QueryString["id"], out id) ? (int?)id : null;
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            if (EditId.HasValue)
            {
                litHeader.Text = "Referansı Düzenle";
                LoadExisting(EditId.Value);
            }
            else
            {
                litHeader.Text = "Yeni Referans";
                string cat = Request.QueryString["cat"];
                if (!string.IsNullOrEmpty(cat)) ddlCategory.SelectedValue = cat;
            }
        }
    }

    private void LoadExisting(int id)
    {
        var table = Db.Query("SELECT * FROM site_references WHERE id = @id", new SqlParameter("@id", id));
        if (table.Rows.Count == 0) return;
        var row = table.Rows[0];
        var inv = System.Globalization.CultureInfo.InvariantCulture;

        ddlCategory.SelectedValue = row["category"].ToString();
        txtName.Text = row["name"].ToString();
        txtType.Text = row["ref_type"] as string;
        txtLocation.Text = row["location"] as string;
        txtYear.Text = row["ref_year"] == DBNull.Value ? "" : Convert.ToInt32(row["ref_year"]).ToString(inv);
        txtPowerValue.Text = row["power_value"] == DBNull.Value ? "" : Convert.ToDecimal(row["power_value"]).ToString(inv);
        ddlPowerUnit.SelectedValue = row["power_unit"] as string ?? "";
        txtEnh.Text = row["enh_meters"] == DBNull.Value ? "" : Convert.ToInt32(row["enh_meters"]).ToString(inv);
        txtDirek.Text = row["direk_count"] == DBNull.Value ? "" : Convert.ToInt32(row["direk_count"]).ToString(inv);
        txtUnitCount.Text = row["unit_count"] == DBNull.Value ? "" : Convert.ToInt32(row["unit_count"]).ToString(inv);
        chkFeatured.Checked = row["is_featured"] != DBNull.Value && Convert.ToBoolean(row["is_featured"]);
        txtSortOrder.Text = row["sort_order"].ToString();
        txtDownloadUrl.Text = row["download_url"] as string;

        string photo = row["photo_filename"] as string;
        if (!string.IsNullOrEmpty(photo))
        {
            imgCurrent.ImageUrl = "~/admin/Uploads/references/" + photo;
            imgCurrent.Visible = true;
            litCurrentPhoto.Text = " Mevcut: " + photo;
        }
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
        if (!Page.IsValid) return;

        try
        {
            string photoFilename = null;

            if (EditId.HasValue)
            {
                var existing = Db.Query("SELECT photo_filename FROM site_references WHERE id = @id",
                    new SqlParameter("@id", EditId.Value));
                if (existing.Rows.Count > 0)
                    photoFilename = existing.Rows[0]["photo_filename"] as string;
            }

            if (fuPhoto.HasFile)
            {
                photoFilename = SavePhoto(fuPhoto);
            }

            var pars = new[]
            {
                new SqlParameter("@category", ddlCategory.SelectedValue),
                new SqlParameter("@name", txtName.Text.Trim()),
                new SqlParameter("@ref_type", NullIfEmpty(txtType.Text)),
                new SqlParameter("@location", NullIfEmpty(txtLocation.Text)),
                new SqlParameter("@ref_year", NullIfEmptyInt(txtYear.Text)),
                new SqlParameter("@power_value", NullIfEmptyDecimal(txtPowerValue.Text)),
                new SqlParameter("@power_unit", NullIfEmpty(ddlPowerUnit.SelectedValue)),
                new SqlParameter("@enh_meters", NullIfEmptyInt(txtEnh.Text)),
                new SqlParameter("@direk_count", NullIfEmptyInt(txtDirek.Text)),
                new SqlParameter("@unit_count", NullIfEmptyInt(txtUnitCount.Text)),
                new SqlParameter("@photo_filename", (object)photoFilename ?? DBNull.Value),
                new SqlParameter("@download_url", NullIfEmpty(txtDownloadUrl.Text)),
                new SqlParameter("@is_featured", chkFeatured.Checked ? 1 : 0),
                new SqlParameter("@sort_order", string.IsNullOrWhiteSpace(txtSortOrder.Text) ? 0 : int.Parse(txtSortOrder.Text))
            };

            if (EditId.HasValue)
            {
                Db.Execute(@"UPDATE site_references SET
                                category=@category, name=@name, ref_type=@ref_type, location=@location,
                                ref_year=@ref_year, power_value=@power_value, power_unit=@power_unit,
                                enh_meters=@enh_meters, direk_count=@direk_count, unit_count=@unit_count,
                                photo_filename=@photo_filename, is_featured=@is_featured, sort_order=@sort_order,
                                download_url=@download_url
                             WHERE id=@id",
                    Concat(pars, new SqlParameter("@id", EditId.Value)));
            }
            else
            {
                Db.Execute(@"INSERT INTO site_references
                                (category,name,ref_type,location,ref_year,power_value,power_unit,
                                 enh_meters,direk_count,unit_count,photo_filename,is_featured,sort_order,download_url)
                             VALUES
                                (@category,@name,@ref_type,@location,@ref_year,@power_value,@power_unit,
                                 @enh_meters,@direk_count,@unit_count,@photo_filename,@is_featured,@sort_order,@download_url)",
                    pars);
            }

            Response.Redirect("References.aspx?cat=" + ddlCategory.SelectedValue, false);
        }
        catch (Exception ex)
        {
            litError.Text = "<div class='msg-ok' style='background:#fdecec;color:#b3261e;'>Hata: " +
                             Server.HtmlEncode(ex.Message) + "</div>";
        }
    }

    private string SavePhoto(System.Web.UI.WebControls.FileUpload upload)
    {
        string ext = Path.GetExtension(upload.FileName).ToLowerInvariant();
        if (ext != ".jpg" && ext != ".jpeg" && ext != ".png")
            throw new Exception("Sadece JPG veya PNG dosyaları yüklenebilir.");

        string safeName = ddlCategory.SelectedValue + "-" + Guid.NewGuid().ToString("N").Substring(0, 8) + ext;
        string folder = Server.MapPath("~/admin/Uploads/references/");
        if (!Directory.Exists(folder)) Directory.CreateDirectory(folder);
        upload.SaveAs(Path.Combine(folder, safeName));
        return safeName;
    }

    private static object NullIfEmpty(string s) { return string.IsNullOrWhiteSpace(s) ? (object)DBNull.Value : s.Trim(); }
    private static object NullIfEmptyInt(string s) { int v; return int.TryParse(s, out v) ? (object)v : DBNull.Value; }
    private static object NullIfEmptyDecimal(string s) { decimal v; return decimal.TryParse(s, out v) ? (object)v : DBNull.Value; }

    private static SqlParameter[] Concat(SqlParameter[] arr, SqlParameter extra)
    {
        var list = new System.Collections.Generic.List<SqlParameter>(arr) { extra };
        return list.ToArray();
    }
}
