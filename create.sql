ALTER SESSION SET  nls_date_format = 'dd/MM/yyyy hh24:mi:ss';

CREATE SEQUENCE reserv_auto_inc 
START WITH 1
INCREMENT BY 1
MINVALUE 0
MAXVALUE 1000000000000;

CREATE SEQUENCE affect_auto_inc 
START WITH 1
INCREMENT BY 1
MINVALUE 0
MAXVALUE 100000000000;

CREATE SEQUENCE avion_auto_inc 
START WITH 1
INCREMENT BY 1
MINVALUE 0
MAXVALUE 100000;


CREATE TABLE Aeroport (
CodeArpt CHAR(3),
NomArpt VARCHAR(50),
Ville VARCHAR(50) NOT NULL,
Province VARCHAR(50) NOT NULL,
CONSTRAINT pk_CodeArpt PRIMARY KEY (CodeArpt) 
);

CREATE TABLE Appareil (
CodeType VARCHAR(25),
NbrePlacesMax NUMBER NOT NULL,
Fabricant VARCHAR(25) NOT NULL,
CONSTRAINT pk_CodeType PRIMARY KEY (CodeType) 
);

CREATE TABLE Avion (
NumAvion NUMBER,
CodeType VARCHAR(25) NOT NULL,
AnneeService NUMBER(3) NOT NULL,
--Nom VARCHAR(25) Les avion n'ont pas de nom autre que 
--la concatenation constructeur modele
NbreHeures NUMBER NOT NULL,
CONSTRAINT pk_NumAvion PRIMARY KEY (NumAvion),
CONSTRAINT fk_CodeType
	FOREIGN KEY (CodeType) 
	REFERENCES Appareil(CodeType) 	
);

CREATE TABLE Vol (
NumVol VARCHAR(8),
CodeDep CHAR(3) NOT NULL,
CodeArr CHAR(3)NOT NULL,
HeureMinMDep DATE NOT NULL,
HeureMinArr DATE NOT NULL,
JourArr NUMBER(1),
CONSTRAINT pk_NumVol PRIMARY KEY (NumVol),
CONSTRAINT fk_CodeDep 
	FOREIGN KEY (CodeDep)
	REFERENCES Aeroport(CodeArpt), 
CONSTRAINT fk_CodeArr 
	FOREIGN KEY (CodeArr)
	REFERENCES Aeroport(CodeArpt),
CONSTRAINT ck_JourArr CHECK (JourArr in (0,1))
);

CREATE TABLE Affectation (
Id NUMBER,
DateVol DATE,
NumVol VARCHAR(8),
NumAvion NUMBER,
NbrePlacesRestant NUMBER NOT NULL,
CONSTRAINT pk_Id PRIMARY KEY (Id),
CONSTRAINT fk_NumVol 
	FOREIGN KEY (NumVol)
	REFERENCES Vol(NumVol),
CONSTRAINT fk_NumAvion 
	FOREIGN KEY (NumAvion) 
	REFERENCES Avion(NumAvion)
);

CREATE TABLE Reservation (
Id NUMBER,
Affectation_id NUMBER,
NumPlace VARCHAR(6),
NomClient VARCHAR(50) NOT NULL,
CONSTRAINT pk_Reserv_Id PRIMARY KEY (Id), 
CONSTRAINT fk_affectation 
	FOREIGN KEY (Affectation_id) 
	REFERENCES Affectation(Id)
);
