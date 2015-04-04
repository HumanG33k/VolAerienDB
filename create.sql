CREATE TABLE Aeroport (
CodeArpt CHAR(3),
NomArp VARCHAR(50),
Ville VARCHAR(50) NOT NULL,
Province VARCHAR(50) NOT NULL,
CONSTRAINT pk_CodeArpt primary key (CodeArpt) 
);
CREATE TABLE Vol (
NumVol VARCHAR(8),
CodeDep CHAR(3) NOT NULL,
CodeArr CHAR(3)NOT NULL,
HeureMinMDep DATE NOT NULL,
HeureMinArr DATE NOT NULL,
JourArr NUMBER(1),
NbrePlacesDisponibles NUMBER NOT NULL,
CONSTRAINT pk_NumVol primary key (NumVol),
CONSTRAINT fk_CodeDep FOREIGN KEY (CodeDep) REFERENCES Aeroport(CodeArpt),
CONSTRAINT fk_CodeArr FOREIGN KEY (CodeArr) REFERENCES Aeroport(CodeArpt),
CONSTRAINT ck_JourArr CHECK (JourArr in (0,1))
);

CREATE TABLE Appareil(
CodeType VARCHAR(25),
NbrePlacesMAx NUMBER NOT NULL,
Fabricant VARCHAR(25) NOT NULL,
CONSTRAINT pk_CodeType primary key (CodeType) 
);

CREATE TABLE Avion (
NumAvion NUMBER,
CodeType VARCHAR(25) NOT NULL,
AnneeService NUMBER(2)NOT NULL,
%Nom VARCHAR(25) Les avion n'ont pas de nom autre que 
%la concatenation constructeur modele
NbreHeures NUMBER NOT NULL,
CONSTRAINT pk_NumAvion primary key (NumAvion),
CONSTRAINT fk_CodeType FOREIGN KEY (CodeType) REFERENCES Appareil(CodeType)
);

CREATE TABLE Affectation (
NumVol VARCHAR(8),
NumAvion NUMBER,
NbrePassagers NUMBER NOT NULL,
CONSTRAINT pk_NumVol_NumAvion primary key (NumVol, VumAvion),
CONSTRAINT fk_NumVol FOREIGN KEY (NumVol) REFERENCES Vol(NumVol),
CONSTRAINT fk_NumAvion FOREIGN KEY (NumAvion) REFERENCES Avion(NumAvion)
);

CREATE TABLE Reservation (
NumVol VARCHAR(8),
DateVol DATE,
NumPlace VARCHAR(6),
NomClient VARCHAR(50) NOT NULL,
CONSTRAINT pk_NumVol_DateVol_NumPlace primary key (NumVol, DateVol, NumPlace), 
CONSTRAINT fk_NumAvion FOREIGN KEY (NumAvion) REFERENCES Avion(NumAvion)
);

CREATE OR REPLACE TRIGGER aeroport_pre_insert
  BEFORE INSERT OR UPDATE ON Aeroport
  FOR EACH ROW
BEGIN
 :new.CodeArpt := UPPER (:new.CodeArpt );
 :new.NomArpt := UPPER (:new.NomArpt );
 :new.Ville := UPPER (:new.Ville );
 :new.Province := UPPER (:new.Province );
END;

CREATE OR REPLACE TRIGGER vol_pre_insert
  BEFORE INSERT OR UPDATE ON Vol
  FOR EACH ROW
BEGIN
 :new.NumVol := UPPER (:new.NumVol );
 :new.CodeDep := UPPER (:new.CodeDep );
 :new.CodeArr := UPPER (:new.CodeArr );
END;

CREATE OR REPLACE TRIGGER reservation_pre_insert
  BEFORE INSERT OR UPDATE ON Vol
  FOR EACH ROW
BEGIN
 :new.NumVol := UPPER (:new.NumVol );
END;
  
