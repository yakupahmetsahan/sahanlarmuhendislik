using System;
using System.Data.SqlClient;

public partial class Admin_ServiceEdit : AdminBasePage
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
                litHeader.Text = "Hizmet Kartını Düzenle";
                LoadExisting(EditId.Value);
            }
            else
            {
                litHeader.Text = "Yeni Hizmet Kartı";
                string cat = Request.QueryString["cat"];
                if (!string.IsNullOrEmpty(cat)) ddlCategory.SelectedValue = cat;
            }
        }
    }

    private void LoadExisting(int id)
    {
        var table = Db.Query("SELECT * FROM service_items WHERE id = @id", new SqlParameter("@id", id));
        if (table.Rows.Count == 0) return;
        var row = table.Rows[0];
        var inv = System.Globalization.CultureInfo.InvariantCulture;

        ddlCategory.SelectedValue = row["category"].ToString();
        ddlIcon.SelectedValue = row["icon_key"].ToString();
        txtTitle.Text = row["title"].ToString();
        txtDescription.Text = row["description"] as string;
        txtSortOrder.Text = Convert.ToInt32(row["sort_order"]).ToString(inv);
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
        if (!Page.IsValid) return;

        int sortOrder;
        if (!int.TryParse(txtSortOrder.Text, out sortOrder)) sortOrder = 0;

        if (EditId.HasValue)
        {
            Db.Execute(
                "UPDATE service_items SET category=@cat, icon_key=@icon, title=@title, description=@desc, sort_order=@sort, updated_at=GETDATE() WHERE id=@id",
                new SqlParameter("@cat", ddlCategory.SelectedValue),
                new SqlParameter("@icon", ddlIcon.SelectedValue),
                new SqlParameter("@title", txtTitle.Text.Trim()),
                new SqlParameter("@desc", (object)txtDescription.Text.Trim() ?? DBNull.Value),
                new SqlParameter("@sort", sortOrder),
                new SqlParameter("@id", EditId.Value));
        }
        else
        {
            Db.Execute(
                "INSERT INTO service_items (category, icon_key, title, description, sort_order) VALUES (@cat, @icon, @title, @desc, @sort)",
                new SqlParameter("@cat", ddlCategory.SelectedValue),
                new SqlParameter("@icon", ddlIcon.SelectedValue),
                new SqlParameter("@title", txtTitle.Text.Trim()),
                new SqlParameter("@desc", (object)txtDescription.Text.Trim() ?? DBNull.Value),
                new SqlParameter("@sort", sortOrder));
        }

        Response.Redirect("~/admin/Admin/Services.aspx?cat=" + ddlCategory.SelectedValue, false);
    }
}
