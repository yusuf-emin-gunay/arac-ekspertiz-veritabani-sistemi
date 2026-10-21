-- ====================================================================
-- PROJE: İkinci El Araç Ekspertiz Veritabanı Sistemi
-- DOSYA: 04_views.sql
-- AÇIKLAMA: Raporlama, Özet ve 3'lü İlişki Detay Görünümleri (Views)
-- ====================================================================

-- 1. Görünüm: Genel Ekspertiz Rapor Özeti
-- Müşteri, araç, seçilen paket ve genel rapor durumunu tek tabloda sunar.
CREATE OR REPLACE VIEW vw_ekspertiz_rapor_ozeti AS
SELECT 
    r.RaporID,
    r.Tarih,
    m.Ad || ' ' || m.Soyad AS MusteriAdSoyad,
    m.Telefon,
    a.Plaka,
    a.Marka || ' ' || a.Model AS AracBilgisi,
    r.GelisKM,
    p.PaketAdi,
    r.ToplamTutar,
    r.GenelNot
FROM Raporlar r
JOIN Araclar a ON r.AracID = a.AracID
JOIN Musteriler m ON a.MusteriID = m.MusteriID
JOIN Paketler p ON r.PaketID = p.PaketID;

-- 2. Görünüm: Parça Bazlı Ayrıntılı Ekspertiz Karnesi (3'lü İlişki Görünümü)
-- Rapor, incelenen parça ve inceleyen teknisyenin notlarını birleştirir.
CREATE OR REPLACE VIEW vw_arac_ekspertiz_detayli_karne AS
SELECT 
    r.RaporID,
    a.Plaka,
    par.ParcaAdi,
    par.Kategori,
    rd.Durum AS ParcaDurumu,
    rd.BoyaMikron,
    t.Ad || ' ' || t.Soyad AS InceleyenUsta,
    t.UzmanlikAlani,
    rd.UstaNotu
FROM RaporDetay rd
JOIN Raporlar r ON rd.RaporID = r.RaporID
JOIN Araclar a ON r.AracID = a.AracID
JOIN Parcalar par ON rd.ParcaID = par.ParcaID
JOIN Teknisyenler t ON rd.TeknisyenID = t.TeknisyenID;