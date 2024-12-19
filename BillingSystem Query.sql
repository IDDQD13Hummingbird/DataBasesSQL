
--SELECT GS.GameS_ID, P.Player_Name, SP.PlayersInSession FROM GameSession AS GS
--LEFT JOIN PlayerPosition AS PP ON PP.GameS_ID = GS.GameS_ID
--LEFT JOIN TreasorPosition AS TP ON TP.GameS_ID = GS.GameS_ID
--LEFT JOIN Players AS P ON PP.Player_ID = P.Player_ID
--LEFT JOIN (
--    SELECT GS.GameS_ID, COUNT(*) AS PlayersInSession FROM GameSession AS GS
--    LEFT JOIN PlayerPosition AS PS ON PS.GameS_ID = GS.GameS_ID
--    GROUP BY GS.GameS_ID
--) AS SP ON SP.GameS_ID = GS.GameS_ID
--WHERE (PP.Position_X = TP.Position_X AND PP.Position_Y = TP.Position_Y)


----------------------------
-- A :
----------------------------
ALTER VIEW [Assigment A] AS
SELECT Cust.Name, Rev.Revenue FROM Customers AS Cust
INNER JOIN (
	select C.CustomerID, CASE
		WHEN (SUM(O.TotalAmount) IS NOT NULL) THEN SUM(O.TotalAmount)
		ELSE 0
	END AS 'Revenue'
	from Customers AS C
	LEFT JOIN
		(
		SELECT CASE
			WHEN (I.Status = 'Paid') THEN O.TotalAmount
			ELSE 0
		END AS 'TotalAmount',
		O.OrderID,
		O.CustomerID
		FROM Orders AS O
		RIGHT JOIN Invoices AS I ON I.OrderID=O.OrderID
	) AS O ON O.CustomerID = C.CustomerID
	GROUP BY C.CustomerID
) AS Rev ON Rev.CustomerID = Cust.CustomerID

--select C.[CustomerID] 'Customer ID'
-- (select count(*) from [dbo].[Orders] O where O.CustomerID = C.CustomerID) 'Number of orders',
-- (select SUM(P.Amount) from Payments P
-- inner join Orders O on O.CustomerID = C.CustomerID inner join Invoices I on I.OrderID = P.OrderID 
-- where Invoices.[Status] = 'Paid') 'Revenue total' 
--from [dbo].[Customers] C;

SELECT * FROM [Assigment A]


--select C.CustomerID, CASE
--	WHEN (SUM(O.TotalAmount) IS NOT NULL) THEN SUM(O.TotalAmount)
--	ELSE 0
--END AS 'Revenue'
--from Customers AS C
--LEFT JOIN
--	(
--	SELECT CASE
--		WHEN (I.Status = 'Paid') THEN O.TotalAmount
--		ELSE 0
--	END AS 'TotalAmount',
--	O.OrderID,
--	O.CustomerID
--	FROM Orders AS O
--	RIGHT JOIN Invoices AS I ON I.OrderID=O.OrderID
--) AS O ON O.CustomerID = C.CustomerID
--GROUP BY C.CustomerID
--
--SELECT Cust.Name, Rev.Revenue FROM Customers AS Cust
--INNER JOIN (
--	select C.CustomerID, CASE
--		WHEN (SUM(O.TotalAmount) IS NOT NULL) THEN SUM(O.TotalAmount)
--		ELSE 0
--	END AS 'Revenue'
--	from Customers AS C
--	LEFT JOIN
--		(
--		SELECT CASE
--			WHEN (I.Status = 'Paid') THEN O.TotalAmount
--			ELSE 0
--		END AS 'TotalAmount',
--		O.OrderID,
--		O.CustomerID
--		FROM Orders AS O
--		RIGHT JOIN Invoices AS I ON I.OrderID=O.OrderID
--	) AS O ON O.CustomerID = C.CustomerID
--	GROUP BY C.CustomerID
--) AS Rev ON Rev.CustomerID = Cust.CustomerID
--
--(SELECT CASE
--	WHEN (I.Status = 'Paid') THEN O.TotalAmount
--	ELSE 0
--END AS 'Paid',
--O.OrderID,
--O.CustomerID
--FROM Orders AS O
--RIGHT JOIN Invoices AS I ON I.OrderID=O.OrderID)

--SELECT
--pi.item_name,
--pc.category_name,
--s.supplier_name
--FROM product_category pc
--INNER JOIN product_item pi ON pc.id = pi.category_id
--INNER JOIN supplier s ON pi.supplier_id = s.id;
----------------------------  

-- SELECT O.OrderDate, OD.Quantity FROM OrderDetails OD
-- LEFT JOIN (SELECT OrderID, OrderDate FROM Orders) AS O ON O.OrderID = OD.OrderID

----------------------------
-- B :
----------------------------
ALTER VIEW [Assigment B] AS

 ---- Line compiles from right to left, down to up.
 ---- First tell what to join, then where to find it!

 SELECT P.[Name] 'Product Name', OD.Quantity, OD.Subtotal, C.CustomerID, C.[Name] 'Customer Name', C.Email, C.Phone from OrderDetails OD
 LEFT JOIN Orders AS O ON OD.OrderID = O.OrderID
 LEFT JOIN Products AS P ON P.ProductID = OD.ProductID
 LEFT JOIN Customers AS C ON C.CustomerID = O.CustomerID


SELECT * FROM [Assigment B]

 

-- SELECT O.OrderID 'Order ID' FROM [dbo].[Orders] O
--
-- SELECT OD.Quantity from Orders O
-- LEFT JOIN OrderDetails AS OD ON OD.OrderID = O.OrderID
--
-- SELECT OD.Subtotal from OrderDetails OD
-- LEFT JOIN Orders AS O ON OD.OrderID = O.OrderID,
--
-- SELECT P.[Name] FROM Products P 
-- left join Orders AS O ON O.OrderID = OD.OrderID 
-- left join OrderDetails AS OD ON OD.ProductID = P.ProductID;

--SELECT * FROM [Assigment B]
--(select C.CustomerID, STRING_AGG(C.[Name], C.Email, C.Phone, C.[Address]) from Customers C where C.CustomerID = O.CustomerID group by C.CustomerID) 'Customer details',

----------------------------

----------------------------
-- C :
----------------------------
ALTER VIEW [Assigment C] AS

--SELECT I.InvoiceID FROM Invoices I WHERE (DATEDIFF(DAY, GETDATE(), I.DueDate) >= 0  AND I.[Status] = 'Unpaid')
--RIGHT JOIN (SELECT I.OrderID, I.InvoiceID FROM Invoices I WHERE (DATEDIFF(DAY, GETDATE(), I.DueDate) >= 0  AND I.[Status] = 'Unpaid')) 
--AS IV ON IV.InvoiceID = 

 SELECT P.[Name] 'Product Name', OD.Quantity, OD.Subtotal, C.CustomerID, C.[Name] 'Customer Name', C.Email, C.Phone, IVC.Status from OrderDetails OD
 LEFT JOIN Orders AS O ON OD.OrderID = O.OrderID
 LEFT JOIN Products AS P ON P.ProductID = OD.ProductID
 LEFT JOIN Customers AS C ON C.CustomerID = O.CustomerID 
 LEFT JOIN Invoices AS IVC ON IVC.OrderID = O.OrderID 
 RIGHT JOIN (SELECT I.OrderID, I.InvoiceID FROM Invoices I WHERE (DATEDIFF(DAY, GETDATE(), I.DueDate) >= 0  AND I.[Status] = 'Unpaid')) 
 AS IV ON IV.InvoiceID = O.OrderID



select C.[CustomerID] 'Customer ID',
(select count(*) from [dbo].[Orders] O where O.CustomerID = C.CustomerID) 'Number of orders',
(select SUM(P.Amount) from Payments P
inner join Orders O on O.CustomerID = C.CustomerID
where O.OrderID = P.OrderID) 'Revenue total'
from Customers C

SELECT * FROM [Assigment C]
----------------------------

--SELECT O.OrderID, C.CustomerID, P.PaymentID FROM Orders AS O
--LEFT JOIN PlayerPosition AS PP ON PP.GameS_ID = GS.GameS_ID
--LEFT JOIN TreasorPosition AS TP ON TP.GameS_ID = GS.GameS_ID
--LEFT JOIN Players AS P ON PP.Player_ID = P.Player_ID
--LEFT JOIN (
--    SELECT GS.GameS_ID, COUNT(*) AS PlayersInSession FROM GameSession AS GS
--    LEFT JOIN PlayerPosition AS PS ON PS.GameS_ID = GS.GameS_ID
--    GROUP BY GS.GameS_ID
--) AS SP ON SP.GameS_ID = GS.GameS_ID
--WHERE (PP.Position_X = TP.Position_X AND PP.Position_Y = TP.Position_Y)


----------------------------
-- D :
----------------------------
ALTER VIEW [Assigment D] AS

--SELECT Name, Description, Price, Stock, TaxName, Rate, Price*(1 + (Rate / 100)) AS 'Price including tax' FROM Products JOIN Taxes ON AppliesTo = 'Product';

SELECT P.Name, P.Price 'Initial Price', CAST(P.Price*(1 + T.Rate/100) AS DECIMAL (8,2)) 'Price after Tax' FROM Products P
JOIN Taxes T ON AppliesTo LIKE 'Product%';
--RIGHT JOIN (SELECT T.Rate 'Tax Rate' FROM Taxes T
--WHERE T.AppliesTo LIKE '%Product%') AS TX ON --god help me there are no Pkeys or FKeys.
--SELECT P.[Initial Price]*TX.[Tax Rate] 'Price after Tax' FROM P.Price;


SELECT * FROM [Assigment D]
----------------------------
--- I'm not sure how to solve the assigment?

----------------------------
-- E :
----------------------------
ALTER PROCEDURE SelectExcess @exceeding int
AS
	SELECT * FROM Customers C RIGHT JOIN (SELECT CustomerID, TotalAmount FROM Orders O WHERE O.TotalAmount > @exceeding) AS OD ON C.CustomerID = OD.CustomerID


EXEC SelectExcess @exceeding = 500;
----------------------------

--select C.[CustomerID] 'Customer ID',
--(select count(*) from [dbo].[Orders] O where O.CustomerID = C.CustomerID) 'Number of orders',
--(select SUM(P.Amount) from Payments P
--inner join Orders O on O.CustomerID = C.CustomerID
--where O.OrderID = P.OrderID) 'Revenue total'
--from [dbo].[Customers] C;

-----------------------------
-------- Task 2 -------------
-----------------------------

----------------------------
-- A :
----------------------------
-- Create a Trigger to automatically update product stock when an order is placed (use Transaction inside)

ALTER TRIGGER StockUpdate ON OrderDetails
AFTER UPDATE
AS
BEGIN
    PRINT 'Updating remaining stocks...';
	BEGIN TRANSACTION StockUp_Tran ;
	  SAVE TRAN SavepointA
		UPDATE Products 
		SET Stock = Stock-(SELECT Quantity FROM inserted)
		WHERE ProductID = (SELECT ProductID FROM inserted)
	  SAVE TRAN SavepointA
	  PRINT 'Stocks updated succesfully.'
	  SAVE TRAN SavepointA
	  ROLLBACK TRAN SavepointA
	COMMIT TRANSACTION StockUp_Tran ;

END;
----------------------------

----------------------------
-- B :
----------------------------
-- Write a trigger to send an invoice when an order is placed (use transaction inside)

ALTER TRIGGER CreateInvoice ON Orders
AFTER UPDATE
AS
BEGIN
    PRINT 'Creating invoice...';
	BEGIN TRANSACTION InvoiceCreate_Tran ;
	    SAVE TRAN SavepointB
			INSERT INTO Invoices (OrderID, InvoiceDate, DueDate, Status)
			VALUES ((SELECT OrderID FROM inserted), GETDATE(), DATEADD(MM, 1, GETDATE()), 'Unpaid')
	    SAVE TRAN SavepointB
		PRINT 'Invoice created succesfully.'
	ROLLBACK TRAN SavepointB	  
	COMMIT TRANSACTION InvoiceCreate_Tran ;

END;
----------------------------

----------------------------
-- C :
----------------------------
-- Create a trigger to log all payment activities in an audit table.

CREATE TABLE Audit (
    PaymentID int not null,
    OrderID int not null,
    PaymentDate datetime not null,
	Amount decimal(10,2) not null,
	PaymentMethod nvarchar(50) not null,
	AuditLogDate datetime not null
);

ALTER TRIGGER PaymentToAudit ON Payments
AFTER UPDATE
AS
	BEGIN
		INSERT INTO Audit (PaymentID, OrderID, PaymentDate, Amount, PaymentMethod, AuditLogDate)
		VALUES ((SELECT PaymentID FROM inserted), 
				(SELECT OrderID FROM inserted), 
				(SELECT PaymentDate FROM inserted), 
				(SELECT Amount FROM inserted), 
				(SELECT PaymentMethod FROM inserted),
				GETDATE())
	END;


----------------------------
-- D :
----------------------------
			INSERT INTO Audit (PaymentID, OrderID, PaymentDate, Amount, PaymentMethod, AuditLogDate)
		VALUES (1, 
				1, 
				GETDATE(), 
				1, 
				'test',
				DATEADD(YY, -3, GETDATE()))
	DELETE FROM Audit WHERE DATEDIFF(year, AuditLogDate, GETDATE()) > 2 ;
----------------------------

-----------------------------
-------- Task 3 -------------
-----------------------------
-- Propose an AES bases solution to hide 
-- the columns TotalAmount in Orders table 
-- and the column Amount in Payments table

CREATE ASYMMETRIC KEY Task3_RSAKey
WITH ALGORITHM = RSA_2048
ENCRYPTION BY PASSWORD = 'Task3_A';

SELECT * FROM sys.asymmetric_keys


		-- Riad's test :
DECLARE @DataToEncrypt NVARCHAR(100) = 'Sensitive Data';
DECLARE @EncryptedData VARBINARY(MAX);
DECLARE @DecryptedData NVARCHAR(100);
-- Encrypt the data
SET @EncryptedData = ENCRYPTBYASYMKEY(ASYMKEY_ID('Task3_RSAKey'), @DataToEncrypt);
select @EncryptedData as EncryptedData;
-- Decrypt the data
SET @DecryptedData = CONVERT(NVARCHAR(100),
DECRYPTBYASYMKEY(ASYMKEY_ID('Task3_RSAKey'), @EncryptedData, N'Task3_A'))
SELECT @DecryptedData AS DecryptedData;
		--

		DECLARE @DataToEncrypt NVARCHAR(100) = 'Sensitive Data';
        DECLARE @EncryptedData VARBINARY(MAX);
        DECLARE @DecryptedData NVARCHAR(100);

SELECT @DataToEncrypt 'Initial Input';

SET @EncryptedData = ENCRYPTBYASYMKEY(ASYMKEY_ID('Task3_RSAKey'), @DataToEncrypt);
SELECT @EncryptedData 'Encrypt';

SELECT DECRYPTBYASYMKEY(ASYMKEY_ID('Task3_RSAKey'), @EncryptedData,  N'Task3_A') 'Decrypt w/o Convert';

SET @DecryptedData = CONVERT(NVARCHAR(100), DECRYPTBYASYMKEY(ASYMKEY_ID('Task3_RSAKey'), @EncryptedData,  N'Task3_A')) 
SELECT @DecryptedData 'Decrypt'; --Add password, or else it'll rebel


	  -----------------------------
-------- Task 3 - ACTUAL Solution ------------
	  -----------------------------
-- Propose an AES bases solution to hide 
-- the columns TotalAmount in Orders table 
-- and the column Amount in Payments table


CREATE TRIGGER PaymentENC ON Payments
AFTER UPDATE
AS
	BEGIN
	    DECLARE @EncryptedData VARBINARY(MAX);
		SET @EncryptedData = ENCRYPTBYASYMKEY(ASYMKEY_ID('Task3_RSAKey'), CAST((SELECT Amount FROM inserted) AS nvarchar));
		INSERT INTO Payments (AmountENC)
		VALUES (@EncryptedData)
	END;

CREATE TRIGGER OrderENC ON Orders
AFTER UPDATE
AS
	BEGIN
	    DECLARE @EncryptedData VARBINARY(MAX);
		SET @EncryptedData = ENCRYPTBYASYMKEY(ASYMKEY_ID('Task3_RSAKey'), CAST((SELECT TotalAmount FROM inserted) AS nvarchar));
		INSERT INTO Orders (TotalAmountENC)
		VALUES (@EncryptedData)
	END;
