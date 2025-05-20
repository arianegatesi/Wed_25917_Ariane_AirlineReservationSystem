--MAKE A RESERVATION
CREATE OR REPLACE PROCEDURE MakeReservation (
  p_passengerID IN NUMBER,
  p_flightNumber IN VARCHAR2,
  p_seatNumber IN VARCHAR2
)
IS
  v_reservationID NUMBER;
BEGIN
  SELECT NVL(MAX(reservationID), 100) + 1 INTO v_reservationID FROM RESERVATION;

  INSERT INTO RESERVATION
  VALUES (v_reservationID, p_passengerID, p_flightNumber, SYSDATE, p_seatNumber);

  DBMS_OUTPUT.PUT_LINE('Reservation created: ' || v_reservationID);
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;

--GET PASSENGER DETAILS
CREATE OR REPLACE PROCEDURE GetPassengerInfo (
  p_passengerID IN NUMBER
)
IS
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
