/*# KORISNICI (autentifikacija/autorizacija)
-- Kreiranje admin korisnika
CREATE USER 'admin'@'localhost' IDENTIFIED BY 'admin_password';
GRANT ALL PRIVILEGES ON *.* TO 'admin'@'localhost' WITH GRANT OPTION;
FLUSH PRIVILEGES;
-- prikaz ovlasti
SHOW GRANTS FOR 'admin'@'localhost';
-- oduzimanje ovlasti
REVOKE ALL PRIVILEGES ON *.* FROM 'admin'@'localhost';
FLUSH PRIVILEGES;
-- brisanje korisnika
DROP USER 'admin'@'localhost';


-- Kreiranje HR korisnika
CREATE USER 'hr'@'localhost' IDENTIFIED BY 'hr_password';
GRANT SELECT, INSERT, UPDATE, DELETE ON Policija.Radno_mjesto TO 'hr'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE ON Policija.Odjeli TO 'hr'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE ON Policija.Zaposlenik TO 'hr'@'localhost';
FLUSH PRIVILEGES;
-- prikaz ovlasti
SHOW GRANTS FOR 'hr'@'localhost';
-- oduzimanje ovlasti
REVOKE ALL PRIVILEGES ON *.* FROM 'hr'@'localhost';
FLUSH PRIVILEGES;
-- brisanje korisnika
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
-- brisanje korisnika
DROP USER 'fizicka_osoba'@'localhost';

# Napravi korisnika 'detektiv' (ne znan dali je to egzaktan naziv) koji će biti zadužen za prikupljanje dokaza na slučajevima, predmete, sredstva_utvrđivanja_istine i sastavljanje izvještaja
CREATE USER 'detektiv'@'localhost' IDENTIFIED BY 'detektiv_password';
GRANT SELECT, INSERT, UPDATE, DELETE ON Policija.Predmet TO 'detektiv'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE ON Policija.Slucaj TO 'detektiv'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE ON Policija.Sui TO 'detektiv'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE ON Policija.Sui_slucaj TO 'detektiv'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE ON Policija.Izvjestaji TO 'detektiv'@'localhost';
FLUSH PRIVILEGES;
*/
