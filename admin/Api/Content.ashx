<%@ WebHandler Language="C#" Class="Api_Content" %>

using System;
using System.Data;
using System.Text;
using System.Web;
using System.Data.SqlClient;

/// <summary>
/// Herkese açık, salt-okunur JSON uç noktası.
/// Kullanım: /Api/Content.ashx?page=elektrik
/// Döner: {"hero_title":"...","hero_lead":"..."}
/// </summary>
public class Api_Content : IHttpHandler
{
    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "application/json; charset=utf-8";
        context.Response.Headers.Add("Access-Control-Allow-Origin", "*");
        context.Response.Cache.SetCacheability(HttpCacheability.NoCache);
        context.Response.Cache.SetNoStore();

        string page = context.Request.QueryString["page"];
        var allowed = new[] { "index", "elektrik", "enerji", "asansor", "yazilim" };
        if (string.IsNullOrEmpty(page) || Array.IndexOf(allowed, page) < 0)
        {
            context.Response.StatusCode = 400;
            context.Response.Write("{\"error\":\"page parametresi index|elektrik|enerji|asansor|yazilim olmalı\"}");
            return;
        }

        DataTable table = Db.Query(
            "SELECT content_key, content_value FROM page_content WHERE page_key=@p",
            new SqlParameter("@p", page));

        var sb = new StringBuilder();
        sb.Append("{");
        for (int i = 0; i < table.Rows.Count; i++)
        {
            if (i > 0) sb.Append(",");
            var row = table.Rows[i];
            sb.Append(JsonStr(row["content_key"]) + ":" + JsonStr(row["content_value"]));
        }
        sb.Append("}");
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
