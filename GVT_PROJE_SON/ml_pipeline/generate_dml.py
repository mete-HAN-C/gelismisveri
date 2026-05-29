from faker import Faker
import random
from datetime import datetime, timedelta
import os
from config import CONN_STR

BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
OUTPUT_PATH = os.path.join(BASE_DIR, "sql", "02_dml.sql")
SEED = 42

N_MUSTERI = 1500
HESAP_PER_MUSTERI = (1, 3)
ISLEM_PER_HESAP = (5, 10)
FRAUD_TUTAR_ORANI = 0.05
N_KREDI_BASVURU = 500

fake = Faker('tr_TR')
Faker.seed(SEED)
random.seed(SEED)

proje_tarihi = datetime(2026, 5, 15, 12, 0, 0)

print(f"[1/4] {N_MUSTERI} musteri uretiliyor...")
musteriler = []
kullanilan_tckn = set()

for i in range(N_MUSTERI):
    while True:
        tckn = str(random.randint(1, 9)) + ''.join(str(random.randint(0, 9)) for _ in range(10))
        if tckn not in kullanilan_tckn:
            kullanilan_tckn.add(tckn)
            break
    ad_temiz = fake.first_name()
    soyad_temiz = fake.last_name()
    email = f"{ad_temiz.lower()}{i}@mail.com"

    musteriler.append({
        'MusteriID': i + 1,
        'Ad': ad_temiz,
        'Soyad': soyad_temiz,
        'TCKN': tckn,
        'DogumTarihi': fake.date_of_birth(minimum_age=20, maximum_age=65).isoformat(),
        'Email': email[:100],
        'Telefon': f"05{random.randint(300000000, 599999999)}",
    })

print(f"[2/4] Hesaplar uretiliyor...")
hesaplar = []
hesap_id = 1
for m in musteriler:
    n = random.randint(*HESAP_PER_MUSTERI)
    for _ in range(n):
        hesap_no = f"TR{1000000000 + hesap_id:010d}"
        hesaplar.append({
            'HesapID': hesap_id,
            'MusteriID': m['MusteriID'],
            'HesapNo': hesap_no,
            'Bakiye': round(random.uniform(1000, 50000), 2),
            'ParaBirimi': random.choices(['TRY', 'USD', 'EUR'], weights=[85, 10, 5])[0],
            'HesapTipi': random.choices(['VADESIZ', 'VADELI', 'KREDI'], weights=[70, 20, 10])[0],
            'Durum': 'AKTIF',
        })
        hesap_id += 1

print(f"[3/4] Islemler uretiliyor...")
islemler = []
islem_id_sayac = 1
for h in hesaplar:
    n = random.randint(*ISLEM_PER_HESAP)
    for _ in range(n):
        if random.random() < FRAUD_TUTAR_ORANI:
            tutar = round(random.uniform(55000, 120000), 2)
            aciklama = "Yuksek Tutar Transferi"
        else:
            tutar = round(random.uniform(50, 3500), 2)
            aciklama = random.choice(["Market Alisverisi", "Fatura Odemesi", "Nakit Cekim", "Giyim Magazasi", "Restoran"])

        islem_tarihi = proje_tarihi - timedelta(days=random.randint(0, 30), hours=random.randint(0, 12))
        islemler.append({
            'IslemID': islem_id_sayac,
            'HesapID': h['HesapID'],
            'Tutar': tutar,
            'IslemTipi': random.choice(['HAVALE', 'EFT', 'ATM', 'POS']),
            'IslemTarihi': islem_tarihi.strftime('%Y-%m-%d %H:%M:%S'),
            'Aciklama': aciklama,
        })
        islem_id_sayac += 1

print(f"[4/4] Kredi basvurulari uretiliyor...")
basvurular = []
for i in range(N_KREDI_BASVURU):
    talep = round(random.uniform(5000, 80000), 2)
    gelir = round(random.uniform(7000, 35000), 2)
    vade = random.choice([12, 24, 36])
    
    # Basit Kredi Kurali: Kisi aylik gelirinin %15'ini taksite ayirabiliyor mu? (Tahmini %50 faiz ile)
    tahmini_aylik_taksit = (talep * 1.5) / vade
    
    if (gelir * 0.15) > tahmini_aylik_taksit:
        # Mantiken karsiliyor -> %80 Onay, %10 Red (Gürültü/İstisna), %10 Beklemede
        durum = random.choices(['ONAYLANDI', 'REDDEDILDI', 'BEKLEMEDE'], weights=[80, 10, 10])[0]
    else:
        # Mantiken karsilamiyor -> %80 Red, %10 Onay (Gürültü/İstisna), %10 Beklemede
        durum = random.choices(['REDDEDILDI', 'ONAYLANDI', 'BEKLEMEDE'], weights=[80, 10, 10])[0]
        
    basvuru_tarihi = proje_tarihi - timedelta(days=random.randint(1, 15))
    degerlendirme = None if durum == 'BEKLEMEDE' else basvuru_tarihi + timedelta(days=random.randint(1, 5))

    basvurular.append({
        'BasvuruID': i + 1,
        'MusteriID': random.choice(musteriler)['MusteriID'],
        'BasvuruTarihi': basvuru_tarihi.strftime('%Y-%m-%d %H:%M:%S'),
        'TalepEdilenTutar': talep,
        'Vade': vade,
        'AylikGelir': gelir,
        'Durum': durum,
        'DegerlendirmeTarihi': degerlendirme.strftime('%Y-%m-%d %H:%M:%S') if degerlendirme else None,
    })

def sql_value(v):
    if v is None: return 'NULL'
    if isinstance(v, (int, float)): return str(v)
    return f"'{str(v)}'"

def write_inserts(f, table, columns, rows):
    if not rows: return
    col_list = ', '.join(columns)
    chunk_size = 900
    for i in range(0, len(rows), chunk_size):
        chunk = rows[i:i+chunk_size]
        f.write(f"INSERT INTO dbo.{table} ({col_list}) VALUES\n")
        lines = []
        for row in chunk:
            vals = ', '.join(sql_value(row.get(c)) for c in columns)
            lines.append(f"    ({vals})")
        f.write(',\n'.join(lines))
        f.write(';\nGO\n\n')

os.makedirs(os.path.dirname(OUTPUT_PATH) or '.', exist_ok=True)

with open(OUTPUT_PATH, 'w', encoding='utf-8-sig') as f:
    f.write("-- 02_dml.sql - Otomatik Uretilen Ornek Veriler\nUSE FintechDB;\nGO\n\n")
    f.write("DELETE FROM dbo.ML_Model_Sonuc; DELETE FROM dbo.Fraud_Log; DELETE FROM dbo.Kredi_Skoru;\n")
    f.write("DELETE FROM dbo.Kredi_Basvuru; DELETE FROM dbo.Islem; DELETE FROM dbo.Hesap; DELETE FROM dbo.Musteri;\nGO\n\n")

    for t in ['Musteri', 'Hesap', 'Islem', 'Kredi_Basvuru', 'Kredi_Skoru', 'Fraud_Log', 'ML_Model_Sonuc']:
        f.write(f"DBCC CHECKIDENT('dbo.{t}', RESEED, 0);\n")
    f.write("GO\n\n")

    f.write("SET IDENTITY_INSERT dbo.Musteri ON;\n")
    write_inserts(f, 'Musteri', ['MusteriID', 'Ad', 'Soyad', 'TCKN', 'DogumTarihi', 'Email', 'Telefon'], musteriler)
    f.write("SET IDENTITY_INSERT dbo.Musteri OFF;\nGO\n\n")

    f.write("SET IDENTITY_INSERT dbo.Hesap ON;\n")
    write_inserts(f, 'Hesap', ['HesapID', 'MusteriID', 'HesapNo', 'Bakiye', 'ParaBirimi', 'HesapTipi', 'Durum'], hesaplar)
    f.write("SET IDENTITY_INSERT dbo.Hesap OFF;\nGO\n\n")

    f.write("SET IDENTITY_INSERT dbo.Islem ON;\n")
    write_inserts(f, 'Islem', ['IslemID', 'HesapID', 'Tutar', 'IslemTipi', 'IslemTarihi', 'Aciklama'], islemler)
    f.write("SET IDENTITY_INSERT dbo.Islem OFF;\nGO\n\n")

    f.write("SET IDENTITY_INSERT dbo.Kredi_Basvuru ON;\n")
    write_inserts(f, 'Kredi_Basvuru', ['BasvuruID', 'MusteriID', 'BasvuruTarihi', 'TalepEdilenTutar', 'Vade', 'AylikGelir', 'Durum', 'DegerlendirmeTarihi'], basvurular)
    f.write("SET IDENTITY_INSERT dbo.Kredi_Basvuru OFF;\nGO\n\n")

print(f"\n[BAŞARILI] {OUTPUT_PATH}")