using System;
using System.Web.UI.WebControls;
using System.Data.SqlClient;

public partial class Admin_Team : AdminBasePage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack) BindGrid();
    }

    private void BindGrid()
    {
        var table = Db.Query("SELECT * FROM team_members ORDER BY team_group, sort_order, full_name");
        gvTeam.DataSource = table;
        gvTeam.DataBind();
    }

    protected void gvTeam_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "DeleteRow")
        {
            int id = Convert.ToInt32(e.CommandArgument);
            Db.Execute("DELETE FROM team_members WHERE id = @id", new SqlParameter("@id", id));
            litMsg.Text = "<div class='msg-ok'>Ekip üyesi silindi.</div>";
            BindGrid();
        }
    }
}
