-- ====================================================================
-- PROJE: İkinci El Araç Ekspertiz Veritabanı Sistemi
-- DOSYA: 03_triggerlar.sql
-- AÇIKLAMA: Kilometre (KM) Doğrulama ve Sahtekarlık Önleme Trigger'ları
-- ====================================================================

-- 1. Fonksiyon: Araç Kilometre Kontrolü ve Güncellemesi
-- Açıklama: Yeni bir ekspertiz raporu girildiğinde, girilen kilometrenin 
-- aracın mevcut kilometresinden düşük olup olmadığını kontrol eder.
-- Eğer düşükse işlem hata döndürür (KM düşürme engellenir). 
-- Eğer geçerliyse aracın güncel kilometresini otomatik günceller.
CREATE OR REPLACE FUNCTION fn_km_kontrol_ve_guncelle()
RETURNS TRIGGER AS $$
DECLARE
    mevcut_arac_km INT;
BEGIN
    -- İlgili aracın veritabanındaki mevcut kilometresini alıyoruz
    SELECT MevcutKM INTO mevcut_arac_km
    FROM Araclar
    WHERE AracID = NEW.AracID;

    -- Eğer araç için daha önceden bir KM kaydı varsa ve yeni girilen KM daha düşükse
    IF mevcut_arac_km IS NOT NULL AND NEW.GelisKM < mevcut_arac_km THEN
        RAISE EXCEPTION 'HATA: Kilometre Manipülasyonu Tespit Edildi! Girilen KM (%), aracın kayıtlı son kilometresinden (%) düşük olamaz.', 
            NEW.GelisKM, mevcut_arac_km;
    END IF;

    -- Eğer girilen KM geçerliyse, Araclar tablosundaki MevcutKM değerini güncelliyoruz
    UPDATE Araclar
    SET MevcutKM = NEW.GelisKM
    WHERE AracID = NEW.AracID;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- 2. Trigger Tanımlaması
-- Raporlar tablosuna yeni bir ekspertiz kaydı eklenmeden ÖNCE (BEFORE INSERT) tetiklenir.
DROP TRIGGER IF EXISTS trg_km_guvenlik_kontrolu ON Raporlar;

CREATE TRIGGER trg_km_guvenlik_kontrolu
BEFORE INSERT ON Raporlar
FOR EACH ROW
EXECUTE FUNCTION fn_km_kontrol_ve_guncelle();