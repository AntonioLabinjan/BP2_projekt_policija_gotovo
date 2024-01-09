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


# PODACI

-- Tablica Područje uprave(1)
INSERT INTO Podrucje_uprave (naziv) VALUES
('Zagrebačka županija'),
('Krapinsko-zagorska županija'),
('Sisačko-moslavačka županija'),
('Karlovačka županija'),
('Varaždinska županija'),
('Koprivničko-križevačka županija'),
('Bjelovarsko-bilogorska županija'),
('Primorsko-goranska županija'),
('Ličko-senjska županija'),
('Virovitičko-podravska županija'),
('Požeško-slavonska županija'),
('Brodsko-posavska županija'),
('Zadarska županija'),
('Osječko-baranjska županija'),
('Šibensko-kninska županija'),
('Vukovarsko-srijemska županija'),
('Splitsko-dalmatinska županija'),
('Istarska županija'),
('Dubrovačko-neretvanska županija'),
('Međimurska županija'),
('Grad Zagreb');

-- Tablica Mjesto(2)
INSERT INTO Mjesto(naziv, id_podrucje_uprave) VALUES
('Pula', 18),
('Pazin', 18),
('Rovinj', 18),
('Rijeka', 8),
('Samobor', 1),
('Vrbovec', 1),
('Zabok', 2),
('Oroslavlje', 2),
('Sisak', 3),
('Petrinja', 3),

('Duga Resa', 4),
('Karlovac', 4),
('Varaždin', 5),
('Lepoglava', 5),
('Koprivnica', 6), 
('Križevci', 6),
('Bjelovar', 7),
('Daruvar', 7),
('Bakar', 8),
('Novi Vinodolski', 8),

('Gospić', 9),
('Senj', 9),
('Virovitica', 10),
('Slatina', 10),
('Požega', 11),
('Pakrac', 11),
('Slavonski Brod', 12),
('Zadar', 13),
('Osijek', 14),
('Šibenik', 15), 

('Vukovar', 16),
('Vinkovci', 16),
('Split', 17),
('Dubrovnik', 19),
('Čakovec', 20),
('Zagreb', 21);

-- Tablica Zgrada(3)
INSERT INTO Zgrada(adresa, id_mjesto, vrsta_zgrade) VALUES
('Jurja Žerjavića 6', 1, 'Policijska postaja'),
('Istarska 32', 2, 'Policijska postaja'),
('Zvonimirova 14', 3, 'Policijska postaja'),
('Dobrilina 33', 4, 'Policijska postaja'),
('Mletačka 1', 5, 'Policijska postaja'),
('Jelačićeva 8', 6, 'Policijska postaja'),
('Matije Gupca 19', 7, 'Policijska postaja'),
('Vrbik 21', 8, 'Policijska postaja'),
('Preradovićeva 55', 9, 'Policijska postaja'),
('Ljudevita Gaja 29', 10, 'Policijska postaja'),
('Nazorova 101', 11, 'Policijska postaja'),
('Tina Ujevića 16', 12, 'Policijska postaja'),
('Kropekova 44', 13, 'Policijska postaja'),
('Put Dragovoda 49', 14, 'Policijska postaja'),
('Poljička Cesta 32', 15, 'Policijska postaja'),
('Trnsko 34', 16, 'Policijska postaja'),
('Radnička cesta 22', 17, 'Policijska postaja'),
('Ujevićeva 11', 18, 'Policijska postaja'),
('Tomašićeva 51', 19, 'Policijska postaja'),
('Dubrova 102', 20, 'Policijska postaja'),
('Istarski razvod 5', 21, 'Policijska postaja'),
('Spinutska 15', 22, 'Policijska postaja'),
('Moslavačka 22', 23, 'Policijska postaja'),
('Ivaniševićeva 1', 24, 'Policijska postaja'),
('Nemčićeva 6', 25, 'Policijska postaja'),
('Nikole Tesle 98', 26, 'Policijska postaja'),
('Zoranićeva 9', 27, 'Policijska postaja'),
('Savska 77', 28, 'Policijska postaja'),
('Benkovačka 10a', 29, 'Policijska postaja'),
('Dubrava 6', 30, 'Policijska postaja'),
('Omiška 27', 31, 'Policijska postaja'),
('Draškovićeva 58', 32, 'Policijska postaja'),
('Križanićev Trg 1', 33, 'Policijska postaja'),
('Trg Stanka Vraza 8', 34, 'Policijska postaja'),
('Janeza Trdine 75', 35, 'Policijska postaja'),
('Dunavska 69', 36, 'Policijska postaja'),

('Savska 96', 2,'Pritvor'),
('Murska 17', 7, 'Pritvor'),
('Dravska 123', 13, 'Pritvor'),
('Koranska 321', 17, 'Pritvor'),
('Zrinskoga 19', 22, 'Pritvor'),
('Šenoina 9', 26, 'Pritvor'),
('Radićeva 8', 3, 'Zatvor'),
('Stepinčeva 13', 8, 'Zatvor'),
('Marunićeva 65', 14, 'Zatvor'),
('Ante Starčevića 15', 18, 'Zatvor'),

('Svilarska 44', 23, 'Zatvor'),
('Kiparska 99', 27, 'Zatvor'),
('Vinodolska 11', 32, 'Zatvor'),
('Starčevićeva 8', 2, 'Zatvor'),
('Lisinskog 91', 17, 'Zatvor'),
('Stipe Ninića 44', 14, 'Pritvor'),
('Matije Gupca 11a', 18, 'Pritvor');

-- Tablica Radno mjesto(4)
INSERT INTO Radno_mjesto(vrsta, dodatne_informacije) VALUES 
('Prometni policajac', 'Policajac koji je zadužen za prometni zakon. On izdaje kazne za prebru vožnju, vožnju u alkoholiziranom stanju ' ),
('Policajac', 'Ovo je općeniti naziv za osobu koja je član policijske snage. Policajci imaju zadatak održavati red, sprječavati zločine i pružati pomoć građanima. '),
('Narednik', 'Narednik je čin u policijskim snagama koji označava viši rang od nižih činova. Narednik obično ima određenu odgovornost u vođenju tima ili jedinice.'),
('Detektiv', 'Detektiv je stručnjak za istraživanje zločina. Ova osoba obično radi u odjelu kriminalističke policije i ima zadaću rješavanja slučajeva, prikupljanja dokaza i identifikacije počinitelja.'),
('Voditelj policije', 'Policajac koji je zadužen za održavanja određene policijske stanice'),
('Zaštitar', 'Zaštitar je osoba koja se bavi osiguranjem i zaštitom imovine, objekata ili ljudi. Ovo može uključivati fizičko osiguranje, nadzor sigurnosnih sustava i reagiranje na potencijalne prijetnje.'),
('Voditelj pritvora', 'Voditelj pritvora odnosi se na osobu koja je odgovorna za upravljanje prostorijama ili objektima u kojima su zadržane osobe, obično prije suđenja ili tijekom istrage.'),
('Voditelj zatvora', 'Voditelj zatvora je osoba koja upravlja svakodnevnim operacijama zatvora. To uključuje nadzor nad zatvorskim osobljem, sigurnošću zatvorenika i provedbom pravila unutar zatvora.'),
('HR zaposlenik', 'Osoba koja radi u odjelu ljudskih resursa (HR). Njihove odgovornosti uključuju regrutiranje, upravljanje osobljem, rješavanje problema zaposlenika te praćenje i primjenu politika tvrtke.'),
('Računovođa', 'Računovođa je stručnjak za financije i računovodstvo. Njihova uloga obuhvaća praćenje financijskih transakcija, sastavljanje financijskih izvještaja, pridržavanje poreznih propisa i pružanje financijskih savjeta.');

-- Tablica Odjeli(5) 
INSERT INTO Odjeli (naziv, opis) VALUES
('Gradska policija', 'Ovi odjeli se bave policijskim poslovima na lokalnoj razini i brinu se za sigurnost građana unutar gradova ili općina.'),
('Prometna policija', 'Ova policijska jedinica nadležna je za kontrolu prometa i sigurnost na cestama, uključujući regulaciju prometa, izdavanje kazni za prekršaje i istraživanje prometnih nesreća.'),
('Kriminalistička policija', 'Ova grana policije bavi se istraživanjem i rješavanjem ozbiljnih kriminalnih slučajeva, uključujući ubojstva, pljačke i ozbiljne prijestupe.'),
('Specijalna policija', 'Ova jedinica obično se koristi za rješavanje izvanrednih situacija poput talačkih kriza, terorističkih prijetnji ili drugih visokorizičnih situacija.'),
('Granična policija', 'Ova agencija zadužena je za kontrolu i sigurnost na granicama zemlje te sprečavanje ilegalnih prelazaka granica i krijumčarenja.'),
('Interventna policija', 'Specijalizirani odjel za brzu i intenzivnu reakciju na ozbiljne incidente i nerede.'),
('Narkotička jedinica', 'Odjel policije koji se bavi narkoticima i suzbijanjem trgovine drogom.'), 
('Policijska inspekcija', 'Odgovorna za unutarnju kontrolu i istragu neetičkog ponašanja unutar same policije.'),
('Financijska policija', 'Ovaj odjel se bavi istragom financijskih prijestupa, utaje poreza i pranja novca.'),
('Administracija', 'Odjel koji se bavi svom papirologijom, što uključuje papirologiju o zaposlenicima, papirologije koju je potrebno imati za slučaj te sve potvrde za poslovanje');

-- Tablica Osobe(6)

INSERT INTO Osoba(Ime_Prezime, Datum_rodenja, Oib, Spol, Adresa, Telefon, Email) VALUES
('Dujko Jezdec', STR_TO_DATE('10.12.1988.', '%d.%m.%Y.'), '52845382039', 'muški', 'Trezijeva 11','099 768 8765', 'dujkojezdec@gmail.com'),
('Aaron Juršević', STR_TO_DATE('17.07.1993.', '%d.%m.%Y.'), '6305194826', 'muški', 'Matije Gupca 9', '095 727 1111', 'aaronjursevic@gmail.com'), 
('Jagoda Voščak', STR_TO_DATE('27.08.1969.', '%d.%m.%Y.'), '23456478222', 'ženski', 'B. Radićeva 7a','098 123 456', 'jagodavoscak8@net.hr'), 
('Kuzma Kočijašević', STR_TO_DATE('13.11.1970.', '%d.%m.%Y.'), '34382945101', 'ženski', 'Bolnička ulica 38', '099 321 4321', 'kocijasevickuzma@gmail,com'),
('Dominik Levanant', STR_TO_DATE('02.02.1984.', '%d.%m.%Y.'), '98765432198', 'muški', 'Matije Gupca 11', '091 222 3333', 'doiniklevanant@gmail.com'), 
('Edina Borovnjak', STR_TO_DATE('03.11.1988.', '%d.%m.%Y.'), '12345678901', 'ženski', 'Mošćenička 88', '099 333 4444', 'edinaborovnjak@yahoo.com'),
('Vanja Lepčin', STR_TO_DATE('29.03.1998.', '%d.%m.%Y.'), '43294620371', 'ženski', 'Velebitska 52', '095 222 2222', 'lepcinv@gmail.com'),
('Ivana Levanat', STR_TO_DATE('13.10.1999.', '%d.%m.%Y.'), '12939496919', 'ženski', 'Kralja Zvonimira 14', '099 333 3333', 'ilevanant11@yahoo.com'),
('Marija Klaso', STR_TO_DATE('17.08.2001.', '%d.%m.%Y.'), '65870943655', 'ženski', 'Lončara Pavla 42', '091 999 9998', 'msrijak123@gmail.com'),
('Nikola Skelić', STR_TO_DATE('07.06.1957.', '%d.%m.%Y.'), '11294587012', 'muški', 'Gundulićeva 121', '098 111 111', 'nskelic22@gmail.com'),

('Jagoda Bubič', STR_TO_DATE('21.12.1993.', '%d.%m.%Y.'), '58172937223', 'ženski', 'M. Benussi 10', '099 656 8787', 'jagodabubic@gmail.com'),
('Rozalija Lepčin', STR_TO_DATE('24.09.1963.', '%d.%m.%Y.'), '94567834567', 'ženski', 'Grič 14', '098 766 5555', 'rosalija9lepcin@gmail.com'),
('Nikola Klaso', STR_TO_DATE('11.01.2003.', '%d.%m.%Y.'), '29876545678', 'muški', 'Dalmatinčeva 87', '099 536 1121', 'nikola1klaso@gmail.com' ),
('Nikolina Kozari', STR_TO_DATE('18.08.1996.', '%d.%m.%Y.'), '13579246804', 'ženski', 'Matejeva 4', '091 222 3366', 'nikolak123@gmail.com'),
('Marko Klaso', STR_TO_DATE('12.12.1989.', '%d.%m.%Y.'), '98812863584', 'muški', 'Travnik 27', '099 323 4747', 'mklaso@yahoo.com'),
('Cvijetka Dardalić', STR_TO_DATE('30.09.1977.', '%d.%m.%Y.'), '54672841977', 'ženski', 'Postolarska 34', '091 232 4444', 'cvijetkadardalić@gmail.com'), 
('Cvijetka Lepčin', STR_TO_DATE('15.05.1980.', '%d.%m.%Y.'), '23234345688', 'ženski', 'Velebitska 123', '095 555 4555', 'clepcin@yahoo.com'), 
('Jagoda Klaso', STR_TO_DATE('29.02.2004.', '%d.%m.%Y.'), '14567237972', 'ženski', 'Preradovićeva 3c', '091 456 777', 'jklaso99@gmail.com'), 
('Nikola Celent', STR_TO_DATE('14.02.1995.', '%d.%m.%Y.'), '21394596522', 'muški', 'Lavoslava Ružičke 81b', '099 99 999', 'Nikola.celent@gmail.com'), 
('Blaško Trotić', STR_TO_DATE('31.12.2002.', '%d.%m.%Y.'), '21010121345', 'muški', 'Sutinska Vrela 22', '091 678 212', 'blaskogtrotic@yahoo.com'), 

('Ivan Jezdec', STR_TO_DATE('16.03.1993.', '%d.%m.%Y.'), '12992752134', 'muški', 'Stačevićeva 13a', '098 212 999', 'ivanjezdec10@gmail.com'),
('Metod Juršević', STR_TO_DATE('01.04.1979.', '%d.%m.%Y.'), '10985754371', 'muški', 'Tuđmana 47', '095 876 2003', 'metodjursevic@gmail.com'),
('Ivana Gregorić', STR_TO_DATE('11.07.1970.', '%d.%m.%Y.'), '88995680882', 'ženski', 'Dubrova 102', '094 378 8044', 'ivana12gregoric@net.hr'),
('Patricia Voščak', STR_TO_DATE('04.09.1975.', '%d.%m.%Y.'), '59987847671', 'ženski', 'Jelačićeva 37a', '092 385 4444', 'patriciavoscak75@gmail.com'),
('Erika Dubroja', STR_TO_DATE('21.12.1981.', '%d.%m.%Y.'), '30989278851', 'ženski', 'Tome Stržića 23', '099 232 6783', 'erikadubroja81@gmail.com'),
-- zaposlenici gore
('Božen Levanant', STR_TO_DATE('27.11.1997.', '%d.%m.%Y.'), '77095354023', 'muški', 'Šestinski dol 63', '098 777 7707', 'bozenlevanat@gmail.com'),
('Emilia Lepčin', STR_TO_DATE('06.01.1985.', '%d.%m.%Y.'), '90991857143', 'ženski', 'Petrova 66', '091 275 6969', 'emilia9lepcin@yahoo.com'),
('Ramon Hrastić', STR_TO_DATE('01.05.2002.', '%d.%m.%Y.'), '29843634452', 'muški', 'Velikogorička 2', '099 887 330', 'rhrastic@gmail.com'),
('Samuela Klaso', STR_TO_DATE('03.09.1959.', '%d.%m.%Y.'), '50958582399', 'ženski', 'Brožova 74', '097 300 0002', 'klasosamuela@gmail.com'),
('Marino Skelić', STR_TO_DATE('31.01.1986.', '%d.%m.%Y.'), '30992715019', 'muški', 'Verdieva 17', '095 983 2004', 'marinoskelic@gmail.com'),

('Filipa Klaso', STR_TO_DATE('09.12.1984.', '%d.%m.%Y.'), '60995642782', 'ženski', 'Vlašićeva 88', '091 205 7004', 'klasofilipa84@gmail.com'),
('Vojmir Kozari', STR_TO_DATE('19.06.1993.', '%d.%m.%Y.'), '77957565120', 'muški', 'Heruca 31', '096 493 3844', 'vojmirkozari@yahoo.com'),
('Janica Klaso', STR_TO_DATE('30.08.1979.', '%d.%m.%Y.'), '64995843429', 'ženski', 'Kovačićeva 57a', '098 569 3294', 'janicaklaso@gmail.com'),
('Johan Dardalić', STR_TO_DATE('27.01.1999.', '%d.%m.%Y.'), '30983721622', 'muški', 'Hebrangova 24', '092 993 3839', 'dardalicjohan@yahoo.com'),
('Anuka Klaso', STR_TO_DATE('22.08.1969.', '%d.%m.%Y.'), '70952423196', 'ženski', 'Ratkovićeva 71', '096 987 3709', 'anukaklaso@gmail.com'),
('Berti Celent', STR_TO_DATE('14.08.1981.', '%d.%m.%Y.'), '22993144610', 'muški', 'Ratarska 90', '094 963 0987', 'berticelent81@gmail.com'),
('Bonita Viher', STR_TO_DATE('07.06.1969.', '%d.%m.%Y.'), '49843199263', 'ženski', 'Vincetićeva 23', '091 748 9478', 'viherbonita12@yahoo.com'),
('Ivan Ivanić', STR_TO_DATE('11.02.1989.', '%d.%m.%Y.'), '98988776577', 'muški', 'Dvojkovićev put 2', '094 569 8610', 'ivanivanic0@gmail.com'),
('Marija Božinović', STR_TO_DATE('13.11.1985.', '%d.%m.%Y.'), '11122233344', 'ženski', 'Jordanovac 103', '097 347 9876', 'marijabozinovic919@gmail.com'),
('Alfonso Faren', STR_TO_DATE('19.10.2000.', '%d.%m.%Y.'), '55566677788', 'muški', 'Kopilica 62', '098 765 4321', 'alfonsohfaren@yahoo.com'),

('Gordana Kovačić', STR_TO_DATE('12.01.2002.', '%d.%m.%Y.'), '12983338921', 'ženski', 'Zvonimorva 6b', '092 444 8884', 'gordanakovacic@net.hr'),
('Dorijan Adamić', STR_TO_DATE('01.07.1988.', '%d.%m.%Y.'), '12345654321', 'muški', 'Marasova 12', '099 370 6549', 'dorijan88adamic@gmail.com'),
('Katja Kovačević', STR_TO_DATE('22.11.1991.', '%d.%m.%Y.'), '22222322222', 'ženski', 'Toplička cesta 33', '096 707 1238', 'kovacevickatja9@yahoo.com'),
('Marko Levat', STR_TO_DATE('14.09.1977.', '%d.%m.%Y.'), '23324554678', 'muški', 'Stipetićeva 63', '095 505 5053', 'marko77levat@gmail.com'),
('Nina Zorić', STR_TO_DATE('01.03.2004.', '%d.%m.%Y.'), '99999199999', 'ženski', 'Perkovićeva 2b', '098 198 4007', 'zoricnina@gmail.com'),
('Goran Vuković', STR_TO_DATE('25.12.1979.', '%d.%m.%Y.'), '54555555545', 'muški', 'Vincetićeva 81a', '092 007 1984', 'goranvukovic@gmail.com'),
('Ivana Čupić', STR_TO_DATE('26.5.1969.', '%d.%m.%Y.'), '37373711211', 'ženski', 'Paulsova 1', '091 230 0040', 'ivanacupic@net.hr'),
('Damian Otis', STR_TO_DATE('10.02.2001.', '%d.%m.%Y.'), '98989877655', 'muški', 'Voćarska cesta 103', '093 343 6000', 'damianotis88@gmail.com'),
('Marina Lovren', STR_TO_DATE('09.09.1999.', '%d.%m.%Y.'), '87898765678', 'ženski', 'Šime Budinića 51', '091 285 7437', 'marinalovren@gmail.com'),
('Fabijan Vilitić', STR_TO_DATE('05.05.1985.', '%d.%m.%Y.'), '59382565411', 'muški', 'Krešimirova 15b', '098 333 1334', 'fabijan4vilitic@gmail.com');

-- Tablica Zaposlenik(7)
INSERT INTO Zaposlenik(datum_zaposlenja, datum_izlaska_iz_sluzbe, id_nadređeni, id_radno_mjesto, id_odjel, id_zgrada, id_osoba) VALUES
-- voditelji policijskih postaja
(STR_TO_DATE('21.11.1995.', '%d.%m.%Y.'), NULL, NULL, 5, 1, 1, 4),
(STR_TO_DATE('05.10.2000.', '%d.%m.%Y.'), NULL, NULL, 5, 1, 36, 12),
(STR_TO_DATE('18.09.1999.', '%d.%m.%Y.'), NULL, NULL, 5, 1, 4, 16),
-- voditelj zatvora, voditelj pritvora
(STR_TO_DATE('17.06.2005.', '%d.%m.%Y.'), NULL, NULL, 8, NULL, 43, 14),
(STR_TO_DATE('21.07.2000.', '%d.%m.%Y.'), NULL, NULL, 7, NULL, 37, 15),
-- zaposlenici policijskih postaja
(STR_TO_DATE('10.01.2009.', '%d.%m.%Y.'), NULL, 1, 4, 3, 1, 1), 
(STR_TO_DATE('25.03.2012.', '%d.%m.%Y.'), NULL, 1, 3, 7, 1, 2),
(STR_TO_DATE('15.08.1988.', '%d.%m.%Y.'), STR_TO_DATE('05.05.2005.', '%d.%m.%Y.'), NULL, NULL, NULL, NULL, 3),
(STR_TO_DATE('17.02.2004.', '%d.%m.%Y.'), NULL, 2, 4, 3, 36, 5),
(STR_TO_DATE('12.12.2010.', '%d.%m.%Y.'), NULL, 9, 2, 3, 36, 6),
(STR_TO_DATE('22.02.2022.', '%d.%m.%Y.'), NULL, 2, 1, 2, 36, 7),
(STR_TO_DATE('28.04.2023.', '%d.%m.%Y.'), NULL, 3, 4, 9, 4, 8),
(STR_TO_DATE('05.05.1985.', '%d.%m.%Y.'), NULL, 3, 4, 7, 4, 9),
(STR_TO_DATE('10.11.1977.', '%d.%m.%Y.'), STR_TO_DATE('01.06.2022.', '%d.%m.%Y.'), NULL, NULL, NULL, NULL, 10),
(STR_TO_DATE('05.05.1985.', '%d.%m.%Y.'), NULL, 13, 2, 7, 4, 11),
(STR_TO_DATE('05.05.1985.', '%d.%m.%Y.'), NULL, 2, 3, 1, 36, 13),
(STR_TO_DATE('11.09.2001.', '%d.%m.%Y.'), STR_TO_DATE('27.07.2017.', '%d.%m.%Y.'), NULL, NULL, NULL, NULL, 17),
-- zaštitari u pritvorima ili zatvorima
(STR_TO_DATE('15.02.2023.', '%d.%m.%Y.'), NULL, 4, 6, NULL, 43, 18),
(STR_TO_DATE('21.07.2015.', '%d.%m.%Y.'), NULL, 5, 6, NULL, 37, 19),
(STR_TO_DATE('18.08.2021.', '%d.%m.%Y.'), NULL, 4, 6, NULL, 43, 20),
-- administrativni zaposlenici
(STR_TO_DATE('23.04.2002.', '%d.%m.%Y.'), NULL, 1, 8, NULL, 1, 21),
(STR_TO_DATE('05.05.1985.', '%d.%m.%Y.'), NULL, 2, 9, NULL, 36, 22),
(STR_TO_DATE('29.10.1990.', '%d.%m.%Y.'), STR_TO_DATE('15.09.2021.', '%d.%m.%Y.'), NULL, NULL, NULL, NULL, 23),
(STR_TO_DATE('05.07.1995.', '%d.%m.%Y.'), NULL, 1, 8, NULL, 1, 24),
(STR_TO_DATE('11.03.2000.', '%d.%m.%Y.'), NULL, 1, 9, NULL, 1, 25);

-- Tablica Vozilo(8)
INSERT INTO Vozilo(Marka, Model, Registracija, Godina_proizvodnje, Sluzbeno_vozilo, id_vlasnik) VALUES
('Audi', 'S4', 'RI-909-OP', 2021, True, 8),
('Audi', 'A2', 'PU-111-IS', 2019, False, 35),
('Audi', 'A1', 'ZG-203-PJ', 2018, True, 3),
('BMW', 'M1', 'ZG-356-AS', 2009, False, 39),
('BMW', 'E3', 'RI-1234-BF', 1999, False, 41),
('BMW', 'I3', 'ZG-2309-US', 2017, False, 38),
('Ford', 'Ka', 'SP-345-GA', 2013, True, 6),
('Ford', 'Fiesta', 'ZD-505-KU', 2001, True, 12),
('Ford', 'Focus', 'RI-8080-DF', 2008, True, 20),
('Ford', 'Ranger', 'PU-777-BD', 2018, True, 9), 
('Ford', 'Focus', 'KA-492-FH', 2011, True, 23),
('Renault', 'Laguna', 'PU-0090-UP', 2005, True, 2),
('Volkswagen', 'Golf 6', 'ZD-567-II', 2020, False, 33),
('Volkswagen', 'Golf 4', 'SP-999-GH', 2009, False, 44),
('Toyota', 'Camry', 'OG-1201-GO', 2012, True, 22),
('Toyota', 'Corolla', 'OG-4444-BR', 1998, False, 40),
('Toyota', 'Corolla', NULL, 1999, False, 42);

-- Tablica Predmet(9)
INSERT INTO Predmet(naziv, id_mjesto_pronalaska) VALUES
('Nož', '1'),
('Pištolj', '4'),
('Puška', '1'),
('Novac u vrijednosti od 5000 eura', '4'),
('Mač', '1'),

('Nož', '36'),
('Nož', '4'),
('Pištolj', '33'),
('Razbijena boca', '28'),
('Mobitel', '36'),

('Osobna iskaznica', '1'),
('Novčanik', '36'),
('Pištolj', '28'),
('Pištolj', '34'),
('Novac u vrijednosti od 10000 eura', '28');

-- Tablica Kaznjiva djela(10)
-- ovisno o ozbiljnosti slučaja kazne će biti različite, no zbog jednostavnosti smo odlučili da ćemo uzet prosječnu kaznu za ova djela
INSERT INTO Kaznjiva_djela(naziv, opis, predvidena_kazna, predvidena_novcana_kazna) VALUES
('Otmica', 'Protupravno i prisilno odvođenje ili zadržavanje osobe protiv njezine volje, obično s ciljem postizanja određenih zahtjeva ili ostvarivanja nekog cilja.', 5, NULL),
('Ucjena', 'Prijetnja ili nametanje nečega s ciljem prisile ili iznude određenih radnji, često uz zahtjev za novčanim ili drugim materijalnim koristima.', NULL, 2000.00),
('Krađa', 'Nezakonito prisvajanje tuđe imovine bez pristanka vlasnika, s namjerom trajnog oduzimanja.', NULL, 500.00),
('Provala', 'Nezakoniti ulazak u neki prostor ili objekt s namjerom počinjenja kaznenog djela, obično krađe ili uništavanja imovine.', NULL, 1000.00),
('Pljačka', 'Nasilno oduzimanje imovine ili stvari od osobe ili mjesta, često uz prijetnju ili upotrebu sile.', 0.5, NULL),

('Brza vožnja', 'Vožnja vozila brzinom koja prelazi dopuštene granice, često kršenje prometnih propisa.', NULL, 500.00),
('Vožnja pod utjecajem substanci', 'Vožnja vozila dok je osoba pod utjecajem alkohola, droga ili drugih psihoaktivnih tvari.', NULL, 750.00),
('Vožnja bez vozačke', 'Vožnja vozila bez valjane vozačke dozvole ili s isteklom dozvolom.', NULL, 750.00),
('Vandalzam', 'Namjerno uništavanje ili oštećenje tuđe imovine, često iz čistog besmisla ili bez razloga.', NULL, 200.00),
('Mito', 'Nezakonito davanje ili primanje novca ili drugih koristi kako bi se utjecalo na postupanje ili odluke osobe u javnom položaju.', NULL, 300.00),

('Ubojstvo', 'Ubojstvo je izuzetno ozbiljno kazneno djelo u kojem osoba namjerno uzrokuje smrt drugoj osobi.', 10, NULL),
('Ubojstvo iz nehata', 'Uzrok smrti druge osobe bez namjere ili predumišljaja, obično zbog nepažnje ili neopreznosti.', 5, NULL),
('Prijevara', 'Namjerno obmanjivanje ili zavaravanje drugih s ciljem stjecanja imovinske dobiti ili drugih koristi.', NULL, 250.00),
('Nasilje u obitelji', 'Fizičko, emocionalno ili ekonomsko zlostavljanje unutar obitelji.', 0.2, NULL),
('Zloupotreba droga', 'Nezakonito posjedovanje, proizvodnja, distribucija ili trgovina drogama.', NULL, 500.00),

('Pranje novca', 'Skrivanje porijekla ilegalno stečenih sredstava kako bi se prikazala kao zakonito stecana imovina.', 1, NULL),
('Napad', 'Namjerno nanošenje tjelesnih ozljeda ili prijetnja nanošenjem ozljeda drugoj osobi.', 0.5, NULL),
('Razbojništvo', 'Krađa koja uključuje prijetnju ili upotrebu sile kako bi se postigao cilj.', 0.5, NULL),
('Sablazan', 'Ponašanje koje je uvredljivo ili koje izaziva gađenje i protivi se društvenim normama.', NULL, 450.00),
('Nedozvoljeno posjedovanje oružja', 'Posjedovanje oružja bez potrebnih dozvola ili u suprotnosti s određenim uvjetima.', 0.5, NULL),

('Korupcija', 'Zloupotreba javne moći ili povlastica radi stjecanja osobne koristi ili koristi trećih strana.', 0.5, NULL),
('Nedozvoljeno snimanje ili prisluškivanje', 'Neovlašteno bilježenje razgovora ili prisluškivanje komunikacija bez pristanka svih uključenih strana.', NULL, 750.00); 
 
 -- Tablica Pas(11)(svaki cin osim voditelja moze biti trener)
 INSERT INTO Pas(id_trener, oznaka, godina_rođenja, status, id_kaznjivo_djelo) VALUES
(1, 'K9-123', 2022, 'aktivan', 1),
(2, 'K9-456', 2020, 'nije za teren', 1),
(5, 'K9-789', 2014, 'umirovljen', 1),
(6, 'K9-987', 2022, 'aktivan', 1),
(7, 'K9-654', 2021, 'aktivan', 15),
(8, 'K9-321', 2019, 'aktivan', 15),
(9, 'K9-111', 2022, 'aktivan', 15),
(11, 'K9-454', 2021, 'aktivan', 11),
(13, 'K9-999', 2016, 'umirovljen', 11);
 
 -- Tablica Slucaj(12)
 INSERT INTO Slucaj(naziv, opis, pocetak, zavrsetak, status, id_pocinitelj, id_izvjestitelj, id_voditelj, id_dokaz, ukupna_vrijednost_zapljena, id_pas, id_svjedok, id_ostecenik) VALUES
 ('Digitalno nasilje #1', 'Počinitelj je konstantno zlostavljao oštećenika preko mnogih socijalnih medija te prijetio da će počiniti fizičko nasilje nad oštećenikom i nad njegovom obitelji', STR_TO_DATE('12.09.2018.', '%d.%m.%Y.'), STR_TO_DATE('25.09.2018.', '%d.%m.%Y.'), 'riješen', 26, 27, 9, NULL, NULL, NULL, NULL, 27),
 ('Nestala osoba #1', 'Nestala osoba je prijavljena u ranim satima jutra, zabrinuta sestra je nazvala policiju nakon što nije čula od svog brata više od 24 sata', STR_TO_DATE('11.07.2020.', '%d.%m.%Y.'), STR_TO_DATE('13.07.2020.', '%d.%m.%Y.'), 'riješen', NULL, 49, 6, NULL, NULL, NULL, NULL, 50), 
 ('Vožnja pod utjecajem #1', 'Osoba je zaustavljena zbog sumnje vožnje pod utjecajem, pristala je puhati te je napuhala 1.2 na alkotestu', STR_TO_DATE('20.11.2019.', '%d.%m.%Y.'), STR_TO_DATE('20.11.2019.', '%d.%m.%Y.'), 'riješen', 40, NULL, 12, NULL, NULL, NULL, NULL, NULL),
 ('Ubojstvo i krađa #1', 'Osumnjičeni je otišao u banku te ubio radnika u njoj', STR_TO_DATE('29.08.2023.', '%d.%m.%Y.'), NULL, 'aktivan', 32, NULL, 9, 2, 10000, 7, 30, 31),
 ('Ubojstvo i krađa #2', 'Navodno je osoba ušla u trgovinu, ubila radika te uzela sve iz kase', STR_TO_DATE('06.07.2020.', '%d.%m.%Y.'), STR_TO_DATE('15.11.2023.', '%d.%m.%Y.'), 'arhiviran', NULL, 44, 12, NULL, NULL, NULL, 33, NULL),
 ('Nasilje u obitelj #1','Osoba je nazvala te priznala da ih osoba u obitelji fizički i psihički zlstavlja već duže vrijeme', STR_TO_DATE('09.02.2022.', '%d.%m.%Y.'), NULL, 'aktivan', 47, 46, 12, 7, NULL, NULL, 45, 46),
 ('Provala #1', 'Osoba je nazvala u kasnim satima noći nakon što je ušla u stan te je primjetila da joj je puno osobnih predmeta nestalo', STR_TO_DATE('12.03.2020.', '%d.%m.%Y.'), STR_TO_DATE('17.03.2020.', '%d.%m.%Y.'), 'riješen', 32, 33, 9, 10, NULL, NULL, NULL, 33);
 
 -- Tablica evidencija događaja(13)
 INSERT INTO Evidencija_dogadaja(id_slucaj, opis_dogadaja, datum_vrijeme, id_mjesto) VALUES
(1, 'Ispitana je osoba koja je optužena, priznala je svim optužbama', STR_TO_DATE('17.09.2018 13:00:00', '%d.%m.%Y %H:%i:%s'), 36),
(2, 'Poziv kojim se prijavila nestala osoba', STR_TO_DATE('11.07.2020 08:00:00', '%d.%m.%Y %H:%i:%s'), 4),
(2, 'Pronađena nestala osoba', STR_TO_DATE('13.07.2020 16:30:00', '%d.%m.%Y %H:%i:%s'), 25),
(3, 'Zaustavljen je auto zbog sumnje da je vozač pod utjecajem alkohola', STR_TO_DATE('20.11.2019 23:00:00', '%d.%m.%Y %H:%i:%s'), 4),
(4, 'Ovlaštena osoba je došla na scenu te ispitala ostale radnike u poslovnom objektu', STR_TO_DATE('29.08.2023 09:00:00', '%d.%m.%Y %H:%i:%s'), 5),
(4, 'Prikupljeni su svi dokazi', STR_TO_DATE('31.08.2023 16:30:00', '%d.%m.%Y %H:%i:%s'), 5),
(5, 'Uzeti su svi potencijalni dokazi za daljne testiranje', STR_TO_DATE('06.07.2020 21:00:00', '%d.%m.%Y %H:%i:%s'), 4),
(6, 'Ispitana je osoba koja je prijavila zlostavljanje', STR_TO_DATE('10.02.2022 14:30:00', '%d.%m.%Y %H:%i:%s'), 36),
(6, 'Ispitana je osoba koja je optužena sa zlostavljanjem', STR_TO_DATE('10.02.2022 15:00:00', '%d.%m.%Y %H:%i:%s'), 36),
(7, 'Ovlaštena osoba je došla u stan i prikupila dokaze i izvještaj osobe', STR_TO_DATE('12.03.2020 20:00:00', '%d.%m.%Y %H:%i:%s'), 2);
 
 -- Tablica kažnjva djela u slucaju(14)
 
 INSERT INTO Kaznjiva_djela_u_slucaju(id_mjesto, id_slucaj, id_kaznjivo_djelo) VALUES
 (36, 1, 3),
 (36, 1, 19),
 (1, 3, 6),
 (1, 3, 7),
 (5, 4, 5),
 (5, 4, 11),
 (5, 4, 20),
 (3, 5, 5),
 (3, 5, 11),
 (2, 6, 2),
 (2, 6, 14),
 (36, 7, 4),
 (36, 7, 9);
 
 -- Tablica Izvjestaji(15)
 INSERT INTO Izvjestaji(naslov, sadrzaj, id_autor, id_slucaj) VALUES
 ('Izvještaj o digitalnom nasilju #1', 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.', 10, 1),
 ('Izvještaj o nestaloj osobi #1', 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.', 7, 2),
 ('Izvještaj o vožnji pod utjecajem #1', 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.', 13, 3),
 ('Izvještaj o ubojstvu i krađi #1', 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.', 10, 4),
 ('Izvještaj o ubojstvu i krađi #2', 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.', 13, 5),
 ('Izvještaj o nasilju u obitelji #1', 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.', 13, 6),
 ('Izvještaj o pljačci #1', 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.', 10, 7);
 
 -- Tablica Zapljene(16)
 INSERT INTO Zapljene(id_slucaj, id_predmet, vrijednost) VALUES
 (4, 2, 100.00),
 (4, 15, 10000.00),
 (6, 7, 15.00),
 (6, 9, 12.00);
 
 -- Tablica Sredstvo_utvrdivanja_istine(17)
INSERT INTO Sredstvo_utvrdivanja_istine(naziv) VALUES
('Poligraf'),
('alkotest'),
('urin_test'),
('krv_test'),
('ispitivanje');

-- Tablica sui_slucaj(18)
INSERT INTO Sui_slucaj(id_sui, id_slucaj) VALUES
(1, 4),
(5, 1),
(5, 2),
(2, 3),
(3, 3),
(4, 6);



# UPITI

 
-- 1) Ispiši prosječan broj godina osoba koje su prijavile digitalno nasilje. 


SELECT AVG(YEAR(S.pocetak)-YEAR(O.datum_rodenja)) AS prosjecan_broj_godina
FROM slucaj S INNER JOIN osoba O ON S.id_izvjestitelj=O.id
WHERE S.naziv LIKE '%digitalno nasilje%';

-- 2) Prikaži osobu čiji je nestanak posljednji prijavljen

SELECT O.*
FROM osoba O INNER JOIN slucaj S ON O.id=S.id_ostecenik
WHERE S.naziv LIKE '%nestala%'
ORDER BY S.pocetak DESC
LIMIT 1;

-- 3) Prikaži najčešću vrstu kažnjivog djela

SELECT KD.*
FROM kaznjiva_djela KD INNER JOIN kaznjiva_djela_u_slucaju KDS 
ON KDS.id_kaznjivo_djelo = KD.id
GROUP BY KD.id
ORDER BY COUNT(*)
LIMIT 1;


# 4) Ispišimo sve voditelje slučajeva i slučajeve koje vode
SELECT O.Ime_Prezime, S.Naziv AS 'Naziv slučaja'
FROM Zaposlenik Z
JOIN Osoba O ON Z.id_osoba = O.Id
JOIN Slucaj S ON Z.Id = S.id_voditelj;


# 5) Ispišimo slučajeve i evidencije za određenu osobu (osumnjičenika)
SELECT O.Ime_Prezime, S.Naziv AS 'Naziv slučaja', ED.opis_dogadaja, ED.datum_vrijeme, ED.id_mjesto
FROM Slucaj S
JOIN Evidencija_dogadaja ED ON S.Id = ED.id_slucaj
JOIN Osoba O ON O.Id = S.id_pocinitelj
WHERE O.Ime_Prezime = 'Ime Prezime';

# 6) Ispišimo sve osobe koje su osumnjičene za određeno KD
SELECT DISTINCT O.Ime_Prezime
FROM Osoba O
JOIN Slucaj S ON O.Id = S.id_pocinitelj
JOIN Kaznjiva_djela_u_slucaju	KDS ON S.Id = KDS.id_slucaj
JOIN Kaznjiva_djela	KD ON KDS.id_kaznjivo_djelo = KD.id
WHERE KD.Naziv = 'Naziv kaznjivog djela';

# 7) Pronađimo sve slučajeve koji sadrže KD i nisu riješeni
SELECT S.Naziv, KD.Naziv AS kaznjivo_djelo
FROM Slucaj S
INNER JOIN Kaznjiva_djela_u_slucaju KDS	ON S.id = KDS.id_slucaj
INNER JOIN Kaznjiva_djela KD ON 
KDS.id_kaznjivo_djelo= KD.id
WHERE S.Status = 'Aktivan';

# 8) Izračunajmo iznos zapljene za svaki pojedini slučaj
SELECT S.id, S.Naziv, SUM(ZA.Vrijednost) AS ukupna_vrijednost_zapljena
FROM Slucaj S
LEFT JOIN Zapljene ZA ON S.id = ZA.id_slucaj
GROUP BY S.id, S.Naziv;

# 9) Pronađi prosječnu vrijednost zapljene za pojedina kaznjivaa djela
SELECT KD.Naziv AS vrsta_kaznjivog_djela, AVG(ZA.Vrijednost) AS prosjecna_vrijednost_zapljene
FROM Kaznjiva_djela_u_slucaju KDS
JOIN Kaznjiva_djela KD ON KDS.id_kaznjivo_djelo= KD.Id
JOIN Zapljene ZA ON KDS.id_slucaj	= ZA.id_slucaj
GROUP BY KD.naziv;

# 10) Pronađi sve odjele i broj zaposlenika na njima
SELECT O.Naziv AS naziv_odjela, COUNT(Z.Id) AS broj_zaposelnika
FROM Zaposlenik Z
JOIN Odjeli O ON Z.id_odjel	 = O.Id
GROUP BY O.id, O.Naziv;

# 11) Pronađi ukupnu vrijednost zapljena po odjelu i sortiraj ih po vrijednosti silazno
SELECT Z.id_odjel, SUM(ZA.vrijednost) AS ukupna_vrijednost_zapljena
FROM Slucaj S
JOIN Zapljene ZA ON S.Id = ZA.id_slucaj
JOIN Zaposlenik Z ON S.id_voditelj= Z.Id
GROUP BY Z.id_odjel
ORDER BY ukupna_vrijednost_zapljena DESC;



# 12) Pronađi osobu koja mora odslužiti najveću ukupnu zatvorsku kaznu
SELECT O.Id, O.Ime_Prezime, SUM(KD.Predvidena_kazna) AS ukupna_kazna
FROM Osoba O
INNER JOIN Slucaj S ON O.Id = S.id_pocinitelj
INNER JOIN Kaznjiva_Djela_u_Slucaju KDS ON S.Id = KDS.id_slucaj
INNER JOIN Kaznjiva_Djela KD ON KDS.id_kaznjivo_djelo= KD.ID
WHERE KD.predvidena_kazna IS NOT NULL
GROUP BY O.id, O.ime_prezime
ORDER BY ukupna_kazna DESC
LIMIT 1;

# 13) Prikaži sva vozila i u koliko slučajeva su se oni upisali
SELECT V.*, COUNT(S.id) AS broj_slucajeva
FROM Vozilo V LEFT OUTER JOIN Osoba O ON V.id_vlasnik = O.id
INNER JOIN Slucaj S ON O.id = S.id_pocinitelj
GROUP BY V.id;

# 14) Mjesto s najviše slučajeva
SELECT M.*, COUNT(ED.id) AS broj_slucajeva
FROM Mjesto M INNER JOIN Evidencija_dogadaja ED ON  M.id = ED.id_mjesto
GROUP BY M.id 
ORDER BY broj_slucajeva DESC 
LIMIT 1;

# 15) Mjesto s najmanje slučajeva (praktički ista stvar kao ovo gore)
SELECT M.*, COUNT(ED.id) AS broj_slucajeva
FROM Mjesto M INNER JOIN Evidencija_dogadaja ED ON  M.id = ED.id_mjesto
GROUP BY M.id 
ORDER BY broj_slucajeva ASC 
LIMIT 1;

# 16) Pronađi policijskog službenika koji je vodio najviše slučajeva
SELECT
    Z.Id AS id_zaposlenika,
    O.Ime_Prezime AS ime_prezime_zaposlenika,
    COUNT(s.Id) AS broj_slucajeva
FROM Zaposlenik Z
JOIN Osoba O ON Z.id_osoba= O.Id
LEFT JOIN Slucaj S ON S.id_voditelj = Z.Id
GROUP BY Z.Id, O.Ime_Prezime
HAVING COUNT(S.Id) = (
    SELECT MAX(broj_slucajeva)
    FROM (
        SELECT COUNT(id) AS broj_slucajeva
        FROM Slucaj
        GROUP BY id_voditelj
    ) AS max_voditelj
);

# 17) Ispiši sva mjesta gdje nema evidentiranih kaznjivih djela u slučajevima(ili uopće nema slučajeva)
SELECT M.Id, M.Naziv
FROM Mjesto M
LEFT JOIN Evidencija_dogadaja ED ON M.Id = ED.id_mjesto
LEFT JOIN Slucaj S ON ED.id_slucaj= S.Id
LEFT JOIN Kaznjiva_Djela_u_Slucaju KDS ON S.Id = KDS.id_slucaj
WHERE KDS.id_slucaj IS NULL OR KDS.id_kaznjivo_djelo IS NULL
GROUP BY M.Id, M.Naziv;

#########################################################################################################################################
# POGLEDI
# 1) Ako je uz osumnjičenika povezano vozilo, onda se stvara pogled koji prati sve osumnjičenike i njihova vozila
CREATE VIEW osumnjicenici_vozila AS
SELECT
	O.id AS id_osobe,
	O.ime_prezime,
	O.datum_rodenja,
	O.oib,
	O.spol,
	O.adresa,
	O.telefon,
	O.email,
	V.id AS id_vozila,
	V.marka,
	V.model,
	V.registracija,
	V.godina_proizvodnje
FROM Osoba O
RIGHT JOIN Vozilo V ON O.id = V.id_vlasnik
INNER JOIN Slucaj S ON O.id = S.id_pocinitelj;

# 2) Pronađi sve policajce koji su vlasnici vozila koja su starija od 10 godina
CREATE VIEW policijski_sluzbenici_stara_vozila AS
SELECT O.Ime_Prezime AS Policajac, V.Marka, V.Model, V.Godina_proizvodnje
FROM Osoba O
JOIN Zaposlenik Z ON O.Id = Z.id_osoba
JOIN Vozilo V ON O.Id = V.id_vlasnik
WHERE Z.id_radno_mjesto= (SELECT Id FROM Radno_mjesto WHERE Vrsta = 'Policajac')
AND V.Godina_proizvodnje <= YEAR(NOW()) - 10;

# 3) Napravi pogled koji će pronaći sve osobe koje su počinile kazneno djelo pljačke i pri tome su koristili pištolj (to dohvati pomoću tablice predmet) i nazovi pogled "Počinitelji oružane pljačke"
CREATE VIEW pocinitelji_oruzane_pljacke AS
SELECT O.ime_prezime AS pocinitelj, KD.Naziv AS kazneno_djelo
FROM Osoba O
JOIN Slucaj S ON O.Id = S.id_pocinitelj
JOIN Kaznjiva_Djela_u_Slucaju KDS ON S.Id = KDS.id_slucaj
JOIN Kaznjiva_Djela KD ON KDS.id_kaznjivo_djelo	= KD.id
JOIN Predmet P ON S.id_dokaz= P.id
WHERE KD.Naziv = 'Pljačka' AND P.naziv LIKE '%pištolj%';


# 4)Napravi pogled koji će izlistati sva evidentirana kaznena djela i njihov postotak pojavljivanja u slučajevima
CREATE VIEW postotak_pojavljivanja_kaznjivih_djela AS
SELECT
    KD.Naziv AS 'kaznjivo_djelo',
    COUNT(KDS.id_slucaj) AS 'broj_slucajeva',
    COUNT(KDS.id_slucaj) / (SELECT COUNT(*) FROM Slucaj) * 100 AS 'postotak_pojavljivanja'
FROM
    Kaznjiva_Djela KD
LEFT JOIN
    Kaznjiva_Djela_u_Slucaju KDS
ON
    KD.ID = KDS.id_kaznjivo_djelo
GROUP BY
    KD.Naziv;

# 5) Napravi pogled koji će izlistati sva evidentirana sredstva utvrđivanja istine i broj slučajeva u kojima je svako od njih korišteno
CREATE VIEW evidentirana_sredstva_utvrdivanja_istine AS
SELECT SUI.Naziv AS 'sredstvo_utvrdivanja_istine',
       COUNT(SS.Id_sui) AS 'broj_slucajeva'
FROM Sredstvo_utvrdivanja_istine SUI
LEFT JOIN Sui_slucaj SS ON SUI.id = SS.Id_sui
GROUP BY SUI.id;


# 6) Napravi pogled koji će izlistati sve slučajeve i sredstva utvrđivanja istine u njima, te izračunati trajanje svakog od slučajeva

CREATE VIEW slucajevi_sortirani_po_trajanju_sredstva AS
SELECT S.*, 
       TIMESTAMPDIFF(DAY, S.Pocetak, S.Zavrsetak) AS trajanje_u_danima, 
       GROUP_CONCAT(SUI.Naziv ORDER BY SUI.Naziv ASC SEPARATOR ', ') AS sredstva_utvrdivanja_istine
FROM Slucaj S
LEFT JOIN Sui_slucaj SS ON S.ID = SS.Id_slucaj
LEFT JOIN Sredstvo_utvrdivanja_istine SUI ON SS.Id_sui = SUI.id
GROUP BY S.id
ORDER BY trajanje_u_danima DESC;

# 7) Napiši pogled koji će u jednu tablicu pohraniti sve izvještaje vezane uz pojedine slučajeve
CREATE VIEW izvjestaji_za_slucajeve AS
SELECT S.Naziv AS Slucaj, I.Naslov AS naslov_izvjestaja, I.Sadrzaj AS sadrzaj_izvjestaja, O.Ime_Prezime AS autor_izvjestaja
FROM Izvjestaji I
INNER JOIN Slucaj S ON I.id_slucaj	 = S.ID
INNER JOIN Osoba O ON I.id_autor	= O.Id;

# 8) Napravi pogled koji će izlistati sve osobe i njihove odjele. Ukoliko osoba nije policajac te nema odjel (odjel je NULL), neka se uz tu osobu napiše "Osoba nije policijski službenik"
CREATE VIEW osobe_odjeli AS
SELECT O.ime_prezime AS ime_osobe,
       CASE
           WHEN Z.id_radno_mjesto
           IS NOT NULL THEN OD.Naziv
           ELSE 'Osoba nije policijski službenik'
       END AS naziv_odjela
FROM Osoba O
LEFT JOIN Zaposlenik Z ON O.Id = Z.id_osoba
LEFT JOIN Odjeli OD ON Z.id_odjel= OD.Id;


# 9) Napravi pogled koji će ispisati sve voditelje slučajeva, ukupan broj slučajeva koje vode, ukupan broj rješenjih slučajeva, ukupan broj nerješenih slučajeva i postotak rješenosti
CREATE VIEW voditelji_slucajevi_pregled AS
SELECT
    O.ime_prezime AS voditelj,
    COUNT(S.ID) AS ukupan_broj_slucajeva,
    SUM(CASE WHEN S.Status = 'riješen' THEN 1 ELSE 0 END) AS ukupan_broj_rijesenih_slucajeva,
    SUM(CASE WHEN S.Status = 'aktivan' THEN 1 ELSE 0 END) AS ukupan_broj_nerijesenih_slucajeva,
    (SUM(CASE WHEN S.Status = 'riješen' THEN 1 ELSE 0 END) / COUNT(S.ID)) * 100 AS postotak_rjesenosti
FROM
    Osoba O
LEFT JOIN
    Slucaj S ON O.ID = S.id_voditelj
GROUP BY
    Voditelj;

# 10) Napravi POGLED koji će prikazivati statistiku zapljena za svaku vrstu kaznenog djela (prosjek, minimum, maksimum  (za vrijednosti) i broj predmeta)
CREATE VIEW StatistikaZapljenaPoKaznenomDjelu AS
SELECT
    KD.Naziv AS 'vrsta_kaznjivog_djela',
    AVG(Z.vrijednost) AS 'Prosječna_vrijednost_zapljena',
    MAX(Z.vrijednost) AS 'Najveća_vrijednost_zapljena',
    MIN(Z.vrijednost) AS 'Najmanja_vrijednost_zapljena',
    COUNT(Z.id) AS 'Broj_zapljenjenih_predmeta'
FROM Zapljene Z
JOIN Slucaj S ON Z.id_slucaj	 = S.ID
JOIN Kaznjiva_Djela_u_Slucaju KDS ON S.ID = KDS.id_slucaj
JOIN Kaznjiva_Djela KD ON KDS.id_kaznjivo_djelo = KD.id
GROUP BY KD.Naziv;


SELECT * From StatistikaZapljenaPoKaznenomDjelu;
-- DROP VIEW StatistikaZapljenaPoKaznenomDjelu;

# 11) Napravi POGLED koji će za svaki slučaj izračunati ukupnu zatvorsku kaznu, uz ograničenje da maksimalna zakonska zatvorska kazna u RH iznosi 50 godina. Ako ukupna kazna premaši 50, postaviti će se na 50 uz odgovarajuće upozorenje
CREATE VIEW ukupna_predvidena_kazna_po_slucaju AS
SELECT S.ID AS 'slucaj_id',
       S.Naziv AS 'naziv_slucaja',
       CASE
           WHEN SUM(KD.predvidena_kazna) > 50 THEN 50
           ELSE SUM(KD.predvidena_kazna)
       END AS 'ukupna_predvidena_kazna',
       CASE
           WHEN SUM(KD.Predvidena_kazna) > 50 THEN 'Maksimalna zakonska zatvorska kazna iznosi 50 godina'
           ELSE NULL
       END AS 'Napomena'
FROM Slucaj S
LEFT JOIN Kaznjiva_djela_u_slucaju KDS ON S.ID = KDS.id_slucaj
LEFT JOIN Kaznjiva_djela KD ON KDS.id_kaznjivo_djelo		= KD.ID
GROUP BY S.id, S.naziv;

# 12)Napiši POGLED koji će za sve policijske službenike dohvatiti njihovu dob i godine staža (ukoliko je još aktivan, oduzimat ćemo od trenutne godine godinu zaposlenja, a ako je umirovljen, oduzimat će od godine umirovljenja godinu zaposlenja)
# Onda dodat još stupac koji prati dali je umirovljen ili aktivan
CREATE VIEW pogled_policijskih_sluzbenika AS
SELECT
    O.Id AS zaposlenik_id,
    O.Ime_Prezime AS ime_prezime_osobe,
    O.datum_rodenja AS datum_rodenja_osobe,
    DATEDIFF(CURRENT_DATE, Z.Datum_zaposlenja) AS Godine_Staza,
    CASE
        WHEN Z.datum_izlaska_iz_sluzbe IS NOT NULL AND Z.Datum_izlaska_iz_sluzbe <= CURRENT_DATE THEN 'Da'
        ELSE 'Ne'
    END AS Umirovljen
FROM Osoba O
INNER JOIN Zaposlenik Z ON O.Id = Z.id_osoba;

# 13) Napravi pogled koji će dohvaćati sve osumnjičenike, zajedno s kažnjivim djelima za koja su osumnjičeni
CREATE VIEW pogled_osumnjicene_osobe_ AS
SELECT DISTINCT O.Ime_Prezime, KD.Naziv AS 'naziv_kaznjivog_djela'
FROM Osoba O
JOIN Slucaj S ON O.Id = S.id_pocinitelj
JOIN Kaznjiva_djela_u_slucaju KDS ON S.Id = KDS.id_slucaj
JOIN Kaznjiva_djela KD ON KDS.id_kaznjivo_djelo = KD.id;

# 14) Napravi pogled koji će izlistati sve pse i broj slučajeva na kojima je svaki od njih radio. U poseban stupac dodaj broj riješenih slučajeva od onih na kojima su radili. Zatim izračunaj postotak rješenosti slučajeva za svakog psa i to dodaj u novi stupac
CREATE VIEW pregled_pasa AS
SELECT
    PA.Id AS pas_id,
    PA.Oznaka AS OznakaPsa,
    O.Ime_Prezime AS Vlasnik,
    COUNT(S.Id) AS broj_slucajeva,
    SUM(CASE WHEN S.Status = 'Riješen' THEN 1 ELSE 0 END) AS broj_rijesenih,
    (SUM(CASE WHEN S.Status = 'Riješen' THEN 1 ELSE 0 END) / COUNT(S.Id) * 100) AS postotak_rijesenosti
FROM
    Pas AS PA
LEFT JOIN Slucaj AS S ON PA.Id = S.id_pas
LEFT JOIN Osoba AS O ON PA.Id_trener = O.Id
GROUP BY
    PA.Id;

# 15) Nadogradi prethodni POGLED tako da pronalazi najefikasnijeg psa, s najvećim postotkom rješenosti
CREATE VIEW najefikasniji_pas AS
SELECT
    pas_id,
    OznakaPsa,
    vlasnik,
    broj_slucajeva,
    broj_rijesenih,
    postotak_rijesenosti
FROM
    pregled_pasa
WHERE
    postotak_rijesenosti = (SELECT MAX(postotak_rijesenosti) FROM pregled_pasa);

-- 16) Napravi pogled koji prikazuje broj kazni zboog brze vožnje u svakom gradu u proteklih mjesec dana. Zatim pomoću upita ispiši grad
-- u kojem je bilo najviše kazni zbog brze vožnje u proteklih mjesec dana.

CREATE VIEW brza_voznja_gradovi AS
SELECT M.naziv, COUNT(*) AS broj_kazni_za_brzu_voznju
FROM mjesto M INNER JOIN Evidencija_dogadaja ED ON M.id=ED.id_mjesto INNER JOIN slucaj S ON ED.id_slucaj=S.id
WHERE S.naziv LIKE '%brza voznja%' AND ED.datum_vrijeme >= (NOW() - INTERVAL 1 MONTH)
GROUP BY M.naziv;

SELECT *
FROM brza_voznja_gradovi
ORDER BY broj_kazni_za_brzu_voznju DESC
LIMIT 1; 

-- 17) Napravi pogled koji prikazuje sve osobe koje su skrivile više od 2 prometne nesreće u posljednjih godinu dana. 
-- Zatim napravi upit koji će prikazati osobu koja je skrivila najviše prometnih nesreća u posljednjih godinu dana.

CREATE VIEW osoba_prometna_nesreca AS
SELECT O.*, COUNT(*) AS broj_prometnih_nesreca
FROM osoba O
INNER JOIN slucaj S ON O.id = S.id_pocinitelj
INNER JOIN evidencija_dogadaja ED ON S.id = ED.id_slucaj
WHERE ED.datum_vrijeme >= (NOW() - INTERVAL 1 YEAR) AND S.naziv LIKE '%prometna nesreca%'
GROUP BY O.id
HAVING broj_prometnih_nesreca > 2;


SELECT *
FROM osoba_prometna_nesreca
ORDER BY broj_prometnih_nesreca DESC
LIMIT 1;


# 18) Napravi pogled koji će pronaći sva kažnjiva djela koja su se događala u slučajevima
# Zatim napravi upit kojim ćemo moći pronalaziti kažnjiva djela za određeno mjesto po id-ju
CREATE VIEW kaznjiva_djela_na_mjestu AS
SELECT ED.id_mjesto, KD.Naziv, KD.Opis
FROM Kaznjiva_djela_u_slucaju KDS
JOIN Kaznjiva_Djela KD ON KDS.id_kaznjivo_djelo = KD.ID
JOIN Evidencija_Dogadaja ED ON KDS.id_slucaj = ED.id_slucaj;

SELECT * FROM Kaznjiva_Djela_Na_Mjestu WHERE id_mjesto = 1;


# 19) Napravi pogled koji će dohvatiti sve osobe, slučajeve koje su počinili i KD u njima
CREATE VIEW osobe_kaznjiva_djela AS
SELECT DISTINCT O.Ime_Prezime, KD.Naziv, S.id, S.opis AS id_slucaj
FROM Osoba O
JOIN Slucaj S ON O.Id = S.id_pocinitelj
JOIN Kaznjiva_djela_u_slucaju KDS ON S.Id = KDS.id_slucaj
JOIN Kaznjiva_djela KD ON KDS.id_kaznjivo_djelo = KD.id;



# 20) Napravi pogled koji će ispisati sve slučajeve i evidentirane događaje za osobe.
# Podaci će se zatim moći filtrirati (npr. po imenu i prezimenu)
# Ispišimo slučajeve i evidencije za određenu osobu (osumnjičenika)

CREATE VIEW slucajevi_dogadaji_osoba AS
SELECT S.Naziv AS 'Naziv slučaja', ED.opis_dogadaja, ED.datum_vrijeme, ED.id_mjesto, O.Ime_Prezime
FROM Slucaj S
JOIN Evidencija_dogadaja ED ON S.Id = ED.id_slucaj
JOIN Osoba O ON O.Id = S.id_pocinitelj;



#21) Napravi pogled koji će dohvaćati sve događaje koji su vezani za slučajeve koji sadrže određeno kažnjivo djelo
CREATE VIEW Dogadaji_Kaznjiva_Djela AS
SELECT ED.Opis_Dogadaja, ED.Datum_Vrijeme, KD.Naziv AS 'Naziv kaznjivog djela'
FROM Evidencija_Dogadaja ED
JOIN Slucaj S ON ED.id_slucaj = S.Id
JOIN Kaznjiva_Djela_u_Slucaju KDS ON S.Id = KDS.id_slucaj
JOIN Kaznjiva_Djela KD ON KDS.id_kaznjivo_djelo = KD.Id;

# 22) Napravi pogled koji će dohvaćati sve slučajeve u posljednjih N dna (stavljeno je 10000)
CREATE VIEW Slucajevi_u_posljednjih_n_dana AS
SELECT 
    S.ID AS id_slucaj,
    S.Naziv AS Naziv_slucaja,
    S.Status,
    S.id_voditelj,
    O.ime_prezime AS ime_i_prezime_voditelja
FROM 
    Slucaj S
JOIN 
    Zaposlenik Z ON S.id_voditelj = Z.id
JOIN 
    Osoba O ON O.id = Z.id_osoba
WHERE 
    S.Pocetak BETWEEN CURDATE() - INTERVAL 10000 DAY AND CURDATE(); # OVAJ INTERVAL MIJENJAMO PREMA POTREBI
##############################################################################################################################################
# 23) Napiši pogled koja će dohvaćati slučajeve koji sadrže određeno kazneno djelo i sortirati ih po vrijednosti zapljene silazno
CREATE VIEW Slucajevi_po_kaznjivom_djelu AS
SELECT
    Slucaj.id AS SlucajID,
    Slucaj.naziv AS NazivSlucaja,
    ukupna_vrijednost_zapljena AS UkupneZapljene
FROM
    Slucaj
JOIN
    Kaznjiva_djela_u_slucaju ON Slucaj.id = Kaznjiva_djela_u_slucaju.id_slucaj
JOIN
    Kaznjiva_djela ON Kaznjiva_djela_u_slucaju.id_kaznjivo_djelo = Kaznjiva_djela.id
LEFT JOIN
    Zapljene ON Slucaj.id = Zapljene.id_slucaj
GROUP BY
    Slucaj.id, Slucaj.naziv
ORDER BY
    UkupneZapljene DESC;


-- DROP VIEW Slucajevi_po_kaznjivom_djelu;
SELECT * FROM Slucajevi_po_kaznjivom_djelu WHERE NazivSlucaja LIKE('%krađa%');
SELECT * FROM Slucaj WHERE Naziv LIKE('%krađa%');
select * from zapljene WHERE id_slucaj  = 4;
# 24) Napiši pogled koja će ispisati sve slučajeve i za svaki slučaj ispisati voditelja i ukupan iznos zapljena. Ako nema pronađenih slučajeva, neka nas obavijesti o tome
# Pretvoreno u pogled
CREATE VIEW Podaci_o_slucajevima_zapljenama AS

SELECT
    Slucaj.id AS Slucaj_ID,
    Osoba.ime_prezime AS Voditelj_ime_prezime,
    COALESCE(SUM(Zapljene.Vrijednost), 0) AS Ukupan_iznos_zapljena
FROM
    Slucaj
JOIN
    Zaposlenik ON Slucaj.id_voditelj = Zaposlenik.id
JOIN
    Osoba ON Zaposlenik.id_osoba = Osoba.id
LEFT JOIN
    Zapljene ON Slucaj.id = Zapljene.id_slucaj
GROUP BY
    Slucaj.id, Osoba.ime_prezime;

SELECT * FROM Podaci_o_slucajevima_zapljenama;

-- DROP VIEW Slucajevi_u_posljednjih_n_dana;
SELECT * FROM Slucajevi_u_posljednjih_n_dana;
SELECT * FROM slucaj;

# TRIGERI
#TRIGERI
# 20 Trigera
# 1) Napiši triger koji će onemogućiti da za slučaj koji u sebi ima određena kaznena djela koristimo psa koji nije zadužen za ta ista djela u slučaju
DELIMITER //

CREATE TRIGGER bi_pas_slucaj_KD
BEFORE INSERT ON kaznjiva_djela_u_slucaju
FOR EACH ROW
BEGIN
    DECLARE id_kaznjivo_djelo_psa INT;

    SELECT id_kaznjivo_djelo INTO id_kaznjivo_djelo_psa
    FROM Pas
    WHERE id = (SELECT id_pas FROM slucaj WHERE id = NEW.id_slucaj);

    IF id_kaznjivo_djelo_psa IS NULL OR id_kaznjivo_djelo_psa != NEW.id_kaznjivo_djelo THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Pas nije zadužen za kaznjiva djela u ovom slučaju.';
    END IF;
END;

//
DELIMITER ;

# 2) Iako postoji opcija kaskadnog brisanja u SQL-u, ovdje ćemo u nekim slučajevima pomoću trigera htijeti zabraniti brisanje, pošto je važno da neki podaci ostanu zabilježeni. U iznimnim slučajevima možemo ostavljati obavijest da je neka vrijednost obrisana iz baze. Također, u većini slučajeva nam opcija kaskadnog brisanja nikako ne bi odgovarala, zato što je u radu policije važna kontinuirana evidencija
# Napiši triger koji će a) ako u području uprave više od 5 mjesta, zabraniti brisanje uz obavijest: "Područje uprave s više od 5 mjesta ne smije biti obrisano" b) ako u području uprave ima manje od 5 mjesta, dopustiti da se područje uprave obriše, ali će se onda u mjestima koja referenciraju to područje uprave, pojaviti obavijest "Prvotno područje uprave je obrisano, povežite mjesto s novim područjem"
DELIMITER //
CREATE TRIGGER bd_podrucje_uprave
BEFORE DELETE ON Podrucje_uprave
FOR EACH ROW
BEGIN
    DECLARE count_mjesta INT;
    SELECT COUNT(*) INTO count_mjesta FROM Mjesto WHERE id_podrucje_uprave = OLD.id;
    
    IF count_mjesta > 5 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Područje uprave s više od 5 mjesta ne smije biti obrisano.';
    ELSE
        UPDATE Mjesto
        SET id_podrucje_uprave = NULL
        WHERE id_podrucje_uprave = OLD.id;
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Prvotno područje uprave je obrisano, povežite mjesto s novim područjem.';
    END IF;
END;
//
DELIMITER ;

# 3) Napiši triger koji će a) spriječiti brisanje osobe ako je ona zaposlenik koji je još u službi (datum izlaska iz službe nije null) uz obavijest:
# "osoba koju pokušavate obrisati je zaposlenik, prvo ju obrišite iz tablice zaposlenika)" b) obrisati osobu i iz tablice zaposlenika i iz tablice osoba, 
# ukoliko datum_izlaska_iz_službe ima neku vrijednost što ukazuje da osoba više nije zaposlena
DELIMITER //
CREATE TRIGGER bd_osoba
BEFORE DELETE ON Osoba
FOR EACH ROW
BEGIN
    DECLARE is_zaposlenik BOOLEAN;
    SET is_zaposlenik = EXISTS (SELECT 1 FROM Zaposlenik WHERE id_osoba = OLD.id AND datum_izlaska_iz_sluzbe IS NULL);

    IF is_zaposlenik = TRUE THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Osoba koju pokušavate obrisati je zaposlenik, prvo ju obrišite iz tablice Zaposlenik.';
    ELSE
        IF EXISTS (SELECT 1 FROM Zaposlenik WHERE id_osoba = OLD.id) THEN
            DELETE FROM Zaposlenik WHERE id_osoba = OLD.id;
        END IF;
    END IF;
END;
//
DELIMITER ;


# 4) Napiši triger koji će, u slučaju da se kažnjivo djelo obriše iz baze, postaviti id_kaznjivo_djelo kod psa na NULL, ukoliko je on prije bio zadužen za upravo to KD koje smo obrisali
DELIMITER //
CREATE TRIGGER ad_pas
AFTER DELETE ON Kaznjiva_djela
FOR EACH ROW
BEGIN
    UPDATE Pas
    SET id_kaznjivo_djelo = NULL
    WHERE id_kaznjivo_djelo = OLD.id;
END;
//
DELIMITER ;

# 5) Napiši triger koji će zabraniti da iz tablice obrišemo predmete koji služe kao dokazi u aktivnim slučajevima (status im nije završeno, te se ne nalaza u arhivi) uz obavijest "Ne možete obrisati dokaze za aktivan slučaj"
DELIMITER //
CREATE TRIGGER bd_dokaz
BEFORE DELETE ON Predmet
FOR EACH ROW
BEGIN
    DECLARE aktivan INT;
    SELECT COUNT(*) INTO aktivan FROM Slucaj WHERE id_dokaz = OLD.id AND status != 'Završeno';
    
    IF aktivan > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Ne možete obrisati dokaze za aktivni slučaj.';
    END IF;
END;
//
DELIMITER ;

# 6) Napiši triger koji će zabraniti da iz tablice obrišemo osobe koje su evidentirani kao počinitelji u aktivnim slučajevima
DELIMITER //
CREATE TRIGGER bd_osoba_2
BEFORE DELETE ON Osoba
FOR EACH ROW
BEGIN
    DECLARE je_pocinitelj INT;
    SELECT COUNT(*) INTO je_pocinitelj FROM Slucaj WHERE id_pocinitelj = OLD.id AND status != 'Završeno';
    
    IF je_pocinitelj > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Ne možete obrisati osobu koja je evidentirana kao počinitelj.';
    END IF;
END;
//
DELIMITER ;

# 7) Napiši triger koji će zabraniti brisanje bilo kojeg izvještaja kreiranog za slučajeve koji nisu završeni (završetak je NULL), ili im je završetak "noviji" od 10 godina (ne smijemo brisati izvještaje za aktivne slučajeve, i za slučajeve koji su završili pred manje od 10 godina)
DELIMITER //
CREATE TRIGGER bd_izvjestaj
BEFORE DELETE ON Izvjestaji
FOR EACH ROW
BEGIN
    DECLARE slucaj_zavrsen DATETIME;
    SELECT zavrsetak INTO slucaj_zavrsen FROM Slucaj WHERE id = OLD.id_slucaj;
    
    IF slucaj_zavrsen IS NULL OR slucaj_zavrsen > DATE_SUB(NOW(), INTERVAL 10 YEAR) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Ne možete obrisati izvještaj za aktivan slučaj ili za slučaj koji je završio unutar posljednjih 10 godina.';
    END IF;
END;
//
DELIMITER ;

# 8)Triger koji osigurava da pri unosu spola osobe možemo staviti samo muški ili ženski spol
DELIMITER //
CREATE TRIGGER bi_osoba
BEFORE INSERT ON Osoba
FOR EACH ROW
BEGIN
    DECLARE validan_spol BOOLEAN;

    SET NEW.Spol = LOWER(NEW.Spol);

    IF NEW.Spol IN ('muski', 'zenski', 'muški', 'ženski', 'm', 'ž', 'muški', 'ženski', 'muski', 'zenski') THEN
        SET validan_spol = TRUE;
    ELSE
        SET validan_spol = FALSE;
    END IF;

    IF NOT validan_spol THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Spol nije valjan. Ispravni formati su: muski, zenski, m, ž, muški, ženski.';
    END IF;
END;
//
DELIMITER ;

# 9)Triger koji kreira stupac Ukupna_vrijednost_zapljena u tablici slučaj i ažurira ga nakon svake nove unesene zapljene u tom slučaju
DELIMITER //

CREATE TRIGGER ai_zapljena
AFTER INSERT ON Zapljene
FOR EACH ROW
BEGIN
    DECLARE ukupno DECIMAL(10, 2);
    
    SELECT SUM(Z.vrijednost) INTO ukupno
    FROM Zapljene Z
    WHERE Z.id_slucaj = NEW.id_slucaj;

    UPDATE Slucaj
    SET ukupna_vrijednost_zapljena = ukupno
    WHERE id = NEW.id_slucaj;
END;

//
DELIMITER ;


# 10)Triger koji premješta završene slučajeve iz tablice slučaj u tablicu arhiva # PRETVORENO JE U PROCEDURU JER JE TO JAKO VAŽAN DIO POLICIJSKOG RADA I NE ŽELIMO DA SE ODRAĐUJE AUTOMATSKI
# Privremeno uklonimo vanjske ključeve

CREATE TABLE Arhiva
(id_slucaj INT, FOREIGN KEY (id_slucaj) REFERENCES Slucaj(id));

ALTER TABLE Arhiva DROP FOREIGN KEY arhiva_ibfk_1;

DELIMITER //

CREATE PROCEDURE Oznaci_Slucaj_Arhiva(IN p_slucaj_id INT)
BEGIN
    DECLARE slucaj_status VARCHAR(20);

    SELECT status INTO slucaj_status
    FROM Slucaj
    WHERE id = p_slucaj_id;

    IF slucaj_status IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Slučaj s navedenim ID-om ne postoji.';
    ELSEIF slucaj_status <> 'riješen' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Slučaj nije riješen i ne može biti premješten u arhivu.';
    ELSE
        # Premjesti slučaj iz Slucaj u Arhiva i obrišemo ga iz slucaj
        INSERT INTO Arhiva (id_slucaj) VALUES (slucaj_id);
        DELETE FROM Slucaj WHERE id = slucaj_id;
    END IF;
END;

//

DELIMITER ;

# 11)Provjera da osoba nije nadređena sama sebi
DELIMITER //
CREATE TRIGGER bi_zaposlenik
BEFORE INSERT ON Zaposlenik
FOR EACH ROW
BEGIN
    IF NEW.id_nadređeni IS NOT NULL AND NEW.id_nadređeni = NEW.Id THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Nadređeni ne može biti ista osoba kao i podređeni.';
    END IF;
END;
//
DELIMITER ;

# 12)Provjera da su datum početka i završetka slučaja različiti i da je datum završetka "veći" od datuma početka
DELIMITER //

CREATE TRIGGER bi_slucaj
BEFORE INSERT ON Slucaj
FOR EACH ROW
BEGIN
    IF NEW.Pocetak >= NEW.Zavrsetak THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Datum završetka slučaja mora biti veći od datuma početka.';
    END IF;
END;
//
DELIMITER ;

# 13) Ako postavimo psu drugu godinu rođenja i preko nje ispada da je stariji od 10 godina, onda ga časno umirovimo
DELIMITER //

CREATE TRIGGER bu_pas
BEFORE UPDATE ON Pas
FOR EACH ROW
BEGIN
    DECLARE nova_dob INTEGER;
    SET nova_dob = YEAR(NOW()) - NEW.godina_rođenja;
    IF nova_dob >= 10 AND OLD.godina_rođenja <> NEW.godina_rođenja THEN
        SET NEW.status = 'Časno umirovljen';
    END IF;
END;
//
DELIMITER ;

# 14) Napravi triger koji će, u slučaju da je pas časno umirovljen koristeći triger (ili ručno), onemogućiti da ga koristimo u novim slučajevima
DELIMITER //
CREATE TRIGGER bi_slucaj_pas
BEFORE INSERT ON Slucaj
FOR EACH ROW
BEGIN
    DECLARE Pas_Status VARCHAR(255);
    SELECT Status INTO Pas_Status FROM Pas WHERE Id = NEW.id_pas;
    
    IF Pas_Status = 'Časno umirovljen' OR Pas_Status = 'Umirovljen' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Pas kojeg pokušavate koristiti na slučaju je umirovljen, odaberite drugog.';
    END IF;
END;
//
DELIMITER ;

# 15) Napiši triger koji će, u slučaju da je osoba mlađa od 18 godina (godina današnjeg datuma - godina rođenja daju broj manji od 18), pri dodavanju te osobe u slučaj dodati poseban stupac s napomenom: Počinitelj je maloljetan - slučaj nije otvoren za javnost
ALTER TABLE Slucaj
ADD COLUMN Napomena VARCHAR(255);

DELIMITER //

CREATE TRIGGER bi_slucaj_maloljetni_pocinitelj
BEFORE INSERT ON Slucaj
FOR EACH ROW
BEGIN
    DECLARE datum_rodjenja DATE;
    DECLARE godina_danas INT;
    DECLARE godina_rodjenja INT;
    
    SELECT Osoba.Datum_rodenja INTO datum_rodjenja
    FROM Osoba
    WHERE Osoba.Id = NEW.id_pocinitelj;
    
    SET godina_danas = YEAR(NOW());
    
    SET godina_rodjenja = YEAR(datum_rodjenja);
    
    IF (godina_danas - godina_rodjenja) < 18 THEN
        SET NEW.Napomena = 'Počinitelj je maloljetan - slučaj nije otvoren za javnost';
    ELSE
        SET NEW.Napomena = 'Počinitelj je punoljetan - javnost smije prisustvovati slučaju';
    END IF;
END //

DELIMITER ;

# 16)Napravi triger koji će onemogućiti da maloljetnik bude vlasnik vozila
DELIMITER //
CREATE TRIGGER bi_vozilo_punoljetnost
BEFORE INSERT ON Vozilo FOR EACH ROW
BEGIN
    DECLARE vlasnik_godine INT;
    SELECT TIMESTAMPDIFF(YEAR, (SELECT Datum_rodenja FROM Osoba WHERE Id = NEW.id_vlasnik), CURDATE()) INTO vlasnik_godine;

    IF vlasnik_godine < 18 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Vlasnik vozila je maloljetan i ne može posjedovati vozilo!';
    END IF;
END;
//
DELIMITER ;


# 17) Napravi triger koji će u slučaju da postavljamo status slučaja na završeno, postaviti datum završetka na današnji ako mi eksplicitno ne navedemo neki drugi datum, ali će dozvoliti da ga izmjenimo ako želimo
DELIMITER //

CREATE TRIGGER bu_slucaj
BEFORE UPDATE ON Slucaj
FOR EACH ROW
BEGIN
    IF NEW.Status = 'Riješen' AND OLD.Status != 'Riješen' AND NEW.Zavrsetak IS NULL THEN
        SET NEW.Zavrsetak = CURRENT_DATE();
    END IF;
END;
//
DELIMITER ;


# 18) Triger koji će prije unosa provjeravati jesu li u slučaju počinitelj i svjedok različite osobe. 

DELIMITER //
CREATE TRIGGER bi_slucaj_ps
BEFORE INSERT ON slucaj
FOR EACH ROW
BEGIN

IF new.id_pocinitelj=new.id_svjedok
THEN SIGNAL SQLSTATE '40000'
SET MESSAGE_TEXT = 'Počitelj ne može istovremeno biti svjedok!';
END IF;

END//
DELIMITER ;
 
# 19) Triger koji provjerava je li email dobre strukture
DELIMITER //
CREATE TRIGGER bi_osoba_mail
BEFORE INSERT ON osoba
FOR EACH ROW
BEGIN
IF new.email NOT LIKE '%@%'
THEN SIGNAL SQLSTATE '40000'
SET MESSAGE_TEXT = 'Neispravan email';
END IF;
END//
DELIMITER ;

# 20) Triger koji će ograničiti da isti zaposlenik ne smije istovremeno voditi više od 5 aktivnih slučajeva kako ne bi bio preopterećen
DELIMITER //

CREATE TRIGGER Ogranicenje_broja_slucajeva
BEFORE INSERT ON Slucaj
FOR EACH ROW
BEGIN
    DECLARE broj_slucajeva INT;

    SELECT COUNT(*)
    INTO broj_slucajeva
    FROM Slucaj
    WHERE id_voditelj = NEW.id_voditelj AND status = 'Aktivan';

    IF broj_slucajeva >= 5 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Zaposlenik ne može voditi više od 5 aktvnih slučajeva istovremeno kako ne bi bio preopterećen.';
    END IF;
END // 
DELIMITER ;
###############################################################################################################################################
DROP PROCEDURE IF EXISTS Provjera_voditelja_po_pocinitelju;
DELIMITER //

CREATE PROCEDURE Provjera_voditelja_po_pocinitelju(
    IN p_id_voditelj INT,
    IN p_id_pocinitelj INT,
    OUT p_poruka VARCHAR(1999)
)
BEGIN
    DECLARE broj_neaktivnih_slucajeva INT;

    SELECT 
        COUNT(CASE WHEN status = 'Riješen' THEN 1 END) INTO broj_neaktivnih_slucajeva
    FROM Slucaj
    WHERE id_pocinitelj = p_id_pocinitelj AND id_voditelj = p_id_voditelj;

    IF broj_neaktivnih_slucajeva > 0 THEN
        SET p_poruka = 'Voditelj ne može voditi nove slučajeve protiv istog počinitelja jer postoji barem jedan riješen slučaj.';
    ELSE
        SET p_poruka = 'Provjera uspješna, slučaj može biti otvoren.';
    END IF;
END //

DELIMITER ;
# OVO DELA JEEEj
#SELECT id_voditelj, id_pocinitelj FROM slucaj;
#CALL Provjera_voditelja_po_pocinitelju(9,26,@poruka);
#CALL Provjera_voditelja_po_pocinitelju(5, 7, @poruka);
#SELECT @poruka ;
#### Zapakirano u triger
DELIMITER //

CREATE TRIGGER BI_Slucaj_procedura
BEFORE INSERT ON Slucaj
FOR EACH ROW
BEGIN
    DECLARE poruka VARCHAR(1999);
    CALL Provjera_voditelja_po_pocinitelju(NEW.id_voditelj, NEW.id_pocinitelj, poruka);
    IF poruka != 'Provjera uspješna, slučaj može biti otvoren.' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = poruka;
    END IF;
END;

//

DELIMITER ;

DELIMITER //

CREATE PROCEDURE PostaviNaPoligraf(p_id_pocinitelj INT)
BEGIN
    DECLARE broj_poligrafa INT;
    
    -- Broj poligrafa koje je počinitelj već prošao
    SELECT COUNT(*) INTO broj_poligrafa
    FROM Sui_slucaj
    WHERE id_slucaj IN (SELECT id FROM Slucaj WHERE id_pocinitelj = p_id_pocinitelj);

    -- Ako počinitelj nije prošao barem dva puta poligraf, dodajte ga
    WHILE broj_poligrafa < 2 DO
        INSERT INTO Sui_slucaj (id_sui, id_slucaj)
        VALUES (1, (SELECT id FROM Slucaj WHERE id_pocinitelj = p_id_pocinitelj LIMIT 1));

        SET broj_poligrafa = broj_poligrafa + 1;
    END WHILE;
END;


DELIMITER ;
-- Stvaranje procedura za provjeru kazne i postavljanje počinitelja na poligraf
DELIMITER //

CREATE PROCEDURE Provjera_kazna_poligraf(
    IN p_id_pocinitelj INT,
    IN p_status VARCHAR(20)
)
BEGIN
    DECLARE ukupna_kazna INT;
    
    -- Izračunaj ukupnu kaznu za počinitelja
    SELECT SUM(kd.predvidena_kazna) INTO ukupna_kazna
    FROM Kaznjiva_djela_u_slucaju kds
    JOIN Kaznjiva_djela kd ON kds.id_kaznjivo_djelo = kd.id
    WHERE kds.id_slucaj IN (SELECT id FROM Slucaj WHERE id_pocinitelj = p_id_pocinitelj);

    -- Provjeri uvjete
    IF ukupna_kazna < 25 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Ukupna kazna počinitelju manja od 25 godina. Počinitelj ne mora proći poligraf barem dva puta.';
    ELSE
        CALL PostaviNaPoligraf(p_id_pocinitelj);
    END IF;
END;

DELIMITER ;



-- Stvaranje okidača koji poziva proceduru
DELIMITER //
CREATE TRIGGER Bi_slucaj_Provjera_Kazne
BEFORE INSERT  ON Slucaj
FOR EACH ROW
BEGIN
    -- Pozovi proceduru za provjeru kazne i postavljanje počinitelja na poligraf
    CALL Provjera_kazna_poligraf(NEW.id_pocinitelj, NEW.status);
END;

DELIMITER ;

#4. Zaposlenik ne može mijenjati id_zgrada u kojoj radi izvan Podrucje_uprave u kojoj je trenutno zaposlen.
#   Dakle, može mijenjati id_zgrada sve dok se time ne mijenja Podrucje_uprave zaposlenika. To je opet okidač (UPDATE) ali provjeru zapakirajte u proceduru
SELECT * FROM mjesto;
SELECT id_zgrada FROM zaposlenik; 
DELIMITER //

CREATE PROCEDURE ProvjeraPromjeneZgrade(
    IN p_id_zaposlenik INT,
    IN p_nova_zgrada INT,
    OUT p_poruka VARCHAR(255)
)
BEGIN
    DECLARE trenutno_podrucje_uprave INT;
    DECLARE novo_podrucje_uprave INT;

    -- Dohvati trenutno podrucje uprave zaposlenika
    SELECT M.id_podrucje_uprave INTO trenutno_podrucje_uprave
    FROM Zaposlenik Z
    JOIN Zgrada ZG ON Z.id_zgrada = ZG.id
    JOIN Mjesto M ON ZG.id_mjesto = M.id
    WHERE Z.id = p_id_zaposlenik;

    -- Dohvati podrucje uprave za novu zgradu
    SELECT id_podrucje_uprave INTO novo_podrucje_uprave
    FROM Zgrada
    WHERE id = p_nova_zgrada;

    -- Provjeri jesu li podrucja uprave ista
    IF trenutno_podrucje_uprave != novo_podrucje_uprave THEN
        SET p_poruka = 'Zaposlenik ne može mijenjati zgradu izvan trenutnog podrucja uprave.';
    ELSE
        SET p_poruka = 'Provjera uspješna, zaposlenik može promijeniti zgradu.';
    END IF;
END //

DELIMITER ;

DELIMITER //

CREATE TRIGGER ProvjeraPromjeneZgrade_Trigger
BEFORE UPDATE ON Zaposlenik
FOR EACH ROW
BEGIN
    DECLARE poruka VARCHAR(255);

    -- Pozovi proceduru za provjeru
    CALL ProvjeraPromjeneZgrade(NEW.id, NEW.id_zgrada, poruka);

    -- Ako je poruka postavljena, prekini izvršavanje upita i vrati poruku kao grešku
    IF poruka = 'Zaposlenik ne može mijenjati zgradu izvan trenutnog podrucja uprave.' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = poruka;
    ELSE
        -- Ako nema poruke, obavi promjenu zgrade
        UPDATE Zaposlenik SET id_zgrada = NEW.id_zgrada WHERE id = NEW.id;
    END IF;
END;

DELIMITER ;

# PROCEDURE

DELIMITER //

CREATE PROCEDURE Dodaj_Novo_Podrucje_Uprave(IN p_naziv VARCHAR(255))
BEGIN
    INSERT INTO Podrucje_uprave (naziv) VALUES (p_naziv);
END //

DELIMITER ;

# Napiši proceduru za unos novog mjesta
DELIMITER //

CREATE PROCEDURE Dodaj_Novo_Mjesto(
    IN p_naziv VARCHAR(255),
    IN p_id_podrucje_uprave INT
)
BEGIN
    INSERT INTO Mjesto (naziv, id_podrucje_uprave) VALUES (p_naziv, p_id_podrucje_uprave);
END //

DELIMITER ;

# Napiši proceduru za unos nove zgrade
DELIMITER //

CREATE PROCEDURE Dodaj_Novu_Zgradu(
    IN p_adresa VARCHAR(255),
    IN p_vrsta_zgrade VARCHAR(30),
    IN p_id_mjesto INT
)
BEGIN
    INSERT INTO Zgrada (adresa, vrsta_zgrade, id_mjesto) VALUES (p_adresa, p_vrsta_zgrade, p_id_mjesto);
END //

DELIMITER ;

# Napiši proceduru za unos novog radnog mjesta
DELIMITER //

CREATE PROCEDURE Dodaj_Novo_Radno_Mjesto(
    IN p_vrsta VARCHAR(255),
    IN p_dodatne_informacije TEXT
)
BEGIN
    INSERT INTO Radno_mjesto (vrsta, dodatne_informacije) VALUES (p_vrsta, p_dodatne_informacije);
END //

DELIMITER ;

# Napiši proceduru za unos novog odjela
DELIMITER //

CREATE PROCEDURE Dodaj_Novi_Odjel(
    IN p_naziv VARCHAR(255),
    IN p_opis TEXT
)
BEGIN
    INSERT INTO Odjeli (naziv, opis) VALUES (p_naziv, p_opis);
END //

DELIMITER ;

# Napiši proceduru za unos nove osobe
DELIMITER //

CREATE PROCEDURE Dodaj_Novu_Osobu(
    IN p_ime_prezime VARCHAR(255),
    IN p_datum_rodenja DATE,
    IN p_oib CHAR(11),
    IN p_spol VARCHAR(10),
    IN p_adresa VARCHAR(255),
    IN p_fotografija BLOB,
    IN p_telefon VARCHAR(20),
    IN p_email VARCHAR(255)
)
BEGIN
    INSERT INTO Osoba (ime_prezime, datum_rodenja, oib, spol, adresa, fotografija, telefon, email)
    VALUES (p_ime_prezime, p_datum_rodenja, p_oib, p_spol, p_adresa, p_fotografija, p_telefon, p_email);
END //

DELIMITER ;

# Procedura za unos novog zaposlenika
DELIMITER //

CREATE PROCEDURE Dodaj_Novog_Zaposlenika(
    IN p_datum_zaposlenja DATETIME,
    IN p_id_nadređeni INT,
    IN p_id_radno_mjesto INT,
    IN p_id_odjel INT,
    IN p_id_zgrada INT,
    IN p_id_mjesto INT,
    IN p_id_osoba INT
)
BEGIN
    INSERT INTO Zaposlenik (datum_zaposlenja, id_nadređeni, id_radno_mjesto, id_odjel, id_zgrada, id_mjesto, id_osoba)
    VALUES (p_datum_zaposlenja, p_id_nadređeni, p_id_radno_mjesto, p_id_odjel, p_id_zgrada, p_id_mjesto, p_id_osoba);
END //

DELIMITER ;



# Napiši proceduru za dodavanje novog predmeta
DELIMITER //

CREATE PROCEDURE Dodaj_Novi_Predmet(
    IN p_naziv VARCHAR(255),
    IN p_id_mjesto_pronalaska INT
)
BEGIN
    -- Unos novog predmeta
    INSERT INTO Predmet (naziv, id_mjesto_pronalaska)
    VALUES (p_naziv, p_id_mjesto_pronalaska);
END //

DELIMITER ;

# Napiši proceduru za dodavanje novog kaznjivog djela u bazu
DELIMITER //

CREATE PROCEDURE Dodaj_Novo_Kaznjivo_Djelo(
    IN p_naziv VARCHAR(255),
    IN p_opis TEXT,
    IN p_predvidena_kazna INT
)
BEGIN
    -- Unos novog kaznjivog djela
    INSERT INTO Kaznjiva_djela (naziv, opis, predvidena_kazna)
    VALUES (p_naziv, p_opis, p_predvidena_kazna);
END //

DELIMITER ;

# Napiši proceduru za dodavanje novog psa
DELIMITER //

CREATE PROCEDURE Dodaj_Novog_Psa(
    IN p_id_trener INTEGER,
    IN p_oznaka VARCHAR(255),
    IN p_godina_rođenja INTEGER,
    IN p_status VARCHAR(255),
    IN p_id_kaznjivo_djelo INTEGER
)
BEGIN
    -- Unos novog psa
    INSERT INTO Pas (id_trener, oznaka, godina_rođenja, status, id_kaznjivo_djelo)
    VALUES (p_id_trener, p_oznaka, p_godina_rođenja, p_status, p_id_kaznjivo_djelo);
END //

DELIMITER ;

# Napiši proceduru za dodavanje novog slučaja, ali neka se ukupna vrijednost zapljena i dalje računa automatski preko trigera
DELIMITER //

CREATE PROCEDURE Dodaj_Novi_Slucaj(
    IN p_naziv VARCHAR(255),
    IN p_opis TEXT,
    IN p_pocetak DATETIME,
    IN p_zavrsetak DATETIME,
    IN p_status VARCHAR(20),
    IN p_id_pocinitelj INT,
    IN p_id_izvjestitelj INT,
    IN p_id_voditelj INT,
    IN p_id_dokaz INT,
    IN p_id_pas INT,
    IN p_id_svjedok INT
)
BEGIN
    -- Unos novog slučaja
    INSERT INTO Slucaj (naziv, opis, pocetak, zavrsetak, status, id_pocinitelj, id_izvjestitelj, id_voditelj, id_dokaz, id_pas, id_svjedok)
    VALUES (p_naziv, p_opis, p_pocetak, p_zavrsetak, p_status, p_id_pocinitelj, p_id_izvjestitelj, p_id_voditelj, p_id_dokaz, p_id_pas, p_id_svjedok);
END //

DELIMITER ;

# Napravi proceduru koja će dodati novi događaj
DELIMITER //

CREATE PROCEDURE Dodaj_događaj_u_evidenciju(
    IN p_slucaj_id INT,
    IN p_opis_dogadaja TEXT,
    IN p_datum_vrijeme DATETIME,
    IN p_mjesto_id INT
)
BEGIN
    INSERT INTO Evidencija_dogadaja (id_slucaj, opis_dogadaja, datum_vrijeme, id_mjesto)
    VALUES (p_slucaj_id, p_opis_dogadaja, p_datum_vrijeme, p_mjesto_id);
END //

DELIMITER ;

# Napiši proceduru koja će dodavati kažnjiva djela u slučaju
DELIMITER //

CREATE PROCEDURE Dodaj_Kaznjivo_Djelo_U_Slucaju(
    IN p_slucaj_id INT,
    IN p_kaznjivo_djelo_id INT
)
BEGIN
    INSERT INTO Kaznjiva_djela_u_slucaju (id_slucaj, id_kaznjivo_djelo)
    VALUES (p_slucaj_id, p_kaznjivo_djelo_id);
END //

DELIMITER ;


DELIMITER //

# Napiši proceduru za dodavanje izvještaja
CREATE PROCEDURE Dodaj_Izvjestaj(
    IN p_naslov VARCHAR(255),
    IN p_sadrzaj TEXT,
    IN p_autor_id INT,
    IN p_slucaj_id INT
)
BEGIN
    INSERT INTO Izvjestaji (naslov, sadrzaj, id_autor, id_slucaj)
    VALUES (p_naslov, p_sadrzaj, p_autor_id, p_slucaj_id);
END //

DELIMITER ;

# Napiši proceduru za dodavanje zapljena
DELIMITER //

CREATE PROCEDURE Dodaj_Zapljene(
    IN p_opis TEXT,
    IN p_slucaj_id INT,
    IN p_predmet_id INT,
    IN p_vrijednost NUMERIC(5,2)
)
BEGIN
    INSERT INTO Zapljene (opis, id_slucaj, id_predmet, Vrijednost)
    VALUES (p_opis, p_slucaj_id, p_predmet_id, p_vrijednost);
END //

DELIMITER ;


# Napiši proceduru za dodavanje sredstva utvrđivanja istine
DELIMITER //

CREATE PROCEDURE Dodaj_Sredstvo_Utvrđivanja_Istine(
    IN p_naziv VARCHAR(100)
)
BEGIN
    INSERT INTO Sredstvo_utvrdivanja_istine (naziv)
    VALUES (p_naziv);
END //

DELIMITER ;

# Napiši proceduru za dodavanje SUI slučaj
DELIMITER //

CREATE PROCEDURE Dodaj_Sui_Slucaj(
    IN p_id_sui INT,
    IN p_id_slucaj INT
)
BEGIN
    INSERT INTO Sui_slucaj (id_sui, id_slucaj)
    VALUES (p_id_sui, p_id_slucaj);
END //

DELIMITER ;

# Procedura za unos novog vozila; ukoliko je vozilo službeno, ono će imati id_vlasnik koji će predstavljati službenika koji najviše koristi vozilo, ali postaviti će se napomena da je vlasnik MUP

SELECT * FROM vozilo;
-- DROP PROCEDURE Dodaj_Novo_Vozilo;

DELIMITER //

CREATE PROCEDURE Dodaj_Novo_Vozilo(
    IN p_marka VARCHAR(255),
    IN p_model VARCHAR(255),
    IN p_registracija VARCHAR(20),
    IN p_godina_proizvodnje INT,
    IN p_sluzbeno_vozilo INT, -- 1 za službeno, 0 za privatno
    IN p_id_vlasnik INT
)
BEGIN
    # Dodamo stupac napomena ako već ne postoji (ovo naknadno prepravit preko alter table, pa izbacit od tu)
    IF NOT EXISTS (
        SELECT * 
        FROM INFORMATION_SCHEMA.COLUMNS 
        WHERE TABLE_NAME = 'Vozilo' AND COLUMN_NAME = 'napomena'
    ) THEN
        ALTER TABLE Vozilo ADD COLUMN napomena VARCHAR(255);
    END IF;
    
    # Postavimo napomenu na 'Vlasnik MUP' ako je vozilo službeno
    IF p_sluzbeno_vozilo = 1 THEN
        SET @napomena = 'Vlasnik MUP';
    ELSE
        SET @napomena = NULL;  # Ako nije službeno, ne treba nam neka posebna napomena
    END IF;

    INSERT INTO Vozilo (marka, model, registracija, godina_proizvodnje, id_vlasnik, napomena)
    VALUES (p_marka, p_model, p_registracija, p_godina_proizvodnje, p_id_vlasnik, @napomena);
END //

DELIMITER ;


CALL Dodaj_Novo_Vozilo ('Chevrolet', 'Camaro', 'ZG-222-FF', 2019, 1, 3);
SELECT * FROM vozilo;








# Napiši proceduru koja će svim zatvorenicima koji su još u zatvoru (datum odlaska iz zgrade zatvora im je NULL) dodati novi stupac sa brojem dana u zatvoru koji će dobiti tako da računa broj dana o dana dolaska u zgradu do današnjeg dana
# Ubacit scheduled dnevno izvođenje procedure
-- DROP PROCEDURE AzurirajPodatkeZatvor;
ALTER TABLE Osoba ADD COLUMN broj_dana_u_zatvoru INT;
DELIMITER //

CREATE PROCEDURE AzurirajPodatkeZatvor()
BEGIN

    UPDATE Osoba O
    JOIN Slucaj S ON O.id = S.id_pocinitelj
    SET O.Broj_dana_u_zatvoru = DATEDIFF(NOW(), S.zavrsetak)
    WHERE S.status = 'riješen';
    
END //

DELIMITER ;

CALL AzurirajPodatkeZatvor();
# Aktiviramo Event Scheduler ako već nije aktivan
SET GLOBAL event_scheduler = ON;

-- Stvaramo
DELIMITER //

CREATE EVENT IF NOT EXISTS Dnevno_odbrojavanje
ON SCHEDULE
    EVERY 1 DAY
    STARTS CURRENT_DATE
DO
    CALL AzurirajPodatkeZatvor(); # pretpostavljamo da je osoba zatvorena točno na dan završetka slučaja

//

DELIMITER ;

CALL AzurirajPodatkeZatvor();
# Aktiviramo Event Scheduler ako već nije aktivan
SET GLOBAL event_scheduler = ON;











# Napiši proceduru koja će omogućiti da pretražujemo slučajeve preko neke ključne riječi iz opisa # OVO SU SADA 2 POGLEDA I 1 UPIT
CREATE VIEW Svi_slucajevi AS
SELECT * FROM Slucaj;

CREATE VIEW Filtrirani_slucajevi AS
SELECT * FROM Svi_slucajevi
WHERE Opis LIKE CONCAT('%', 'tvoja_kljucna_rijec', '%');

SELECT * FROM Filtrirani_slucajevi;


# Napiši proceduru koja će kreirati novu privremenu tablicu u kojoj će se prikazati svi psi i broj slučajeva na kojima su radili. Zatim će dodati novi stupac tablici pas i u njega upisati "nagrađeni pas" kod svih pasa koji su radili na više od 15 slučajeva 

-- Postavljanje sql_safe_updates na 0
SET sql_safe_updates = 0;

DELIMITER //
CREATE PROCEDURE Godisnje_nagrađivanje_pasa()
BEGIN
    
    CREATE TEMPORARY TABLE IF NOT EXISTS Temp_Psi (id_pas	INT, BrojSlucajeva INT);

    
    INSERT INTO Temp_Psi (id_pas, BrojSlucajeva)
    SELECT id_pas, COUNT(*) AS BrojSlucajeva
    FROM Slucaj
    GROUP BY id_pas;
    
    UPDATE Pas
    SET Status = 'nagrađeni pas'
    WHERE Id IN (SELECT	id_pas  FROM Temp_Psi WHERE BrojSlucajeva > 15);
    
    
    DROP TEMPORARY TABLE Temp_Psi;
END //
DELIMITER ;
SELECT * FROM Pas;
CALL Godisnje_nagrađivanje_pasa();

# Napiši sličnu proceduru za godišnje nagrađivanje zaposlenika (ovo je nova procedura po uzoru na gornju)
DELIMITER //
CREATE PROCEDURE Godisnje_nagrađivanje_zaposlenika()
BEGIN
    CREATE TEMPORARY TABLE IF NOT EXISTS Temp_Zaposlenici (id_zaposlenik INT, broj_rijesenih_slucajeva INT);

    INSERT INTO Temp_Zaposlenici (id_zaposlenik, broj_rijesenih_slucajeva)
    SELECT id_voditelj, COUNT(*) AS broj_rijesenih_slucajeva
    FROM Slucaj
    WHERE status = 'riješen'
    GROUP BY id_voditelj;

    UPDATE Zaposlenik
    SET Status = 'nagrađeni zaposlenik'
    WHERE id IN (SELECT id_zaposlenik FROM Temp_Zaposlenici WHERE broj_rijesenih_slucajeva > 2); # u praksi bi treba bit veći broj slučajeva za nagradu, ali nemamo ih baš puno u bazi

    DROP TEMPORARY TABLE IF EXISTS Temp_Zaposlenici;
END //
DELIMITER ;

SELECT * FROM Slucajevi_u_posljednjih_n_dana;
SELECT * FROM slucaj;
# Napiši proceduru koja će za određenu osobu kreirati potvrdu o nekažnjavanju. To će napraviti samo u slučaju da osoba stvarno nije evidentirana niti u jednom slučaju kao počinitelj. Ukoliko je osoba kažnjavana i za to ćemo dobiti odgovarajuću obavijest. Također,ako uspješno izdamo potvrdu, neka se prikaže i datum izdavanja
# Neka id_slucaj za izvještaj bude 999 kako ne bismo morali mijenjati shemu baze
-- DROP PROCEDURE ProvjeriNekažnjavanje;
DELIMITER //

CREATE PROCEDURE ProvjeriNekažnjavanje(IN osoba_id INT)
BEGIN
    DECLARE počinitelj_count INT;
    DECLARE osoba_ime_prezime VARCHAR(255);
    DECLARE obavijest VARCHAR(255);
    DECLARE izdavanje_datum DATETIME;

    SET izdavanje_datum = NOW();

    SELECT Ime_Prezime INTO osoba_ime_prezime FROM Osoba WHERE Id = osoba_id;

    SELECT COUNT(*) INTO počinitelj_count
    FROM Slucaj
    WHERE id_pocinitelj	= osoba_id;

    IF počinitelj_count > 0 THEN
        SET obavijest = 'Osoba je kažnjavana';
        SELECT obavijest AS Poruka;
    ELSE
        INSERT INTO Izvjestaji (Naslov, sadrzaj, id_autor, id_slucaj)
        VALUES ('Potvrda o nekažnjavanju', CONCAT('Osoba ', osoba_ime_prezime, ' nije kažnjavana. Izdana ', DATE_FORMAT(izdavanje_datum, '%d-%m-%Y %H:%i:%s')), osoba_id, 999);
        SELECT CONCAT('Potvrda za ', osoba_ime_prezime) AS Poruka;
    END IF;
END //

DELIMITER ;

# Svaki izvještaj mora biti povezan za neki slučaj, pa smo kreirali "slučaj" za izdavanje potvrde, da bi ga se moglo referencirat u potvrdi o nekažnjvananju
INSERT INTO Slucaj (id, naziv, pocetak, zavrsetak, status, opis) VALUES ( 999, 'Izdavanje potvrde', NOW(), NOW()+INTERVAL 1 DAY, 'U tijeku', 'Opis slucaja');
SELECT * FROM Slucaj;

CALL ProvjeriNekažnjavanje(1);


SELECT * FROM Izvjestaji;

CALL ProvjeriNekažnjavanje(1);
SELECT * FROM Izvjestaji;

# Napiši proceduru koja će omogućiti da za određenu osobu izmjenimo kontakt informacije (email i/ili broj telefona)
DELIMITER //

CREATE PROCEDURE IzmjeniKontaktInformacije(
    IN id_osoba INT,
    IN novi_email VARCHAR(255),
    IN novi_telefon VARCHAR(20)
)
BEGIN
    DECLARE br_osoba INT;
    SELECT COUNT(*) INTO br_osoba FROM Osoba WHERE Id = id_osoba;
    
    IF br_osoba > 0 THEN
        UPDATE Osoba
        SET Email = novi_email, Telefon = novi_telefon
        WHERE Id = id_osoba;
        
        SELECT 'Kontakt informacije su uspješno izmijenjene' AS Poruka;
    ELSE
        SELECT 'Osoba s navedenim ID-jem ne postoji' AS Poruka;
    END IF;
END //

DELIMITER ;
SELECT * FROM Osoba;
CALL IzmjeniKontaktInformacije (1, 'a@b.com', 091333333);

# Napiši proceduru koja će za određeni slučaj izlistati sve događaje koji su se u njemu dogodili i poredati ih kronološki (OVO JE VIEW)
CREATE VIEW Pregled_Dogadaji AS
SELECT ed.Id, ed.opis_dogadaja, ed.datum_vrijeme, ed.id_slucaj
FROM Evidencija_dogadaja AS ed
ORDER BY ed.Datum_Vrijeme;

# Napiši PROCEDURU KOJA ZA ARGUMENT PRIMA OZNAKU PSA, A VRAĆA ID, IME i PREZIME VLASNIKA i BROJ SLUČAJEVA U KOJIMA JE PAS SUDJELOVAO (Ovo je isto VIEW)
CREATE VIEW Pregled_Pas AS
SELECT
    O.Id AS Vlasnik_id,
    O.Ime_Prezime AS Trener,
    COUNT(S.Id) AS BrojSlucajeva,
    P.Oznaka
FROM
    Pas AS P
INNER JOIN Slucaj AS S ON P.Id = S.id_pas
INNER JOIN Osoba AS O ON P.Id_trener = O.Id
GROUP BY
    P.Id, P.Oznaka, O.Id, O.Ime_Prezime;

# Napiši proceduru koja će za određeno KD moći smanjiti ili povećati predviđenu kaznu tako što će za argument primiti naziv KD i broj godina za koji želimo izmjeniti kaznu
# Ako želimo smanjiti kaznu, za argument ćemo prosljediti negativan broj
DELIMITER //
CREATE PROCEDURE izmjeni_kaznu(IN naziv_djela VARCHAR(255), IN iznos INT)
BEGIN
    DECLARE kazna INT;
    
    SELECT predvidena_kazna INTO kazna
    FROM Kaznjiva_djela
    WHERE naziv = naziv_djela;
    
    IF kazna IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Traženo KD ne postoji u bazi';
    END IF;
    
    SET kazna = kazna + iznos;
    
    UPDATE Kaznjiva_djela
    SET predvidena_kazna = kazna
    WHERE naziv = naziv_djela;
END //
DELIMITER ;
SELECT * FROM Kaznjiva_djela;
CALL izmjeni_kaznu ('Otmica', 4);

# Napravi sličnu proceduru za promjenu novčane kazne
	DELIMITER //
CREATE PROCEDURE izmjeni_kaznu_n(IN naziv_djela VARCHAR(255), IN iznos INT)
BEGIN
    DECLARE kazna INT;
    
    SELECT predvidena_novcana_kazna INTO kazna
    FROM Kaznjiva_djela
    WHERE naziv = naziv_djela;
    
    IF kazna IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Traženo KD ne postoji u bazi';
    END IF;
    
    SET kazna = kazna + iznos;
    
    UPDATE Kaznjiva_djela
    SET predvidena_novcana_kazna = kazna
    WHERE naziv = naziv_djela;
END //
DELIMITER ;





# Napiši proceduru koja će služiti za unaprijeđenje policijskih službenika na novo radno mjesto. Ako je novo radno mjesto jednako onom radnom mjestu osobe koja im je prije bila nadređena, postaviti će id_nadređeni na NULL
-- DROP PROCEDURE UnaprijediPolicijskogSluzbenika;
DELIMITER //

CREATE PROCEDURE UnaprijediPolicijskogSluzbenika(
    IN p_id_osoba INT, 
    IN p_novo_radno_mjesto_id INT
)
BEGIN
    DECLARE stari_radno_mjesto_id INT;
    DECLARE stari_nadredeni_id INT;
    DECLARE radno_mjesto_nadredenog INT;

    SELECT id_radno_mjesto, id_nadređeni INTO stari_radno_mjesto_id, stari_nadredeni_id
    FROM Zaposlenik
    WHERE id_osoba = p_id_osoba
    LIMIT 1;

    SELECT id_radno_mjesto INTO radno_mjesto_nadredenog
    FROM Zaposlenik
    WHERE id_osoba = stari_nadredeni_id
    LIMIT 1;

    IF radno_mjesto_nadredenog = p_novo_radno_mjesto_id THEN
        UPDATE Zaposlenik
        SET id_nadređeni = NULL
        WHERE id_osoba = p_id_osoba;
    ELSE
        UPDATE Zaposlenik
        SET id_radno_mjesto = p_novo_radno_mjesto_id
        WHERE id_osoba = p_id_osoba;
    END IF;
END //

DELIMITER ;
SELECT Zaposlenik.*, Radno_mjesto.id FROM Zaposlenik, Radno_mjesto WHERE Zaposlenik.id_radno_mjesto = radno_mjesto.id;
CALL UnaprijediPolicijskogSluzbenika(1,2);
# Napravi proceduru koja će provjeravati je li zatvorska kazna istekla 
# Ova je grda
DELIMITER //

CREATE PROCEDURE ProvjeriIstekZatvorskeKazne()
BEGIN
	DECLARE done INT DEFAULT 0;
    DECLARE osoba_id INT;
    DECLARE datum_zavrsetka_slucaja DATETIME;
    DECLARE ukupna_kazna INT;
    DECLARE danas DATETIME;
    
    DECLARE cur CURSOR FOR
    SELECT O.Id, S.zavrsetak
    FROM Osoba O
    JOIN Slucaj S ON O.id = S.id_pocinitelj
    WHERE S.status = 'Zavrsen';
    
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
    # Provjerimo dali postoji stupac prije dodavanja
    IF NOT EXISTS (
        SELECT * FROM INFORMATION_SCHEMA.COLUMNS
        WHERE TABLE_NAME = 'Osoba' AND COLUMN_NAME = 'obavijest'
    ) THEN
        # Dodamo stupac obavijest u tablicu Osoba
        ALTER TABLE Osoba
        ADD COLUMN obavijest VARCHAR(50);
    END IF;

    
    OPEN cur;

    read_loop: LOOP
        FETCH cur INTO osoba_id, datum_zavrsetka_slucaja;

        IF done = 1 THEN
            LEAVE read_loop;
        END IF;

        # Izračunamo ukupnu kaznu za osobu
        SET ukupna_kazna = (
            SELECT COALESCE(SUM(K.predvidena_kazna), 0)
            FROM Slucaj S
            LEFT JOIN Kaznjiva_djela_u_slucaju KS ON S.id = KS.id_slucaj
            LEFT JOIN Kaznjiva_djela K ON KS.id_kaznjivo_djelo = K.id
            WHERE S.id_pocinitelj = osoba_id
        );

        # Provjerimo je li datum zavrsetka_slucaja + ukupna_kazna manji od današnjeg datuma
        SET danas = NOW();
        IF DATE_ADD(datum_zavrsetka_slucaja, INTERVAL ukupna_kazna DAY) <= danas THEN
            # Datum na koji je osoba trebala biti puštena je manji nego današnji => istekla je zatvorska kazna, dodamo obavijest u stupac obavijest u tablici Osoba
            UPDATE Osoba
            SET obavijest = 'Kazna je istekla'
            WHERE Id = osoba_id;
        END IF;
    END LOOP;

    
    CLOSE cur;

END //

DELIMITER ;
CALL ProvjeriIstekZatvorskeKazne();
SELECT * FROM Osoba;
# EVENT KOJI VRTI TU PROCEDURU SVAKIH 1 DAN
DELIMITER //

CREATE EVENT IF NOT EXISTS `ProvjeraIstekaKazniEvent`
ON SCHEDULE EVERY 1 DAY
DO
BEGIN
    CALL ProvjeriIstekZatvorskeKazne();
END //

DELIMITER ;

########################## NOVO ####################################
# Par ideja za procedure:
#1. Možete implementirati pravilo da određeni voditelj ne može voditi više slučajeva protiv određenog počinitelja (kao neki mehanizam zaštite pravde).
#   Ako želite dodatnu težinu onda možete reći da voditelj smije voditi više paralelnih slučajeva prema tom počinitelju, ali jednom kad zatvori jedan slučaj prema tom počinitelju onda više ne smije voditi nove slučajeve.
#   Ovo izgleda kao problem za okidač, ali ta provjera vam treba prilikom INSERT-a i prilikom UPDATE-a, tako da tu provjeru smjestite u proceduru i pozovite proceduru u oba okidača

# OVO DELA JEEEj
#SELECT id_voditelj, id_pocinitelj FROM slucaj;
#CALL Provjera_voditelja_po_pocinitelju(9,26,@poruka);
#CALL Provjera_voditelja_po_pocinitelju(5, 7, @poruka);
#SELECT @poruka ;
#### Zapakirano u triger


#2. Procedura (naziv "nagodba") koja će za počinitelja (p_id_pocinitelj) pozatvarati sve njegove otvorene slučajeve i postaviti sve potrebne vrijednosti na odgovarajuća mjesta što god treba (npr. u opis svakog slučaja dodati "(zaključen nagodbom)", postaviti datum_završetka, status itd.) -> tu bi mu trebala kazna u godinama biti manja, ali ne vidin način da to napravite pa taj dio možete zanemarit
#SELECT * FROM slucaj;

DELIMITER //

CREATE PROCEDURE nagodba(p_id_pocinitelj INT)
BEGIN
    DECLARE ukupna_kazna INT;
    
    -- Izračunaj ukupnu kaznu za počinitelja
    SELECT SUM(kd.predvidena_kazna) INTO ukupna_kazna
    FROM Kaznjiva_djela_u_slucaju kds
    JOIN Kaznjiva_djela kd ON kds.id_kaznjivo_djelo = kd.id
    WHERE kds.id_slucaj IN (SELECT id FROM Slucaj WHERE id_pocinitelj = p_id_pocinitelj);

    -- Provjeri ukupnu kaznu
    IF ukupna_kazna > 7 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Ukupna kazna prelazi 7 godina, nagodba nije moguća.';
    ELSE
        -- Postavi odgovarajuće vrijednosti za zatvaranje slučajeva nagodbom
        UPDATE Slucaj
        SET 
            opis = CONCAT(opis, ' (zaključen nagodbom)'),
            zavrsetak = NOW(),
            status = 'Zatvoren nagodbom'
        WHERE id_pocinitelj = p_id_pocinitelj AND status = 'aktivan';
        
        -- Dodajte dodatne postavke koje želite primijeniti za nagodbu
    END IF;
END //
DELIMITER ;
#SELECT * FROM slucaj;
#CALL nagodba(47);  # DELA

#3. Možete implementirati pravilo da ako je ukupna kazna počinitelju za slučaj veća od 25 godina, da se počinitelj mora barem dva puta staviti na poligraf.
#   Ako to nije zadovoljeno neće se dopustit (greška) postavljanje atributa "zavrsetak" u tablici slučaj (ili "status" -> kako god kontrolirate završetak slučaja).
#   To je ponovno mehanizam za okidač, ali opet morate obuhvatiti i INSERT i UPDATE, pa onda stavite provjeru u proceduru pa pozovite proceduru u okidačima
## VEĆ IMAMO TRIGER KOJI GOVORI DA NE SMIJE BITI VEĆI OD 50, PA ĆEMO STAVITI 25 GODINA U OVO PRAVILO
#SELECT * FROM sredstvo_utvrdivanja_istine;



DELIMITER //

CREATE PROCEDURE PostaviNaPoligraf(p_id_pocinitelj INT)
BEGIN
    DECLARE broj_poligrafa INT;
    
    -- Broj poligrafa koje je počinitelj već prošao
    SELECT COUNT(*) INTO broj_poligrafa
    FROM Sui_slucaj
    WHERE id_slucaj IN (SELECT id FROM Slucaj WHERE id_pocinitelj = p_id_pocinitelj);

    -- Ako počinitelj nije prošao barem dva puta poligraf, dodajte ga
    WHILE broj_poligrafa < 2 DO
        INSERT INTO Sui_slucaj (id_sui, id_slucaj)
        VALUES (1, (SELECT id FROM Slucaj WHERE id_pocinitelj = p_id_pocinitelj LIMIT 1));

        SET broj_poligrafa = broj_poligrafa + 1;
    END WHILE;
END;


DELIMITER ;
-- Stvaranje procedura za provjeru kazne i postavljanje počinitelja na poligraf
DELIMITER //

CREATE PROCEDURE Provjera_kazna_poligraf(
    IN p_id_pocinitelj INT,
    IN p_status VARCHAR(20)
)
BEGIN
    DECLARE ukupna_kazna INT;
    
    -- Izračunaj ukupnu kaznu za počinitelja
    SELECT SUM(kd.predvidena_kazna) INTO ukupna_kazna
    FROM Kaznjiva_djela_u_slucaju kds
    JOIN Kaznjiva_djela kd ON kds.id_kaznjivo_djelo = kd.id
    WHERE kds.id_slucaj IN (SELECT id FROM Slucaj WHERE id_pocinitelj = p_id_pocinitelj);

    -- Provjeri uvjete
    IF ukupna_kazna < 25 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Ukupna kazna počinitelju manja od 25 godina. Počinitelj ne mora proći poligraf barem dva puta.';
    ELSE
        CALL PostaviNaPoligraf(p_id_pocinitelj);
    END IF;
END;

DELIMITER ;



-- Stvaranje okidača koji poziva proceduru
DELIMITER //
CREATE TRIGGER Bi_slucaj_Provjera_Kazne
BEFORE INSERT  ON Slucaj
FOR EACH ROW
BEGIN
    -- Pozovi proceduru za provjeru kazne i postavljanje počinitelja na poligraf
    CALL Provjera_kazna_poligraf(NEW.id_pocinitelj, NEW.status);
END;

DELIMITER ;






#4. Zaposlenik ne može mijenjati id_zgrada u kojoj radi izvan Podrucje_uprave u kojoj je trenutno zaposlen.
#   Dakle, može mijenjati id_zgrada sve dok se time ne mijenja Podrucje_uprave zaposlenika. To je opet okidač (UPDATE) ali provjeru zapakirajte u proceduru
SELECT * FROM mjesto;
SELECT id_zgrada FROM zaposlenik; 


DELIMITER //

CREATE TRIGGER ProvjeraPromjeneZgrade_Trigger
BEFORE UPDATE ON Zaposlenik
FOR EACH ROW
BEGIN
    DECLARE poruka VARCHAR(255);

    -- Pozovi proceduru za provjeru
    CALL ProvjeraPromjeneZgrade(NEW.id, NEW.id_zgrada, poruka);

    -- Ako je poruka postavljena, prekini izvršavanje upita i vrati poruku kao grešku
    IF poruka = 'Zaposlenik ne može mijenjati zgradu izvan trenutnog podrucja uprave.' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = poruka;
    ELSE
        -- Ako nema poruke, obavi promjenu zgrade
        UPDATE Zaposlenik SET id_zgrada = NEW.id_zgrada WHERE id = NEW.id;
    END IF;
END;

DELIMITER ;

# FUNKCIJE

# FUNKCIJE + upiti za funkcije
# 1) Napiši funkciju koja kao argument prima naziv kaznenog djela i vraća naziv KD, predviđenu kaznu i broj pojavljivanja KD u slučajevima
-- DROP FUNCTION KDInfo;
DELIMITER //
CREATE FUNCTION KDInfo(p_naziv_kaznjivog_djela VARCHAR(255)) RETURNS TEXT
DETERMINISTIC
BEGIN
    DECLARE f_predvidena_kazna INT;
    DECLARE broj_pojavljivanja INT;
    
    SELECT predvidena_kazna INTO f_predvidena_kazna
    FROM Kaznjiva_djela
    WHERE Naziv = p_naziv_kaznjivog_djela;

    SELECT COUNT(*) INTO broj_pojavljivanja
    FROM Kaznjiva_Djela_u_Slucaju
    WHERE id_kaznjivo_djelo= (SELECT ID FROM Kaznjiva_djela	WHERE Naziv = p_naziv_kaznjivog_djela);

    RETURN CONCAT('Kaznjivo djelo: ', p_naziv_kaznjivog_djela, '\nPredviđena kazna: ', f_predvidena_kazna, '\nBroj pojavljivanja: ', broj_pojavljivanja);
END;
//
DELIMITER ;

SELECT KDInfo('Ubojstvo');

# u.1)Napiši upit koji će koristeći ovu funkciju izlistati sva kaznena djela koja su se dogodila u 2023. godini (ili nekoj drugoj) i njihov broj pojavljivanja

    SELECT
    KDInfo(KD.Naziv) AS KaznjivoDjeloInfo,
    COUNT(KS.id_kaznjivo_djelo) AS BrojPojavljivanja
FROM Kaznjiva_Djela_u_Slucaju KS
INNER JOIN Kaznjiva_djela KD ON KS.id_kaznjivo_djelo = KD.ID
INNER JOIN Slucaj S ON KS.id_slucaj = S.ID
WHERE YEAR(S.Pocetak) = 2023
GROUP BY KD.Naziv;


#2 Napiši funkciju koja će vratiti informacije o osobi prema broju telefona
DELIMITER //
CREATE FUNCTION InformacijeOOsobiPoTelefonu(broj_telefona VARCHAR(20)) RETURNS TEXT
DETERMINISTIC
BEGIN
    DECLARE osoba_info TEXT;

    SELECT CONCAT('Ime i prezime: ', Ime_Prezime, '\nDatum rođenja: ', Datum_rodenja, '\nAdresa: ', Adresa, '\nEmail: ', Email)
    INTO osoba_info
    FROM Osoba
    WHERE Telefon = broj_telefona;

    IF osoba_info IS NOT NULL THEN
        RETURN osoba_info;
    ELSE
        RETURN 'Osoba s navedenim brojem telefona nije pronađena.';
    END IF;
END;
//
DELIMITER ;

# u.2)Napiši upit koji će izlistati sve brojeve telefona i informacije o tim osobama, ali samo ako te osobe nisu policijski službenici
 
    SELECT
    Telefon,
    InformacijeOOsobiPoTelefonu(Telefon) AS OsobaInfo
FROM Osoba
WHERE Osoba.id NOT IN(SELECT id_osoba FROM Zaposlenik);


SET SQL_safe_updates = 0;

# 3)Napiši funkciju koja će za određeni predmet vratiti slučaj u kojem je taj predmet dokaz i osobu koja je u tom slučaju osumnjičena
-- DROP FUNCTION DohvatiSlucajIOsobu;


DELIMITER //

CREATE FUNCTION DohvatiSlucajIOsobu(p_id_predmet	INT)
RETURNS VARCHAR(512)
DETERMINISTIC
BEGIN
    DECLARE slucaj_naziv VARCHAR(255);
    DECLARE osoba_ime_prezime VARCHAR(255);
    DECLARE rezultat VARCHAR(512);
    
    
    SELECT Slucaj.Naziv INTO slucaj_naziv
    FROM Slucaj
    WHERE Slucaj.id_dokaz= p_id_predmet
    LIMIT 1;
    
    
    SELECT Osoba.Ime_Prezime INTO osoba_ime_prezime
    FROM Osoba
    INNER JOIN Slucaj ON Osoba.Id = Slucaj.id_pocinitelj
    WHERE Slucaj.id_dokaz = p_id_predmet
    LIMIT 1;
    
    SET rezultat = CONCAT('Odabrani je predmet dokaz u slučaju: ', slucaj_naziv, ', gdje je osumnjičena osoba: ', osoba_ime_prezime);
    
    RETURN rezultat;
END //

DELIMITER ;
SELECT DohvatiSlucajIOsobu(1);

# u3)Napiši upit koji izdvaja informacije o određenom predmetu, uključujući naziv predmeta, naziv povezanog slučaja i ime i prezime osumnjičenika u tom slučaju, koristeći funkciju DohvatiSlucajIOsobu za dobijanje dodatnih detalja za taj predmet.
SELECT
    Predmet.ID AS PredmetID,
    Predmet.Naziv AS NazivPredmeta,
    Slucaj.Naziv AS NazivSlucaja,
    Osoba.Ime_Prezime AS ImePrezimeOsumnjicenika,
    DohvatiSlucajIOsobu(Predmet.ID) AS InformacijeOPredmetu
FROM Predmet
INNER JOIN Slucaj ON Predmet.ID = Slucaj.id_dokaz
INNER JOIN Osoba ON Slucaj.id_pocinitelj = Osoba.ID
WHERE Predmet.ID = 5;

SELECT * FROM predmet;

# 4) Napravi funkciju koja će za argument primati sredstvo utvrđivanja istine, zatim će prebrojiti u koliko je slučajeva to sredstvo korišteno, prebrojit će koliko je slučajeva od tog broja riješeno, te će na temelju ta 2 podatka izračunati postotak rješenosti slučajeva gdje se odabrano sredstvo koristi
DELIMITER //

CREATE FUNCTION IzracunajPostotakRjesenosti (
    sredstvo_id INT
) RETURNS DECIMAL(5,2)
DETERMINISTIC
BEGIN
    DECLARE ukupno INT;
    DECLARE koristeno INT;
    DECLARE postotak DECIMAL(5,2);
    
    
    SELECT COUNT(*) INTO ukupno FROM Sui_slucaj WHERE Id_sui = sredstvo_id;
    
    
    SELECT COUNT(*) INTO koristeno FROM Sui_slucaj s
    INNER JOIN Slucaj c ON s.Id_slucaj = c.Id
    WHERE s.Id_sui = sredstvo_id AND c.Status = 'Riješen';
    
    
    IF ukupno IS NOT NULL AND ukupno > 0 THEN
        SET postotak = (koristeno / ukupno) * 100;
    ELSE
        SET postotak = 0.00;
    END IF;
    
    RETURN postotak;
END //

DELIMITER ;

# u4)Koristeći gornju funkciju prikaži sredstva koja imaju rješenost veću od 50% (riješeno je više od 50% slučajeva koja koriste to sredstvo)
SELECT
    Sredstvo_utvrdivanja_istine.ID AS id_sredstvo,
    Sredstvo_utvrdivanja_istine.Naziv AS Naziv_Sredstva,
    IzracunajPostotakRjesenosti(Sredstvo_utvrdivanja_istine.ID) AS postotak
FROM Sredstvo_utvrdivanja_istine
WHERE IzracunajPostotakRjesenosti(Sredstvo_utvrdivanja_istine.ID) > 50.00;

# 5)Napiši funkciju koja će za argument primati registarske tablice vozila, a vraćat će informaciju je li se to vozilo pojavilo u nekom od slučajeva, tako što će provjeriti je li se id_osoba koji referencira vlasnika pojavio u nekom slučaju kao pocinitelj_id. Ako se pojavilo, vraćat će "Vozilo se pojavljivalo u slučajevima", a ako se nije pojavilo, vraćat će "Vozilo se nije pojavljivalo u slučajevima". Također, vratit će i broj koliko se puta vozilo pojavilo
-- DROP FUNCTION Provjera_vozila;
DELIMITER //
CREATE FUNCTION Provjera_vozila(p_registracija VARCHAR(20))
RETURNS VARCHAR(255)
DETERMINISTIC
BEGIN
    DECLARE result VARCHAR(255);
    DECLARE pojavljivanja INT;

    SELECT COUNT(*) INTO pojavljivanja
    FROM Slucaj
    WHERE id_pocinitelj IN (SELECT id_vlasnik FROM Vozilo WHERE registracija = p_registracija);

    IF pojavljivanja > 0 THEN
        SET result = CONCAT('Vozilo se pojavljivalo u slučajevima (', pojavljivanja, ' puta)');
    ELSE
        SET result = 'Vozilo se nije pojavljivalo u slučajevima';
    END IF;

    RETURN result;
END //
 DELIMITER ;



# u5)Koristeći funkciju prikažite vozila koja se pojavljuju iznad prosjeka (u iznadprosječnom broju)
CREATE VIEW View_Provjera_Vozila AS
SELECT 
    V.Registracija, 
    Provjera_vozila(V.Registracija) AS StatusVozila
FROM 
    Vozilo V
INNER JOIN (
    SELECT 
        Vozilo.Registracija, 
        COUNT(*) AS count
    FROM 
        Slucaj
    INNER JOIN 
        Vozilo ON Slucaj.id_pocinitelj = Vozilo.id_vlasnik
    GROUP BY 
        Vozilo.Registracija
) AS Podupit ON V.Registracija = Podupit.Registracija
WHERE 
    Podupit.count > (
        SELECT 
            AVG(count) AS Prosjek
        FROM (
            SELECT 
                COUNT(*) AS count
            FROM 
                Slucaj
            INNER JOIN 
                Vozilo ON Slucaj.id_pocinitelj = Vozilo.id_vlasnik
            GROUP BY 
                Vozilo.Registracija
        ) AS Podupit1
    );
SELECT * FROM View_Provjera_Vozila; # Nema iznadprosječnih vozila :)...samo 1 se pojavljuje u slučajevima


# 6)Funkcija koja za argument prima id podrucja uprave i vraća broj mjesta u tom području te naziv svih mjesta u 1 stringu
DELIMITER //
CREATE FUNCTION Podaci_O_Podrucju(id_podrucje INT) RETURNS TEXT
DETERMINISTIC
BEGIN
    DECLARE broj_mjesta INT;
    DECLARE mjesta TEXT;
    
    SELECT COUNT(*) INTO broj_mjesta
    FROM Mjesto
    WHERE id_podrucje_uprave = id_podrucje;
    
    SELECT GROUP_CONCAT(naziv SEPARATOR ';') INTO mjesta
    FROM Mjesto
    WHERE id_podrucje_uprave = id_podrucje;
    
    RETURN CONCAT('Područje: ', (SELECT naziv FROM Podrucje_uprave WHERE id = id_podrucje), 
                  ', Broj mjesta: ', broj_mjesta, ', Mjesta: ', mjesta);
END //
DELIMITER ;

# 7) Napravi funkciju koje će za slučej predan preko id-ja dohvatiti broj kažnjivih djela u njemu
DELIMITER //

CREATE FUNCTION Broj_Kaznjivih_Djela_U_Slucaju(id_slucaj INT) RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE broj_kaznjivih_djela INT;

    SELECT COUNT(*) INTO broj_kaznjivih_djela
    FROM Kaznjiva_djela_u_slucaju
    WHERE id_slucaj = id_slucaj;

    RETURN broj_kaznjivih_djela;
END;

//
DELIMITER ;

SELECT Broj_Kaznjivih_Djela_U_Slucaju(5);

# u6)Koristeći gornju funkciju napiši upit koji će naći slučaj s najviše kažnjivih djela
SELECT
    S.ID AS id_slucaj,
    S.Naziv AS Naziv_Slucaja,
    Broj_Kaznjivih_Djela_U_Slucaju(S.ID) AS Broj_Kaznjivih_Djela
FROM Slucaj S
GROUP BY id_slucaj, Naziv_Slucaja
ORDER BY Broj_Kaznjivih_Djela DESC LIMIT 1;


# 8)Funkcija koje će za argument primati status slučajeva i vratiti će broj slučajeva sa tim statusom
DELIMITER //
CREATE FUNCTION broj_slucajeva_po_statusu(status VARCHAR(20)) RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE broj_slucajeva INT;

    IF status IS NULL THEN
        SET broj_slucajeva = 0;
    ELSE
        SELECT COUNT(*) INTO broj_slucajeva
        FROM Slucaj
        WHERE Status = status;
    END IF;

    RETURN broj_slucajeva;
END;

//
DELIMITER ;

# u7)Koristeći gornju funkciju napravi upit koji će dohvatiti sve statuse koji vrijede za više od 5 slučajeva (ili neki drugi broj)
SELECT 
    Status,
    COUNT(*) AS broj_slucajeva
FROM
    Slucaj
GROUP BY
    Status
HAVING
    broj_slucajeva_po_statusu(Status) > 5; -- Prilagodimo broj prema potrebi
*/
# 9)Funkcija koja za argument prima id_slucaj i računa njegovo trajanje; ako je završen, onda trajanje od početka do završetka, a ako nije, onda trajanje od početka do poziva funkcije
DELIMITER //
CREATE FUNCTION Informacije_o_slucaju(id_slucaj INT) RETURNS TEXT
DETERMINISTIC
BEGIN
    DECLARE status_slucaja VARCHAR(20);
    DECLARE trajanje_slucaja INT;

    SELECT 
        Status,
        CASE
            WHEN Zavrsetak IS NULL THEN DATEDIFF(NOW(), Pocetak)
            ELSE DATEDIFF(Zavrsetak, Pocetak)
        END AS trajanje
    INTO
        status_slucaja, trajanje_slucaja
    FROM 
        Slucaj
    WHERE 
        id = id_slucaj;

    RETURN CONCAT('Status slučaja: ', status_slucaja, '\nTrajanje slučaja: ', trajanje_slucaja, ' dana');
END;
//
DELIMITER ;

# u8)Napiši upit koji će dohvatiti sve slučajeve i pomoću funkcije iščitati njihove statuse i trajanja
    SELECT 
    Id AS 'ID slučaja',
    Naziv AS 'Naziv slučaja',
    Informacije_o_slucaju(Id) AS 'Informacije o slučaju'
FROM 
    Slucaj;

--10) Napiši funckiju koja će za zaposlenika definiranog parametron p_id_zaposlenik izbrojiti broj slučajeva na kojima je on bio voditelj i izračunati 
-- postotak rješenosti tih slučajeva te na temelju toga ispiše je li zaposlenik neuspješan (0%-49%) ili uspješan (50%-100%).

DELIMITER //
CREATE FUNCTION zaposlenik_slucaj(p_id_zaposlenik INT) RETURNS VARCHAR(100)
DETERMINISTIC
BEGIN

DECLARE l_broj INT;
DECLARE l_broj_rijeseni INT;
DECLARE l_postotak DECIMAL (5, 2);

SELECT COUNT(*) INTO l_broj
FROM slucaj
WHERE id_voditelj=p_id_zaposlenik;

SELECT COUNT(*) INTO l_broj_rijeseni
FROM slucaj
WHERE id_voditelj=p_id_zaposlenik AND status='Riješen';

SET l_postotak=(l_broj_rijeseni/l_broj)*100;

IF l_postotak<=49
THEN RETURN "neuspješan";
ELSE RETURN "uspješan";
END IF;

END//
DELIMITER ;

# u9)upit koji će za svakog zaposlenika pozvati funkciju uspješnosti i vratiti rezultat, osim ako nije vodio slučajeve, onda će vratiti odgovarajuću obavijest
    SELECT
    Z.Id AS 'ID zaposlenika',
    O.Ime_Prezime AS 'Ime i prezime zaposlenika',
    CASE
        WHEN (SELECT COUNT(*) FROM slucaj WHERE id_voditelj = Z.Id) > 0
        THEN zaposlenik_slucaj(Z.Id)
        ELSE 'Zaposlenik nije vodio slučajeve'
    END AS 'Uspješnost'
FROM
    Zaposlenik Z
JOIN
    Osoba O ON Z.id_osoba = O.id;

-- 11)Napiši funkciju koja će za osobu definiranu parametrom p_id_osoba vratiti "DA" ako je barem jednom bila oštećenik u nekom slučaju, a u 
-- protivnom će vratiti "NE."

DELIMITER //
CREATE FUNCTION osoba_ostecenik(p_id_osoba INT) RETURNS CHAR(2)
DETERMINISTIC
BEGIN

DECLARE l_broj INT;
SELECT COUNT(*) INTO l_broj
FROM slucaj
WHERE id_ostecenik=p_id_osoba;

IF l_broj>0
THEN RETURN "DA";
ELSE RETURN "NE";
END IF;

END//
DELIMITER ;


# u10)Prikaži sve osobe koje su oštećene više od 3 puta
    SELECT
    O.Id AS 'ID osobe',
    O.Ime_Prezime AS 'Ime i prezime osobe'
FROM
    Osoba O
WHERE
    osoba_ostecenik(O.Id) = 'DA'
GROUP BY
    O.Id, O.Ime_Prezime
HAVING
    COUNT(*) > 3;

# 11) Napiši funkciju koja će za osobu određenu predanim id_jem odrediti sve uloge koje je ta osoba imala u slučajevima
DELIMITER //

CREATE FUNCTION Uloge_Osobe_U_Slucajevima(osoba_id INT) RETURNS VARCHAR(255)
DETERMINISTIC
BEGIN
    DECLARE uloge VARCHAR(255);

    SELECT 
        CONCAT('Osoba je u slučajevima bila: ',
            CASE WHEN os.id = s.id_pocinitelj THEN 'pocinitelj ' ELSE '' END,
            CASE WHEN os.id = s.id_izvjestitelj THEN 'izvjestitelj ' ELSE '' END,
            CASE WHEN os.id = s.id_voditelj THEN 'voditelj ' ELSE '' END,
            CASE WHEN os.id = s.id_svjedok THEN 'svjedok ' ELSE '' END,
            CASE WHEN os.id = s.id_ostecenik THEN 'ostecenik ' ELSE '' END) INTO uloge
    FROM Slucaj s
    LEFT JOIN Osoba os ON os.id = osoba_id
    WHERE os.id IN (s.id_pocinitelj, s.id_izvjestitelj, s.id_voditelj, s.id_svjedok, s.id_ostecenik)
    LIMIT 1;

    # Ako osoba ima više od jedne uloge u istom slučaju, dodamo ih u rezultat
    SELECT 
        CONCAT('Osoba je u slučajevima bila: ',
            CASE WHEN os.id = s.id_pocinitelj THEN 'pocinitelj ' ELSE '' END,
            CASE WHEN os.id = s.id_izvjestitelj THEN 'izvjestitelj ' ELSE '' END,
            CASE WHEN os.id = s.id_voditelj THEN 'voditelj ' ELSE '' END,
            CASE WHEN os.id = s.id_svjedok THEN 'svjedok ' ELSE '' END,
            CASE WHEN os.id = s.id_ostecenik THEN 'ostecenik ' ELSE '' END) 
    INTO uloge
    FROM Slucaj s
    LEFT JOIN Osoba os ON os.id = osoba_id
    WHERE os.id IN (s.id_pocinitelj, s.id_izvjestitelj, s.id_voditelj, s.id_svjedok, s.id_ostecenik)
    AND os.id != s.id_pocinitelj AND os.id != s.id_izvjestitelj AND os.id != s.id_voditelj AND os.id != s.id_svjedok AND os.id != s.id_ostecenik;

    #Ako osoba nije bila ništa u slučajevima
    IF uloge IS NULL THEN
        SET uloge = 'Osoba nije bila u niti jednom slučaju';
    END IF;

    RETURN uloge;
END //

DELIMITER ;

# u10)UPIT KOJI ĆE DOHVATIT SVE OSOBE I NJIHOVE ULOGE U SLUČAJEVIMA
SELECT id, ime_prezime, Uloge_Osobe_U_Slucajevima(id) AS uloge
FROM Osoba;

-- DROP FUNCTION Sumnjivost_Osobe;
#12) Funkcija koja će vratiti je li osoba sumnjiva (već je osumnjičena na nekim slučajevima) ili nije sumnjiva 
 
DELIMITER //
 
CREATE FUNCTION Sumnjivost_Osobe(osoba_id INT) RETURNS VARCHAR(50)
DETERMINISTIC
BEGIN
    DECLARE broj_slucajeva INT;
    DECLARE sumnjivost VARCHAR(50);

    SELECT COUNT(*) INTO broj_slucajeva
    FROM Slucaj
    WHERE id_pocinitelj = osoba_id;

    IF broj_slucajeva > 10 THEN
        SET sumnjivost = 'Jako sumnjiva';
    ELSEIF broj_slucajeva > 0 AND broj_slucajeva <10 THEN
        SET sumnjivost = 'Umjereno sumnjiva';
    ELSE
        SET sumnjivost = 'Nije sumnjiva';
    END IF;

    RETURN sumnjivost;
END //

DELIMITER ;

# u11) Napiši upit koji će dohvatiti sve osobe, pa i policajce; nije nemoguće da policajac bude kriminalac :) i podatke o njihovoj sumnjivosti
SELECT id, ime_prezime, Sumnjivost_Osobe(id) AS sumnjivost
FROM Osoba;

# 13)Napiši funkciju koja će za dani odjel definiran id-jem koji joj prosljeđujemo za argument vratiti broj zaposlenih na tom odjelu u zadnjih 6 mjeseci
DELIMITER //

CREATE FUNCTION Broj_zaposlenih_6mj(odjel_id INT) 
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE broj_zaposlenih INT;

    SELECT COUNT(*) INTO broj_zaposlenih
    FROM Zaposlenik
    WHERE id_odjel = odjel_id
      AND datum_zaposlenja >= CURDATE() - INTERVAL 6 MONTH;

    RETURN broj_zaposlenih;
END //

DELIMITER ;
SELECT Broj_zaposlenih_6mj(5);

# u12)Napiši upit koji će vratiti id i naziv odjela koji je imao  najveći broj zaposlenih u zadnjih 6 mjeseci
SELECT id, naziv, Broj_zaposlenih_6mj(id) AS Broj_zaposlenih
FROM odjeli
ORDER BY Broj_zaposlenih DESC
LIMIT 1;

# 14)Napiši funkciju koja će za odjel definiran prosljeđenim id-jem dohvatiti broj zaposlenih i broj slučajeva. Zatim
# će računati koliko prosječno ima slučajeva po osobi na tom odjelu
DELIMITER //

CREATE FUNCTION Avg_Slucaj_Osoba_Odjel(odjel_id INT) RETURNS DECIMAL(10, 2)
DETERMINISTIC
BEGIN
    DECLARE broj_zaposlenih INT;
    DECLARE broj_slucajeva INT;
    DECLARE prosječan_broj_slucajeva DECIMAL(10, 2);


    SELECT COUNT(*) INTO broj_zaposlenih
    FROM Zaposlenik
    WHERE id_odjel = odjel_id;


    SELECT COUNT(*) INTO broj_slucajeva
    FROM Slucaj
    WHERE id_voditelj IN (SELECT id_osoba FROM Zaposlenik WHERE id_odjel = odjel_id);


    IF broj_zaposlenih > 0 THEN
        SET prosječan_broj_slucajeva = broj_slucajeva / broj_zaposlenih;
    ELSE
        SET prosjecan_broj_slučajeva = 0;
    END IF;

    RETURN prosjecan_broj_slučajeva;
END //

DELIMITER ;

SELECT Avg_Slucaj_Osoba_Odjel(5);

#u13)Koristeći ovu funkciju napiši upit za pronalaženje odjela s ispodprosječnim brojem slučajeva po osobi
SELECT naziv AS Nazivi_ispodprosječnih_odjela
FROM Odjeli
WHERE Avg_Slucaj_Osoba_Odjel(id) < 
    (SELECT AVG(Avg_Slucaj_Osoba_Odjel(id)) FROM Odjeli);

# Na isti način napiši i upit za pronalaženje odjela s iznadprosječnim brojem slučajeva po osobi
-- Upit za pronalaženje odjela s ispodprosječnim brojem slučajeva po osobi
SELECT id, naziv
FROM Odjeli
WHERE Avg_Slucaj_Osoba_Odjel(id) >
    (SELECT AVG(Avg_Slucaj_Osoba_Odjel(id)) FROM Odjeli);


# TRANSAKCIJE

#Kreiramo transakciju koja, uzimajući u obzir trenutačnu aktivnost pasa, dodjeljuje psa s najmanje slučajeva novom aktivnom slučaju.
# Imamo dosljedne podatke i psi su minimalno opterećeni.

# FOR UPDATE klauzula se koristi da bimo tijekom čitanja informacija o broju slučajeva za aktivne pse zaključali retke, 
#i spriječili druge transakcije (i druge korisnike na istoj bazi) da mijenjaju status pasa, 
#npr.umirove ga ili ga dodjele na nove slučajeve jer bi to onda narušilo cijeli koncept tega da dodijelimo psa s najmanje slučajeva na nobi. 

#  Koristimo  "REPEATABLE READ" da bi osigurali dosljednost podataka tijekom trajanja transakcije.
#  Budući da analiziramo trenutačnu aktivnost pasa i dodjelu pasa slučajevima, važno je da podaci o psima ostanu nepromijenjeni kako bi se izbjegle netočnosti
#  u dodjeli pasa novim slučajevima. "REPEATABLE READ" sprječava čitanje prljavih podataka (dirty reads - čitamo nešto ča druga transakcija mijenja, ali ni još commitala)
#i neponovljivih čitanja (non-repeatable reads),  (2 puta čitamo isti podatak, a on nema istu vrijednost)
#  čime se održava konzistentnost podataka i osigurava pouzdanost u obradi podataka u okviru transakcije. */

# Postavljanje izolacijskog nivoa na REPEATABLE READ
SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
START TRANSACTION;

# Pronađemo aktivne pse s brojem slučajeva
SELECT Pas.id, COUNT(Slucaj.id) AS broj_slucajeva
FROM Pas
LEFT JOIN Slucaj ON Pas.id = Slucaj.id_pas
WHERE Pas.status = 'Aktivan' AND Slucaj.status = 'Aktivan'
GROUP BY Pas.id
FOR UPDATE;

# Pronađemo psa s najmanje slučajeva
SELECT Pas.id
FROM Pas
LEFT JOIN Slucaj ON Pas.id = Slucaj.id_pas
WHERE Pas.status = 'Aktivan' AND Slucaj.status = 'Aktivan'
GROUP BY Pas.id
ORDER BY COUNT(Slucaj.id) ASC
LIMIT 1;

-- Dodijelimo psa s najmanje slučajeva novom slučaju
INSERT INTO Slucaj (naziv, pocetak, status, id_pas)
SELECT 'Novi slucaj', NOW(), 'Aktivan', Pas.id
FROM Pas
LEFT JOIN Slucaj ON Pas.id = Slucaj.id_pas
WHERE Pas.status = 'Aktivan' AND Slucaj.status = 'Aktivan'
GROUP BY Pas.id
ORDER BY COUNT(Slucaj.id) ASC
LIMIT 1;

-- Zatvorimo transakciju
COMMIT;





#########################################################################3
#  transakcija koja će omogućiti praćenje broja izvještaja za svaki slučaj
# Prva transakcija za dodavanje stupca broj_izvjestaja u tablicu Slucaj
SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
START TRANSACTION;

# Dodavanje stupca broj_izvjestaja u tablicu Slucaj
ALTER TABLE Slucaj
ADD COLUMN broj_izvjestaja INT DEFAULT 0;

# Zatvaranje prve transakcije
COMMIT;

# Postavljanje izolacijskog nivoa na REPEATABLE READ
SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
START TRANSACTION;

# Dohvaćanje ID-a osobe koja će biti autor izvještaja
SET @id_autor = (SELECT id FROM Osoba WHERE ime_prezime = 'Ime_Prezime' LIMIT 1);

# Dohvaćanje ID-a slučaja za koji ćemo kreirati izvještaj
SET @id_slucaj = (SELECT id FROM Slucaj WHERE naziv = 'NazivSlucaja' LIMIT 1);

# Privremena tablica za praćenje broja izvještaja po slučaju
CREATE TEMPORARY TABLE IF NOT EXISTS TempBrojIzvjestaja (
    id_slucaj INT,
    broj_izvjestaja INT
);

# Inicijalizacija broja izvještaja na 0 za odabrani slučaj
INSERT INTO TempBrojIzvjestaja (id_slucaj, broj_izvjestaja)
VALUES (@id_slucaj, 0)
ON DUPLICATE KEY UPDATE broj_izvjestaja = broj_izvjestaja;



# Ažuriranje broja izvještaja za odabrani slučaj u privremenoj tablici
UPDATE TempBrojIzvjestaja
SET broj_izvjestaja = broj_izvjestaja + 1
WHERE id_slucaj = @id_slucaj;

# Ažuriranje ukupnog broja izvještaja za odabrani slučaj u tablici Slucaj
UPDATE Slucaj
SET broj_izvjestaja = (SELECT broj_izvjestaja FROM TempBrojIzvjestaja WHERE id_slucaj = @id_slucaj)
WHERE id = @id_slucaj;

# Brisanje privremene tablice
DROP TEMPORARY TABLE IF EXISTS TempBrojIzvjestaja;

# Zatvaranje transakcije
COMMIT;

##################################################################################################
#  izraditi SQL transakciju koja će analizirati događaje u evidenciji (tablica Evidencija_dogadaja) i stvoriti tri nove tablice događaja prema godinama.
# Novo kreirane tablice trebaju sadržavati događaje koji su se dogodili u 2023., 2022. i 2021. godini.
# Postavljanje izolacijskog nivoa na REPEATABLE READ
SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
START TRANSACTION;

# Kreiranje tablice za događaje u 2023. godini
CREATE TABLE IF NOT EXISTS Događaji_2023 (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_slucaj INT,
    opis_dogadaja TEXT NOT NULL,
    datum_vrijeme DATETIME NOT NULL,
    id_mjesto INT NOT NULL,
    FOREIGN KEY (id_slucaj) REFERENCES Slucaj(id),
    FOREIGN KEY (id_mjesto) REFERENCES Mjesto(id)
);

# Insert događaja u 2023. godinu
INSERT INTO Događaji_2023 (id_slucaj, opis_dogadaja, datum_vrijeme, id_mjesto)
SELECT id_slucaj, opis_dogadaja, datum_vrijeme, id_mjesto
FROM Evidencija_dogadaja
WHERE YEAR(datum_vrijeme) = 2023;

# Kreiranje tablice za događaje u 2022. godini
CREATE TABLE IF NOT EXISTS Događaji_2022 (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_slucaj INT,
    opis_dogadaja TEXT NOT NULL,
    datum_vrijeme DATETIME NOT NULL,
    id_mjesto INT NOT NULL,
    FOREIGN KEY (id_slucaj) REFERENCES Slucaj(id),
    FOREIGN KEY (id_mjesto) REFERENCES Mjesto(id)
);

# Insert događaja u 2022. godinu
INSERT INTO Događaji_2022 (id_slucaj, opis_dogadaja, datum_vrijeme, id_mjesto)
SELECT id_slucaj, opis_dogadaja, datum_vrijeme, id_mjesto
FROM Evidencija_dogadaja
WHERE YEAR(datum_vrijeme) = 2022;

# Kreiranje tablice za događaje u 2021. godini
CREATE TABLE IF NOT EXISTS Događaji_2021 (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_slucaj INT,
    opis_dogadaja TEXT NOT NULL,
    datum_vrijeme DATETIME NOT NULL,
    id_mjesto INT NOT NULL,
    FOREIGN KEY (id_slucaj) REFERENCES Slucaj(id),
    FOREIGN KEY (id_mjesto) REFERENCES Mjesto(id)
);

# Insert događaja u 2021. godinu
INSERT INTO Događaji_2021 (id_slucaj, opis_dogadaja, datum_vrijeme, id_mjesto)
SELECT id_slucaj, opis_dogadaja, datum_vrijeme, id_mjesto
FROM Evidencija_dogadaja
WHERE YEAR(datum_vrijeme) = 2021;

# Zatvaranje transakcije
COMMIT;

# Napravi transakciju koja će pomoću procedure dodati 20 novih kažnjivih djela
# Ovo baš i ni pametna transakcija i maknut ćemo je iz projekta, jer ne služi ničemu...više je nastala iz znatiželje za provjerit dali funkcionira
SET SESSION TRANSACTION ISOLATION LEVEL 
READ COMMITTED;
START TRANSACTION;

CALL Dodaj_Novo_Kaznjivo_Djelo('Lažno prijavljivanje', 'Namjerno davanje lažnih informacija policiji ili drugim službama.', 4);
CALL Dodaj_Novo_Kaznjivo_Djelo('Sabotaža prometa', 'Namjerno uzrokovano kaos u prometu radi ometanja normalnog toka.', 5);
CALL Dodaj_Novo_Kaznjivo_Djelo('Povreda tajnosti pisma', 'Neovlašteno otvaranje i čitanje privatne pošte.', 3);
CALL Dodaj_Novo_Kaznjivo_Djelo('Prijetnja bombom', 'Prijeteće ponašanje koje uključuje prijetnju eksplozivnim napravama.', 8);
CALL Dodaj_Novo_Kaznjivo_Djelo('Zloupotreba položaja', 'Korištenje položaja u društvu radi stjecanja nepravedne koristi.', 6);
CALL Dodaj_Novo_Kaznjivo_Djelo('Zlostavljanje starijih osoba', 'Fizičko, emocionalno ili financijsko zlostavljanje starijih osoba.', 7);
CALL Dodaj_Novo_Kaznjivo_Djelo('Ratni zločin', 'Zločin protiv civilnog stanovništva tijekom rata ili sukoba.', 10);
CALL Dodaj_Novo_Kaznjivo_Djelo('Neovlaštena uporaba vojnog vozila', 'Korištenje vojnog vozila bez odobrenja.', 4);
CALL Dodaj_Novo_Kaznjivo_Djelo('Organizirani kriminal', 'Sudjelovanje u organiziranom kriminalu i kriminalnim udruženjima.', 9);
CALL Dodaj_Novo_Kaznjivo_Djelo('Podmićivanje svjedoka', 'Davanje mita svjedoku radi utjecaja na iskaz.', 6);
CALL Dodaj_Novo_Kaznjivo_Djelo('Sabotaža energetskog sustava', 'Namjerno oštećenje energetskog sustava radi ometanja opskrbe.', 8);
CALL Dodaj_Novo_Kaznjivo_Djelo('Nezakoniti izvoz oružja', 'Izvoz oružja bez odobrenja i u suprotnosti s zakonima.', 7);
CALL Dodaj_Novo_Kaznjivo_Djelo('Otmica djeteta', 'Nezakonito zadržavanje djeteta protiv volje roditelja ili skrbnika.', 5);
CALL Dodaj_Novo_Kaznjivo_Djelo('Napad na suverenitet', 'Napad na suverenitet države ili teritorijalni integritet.', 9);
CALL Dodaj_Novo_Kaznjivo_Djelo('Preprodaja ilegalnih supstanci', 'Neovlaštena proizvodnja i distribucija ilegalnih supstanci.', 6);
CALL Dodaj_Novo_Kaznjivo_Djelo('Zločin iz mržnje', 'Napad motiviran mržnjom prema nekoj skupini ljudi.', 7);
CALL Dodaj_Novo_Kaznjivo_Djelo('Pretvaranje oružja u automatsko', 'Nedopuštena modifikacija vatrenog oružja u automatsko.', 4);
CALL Dodaj_Novo_Kaznjivo_Djelo('Izazivanje nesreće', 'Namjerno izazivanje prometne ili druge nesreće s ozbiljnim posljedicama.', 5);
CALL Dodaj_Novo_Kaznjivo_Djelo('Zlostavljanje životinja u grupi', 'Nečovječno postupanje prema većem broju životinja.', 6);
CALL Dodaj_Novo_Kaznjivo_Djelo('Dijamantna pljačka', 'Oružana pljačka draguljarnice s namjerom krađe dijamanata.', 8);

COMMIT;


-- Napravi transakciju koja će omogućiti pregled svih službenih vozila. Neka se stupac id_vlasnik pretvori u stupac vlasnik tipa VARCHAR zato što je
-- vlasnik svih službenih vozila MUP
-- Postavljanje izolacijskog nivoa na REPEATABLE READ
-- Osiguraj da se prilikom izvođenja transakcije ne obriše ili izmjeni niti jedno od službenih vozila (zato imamo repeatable read i zaključavanje)
-- Postavljanje izolacijskog nivoa na REPEATABLE READ
SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
START TRANSACTION;

# Dodavanje novog stupca 'Napomena za službena vozila'
ALTER TABLE Vozilo
ADD COLUMN napomena_službena_vozila VARCHAR(255);

# Dobivanje zaključavanja za službena vozila
SELECT * FROM Vozilo WHERE sluzbeno_vozilo = 1 FOR UPDATE NOWAIT; -- pokušavamo zaključati retke, ali ako su već zaključani ne čekamo, nego odmah vraća grešku i prekine transakciju

# Kreiranje privremene tablice Pregled_službenih_vozila
CREATE TEMPORARY TABLE IF NOT EXISTS Pregled_službenih_vozila (
    id INT,
    marka VARCHAR(255),
    model VARCHAR(255),
    registracija VARCHAR(20),
    godina_proizvodnje INT,
    sluzbeno_vozilo BOOLEAN,
    vlasnik VARCHAR(255),
    napomena_službena_vozila VARCHAR(255)
);

# Kopiranje podataka o službenim vozilima u privremenu tablicu i postavljanje 'Napomena za službena vozila'
INSERT INTO Pregled_službenih_vozila (id, marka, model, registracija, godina_proizvodnje, sluzbeno_vozilo, vlasnik, napomena_službena_vozila)
SELECT id, marka, model, registracija, godina_proizvodnje, sluzbeno_vozilo, 'Ministarstvo Unutarnjih Poslova' AS vlasnik, 'Ministarstvo Unutarnjih Poslova' AS napomena_službena_vozila
FROM Vozilo
WHERE sluzbeno_vozilo = 1;

-- Zatvaranje transakcije
COMMIT;

# KORISNICI
# KORISNICI (autentifikacija/autorizacija)
# OVAKO SMO TESTIRALI KORISNIKE U SQL-u (napravimo ga, dodamo mu prava, oduzmemo mu prava, dropamo ga
# Kreiranje admin korisnika
/*

CREATE USER 'admin'@'localhost' IDENTIFIED BY 'admin_password';
GRANT ALL PRIVILEGES ON *.* TO 'admin'@'localhost' WITH GRANT OPTION;
FLUSH PRIVILEGES;
# prikaz ovlasti
SHOW GRANTS FOR 'admin'@'localhost';
# oduzimanje ovlasti
REVOKE ALL PRIVILEGES ON *.* FROM 'admin'@'localhost';
FLUSH PRIVILEGES;
# brisanje korisnika
DROP USER 'admin'@'localhost';


# Kreiranje HR korisnika
CREATE USER 'hr'@'localhost' IDENTIFIED BY 'hr_password';
GRANT SELECT, INSERT, UPDATE, DELETE ON Policija.Radno_mjesto TO 'hr'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE ON Policija.Odjeli TO 'hr'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE ON Policija.Zaposlenik TO 'hr'@'localhost';
FLUSH PRIVILEGES;
# prikaz ovlasti
SHOW GRANTS FOR 'hr'@'localhost';
# oduzimanje ovlasti
REVOKE ALL PRIVILEGES ON *.* FROM 'hr'@'localhost';
FLUSH PRIVILEGES;
# brisanje korisnika
DROP USER 'hr'@'localhost';

# Napravi korisnika za običnu fizičku osobu koja nije djelatnik policije i ima pristup samo osnovnijim, neklasificiranim tablicama
CREATE USER 'fizicka_osoba'@'localhost' IDENTIFIED BY 'fizicka_osoba_password';
GRANT SELECT ON Policija.Podrucje_uprave TO 'fizicka_osoba'@'localhost';
GRANT SELECT ON Policija.Mjesto TO 'fizicka_osoba'@'localhost';
GRANT SELECT ON Policija.Zgrada TO 'fizicka_osoba'@'localhost';
GRANT SELECT ON Policija.Radno_mjesto TO 'fizicka_osoba'@'localhost';
GRANT SELECT ON Policija.Odjeli TO 'fizicka_osoba'@'localhost';
GRANT SELECT (ime_prezime, datum_rodenja, spol, adresa, telefon, email) ON Policija.Osoba TO 'fizicka_osoba'@'localhost';
GRANT SELECT ON Policija.Kaznjiva_djela TO 'fizicka_osoba'@'localhost';
GRANT SELECT ON Policija.Sredstvo_utvrdivanja_istine TO 'fizicka_osoba'@'localhost';
FLUSH PRIVILEGES;

SHOW GRANTS FOR 'fizicka_osoba'@'localhost';
REVOKE ALL PRIVILEGES ON *.* FROM 'fizicka_osoba'@'localhost';
FLUSH PRIVILEGES;
# brisanje korisnika
DROP USER 'fizicka_osoba'@'localhost';

# Napravi korisnika 'detektiv' (ne znan dali je to egzaktan naziv, ali ok...valjda ni toliko bitno) koji će biti zadužen za prikupljanje dokaza na slučajevima, predmete, sredstva_utvrđivanja_istine i sastavljanje izvještaja
CREATE USER 'detektiv'@'localhost' IDENTIFIED BY 'detektiv_password';
GRANT SELECT, INSERT, UPDATE, DELETE ON Policija.Predmet TO 'detektiv'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE ON Policija.Slucaj TO 'detektiv'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE ON Policija.Sui TO 'detektiv'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE ON Policija.Sui_slucaj TO 'detektiv'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE ON Policija.Izvjestaji TO 'detektiv'@'localhost';
FLUSH PRIVILEGES;
*/



