@echo off
chcp 65001 >nul
echo ========================================================
echo FintechDB - Python Kutuphanelerinin Kurulumu
echo ========================================================
echo.

REM Python kurulu mu kontrol et
python --version >nul 2>&1
if errorlevel 1 (
    echo HATA: Python kurulu degil veya PATH'e ekli degil.
    echo Once https://python.org adresinden Python 3.8+ kurun.
    pause
    exit /b 1
)

echo Python bulundu:
python --version
echo.

echo Kurulacak kutuphaneler:
echo   - faker          (Ornek veri uretimi)
echo   - pandas         (Veri analizi)
echo   - numpy          (Sayisal hesaplama)
echo   - scikit-learn   (ML modelleri)
echo   - pyodbc         (SQL Server baglantisi)
echo.

python -m pip install --upgrade pip
python -m pip install faker pandas numpy scikit-learn pyodbc

if errorlevel 1 (
    echo.
    echo HATA: Kurulum sirasinda sorun olustu.
    echo Internet baglantinizi ve pip durumunu kontrol edin.
    pause
    exit /b 1
)

echo.
echo ========================================================
echo Kurulum basariyla tamamlandi!
echo ========================================================
echo.
echo.
pause
