USE FintechDB;
GO

DELETE FROM dbo.ML_Model_Sonuc; DELETE FROM dbo.Fraud_Log; DELETE FROM dbo.Kredi_Skoru;
DELETE FROM dbo.Kredi_Basvuru; DELETE FROM dbo.Islem; DELETE FROM dbo.Hesap; DELETE FROM dbo.Musteri;
GO

SET IDENTITY_INSERT dbo.Musteri ON;
INSERT INTO dbo.Musteri (MusteriID, Ad, Soyad, TCKN, DogumTarihi, Email, Telefon) VALUES
(1, N'Muhammet', N'Yaman', '20433218196', '2000-07-04', 'muhammet@mail.com', '05317063198'),
(2, N'Ayşe', N'Şafak', '11338908386', '1985-07-20', 'ayse@mail.com', '05418348156'),
(3, N'Murat', N'Tevetoğlu', '89402654235', '1992-03-12', 'murat@mail.com', '05354873725'),
(4, N'Gül', N'Seven', '26155940781', '1965-05-23', 'gul@mail.com', '05503224098'),
(5, N'Mete', N'Sezer', '28495931034', '1999-02-24', 'mete@mail.com', '05342837990'),
(6, N'Emir', N'Çorlu', '41647525534', '2001-03-30', 'emir@mail.com', '05338333930'),
(7, N'Ahmet', N'Sezgin', '38327648350', '1953-05-06', 'ahmet@mail.com', '05422969247'),
(8, N'Can', N'Durmuş', '15641395376', '1970-05-04', 'can@mail.com', '05546344213'),
(9, N'Sidar', N'Bilgin', '34238849696', '2002-12-30', 'sidar@mail.com', '05494345362'),
(10, N'Zeynep', N'Ertaş', '42871012269', '1993-08-25', 'zeynep@mail.com', '05334106178'),
(11, N'Süsen', N'Aslan', '76978480184', '1998-02-23', 'susen@mail.com', '05482630317'),
(12, N'Buse', N'Gül', '24627048281', '1967-01-18', 'buse@mail.com', '05460226325'),
(13, N'Deniz', N'Yılmaz', '61834738299', '1988-04-16', 'deniz@mail.com', '05562318192'),
(14, N'Mükremin', N'Alemdar', '11543039117', '1975-07-28', 'mukremin@mail.com', '05337158185'),
(15, N'Fatma', N'Akgündüz', '92278248963', '1999-03-30', 'fatma@mail.com', '05589532383');
GO
SET IDENTITY_INSERT dbo.Musteri OFF;

SET IDENTITY_INSERT dbo.Hesap ON;
INSERT INTO dbo.Hesap (HesapID, MusteriID, HesapNo, Bakiye, ParaBirimi, HesapTipi, Durum) VALUES
(1, 1, 'TR00100001', 25000.00, 'TRY', 'VADESIZ', 'AKTIF'),
(2, 1, 'TR00100002', 35000.00, 'TRY', 'VADELI', 'AKTIF'),
(3, 2, 'TR00100003', 44000.00, 'TRY', 'VADESIZ', 'AKTIF'),
(4, 3, 'TR00100004', 65000.00, 'TRY', 'VADESIZ', 'AKTIF'),
(5, 4, 'TR00100005', 24000.00, 'TRY', 'VADESIZ', 'AKTIF'),
(6, 5, 'TR00100006', 4500.00,  'EUR', 'VADESIZ', 'AKTIF'),
(7, 6, 'TR00100007', 72000.00, 'TRY', 'VADESIZ', 'AKTIF'),
(8, 7, 'TR00100008', 68000.00, 'TRY', 'KREDI', 'AKTIF'),
(9, 8, 'TR00100009', 12000.00, 'USD', 'VADESIZ', 'AKTIF'),
(10, 9, 'TR00100010', 58000.00, 'TRY', 'VADESIZ', 'AKTIF'),
(11, 10, 'TR00100011', 11000.00, 'TRY', 'VADESIZ', 'AKTIF'),
(12, 11, 'TR00100012', 21000.00, 'TRY', 'VADELI', 'AKTIF'),
(13, 12, 'TR00100013', 28000.00, 'TRY', 'VADELI', 'AKTIF'),
(14, 13, 'TR00100014', 18000.00, 'TRY', 'VADESIZ', 'AKTIF'),
(15, 15, 'TR00100015', 41000.00, 'TRY', 'KREDI', 'AKTIF');
GO
SET IDENTITY_INSERT dbo.Hesap OFF;

SET IDENTITY_INSERT dbo.Islem ON;
INSERT INTO dbo.Islem (IslemID, HesapID, Tutar, IslemTipi, IslemTarihi, Aciklama) VALUES
(1, 1, 1500.00, 'POS', '2026-05-10 12:00:00', N'Market Harcaması'),
(2, 1, 85000.00, 'ATM', '2026-05-11 14:30:00', N'Hesaba Para Yatırma - Şüpheli Yüksek Tutar'),
(3, 3, 200.00, 'POS', '2026-05-12 09:15:00', N'Kahve Alışverişi'),
(4, 4, 3500.00, 'HAVALE', '2026-05-12 18:20:00', N'Kira Ödemesi'),
(5, 5, 450.00, 'EFT', '2026-05-13 11:10:00', N'İnternet Faturası'),
(6, 6, 1200.00, 'POS', '2026-05-13 15:40:00', N'Giyim Alışverişi'),
(7, 7, 75000.00, 'EFT', '2026-05-14 10:05:00', N'Araba Alımı - Şüpheli Yüksek Tutar'),
(8, 8, 2500.00, 'ATM', '2026-05-14 16:00:00', N'Hesaba Nakit Yatırma'),
(9, 10, 4000.00, 'HAVALE', '2026-05-15 08:22:00', N'Borç Ödemesi'),
(10, 11, 150.00, 'POS', '2026-05-15 19:45:00', N'Restoran Ödemesi'),
(11, 12, 3000.00, 'ATM', '2026-05-16 13:12:00', N'Hesaba Nakit Yatırma'),
(12, 13, 950.00, 'POS', '2026-05-16 17:55:00', N'Kitap Siparişi'),
(13, 14, 120000.00, 'HAVALE', '2026-05-17 11:00:00', N'Ev Peşinatı - Şüpheli Yüksek Tutar'),
(14, 15, 600.00, 'POS', '2026-05-17 14:20:00', N'Eczane Harcaması'),
(15, 1, 500.00, 'POS', '2026-05-18 09:00:00', N'Nakit Çekim');
GO
SET IDENTITY_INSERT dbo.Islem OFF;

SET IDENTITY_INSERT dbo.Kredi_Basvuru ON;
INSERT INTO dbo.Kredi_Basvuru (BasvuruID, MusteriID, BasvuruTarihi, TalepEdilenTutar, Vade, AylikGelir, Durum, DegerlendirmeTarihi) VALUES
(1, 1, '2026-05-01', 50000.00, 12, 12000.00, 'ONAYLANDI', '2026-05-03'),
(2, 2, '2026-05-02', 150000.00, 24, 25000.00, 'BEKLEMEDE', NULL),
(3, 3, '2026-05-03', 20000.00, 6, 8500.00, 'REDDEDILDI', '2026-05-04'),
(4, 4, '2026-05-04', 300000.00, 48, 18000.00, 'REDDEDILDI', '2026-05-06'),
(5, 5, '2026-05-05', 40000.00, 12, 14500.00, 'ONAYLANDI', '2026-05-06'),
(6, 6, '2026-05-06', 80000.00, 24, 35000.00, 'BEKLEMEDE', NULL),
(7, 7, '2026-05-07', 15000.00, 12, 4500.00, 'REDDEDILDI', '2026-05-08'),
(8, 8, '2026-05-08', 95000.00, 36, 22000.00, 'ONAYLANDI', '2026-05-10'),
(9, 9, '2026-05-09', 10000.00, 6, 7500.00, 'BEKLEMEDE', NULL),
(10, 10, '2026-05-10', 85000.00, 24, 19000.00, 'ONAYLANDI', '2026-05-11'),
(11, 11, '2026-05-11', 250000.00, 48, 45000.00, 'ONAYLANDI', '2026-05-12'),
(12, 12, '2026-05-12', 35000.00, 12, 11000.00, 'BEKLEMEDE', NULL),
(13, 13, '2026-05-13', 60000.00, 24, 16500.00, 'REDDEDILDI', '2026-05-14'),
(14, 1, '2026-05-14', 120000.00, 36, 28000.00, 'BEKLEMEDE', NULL),
(15, 2, '2026-05-15', 25000.00, 12, 13000.00, 'ONAYLANDI', '2026-05-16');
GO
SET IDENTITY_INSERT dbo.Kredi_Basvuru OFF;

SET IDENTITY_INSERT dbo.Kredi_Skoru ON;
INSERT INTO dbo.Kredi_Skoru (SkorID, MusteriID, Skor, HesaplamaTarihi, HesaplamaYontemi) VALUES
(1, 1, 0.8500, '2026-05-01', 'SADE_LINEER'),
(2, 2, 0.9200, '2026-05-02', 'SADE_LINEER'),
(3, 3, 0.4500, '2026-05-03', 'SADE_LINEER'),
(4, 4, 0.3000, '2026-05-04', 'SADE_LINEER'),
(5, 5, 0.7800, '2026-05-05', 'SADE_LINEER'),
(6, 6, 0.8800, '2026-05-06', 'SADE_LINEER'),
(7, 7, 0.4000, '2026-05-07', 'SADE_LINEER'),
(8, 8, 0.8100, '2026-05-08', 'SADE_LINEER'),
(9, 9, 0.6500, '2026-05-09', 'SADE_LINEER'),
(10, 10, 0.8900, '2026-05-10', 'SADE_LINEER');
GO
SET IDENTITY_INSERT dbo.Kredi_Skoru OFF;

SET IDENTITY_INSERT dbo.Fraud_Log ON;
INSERT INTO dbo.Fraud_Log (LogID, IslemID, RiskSkoru, Aciklama, LogTarihi) VALUES
(1, 2, 0.9500, N'Şüpheli Yüksek Tutar - ATM', '2026-05-11 14:35:00'),
(2, 7, 0.8800, N'Şüpheli Yüksek Tutar - EFT', '2026-05-14 10:10:00'),
(3, 13, 0.9200, N'Ev Peşinatı - Anormal Hacim', '2026-05-17 11:05:00'),
(4, 1, 0.1500, N'Olağan Market Harcaması', '2026-05-10 12:05:00'),
(5, 3, 0.1000, N'Olağan Kahve Harcaması', '2026-05-12 09:20:00'),
(6, 4, 0.2000, N'Rutin Kira Ödemesi', '2026-05-12 18:25:00'),
(7, 5, 0.0500, N'Fatura Ödemesi', '2026-05-13 11:15:00'),
(8, 6, 0.2500, N'Giyim - Normal Limit', '2026-05-13 15:45:00'),
(9, 8, 0.3000, N'Nakit Yatırma - Günlük Limit İçi', '2026-05-14 16:05:00'),
(10, 9, 0.1800, N'Borç Ödemesi', '2026-05-15 08:30:00');
GO
SET IDENTITY_INSERT dbo.Fraud_Log OFF;

SET IDENTITY_INSERT dbo.ML_Model_Sonuc ON;
INSERT INTO dbo.ML_Model_Sonuc (SonucID, MusteriID, BasvuruID, ModelAdi, Cikti, TahminEtiketi, Tarih) VALUES
(1, 1, 1, 'LineerRegresyon', 0.8500, 'ONAY', '2026-05-02'),
(2, 2, 2, 'LineerRegresyon', 0.6500, 'ONAY', '2026-05-03'),
(3, 3, 3, 'LineerRegresyon', 0.3500, 'RED', '2026-05-04'),
(4, 4, 4, 'LineerRegresyon', 0.2000, 'RED', '2026-05-05'),
(5, 5, 5, 'LineerRegresyon', 0.7800, 'ONAY', '2026-05-06'),
(6, 6, 6, 'LineerRegresyon', 0.9000, 'ONAY', '2026-05-07'),
(7, 7, 7, 'LineerRegresyon', 0.4200, 'RED', '2026-05-08'),
(8, 8, 8, 'LineerRegresyon', 0.8800, 'ONAY', '2026-05-09'),
(9, 9, 9, 'LineerRegresyon', 0.5500, 'ONAY', '2026-05-10'),
(10, 10, 10, 'LineerRegresyon', 0.8200, 'ONAY', '2026-05-11');
GO
SET IDENTITY_INSERT dbo.ML_Model_Sonuc OFF;