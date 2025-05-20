--PACKAGE SPEC 
CREATE OR REPLACE PACKAGE ReservationPkg AS
  PROCEDURE MakeReservation(
    p_passengerID NUMBER,
    p_flightNumber VARCHAR2,
    p_seatNumber VARCHAR2
  );

  FUNCTION GetReservationCount(
    p_passengerID NUMBER
  ) RETURN NUMBER;

  PROCEDURE GetPassengerInfo(
    p_passengerID IN NUMBER
  );
END ReservationPkg;
/

--PACKAGE BODY
CREATE OR REPLACE PACKAGE BODY ReservationPkg AS

PROCEDURE MakeReservation(
  p_passengerID NUMBER,
  p_flightNumber VARCHAR2,
  p_seatNumber VARCHAR2
) IS
  v_newID NUMBER;
BEGIN
  SELECT NVL(MAX(reservationID), 200) + 1
  INTO v_newID
  FROM RESERVATION;

  INSERT INTO RESERVATION (
    reservationID, passengerID, flightNumber, reservationDate, seatNumber
  ) VALUES (
    v_newID, p_passengerID, p_flightNumber, SYSDATE, p_seatNumber
  );

  DBMS_OUTPUT.PUT_LINE('Reservation added with ID: ' || v_newID);
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error adding reservation: ' || SQLERRM);
END;

  FUNCTION GetReservationCount(
    p_passengerID NUMBER
  ) RETURN NUMBER IS
    v_count NUMBER;
  BEGIN
    SELECT COUNT(*)
    INTO v_count
    FROM RESERVATION
    WHERE passengerID = p_passengerID;

    RETURN v_count;
  EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('Error counting reservations: ' || SQLERRM);
      RETURN 0;
  END;

  PROCEDURE GetPassengerInfo(
    p_passengerID IN NUMBER
  ) IS
    v_name         PASSENGER.name%TYPE;
    v_address      PASSENGER.address%TYPE;
    v_city         PASSENGER.city%TYPE;
    v_state        PASSENGER.state%TYPE;
    v_phoneNumber  PASSENGER.phoneNumber%TYPE;
  BEGIN
    SELECT name, address, city, state, phoneNumber
    INTO v_name, v_address, v_city, v_state, v_phoneNumber
    FROM PASSENGER
    WHERE passengerID = p_passengerID;

    DBMS_OUTPUT.PUT_LINE('--- Passenger Details ---');
    DBMS_OUTPUT.PUT_LINE('Name       : ' || v_name);
    DBMS_OUTPUT.PUT_LINE('Address    : ' || v_address);
    DBMS_OUTPUT.PUT_LINE('City       : ' || v_city);
    DBMS_OUTPUT.PUT_LINE('State      : ' || v_state);
    DBMS_OUTPUT.PUT_LINE('Phone No.  : ' || v_phoneNumber);
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      DBMS_OUTPUT.PUT_LINE('No passenger found with ID: ' || p_passengerID);
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
  END;

END ReservationPkg;
/