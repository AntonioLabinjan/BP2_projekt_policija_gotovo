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
CREATE PROCEDURE IzlistajSlucajeveZaPosljednjih20Dana()
BEGIN
    DECLARE Datum_pocetka DATE;
    DECLARE Datum_zavrsetka DATE;
    
    -- Postavimo početni i završni datum za analizu (npr. 20 dana, ali možemo izmjeniti)
    SET Datum_pocetka = CURDATE() - INTERVAL 20 DAY;
    SET Datum_zavrsetka = CURDATE();
    
    SELECT S.ID AS Slucaj_id, S.Naziv AS Naziv_slucaja, S.Status, S.id_voditelj, O.ime_prezime
    FROM Slucaj S
    JOIN Zaposlenik Z ON S.VoditeljID = Z.id
JOIN Osoba O ON O.id = Z.id_osoba
    WHERE S.Pocetak BETWEEN Datum_pocetka AND Datum_zavrsetka;
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
# Napiši proceduru koja će za određeni slučaj izlistati sve događaje koji su se u njemu dogodili i poredati ih kronološki (OVO JE VIEW)
CREATE VIEW Pregled_Dogadaji AS
SELECT ed.Id, ed.opis_dogadaja, ed.datum_vrijeme, ed.id_slucaj
FROM Evidencija_dogadaja AS ed
ORDER BY ed.Datum_Vrijeme;

# Napiši PROCEDURU KOJA ZA ARGUMENT PRIMA OZNAKU PSA, A VRAĆA ID, IME i PREZIME VLASNIKA i BROJ SLUČAJEVA U KOJIMA JE PAS SUDJELOVAO
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

#Napiši proceduru koja će dohvaćati slučajeve koji sadrže određeno kazneno djelo i sortirati ih po vrijednosti zapljene silazno

CREATE VIEW Slucajevi_po_kaznjivom_djelu AS
SELECT Slucaj.id AS SlucajID, Slucaj.naziv AS NazivSlucaja, Zapljene.Vrijednost AS ZapljenaVrijednost
FROM Slucaj
JOIN Kaznjiva_djela_u_slucaju ON Slucaj.id = Kaznjiva_djela_u_slucaju.id_slucaj
JOIN Kaznjiva_djela ON Kaznjiva_djela_u_slucaju.id_kaznjivo_djelo = Kaznjiva_djela.id
LEFT JOIN Zapljene ON Slucaj.id = Zapljene.id_slucaj
ORDER BY Zapljene.Vrijednost DESC;

SELECT * FROM Slucajevi_po_kaznjivom_djelu WHERE Kaznjiva_djela.naziv = 'naziv_kaznenog_djela'

# Napiši proceduru koja će ispisati sve zaposlenike, imena i prezimena, adrese i brojeve telefona u jednom redu za svakog zaposlenika

# Napiši proceduru koja će ispisati sve slučajeve i za svaki slučaj ispisati voditelja i ukupan iznos zapljena. Ako nema pronađenih slučajeva, neka nas obavijesti o tome
CREATE VIEW PogledPodaciOSlucajevimaIZapljenama AS
SELECT
    Slucaj.id AS SlucajID,
    Osoba.ime_prezime AS VoditeljImePrezime,
    COALESCE(SUM(Zapljene.Vrijednost), 0) AS UkupanIznosZapljena
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
