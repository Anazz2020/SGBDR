Create database DB2_Hotel

ON Primary
(
Name = bd_inscription_data,
filename = 'G:\cours\bd_hotel_data.mdf',
size = 4 MB,
Maxsize = 6MB,
Filegrowth = 2MB
)
log on
(
Name = bd_inscription_log,
filename = 'G:\cours\bd_hotel.ldf',
size = 4 MB,
Maxsize = 6MB,
Filegrowth = 2MB
)
use DB2_Hotel

create table Hotel
(
numhotel int primary key identity(1,1),
nom varchar(50) not null,
ville varchar(50) not null,
etoils varchar(5) not null
)

create table chambre 
(
numChambre  int primary key identity(1,1),
numHotel int foreign key references Hotel(numhotel) not null,
etage int not null,
typ varchar(10) check(typ in('unique','double','mixte')),
prixnuitht money not null
)
create table Client
(
numClient int primary key identity(1,1),
nom varchar(50) not null,
Prenom varchar(50) not null,
tel varchar(15) not null
)

CREATE table Occuption
(
numoccup  int primary key identity(1,1),
numClient int foreign key references Client(numClient) not null,
numChambre int foreign key references chambre(numchambre) not null,
numHotel int foreign key references Hotel(numhotel) not null,
Datearrivee datetime not null,
Datedepart datetime not null
)
CREATE table Reservation
(
numRev  int primary key identity(1,1),
numClient int foreign key references Client(numClient) not null,
numChambre int foreign key references chambre(numchambre) not null,
numHotel int foreign key references Hotel(numhotel) not null,
Datearrivee datetime not null,
Datedepart datetime not null
)


--Hotel
INSERT INTO Hotel (nom, ville, etoils)VALUES('Hotel 1','sefrou','3')
INSERT INTO Hotel (nom, ville, etoils)VALUES('Hotel 2','sefrou','5')

--chamber
INSERT INTO chambre(numHotel, etage, typ, prixnuitht) VALUES (1,3,'unique','10000')
INSERT INTO chambre(numHotel, etage, typ, prixnuitht) VALUES (2,1,'mixte','550')

-- client
INSERT INTO Client(nom, Prenom, tel)VALUES('Nom 1','Prenom 1','0633802208')
INSERT INTO Client(nom, Prenom, tel)VALUES('Nom 2','Prenom 2','0633802209')

--Occupation
INSERT INTO Occuption(numClient, numChambre, numHotel, Datearrivee, Datedepart) VALUES ('1','1','1','08/10/2019','08/12/2019')
INSERT INTO Occuption(numClient, numChambre, numHotel, Datearrivee, Datedepart) VALUES ('2','2','2','09/10/2019','09/12/2019')

--Reservation
INSERT INTO Reservation(numClient, numChambre, numHotel, Datearrivee, Datedepart) VALUES ('1','2','2','10/10/2020','10/12/2020')
INSERT INTO Reservation(numClient, numChambre, numHotel, Datearrivee, Datedepart) VALUES ('2','1','1','07/10/2020','07/12/2020')
commit tran
