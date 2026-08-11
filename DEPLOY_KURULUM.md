# Tek Tıkla Deploy — Kurulum (bir kere yapılır)

Bu kurulumdan sonra, siteyi güncellemek için tek yapman gereken:
**GitHub Desktop'ta "Pull origin" → `deploy.bat`'e çift tıkla.** Hepsi bu.

---

## 1) WinSCP'yi kur

https://winscp.net/eng/download.php adresinden **"Installation package"**
indir, kur. (Ücretsiz, açık kaynak, güvenli — Türkiye'de de çok yaygın
kullanılan bir FTP programı.)

## 2) FTP bağlantısını WinSCP'ye kaydet

1. WinSCP'yi aç.
2. Karşına çıkan "New Site" ekranında:
   - **File protocol:** FTP
   - **Encryption:** TLS/SSL Explicit Encryption (FileZilla'da kullandığın
     "Explicit FTP over TLS" ile aynı şey)
   - **Host name:** `ftp.sahanlarmuhendislik.com`
   - **User name / Password:** İHS FTP bilgilerin (FileZilla'da kullandığın)
3. Sol alttaki **"Save"** butonuna bas.
4. Karşına bir isim sorulacak — **`sahanlar-ftp`** yaz (aşağıdaki script bu
   ismi arıyor; farklı bir isim verirsen `deploy.bat` içinde `SITE_NAME`
   satırını da değiştir).
5. "Save password" seçeneğini işaretleyebilirsin (rahat kullanım için) —
   şifre WinSCP'nin kendi şifreli deposunda saklanır, `deploy.bat`
   dosyasının içinde asla görünmez.

## 3) deploy.bat dosyasını düzenle

`deploy.bat` dosyasını sağ tık → **"Edit"** (veya Not Defteri ile aç).
İçindeki şu iki satırı, GitHub Desktop'ın depoyu bilgisayarına kopyaladığı
gerçek klasör yoluna göre düzenle:

```
set LOCAL_SITE=C:\Users\Sahanlar\Documents\GitHub\sahanlarmuhendislik\site
set LOCAL_ADMIN=C:\Users\Sahanlar\Documents\GitHub\sahanlarmuhendislik\admin
```

Bu yolu GitHub Desktop'ta **Repository → Show in Explorer** ile bulabilirsin
— açılan pencerenin adres çubuğundaki yol, yukarıdaki `...\sahanlarmuhendislik`
kısmına karşılık gelir.

Ayrıca `WINSCP_EXE` satırındaki yolun, WinSCP'yi kurduğun gerçek klasörle
eşleştiğinden emin ol (genelde değiştirmene gerek kalmaz).

## 4) Test et

`deploy.bat` dosyasına çift tıkla. Siyah bir pencere açılıp dosyaları
yüklemeye başlamalı, sonunda "Deploy tamamlandi" yazıp Enter'a basmanı
bekleyecek. Hata çıkarsa ekran görüntüsünü at.

---

## Bundan sonraki her güncellemede

1. Ben sana yeni dosyalar verdiğimde, onları GitHub'a yükle (web arayüzünden
   veya GitHub Desktop ile commit + push).
2. GitHub Desktop'ta **"Pull origin"** butonuna bas (bilgisayarına indirsin).
3. `deploy.bat`'e çift tıkla.

Otomatik olarak `Download`, `Guncellemeler`, `ProgramSetuplar`, `Sozlesmeler`
klasörlerine dokunmuyor — onlar güvende.
