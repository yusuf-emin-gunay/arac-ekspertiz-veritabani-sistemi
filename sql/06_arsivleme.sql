-- ====================================================================
-- PROJE: İkinci El Araç Ekspertiz Veritabanı Sistemi
-- DOSYA: 06_arsivleme.sql
-- AÇIKLAMA: Silinen Araçların Denetim ve Arşiv Logu (Audit Trigger)
-- ====================================================================

-- 1. Arşiv Tablosu
CREATE TABLE IF NOT EXISTS SilinenAraclarArsivi (
    ArsivID SERIAL PRIMARY KEY,
    EskiAracID INT,
    Plaka VARCHAR(15),
    Marka VARCHAR(50),
    Model VARCHAR(50),
    SonKM INT,
    SilinmeTarihi TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    SilenKullanici VARCHAR(50) DEFAULT CURRENT_USER
);

-- 2. Arşivleme Fonksiyonu
CREATE OR REPLACE FUNCTION fn_arac_silme_arsivle()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO SilinenAraclarArsivi (EskiAracID, Plaka, Marka, Model, SonKM)
    VALUES (OLD.AracID, OLD.Plaka, OLD.Marka, OLD.Model, OLD.MevcutKM);
    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

-- 3. Arşivleme Trigger'ı (BEFORE DELETE)
DROP TRIGGER IF EXISTS trg_arac_silme_arsivle ON Araclar;

CREATE TRIGGER trg_arac_silme_arsivle
BEFORE DELETE ON Araclar
FOR EACH ROW
EXECUTE FUNCTION fn_arac_silme_arsivle();