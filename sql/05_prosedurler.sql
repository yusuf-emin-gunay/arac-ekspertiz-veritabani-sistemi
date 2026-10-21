-- ====================================================================
-- PROJE: İkinci El Araç Ekspertiz Veritabanı Sistemi
-- DOSYA: 05_prosedurler.sql
-- AÇIKLAMA: İş Mantığı ve Rapor Giriş Prosedürleri (Stored Procedures)
-- ====================================================================

-- 1. Prosedür: Yeni Ekspertiz Raporu Başlatma
-- Araç servise girdiğinde temel rapor kaydını oluşturur.
CREATE OR REPLACE PROCEDURE sp_yeni_ekspertiz_kaydi(
    p_arac_id INT,
    p_paket_id INT,
    p_gelis_km INT,
    p_toplam_tutar DECIMAL(10,2),
    p_genel_not TEXT
)
LANGUAGE plpgsql
AS $$
BEGIN
    -- Raporlar tablosuna yeni kaydı ekler.
    -- (Daha önce yazdığımız trg_km_guvenlik_kontrolu trigger'ı burada otomatik devreye girer)
    INSERT INTO Raporlar (AracID, PaketID, GelisKM, ToplamTutar, GenelNot)
    VALUES (p_arac_id, p_paket_id, p_gelis_km, p_toplam_tutar, p_genel_not);

    RAISE NOTICE 'Yeni ekspertiz kaydı başarıyla oluşturuldu. Araç ID: %, Giriş KM: %', p_arac_id, p_gelis_km;
END;
$$;

-- 2. Prosedür: 3'lü İlişki Parça Ekspertiz Detayı Ekleme
-- Bir rapor için usta, incelenen parça, boya mikronu ve sonuç notunu kaydeder.
CREATE OR REPLACE PROCEDURE sp_parca_ekspertiz_isle(
    p_rapor_id INT,
    p_parca_id INT,
    p_teknisyen_id INT,
    p_durum VARCHAR(30),
    p_boya_mikron INT,
    p_usta_notu TEXT
)
LANGUAGE plpgsql
AS $$
BEGIN
    -- RaporDetay tablosuna 3'lü ilişki kaydını ekler
    INSERT INTO RaporDetay (RaporID, ParcaID, TeknisyenID, Durum, BoyaMikron, UstaNotu)
    VALUES (p_rapor_id, p_parca_id, p_teknisyen_id, p_durum, p_boya_mikron, p_usta_notu);

    RAISE NOTICE 'Parça ekspertiz detayı başarıyla kaydedildi. Rapor ID: %, Parça ID: %', p_rapor_id, p_parca_id;
END;
$$;