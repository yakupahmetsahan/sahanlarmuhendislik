<%@ WebHandler Language="C#" Class="Api_References" %>

using System;
using System.Data;
using System.Text;
using System.Web;
using System.Data.SqlClient;

/// <summary>
/// Herkese açık, salt-okunur JSON uç noktası.
/// Kullanım: /Api/References.ashx?category=elektrik
/// Statik site sayfaları bu adresten fetch() ile veri çekip
/// tabloları/kartları JavaScript ile oluşturabilir.
/// </summary>
public class Api_References : IHttpHandler
{
    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "application/json; charset=utf-8";
        context.Response.Headers.Add("Access-Control-Allow-Origin", "*");
        context.Response.Cache.SetCacheability(System.Web.HttpCacheability.NoCache);
        context.Response.Cache.SetNoStore();

        string category = context.Request.QueryString["category"];
        var allowed = new[] { "elektrik", "enerji", "asansor", "yazilim" };
        if (string.IsNullOrEmpty(category) || Array.IndexOf(allowed, category) < 0)
        {
            context.Response.StatusCode = 400;
            context.Response.Write("{\"error\":\"category parametresi elektrik|enerji|asansor|yazilim olmalı\"}");
            return;
        }

        DataTable table = Db.Query(
            "SELECT id,name,ref_type,location,ref_year,power_value,power_unit,enh_meters,direk_count,unit_count,photo_filename,is_featured,download_url " +
            "FROM site_references WHERE category=@c ORDER BY sort_order, ref_year DESC, name",
            new SqlParameter("@c", category));

        context.Response.Write(ToJsonArray(table));
    }

    private string ToJsonArray(DataTable table)
    {
        var sb = new StringBuilder();
        sb.Append("[");
        for (int i = 0; i < table.Rows.Count; i++)
        {
            if (i > 0) sb.Append(",");
            var row = table.Rows[i];
            sb.Append("{");
            sb.Append("\"id\":" + row["id"] + ",");
            sb.Append("\"name\":" + JsonStr(row["name"]) + ",");
            sb.Append("\"type\":" + JsonStr(row["ref_type"]) + ",");
            sb.Append("\"location\":" + JsonStr(row["location"]) + ",");
            sb.Append("\"year\":" + JsonNum(row["ref_year"]) + ",");
            sb.Append("\"power_value\":" + JsonNum(row["power_value"]) + ",");
            sb.Append("\"power_unit\":" + JsonStr(row["power_unit"]) + ",");
            sb.Append("\"enh_meters\":" + JsonNum(row["enh_meters"]) + ",");
            sb.Append("\"direk_count\":" + JsonNum(row["direk_count"]) + ",");
            sb.Append("\"unit_count\":" + JsonNum(row["unit_count"]) + ",");
            sb.Append("\"photo_url\":" + JsonPhotoUrl(row["photo_filename"]) + ",");
            sb.Append("\"download_url\":" + JsonStr(row["download_url"]) + ",");
            sb.Append("\"is_featured\":" + (Convert.ToBoolean(row["is_featured"]) ? "true" : "false"));
            sb.Append("}");
        }
        sb.Append("]");
        return sb.ToString();
    }

    private string JsonStr(object val)
    {
        if (val == DBNull.Value || val == null) return "null";
        string s = val.ToString().Replace("\\", "\\\\").Replace("\"", "\\\"");
        return "\"" + s + "\"";
    }

    private string JsonNum(object val)
    {
        if (val == DBNull.Value || val == null) return "null";
        return Convert.ToString(val, System.Globalization.CultureInfo.InvariantCulture);
    }

    private string JsonPhotoUrl(object filename)
    {
        if (filename == DBNull.Value || filename == null || string.IsNullOrEmpty(filename.ToString()))
            return "null";
        return "\"/admin/Uploads/references/" + filename + "\"";
    }

    public bool IsReusable { get { return false; } }
}
