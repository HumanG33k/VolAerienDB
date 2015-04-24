/* Mettre les heures de vol  */

CREATE OR REPLACE PROCEDURE update_hours(hourIncrement IN NUMBER)
AS
  CURSOR nbHours IS
    SELECT NbreHeures
	FROM Avion;
  CURSOR 

BEGIN
  FOR rec IN c LOOP
	rec := rec + hourIncrement;
  END LOOP;
END;

/*BEGIN
DBMS_SCHEDULER.CREATE_JOB (
  job_name             => 'check_hours',
  job_type             => 'STORED_PROCEDURE',
  job_action           => 'update_hours',
  start_date           => '-- 1.00.00AM US/Pacific',
  repeat_interval      => 'FREQ=DAILY', 
  end_date             => '15-SEP-08 1.00.00AM US/Pacific',
  enabled              =>  TRUE,
  comments             => 'Gather table statistics');
END;*/
/
