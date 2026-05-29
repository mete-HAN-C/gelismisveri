USE FintechDB;
GO

IF OBJECT_ID('dbo.trg_FraudKontrol', 'TR') IS NOT NULL 
    DROP TRIGGER dbo.trg_FraudKontrol;
GO

CREATE TRIGGER dbo.trg_FraudKontrol
ON dbo.Islem
AFTER INSERT
AS
BEGIN
    UPDATE dbo.Islem 
    SET FraudFlag = 1 
    FROM dbo.Islem i
    INNER JOIN inserted ins ON i.IslemID = ins.IslemID
    WHERE ins.Tutar > 50000;

    INSERT INTO dbo.Fraud_Log (IslemID, RiskSkoru, Aciklama)
    SELECT IslemID, 0.90, N'Yüksek tutarlı işlem tespiti'
    FROM inserted
    WHERE Tutar > 50000;
END;
GO

IF OBJECT_ID('dbo.trg_BasvuruDegerlendirme', 'TR') IS NOT NULL 
    DROP TRIGGER dbo.trg_BasvuruDegerlendirme;
GO

CREATE TRIGGER dbo.trg_BasvuruDegerlendirme
ON dbo.Kredi_Basvuru
AFTER UPDATE
AS
BEGIN
    IF UPDATE(Durum)
    BEGIN
        UPDATE dbo.Kredi_Basvuru
        SET DegerlendirmeTarihi = GETDATE()
        FROM dbo.Kredi_Basvuru kb
        INNER JOIN inserted ins ON kb.BasvuruID = ins.BasvuruID
        INNER JOIN deleted del ON kb.BasvuruID = del.BasvuruID
        WHERE ins.Durum <> del.Durum;
    END
END;
GO