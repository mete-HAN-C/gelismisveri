USE FintechDB;
GO

IF OBJECT_ID('dbo.Fact_Islem',    'U') IS NOT NULL DROP TABLE dbo.Fact_Islem;
IF OBJECT_ID('dbo.Dim_Musteri',   'U') IS NOT NULL DROP TABLE dbo.Dim_Musteri;
IF OBJECT_ID('dbo.Dim_Hesap',     'U') IS NOT NULL DROP TABLE dbo.Dim_Hesap;
IF OBJECT_ID('dbo.Dim_Tarih',     'U') IS NOT NULL DROP TABLE dbo.Dim_Tarih;
GO

CREATE TABLE dbo.Dim_Musteri (
    MusteriID   INT PRIMARY KEY,
    AdSoyad     NVARCHAR(100),
    TCKN        CHAR(11),
    Email       NVARCHAR(100)
);
GO

CREATE TABLE dbo.Dim_Hesap (
    HesapID     INT PRIMARY KEY,
    HesapNo     VARCHAR(20),
    HesapTipi   NVARCHAR(20),
    ParaBirimi  CHAR(3)
);
GO

CREATE TABLE dbo.Dim_Tarih (
    TarihID     INT PRIMARY KEY,
    Yil         INT,
    Ay          INT,
    Gun         INT
);
GO

CREATE TABLE dbo.Fact_Islem (
    IslemID     INT PRIMARY KEY,
    MusteriID   INT REFERENCES dbo.Dim_Musteri(MusteriID),
    HesapID     INT REFERENCES dbo.Dim_Hesap(HesapID),
    TarihID     INT REFERENCES dbo.Dim_Tarih(TarihID),
    Tutar       DECIMAL(18,2),
    FraudFlag   BIT
);
GO

INSERT INTO dbo.Dim_Musteri (MusteriID, AdSoyad, TCKN, Email)
SELECT MusteriID, Ad + ' ' + Soyad, TCKN, Email FROM dbo.Musteri;

INSERT INTO dbo.Dim_Hesap (HesapID, HesapNo, HesapTipi, ParaBirimi)
SELECT HesapID, HesapNo, HesapTipi, ParaBirimi FROM dbo.Hesap;


INSERT INTO dbo.Dim_Tarih (TarihID, Yil, Ay, Gun)
SELECT DISTINCT 
    YEAR(IslemTarihi)*10000 + MONTH(IslemTarihi)*100 + DAY(IslemTarihi),
    YEAR(IslemTarihi), 
    MONTH(IslemTarihi), 
    DAY(IslemTarihi) 
FROM dbo.Islem;

INSERT INTO dbo.Fact_Islem (IslemID, MusteriID, HesapID, TarihID, Tutar, FraudFlag)
SELECT 
    i.IslemID, 
    h.MusteriID, 
    i.HesapID, 
    YEAR(i.IslemTarihi)*10000 + MONTH(i.IslemTarihi)*100 + DAY(i.IslemTarihi),
    i.Tutar, 
    i.FraudFlag
FROM dbo.Islem i
INNER JOIN dbo.Hesap h ON i.HesapID = h.HesapID;
GO

 
SELECT dt.Yil, dt.Ay, SUM(f.Tutar) AS ToplamCiro
FROM dbo.Fact_Islem f
INNER JOIN dbo.Dim_Tarih dt ON f.TarihID = dt.TarihID
GROUP BY ROLLUP(dt.Yil, dt.Ay);
GO


SELECT dh.HesapTipi, dh.ParaBirimi, SUM(f.Tutar) AS ToplamHacim
FROM dbo.Fact_Islem f
INNER JOIN dbo.Dim_Hesap dh ON dh.HesapID = f.HesapID
GROUP BY CUBE(dh.HesapTipi, dh.ParaBirimi);
GO