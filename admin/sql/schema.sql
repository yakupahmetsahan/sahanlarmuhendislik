-- ============================================================
-- Şahanlar Mühendislik — Admin Panel Veritabanı Şeması
-- MySQL 5.7+ / 8.0 uyumlu
-- Kurulum: bu dosyanın tamamını phpMyAdmin (veya hostinginizin
-- sunduğu MySQL yönetim aracı) üzerinden "Import / İçe Aktar"
-- sekmesinden çalıştırmanız yeterli.
-- ============================================================

SET NAMES utf8;
SET FOREIGN_KEY_CHECKS = 0;

-- ------------------------------------------------------------
-- 1) Yönetici kullanıcıları
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS admin_users (
    id              INT AUTO_INCREMENT PRIMARY KEY,
    username        VARCHAR(50)  NOT NULL UNIQUE,
    password_hash   VARCHAR(255) NOT NULL,   -- SHA256 hex (bkz. Db.cs -> HashPassword)
    display_name    VARCHAR(100) NOT NULL,
    created_at      TIMESTAMP NULL DEFAULT NULL,
    last_login_at   DATETIME NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Varsayılan kullanıcı: admin / Sahanlar2026!
-- (bu hash aşağıdaki şifrenin SHA256'sıdır — ilk girişten sonra
--  Admin panelden mutlaka değiştirin)
-- Not: hash SQL içinde SHA2() ile değil, Python'da önceden hesaplanıp
-- düz metin olarak yazıldı — bazı eski MySQL sürümlerinde SHA2()
-- fonksiyonu bulunmuyor.
INSERT INTO admin_users (username, password_hash, display_name)
VALUES ('admin', '6d0147963a52b66a8cac073e3a3e90fe175b05e454e33eb3fcfcaca11b6f2ae6', 'Yönetici')
ON DUPLICATE KEY UPDATE username = username;

-- ------------------------------------------------------------
-- 2) Referanslar (Elektrik / Enerji / Asansör / Yazılım ortak tablo)
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS site_references (
    id              INT AUTO_INCREMENT PRIMARY KEY,
    category        ENUM('elektrik','enerji','asansor','yazilim') NOT NULL,
    name            VARCHAR(200) NOT NULL,      -- Firma / proje adı
    ref_type        VARCHAR(150) NULL,          -- Tür (Tavuk Çiftliği, Çatı Tipi, Apartman, vb.)
    location        VARCHAR(150) NULL,          -- İl / ilçe
    ref_year        INT NULL,                   -- Yıl
    power_value     DECIMAL(10,2) NULL,         -- kVa / kW değeri (varsa)
    power_unit      VARCHAR(20) NULL,           -- 'kVa', 'kW', 'MW' vb.
    enh_meters      INT NULL,                   -- Enerji Nakil Hattı uzunluğu (metre) — sadece elektrik
    direk_count     INT NULL,                   -- Direk adedi — sadece elektrik
    unit_count      INT NULL,                   -- Adet (asansör için: kaç adet asansör)
    photo_filename  VARCHAR(255) NULL,          -- /Uploads/references/ altındaki dosya adı
    is_featured     TINYINT(1) NOT NULL DEFAULT 0, -- "Öne Çıkan Projeler" bölümünde göster
    sort_order      INT NOT NULL DEFAULT 0,
    created_at      TIMESTAMP NULL DEFAULT NULL,
    updated_at      TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_category (category),
    INDEX idx_featured (category, is_featured)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ------------------------------------------------------------
-- 3) Ekip üyeleri
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS team_members (
    id              INT AUTO_INCREMENT PRIMARY KEY,
    full_name       VARCHAR(150) NOT NULL,
    role_title      VARCHAR(200) NOT NULL,      -- "Elektrik-Elektronik Mühendisi · Şirket Sahibi" gibi
    team_group      VARCHAR(100) NOT NULL,      -- "Mühendislik Ekibi" / "Koordinasyon & Ofis" / "Teknik Ekip"
    photo_filename  VARCHAR(255) NULL,          -- /Uploads/team/ altında (opsiyonel, yoksa baş harfler gösterilir)
    sort_order      INT NOT NULL DEFAULT 0,
    created_at      TIMESTAMP NULL DEFAULT NULL,
    updated_at      TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ------------------------------------------------------------
-- 4) Sayfa metinleri (başlıklar, hakkımızda, sloganlar vb.)
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS page_content (
    id              INT AUTO_INCREMENT PRIMARY KEY,
    page_key        VARCHAR(50)  NOT NULL,      -- 'index', 'elektrik', 'enerji', 'asansor', 'yazilim'
    content_key     VARCHAR(100) NOT NULL,      -- 'hero_title', 'hero_lead', 'about_text', 'tagline' vb.
    content_value   TEXT NULL,
    updated_at      TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY uq_page_content (page_key, content_key)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Başlangıç içerikleri (siteyle bugün aynı olacak şekilde) --
INSERT INTO page_content (page_key, content_key, content_value) VALUES
('index', 'hero_eyebrow', 'Çivril / Denizli — 2016''dan bu yana'),
('index', 'hero_title', 'Mühendisliği dört alanda birleştiriyoruz.'),
('index', 'hero_lead', 'Elektrik, enerji, asansör ve yazılım — işletmenizin ihtiyaç duyduğu her mühendislik çözümünü tek adresten sunuyoruz. Devam etmek istediğin alanı seç.'),
('index', 'about_text', 'Şahanlar Mühendislik olarak, 2016 yılında elektrik sektöründe faaliyetlerimize başlamış olup, geçen yıllar içerisinde enerji ve asansör sektörlerinde de hizmet vermeye başlayarak çalışma alanlarımızı genişletmiş, son olarak da yazılım alanına adım atmış bulunmaktayız.'),
('elektrik', 'hero_title', 'Tesisattan panoya, mühendislik güvencesiyle elektrik.'),
('elektrik', 'hero_lead', 'Konut, işyeri ve sanayi tesislerinde elektrik tesisatı, pano ve aydınlatma sistemlerini proje aşamasından bakıma kadar uçtan uca yürütüyoruz.'),
('enerji', 'hero_title', 'Enerjini verimli kullanmanın mühendislik yolu.'),
('enerji', 'hero_lead', 'Enerji verimliliğinden kompanzasyona, yenilenebilir enerji sistemlerinden enerji kimlik belgesine kadar işletmenizin enerji maliyetini düşürecek çözümleri planlıyoruz.'),
('asansor', 'hero_title', 'Asansörde güvenlik ve konforu bir arada sağlıyoruz.'),
('asansor', 'hero_lead', 'Yeni asansör montajından periyodik bakım ve revizyona kadar, yönetmeliklere uygun asansör hizmetleri sunuyoruz.'),
('yazilim', 'hero_title', 'İşletmenizin operasyonunu yöneten yazılımlar.'),
('yazilim', 'hero_lead', 'Perde otomasyonundan muhasebe ve POS takibine kadar, işletmelerin günlük operasyonunu kolaylaştıran masaüstü yazılımlar geliştiriyoruz.')
ON DUPLICATE KEY UPDATE content_value = VALUES(content_value);

SET FOREIGN_KEY_CHECKS = 1;
