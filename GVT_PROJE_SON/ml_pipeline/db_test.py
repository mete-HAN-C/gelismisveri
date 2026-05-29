import pyodbc
from config import CONN_STR, SERVER, DATABASE

print(f"Sunucu  : {SERVER}")
print(f"Veritabani: {DATABASE}")

try:
    conn = pyodbc.connect(CONN_STR)
    cursor = conn.cursor()
    cursor.execute("SELECT @@VERSION, DB_NAME()")
    row = cursor.fetchone()
    print(f"[OK] Baglanti basarili - {row[1]}")
    conn.close()
except Exception as e:
    print(f"[HATA] {e}")
    print("config.py dosyasindaki SERVER degerini kontrol edin.")
