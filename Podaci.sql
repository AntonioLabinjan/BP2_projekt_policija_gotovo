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
