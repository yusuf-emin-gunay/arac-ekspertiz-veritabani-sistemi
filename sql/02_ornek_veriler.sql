-- ====================================================================
-- PROJE: İkinci El Araç Ekspertiz Veritabanı Sistemi
-- DOSYA: 02_ornek_veriler.sql
-- ====================================================================

-- 1. Musteriler Ekleme
INSERT INTO Musteriler (Ad, Soyad, Telefon, Email, Adres) VALUES
('Ahmet', 'Yilmaz', '05321112233', 'ahmet.yilmaz@email.com', 'Malatya Merkez'),
('Mehmet', 'Kaya', '05442223344', 'mehmet.kaya@email.com', 'Battalgazi / Malatya'),
('Ayse', 'Demir', '05553334455', 'ayse.demir@email.com', 'Yesilyurt / Malatya'),
('Fatma', 'Celik', '05054445566', 'fatma.celik@email.com', 'Elazig Merkez'),
('Ali', 'Ozturk', '05335556677', 'ali.ozturk@email.com', 'Keban / Elazig');

-- 2. Paketler Ekleme
INSERT INTO Paketler (PaketAdi, Ucret, Aciklama) VALUES
('Standart Paket', 7000.00, 'Temel motor ve kaporta kontrolü'),
('Full Ekspertiz', 10000.00, 'Motor, mekanik, kaporta, boya mikron ve alt takım kontrolü'),
('VIP Ekspertiz', 14000.00, 'Full paket + yol testi, conta kacak ve beyin/OBD teşhis');

-- 3. Parcalar Kataloğu Ekleme
INSERT INTO Parcalar (ParcaAdi, Kategori) VALUES
('Motor Blogu', 'Mekanik'),
('Sanziman', 'Mekanik'),
('On Fren Sistemi', 'Mekanik'),
('Kaput', 'Kaporta'),
('Tavan', 'Kaporta'),
('Sol On Camurluk', 'Kaporta'),
('Sag On Kapi', 'Kaporta'),
('Bagaj Kapagi', 'Kaporta'),
('OBD Beyin Testi', 'Elektronik');

-- 4. Teknisyenler Ekleme
INSERT INTO Teknisyenler (Ad, Soyad, UzmanlikAlani) VALUES
('Murat', 'Usta', 'Kaporta-Boya'),
('Hasan', 'Usta', 'Motor-Mekanik'),
('Emre', 'Tekniker', 'Elektronik');

-- 5. Araclar Ekleme (MusteriID ile bagli)
INSERT INTO Araclar (MusteriID, Plaka, Marka, Model, ModelYili, YakitTuru, VitesTuru, MevcutKM) VALUES
(1, '44 AA 101', 'Ford', 'Focus', 2017, 'Dizel', 'Manuel', 145000),
(2, '44 BB 202', 'Renault', 'Megane', 2020, 'Benzin', 'Otomatik', 78000),
(3, '23 EA 303', 'Volkswagen', 'Golf', 2015, 'Dizel', 'Otomatik', 192000),
(4, '34 CC 404', 'Fiat', 'Egea', 2021, 'Dizel', 'Manuel', 65000);

-- 6. Raporlar Ekleme (AracID ve PaketID ile bagli)
INSERT INTO Raporlar (AracID, PaketID, GelisKM, ToplamTutar, GenelNot) VALUES
(1, 2, 145000, 3000.00, 'Arac genel kondisyonu yasına gore normal, periyodik bakim onerilir.'),
(2, 3, 78000, 4500.00, 'Elektronik sistemler ve yuruyen aksam kusursuz.');

-- 7. RaporDetay (3'LÜ İLİŞKİ: RaporID + ParcaID + TeknisyenID)
-- Rapor 1 (Ford Focus) İnceleme Detayları
INSERT INTO RaporDetay (RaporID, ParcaID, TeknisyenID, Durum, BoyaMikron, UstaNotu) VALUES
(1, 4, 1, 'Boyali', 230, 'Macunlu yuzeysel boya tespit edildi'),
(1, 5, 1, 'Orijinal', 115, 'Fabrika cikis boya degeri'),
(1, 6, 1, 'Degisen', 90, 'Cıvatalar sokulmus, parca degistirilmis'),
(1, 1, 2, 'Orijinal', 0, 'Yag kacagi yok, kompresyon testi basarili'),
(1, 3, 2, 'Orijinal', 0, 'On balatalar %70 seviyesinde');

-- Rapor 2 (Renault Megane) İnceleme Detayları
INSERT INTO RaporDetay (RaporID, ParcaID, TeknisyenID, Durum, BoyaMikron, UstaNotu) VALUES
(2, 4, 1, 'Orijinal', 110, 'Hatasiz orijinal parca'),
(2, 5, 1, 'Orijinal', 105, 'Hatasiz'),
(2, 9, 3, 'Orijinal', 0, 'Ariza kodu bulunamadi, tum sensorler aktif');