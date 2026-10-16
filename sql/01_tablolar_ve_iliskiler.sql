-- ====================================================================
-- PROJE: İkinci El Araç Ekspertiz Veritabanı Sistemi
-- DDL SCRIPT: Tablolar, Kısıtlar ve 3'lü İlişki
-- ====================================================================

-- 1. Musteriler Tablosu
CREATE TABLE IF NOT EXISTS Musteriler (
    MusteriID SERIAL PRIMARY KEY,
    Ad VARCHAR(50) NOT NULL,
    Soyad VARCHAR(50) NOT NULL,
    Telefon VARCHAR(15) UNIQUE NOT NULL,
    Email VARCHAR(100),
    Adres TEXT
);

-- 2. Araclar Tablosu (Musteri ile 1:N İliskili)
CREATE TABLE IF NOT EXISTS Araclar (
    AracID SERIAL PRIMARY KEY,
    MusteriID INT NOT NULL,
    Plaka VARCHAR(15) UNIQUE NOT NULL,
    Marka VARCHAR(50) NOT NULL,
    Model VARCHAR(50) NOT NULL,
    ModelYili INT CHECK (ModelYili >= 1990),
    YakitTuru VARCHAR(20),
    VitesTuru VARCHAR(20),
    MevcutKM INT DEFAULT 0 CHECK (MevcutKM >= 0),
    CONSTRAINT fk_arac_musteri FOREIGN KEY (MusteriID) REFERENCES Musteriler(MusteriID) ON DELETE CASCADE
);

-- 3. Paketler Tablosu (Sabit Hizmet Paketleri)
CREATE TABLE IF NOT EXISTS Paketler (
    PaketID SERIAL PRIMARY KEY,
    PaketAdi VARCHAR(50) NOT NULL,
    Ucret NUMERIC(10,2) NOT NULL CHECK (Ucret >= 0),
    Aciklama VARCHAR(200)
);

-- 4. Parcalar Tablosu (Kontrol Noktaları Kataloğu)
CREATE TABLE IF NOT EXISTS Parcalar (
    ParcaID SERIAL PRIMARY KEY,
    ParcaAdi VARCHAR(50) NOT NULL,
    Kategori VARCHAR(30) NOT NULL -- 'Kaporta', 'Mekanik', 'Elektronik'
);

-- 5. Teknisyenler Tablosu (Ekspertizi Yapan Ustalar)
CREATE TABLE IF NOT EXISTS Teknisyenler (
    TeknisyenID SERIAL PRIMARY KEY,
    Ad VARCHAR(50) NOT NULL,
    Soyad VARCHAR(50) NOT NULL,
    UzmanlikAlani VARCHAR(50) NOT NULL -- 'Kaporta-Boya', 'Motor-Mekanik'
);

-- 6. Raporlar Tablosu (Ana Ekspertiz Süreci)
CREATE TABLE IF NOT EXISTS Raporlar (
    RaporID SERIAL PRIMARY KEY,
    AracID INT NOT NULL,
    PaketID INT NOT NULL,
    GelisKM INT NOT NULL CHECK (GelisKM >= 0),
    Tarih TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ToplamTutar NUMERIC(10,2) NOT NULL CHECK (ToplamTutar >= 0),
    GenelNot TEXT,
    CONSTRAINT fk_rapor_arac FOREIGN KEY (AracID) REFERENCES Araclar(AracID),
    CONSTRAINT fk_rapor_paket FOREIGN KEY (PaketID) REFERENCES Paketler(PaketID)
);

-- 7. RaporDetay Tablosu (3'LÜ İLİŞKİ: Rapor + Parca + Teknisyen)
CREATE TABLE IF NOT EXISTS RaporDetay (
    DetayID SERIAL PRIMARY KEY,
    RaporID INT NOT NULL,
    ParcaID INT NOT NULL,
    TeknisyenID INT NOT NULL,
    Durum VARCHAR(30) NOT NULL, -- 'Orijinal', 'Boyali', 'Degisen'
    BoyaMikron INT CHECK (BoyaMikron >= 0),
    UstaNotu VARCHAR(200),
    CONSTRAINT fk_detay_rapor FOREIGN KEY (RaporID) REFERENCES Raporlar(RaporID) ON DELETE CASCADE,
    CONSTRAINT fk_detay_parca FOREIGN KEY (ParcaID) REFERENCES Parcalar(ParcaID),
    CONSTRAINT fk_detay_teknisyen FOREIGN KEY (TeknisyenID) REFERENCES Teknisyenler(TeknisyenID),
    CONSTRAINT uq_rapor_parca UNIQUE (RaporID, ParcaID)
);