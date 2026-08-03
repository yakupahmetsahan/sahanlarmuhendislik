# Şahanlar Mühendislik — GitHub'a Yükleme ve Otomatik Deploy Rehberi

Bu paket iki şeyi içerir:
- `/site/`  → müşteri tarafında görünen web sitesi (statik HTML)
- `/admin/` → referans/ekip/metin yönetim paneli (ASP.NET + MySQL)
- `/.github/workflows/deploy.yml` → GitHub'a her yükleme yaptığında
  bu iki klasörü otomatik olarak İHS hostingine FTP ile gönderen robot

Aşağıdaki adımları sırayla uygula. Hiçbir yerde komut satırı
kullanmana gerek yok, hepsi tarayıcıdan.

---

## 1) Bu dosyaları GitHub'a yükle

1. Az önce oluşturduğun `sahanlarmuhendislik` reposuna git.
2. Sayfada gördüğün **"mevcut bir dosyayı yükleyerek"** (uploading an
   existing file) linkine tıkla.
3. Bu zip'i açtığında çıkan **tüm klasörleri** (`site`, `admin`, `.github`)
   tarayıcıya sürükle bırak.
   - Not: `.github` klasörü gizli göründüğü için bilgisayarında
     görünmeyebilir. Görünmüyorsa: Windows'ta dosya gezgininde
     "Gizli öğeleri göster" seçeneğini aç (Görünüm sekmesi).
4. Altta "Commit changes" (Değişiklikleri Kaydet) butonuna bas.

---

## 2) FTP bilgilerini GitHub'a güvenli şekilde ekle

Bu bilgiler bana **görünmez**, sadece GitHub'ın otomasyonu kullanır.

1. Repo sayfasında üstteki **Settings** sekmesine tıkla.
2. Sol menüden **Secrets and variables → Actions**.
3. **New repository secret** butonuna 3 kere basıp şunları tek tek ekle:

   | Name (isim)     | Secret (değer)                          |
   |-----------------|------------------------------------------|
   | `FTP_SERVER`    | İHS panelindeki FTP sunucu adresin        |
   | `FTP_USERNAME`  | İHS FTP kullanıcı adın                    |
   | `FTP_PASSWORD`  | İHS FTP şifren                            |

   Bu bilgileri İHS'in kontrol panelinde **"FTP Hesapları"** ya da
   **"Dosya Yöneticisi / FTP Bilgileri"** bölümünde bulursun.

---

## 3) Hedef klasör adını kontrol et

`.github/workflows/deploy.yml` dosyasının içinde iki yerde
`server-dir: ./httpdocs/` yazıyor. İHS'te ana klasörün adı
`httpdocs` değilse (bazı hostinglerde `public_html` veya `wwwroot`
olabilir), bu satırları GitHub üzerinden dosyayı açıp düzenleyerek
(kalem ikonuna tıkla) doğru isimle değiştir.

Klasör adını İHS'in **Dosya Yöneticisi**nde görebilirsin — siteye
girdiğinde hangi klasörün içinde `index.html` görüyorsan o klasör adı.

---

## 4) Veritabanını bir kere elle kur (bu adım otomatik değil)

GitHub Actions sadece dosyaları yükler, veritabanı tablolarını
oluşturmaz. Bunun için:

1. İHS panelinden bir MySQL veritabanı oluştur.
2. phpMyAdmin'e gir.
3. `admin/sql/schema.sql` dosyasını İçe Aktar (Import).
4. Ardından `admin/sql/seed.sql` dosyasını İçe Aktar.
5. `admin/Web.config` içindeki bağlantı bilgisini (Server/Database/Uid/Pwd)
   kendi MySQL bilgilerinle güncelle — bunu da GitHub üzerinden dosyayı
   açıp kalem ikonuyla düzenleyebilirsin.

---

## 5) Test et

1. GitHub'da **Actions** sekmesine git — deploy işleminin çalıştığını
   (yeşil tik) görmelisin. Kırmızı çarpı görürsen, üstüne tıklayıp
   hata mesajını bana gönder, birlikte çözeriz.
2. `https://siteniz.com` → statik site açılmalı.
3. `https://siteniz.com/admin/Login.aspx` → admin panel giriş ekranı
   açılmalı (kullanıcı: `admin`, şifre: `Sahanlar2026!` — hemen değiştir).

---

Herhangi bir adımda takılırsan, o ekranın görüntüsünü at, kaldığın
yerden devam ederiz.
