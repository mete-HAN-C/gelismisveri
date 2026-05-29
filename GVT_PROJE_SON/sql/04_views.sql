USE FintechDB;
GO

IF EXISTS (SELECT * FROM sys.views WHERE name = 'v_aktif_hesaplar')
    DROP VIEW dbo.v_aktif_hesaplar;
GO

CREATE VIEW dbo.v_aktif_hesaplar AS
SELECT HesapID, HesapNo, Bakiye, ParaBirimi, HesapTipi
FROM dbo.Hesap
WHERE Durum = 'AKTIF';
GO

IF EXISTS (SELECT * FROM sys.views WHERE name = 'v_kredi_raporu')
    DROP VIEW dbo.v_kredi_raporu;
GO

CREATE VIEW dbo.v_kredi_raporu AS
SELECT kb.BasvuruID, m.Ad + ' ' + m.Soyad AS Musteri, kb.TalepEdilenTutar, kb.Vade, kb.Durum
FROM dbo.Musteri m
INNER JOIN dbo.Kredi_Basvuru kb ON m.MusteriID = kb.MusteriID;
GO

IF EXISTS (SELECT * FROM sys.views WHERE name = 'v_fraud_ozet')
    DROP VIEW dbo.v_fraud_ozet;
GO

CREATE VIEW dbo.v_fraud_ozet AS
SELECT HesapID, COUNT(*) AS ToplamIslem, SUM(CAST(FraudFlag AS INT)) AS ToplamFraudSayisi
FROM dbo.Islem
GROUP BY HesapID;
GO