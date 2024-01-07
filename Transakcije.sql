#Kreirajte transakciju koja, uzimajući u obzir trenutačnu aktivnost pasa, dodjeljuje psa s najmanje slučajeva novom aktivnom slučaju. Rješenje treba osigurati dosljednost podataka i minimalno opterećenje pasa.
/*
 FOR UPDATE klauzula koristi se kako bi se tijekom čitanja informacija o broju slučajeva za aktivne pse zaključali retci, spriječavajući druge transakcije da mijenjaju status pasa, primjerice umirovljenje ili dodjelu na nove slučajeve. 
 Time se osigurava da pas s najmanje slučajeva ostane nepromijenjen tijekom trajanja transakcije, održavajući dosljednost podataka u kontekstu dodjele pasa novim slučajevima.
*/
#  U ovom zadatku koristimo izolacijski nivo "REPEATABLE READ" kako bi osigurao dosljednost podataka tijekom trajanja transakcije.
#  Budući da analiziramo trenutačnu aktivnost pasa i dodjelu pasa slučajevima, važno je da podaci o psima ostanu nepromijenjeni kako bi se izbjegle netočnosti
#  u dodjeli pasa novim slučajevima. "REPEATABLE READ" sprječava čitanje prljavih podataka (dirty reads) i neponovljivih čitanja (non-repeatable reads), 
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

-- Pronađemo psa s najmanje slučajeva
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

# Dodavanje novog izvještaja
INSERT INTO Izvjestaji (naslov, sadrzaj, id_autor, id_slucaj)
VALUES ('Naslov izvještaja', 'Sadržaj izvještaja.', @id_autor, @id_slucaj);

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

-- Dodavanje novog stupca 'Napomena za službena vozila'
ALTER TABLE Vozilo
ADD COLUMN napomena_službena_vozila VARCHAR(255);

-- Dobivanje zaključavanja za službena vozila
SELECT * FROM Vozilo WHERE sluzbeno_vozilo = 1 FOR UPDATE NOWAIT; -- pokušavamo zaključati retke, ali ako su već zaključani ne čekamo, nego odmah vraća grešku i prekine transakciju

-- Kreiranje privremene tablice Pregled_službenih_vozila
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

-- Kopiranje podataka o službenim vozilima u privremenu tablicu i postavljanje 'Napomena za službena vozila'
INSERT INTO Pregled_službenih_vozila (id, marka, model, registracija, godina_proizvodnje, sluzbeno_vozilo, vlasnik, napomena_službena_vozila)
SELECT id, marka, model, registracija, godina_proizvodnje, sluzbeno_vozilo, 'Ministarstvo Unutarnjih Poslova' AS vlasnik, 'Ministarstvo Unutarnjih Poslova' AS napomena_službena_vozila
FROM Vozilo
WHERE sluzbeno_vozilo = 1;

-- Zatvaranje transakcije
COMMIT;
