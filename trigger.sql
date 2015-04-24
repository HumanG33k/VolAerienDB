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
/
CREATE OR REPLACE TRIGGER vol_pre_insert
  BEFORE INSERT OR UPDATE ON Vol
  FOR EACH ROW
DECLARE
BEGIN
 :NEW.NumVol := UPPER (:NEW.NumVol );
 :NEW.CodeDep := UPPER (:NEW.CodeDep );
 :NEW.CodeArr := UPPER (:NEW.CodeArr );
END;
/
CREATE OR REPLACE TRIGGER reservation_pre_insert
  BEFORE INSERT OR UPDATE ON reservation
  FOR EACH ROW
DECLARE
BEGIN
 :NEW.NumPlace := UPPER (:NEW.NumPlace ); 
END;
/
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
/
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
/

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
/
