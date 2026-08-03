using System;
using MySql.Data.MySqlClient;

public partial class Admin_TeamEdit : System.Web.UI.Page
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
                litHeader.Text = "Ekip Üyesini Düzenle";
                var table = Db.Query("SELECT * FROM team_members WHERE id = @id", new MySqlParameter("@id", EditId.Value));
                if (table.Rows.Count > 0)
                {
                    var row = table.Rows[0];
                    txtName.Text = row["full_name"].ToString();
                    txtRole.Text = row["role_title"].ToString();
                    ddlGroup.SelectedValue = row["team_group"].ToString();
                    txtSortOrder.Text = row["sort_order"].ToString();
                }
            }
            else
            {
                litHeader.Text = "Yeni Ekip Üyesi";
            }
        }
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
        if (!Page.IsValid) return;

        try
        {
            int sortOrder;
            if (!int.TryParse(txtSortOrder.Text, out sortOrder)) sortOrder = 0;

            if (EditId.HasValue)
            {
                Db.Execute(
                    "UPDATE team_members SET full_name=@n, role_title=@r, team_group=@g, sort_order=@s WHERE id=@id",
                    new MySqlParameter("@n", txtName.Text.Trim()),
                    new MySqlParameter("@r", txtRole.Text.Trim()),
                    new MySqlParameter("@g", ddlGroup.SelectedValue),
                    new MySqlParameter("@s", sortOrder),
                    new MySqlParameter("@id", EditId.Value));
            }
            else
            {
                Db.Execute(
                    "INSERT INTO team_members (full_name, role_title, team_group, sort_order) VALUES (@n,@r,@g,@s)",
                    new MySqlParameter("@n", txtName.Text.Trim()),
                    new MySqlParameter("@r", txtRole.Text.Trim()),
                    new MySqlParameter("@g", ddlGroup.SelectedValue),
                    new MySqlParameter("@s", sortOrder));
            }

            Response.Redirect("Team.aspx", false);
        }
        catch (Exception ex)
        {
            litError.Text = "<div class='msg-ok' style='background:#fdecec;color:#b3261e;'>Hata: " +
                             Server.HtmlEncode(ex.Message) + "</div>";
        }
    }
}
