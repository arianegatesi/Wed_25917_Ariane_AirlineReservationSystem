--LISTING ALL RESERVATIONS
DECLARE
  CURSOR c_res IS
    SELECT r.reservationID, p.name, f.flightNumber, r.seatNumber
    FROM RESERVATION r
    JOIN PASSENGER p ON r.passengerID = p.passengerID
    JOIN FLIGHT f ON r.flightNumber = f.flightNumber;

  v_row c_res%ROWTYPE;
BEGIN
  OPEN c_res;
  LOOP
    FETCH c_res INTO v_row;
    EXIT WHEN c_res%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE('Reservation #' || v_row.reservationID ||
                         ': ' || v_row.name || ' - ' || v_row.flightNumber || ' - Seat ' || v_row.seatNumber);
  END LOOP;
  CLOSE c_res;
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error retrieving reservations: ' || SQLERRM);
END;
/