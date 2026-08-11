using System;
using System.Configuration;
using System.Data;
using System.Security.Cryptography;
using System.Text;
using MySql.Data.MySqlClient;

/// <summary>
/// Basit veritabanı yardımcı sınıfı. Tüm sayfalar bu sınıf üzerinden
/// MySQL'e bağlanır. Bağlantı bilgisi Web.config -> connectionStrings
/// içindeki "SahanlarDb" değerinden okunur.
/// </summary>
public static class Db
{
    private static string ConnStr
    {
        get { return ConfigurationManager.ConnectionStrings["SahanlarDb"].ConnectionString; }
    }

    public static MySqlConnection GetConnection()
    {
        var conn = new MySqlConnection(ConnStr);
        conn.Open();
        return conn;
    }

    /// <summary>SELECT sorgusu çalıştırır ve DataTable döner.</summary>
    public static DataTable Query(string sql, params MySqlParameter[] parameters)
    {
        using (var conn = GetConnection())
        using (var cmd = new MySqlCommand(sql, conn))
        {
            if (parameters != null) cmd.Parameters.AddRange(parameters);
            using (var adapter = new MySqlDataAdapter(cmd))
            {
                var table = new DataTable();
                adapter.Fill(table);
                return table;
            }
        }
    }

    /// <summary>INSERT / UPDATE / DELETE çalıştırır, etkilenen satır sayısını döner.</summary>
    public static int Execute(string sql, params MySqlParameter[] parameters)
    {
        using (var conn = GetConnection())
        using (var cmd = new MySqlCommand(sql, conn))
        {
            if (parameters != null) cmd.Parameters.AddRange(parameters);
            return cmd.ExecuteNonQuery();
        }
    }

    /// <summary>INSERT sonrası eklenen satırın otomatik ID'sini döner.</summary>
    public static long ExecuteInsertReturnId(string sql, params MySqlParameter[] parameters)
    {
        using (var conn = GetConnection())
        using (var cmd = new MySqlCommand(sql, conn))
        {
            if (parameters != null) cmd.Parameters.AddRange(parameters);
            cmd.ExecuteNonQuery();
            return cmd.LastInsertedId;
        }
    }

    /// <summary>Şifreyi admin_users.password_hash ile aynı yöntemle (SHA256) hashler.</summary>
    public static string HashPassword(string plainText)
    {
        using (var sha = SHA256.Create())
        {
            var bytes = sha.ComputeHash(Encoding.UTF8.GetBytes(plainText));
            var sb = new StringBuilder();
            foreach (var b in bytes) sb.Append(b.ToString("x2"));
            return sb.ToString();
        }
    }
}
