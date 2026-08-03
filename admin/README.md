# Şahanlar Mühendislik — Yönetim Paneli

ASP.NET Web Forms (.NET Framework 4.8) + MySQL ile yazılmış, referansları
(Elektrik / Enerji / Asansör / Yazılım), ekip listesini ve sayfa metinlerini
yönetebileceğiniz basit bir admin panel.

⚠️ **Önemli dürüstlük notu:** Bu kod gerçek bir IIS + MySQL sunucusuna karşı
test edilmedi (bu ortamda Windows/IIS/MySQL çalıştıramıyorum). Söz dizimi ve
mantık dikkatle yazıldı, ama hosting'e yüklerken küçük hatalarla
karşılaşabilirsiniz — normal, birlikte çözeriz.

---

## 1) Klasör yapısı

```
SahanlarAdmin/
  Web.config              ← MySQL bağlantı bilgisi burada
  Default.aspx            ← kök adres, giriş yapılmışsa panele yönlendirir
  Login.aspx               ← giriş ekranı
  Logout.aspx
  /App_Code/
    Db.cs                 ← MySQL yardımcı sınıfı
    ReferenceItem.cs
  /Admin/                 ← korumalı alan (girişsiz erişilemez)
    Site.Master           ← ortak panel görünümü (menü, üst bar)
    Default.aspx           ← panel ana sayfası (özet sayılar)
    References.aspx         ← referans listesi (kategoriye göre filtreli)
    ReferenceEdit.aspx       ← referans ekle/düzenle + fotoğraf yükleme
    Team.aspx / TeamEdit.aspx  ← ekip yönetimi
    Content.aspx            ← sayfa başlıkları / metinleri düzenleme
  /Api/
    References.ashx         ← herkese açık JSON uç noktası (bkz. madde 5)
  /Uploads/
    /references/            ← yüklenen referans fotoğrafları buraya kaydedilir
    /team/                   ← ekip fotoğrafları (opsiyonel)
  /sql/
    schema.sql              ← veritabanı tabloları
    seed.sql                 ← mevcut sitedeki gerçek verilerin tamamı (237 elektrik,
                                14 asansör, 29 enerji, 4 yazılım, 13 ekip üyesi)
```

---

## 2) Kurulum adımları

### a) Veritabanını oluşturun
1. İHS panelinizden yeni bir **MySQL veritabanı** ve kullanıcı oluşturun.
2. phpMyAdmin (veya panelinizin sunduğu MySQL aracı) ile veritabanına girin.
3. **Önce** `sql/schema.sql` dosyasını "İçe Aktar" (Import) ile çalıştırın.
4. **Sonra** `sql/seed.sql` dosyasını çalıştırın (mevcut 297 referans + ekip kaydını yükler).

### b) Bağlantı bilgisini girin
`Web.config` içinde şu satırı bulup kendi bilgilerinizle değiştirin:

```xml
<add name="SahanlarDb"
     connectionString="Server=localhost;Database=sahanlar_db;Uid=sahanlar_user;Pwd=BURAYA_SIFRE;charset=utf8mb4;SslMode=none;"
     providerName="MySql.Data.MySqlClient" />
```

`Server`, `Database`, `Uid`, `Pwd` değerlerini İHS panelinizdeki MySQL
bilgileriyle değiştirin. Server genelde `localhost` olur.

### c) MySQL Connector/NET'i projeye ekleyin
Bu proje Visual Studio ile açılıp derlenmeli (hazır .dll dosyası bu pakette
yok, çünkü sürüm uyumluluğu sunucunuza göre değişebilir):

1. Visual Studio'da bu klasörü bir **ASP.NET Web Application (.NET Framework)**
   projesi olarak açın (veya yeni proje oluşturup dosyaları içine kopyalayın).
2. **Tools → NuGet Package Manager → Package Manager Console** açın.
3. Şunu yazıp Enter'a basın: `Install-Package MySql.Data`
4. Projeyi derleyin (Build). `/bin` klasörü otomatik oluşacak.

### d) Hostinge yükleyin
Tüm proje klasörünü (bin klasörü dahil) FTP ile hostinginizdeki
`httpdocs` veya `wwwroot` klasörüne yükleyin. `/Uploads/` klasörünün
yazma izni (write permission) olduğundan emin olun — fotoğraf yükleme
burada başarısız olursa hosting desteğine "Uploads klasörüne IIS_IUSRS
yazma izni verir misiniz" diye yazmanız yeterli.

### e) Giriş yapın
`https://siteniz.com/Login.aspx` adresine gidin.

- **Kullanıcı adı:** `admin`
- **Şifre:** `Sahanlar2026!`

**Giriş yaptıktan hemen sonra bu şifreyi değiştirin.** Hostinginizin MySQL
sürümü eski olabileceği için (SHA2 fonksiyonu bulunmayabilir), şifre
değiştirmek için paket içindeki `sifre-hash-araci.html` dosyasını
bilgisayarınızda çift tıklayıp açın, yeni şifrenizi yazın, çıkan kodu
kopyalayıp phpMyAdmin'de şunu çalıştırın:

```sql
UPDATE admin_users
SET password_hash = 'ARAÇTAN_ÇIKAN_KOD'
WHERE username = 'admin';
```

---

## 3) Neyi yönetebilirsiniz

- **Referanslar** (4 kategori): ekle, düzenle, sil, fotoğraf yükle,
  "Öne Çıkan Projeler" bölümünde gösterilsin mi işaretle.
- **Ekip**: ad, unvan, grup (Mühendislik / Ofis / Teknik) ekle-düzenle-sil.
- **Sayfa Metinleri**: her sayfanın başlık ve açıklama yazılarını değiştir.

---

## 4) Önceden yüklenmiş veriler (seed.sql)

Excel'inizden ve kataloglardan derlediğimiz **gerçek** veriler zaten
yüklü geliyor:
- 237 elektrik referansı (216 trafo + 21 elektrik altyapı)
- 14 asansör işi (30 asansör)
- 29 GES projesi (13 fotoğraflı + 16 Excel kaydı)
- 4 yazılım ürünü
- 13 ekip üyesi

Referans fotoğrafları `/Uploads/references/` klasöründe hazır halde
paketin içinde geliyor (ges-*.jpg, enh-*.jpg dosyaları).

---

## 5) Bu panel siteyle nasıl konuşacak? (önemli, okuyun)

Şu an elinizdeki **görsel site** (index.html, elektrik.html vb.) hâlâ
**statik dosyalar** — yani bu admin panelden bir referans eklediğinizde,
veritabanı güncellenir ama sitedeki HTML dosyaları OTOMATİK değişmez.

`/Api/References.ashx?category=elektrik` adresi veritabanındaki güncel
veriyi JSON olarak dışarı veriyor — bunu hazırladım ki köprü hazır olsun.

**Bir sonraki adım olarak** iki seçeneğimiz var:
1. **Statik sayfalara küçük bir JavaScript ekleyip**, sayfa açıldığında
   bu API'den veri çekip tabloyu/kartları otomatik oluşturmasını
   sağlamak (siteyi statik tutar, hızlı kalır).
2. **Sayfaları da ASP.NET'e çevirip** sunucu tarafında veritabanından
   okuyarak oluşturmak (daha "klasik" ama daha çok iş).

İkisinden birini seçersen bir sonraki adımda onu da tamamlarım — şu an
panel tek başına çalışır durumda, sadece siteye otomatik yansımıyor.
