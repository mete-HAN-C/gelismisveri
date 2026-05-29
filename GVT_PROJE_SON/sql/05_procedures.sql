USE FintechDB;
GO

IF EXISTS (SELECT * FROM sys.procedures WHERE name = 'HesaplaKrediSkoru')
    DROP PROCEDURE dbo.HesaplaKrediSkoru;
GO

CREATE PROCEDURE dbo.HesaplaKrediSkoru
    @MusteriID INT
AS
BEGIN
    DECLARE @bakiye DECIMAL(18,2);
    DECLARE @gelir  DECIMAL(18,2);
    DECLARE @skor   DECIMAL(5,4);

    SELECT @bakiye = ISNULL(SUM(Bakiye), 0)
    FROM dbo.Hesap
    WHERE MusteriID = @MusteriID;

    SET @gelir = ISNULL(
        (SELECT TOP 1 AylikGelir FROM dbo.Kredi_Basvuru
         WHERE MusteriID = @MusteriID ORDER BY BasvuruID DESC),
        0
    );

    SET @skor = (@bakiye * 0.00001) + (@gelir * 0.00002);
    IF @skor > 1 SET @skor = 1;
    IF @skor < 0 SET @skor = 0;

    INSERT INTO dbo.Kredi_Skoru (MusteriID, Skor, HesaplamaYontemi)
    VALUES (@MusteriID, @skor, 'SADE_LINEER');
END;
GO

IF EXISTS (SELECT * FROM sys.procedures WHERE name = 'IslemEkle')
    DROP PROCEDURE dbo.IslemEkle;
GO

CREATE PROCEDURE dbo.IslemEkle
    @HesapID INT,
    @Tutar DECIMAL(18,2),
    @IslemTipi NVARCHAR(20)
AS
BEGIN
    DECLARE @mevcutBakiye DECIMAL(18,2);
    
    SELECT @mevcutBakiye = Bakiye FROM dbo.Hesap WHERE HesapID = @HesapID;

    IF @IslemTipi IN ('POS', 'EFT', 'HAVALE')
    BEGIN
        IF @Tutar > @mevcutBakiye
        BEGIN
            RAISERROR('Yetersiz bakiye! İşlem iptal edildi.', 16, 1);
            RETURN;
        END;

        UPDATE dbo.Hesap 
        SET Bakiye = Bakiye - @Tutar 
        WHERE HesapID = @HesapID;
    END
    ELSE IF @IslemTipi = 'ATM'
    BEGIN
        UPDATE dbo.Hesap 
        SET Bakiye = Bakiye + @Tutar 
        WHERE HesapID = @HesapID;
    END;

    INSERT INTO dbo.Islem (HesapID, Tutar, IslemTipi) 
    VALUES (@HesapID, @Tutar, @IslemTipi);
END;
GO