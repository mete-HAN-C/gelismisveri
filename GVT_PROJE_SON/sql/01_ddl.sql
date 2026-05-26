IF NOT EXISTS (SELECT 1 FROM sys.databases WHERE name = 'FintechDB')
    CREATE DATABASE FintechDB;
GO

USE FintechDB;
GO

IF OBJECT_ID('dbo.Fraud_Log',      'U') IS NOT NULL DROP TABLE dbo.Fraud_Log;
IF OBJECT_ID('dbo.ML_Model_Sonuc', 'U') IS NOT NULL DROP TABLE dbo.ML_Model_Sonuc;
IF OBJECT_ID('dbo.Kredi_Skoru',    'U') IS NOT NULL DROP TABLE dbo.Kredi_Skoru;
IF OBJECT_ID('dbo.Kredi_Basvuru',  'U') IS NOT NULL DROP TABLE dbo.Kredi_Basvuru;
IF OBJECT_ID('dbo.Islem',          'U') IS NOT NULL DROP TABLE dbo.Islem;
IF OBJECT_ID('dbo.Hesap',          'U') IS NOT NULL DROP TABLE dbo.Hesap;
IF OBJECT_ID('dbo.Musteri',        'U') IS NOT NULL DROP TABLE dbo.Musteri;
GO

CREATE TABLE dbo.Musteri (
    MusteriID   INT IDENTITY(1,1) PRIMARY KEY,
    Ad          NVARCHAR(50)  NOT NULL,
    Soyad       NVARCHAR(50)  NOT NULL,
    TCKN        CHAR(11)      NOT NULL UNIQUE CHECK (LEN(TCKN) = 11),
    DogumTarihi DATE          NULL CHECK (DogumTarihi >= '1900-01-01'),
    Email       NVARCHAR(100) NULL UNIQUE,
    Telefon     NVARCHAR(15)  NULL,
    KayitTarihi DATETIME      NOT NULL DEFAULT GETDATE()
);
GO

CREATE TABLE dbo.Hesap (
    HesapID      INT IDENTITY(1,1) PRIMARY KEY,
    MusteriID    INT           NOT NULL REFERENCES dbo.Musteri(MusteriID),
    HesapNo      VARCHAR(20)   NOT NULL UNIQUE,
    Bakiye       DECIMAL(18,2) NOT NULL DEFAULT 0 CHECK (Bakiye >= 0),
    ParaBirimi   CHAR(3)       NOT NULL DEFAULT 'TRY' CHECK (ParaBirimi IN ('TRY','USD','EUR')),
    HesapTipi    NVARCHAR(20)  NOT NULL CHECK (HesapTipi IN ('VADESIZ','VADELI','KREDI')),
    AcilisTarihi DATETIME      NOT NULL DEFAULT GETDATE(),
    Durum        NVARCHAR(20)  NOT NULL DEFAULT 'AKTIF' CHECK (Durum IN ('AKTIF','PASIF','KAPALI'))
);
GO

CREATE TABLE dbo.Islem (
    IslemID     INT IDENTITY(1,1) PRIMARY KEY,
    HesapID     INT           NOT NULL REFERENCES dbo.Hesap(HesapID),
    Tutar       DECIMAL(18,2) NOT NULL CHECK (Tutar > 0),
    IslemTipi   NVARCHAR(20)  NOT NULL CHECK (IslemTipi IN ('HAVALE','EFT','ATM','POS')),
    IslemTarihi DATETIME      NOT NULL DEFAULT GETDATE(),
    Aciklama    NVARCHAR(200) NULL,
    FraudFlag   BIT           NOT NULL DEFAULT 0
);
GO

CREATE TABLE dbo.Kredi_Basvuru (
    BasvuruID           INT IDENTITY(1,1) PRIMARY KEY,
    MusteriID           INT           NOT NULL REFERENCES dbo.Musteri(MusteriID),
    BasvuruTarihi       DATETIME      NOT NULL DEFAULT GETDATE(),
    TalepEdilenTutar    DECIMAL(18,2) NOT NULL CHECK (TalepEdilenTutar > 0),
    Vade                INT           NOT NULL CHECK (Vade > 0),
    AylikGelir          DECIMAL(18,2) NOT NULL CHECK (AylikGelir >= 0),
    Durum               NVARCHAR(20)  NOT NULL DEFAULT 'BEKLEMEDE' CHECK (Durum IN ('BEKLEMEDE','ONAYLANDI','REDDEDILDI')),
    DegerlendirmeTarihi DATETIME      NULL
);
GO

CREATE TABLE dbo.Kredi_Skoru (
    SkorID           INT IDENTITY(1,1) PRIMARY KEY,
    MusteriID        INT          NOT NULL REFERENCES dbo.Musteri(MusteriID),
    Skor             DECIMAL(5,4) NOT NULL CHECK (Skor BETWEEN 0 AND 1),
    HesaplamaTarihi  DATETIME     NOT NULL DEFAULT GETDATE(),
    HesaplamaYontemi NVARCHAR(50) NOT NULL
);
GO

CREATE TABLE dbo.Fraud_Log (
    LogID     INT IDENTITY(1,1) PRIMARY KEY,
    IslemID   INT           NOT NULL REFERENCES dbo.Islem(IslemID),
    RiskSkoru DECIMAL(5,4)  NOT NULL CHECK (RiskSkoru BETWEEN 0 AND 1),
    Aciklama  NVARCHAR(500) NULL,
    LogTarihi DATETIME      NOT NULL DEFAULT GETDATE()
);
GO

CREATE TABLE dbo.ML_Model_Sonuc (
    SonucID       INT IDENTITY(1,1) PRIMARY KEY,
    MusteriID     INT           NOT NULL REFERENCES dbo.Musteri(MusteriID),
    BasvuruID     INT           NOT NULL REFERENCES dbo.Kredi_Basvuru(BasvuruID),
    ModelAdi      NVARCHAR(50)  NOT NULL,
    Cikti         DECIMAL(5,4)  NOT NULL CHECK (Cikti BETWEEN 0 AND 1),
    TahminEtiketi NVARCHAR(20)  NOT NULL CHECK (TahminEtiketi IN ('ONAY','RED')),
    Tarih         DATETIME      NOT NULL DEFAULT GETDATE()
);
GO

CREATE INDEX IX_Islem_HesapID_Tarih   ON dbo.Islem(HesapID, IslemTarihi);
CREATE INDEX IX_Islem_HesapID ON dbo.Islem(HesapID);
CREATE INDEX IX_Hesap_MusteriID   ON dbo.Hesap(MusteriID);
CREATE INDEX IX_Kredi_MusteriID   ON dbo.Kredi_Basvuru(MusteriID);
GO