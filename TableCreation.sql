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