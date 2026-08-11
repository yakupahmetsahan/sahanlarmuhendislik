# Şahanlar Mühendislik — Yönetim Paneli

ASP.NET Web Forms (.NET Framework 4.8) + **MSSQL** ile yazılmış, referansları
(Elektrik / Enerji / Asansör / Yazılım / Hayvancılık / Tarım), ekip listesini
ve sayfa metinlerini yönetebileceğiniz basit bir admin panel.

MSSQL bağlantısı `System.Data.SqlClient` ile yapılır — bu, .NET Framework'ün
**kendi parçasıdır**, ekstra DLL yüklemeye veya hostingde "Full Trust" izni
istemeye gerek yoktur. (Daha önce MySQL ile denendi, paylaşımlı hostingde
Full Trust kilidine takıldığı için MSSQL'e geçildi — Perde Otomasyon
programınızın da kullandığı, hosting üzerinde zaten kanıtlanmış yöntem.)

⚠️ **Dürüstlük notu:** Bu kod gerçek bir IIS + MSSQL sunucusuna karşı test
edilmedi (bu ortamda Windows/IIS/MSSQL çalıştıramıyorum). Söz dizimi dikkatle
yazıldı, ama küçük bir hatayla karşılaşırsan normal, birlikte çözeriz.

---

## 1) Klasör yapısı

```
site/
  App_Code/               ← ÖNEMLİ: site KÖKÜNDE olmalı (admin altında değil)
    Db.cs                 ← MSSQL yardımcı sınıfı
    ReferenceItem.cs
    AdminBasePage.cs
  web.config               ← site kökü — burada mevcut ASP.NET ayarlarınız da var
  (index.html, elektrik.html, ... — statik site dosyaları)

admin/
  Web.config              ← MSSQL bağlantı bilgisi burada
  Login.aspx / Login.aspx.cs
  Logout.aspx
  /Admin/                 ← korumalı alan (Session ile kontrol edilir)
    Site.Master
    Default.aspx           ← panel ana sayfası
    References.aspx         ← referans listesi
    ReferenceEdit.aspx       ← referans ekle/düzenle + fotoğraf
    Images.aspx              ← kategori kutucuk/banner görselleri
    Team.aspx / TeamEdit.aspx
    Content.aspx
  /Api/
    References.ashx         ← herkese açık JSON uç noktası
  /Uploads/
    /references/             ← referans fotoğrafları
  /sql/
    schema.sql               ← veritabanı tabloları (MSSQL/T-SQL)
    seed.sql                  ← mevcut sitedeki gerçek verilerin tamamı
```

---

## 2) Kurulum adımları

### a) Veritabanını oluşturun
1. İHS panelinizden yeni bir **MSSQL veritabanı** ve kullanıcı oluşturun.
2. SQL Server Management Studio (SSMS) ile bağlanın — İHS panelinizde
   sunucu adresi/instance adı yazar (örn. `sunucuadi.ihs.com.tr` gibi).
   SSMS yoksa İHS panelinin sunduğu web tabanlı MSSQL yönetim aracını
   kullanabilirsiniz.
3. **Önce** `sql/schema.sql` dosyasının tamamını çalıştırın (New Query).
4. **Sonra** `sql/seed.sql` dosyasını çalıştırın (237 elektrik, 14 asansör,
   29 enerji, 4 yazılım, 13 ekip üyesi + Hayvancılık/Tarım kayıtlarını yükler).

### b) Bağlantı bilgisini girin
`admin/Web.config` içinde şu satırı bulup kendi bilgilerinizle değiştirin:

```xml
<add name="SahanlarDb"
     connectionString="Server=localhost;Database=sahanlar_db;User Id=sahanlar_user;Password=BURAYA_SIFRE;"
     providerName="System.Data.SqlClient" />
```

`Server`, `Database`, `User Id`, `Password` değerlerini İHS panelinizdeki
MSSQL bilgilerinizle değiştirin.

### c) Hostinge yükleyin
Hem `site/` hem `admin/` klasörlerini FTP ile yükleyin (site → `http/`,
admin → `http/admin/`). **`site/App_Code/` klasörünün mutlaka yüklendiğinden
emin olun** — bu klasör olmadan admin panel çalışmaz.

`/Uploads/` ve `site/assets/img/tiles/` klasörlerinin yazma izni olduğundan
emin olun — fotoğraf yükleme burada başarısız olursa hosting desteğine
"bu klasörlere yazma izni verir misiniz" diye yazmanız yeterli.

### d) Giriş yapın
`https://siteniz.com/admin/Login.aspx` adresine gidin.

- **Kullanıcı adı:** `admin`
- **Şifre:** `Sahanlar2026!`

**Giriş yaptıktan hemen sonra bu şifreyi değiştirin.** Paket içindeki
`sifre-hash-araci.html` dosyasını bilgisayarınızda çift tıklayıp açın,
yeni şifrenizi yazın, çıkan kodu kopyalayıp MSSQL'de şunu çalıştırın:

```sql
UPDATE admin_users
SET password_hash = 'ARAÇTAN_ÇIKAN_KOD'
WHERE username = 'admin';
```

---

## 3) Neyi yönetebilirsiniz

- **Referanslar** (6 kategori): ekle, düzenle, sil, fotoğraf yükle.
- **Kategori Görselleri**: her kategorinin ana sayfa kutucuğu ve banner
  fotoğrafını değiştir.
- **Ekip**: ad, unvan, grup ekle-düzenle-sil.
- **Sayfa Metinleri**: her sayfanın başlık ve açıklama yazılarını değiştir.

---

## 4) Bu panel siteyle nasıl konuşacak?

Şu an elinizdeki **statik site** hâlâ statik dosyalar — admin panelden
değişiklik yaptığınızda veritabanı güncellenir ama HTML dosyaları otomatik
değişmez (Kategori Görselleri sayfası istisna — o direkt dosya üzerine
yazıyor).

`/Api/References.ashx?category=elektrik` adresi veritabanındaki güncel
referans verisini JSON olarak dışarı veriyor — sonraki adımda statik
sayfalara bunu okuyan bir JavaScript ekleyebiliriz, ya da sayfaları
ASP.NET'e çevirip sunucu tarafında okutabiliriz. Şu an panel tek başına
çalışır durumda, ne zaman istersen bu köprüyü tamamlarız.
