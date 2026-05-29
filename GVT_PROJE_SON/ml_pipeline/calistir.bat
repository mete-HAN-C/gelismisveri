@echo off
chcp 65001 >nul

echo ========================================================
echo FintechDB - ML Pipeline Calistiriliyor
echo ========================================================
echo.

cd /d "%~dp0"

python --version >nul 2>&1
if errorlevel 1 (
    echo HATA: Bilgisayarda Python bulunamadi!
    pause
    exit /b
)

echo [1/3] Veritabani baglantisi test ediliyor...

python db_test.py
if %errorlevel% neq 0 goto hata
echo.

echo [2/3] Yapay Zeka modeli egitiliyor...
python train_model.py
if %errorlevel% neq 0 goto hata
echo.

echo [3/3] Tahminler yapiliyor ve veritabanina yukleniyor...
python predict_and_save.py
if %errorlevel% neq 0 goto hata
echo.

echo ========================================================
echo [BASARILI] Tum adimlar kayipsiz tamamlandi!
echo ========================================================
echo.
echo Sonuclar SSMS uzerinden kontrol edilebilir.
echo.
pause
exit /b

:hata
echo.
echo ========================================================
echo HATA: Pipeline calisirken bir sorun olustu!
echo ========================================================
echo.
echo Lutfen sunlari kontrol edin:
echo   1. SQL Server servisinin acik oldugunu
echo   2. FintechDB veritabaninin kuruldugunu (01_ddl.sql)
echo   3. config.py icindeki SERVER adinin dogrulugunu
echo.
pause
exit /b