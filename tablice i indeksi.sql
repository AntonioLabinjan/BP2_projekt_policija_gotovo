DROP DATABASE IF EXISTS Policija;
CREATE DATABASE Policija;

USE Policija;

CREATE TABLE Podrucje_uprave (
    id INT AUTO_INCREMENT PRIMARY KEY,
    naziv VARCHAR(255) NOT NULL UNIQUE
);
# U tablici područje uprave možemo staviti indeks na stupac naziv zato jer je on UNIQUE
CREATE INDEX idx_naziv_podrucje_uprave ON Podrucje_uprave(naziv);

CREATE TABLE Mjesto (
    id INT AUTO_INCREMENT PRIMARY KEY,
    naziv VARCHAR(255) NOT NULL,
    id_podrucje_uprave INT,
    FOREIGN KEY (Id_Podrucje_Uprave) REFERENCES Podrucje_uprave(Id)
);
# U tablici mjesto možemo staviti indeks na stupac naziv zato jer je on UNIQUE i na stupac id_podrucje_uprave kako bismo ubrzali pretragu po području uprave
CREATE INDEX idx_naziv_mjesto ON Mjesto(naziv);
CREATE INDEX idx_id_podrucje_uprave ON Mjesto(id_podrucje_uprave);

CREATE TABLE Zgrada (
    id INT AUTO_INCREMENT PRIMARY KEY,
    adresa VARCHAR(255) NOT NULL,
    id_mjesto INT,
    vrsta_zgrade VARCHAR(30),
    FOREIGN KEY (id_mjesto) REFERENCES Mjesto(ID)
);
# U tablici zgrada možemo staviti indeks na stupac adresa zato da ubrzamo pretraživanje po afresi i na stupac id_mjesto da ubrzamo pretragu po mjestima 
CREATE INDEX idx_adresa_zgrada ON Zgrada(adresa);
CREATE INDEX idx_id_mjesto_zgrada ON Zgrada(id_mjesto);

CREATE TABLE  Radno_mjesto(
    id INT AUTO_INCREMENT PRIMARY KEY,
    vrsta VARCHAR(255) NOT NULL,
    dodatne_informacije TEXT
);
# Ova će tablica sadržavati manji broj redaka i neće se često mijenjati zbog svoje prirode, pa nam ne trebaju indeksi

CREATE TABLE Odjeli (
    id INT AUTO_INCREMENT PRIMARY KEY,
    naziv VARCHAR(255) NOT NULL UNIQUE,
    opis TEXT
);
# Ova će tablica sadržavati manji broj redaka i neće se često mijenjati zbog svoje prirode, pa nam ne trebaju indeksi

CREATE TABLE Osoba (
    id INT AUTO_INCREMENT PRIMARY KEY,
    ime_prezime VARCHAR(255) NOT NULL,
    datum_rodenja DATE NOT NULL,
    oib CHAR(11) NOT NULL UNIQUE,
    spol VARCHAR(10) NOT NULL,
    adresa VARCHAR(255) NOT NULL,
    telefon VARCHAR(20) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE
    );
# U tablici osoba možemo staviti indekse na stupce oib i email jer su označeni kao unique
CREATE INDEX idx_oib_osoba ON Osoba(oib);
CREATE INDEX idx_email_osoba ON Osoba(email);


CREATE TABLE Zaposlenik (
  id INT AUTO_INCREMENT PRIMARY KEY,
  datum_zaposlenja DATE NOT NULL,
  datum_izlaska_iz_sluzbe DATE, # ovo može biti NULL ako nije izašao iz službe
  id_nadređeni INT,
  id_radno_mjesto INT,
  id_odjel INT,
  id_zgrada INT,
  id_osoba INT,
  FOREIGN KEY (id_nadređeni) REFERENCES Zaposlenik(id), 
  FOREIGN KEY (id_radno_mjesto) REFERENCES Radno_mjesto(id),
  FOREIGN KEY (id_odjel) REFERENCES Odjeli(id),
  FOREIGN KEY (id_zgrada) REFERENCES Zgrada(id), # ovo je tipa zatvor di se nalazi/postaja di dela itd.
  FOREIGN KEY (id_osoba) REFERENCES Osoba(id)
);
# U tablici zaposlenik možemo staviti indeks na stupac datum_zaposlenja(ne i na stupac datum_izlaska_iz službe, jer za većinu zaposlenika je taj atribut NULL) i na radno mjesto da bismo mogli pretraživati brže zaposlenike po radnom mjestu
CREATE INDEX idx_datum_zaposlenja_zaposlenik ON Zaposlenik(datum_zaposlenja);
CREATE INDEX idx_radno_mjesto_zaposlenik ON Zaposlenik(id_radno_mjesto)	;

	CREATE TABLE Vozilo (
    id INT AUTO_INCREMENT PRIMARY KEY,
    marka VARCHAR(255) NOT NULL,
    model VARCHAR(255) NOT NULL,
    registracija VARCHAR(20) UNIQUE,
    godina_proizvodnje INT NOT NULL,
    sluzbeno_vozilo BOOLEAN, # je li službeno ili ne
    id_vlasnik INT NOT NULL, # ovaj FK se odnosi na privatna/osobna vozila
    FOREIGN KEY (id_vlasnik) REFERENCES Osoba(id)
);
# U tablici vozilo možemo staviti indeks na stupac registracija zato što je unique i na id_vlasnik da bismo ubrzali pretragu po vlasniku
CREATE INDEX idx_registracija_vozilo ON Vozilo(registracija);
CREATE INDEX idx_id_vlasnik_vozilo ON Vozilo(id_vlasnik);


CREATE TABLE Predmet (
    id INT AUTO_INCREMENT PRIMARY KEY,
    naziv VARCHAR(255) NOT NULL,
    id_mjesto_pronalaska INT,
    FOREIGN KEY (id_mjesto_pronalaska) REFERENCES Mjesto(id)
);
# U tablici predmet možemo staviti indekse na stupac naziv zato što nam olakšava pretragu predmeta i na id_mjesto pronalaska kako bismo brže pronalazili mjesto pronalska za predmete
CREATE INDEX idx_naziv_predmet ON Predmet(naziv);
CREATE INDEX idx_id_mjesto_pronalaska_predmet ON Predmet(id_mjesto_pronalaska);

CREATE TABLE Kaznjiva_djela (
    id INT AUTO_INCREMENT PRIMARY KEY,
    naziv VARCHAR(255) NOT NULL UNIQUE,
    opis TEXT NOT NULL,
    predvidena_kazna INT,#zatvorska
    predvidena_novcana_kazna DECIMAL(10,2)
    
);
# Ova će tablica sadržavati manji broj redaka i neće se često mijenjati zbog svoje prirode, pa nam ne trebaju indeksi

CREATE TABLE Pas (
    id INTEGER AUTO_INCREMENT PRIMARY KEY,
    id_trener INTEGER, # to je osoba zadužena za rad s psom
    oznaka VARCHAR(255) UNIQUE, # pretpostavljan da je ovo unikatno za svakega psa; ima mi logike 
    godina_rođenja INTEGER NOT NULL,
    status VARCHAR(255),
    id_kaznjivo_djelo INTEGER,# dali je pas za drogu/ljude/oružje itd.	
    FOREIGN KEY (id_trener) REFERENCES Zaposlenik(id),
    FOREIGN KEY (id_kaznjivo_djelo) REFERENCES Kaznjiva_djela(id)
    );
CREATE INDEX idx_id_kaznjivo_djelo_pas ON Pas(id_kaznjivo_djelo);
# Kod psa je najbolje indeksirati stupac koji regerencira kaznjiva djela za koja je pas zadužen kako bismo mogli pronalaziti odgovarajuće pse za pojedine slučajeve
CREATE TABLE Slucaj (
    id INT AUTO_INCREMENT PRIMARY KEY,
    naziv VARCHAR(255) NOT NULL,
    opis TEXT,
    pocetak DATETIME NOT NULL,
    zavrsetak DATETIME,
    status VARCHAR(20),
    id_pocinitelj INT,
    id_izvjestitelj INT,
    id_voditelj INT,
    id_dokaz INT,
    ukupna_vrijednost_zapljena INT DEFAULT 0,
    id_pas INT,
    id_svjedok INT,
id_ostecenik INT,
    FOREIGN KEY (id_pocinitelj) REFERENCES Osoba(id),
    FOREIGN KEY (id_izvjestitelj) REFERENCES Osoba(id),
    FOREIGN KEY (id_voditelj) REFERENCES Zaposlenik(id),
    FOREIGN KEY (id_dokaz) REFERENCES Predmet(id),
    FOREIGN KEY (id_pas) REFERENCES Pas(id),
    FOREIGN KEY (id_svjedok) REFERENCES Osoba(id),
FOREIGN KEY (id_ostecenik) REFERENCES Osoba(id)
);

# U tablici slučaj, možemo indeksirati stupac početak da bismo brže pretraživali slučajeve po datumu početka
# Možemp indeksirati i sve strane ključeve kako bismo ubrzali pretragu po njima
CREATE INDEX idx_pocetak_slucaj ON Slucaj(pocetak);
CREATE INDEX idx_id_pocinitelj_slucaj ON Slucaj(id_pocinitelj);
CREATE INDEX idx_id_izvjestitelj_slucaj ON Slucaj(id_izvjestitelj);
CREATE INDEX idx_id_voditelj_slucaj ON Slucaj(id_voditelj);
CREATE INDEX idx_id_dokaz_slucaj ON Slucaj(id_dokaz);
CREATE INDEX idx_id_pas_slucaj ON Slucaj(id_pas);
CREATE INDEX idx_id_svjedok_slucaj ON Slucaj(id_svjedok);
CREATE INDEX idx_id_ostecenik_slucaj ON Slucaj(id_ostecenik);

# U prezentaciji spomenut da je ovo evidencija nekriminalnih događaja (npr. izlazak policajca na uviđaj, ispitivanje svjedoka itd.)
CREATE TABLE Evidencija_dogadaja (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_slucaj INT,
    opis_dogadaja TEXT NOT NULL,
    datum_vrijeme DATETIME NOT NULL,
    id_mjesto INT NOT NULL,
    FOREIGN KEY (id_slucaj) REFERENCES Slucaj(id),
    FOREIGN KEY (id_mjesto) REFERENCES Mjesto(id)
);
# U tablici evidencija događaja možemo indeksirati strane ključeve da ubrzamo pretragu po slučaju i mjestu
CREATE INDEX idx_id_slucaj_evidencija_dogadaja ON Evidencija_dogadaja(id_slucaj);
CREATE INDEX idx_id_mjesto_evidencija_dogadaja ON Evidencija_dogadaja(id_mjesto);



CREATE TABLE Kaznjiva_djela_u_slucaju (
	id INT AUTO_INCREMENT PRIMARY KEY,
	id_mjesto INT,
    id_slucaj INT,
    id_kaznjivo_djelo INT,
	FOREIGN KEY (id_mjesto) REFERENCES Mjesto(id),
    FOREIGN KEY (id_slucaj) REFERENCES Slucaj(id),
    FOREIGN KEY (id_kaznjivo_djelo) REFERENCES Kaznjiva_djela(id)
);
# Možemo dodati indekse na mjestu, slučaju i kaznjivom djelu kako bismo ubrzali pretragu po svakom od atributa
CREATE INDEX idx_id_mjesto_kaznjiva_djela ON Kaznjiva_djela_u_slucaju(id_mjesto);
CREATE INDEX idx_id_slucaj_kaznjiva_djela ON Kaznjiva_djela_u_slucaju(id_slucaj);
CREATE INDEX idx_id_kaznjivo_djelo_kaznjiva_djela ON Kaznjiva_djela_u_slucaju(id_kaznjivo_djelo);



CREATE TABLE Izvjestaji (
    id INT AUTO_INCREMENT PRIMARY KEY,
    naslov VARCHAR(255) NOT NULL,
    sadrzaj TEXT NOT NULL,
    id_autor INT NOT NULL,
    id_slucaj INT NOT NULL,
    FOREIGN KEY (id_autor) REFERENCES Zaposlenik(id),
    FOREIGN KEY (id_slucaj) REFERENCES Slucaj(id)
);
# U tablici izvjestaji možemo indeksirati autora i slucaj kako bismo brže pretraživali izvještaje određenih autora, ili za određene slučajeve
CREATE INDEX idx_id_autor_izvjestaji ON Izvjestaji(id_autor);
CREATE INDEX idx_id_slucaj_izvjestaji ON Izvjestaji(id_slucaj);

CREATE TABLE Zapljene (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_slucaj INT NOT NULL,
    id_predmet INT NOT NULL,
    vrijednost NUMERIC (10,2),
    FOREIGN KEY (id_slucaj) REFERENCES Slucaj(id),
    FOREIGN KEY (id_predmet) REFERENCES Predmet(id)
);
# U tablici zapljene možemo indeksirati slucaj i predmet zbog brže pretrage po tim atributima
CREATE INDEX idx_id_slucaj_zapljene ON Zapljene(id_slucaj);
CREATE INDEX idx_id_predmet_zapljene ON Zapljene(id_predmet);

CREATE TABLE Sredstvo_utvrdivanja_istine ( # ovo je tipa poligraf, alkotest i sl.
	id INT AUTO_INCREMENT PRIMARY KEY,
    naziv VARCHAR(100) NOT NULL
);

CREATE TABLE Sui_slucaj (
	id INT AUTO_INCREMENT PRIMARY KEY,
    id_sui INT NOT NULL,
    id_slucaj INT NOT NULL,
    FOREIGN KEY (id_sui) REFERENCES Sredstvo_utvrdivanja_istine(id),
    FOREIGN KEY (id_slucaj) REFERENCES Slucaj(id)
);
# U tablici sui_slucaj možemo idneksirati id_sui i id_slucaj zbog brže pretrage
CREATE INDEX idx_id_sui_sui_slucaj ON Sui_slucaj(id_sui);
CREATE INDEX idx_id_slucaj_sui_slucaj ON Sui_slucaj(id_slucaj);
