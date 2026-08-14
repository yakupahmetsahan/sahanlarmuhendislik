<%@ WebHandler Language="C#" Class="Api_Services" %>

using System;
using System.Data;
using System.Text;
using System.Web;
using System.Data.SqlClient;

/// <summary>
/// Herkese açık, salt-okunur JSON uç noktası.
/// Kullanım: /Api/Services.ashx?category=elektrik
/// </summary>
public class Api_Services : IHttpHandler
{
    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "application/json; charset=utf-8";
        context.Response.Headers.Add("Access-Control-Allow-Origin", "*");

        string category = context.Request.QueryString["category"];
        var allowed = new[] { "elektrik", "enerji", "asansor", "yazilim" };
        if (string.IsNullOrEmpty(category) || Array.IndexOf(allowed, category) < 0)
        {
            context.Response.StatusCode = 400;
            context.Response.Write("{\"error\":\"category parametresi elektrik|enerji|asansor|yazilim olmalı\"}");
            return;
        }

        DataTable table = Db.Query(
            "SELECT id, icon_key, title, description FROM service_items WHERE category=@c ORDER BY sort_order, id",
            new SqlParameter("@c", category));

        var sb = new StringBuilder();
        sb.Append("[");
        for (int i = 0; i < table.Rows.Count; i++)
        {
            if (i > 0) sb.Append(",");
            var row = table.Rows[i];
            sb.Append("{");
            sb.Append("\"id\":" + row["id"] + ",");
            sb.Append("\"icon_key\":" + JsonStr(row["icon_key"]) + ",");
            sb.Append("\"title\":" + JsonStr(row["title"]) + ",");
            sb.Append("\"description\":" + JsonStr(row["description"]));
            sb.Append("}");
        }
        sb.Append("]");
        context.Response.Write(sb.ToString());
    }

    private string JsonStr(object val)
    {
        if (val == DBNull.Value || val == null) return "null";
        string s = val.ToString().Replace("\\", "\\\\").Replace("\"", "\\\"");
        return "\"" + s + "\"";
    }

    public bool IsReusable { get { return false; } }
}
