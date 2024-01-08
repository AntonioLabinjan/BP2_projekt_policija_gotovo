# FUNKCIJE + upiti za funkcije
# Napiši funkciju koja kao argument prima naziv kaznenog djela i vraća naziv KD, predviđenu kaznu i broj pojavljivanja KD u slučajevima
DROP FUNCTION KDInfo;
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

# Napiši upit koji će koristeći ovu funkciju izlistati sva kaznena djela koja su se dogodila u 2023. godini (ili nekoj drugoj) i njihov broj pojavljivanja

    SELECT
    KDInfo(KD.Naziv) AS KaznjivoDjeloInfo,
    COUNT(KS.id_kaznjivo_djelo) AS BrojPojavljivanja
FROM Kaznjiva_Djela_u_Slucaju KS
INNER JOIN Kaznjiva_djela KD ON KS.id_kaznjivo_djelo = KD.ID
INNER JOIN Slucaj S ON KS.id_slucaj = S.ID
WHERE YEAR(S.Pocetak) = 2023
GROUP BY KD.Naziv;


# Napiši funkciju koja će vratiti informacije o osobi prema broju telefona
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

# Napiši upit koji će izlistati sve brojeve telefona i informacije o tim osobama, ali samo ako te osobe nisu policijski službenici
 
    SELECT
    Telefon,
    InformacijeOOsobiPoTelefonu(Telefon) AS OsobaInfo
FROM Osoba
WHERE Osoba.id NOT IN(SELECT id_osoba FROM Zaposlenik);


SET SQL_safe_updates = 0;
# Napiši funkciju koja će za određeni predmet vratiti slučaj u kojem je taj predmet dokaz i osobu koja je u tom slučaju osumnjičena
DROP FUNCTION DohvatiSlucajIOsobu;


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

# Napiši upit koji izdvaja informacije o određenom predmetu, uključujući naziv predmeta, naziv povezanog slučaja i ime i prezime osumnjičenika u tom slučaju, koristeći funkciju DohvatiSlucajIOsobu za dobijanje dodatnih detalja za taj predmet.
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

# Napravi funkciju koja će za argument primati sredstvo utvrđivanja istine, zatim će prebrojiti u koliko je slučajeva to sredstvo korišteno, prebrojit će koliko je slučajeva od tog broja riješeno, te će na temelju ta 2 podatka izračunati postotak rješenosti slučajeva gdje se odabrano sredstvo koristi
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

# Koristeći gornju funkciju prikaži sredstva koja imaju rješenost veću od 50% (riješeno je više od 50% slučajeva koja koriste to sredstvo)
SELECT
    Sredstvo_utvrdivanja_istine.ID AS id_sredstvo,
    Sredstvo_utvrdivanja_istine.Naziv AS Naziv_Sredstva,
    IzracunajPostotakRjesenosti(Sredstvo_utvrdivanja_istine.ID) AS postotak
FROM Sredstvo_utvrdivanja_istine
WHERE IzracunajPostotakRjesenosti(Sredstvo_utvrdivanja_istine.ID) > 50.00;

# Napiši funkciju koja će za argument primati registarske tablice vozila, a vraćat će informaciju je li se to vozilo pojavilo u nekom od slučajeva, tako što će provjeriti je li se id_osoba koji referencira vlasnika pojavio u nekom slučaju kao pocinitelj_id. Ako se pojavilo, vraćat će "Vozilo se pojavljivalo u slučajevima", a ako se nije pojavilo, vraćat će "Vozilo se nije pojavljivalo u slučajevima". Također, vratit će i broj koliko se puta vozilo pojavilo
DROP FUNCTION Provjera_vozila;
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



# Koristeći funkciju prikažite vozila koja se pojavljuju iznad prosjeka (u iznadprosječnom broju)
CREATE TEMPORARY TABLE Prosjek_Pojavljivanja AS
SELECT AVG(count) AS Prosjek
FROM (
    SELECT COUNT(*) AS count
    FROM Slucaj
    INNER JOIN Vozilo ON Slucaj.id_pocinitelj = Vozilo.id_vlasnik
    GROUP BY Vozilo.Registracija
) AS Podupit1;

SELECT V.Registracija, Provjera_vozila(V.Registracija) AS StatusVozila
FROM Vozilo V
INNER JOIN (
    SELECT Vozilo.Registracija, COUNT(*) AS count
    FROM Slucaj
    INNER JOIN Vozilo ON Slucaj.id_pocinitelj = Vozilo.id_vlasnik
    GROUP BY Vozilo.Registracija
) AS Podupit2 ON V.Registracija = Podupit2.Registracija
WHERE Podupit2.count > (SELECT Prosjek FROM Prosjek_Pojavljivanja);



# Funkcija koja za argument prima id podrucja uprave i vraća broj mjesta u tom području te naziv svih mjesta u 1 stringu
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

# Napravi funkciju koje će za slučej predan preko id-ja dohvatiti broj kažnjivih djela u njemu
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

# Koristeći gornju funkciju napiši upit koji će naći slučaj s najviše kažnjivih djela
SELECT
    S.ID AS id_slucaj,
    S.Naziv AS Naziv_Slucaja,
    Broj_Kaznjivih_Djela_U_Slucaju(S.ID) AS Broj_Kaznjivih_Djela
FROM Slucaj S
GROUP BY id_slucaj, Naziv_Slucaja
ORDER BY Broj_Kaznjivih_Djela DESC LIMIT 1;


# Funkcija koje će za argument primati status slučajeva i vratiti će broj slučajeva sa tim statusom
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

# Koristeći gornju funkciju napravi upit koji će dohvatiti sve statuse koji vrijede za više od 5 slučajeva (ili neki drugi broj)
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
# Funkcija koja za argument prima id_slucaj i računa njegovo trajanje; ako je završen, onda trajanje od početka do završetka, a ako nije, onda trajanje od početka do poziva funkcije
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

# Napiši upit koji će dohvatiti sve slučajeve i pomoću funkcije iščitati njihove statuse i trajanja
    SELECT 
    Id AS 'ID slučaja',
    Naziv AS 'Naziv slučaja',
    Informacije_o_slucaju(Id) AS 'Informacije o slučaju'
FROM 
    Slucaj;

-- Napiši funckiju koja će za zaposlenika definiranog parametron p_id_zaposlenik izbrojiti broj slučajeva na kojima je on bio voditelj i izračunati 
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

# upit koji će za svakog zaposlenika pozvati funkciju uspješnosti i vratiti rezultat, osim ako nije vodio slučajeve, onda će vratiti odgovarajuću obavijest
    SELECT
    Z.Id AS 'ID zaposlenika',
    Z.Ime_Prezime AS 'Ime i prezime zaposlenika',
    CASE
        WHEN (SELECT COUNT(*) FROM slucaj WHERE id_voditelj = Z.Id) > 0
        THEN zaposlenik_slucaj(Z.Id)
        ELSE 'Zaposlenik nije vodio slučajeve'
    END AS 'Uspješnost'
FROM
    Zaposlenik Z;

-- Napiši funkciju koja će za osobu definiranu parametrom p_id_osoba vratiti "DA" ako je barem jednom bila oštećenik u nekom slučaju, a u 
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


# Prikaži sve osobe koje su oštećene više od 3 puta
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

# Napiši funkciju koja će za osobu određenu predanim id_jem odrediti sve uloge koje je ta osoba imala u slučajevima
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

# UPIT KOJI ĆE DOHVATIT SVE OSOBE I NJIHOVE ULOGE U SLUČAJEVIMA
SELECT id, ime_prezime, Uloge_Osobe_U_Slucajevima(id) AS uloge
FROM Osoba;
*/
DROP FUNCTION Sumnjivost_Osobe;
DELIMITER //
# Funkcija koja će vratiti je li osoba sumnjiva (već je osumnjičena na nekim slučajevima) ili nije sumnjiva 
 
 
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

# Napiši upit koji će dohvatiti sve osobe, pa i policajce; nije nemoguće da policajac bude kriminalac :) i podatke o njihovoj sumnjivosti
SELECT id, ime_prezime, Sumnjivost_Osobe(id) AS sumnjivost
FROM Osoba;

# Napiši funkciju koja će za dani odjel definiran id-jem koji joj prosljeđujemo za argument vratiti broj zaposlenih na tom odjelu u zadnjih 6 mjeseci
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

# Napiši upit koji će vratiti id i naziv odjela koji je imao  najveći broj zaposlenih u zadnjih 6 mjeseci
SELECT id, naziv, Broj_zaposlenih_6mj(id) AS Broj_zaposlenih
FROM odjeli
ORDER BY Broj_zaposlenih DESC
LIMIT 1;

# Napiši funkciju koja će za odjel definiran prosljeđenim id-jem dohvatiti broj zaposlenih i broj slučajeva. Zatim
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

#Koristeći ovu funkciju napiši upit za pronalaženje odjela s ispodprosječnim brojem slučajeva po osobi
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

*/
