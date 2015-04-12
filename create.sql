ALTER SESSION SET  nls_date_format = 'dd/MM/yyyy hh24:mi:ss'
Create sequence auto_inc start with 1
increment by 1
minvalue 1
maxvalue 10000;

CREATE OR REPLACE TABLE Aeroport (
CodeArpt CHAR(3),
NomArp VARCHAR(50),
Ville VARCHAR(50) NOT NULL,
Province VARCHAR(50) NOT NULL,
CONSTRAINT pk_CodeArpt primary key (CodeArpt) 
);

CREATE OR REPLACE TABLE Appareil(
CodeType VARCHAR(25),
NbrePlacesMAx NUMBER NOT NULL,
Fabricant VARCHAR(25) NOT NULL,
CONSTRAINT pk_CodeType primary key (CodeType) 
);

CREATE OR REPLACE TABLE Avion (
NumAvion NUMBER,
CodeType VARCHAR(25) NOT NULL,
AnneeService NUMBER(2)NOT NULL,
%Nom VARCHAR(25) Les avion n'ont pas de nom autre que 
%la concatenation constructeur modele
NbreHeures NUMBER NOT NULL,
CONSTRAINT pk_NumAvion primary key (NumAvion),
CONSTRAINT fk_CodeType FOREIGN KEY (CodeType) REFERENCES Appareil(CodeType)
);

CREATE OR REPLACE TABLE Vol (
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



CREATE OR REPLACE TABLE Affectation (
id NUMBER,
DateVol DATE,
NumVol NUMBER,
NumAvion NUMBER,
NbrePassagers NUMBER NOT NULL,
CONSTRAINT pk_id primary key (id),
CONSTRAINT fk_NumVol FOREIGN KEY (NumVol) REFERENCES Vol(NumVol),
CONSTRAINT fk_NumAvion FOREIGN KEY (NumAvion) REFERENCES Avion(NumAvion)
);

CREATE OR REPLACE TABLE Reservation (
id NUMBER,
affectation_id VARCHAR(8),
NumPlace VARCHAR(6),
NomClient VARCHAR(50) NOT NULL,
CONSTRAINT pk_id primary key (id), 
CONSTRAINT fk_affectation FOREIGN KEY (affectation_id) REFERENCES Affectation(id)
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
  
INSERT INTO Aeroport VALUES ( 'ybc', '', 'BAGOTVILLE','QC');
INSERT INTO Aeroport VALUES ( 'YYC', 'Jean Chretien', 'BAGOTVILLE', 'alberta');
INSERT INTO Aeroport VALUES ( 'YYC', 'LeBlanc', 'Charlottetown', 'PE');

INSERT INTO Appareil VALUES ('A380', '450', 'Airbus');
INSERT INTO Appareil VALUES ('CRJ200', '200', 'Bombardier');
INSERT INTO Appareil VALUES ('SpeedFire', '1', 'British');

INSERT INTO Avion VALUES (0, 'A380', '0', '12500');
INSERT INTO Avion VALUES (1, 'CRJ200', '12','300000');
INSERT INTO Avion VALUES (2, 'SpeedFire', '120', '1000000');

INSERT INTO Vol VALUES ('AC8989', 'YYC', 'YBC', to_date(  18:30  , hh24:mi), to_date(   20:30  , hh24:mi), '0', NULL );
INSERT INTO Vol VALUES ('AC8990', 'YBC', 'YYG', to_date(  22:00  , hh24:mi), to_date(   23:30  , hh24:mi), '1', NULL );
INSERT INTO Vol VALUES ('AC8991', 'Yyg', 'YYC', to_date(  22:00  , hh24:mi), to_date(   23:30  , hh24:mi), '1', NULL );

INSERT INTO Reservation VALUES (auto_inc.nextval, ,'AC8989', to_date( 24/04/2015, DD/MM/YYYY ) ,'A12', 'John Smith');
INSERT INTO Reservation VALUES ( 'AC8995', to_date( 24/04/2015, DD/MM/YYYY ) ,'A12', 'John Smith');
INSERT INTO Reservation VALUES ( 'AC8991', to_date( 27/04/2015, DD/MM/YYYY ) ,'A37', 'John Smith');


INSERT INTO Affectation VALUES ('AC8989', '0', 0);
INSERT INTO Affectation VALUES ('AC8991', '1', 50);
INSERT INTO Affectation VALUES ('AC8990', '2', 3);%can t be insert.

/*TODO
Insert avion faire auto inc
Insert Vol nb max a NULL
Insert Affectation change vol.nbMax getAvion.getAppareil.getMAxPlace 
Can't Insert if NumVol.getNbPlaceDispo = NUll
modify affectation check nbpassager
Insert reservation Affectation.NbrePassager =  reserv.NumPlace + Affectation.NbrePassager
if <= getAvion.getAppareil.getMAxPlace
contrainte heure / nombre d'année 
*/
