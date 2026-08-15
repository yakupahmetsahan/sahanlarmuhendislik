-- ============================================================
-- Şahanlar Mühendislik — Admin Panel Veritabanı Şeması (MSSQL)
-- SQL Server 2012+ uyumlu
-- Kurulum: SQL Server Management Studio (SSMS) veya İHS panelinizin
-- sunduğu MSSQL yönetim aracından "New Query" ile bu dosyanın
-- tamamını çalıştırın.
-- ============================================================

-- ------------------------------------------------------------
-- 1) Yönetici kullanıcıları
-- ------------------------------------------------------------
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'admin_users')
CREATE TABLE admin_users (
    id              INT IDENTITY(1,1) PRIMARY KEY,
    username        NVARCHAR(50)  NOT NULL UNIQUE,
    password_hash   NVARCHAR(255) NOT NULL,   -- SHA256 hex (bkz. Db.cs -> HashPassword)
    display_name    NVARCHAR(100) NOT NULL,
    created_at      DATETIME NOT NULL DEFAULT GETDATE(),
    last_login_at   DATETIME NULL
);
GO

-- Varsayılan kullanıcı: admin / Sahanlar2026!
-- (bu hash aşağıdaki şifrenin SHA256'sıdır — ilk girişten sonra
--  Admin panelden mutlaka değiştirin — bkz. sifre-hash-araci.html)
IF NOT EXISTS (SELECT * FROM admin_users WHERE username = 'admin')
INSERT INTO admin_users (username, password_hash, display_name)
VALUES ('admin', '6d0147963a52b66a8cac073e3a3e90fe175b05e454e33eb3fcfcaca11b6f2ae6', N'Yönetici');
GO

-- ------------------------------------------------------------
-- 2) Referanslar (Elektrik / Enerji / Asansör / Yazılım ortak tablo)
-- ------------------------------------------------------------
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'site_references')
CREATE TABLE site_references (
    id              INT IDENTITY(1,1) PRIMARY KEY,
    category        NVARCHAR(20) NOT NULL,      -- 'elektrik','enerji','asansor','yazilim','hayvancilik','tarim'
    name            NVARCHAR(200) NOT NULL,     -- Firma / proje adı
    ref_type        NVARCHAR(150) NULL,         -- Tür
    location        NVARCHAR(150) NULL,         -- İl / ilçe
    ref_year        INT NULL,
    power_value     DECIMAL(10,2) NULL,         -- kVa / kW değeri
    power_unit      NVARCHAR(20) NULL,
    enh_meters      INT NULL,                   -- Enerji Nakil Hattı uzunluğu (metre)
    direk_count     INT NULL,
    unit_count      INT NULL,                   -- Adet (asansör vb.)
    photo_filename  NVARCHAR(255) NULL,
    is_featured     BIT NOT NULL DEFAULT 0,
    sort_order      INT NOT NULL DEFAULT 0,
    created_at      DATETIME NOT NULL DEFAULT GETDATE(),
    updated_at      DATETIME NOT NULL DEFAULT GETDATE()
);
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'idx_category' AND object_id = OBJECT_ID('site_references'))
CREATE INDEX idx_category ON site_references(category);
GO

-- ------------------------------------------------------------
-- 3) Ekip üyeleri
-- ------------------------------------------------------------
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'team_members')
CREATE TABLE team_members (
    id              INT IDENTITY(1,1) PRIMARY KEY,
    full_name       NVARCHAR(150) NOT NULL,
    role_title      NVARCHAR(200) NOT NULL,
    team_group      NVARCHAR(100) NOT NULL,
    photo_filename  NVARCHAR(255) NULL,
    sort_order      INT NOT NULL DEFAULT 0,
    created_at      DATETIME NOT NULL DEFAULT GETDATE(),
    updated_at      DATETIME NOT NULL DEFAULT GETDATE()
);
GO

-- ------------------------------------------------------------
-- 4) Sayfa metinleri
-- ------------------------------------------------------------
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'page_content')
CREATE TABLE page_content (
    id              INT IDENTITY(1,1) PRIMARY KEY,
    page_key        NVARCHAR(50)  NOT NULL,
    content_key     NVARCHAR(100) NOT NULL,
    content_value   NVARCHAR(MAX) NULL,
    updated_at      DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT uq_page_content UNIQUE (page_key, content_key)
);
GO

-- Başlangıç içerikleri
MERGE page_content AS target
USING (VALUES
    (N'index', N'hero_eyebrow', N'Çivril / Denizli — 2016''dan bu yana'),
    (N'index', N'hero_title', N'Mühendisliği dört alanda birleştiriyoruz.'),
    (N'index', N'hero_lead', N'Elektrik, enerji, asansör ve yazılım — işletmenizin ihtiyaç duyduğu her mühendislik çözümünü tek adresten sunuyoruz. Devam etmek istediğin alanı seç.'),
    (N'index', N'about_text', N'Şahanlar Mühendislik olarak, 2016 yılında elektrik sektöründe faaliyetlerimize başlamış olup, geçen yıllar içerisinde enerji ve asansör sektörlerinde de hizmet vermeye başlayarak çalışma alanlarımızı genişletmiş, son olarak da yazılım alanına adım atmış bulunmaktayız.'),
    (N'elektrik', N'hero_title', N'Tesisattan panoya, mühendislik güvencesiyle elektrik.'),
    (N'elektrik', N'hero_lead', N'Konut, işyeri ve sanayi tesislerinde elektrik tesisatı, pano ve aydınlatma sistemlerini proje aşamasından bakıma kadar uçtan uca yürütüyoruz.'),
    (N'enerji', N'hero_title', N'Enerjini verimli kullanmanın mühendislik yolu.'),
    (N'enerji', N'hero_lead', N'Enerji verimliliğinden kompanzasyona, yenilenebilir enerji sistemlerinden enerji kimlik belgesine kadar işletmenizin enerji maliyetini düşürecek çözümleri planlıyoruz.'),
    (N'asansor', N'hero_title', N'Asansörde güvenlik ve konforu bir arada sağlıyoruz.'),
    (N'asansor', N'hero_lead', N'Yeni asansör montajından periyodik bakım ve revizyona kadar, yönetmeliklere uygun asansör hizmetleri sunuyoruz.'),
    (N'yazilim', N'hero_title', N'İşletmenizin operasyonunu yöneten yazılımlar.'),
    (N'yazilim', N'hero_lead', N'Perde otomasyonundan muhasebe ve POS takibine kadar, işletmelerin günlük operasyonunu kolaylaştıran masaüstü yazılımlar geliştiriyoruz.')
) AS source (page_key, content_key, content_value)
ON target.page_key = source.page_key AND target.content_key = source.content_key
WHEN MATCHED THEN UPDATE SET content_value = source.content_value
WHEN NOT MATCHED THEN INSERT (page_key, content_key, content_value) VALUES (source.page_key, source.content_key, source.content_value);
GO

-- ------------------------------------------------------------
-- 5) Hizmet kartları (her kategori sayfasındaki "Hizmetlerimiz" bölümü)
-- ------------------------------------------------------------
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'service_items')
CREATE TABLE service_items (
    id              INT IDENTITY(1,1) PRIMARY KEY,
    category        NVARCHAR(20) NOT NULL,      -- 'elektrik','enerji','asansor','yazilim'
    icon_key        NVARCHAR(30) NOT NULL DEFAULT 'check',
    title           NVARCHAR(200) NOT NULL,
    description     NVARCHAR(400) NULL,
    sort_order      INT NOT NULL DEFAULT 0,
    created_at      DATETIME NOT NULL DEFAULT GETDATE(),
    updated_at      DATETIME NOT NULL DEFAULT GETDATE()
);
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'idx_service_category' AND object_id = OBJECT_ID('service_items'))
CREATE INDEX idx_service_category ON service_items(category);
GO

-- ------------------------------------------------------------
-- 6) Yazılım referansları için indirme linki alanı
-- ------------------------------------------------------------
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('site_references') AND name = 'download_url')
ALTER TABLE site_references ADD download_url NVARCHAR(500) NULL;
GO
