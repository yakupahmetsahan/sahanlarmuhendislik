@echo off
REM ============================================================
REM  Şahanlar Mühendislik — Tek Tıkla Deploy
REM  Bu dosyaya çift tıkladığında, bilgisayarındaki güncel site
REM  ve admin panel dosyalarını FTP ile hostinge yükler.
REM
REM  ÖNCE KURULUM (bir kere yapılır, bkz. DEPLOY_KURULUM.md):
REM   1) WinSCP'yi kur: https://winscp.net/eng/download.php
REM   2) WinSCP'yi aç, "New Site" ile İHS FTP bilgilerini gir,
REM      "Save" derken bir isim ver: ornek "sahanlar-ftp"
REM   3) Aşağıdaki SITE_NAME değerini o isimle değiştir
REM   4) Aşağıdaki LOCAL_SITE ve LOCAL_ADMIN yollarını, GitHub
REM      Desktop'ın deposunu kopyaladığın klasöre göre düzenle
REM ============================================================

set SITE_NAME=sahanlar-ftp
set LOCAL_SITE=C:\Users\Sahanlar\Documents\GitHub\sahanlarmuhendislik\site
set LOCAL_ADMIN=C:\Users\Sahanlar\Documents\GitHub\sahanlarmuhendislik\admin
set WINSCP_EXE="C:\Program Files (x86)\WinSCP\WinSCP.com"

echo.
echo === Sahanlar Muhendislik - Deploy basliyor ===
echo.

%WINSCP_EXE% /command ^
  "open %SITE_NAME%" ^
  "synchronize remote -filemask=""|Download/;Guncellemeler/;ProgramSetuplar/;Sozlesmeler/"" ""%LOCAL_SITE%"" /http" ^
  "synchronize remote ""%LOCAL_ADMIN%"" /http/admin" ^
  "exit"

echo.
echo === Deploy tamamlandi ===
pause
