USE FintechDB;
GO

BEGIN TRY
    BEGIN TRANSACTION;

    UPDATE dbo.Hesap SET Bakiye = Bakiye - 500 WHERE HesapID = 1;
    UPDATE dbo.Hesap SET Bakiye = Bakiye + 500 WHERE HesapID = 3;

    INSERT INTO dbo.Islem (HesapID, Tutar, IslemTipi, Aciklama) VALUES (1, 500, 'HAVALE', 'Giden transfer');
    INSERT INTO dbo.Islem (HesapID, Tutar, IslemTipi, Aciklama) VALUES (3, 500, 'HAVALE', 'Gelen transfer');

    COMMIT TRANSACTION;
    PRINT 'Senaryo 1: Transfer basariyla tamamlandi.';
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;
    PRINT 'Senaryo 1: Hata olustu, islemler geri alindi.';
END CATCH;
GO

BEGIN TRY
    BEGIN TRANSACTION;

    UPDATE dbo.Kredi_Basvuru SET Durum = 'ONAYLANDI' WHERE BasvuruID = 2;
    UPDATE dbo.Hesap SET Bakiye = Bakiye + 150000 WHERE HesapID = 3;
    INSERT INTO dbo.Islem (HesapID, Tutar, IslemTipi, Aciklama) VALUES (3, 150000, 'HAVALE', 'Kredi yuklemesi');

    COMMIT TRANSACTION;
    PRINT 'Senaryo 2: Kredi kullandirimi basariyla tamamlandi.';
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;
    PRINT 'Senaryo 2: Hata olustu, kredi islemi iptal edildi.';
END CATCH;
GO

BEGIN TRY
    BEGIN TRANSACTION;

    UPDATE dbo.Hesap SET Bakiye = Bakiye - 50000 WHERE HesapID = 11; 

    COMMIT TRANSACTION;
    PRINT 'Senaryo 3: Bu yazinin gelmemesi gerekir (Hata atlandi)!';
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;
    PRINT 'Senaryo 3: Bakiye eksiye dusemezdi! CHECK constraint ihlal edildi ve ROLLBACK basariyla calisti.';
END CATCH;
GO