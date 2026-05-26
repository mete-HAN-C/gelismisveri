USE FintechDB;
GO

IF DATABASE_PRINCIPAL_ID('db_readonly') IS NOT NULL 
    DROP ROLE db_readonly;
GO

IF DATABASE_PRINCIPAL_ID('db_operator') IS NOT NULL 
    DROP ROLE db_operator;
GO

CREATE ROLE db_readonly;
CREATE ROLE db_operator;
GO

CREATE USER fintech_reader   WITHOUT LOGIN;
CREATE USER fintech_operator WITHOUT LOGIN;
GO

ALTER ROLE db_readonly ADD MEMBER fintech_reader;
ALTER ROLE db_operator ADD MEMBER fintech_operator;
GO

GRANT SELECT ON dbo.Musteri TO db_readonly;
GRANT SELECT ON dbo.Hesap TO db_readonly;
GRANT SELECT ON dbo.Islem TO db_readonly;
GRANT SELECT ON dbo.v_aktif_hesaplar TO db_readonly;

GRANT SELECT ON dbo.v_kredi_raporu TO db_readonly;
GRANT SELECT ON dbo.v_fraud_ozet TO db_readonly;
GO

GRANT SELECT, INSERT, UPDATE ON dbo.Hesap TO db_operator;
GRANT SELECT, INSERT, UPDATE ON dbo.Islem TO db_operator;
GRANT SELECT, INSERT, UPDATE ON dbo.Kredi_Basvuru TO db_operator;
GRANT EXECUTE ON dbo.IslemEkle TO db_operator;
GRANT DELETE ON dbo.Musteri TO db_operator;
GO

REVOKE DELETE ON dbo.Musteri FROM db_operator;
GO