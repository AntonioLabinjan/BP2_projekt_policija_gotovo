# Napiši proceduru za unos novog područja uprave
DELIMITER //

CREATE PROCEDURE Dodaj_Novo_Podrucje_Uprave(IN p_naziv VARCHAR(255))
BEGIN
    INSERT INTO Podrucje_uprave (naziv) VALUES (p_naziv);
END //

DELIMITER ;
CALL Dodaj_Novo_Podrucje_Uprave ('Grimalda');
SELECT * FROM Podrucje_uprave;
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
    IN p_telefon VARCHAR(20),
    IN p_email VARCHAR(255)
)
BEGIN
    INSERT INTO Osoba (ime_prezime, datum_rodenja, oib, spol, adresa, telefon, email)
    VALUES (p_ime_prezime, p_datum_rodenja, p_oib, p_spol, p_adresa, p_telefon, p_email);
END //

DELIMITER ;

# Procedura za unos novog zaposlenika
SELECT * FROM Zaposlenik;
DELIMITER //

CREATE PROCEDURE Dodaj_Novog_Zaposlenika(
    IN p_datum_zaposlenja DATETIME,
    IN p_datum_izlaska_iz_sluzbe DATETIME,
    IN p_id_nadređeni INT,
    IN p_id_radno_mjesto INT,
    IN p_id_odjel INT,
    IN p_id_zgrada INT,
    IN p_id_mjesto INT,
    IN p_id_osoba INT
)
BEGIN
    INSERT INTO Zaposlenik (datum_zaposlenja, datum_izlaska_iz_sluzbe, id_nadređeni, id_radno_mjesto, id_odjel, id_zgrada, id_mjesto, id_osoba)
    VALUES (p_datum_zaposlenja, p_datum_izlaska_iz_sluzbe, p_id_nadređeni, p_id_radno_mjesto, p_id_odjel, p_id_zgrada, p_id_mjesto, p_id_osoba);
END //

DELIMITER ;

# Procedura za unos novog vozila; ukoliko je vozilo službeno, ono će imati id_vlasnik koji će predstavljati službenika koji najviše koristi vozilo, ali postaviti će se napomena da je vlasnik MUP

SELECT * FROM vozilo;
DROP PROCEDURE Dodaj_Novo_Vozilo;

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
    -- Dodaj stupac napomena ako već ne postoji
    IF NOT EXISTS (
        SELECT * 
        FROM INFORMATION_SCHEMA.COLUMNS 
        WHERE TABLE_NAME = 'Vozilo' AND COLUMN_NAME = 'napomena'
    ) THEN
        ALTER TABLE Vozilo ADD COLUMN napomena VARCHAR(255);
    END IF;
    
    -- Postavi napomenu na 'Vlasnik MUP' ako je vozilo službeno
    IF p_sluzbeno_vozilo = 1 THEN
        SET @napomena = 'Vlasnik MUP';
    ELSE
        SET @napomena = NULL;  -- Možete postaviti neku drugu vrijednost ako nije službeno vozilo
    END IF;

    INSERT INTO Vozilo (marka, model, registracija, godina_proizvodnje, id_vlasnik, napomena)
    VALUES (p_marka, p_model, p_registracija, p_godina_proizvodnje, p_id_vlasnik, @napomena);
END //

DELIMITER ;


CALL Dodaj_Novo_Vozilo ('Chevrolet', 'Camaro', 'ZG-222-FF', 2019, 1, 3);
SELECT * FROM vozilo;
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

# Napiši proceduru koja će svim zatvorenicima koji su još u zatvoru (datum odlaska iz zgrade zatvora im je NULL) dodati novi stupac sa brojem dana u zatvoru koji će dobiti tako da računa broj dana o dana dolaska u zgradu do današnjeg dana
# Ubacit scheduled dnevno izvođenje procedure
DROP PROCEDURE AzurirajPodatkeZatvor;
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
-- Aktivacija Event Schedulera ako već nije aktivan
SET GLOBAL event_scheduler = ON;

-- Stvaranje Eventa
DELIMITER //

CREATE EVENT IF NOT EXISTS Dnevno_odbrojavanje
ON SCHEDULE
    EVERY 1 DAY
    STARTS CURRENT_DATE
DO
    CALL AzurirajPodatkeZatvor();

//

DELIMITER ;
    # Napiši proceduru koja će omogućiti da pretražujemo slučajeve preko neke ključne riječi iz opisa # OVO SU SADA 2 POGLEDA I 1 UPIT
CREATE VIEW Svi_slucajevi AS
SELECT * FROM Slucaj;
CREATE VIEW Filtrirani_slucajevi AS
SELECT * FROM SviSlucajevi
WHERE Opis LIKE CONCAT('%', kljucna_rijec, '%');
SELECT * FROM Filtrirani_slucajevi WHERE kljucnarijec = 'neka_kljucna_rijec';


# Napiši proceduru koja će kreirati novu privremenu tablicu u kojoj će se prikazati svi psi i broj slučajeva na kojima su radili. Zatim će dodati novi stupac tablici pas i u njega upisati "nagrađeni pas" kod svih pasa koji su radili na više od 15 slučajeva 
DELIMITER //
CREATE PROCEDURE Godisnje_nagrađivanje_pasa()
BEGIN
    
    CREATE TEMPORARY TABLE Temp_Psi (id_pas	INT, BrojSlucajeva INT);

    
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
# Napiši proceduru koja će generirati izvještaje o slučajevima u zadnjih 20 dana (ovaj broj se može prilagođavati)
DELIMITER //
CREATE PROCEDURE GenerirajIzvjestajeOSlučajevima()
BEGIN
    DECLARE DatumPocetka DATE;
    DECLARE DatumZavrsetka DATE;
    
    -- Postavimo početni i završni datum za analizu (npr. 20 dana, ali moremo izmjenit)
    SET DatumPocetka = CURDATE() - INTERVAL 20 DAY;
    SET DatumZavrsetka = CURDATE();
    
    CREATE TEMPORARY TABLE TempIzvjestaji (
        SlucajID INT,
        NazivSlucaja VARCHAR(255),
        Pocetak DATE,
        Zavrsetak DATE,
        Status VARCHAR(50)
    );

    
    INSERT INTO TempIzvjestaji (SlucajID, NazivSlucaja, Pocetak, Zavrsetak, Status)
    SELECT S.ID, S.Naziv, S.Pocetak, S.Zavrsetak, S.Status
    FROM Slucaj S
    WHERE S.Pocetak BETWEEN DatumPocetka AND DatumZavrsetka;
    
    
    SELECT * FROM TempIzvjestaji;
    
    
    DROP TEMPORARY TABLE TempIzvjestaji;
END;
//
DELIMITER ;

# Napiši proceduru koja će za određenu osobu kreirati potvrdu o nekažnjavanju. To će napraviti samo u slučaju da osoba stvarno nije evidentirana niti u jednom slučaju kao počinitelj. Ukoliko je osoba kažnjavana i za to ćemo dobiti odgovarajuću obavijest. Također,ako uspješno izdamo potvrdu, neka se prikaže i datum izdavanja
# Neka id_slucaj za izvještaj bude 999 kako ne bismo morali mijenjati shemu baze
DROP PROCEDURE ProvjeriNekažnjavanje;
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
# Napiši proceduru koja će za određeni slučaj izlistati sve događaje koji su se u njemu dogodili i poredati ih kronološki
DELIMITER //

CREATE PROCEDURE Izlistaj_dogadjaje(IN id_slucaj INT)
BEGIN
    SELECT ed.Id, ed.opis_dogadaja,ed.datum_vrijeme
    FROM Evidencija_dogadaja	AS ed
    WHERE ed.id_slucaj = id_slucaj
    ORDER BY ed.Datum_Vrijeme;
END //

DELIMITER ;
CALL Izlistaj_dogadjaje(1);
# Napiši PROCEDURU KOJA ZA ARGUMENT PRIMA OZNAKU PSA, A VRAĆA ID, IME i PREZIME VLASNIKA i BROJ SLUČAJEVA U KOJIMA JE PAS SUDJELOVAO
DELIMITER //
CREATE PROCEDURE Info_pas(IN Oznaka VARCHAR(255))
BEGIN
    SELECT
        O.Id AS Vlasnik_id,
        O.Ime_Prezime AS Trener,
        COUNT(S.Id) AS BrojSlucajeva
    FROM
        Pas AS P
    INNER JOIN Slucaj AS S ON P.Id = S.id_pas
    INNER JOIN Osoba AS O ON P.Id_trener = O.Id
    WHERE
        P.Oznaka = Oznaka
    GROUP BY
        P.Id;
END
//
DELIMITER ;
CALL Info_pas('K9-111');
SELECT Oznaka FROM Pas;
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

#Napiši proceduru koja će dohvaćati slučajeve koji sadrže određeno kazneno djelo i sortirati ih po vrijednosti zapljene silazno
DROP PROCEDURE Dohvati_Slucajeve_Po_Kaznenom_Djelu_Sortirano;
DELIMITER //
CREATE PROCEDURE Dohvati_Slucajeve_Po_Kaznenom_Djelu_Sortirano(kaznenoDjeloNaziv VARCHAR(255))
BEGIN
    DECLARE slucaj_id INT;
    DECLARE slucaj_naziv VARCHAR(255);
    DECLARE zapljena_vrijednost NUMERIC (65,8);

    DECLARE slucajevi_Cursor CURSOR FOR
        SELECT Slucaj.id, Slucaj.naziv, Zapljene.Vrijednost
        FROM Slucaj
        JOIN Kaznjiva_djela_u_slucaju ON Slucaj.id = Kaznjiva_djela_u_slucaju.id_slucaj
        JOIN Kaznjiva_djela ON Kaznjiva_djela_u_slucaju.id_kaznjivo_djelo = Kaznjiva_djela.id
        LEFT JOIN Zapljene ON Slucaj.id = Zapljene.id_slucaj
        WHERE Kaznjiva_djela.naziv = kaznenoDjeloNaziv
        ORDER BY Zapljene.Vrijednost DESC;

    OPEN slucajevi_Cursor;

    slucaj_loop: LOOP
        FETCH slucajevi_Cursor INTO slucaj_id, slucaj_naziv, zapljena_vrijednost;
        IF slucaj_id IS NULL THEN
            LEAVE slucaj_loop;
        END IF;
        SELECT slucaj_naziv, zapljena_vrijednost;
    END LOOP;

    CLOSE slucajevi_Cursor;
END //
DELIMITER ;
CALL Dohvati_Slucajeve_Po_Kaznenom_Djelu_Sortirano('Ubojstvo');

# Napiši proceduru koja će ispisati sve zaposlenike, imena i prezimena, adrese i brojeve telefona u jednom redu za svakog zaposlenika
DROP PROCEDURE IF EXISTS IspisiInformacijeZaposlenika;
DELIMITER //

CREATE PROCEDURE IspisiInformacijeZaposlenika() # Izbacit će jaaako veliki broj podataka, pa ju je poželjno zaustaviti u nekom trenutku ručno
BEGIN

    DECLARE zaposlenik_id INT;
    DECLARE zaposlenik_ime_prezime VARCHAR(255);
    DECLARE zaposlenik_adresa VARCHAR(255);
    DECLARE zaposlenik_telefon VARCHAR(20);


    DECLARE zaposleniciCursor CURSOR FOR
        SELECT Zaposlenik.id, Osoba.ime_prezime, Osoba.adresa, Osoba.telefon
        FROM Zaposlenik
        JOIN Osoba ON Zaposlenik.id_osoba = Osoba.id;


    DECLARE CONTINUE HANDLER FOR NOT FOUND
    BEGIN

        SELECT 'Nema dostupnih informacija o zaposlenicima.' AS Info;
    END;

    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
    BEGIN

        SELECT 'Došlo je do greške u izvršavanju SQL upita.' AS Info;
    END;


    OPEN zaposleniciCursor;

    zaposlenik_loop: LOOP

        FETCH zaposleniciCursor INTO zaposlenik_id, zaposlenik_ime_prezime, zaposlenik_adresa, zaposlenik_telefon;


        IF zaposlenik_id IS NULL THEN
            LEAVE zaposlenik_loop;
        END IF;


        SELECT CONCAT('Zaposlenik: ', zaposlenik_ime_prezime, ', Adresa: ', zaposlenik_adresa, ', Telefon: ', zaposlenik_telefon) AS Info;
    END LOOP;


    CLOSE zaposleniciCursor;
END //

DELIMITER ;

CALL IspisiInformacijeZaposlenika();

CALL IspisiInformacijeZaposlenika;
# Napiši proceduru koja će ispisati sve slučajeve i za svaki slučaj ispisati voditelja i ukupan iznos zapljena. Ako nema pronađenih slučajeva, neka nas obavijesti o tome
#DROP PROCEDURE IspisiPodatkeOSlucajevimaIZapljenama;
DELIMITER //

CREATE PROCEDURE IspisiPodatkeOSlucajevimaIZapljenama()
BEGIN
    -- Kreiramo privremenu tablicu za međurezultate
    CREATE TEMPORARY TABLE IF NOT EXISTS TempRezultati (
        id INT,
        voditeljImePrezime VARCHAR(255),
        ukupanIznosZapljena NUMERIC(10, 2)
    );

    -- Ubacite podatke o slučajevima, voditeljima i ukupnom iznosu zapljena u tablicu za privremene rezultate
    INSERT INTO TempRezultati (id, voditeljImePrezime, ukupanIznosZapljena)
    SELECT
        Slucaj.id,
        Osoba.ime_prezime AS voditeljImePrezime,
        COALESCE(SUM(Zapljene.Vrijednost), 0) AS ukupanIznosZapljena # sumiraj sve zapljene koje nisu NULL (za to služi COALESCE)
    FROM Slucaj
    JOIN Zaposlenik ON Slucaj.id_voditelj = Zaposlenik.id
    JOIN Osoba ON Zaposlenik.id_osoba = Osoba.id
    LEFT JOIN Zapljene ON Slucaj.id = Zapljene.id_slucaj
    GROUP BY Slucaj.id, Osoba.ime_prezime;

    -- Ispisivanje informacija o slučaju
    SELECT * FROM TempRezultati;

    -- Ispis obavijesti ako nema pronađenih redaka
    IF (SELECT COUNT(*) FROM TempRezultati) = 0 THEN
        SELECT 'Nema podataka o slučajevima i zapljenama.' AS Napomena;
    END IF;

    -- Obrišite tablicu za privremene rezultate
    DROP TEMPORARY TABLE IF EXISTS TempRezultati;

END //

DELIMITER ;


CALL IspisiPodatkeOSlucajevimaIZapljenama;

# Napiši proceduru koja će služiti za unaprijeđenje policijskih službenika na novo radno mjesto. Ako je novo radno mjesto jednako onom radnom mjestu osobe koja im je prije bila nadređena, postaviti će id_nadređeni na NULL
DROP PROCEDURE UnaprijediPolicijskogSluzbenika;
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
CALL ProvjeriIstekZatvorskeKazne();
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
    -- Provjerimo postojanje stupca prije dodavanja
    IF NOT EXISTS (
        SELECT * FROM INFORMATION_SCHEMA.COLUMNS
        WHERE TABLE_NAME = 'Osoba' AND COLUMN_NAME = 'obavijest'
    ) THEN
        -- Dodamo stupac obavijest u tablicu Osoba
        ALTER TABLE Osoba
        ADD COLUMN obavijest VARCHAR(50);
    END IF;

    
    OPEN cur;

    read_loop: LOOP
        FETCH cur INTO osoba_id, datum_zavrsetka_slucaja;

        IF done = 1 THEN
            LEAVE read_loop;
        END IF;

        -- Izračunamo ukupnu kaznu za osobu
        SET ukupna_kazna = (
            SELECT COALESCE(SUM(K.predvidena_kazna), 0)
            FROM Slucaj S
            LEFT JOIN Kaznjiva_djela_u_slucaju KS ON S.id = KS.id_slucaj
            LEFT JOIN Kaznjiva_djela K ON KS.id_kaznjivo_djelo = K.id
            WHERE S.id_pocinitelj = osoba_id
        );

        -- Provjerimo je li datum zavrsetka_slucaja + ukupna_kazna manji od današnjeg datuma
        SET danas = NOW();
        IF DATE_ADD(datum_zavrsetka_slucaja, INTERVAL ukupna_kazna DAY) <= danas THEN
            -- Istekla je zatvorska kazna, dodaj obavijest u stupac obavijest u tablici Osoba
            UPDATE Osoba
            SET obavijest = 'Kazna je istekla'
            WHERE Id = osoba_id;
        END IF;
    END LOOP;

    -- Zatvorimo kursor
    CLOSE cur;

END //

DELIMITER ;
CALL ProvjeriIstekZatvorskeKazne();
SELECT * FROM Osoba;
DELIMITER //

CREATE EVENT IF NOT EXISTS `ProvjeraIstekaKazniEvent`
ON SCHEDULE EVERY 1 DAY
DO
BEGIN
    CALL ProvjeriIstekZatvorskeKazne();
END //

DELIMITER ;
