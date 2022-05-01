Create database Bd_animaux
ON PRIMARY
(
name = Bd_animaux_data,
filename='G:\cours\Bd_animaux_data.mdf',
size=4 MB,
maxsize=6 MB,
filegrowth = 2 MB
)
LOG ON
(
name = Bd_animaux_log,
filename='G:\cours\Bd_animaux_log.ldf',
size=4 MB,
maxsize=6 MB,
filegrowth = 2 MB
)
use Bd_animaux

/*------------------------------------------------------------
*        Script SQLSERVER 
------------------------------------------------------------*/
SET XACT_ABORT ON
BEGIN TRAN

/*------------------------------------------------------------
-- Table: race
------------------------------------------------------------*/
CREATE TABLE Race
(
	race_id INT PRIMARY KEY IDENTITY(1,1) ,
	nom     VARCHAR (25) NOT NULL 
)


/*------------------------------------------------------------
-- Table: Animaux
------------------------------------------------------------*/
CREATE TABLE Animaux
(
	n_animal		INT PRIMARY KEY IDENTITY(1,1) ,
	nom_animal		VARCHAR (25) NOT NULL ,
	sexe			VARCHAR (25) NOT NULL  CONSTRAINT cst_sexe CHECK(sexe in ('Male','Femelle')) ,
	date_naissance	DATETIME  NOT NULL ,
	Race			INT FOREIGN KEY REFERENCES Race (race_id) 
	
	
)


/*------------------------------------------------------------
-- Table: Aliment
------------------------------------------------------------*/
CREATE TABLE Aliment(
	n_aliment INT PRIMARY KEY IDENTITY(1,1)  ,
	nom        VARCHAR (25) NOT NULL ,
	proteines  FLOAT NOT NULL  ,
	glucides   FLOAT NOT NULL  ,
	lipides    FLOAT NOT NULL  ,
	calories   FLOAT NOT NULL  
	
)


/*------------------------------------------------------------
-- Table: Filiation
------------------------------------------------------------*/
CREATE TABLE Filiation
(
	n_animal_enfant	INT PRIMARY KEY IDENTITY(1,1),
	n_animal_mere   INT  NOT NULL FOREIGN KEY REFERENCES Animaux (n_animal),
	n_animal_pere   INT  NOT NULL FOREIGN KEY REFERENCES Animaux (n_animal)
	
)


/*------------------------------------------------------------
-- Table: Aliments_autorisés 
------------------------------------------------------------*/
CREATE TABLE Aliments_autorises
(
	race    INT NOT NULL FOREIGN KEY REFERENCES Race (race_id),
	n_aliment INT  NOT NULL FOREIGN KEY REFERENCES Aliment (n_aliment)
	
)


/*------------------------------------------------------------
-- Table: Aliments_interdits
------------------------------------------------------------*/
CREATE TABLE Aliments_interdits(
	race    INT NOT NULL FOREIGN KEY REFERENCES Race (race_id),
	n_aliment INT  NOT NULL FOREIGN KEY REFERENCES Aliment (n_aliment)
	
)


/*------------------------------------------------------------
-- Table: PlatMenu
------------------------------------------------------------*/
CREATE TABLE PlatMenu(
	jour       VARCHAR (25) NOT NULL ,
	race    INT NOT NULL FOREIGN KEY REFERENCES Race (race_id),
	n_aliment INT  NOT NULL FOREIGN KEY REFERENCES Aliment (n_aliment),
	Quantite   INT  NOT NULL 
	
)


ALTER TABLE Aliments_autorises
ADD CONSTRAINT PK_Aliments_autorises PRIMARY KEY (race,n_aliment)

ALTER TABLE Aliments_interdits
ADD CONSTRAINT PK_Aliments_interdits PRIMARY KEY(race,n_aliment)

ALTER TABLE PlatMenu
ADD CONSTRAINT PK_PlatMenu PRIMARY KEY(jour,race,n_aliment)

COMMIT TRAN

SET XACT_ABORT ON
BEGIN TRAN
-- remplir race :
insert into Race
values ('Lion')

insert into Race
values ('Chat')

insert into Race
values ('Chevaux')

insert into Race
values ('souris')


-- remplir animaux :
insert into Animaux
values ('Lion','Male','02/01/2015',1)
insert into Animaux
values ('lion 2','Femelle','02/12/2015',1)

insert into Animaux
values ('Chat','Male','03/01/2016',2)
insert into Animaux
values ('chat 2','Femelle','03/12/2016',2)

insert into Animaux
values ('Cheval','Male','01/01/2014',3)
insert into Animaux
values ('cheval 2','Femelle','01/12/2014',3)

insert into Animaux
values ('Souris','Male','04/01/2017',4)
insert into Animaux
values ('souris 2','Femelle','04/02/2017',4)


-- remplir aliment :
insert into Aliment
values ('Viande' , 0.2 , 0.1, 0.15 , 2.55)

insert into Aliment
values ('Poisson' , 0.4 , 0.18, 0.33 , 5.29)

insert into Aliment
values ('Blé' , 0.13 , 0.12, 0.3 , 3.7)

insert into Aliment
values ('Fromage' , 0.03 , 0.02, 0.03 , 0.47)

-- remplir Aliments_autorises
-- race lion
insert into Aliments_autorises
values(1,1)
insert into Aliments_interdits
values(1,2)
insert into Aliments_interdits
values(1,3)
insert into Aliments_interdits
values(1,4)

-- race chat
insert into Aliments_autorises
values(2,2)
insert into Aliments_interdits
values(2,1)
insert into Aliments_interdits
values(2,3)
insert into Aliments_interdits
values(2,4)

-- race cheveaux :
insert into Aliments_autorises
values(3,3)
insert into Aliments_interdits
values(3,1)
insert into Aliments_interdits
values(3,2)
insert into Aliments_interdits
values(3,4)

-- race souris :
insert into Aliments_autorises
values(4,4)
insert into Aliments_interdits
values(4,1)
insert into Aliments_interdits
values(4,2)
insert into Aliments_interdits
values(4,3)


-- filiation :
insert into Filiation
values (1,2)
insert into Filiation
values (3,4)
insert into Filiation
values (5,6)

-- PlatMenu :
insert into PlatMenu
values ('lundi',1,1,500)
insert into PlatMenu
values ('lundi',2,2,150)
insert into PlatMenu
values ('lundi',3,3,1000)
insert into PlatMenu
values ('lundi',4,4,20)

COMMIT TRAN

--Q2 Afficher les animaux femelle de la race 'Lion'. 
select * from animaux a join Race r on a.Race = r.race_id
where r.nom = 'Lion' and a.sexe = 'femelle'

--Q3 Afficher les animaux Male nés entre le mois de janvier et mars de l'année 2019.
select * from animaux
where sexe = 'Male' and DATENAME(month,date_naissance) between 'janvier' and 'mars'

--Q4 Afficher le nombre des animaux nés par sexe et par race.
select count(*) AS [Nombre des animaux],Race, Sexe from Animaux
group by Race,sexe

--Q5 Lister les aliments autorisés et les aliments interdits pour la race 'Chat'

select A1.*,A2.* from Race r inner join Aliments_autorises A1 on r.race_id = A1.race
inner join Aliments_interdits A2 on r.race_id = A2.race
where r.nom = 'Chat'

--Q6 Afficher le plateau menu de lundi pour les animaux femelle

SELECT * from PlatMenu P join animaux a on p.race = a.Race
where jour = 'lundi' and  sexe = 'femelle'

--Q7 Afficher le nombre de plateau par jour pour une quantité mois de 1000 gramme. 
Select jour, COUNT(*) as [nombre de plateau]
from PlatMenu
where Quantite<1000
group by jour
---Q8 Lister les aliments ayant des protéines indéterminés. 
Select * 
from Aliment
where proteines is null

--Q9 Afficher les aliments interdits pour les animaux de la race lion

SELECT a1.* from Aliments_interdits a1 join Race a on a1.race = a.race_id
where a.nom = 'lion'

--Q10 Donner la liste des animaux qui peuvent avalés une valeur énergétique  comprise entre 700 Kj. et 900 Kj.

--Q11 Ecrire un trigger T1 sur la table Aliments_autorisés qui interdit pour la race saisi, l'ajout d'un aliment déjà existe dans la table Aliments_ interdits en affichant le message : "L'aliment saisi est déjà existe dans la liste des aliments interdits". 

create trigger T1 on Aliments_autorises for insert 
as
declare @n_aliment int 
select @n_aliment = @n_aliment
from Aliment A join Aliments_interdits AI on A.n_aliment=AI.n_aliment
if exists ( select @n_aliment from Aliment where @n_aliment = @n_aliment)
begin 
rollback transaction
raiserror ('L"aliment saisi est déja existe dans la table Aliment Interdits',0,1)
end


--Q12  Ecrire un trigger T2 sur la table Aliments_autorisés qui empêche de modifier la valeur du champ n°_aliment pour les mois de : Janvier, Février et Mars en affichant un message : "Modification interdite pour les mois : Janvier, Février et Mars." 

create trigger T2 on Aliments_autorises for UPDATE
as
if(UPDATE(n_aliment) and DATENAME(MONTH,GETDATE()) in('Janvier', 'Février' ,'Mars'))
begin
rollback tran
Raiserror('Modification interdite pour les mois : Janvier, Février et Mars ',0,1)

end
--Q13 
create trigger T3 on [dbo].[Aliments_autorisé] for delete
as
declare @race int 
select @race=race from deleted
if(@race in (select race_id from Race where nom in('chien','chat','chevaux')))
begin
rollback transaction
raiserror('Suppression interdite pour races animaux  : chien, chat et chevaux.',0,1)
end
-- Q14  Ecrire une procédure stockée PS1 qui effectuée l'ajout dans la table Filiation, Cette procédure reçoit deux paramètres d'entrés respectivement :  n° animal mère et n° animal père puis retourne dans un troisième paramètre de sortie un message de la manière suivante :  - Si le n° animal mère et le n° animal père ayant la race différent, la procédure affiche : "Erreur : race différent".  - Si le n° animal mère est égale le n° animal père, la procédure affiche : "Erreur : même mère".  - Si le n° animal père est égale le n° animal mère, la procédure affiche : "Erreur : même père".  - Si tout va bien et l'ajout passe, la procédure affiche : "Bien ajouter" 15
	
	create proc PS1 (@n_animalM int ,@n_animalP int,@MsgSortie nvarchar(100) output)
	as
	select @n_animalM,@n_animalP,@MsgSortie
	from Filiation
	if (@n_animalM in (select @n_animalM from Filiation where @n_animalM <> @n_animalP))
	begin
	raiserror ('Erreur : race différent ',0,1)
	end
	if (@n_animalM in (select @n_animalM from Filiation where @n_animalM = @n_animalP))
	begin
	raiserror ('Erreur : même mère',0,1)
	end
	if (@n_animalM in (select @n_animalM from Filiation where @n_animalP = @n_animalM))
	begin
	raiserror ('Erreur : même père',0,1)
	end


	---Q15

	alter proc  PS2 (@race varchar(20))
as

select r.nom, al.n_aliment, al.nom, proteines, glucides, lipides, calories  from Aliment al  inner join Aliments_interdits al_auto 
on al.n_aliment=al_auto.n_aliment inner join Race r on r.race_id=al_auto.race
where r.nom=@race

