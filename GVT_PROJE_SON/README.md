# FintechDB – Gelişmiş Veritabanı Projesi

Fintech (finansal teknoloji) sektörü temalı bir SQL Server veritabanı projesidir.
Müşteri, hesap, işlem ve kredi başvurusu yönetimini kapsar; üzerine bir makine
öğrenmesi katmanı (kredi skoru tahmini) entegre edilmiştir.


## Gereksinimler

Proje çalıştırılmadan önce aşağıdaki programlar kurulu olmalı.

SQL Server
SQL Server Management Studio
Python 3.8+
ODBC Driver 17 for SQL Server


## Adım 1 – Veritabanının Oluşturulması (SSMS)

SQL Server Management Studio yu açın ve aşağıdaki SQL dosyalarını çalıştırın:

1- `sql/01_ddl.sql`  (Veritabanı ve tabloları oluşturur)
2- `sql/02_dml.sql`  (Otomatik üretilen müşterileri, hesapları, kredi skorlarını ve test işlemlerini ekler)
3- `sql/03_queries.sql`  (JOIN, GROUP BY, alt sorgu örnekleri)
4- `sql/04_views.sql`  (3 adet VIEW tanımlar)
5- `sql/05_procedures.sql`  (2 adet Stored Procedure tanımlar)
6- `sql/06_triggers.sql`  (Fraud tespiti ve başvuru trigger'ları)
7- `sql/07_transactions.sql`  (Para transferi ve rollback senaryoları)
8- `sql/08_security.sql`  (Kullanıcı/rol ve yetki yönetimi)
9- `sql/09_datawarehouse.sql`  (Veri ambarı (Star Schema) + OLAP sorguları)


## Adım 2 – Sunucu Adının Ayarlaması

`ml_pipeline/config.py` dosyasını açın ve `SERVER` satırını kendi bilgisayarınıza göre düzenleyin:

SERVER = r"localhost"   # ← burası


## Adım 3 – Gerekli Python Kütüphanelerin yüklenmesi

`ml_pipeline/setup.bat` dosyasına **çift tıklayın.**

Bu işlem:
Gerekli Python kütüphanelerini kurar (`faker`, `pandas`, `scikit-learn`, `pyodbc`)


## Adım 4 – ML Pipeline'ı Çalıştır

`ml_pipeline/calistir.bat` dosyasına **çift tıklayın.**

Bu işlem sırasıyla:
1. config.py ayarlarını baz alarak veritabanı bağlantısını test eder
2. train_model.py ile kredi onay/red verisiyle Logistic Regression modeli eğitir
3. predict_and_save.py ile tüm başvurular için tahmin yapar ve `ML_Model_Sonuc` tablosuna yazar


## OPSİYONEL Yeni Test Verisi Üretmek

Eğer mevcut veritabanı içeriğini değiştirmek ve sıfırdan, rastgele daha fazla yeni test verileri üretmek isterseniz:

1- ml_pipeline/generate_dml.py dosyasını çalıştırın.
2- Bu işlem sql/02_dml.sql dosyasının içeriğini günceller daha fazla veri üretir.
3- Ardından güncellenen sql/02_dml.sql dosyasını SSMS üzerinde yeniden çalıştırarak yeni verileri SQL Server'a yükleyebilirsiniz.