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
    WHERE id = NEW.id_pas;

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
