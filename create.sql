ALTER SESSION SET  nls_date_format = 'dd/MM/yyyy hh24:mi:ss'

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
Affectation_id VARCHAR(8),
NumPlace VARCHAR(6),
NomClient VARCHAR(50) NOT NULL,
CONSTRAINT pk_Reserv_Id PRIMARY KEY (Id), 
CONSTRAINT fk_affectation 
	FOREIGN KEY (Affectation_id) 
	REFERENCES Affectation(Id)
);

/* Triggers */

CREATE OR REPLACE TRIGGER aeroport_pre_insert
  BEFORE INSERT OR UPDATE ON Aeroport
  FOR EACH ROW
DECLARE
BEGIN
  :NEW.CodeArpt := UPPER (:NEW.CodeArpt );
  :NEW.NomArpt := UPPER (:NEW.NomArpt );
  :NEW.Ville := UPPER (:NEW.Ville );
  :NEW.Province := UPPER (:NEW.Province );
END;

CREATE OR REPLACE TRIGGER vol_pre_insert
  BEFORE INSERT OR UPDATE ON Vol
  FOR EACH ROW
DECLARE
BEGIN
 :NEW.NumVol := UPPER (:NEW.NumVol );
 :NEW.CodeDep := UPPER (:NEW.CodeDep );
 :NEW.CodeArr := UPPER (:NEW.CodeArr );
END;

CREATE OR REPLACE TRIGGER reservation_pre_insert
  BEFORE INSERT OR UPDATE ON reservation
  FOR EACH ROW
DECLARE
BEGIN
 :NEW.NumPlace := UPPER (:NEW.NumPlace ); 
END;

-- Vérification de la taille du nouvel avion.
CREATE OR REPLACE TRIGGER affectation_pre_update
  BEFORE UPDATE ON affectation
  FOR EACH ROW
DECLARE
  total NUMBER;
  res NUMBER;
  avion_petit EXCEPTION;
BEGIN
   
  SELECT app.NbrePlacesMax
  INTO total
  FROM Appareil app, Avion av
  WHERE app.CodeType = av.CodeType AND av.NumAvion = :NEW.NumAvion;
    
  SELECT COUNT(*)
  INTO res
  FROM Reservation
  WHERE affectation_id = :OLD.id; 
  
  IF total < res THEN
    RAISE avion_petit;
  END IF; 
  
  EXCEPTION
    WHEN avion_petit THEN     
      Raise_application_error(-20001,'Avion trop petit, trop de réservation');    
END;

-- Mise en place du nombre de place restante en fonction de l'avion.
CREATE OR REPLACE TRIGGER affectation_pre_insert
BEFORE INSERT ON Affectation
FOR EACH ROW
DECLARE
  nbPlace NUMBER;
  numAvion NUMBER;
BEGIN
  SELECT NbrePlacesMax
  INTO nbPlace
  FROM Appareil
  WHERE NumAvion = :NEW.NumAvion;

  :NEW.NbrePlacesRestant := nbPlace;
  :NEW.Id := affect_auto_inc.NEXTVAL;
END;

-- Modification du nombre de place disponible.
CREATE OR REPLACE TRIGGER reservation_pre_insert
BEFORE INSERT ON Reservation
FOR EACH ROW

DECLARE
nbPlacesRest NUMBER;
avion_plein EXCEPTION;

BEGIN

  SELECT NbrePlacesRestant
  INTO nbPlacesRest
  FROM Affectation
  WHERE Id = :NEW.Affectation_id;

  IF (nbPlacesRest - 1) < 0 THEN
    RAISE avion_plein;
  ELSE
    UPDATE Affectation 
    SET NbrePlacesRestant = nbPlacesRest - 1
    WHERE Id = :NEW.Affectation_id;
  END IF;

EXCEPTION
 WHEN avion_plein THEN
  	Raise_application_error(-20004,'Avion plein');
END;

/* Mettre les heures de vol  */

CREATE OR REPLACE PROCEDURE update_hours(hourIncrement IN NUMBER)
AS
  CURSOR c IS
    SELECT NbreHeures
	FROM Avion;

BEGIN
  FOR rec IN c LOOP
	rec := rec + hourIncrement;
  END LOOP;
END;

BEGIN
DBMS_SCHEDULER.CREATE_JOB (
  job_name             => 'check_hours',
  job_type             => 'STORED_PROCEDURE',
  job_action           => 'update_hours',
  start_date           => '-- 1.00.00AM US/Pacific',
  repeat_interval      => 'FREQ=DAILY', 
  end_date             => '15-SEP-08 1.00.00AM US/Pacific',
  enabled              =>  TRUE,
  comments             => 'Gather table statistics');
END;

/* Test  Dataset insertion  */

INSERT INTO Aeroport VALUES ( 'ybc', '', 'BAGOTVILLE','QC');
INSERT INTO Aeroport VALUES ( 'YYC', 'Jean Chretien', 'BAGOTVILLE', 'alberta');
INSERT INTO Aeroport VALUES ( 'YYZ', 'LeBlanc', 'Charlottetown', 'PE');

INSERT INTO Appareil VALUES ('A380', '450', 'Airbus');
INSERT INTO Appareil VALUES ('CRJ200', '200', 'Bombardier');
INSERT INTO Appareil VALUES ('SpeedFire', '1', 'British');

--Insertion de donnees valides.
INSERT INTO Avion VALUES (0, 'A380', '0', '12500');
INSERT INTO Avion VALUES (1, 'CRJ200', '12','300000');
INSERT INTO Avion VALUES (2, 'SpeedFire', '120', '1000000');
--Insertion d'une donne invalide afin de tester la contrainte fk_CodeType.
--INSERT INTO Avion (3, 'Test', 1, 1); 

INSERT INTO Vol VALUES ('AC8989', 'YYC', 'YBC', to_date(  18:30  , hh24:mi), to_date(   20:30  , hh24:mi), '0', NULL );
INSERT INTO Vol VALUES ('AC8990', 'YBC', 'YYZ', to_date(  22:00  , hh24:mi), to_date(   23:30  , hh24:mi), '1', NULL );
INSERT INTO Vol VALUES ('AC8991', 'YYZ', 'YYC', to_date(  22:00  , hh24:mi), to_date(   23:30  , hh24:mi), '1', NULL );

INSERT INTO Affectation VALUES (1 ,to_date( 27/04/2015,dd/mm/yyyy ) ,'AC8989', '0');
INSERT INTO Affectation VALUES (1 ,to_date( 27/04/2015,dd/mm/yyyy ) ,'AC899' ) , '0');
INSERT INTO Affectation VALUES (2 ,to_date( 27/04/2015,dd/mm/yyyy ) ,'AC8991', '0');

INSERT INTO Reservation VALUES (reserv_auto_inc.nextval, ,'0', 'John Smith');
INSERT INTO Reservation VALUES (reserv_auto_inc.nextval, ,'1', 'John Smith');
INSERT INTO Reservation VALUES (reserv_auto_inc.nextval, ,'2', 'John Smith');

/*TODO
Insert Vol nb max a NULL
Insert Affectation change vol.nbMax getAvion.getAppareil.getMAxPlace 
Can't Insert if NumVol.getNbPlaceDispo = NUll
modify affectation check nbpassager
Insert reservation Affectation.NbrePassager =  reserv.NumPlace + Affectation.NbrePassager
if <= getAvion.getAppareil.getMAxPlace
contrainte heure / nombre d'année 
*/
