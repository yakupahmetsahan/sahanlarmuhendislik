using System;

/// <summary>
/// site_references tablosundaki bir satırı temsil eder.
/// Kategoriye göre bazı alanlar boş (null) kalabilir:
///  - elektrik: power_value(kVa), enh_meters, direk_count kullanılır
///  - enerji  : power_value(kW/MW) kullanılır
///  - asansor : unit_count (adet) kullanılır
///  - yazilim : sadece name/ref_type/ref_year kullanılabilir
/// </summary>
public class ReferenceItem
{
    public int Id { get; set; }
    public string Category { get; set; }      // elektrik | enerji | asansor | yazilim
    public string Name { get; set; }
    public string RefType { get; set; }
    public string Location { get; set; }
    public int? RefYear { get; set; }
    public decimal? PowerValue { get; set; }
    public string PowerUnit { get; set; }
    public int? EnhMeters { get; set; }
    public int? DirekCount { get; set; }
    public int? UnitCount { get; set; }
    public string PhotoFilename { get; set; }
    public bool IsFeatured { get; set; }
    public int SortOrder { get; set; }

    public static ReferenceItem FromRow(System.Data.DataRow row)
    {
        return new ReferenceItem
        {
            Id = Convert.ToInt32(row["id"]),
            Category = row["category"].ToString(),
            Name = row["name"].ToString(),
            RefType = row["ref_type"] as string,
            Location = row["location"] as string,
            RefYear = row["ref_year"] == DBNull.Value ? (int?)null : Convert.ToInt32(row["ref_year"]),
            PowerValue = row["power_value"] == DBNull.Value ? (decimal?)null : Convert.ToDecimal(row["power_value"]),
            PowerUnit = row["power_unit"] as string,
            EnhMeters = row["enh_meters"] == DBNull.Value ? (int?)null : Convert.ToInt32(row["enh_meters"]),
            DirekCount = row["direk_count"] == DBNull.Value ? (int?)null : Convert.ToInt32(row["direk_count"]),
            UnitCount = row["unit_count"] == DBNull.Value ? (int?)null : Convert.ToInt32(row["unit_count"]),
            PhotoFilename = row["photo_filename"] as string,
            IsFeatured = row["is_featured"] != DBNull.Value && Convert.ToBoolean(row["is_featured"]),
            SortOrder = row["sort_order"] == DBNull.Value ? 0 : Convert.ToInt32(row["sort_order"])
        };
    }
}
