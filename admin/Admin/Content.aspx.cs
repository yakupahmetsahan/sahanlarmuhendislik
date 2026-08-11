using System;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;

public partial class Admin_Content : AdminBasePage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack) BindContent();
    }

    private void BindContent()
    {
        var table = Db.Query(
            "SELECT content_key, content_value FROM page_content WHERE page_key = @p ORDER BY content_key",
            new SqlParameter("@p", ddlPage.SelectedValue));
        rptContent.DataSource = table;
        rptContent.DataBind();
    }

    protected void rptContent_ItemDataBound(object sender, RepeaterItemEventArgs e)
    {
        // Şablon zaten Eval ile bağlanıyor, ekstra işlem gerekmiyor.
    }

    protected void ddlPage_Changed(object sender, EventArgs e)
    {
        BindContent();
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
        foreach (RepeaterItem item in rptContent.Items)
        {
            var hidKey = (HiddenField)item.FindControl("hidKey");
            var txtValue = (TextBox)item.FindControl("txtValue");
            if (hidKey == null || txtValue == null) continue;

            Db.Execute(
                "UPDATE page_content SET content_value = @v WHERE page_key = @p AND content_key = @k",
                new SqlParameter("@v", txtValue.Text),
                new SqlParameter("@p", ddlPage.SelectedValue),
                new SqlParameter("@k", hidKey.Value));
        }

        litMsg.Text = "<div class='msg-ok'>Değişiklikler kaydedildi.</div>";
        BindContent();
    }
}
