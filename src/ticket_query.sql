#qeury 1
 USE DB_Model1;
  SELECT
  E.Title AS EventTitle,
  E.Venue,
  E.StartTime,
  E.EndTime,
  TT.TypeName AS TicketType,
  TT.description AS TicketDescription,
  TT.Price,
  TT.MinAge,
  TT.MaxAge,
  COALESCE(ET.QuantityForEvent, 0) AS TotalTickets
FROM
  Events E
CROSS JOIN TicketType TT
LEFT JOIN TotalTicketperEventIndex ET ON E.EventID = ET.EventID AND TT.TicketTypeID = ET.TicketTypeID
WHERE
  E.Title = 'Exeter Food Festival 2023'
  AND (TT.MinAge >= 16 or (TT.MinAge >= 5 AND TT.MaxAge <= 15));






#query 2

SELECT
  Title AS EventTitle,
  StartTime,
  EndTime,
  Description
FROM
  Events
WHERE
  City = 'Exeter'
  AND StartTime >= '2023-07-01' 
  AND StartTime <= '2023-07-10';









  
  
  #query 3
  SELECT
  E.Title AS EventTitle,
  TT.TypeName AS TicketType,
  TT.Price,
  COALESCE(ET.QuantityForEvent, 0) AS TotalTickets
FROM
  Events E
CROSS JOIN TicketType TT
LEFT JOIN TotalTicketperEventIndex ET ON E.EventID = ET.EventID AND TT.TicketTypeID = ET.TicketTypeID
WHERE
  E.Title = 'Exmouth Music Festival 2023'
  AND TT.TypeName = 'Bronze';
  
 
  
  
 
#query 4
SELECT
  C.FullName AS CustomerName,
  E.Title AS EventTitle,
  COUNT(*) AS NumberOfGoldTickets
FROM
  Customer C
JOIN Booking B ON C.CustomerID = B.CustomerID
JOIN TotalTicketperEventIndex ET ON B.EventID = ET.EventID
JOIN TicketType TT ON ET.TicketTypeID = TT.TicketTypeID
JOIN Events E ON B.EventID = E.EventID
WHERE
  B.Status = 'Confirmed'
  AND TT.TypeName = 'Gold'
GROUP BY
  C.CustomerID, C.FullName, E.EventID, E.Title;
 
 

 #query 5
 SELECT
  E.Title AS EventName,
  COUNT(*) AS SoldOutTickets
FROM
  Events E
JOIN Booking B ON E.EventID = B.EventID
JOIN TicketBookingIndex T ON B.BookingID = T.BookingID
LEFT JOIN Payment P ON B.BookingID = P.BookingID
WHERE
  B.Status = 'Confirmed'
  AND P.PaymentID IS NOT NULL
GROUP BY
  E.EventID, E.Title
ORDER BY
  SoldOutTickets DESC;
  
#query 6
  
SELECT
  B.BookingID,
  C.FullName AS CustomerName,
  B.BookingTime,
  E.Title AS EventTitle,
  B.DeliveryOption,
  TT.TypeName AS TicketType,
  T.QuantityTicketTypeBooking AS NumberOfTickets,
  TT.Price AS TicketPrice,
  (TT.Price * T.QuantityTicketTypeBooking) AS TotalPayment
FROM
  Booking B
JOIN Customer C ON B.CustomerID = C.CustomerID
JOIN TotalTicketperEventIndex ET ON B.EventID = ET.EventID
JOIN TicketBookingIndex T ON B.BookingID = T.BookingID
JOIN TicketType TT ON T.TicketTypeID = TT.TicketTypeID
JOIN Events E ON B.EventID = E.EventID
WHERE
  B.Status = 'Confirmed'
ORDER BY
  B.BookingID;
  #query 7
  
SELECT
  E.Title AS EventTitle,
  SUM(TT.Price * T.QuantityTicketTypeBooking) AS TotalIncome
FROM
  Events E
JOIN Booking B ON E.EventID = B.EventID
JOIN TicketBookingIndex T ON B.BookingID = T.BookingID
JOIN TicketType TT ON T.TicketTypeID = TT.TicketTypeID
JOIN Payment P ON B.BookingID = P.BookingID
WHERE
  B.Status = 'Confirmed'
GROUP BY
  E.EventID, E.Title
ORDER BY
  TotalIncome DESC
LIMIT 1;
