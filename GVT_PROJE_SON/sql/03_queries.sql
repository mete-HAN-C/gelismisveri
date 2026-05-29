USE FintechDB;
GO

SELECT m.Ad, m.Soyad, h.HesapNo, i.Tutar, i.IslemTipi
FROM dbo.Musteri m
INNER JOIN dbo.Hesap h ON m.MusteriID = h.MusteriID
INNER JOIN dbo.Islem i ON h.HesapID = i.HesapID
WHERE i.Tutar > 5000;
GO

SELECT m.MusteriID, m.Ad, m.Soyad, m.Email
FROM dbo.Musteri m
LEFT JOIN dbo.Kredi_Basvuru kb ON m.MusteriID = kb.MusteriID
WHERE kb.BasvuruID IS NULL;
GO

SELECT i1.HesapID, i1.IslemID AS Islem1, i1.Tutar AS Tutar1, i2.IslemID AS Islem2, i2.Tutar AS Tutar2
FROM dbo.Islem i1
INNER JOIN dbo.Islem i2 ON i1.HesapID = i2.HesapID
WHERE i1.IslemID < i2.IslemID AND i1.IslemTipi = i2.IslemTipi;
GO

SELECT HesapNo, Bakiye, HesapTipi
FROM dbo.Hesap
WHERE Bakiye > (SELECT AVG(Bakiye) FROM dbo.Hesap);
GO

SELECT m.MusteriID, m.Ad, m.Soyad
FROM dbo.Musteri m
WHERE EXISTS (
    SELECT 1 FROM dbo.Hesap h
    INNER JOIN dbo.Islem i ON h.HesapID = i.HesapID
    WHERE h.MusteriID = m.MusteriID AND i.Tutar > 50000
);
GO

SELECT m.MusteriID, m.Ad, m.Soyad 
FROM dbo.Musteri m
WHERE NOT EXISTS (
    SELECT 1 
    FROM dbo.Kredi_Basvuru kb 
    WHERE kb.MusteriID = m.MusteriID
);
GO

SELECT h.MusteriID,
       COUNT(i.IslemID)  AS ToplamIslem,
       SUM(i.Tutar)      AS ToplamHacim,
       MIN(i.Tutar)      AS EnKucukIslem,
       MAX(i.Tutar)      AS EnBuyukIslem
FROM dbo.Hesap h
INNER JOIN dbo.Islem i ON h.HesapID = i.HesapID
GROUP BY h.MusteriID
HAVING COUNT(i.IslemID) >= 2;
GO

SELECT IslemTipi, COUNT(*) AS IslemSayisi, SUM(Tutar) AS ToplamTutar
FROM dbo.Islem
GROUP BY ROLLUP(IslemTipi);
GO

SELECT MusteriID, SUM(TalepEdilenTutar) AS ToplamKrediTalebi, AVG(Vade) AS OrtalamaVade
FROM dbo.Kredi_Basvuru
GROUP BY MusteriID
HAVING SUM(TalepEdilenTutar) >= 100000;
GO