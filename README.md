# Airline Reservation System – Oracle PL/SQL Capstone

A fully functional Airline Reservation System implemented in Oracle PL/SQL as part of the Final Capstone Project.

## Problem Statement

In many airline environments, manual or spreadsheet-based reservation systems cause delays, data inconsistency, and security risks. This capstone builds a robust PL/SQL-driven solution to automate and secure the booking, flight management, and passenger data operations.

## Project Goals

- Build an automated airline reservation system using Oracle PL/SQL
- Ensure data consistency and integrity through constraints and procedural logic
- Automate actions via triggers, procedures, functions, and packages
- Restrict unauthorized or ill-timed operations (e.g., on weekdays or holidays)
- Audit all DML operations for accountability and reporting

---

## Phase II: Business Process Model

**UML Diagram**

![UML Diagram](/Screenshots/BPMN%20Diagram.png)

The diagram above illustrates the end-to-end booking flow in an Airline Reservation System. Passengers initiate flight search, provide their details, and confirm a booking. The system validates seat availability, assigns seats, and confirms the reservation. Airline staff manage schedules and seat assignments, while administrators oversee security and manage system-level operations. The use of a structured workflow improves accuracy, minimizes delays, and enhances user experience, aligning with MIS principles of information flow and decision support.

**Swimlane Diagram**

![Swimlane Diagram](/Screenshots/Swimlane%20Diagram.png)

This swimlane diagram illustrates the flight booking process across five departments. It tracks the journey from customer initiation through sales processing, system validation, staff approvals for special requests, and fulfillment completion. Decision points determine whether bookings follow standard paths or require special handling, ultimately ending in one of three possible status outcomes.

---

## Phase III: Logical Model (ER Diagram)

- **Tables**: `PASSENGER`, `FLIGHT`, `RESERVATION`
- **Relationships**:
  - 1:N between PASSENGER and RESERVATION
  - 1:N between FLIGHT and RESERVATION

![ER Model](/Screenshots/ER%20Diagram.png)

---

## Phase IV: Database Creation

**Pluggable Database**
![PDB](/Screenshots/PDB%20Created.png)

**Oracle Enterprise Manager**
> _📸 Screenshot: SQL Developer or OEM table creation, DB name confirmation_

---

## Phase V: Table Implementation and Data Insertion

**SQL Queries**
- Table Creation
```sql
-- PASSENGER TABLE
CREATE TABLE PASSENGER (
  passengerID     NUMBER PRIMARY KEY,
  name            VARCHAR2(100),
  address         VARCHAR2(150),
  city            VARCHAR2(50),
  state           VARCHAR2(50),
  phoneNumber     VARCHAR2(15)
);

-- FLIGHT TABLE
CREATE TABLE FLIGHT (
  flightNumber    VARCHAR2(10) PRIMARY KEY,
  source          VARCHAR2(50),
  destination     VARCHAR2(50),
  fare            NUMBER(8,2),
  flightDate      DATE,
  numOfSeats      NUMBER,
  airline         VARCHAR2(50)
);

-- RESERVATION TABLE
CREATE TABLE RESERVATION (
  reservationID   NUMBER PRIMARY KEY,
  passengerID     NUMBER REFERENCES PASSENGER(passengerID),
  flightNumber    VARCHAR2(10) REFERENCES FLIGHT(flightNumber),
  reservationDate DATE,
  seatNumber      VARCHAR2(5)
);
```

- Data Insertion
```sql
INSERT INTO PASSENGER VALUES (1, 'Ace Gatesi', 'KG 123 St', 'Kigali', 'Kigali', '0788123456');
INSERT INTO PASSENGER VALUES (2, 'Liam Kamanzi', 'KK 456 Ave', 'Huye', 'Southern', '0788345678');
INSERT INTO PASSENGER VALUES (3, 'Ella Uwase', 'KN 789 St', 'Musanze', 'Northern', '0788765432');
INSERT INTO PASSENGER VALUES (4, 'Tania Uwimana', 'KG 101 Rd', 'Rubavu', 'Western', '0788222111');
INSERT INTO PASSENGER VALUES (5, 'Kevin Mugisha', 'KN 404 St', 'Rwamagana', 'Eastern', '0788555444');

INSERT INTO FLIGHT VALUES ('FL001', 'Kigali', 'Nairobi', 200.00, TO_DATE('2025-06-01', 'YYYY-MM-DD'), 60, 'RwandAir');
INSERT INTO FLIGHT VALUES ('FL002', 'Kigali', 'Johannesburg', 350.00, TO_DATE('2025-06-02', 'YYYY-MM-DD'), 80, 'Ethiopian Air');
INSERT INTO FLIGHT VALUES ('FL003', 'Huye', 'Kigali', 80.00, TO_DATE('2025-06-03', 'YYYY-MM-DD'), 30, 'Air Rwanda');
INSERT INTO FLIGHT VALUES ('FL004', 'Kigali', 'Dubai', 600.00, TO_DATE('2025-06-04', 'YYYY-MM-DD'), 120, 'Emirates');
INSERT INTO FLIGHT VALUES ('FL005', 'Musanze', 'Kigali', 90.00, TO_DATE('2025-06-05', 'YYYY-MM-DD'), 25, 'RwandAir');

INSERT INTO RESERVATION VALUES (101, 1, 'FL001', TO_DATE('2025-05-20', 'YYYY-MM-DD'), '12A');
INSERT INTO RESERVATION VALUES (102, 2, 'FL002', TO_DATE('2025-05-20', 'YYYY-MM-DD'), '7B');
INSERT INTO RESERVATION VALUES (103, 3, 'FL003', TO_DATE('2025-05-22', 'YYYY-MM-DD'), '1C');
INSERT INTO RESERVATION VALUES (104, 4, 'FL004', TO_DATE('2025-05-23', 'YYYY-MM-DD'), '24D');
INSERT INTO RESERVATION VALUES (105, 5, 'FL005', TO_DATE('2025-05-24', 'YYYY-MM-DD'), '3E');
```

![Passenger Info](/Screenshots/Passenger%20info.png)
![Reservation Info](/Screenshots/Reservation%20info.png)
![Flight Info](/Screenshots/Flight%20info.png)
---

## Phase VI: Database Interaction & Transactions

**1. SQL Queries**
- Update Record (ex: Passenger)
```sql
UPDATE PASSENGER
SET phoneNumber = '0788000011'
WHERE passengerID = 2;
```

- Delete Record (ex: Reservation)
```sql
DELETE FROM RESERVATION
WHERE reservationID = 101;
```

- Alter Record (ex: Passenger)
```sql
ALTER TABLE PASSENGER
ADD email VARCHAR2(100);
```

- Drop Record (ex: Flight).
```sql
DROP TABLE FLIGHT;
```

- Displaying Records using Joins
```sql
SELECT 
  r.reservationID,
  p.name AS passenger_name,
  f.flightNumber,
  f.source,
  f.destination,
  f.flightDate,
  r.seatNumber
FROM RESERVATION r
JOIN PASSENGER p ON r.passengerID = p.passengerID
JOIN FLIGHT f ON r.flightNumber = f.flightNumber;
```

**2. Procedures**: `MakeReservation`, `GetPassengerInfo`
```sql
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
```

```sql
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
/
```

**3. Functions**: `CountReservations`
```sql
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
```
**4. Cursors** with Exception Handling
```sql
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
```
**5. Package**: `ReservationPkg`
```sql
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
```

```sql
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
```

![Procedure](/Screenshots/Procedure%201.png)
![Procedure](/Screenshots/Procedure%202.png)
![Function](/Screenshots/Function.png)
![Cursor](/Screenshots/Cursor.png)
![Package](/Screenshots/Package.png)

---

## Phase VII: Advanced Triggers and Auditing

- Restriction trigger (`trg_block_weekdays_holidays`)
  - Blocks DML on weekdays and holidays
```sql
CREATE OR REPLACE TRIGGER trg_block_weekdays_holidays
BEFORE INSERT OR UPDATE OR DELETE ON RESERVATION
DECLARE
  v_today DATE := TRUNC(SYSDATE);
  v_day VARCHAR2(10);
  v_exists NUMBER;
BEGIN
  -- Get current day name
  SELECT TO_CHAR(SYSDATE, 'DY', 'NLS_DATE_LANGUAGE = AMERICAN') INTO v_day FROM dual;

  -- Check if it's a weekday (Mon-Fri)
  IF v_day IN ('MON','TUE','WED','THU','FRI') THEN
    RAISE_APPLICATION_ERROR(-20001, 'DML operations are blocked on weekdays!');
  END IF;

  -- Check if it's a public holiday
  SELECT COUNT(*) INTO v_exists
  FROM PUBLIC_HOLIDAYS
  WHERE holiday_date = v_today;

  IF v_exists > 0 THEN
    RAISE_APPLICATION_ERROR(-20002, 'DML operations are blocked on public holidays!');
  END IF;
END;
/
```
- Audit trigger (`trg_audit_reservation`)
  - Logs user, table, action, and timestamp
```sql
CREATE OR REPLACE TRIGGER trg_audit_reservation
AFTER INSERT OR UPDATE OR DELETE ON RESERVATION
FOR EACH ROW
DECLARE
  v_action_type VARCHAR2(10);
BEGIN
  IF INSERTING THEN
    v_action_type := 'INSERT';
  ELSIF UPDATING THEN
    v_action_type := 'UPDATE';
  ELSIF DELETING THEN
    v_action_type := 'DELETE';
  END IF;

  INSERT INTO AUDIT_LOG (
    user_name, action_type, table_name, action_date, status
  ) VALUES (
    USER, v_action_type, 'RESERVATION', SYSDATE, 'ALLOWED'
  );
END;
/
```

![Audit Triggers](/Screenshots/Audit%20tested.png)

---
