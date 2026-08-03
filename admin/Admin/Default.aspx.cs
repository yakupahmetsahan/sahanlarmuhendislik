using System;
using MySql.Data.MySqlClient;

public partial class Admin_Default : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            litElektrik.Text = CountFor("elektrik");
            litEnerji.Text = CountFor("enerji");
            litAsansor.Text = CountFor("asansor");
            litYazilim.Text = CountFor("yazilim");

            var teamTable = Db.Query("SELECT COUNT(*) AS c FROM team_members");
            litTeam.Text = teamTable.Rows[0]["c"].ToString();
        }
    }

    private string CountFor(string category)
    {
        var table = Db.Query(
            "SELECT COUNT(*) AS c FROM site_references WHERE category = @c",
            new MySqlParameter("@c", category));
        return table.Rows[0]["c"].ToString();
    }
}
