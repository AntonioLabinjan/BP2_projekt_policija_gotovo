/*
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
*/
/* Procedura za unos novog vozila
DELIMITER //

CREATE PROCEDURE Dodaj_Novo_Vozilo(
    IN p_marka VARCHAR(255),
    IN p_model VARCHAR(255),
    IN p_registracija VARCHAR(20),
    IN p_godina_proizvodnje INT,
    IN p_tip_vozila INT, -- 1 za službeno, 0 za privatno
    IN p_id_vlasnik INT
)
BEGIN
    DECLARE v_vlasnik VARCHAR(255);
    
    IF p_tip_vozila = 1 THEN
        SET v_vlasnik = 'Ministarstvo unutarnjih poslova';
    ELSE
        -- Ako nije službeno vozilo, koristimo predani ID vlasnika
        SELECT ime_prezime INTO v_vlasnik FROM Osoba WHERE id = p_id_vlasnik;
    END IF;
    
    INSERT INTO Vozilo (marka, model, registracija, godina_proizvodnje, sluzbeno_vozilo, id_vlasnik)
    VALUES (p_marka, p_model, p_registracija, p_godina_proizvodnje, p_tip_vozila, v_vlasnik);
END //

DELIMITER ;
/*
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
*/
*/
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

# Napiši proceduru koja će omogućiti da pretražujemo slučajeve preko neke ključne riječi iz opisa # OVO SU SADA 2 POGLEDA I 1 UPIT
CREATE VIEW Svi_slucajevi AS
SELECT * FROM Slucaj;
CREATE VIEW Filtrirani_slucajevi AS
SELECT * FROM Svi_slucajevi
WHERE Opis LIKE CONCAT('%', kljucna_rijec, '%');
SELECT * FROM Filtrirani_slucajevi WHERE kljucna_rijec = 'blabla'; #ovo naravno mijenjamo


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

# Napiši proceduru koja će generirati izvještaje o slučajevima u zadnjih 20 dana (ovaj broj se može prilagođavati)
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
DROP VIEW Slucajevi_u_posljednjih_n_dana;
SELECT * FROM Slucajevi_u_posljednjih_n_dana;
SELECT * FROM slucaj;
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


#Napiši proceduru koja će dohvaćati slučajeve koji sadrže određeno kazneno djelo i sortirati ih po vrijednosti zapljene silazno
# Pretvoreno u pogled
CREATE VIEW Slucajevi_po_kaznjivom_djelu AS
SELECT Slucaj.id AS SlucajID, Slucaj.naziv AS NazivSlucaja, Zapljene.Vrijednost AS ZapljenaVrijednost
FROM Slucaj
JOIN Kaznjiva_djela_u_slucaju ON Slucaj.id = Kaznjiva_djela_u_slucaju.id_slucaj
JOIN Kaznjiva_djela ON Kaznjiva_djela_u_slucaju.id_kaznjivo_djelo = Kaznjiva_djela.id
LEFT JOIN Zapljene ON Slucaj.id = Zapljene.id_slucaj
ORDER BY Zapljene.Vrijednost DESC;

SELECT * FROM Slucajevi_po_kaznjivom_djelu WHERE Kaznjiva_djela.naziv = 'naziv_kaznenog_djela'


# Napiši proceduru koja će ispisati sve slučajeve i za svaki slučaj ispisati voditelja i ukupan iznos zapljena. Ako nema pronađenih slučajeva, neka nas obavijesti o tome
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
# Ova je grda
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

*/

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
