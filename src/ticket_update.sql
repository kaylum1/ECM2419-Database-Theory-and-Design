-- upadte 1
UPDATE TotalTicketperEventIndex
SET QuantityForEvent = QuantityForEvent + 100
WHERE EventID = 301 AND TicketTypeID = 201;


-- update 2
-- Insert Ian Cooper into the Customer table
INSERT INTO Customer (FullName, Email, Phone, DoB, Address)
VALUES ('Ian Cooper', 'ian.cooper@example.com', '+1122334455', '1980-01-01', '123 Oak St');



-- Get the CustomerID for Ian Cooper
SET @CustomerID := LAST_INSERT_ID();

-- insert ian cooper into carddetails
INSERT INTO CardDetails (CardType, CardHolderName, CardNumber, SecurityCode, ExpiryDate)
VALUES('Mastercard', 'Ian Cooper', '2218105172893890', '3401', '2024-02-28');
SET @CardID := LAST_INSERT_ID();


-- Get the EventID for Exeter Food Festival
SET @EventID := (SELECT EventID FROM Events WHERE Title = 'Exeter Food Festival 2023');

-- Get the TicketTypeIDs for Adult and Child
SET @AdultTicketTypeID := (SELECT TicketTypeID FROM TicketType WHERE TypeName = 'Adult');
SET @ChildTicketTypeID := (SELECT TicketTypeID FROM TicketType WHERE TypeName = 'Child');

-- Calculate the total price before discount
SET @TotalPrice := (
  SELECT
    SUM(TT.Price * T.QuantityTicketTypeBooking) AS TotalPrice
  FROM
    TicketBookingIndex T
    JOIN TicketType TT ON T.TicketTypeID = TT.TicketTypeID
  WHERE
    T.BookingID = @BookingID
);

-- Apply the discount based on the voucher code 'FOOD10'
SET @DiscountPercentage := (SELECT DiscountPercentage FROM VoucherCode WHERE EventID = @EventID AND Code = 'FOOD10');
SET @Discount := @TotalPrice * (@DiscountPercentage / 100);
SET @DiscountedPrice := @TotalPrice - @Discount;

-- Insert the booking into the Booking table
INSERT INTO Booking (CustomerID, EventID, BookingTime, TotalPayment, DeliveryOption, TicketTypeID, QuantityPurchased)
VALUES (@CustomerID, @EventID, NOW(), @DiscountedPrice, 'Email', @AdultTicketTypeID, 2),
       (@CustomerID, @EventID, NOW(), @DiscountedPrice, 'Email', @ChildTicketTypeID, 1);

-- Get the BookingID for the last inserted booking
SET @BookingID := LAST_INSERT_ID();

-- Insert the payment information into the Payment table
INSERT INTO Payment (BookingID, CardID, TotalPayment)
VALUES (@BookingID, @CardID, @DiscountedPrice);

-- Update Delivery for Ian Cooper's booking
INSERT INTO delivery(BookingID, CustomerID, DeliveryMethod, DeliveryDetails)
VALUES (@BookingID, @CustomerID, 'Email', (SELECT Email FROM Customer WHERE CustomerID = 6));
    


  -- update 3

-- Assuming the BookingID to be canceled is 123 (replace with the actual BookingID)
SET @BookingIDToCancel := 402;

-- Insert the cancellation request into the Cancellation table
INSERT INTO Cancellation (BookingID, RequestTime, ApprovalStatus)
VALUES (@BookingIDToCancel, NOW(),'confirmeed'
);

-- Update the booking status to 'Cancelled' in the Booking table if it exists
UPDATE Booking
SET Status = 'Cancelled'
WHERE BookingID = @BookingIDToCancel AND Status = 'Confirmed';

-- Check if the booking was successfully canceled
SELECT
  CASE
    WHEN ROW_COUNT() > 0 THEN 'Booking successfully canceled'
    ELSE 'Booking not found'
  END AS Result;

  

-- update 4
INSERT INTO VoucherCode (VoucherCodeID, EventID, Code, DiscountPercentage)
VALUES
  (506, 302, 'SUMMER20', 20);



