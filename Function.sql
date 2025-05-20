CREATE OR REPLACE FUNCTION GetReservationCount (
  p_passengerID IN NUMBER
) RETURN NUMBER
IS
  v_count NUMBER;
BEGIN
  SELECT COUNT(*) INTO v_count
  FROM RESERVATION
  WHERE passengerID = p_passengerID;

  RETURN v_count;
END;