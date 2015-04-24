
/* Test  Dataset insertion  */

INSERT INTO Aeroport VALUES ( 'ybc', '', 'BAGOTVILLE','QC');
INSERT INTO Aeroport VALUES ( 'YYC', 'Jean Chretien', 'BAGOTVILLE', 'alberta');
INSERT INTO Aeroport VALUES ( 'YYZ', 'LeBlanc', 'Charlottetown', 'PE');
select * from Aeroport;

INSERT INTO Appareil VALUES ('A380', '450', 'Airbus');
INSERT INTO Appareil VALUES ('CRJ200', '200', 'Bombardier');
INSERT INTO Appareil VALUES ('SpeedFire', '1', 'British');
select * from Appareil;

INSERT INTO Avion VALUES (0, 'A380', '0', '125');
INSERT INTO Avion VALUES (1, 'CRJ200', '12','30');
INSERT INTO Avion VALUES (2, 'SpeedFire', '120', '1');
select * from Avion;

INSERT INTO Vol VALUES (0 , 'ybc', 'YYC', to_date(  '18:30'  , 'hh24:mi'), to_date( '20:30' , 'hh24:mi'), 0 );
INSERT INTO Vol VALUES (1 , 'YYC', 'YYZ', to_date(  '18:30'  , 'hh24:mi'), to_date( '20:30' , 'hh24:mi'), 1 );
INSERT INTO Vol VALUES (2 , 'YYC', 'Ybc', to_date(  '18:30'  , 'hh24:mi'), to_date( '20:30' , 'hh24:mi'), 0 );
select * from Vol;

INSERT INTO Affectation VALUES ('0',to_date(  '27/04/2015' , 'dd/mm/yyyy'), '0', '0','');
INSERT INTO Affectation VALUES ('1',to_date(  '27/04/2015' , 'dd/mm/yyyy'), '2', '1','');
INSERT INTO Affectation VALUES ('2',to_date(  '28/04/2015' , 'dd/mm/yyyy'), '2', '1','');
select * from Affectation;


INSERT INTO Reservation VALUES ('0', '0', '3', 'Toto Rigolo' );
select * from Reservation;

