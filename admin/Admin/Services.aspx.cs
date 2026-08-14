using System;
using System.Web.UI.WebControls;
using System.Data.SqlClient;

public partial class Admin_Services : AdminBasePage
{
    private static readonly System.Collections.Generic.Dictionary<string, string> CategoryLabels =
        new System.Collections.Generic.Dictionary<string, string>
        {
            { "elektrik", "Elektrik" },
            { "enerji", "Enerji" },
            { "asansor", "Asansör" },
            { "yazilim", "Yazılım" }
        };

    public string CurrentCat
    {
        get
        {
            string cat = Request.QueryString["cat"];
            return !string.IsNullOrEmpty(cat) && CategoryLabels.ContainsKey(cat) ? cat : "elektrik";
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        BindGrid();
    }

    private void BindGrid()
    {
        var table = Db.Query(
            "SELECT * FROM service_items WHERE category = @cat ORDER BY sort_order, id",
            new SqlParameter("@cat", CurrentCat));
        gv.DataSource = table;
        gv.DataBind();
        litCount.Text = table.Rows.Count.ToString();
    }

    protected void gv_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "DeleteRow")
        {
            int id = Convert.ToInt32(e.CommandArgument);
            Db.Execute("DELETE FROM service_items WHERE id = @id", new SqlParameter("@id", id));
            litMsg.Text = "<div class='msg-ok'>Kart silindi.</div>";
            BindGrid();
        }
    }
}
