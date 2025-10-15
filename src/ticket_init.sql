USE DB_Model1;

-- Customer table
CREATE TABLE IF NOT EXISTS Customer (
  CustomerID INT PRIMARY KEY AUTO_INCREMENT,
  FullName VARCHAR(50) NOT NULL,
  Email VARCHAR(100) NOT NULL,
  Phone VARCHAR(20),
  DoB date,
  Address VARCHAR(255)
);

INSERT INTO Customer (FullName, Email, Phone, Dob, Address)
VALUES
  ('Tom Banks', 'tom.banks@gmail.com', '+1234567890', '1990-05-15', '123 Main St'),
  ('Joe Smith', 'joe.smith@icloud.com', '+9876543210', '1985-08-22', '456 Oak St'),
  ('Bob Johnson', 'bob.johnson@gmail.com', '+1122334455', '1998-03-10', '789 Elm St'),
  ('Eva Davis', 'eva.davis@icloud.com', '+4433221100', '2002-11-28', '101 Pine St'),
  ('Chris Brown', 'chris.brown@gmail.com', '+5544332211', '1975-06-05', '202 Maple St');


-- Event table
CREATE TABLE IF NOT EXISTS Events (
  EventID INT PRIMARY KEY AUTO_INCREMENT,
  Title VARCHAR(255) DEFAULT NULL,
  City VARCHAR(255) DEFAULT NULL,
  Venue VARCHAR(45) DEFAULT NULL,
  StartTime DATETIME DEFAULT NULL,
  EndTime DATETIME DEFAULT NULL,
  Description TEXT
)AUTO_INCREMENT=301;

INSERT IGNORE INTO Events (Title, City, Venue, StartTime, EndTime, Description)
VALUES
  ('Exeter Food Festival 2023', 'Exeter', 'Town Hall', '2023-07-02 10:00:00', '2023-07-02 22:00:00', 'Join us for a celebration of food and culture in Exeter.'),
  ('Exmouth Music Festival 2023', 'Exmouth', 'Beach', '2023-07-05 16:00:00', '2023-07-05 23:00:00', 'Enjoy a day of music and fun by the beach in Exmouth.'),
  ('Wirless 2023', 'London', 'Hyde Park', '2023-08-10 19:30:00', '2023-08-10 22:00:00', 'Music festival in the heart of London.'),
  ('Art Exhibition 2023', 'Exeter', 'Cathedral', '2023-07-07 10:00:00', '2023-07-07 18:00:00', 'Art exhibition in Exeter.'),
  ('Tech Conference 2023', 'Liverpool', 'O2', '2023-11-03 09:00:00', '2023-11-03 17:00:00', 'Stay updated on the latest technology in Liverpool.');


-- TicketType table
CREATE TABLE IF NOT EXISTS TicketType (
  TicketTypeID INT PRIMARY KEY AUTO_INCREMENT,
  TypeName VARCHAR(50) DEFAULT NULL,
  Description VARCHAR(100) DEFAULT NULL,
  Price DECIMAL(10,2) DEFAULT NULL,
  MinAge INT DEFAULT NULL,
  MaxAge INT DEFAULT NULL
) AUTO_INCREMENT=201;

INSERT INTO TicketType (TypeName, Description, Price, MinAge, MaxAge)
VALUES
  ('Adult', 'Ticket for individuals over 16 years old', 20.00, 16, NULL),
  ('Child', 'Ticket for individuals aged 5 to 15 years old', 15.00, 5, 15),
  ('Bronze', 'No requirements for purchase', 10.00, NULL, NULL),
  ('Silver', 'No requirements for purchase', 15.00, NULL, NULL),
  ('Gold', 'No requirements for purchase', 12.00, NULL, NULL);

-- Booking table
CREATE TABLE IF NOT EXISTS Booking (
  BookingID INT PRIMARY KEY AUTO_INCREMENT,
  CustomerID INT DEFAULT NULL,
  EventID INT DEFAULT NULL,
  BookingTime DATETIME DEFAULT NULL,
  TotalPayment DECIMAL(10,2) DEFAULT NULL,
  DeliveryOption VARCHAR(50) DEFAULT NULL,
  Status VARCHAR(50) DEFAULT 'Pending',
  TicketTypeID INT DEFAULT NULL,
  QuantityPurchased INT DEFAULT NULL,
  KEY CustomerID (CustomerID),
  KEY EventID (EventID),
  FOREIGN KEY (CustomerID) REFERENCES Customer (CustomerID),
  FOREIGN KEY (EventID) REFERENCES Events (EventID)
) AUTO_INCREMENT=401;


-- look int0 this one
INSERT INTO Booking (CustomerID, EventID, BookingTime, TotalPayment, DeliveryOption, Status, TicketTypeID, QuantityPurchased)
VALUES
  (1, 301, '2023-11-30 15:00:00', 40.00, 'Email', 'Confirmed', 201, 1),
  (2, 302, '2023-12-01 18:30:00', 60.00, 'Pickup', 'Confirmed', 202, 2),
  (3, 302, '2023-11-28 12:45:00', 75.00, 'Post', 'Confirmed', 202, 3),
  (4, 304, '2023-11-25 09:15:00', 30.00, 'Pickup', 'Pending', 205, 2),
  (5, 305, '2023-11-29 20:30:00', 48.00, 'Email', 'Pending', 205, 1);



-- Cancellation table
CREATE TABLE IF NOT EXISTS Cancellation (
  CancellationID INT PRIMARY KEY AUTO_INCREMENT,
  BookingID INT DEFAULT NULL,
  RequestTime DATETIME DEFAULT NULL,
  ApprovalStatus VARCHAR(50) DEFAULT NULL,
  KEY FK_Cancellation_Booking (BookingID),
  FOREIGN KEY (BookingID) REFERENCES Booking (BookingID)
) AUTO_INCREMENT=501;
INSERT INTO Cancellation (CancellationID, BookingID, RequestTime, ApprovalStatus)
VALUES
  (501, 401, '2023-11-30 16:00:00', 'Approved'),
  (502, 402, '2023-12-01 20:00:00', 'Denied');
  


-- CardDetails table
CREATE TABLE IF NOT EXISTS CardDetails (
  CardID INT PRIMARY KEY AUTO_INCREMENT,
  CardType VARCHAR(50) DEFAULT NULL,
  CardHolderName VARCHAR(45) DEFAULT NULL,
  CardNumber VARCHAR(20) DEFAULT NULL,
  SecurityCode VARCHAR(10) DEFAULT NULL,
  ExpiryDate VARCHAR(10) DEFAULT NULL
  
);

INSERT INTO CardDetails (CardID, CardType, CardHolderName, CardNumber, SecurityCode, ExpiryDate)
VALUES
  (1, 'Visa', 'Tom Banks', '4111111346823111', '123', '2025-12-31'),
  (2, 'Mastercard', 'Joe Smith', '5982655555554444', '456', '2024-09-30'),
  (3, 'American Express', 'Bob Johnson', '378281246310005', '790', '2023-06-30'),
  (4, 'Visa', 'Eva Davis', '4929222678922', '567', '2026-03-31'),
  (5, 'Mastercard', 'Chris Brown', '5105105105617890', '801', '2024-11-30');

-- Delivery table
CREATE TABLE IF NOT EXISTS Delivery (
  DeliveryID INT PRIMARY KEY AUTO_INCREMENT,
  BookingID INT DEFAULT NULL,
  CustomerID INT DEFAULT NULL,
  DeliveryMethod VARCHAR(50) DEFAULT NULL,
  DeliveryDetails VARCHAR(255) DEFAULT NULL,
  KEY FK_Delivery_Booking (BookingID),
  FOREIGN KEY (BookingID) REFERENCES Booking (BookingID)
)AUTO_INCREMENT=601;

INSERT INTO Delivery (BookingID, CustomerID, DeliveryMethod, DeliveryDetails)
VALUES
  (401, 1, 'Email', (SELECT Email FROM Customer WHERE CustomerID = 1)),
  (402, 2, 'delivery', (SELECT Address FROM Customer WHERE CustomerID = 2)),
  (403, 3, 'Delivery', (SELECT Address FROM Customer WHERE CustomerID = 3)),
  (404, 4, 'Delivery', (SELECT Address FROM Customer WHERE CustomerID = 4)),
  (405, 5, 'Email', (SELECT Email FROM Customer WHERE CustomerID = 5));


-- sort out total payment and chekc its not anywhere else
-- Payment table
CREATE TABLE IF NOT EXISTS Payment (
  PaymentID INT PRIMARY KEY AUTO_INCREMENT,
  BookingID INT DEFAULT NULL,
  CardID INT DEFAULT NULL,
  TotalPayment DECIMAL(10,2) DEFAULT NULL,
  KEY BookingID (BookingID),
  KEY CardID (CardID),
  FOREIGN KEY (BookingID) REFERENCES Booking (BookingID),
  FOREIGN KEY (CardID) REFERENCES CardDetails (CardID)
)AUTO_INCREMENT=702;
INSERT INTO Payment (BookingID, CardID, TotalPayment)
VALUES
  (401, 1, NULL),
  (402, 2, NULL),
  (403, 3, NULL),
  (404, 4, NULL),
  (405, 5, NULL);


-- Ticket table
CREATE TABLE IF NOT EXISTS TicketBookingIndex (
  TicketID INT PRIMARY KEY AUTO_INCREMENT,
  BookingID INT DEFAULT NULL,
  TicketTypeID INT DEFAULT NULL,
  QuantityTicketTypeBooking INT DEFAULT NULL,
  KEY BookingID (BookingID),
  KEY TicketTypeID (TicketTypeID),
  FOREIGN KEY (BookingID) REFERENCES Booking (BookingID),
  FOREIGN KEY (TicketTypeID) REFERENCES TicketType (TicketTypeID)
)AUTO_INCREMENT=802;

INSERT INTO TicketBookingIndex (BookingID, TicketTypeID, QuantityTicketTypeBooking)
VALUES
  (401, 201, 2),
  (401, 202, 1),
  (403, 202, 3),
  (404, 202, 2),
  (405, 205, 4);

-- VoucherCode table
CREATE TABLE IF NOT EXISTS VoucherCode (
  VoucherCodeID INT PRIMARY KEY,
  EventID INT DEFAULT NULL,
  Code VARCHAR(50) DEFAULT NULL,
  DiscountPercentage INT DEFAULT NULL,
  KEY EventID (EventID),
  FOREIGN KEY (EventID) REFERENCES Events (EventID)
);


  -- Populate the VoucherCode table
INSERT INTO VoucherCode (VoucherCodeID, EventID, Code, DiscountPercentage)
VALUES
  (101, 301, 'FOOD10', 10),
  (102, 302, 'Other', 20),
  (103, 303, 'Music5', 5),
  (104, 304, 'ART10', 10),
  (105, 305, 'TECH10', 12);

  
  CREATE TABLE IF NOT EXISTS TotalTicketperEventIndex (
  EventID INT NOT NULL,
  TicketTypeID INT NOT NULL,
  QuantityForEvent VARCHAR(45) DEFAULT NULL,
  KEY FK_EventTicket_TicketType (TicketTypeID),
  FOREIGN KEY (EventID) REFERENCES Events (EventID),
  FOREIGN KEY (TicketTypeID) REFERENCES TicketType (TicketTypeID)
);

  
  -- Populate the EventTicket table
INSERT INTO TotalTicketperEventIndex (EventID, TicketTypeID, QuantityForEvent)
VALUES
  (301, 201, '500'),
  (301, 202, '300'),
  (302, 202, '200'),
  (303, 203, '1000'),
  (304, 205, '500'),
  (305, 205, '800');