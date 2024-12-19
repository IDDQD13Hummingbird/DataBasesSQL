SELECT [Player_ID] 'ID', [Player_Name] 'Nickname', [Player_DateOfCreation] 'Join date' FROM [mock_exam2024db].[dbo].[Players] ORDER BY [Player_DateOfCreation]  ASC; 

			-----------------------------------------------

SELECT GS.[GameS_ID] 'Game ID', P.Player_Name 'Winner', PS.PlayersInSession 'Players participated' FROM [mock_exam2024db].[dbo].[GameSession] AS GS
LEFT JOIN PlayerPosition AS PP ON PP.GameS_ID = GS.GameS_ID
LEFT JOIN TreasorPosition AS TP ON TP.GameS_ID = GS.GameS_ID
LEFT JOIN Players AS P ON P.Player_ID = PP.Player_ID
LEFT JOIN (
	      SELECT GS.GameS_ID, COUNT(*) AS PlayersInSession FROM GameSession AS GS
	      LEFT JOIN PlayerPosition AS PS ON PS.GameS_ID = GS.GameS_ID
	      GROUP BY GS.GameS_ID
		  ) AS PS ON PS.GameS_ID = GS.GameS_ID
		  WHERE (PP.Position_X = TP.Position_X AND PP.Position_Y = TP.Position_Y);

			-----------------------------------------------


SELECT DISTINCT P.Player_ID 'ID', Player_Name 'Player name', NumberOfGames 'Games played' FROM Players P 
LEFT JOIN PlayerPosition AS PST ON PST.Player_ID = P.Player_ID
LEFT JOIN (
	      SELECT PP.Player_ID, COUNT(DISTINCT PP.GameS_ID)
		  AS NumberOfGames FROM PlayerPosition AS PP
	      RIGHT JOIN PlayerPosition AS PS ON PS.Player_ID = PP.Player_ID
	      GROUP BY PP.Player_ID
		  ) AS PS ON PS.Player_ID = PST.Player_ID;

		  -----------------------------------------------

SELECT P.Player_ID 'Player ID', P.Player_Name 'Nickname', GamesWon 'Games played' FROM [mock_exam2024db].[dbo].[PlayerPosition] AS PP
LEFT JOIN Players AS P ON PP.Player_ID = P.Player_ID
LEFT JOIN GameSession AS GS ON PP.GameS_ID = GS.GameS_ID
LEFT JOIN TreasorPosition AS TP ON TP.GameS_ID = GS.GameS_ID
JOIN (
			SELECT 
			CASE
				WHEN (PS.Position_X = TP.Position_X AND PS.Position_Y = TP.Position_Y) 
				THEN (COUNT(*) AS GamesWon FROM PlayerPosition AS PS
				LEFT JOIN TreasorPosition AS TP ON PS.GameS_ID = TP.GameS_ID
				RIGHT JOIN Players AS PL ON PL.Player_ID = PS.Player_ID
				WHERE (PS.Position_X = TP.Position_X AND PS.Position_Y = TP.Position_Y)
				GROUP BY PS.Player_ID)

				ELSE 0
			END 
			)
			AS PS ON P.Player_ID = PS.Player_ID;

--
--SELECT P.Player_ID 'Player ID', P.Player_Name 'Nickname', GamesWon 'Games played' FROM [mock_exam2024db].[dbo].[PlayerPosition] AS PP
--LEFT JOIN Players AS P ON PP.Player_ID = P.Player_ID
--LEFT JOIN GameSession AS GS ON PP.GameS_ID = GS.GameS_ID
--LEFT JOIN TreasorPosition AS TP ON TP.GameS_ID = GS.GameS_ID
--JOIN (
--			SELECT 
--			COUNT(*) AS GamesWon, PS.Player_ID FROM PlayerPosition AS PS
--			LEFT JOIN TreasorPosition AS TP ON PS.GameS_ID = TP.GameS_ID
--	        RIGHT JOIN Players AS PL ON PL.Player_ID = PS.Player_ID
--
--			WHERE (PS.Position_X = TP.Position_X AND PS.Position_Y = TP.Position_Y)
--			GROUP BY PS.Player_ID
--			)
--			AS PS ON P.Player_ID = PS.Player_ID;
--


SELECT P.Player_Name 'Nickname', 
CASE 
	WHEN (PP.Position_X = TP.Position_X AND PP.Position_Y = TP.Position_Y) 
		THEN COUNT(PP.GameS_ID) 
	ELSE 0 
		END 
	AS GamesWon FROM [mock_exam2024db].[dbo].[Players] AS P

	JOIN PlayerPosition PP ON P.Player_ID = PP.Player_ID
	JOIN GameSession GS ON PP.GameS_ID = GS.GameS_ID
	JOIN TreasorPosition TP ON GS.GameS_ID = TP.GameS_ID
WHERE 
	PP.Position_X = TP.Position_X AND PP.Position_Y = TP.Position_Y
GROUP BY P.Player_Name;

----------- Orig :

--DECLARE @wins as int;
--SELECT IF(COUNT(PlayerPosition.GameS_ID)=0, 0, COUNT(PlayerPosition.GameS_ID));
--SELECT @wins = 0;
SELECT P.Player_Name 'Nickname', COUNT(PP.GameS_ID) AS GamesWon 
FROM [mock_exam2024db].[dbo].[Players] AS P
	JOIN PlayerPosition PP ON P.Player_ID = PP.Player_ID
	JOIN GameSession GS ON PP.GameS_ID = GS.GameS_ID
	JOIN TreasorPosition TP ON GS.GameS_ID = TP.GameS_ID
WHERE 
	PP.Position_X = TP.Position_X AND PP.Position_Y = TP.Position_Y

GROUP BY P.Player_Name;



--SELECT P.Player_Name 'Nickname', COUNT(PP.GameS_ID) AS GamesWon FROM [mock_exam2024db].[dbo].[Players] AS P
--	JOIN PlayerPosition PP ON P.Player_ID = PP.Player_ID
--	JOIN (SELECT  
--	CASE
--    WHEN (PP.Position_X = TP.Position_X AND PP.Position_Y = TP.Position_Y) THEN
--	(
--	JOIN GameSession GS ON PP.GameS_ID = GS.GameS_ID
--	JOIN TreasorPosition TP ON GS.GameS_ID = TP.GameS_ID
--WHERE 
--	PP.Position_X = TP.Position_X AND PP.Position_Y = TP.Position_Y
--GROUP BY P.Player_Name;
--
--    ELSE 0
--	END
--	) AS O WHERE O.Player_Name = P.Player_Name

--  RIGHT JOIN (SELECT I.OrderID, I.InvoiceID FROM Invoices I 
-- WHERE (DATEDIFF(DAY, GETDATE(), I.DueDate) >= 0  AND I.[Status] = 'Unpaid')) 
-- AS IV ON IV.InvoiceID = O.OrderID

			----------------------------------------


--SELECT GS.[GameS_ID] 'Game ID', P.Player_Name 'Winner', PS.PlayersInSession 'Players participated' FROM [mock_exam2024db].[dbo].[GameSession] AS GS
SELECT GS.GameS_ID 'Game ID', TimeStart 'Session started', TimeEnd 'Session ended' FROM [mock_exam2024db].[dbo].[GameSession] AS GS
LEFT JOIN PlayerPosition AS PP ON PP.GameS_ID = GS.GameS_ID
LEFT JOIN TreasorPosition AS TP ON TP.GameS_ID = GS.GameS_ID
LEFT JOIN (
	      SELECT TP.[Timestamp] AS TimeStart FROM TreasorPosition AS TP
		  ) AS TS ON GS.GameS_ID = TP.GameS_ID
LEFT JOIN (
          SELECT PP.GameS_ID, PP.[Timestamp] AS TimeEnd FROM PlayerPosition AS PP
		  JOIN TreasorPosition AS TP ON TP.GameS_ID = PP.GameS_ID
		  WHERE PP.Position_X = TP.Position_X AND PP.Position_Y = TP.Position_Y
		  ) AS TE ON GS.GameS_ID = TE.GameS_ID
		  WHERE (PP.Position_X = TP.Position_X AND PP.Position_Y = TP.Position_Y);

----------------------------------------------------------------


---
---Write a transaction inside an SQL stored procedure that creates a new session and initializes a random position for a treasure.
---(Input parameters: min_X, max_X, min_Y, max_Y)
---

CREATE PROCEDURE GenerateMapSize @MaxPlayers int, @min_X int, @max_X int, @min_Y int, @max_Y int
 AS
DECLARE @GameS_ID int;
DECLARE @Tresor_ID int;
   BEGIN TRAN GenerateRect
      SAVE TRAN SavepointA
	    -- create a transaction which adds a row to game sessions. 
		INSERT GameSession (GameS_MaxPlayers, Rect_min_x, Rect_max_x, Rect_min_y, Rect_max_y)
		VALUES (@MaxPlayers, @min_X, @max_X, @min_Y, @max_Y)
		SET @GameS_ID = (SELECT TOP 1 (GameS_ID) FROM GameSession ORDER BY GameS_ID DESC);
		--SET @GameS_ID = SELECT GameS_ID FROM INSERTED;
		-- select top 1 row ordered by gameid descending and set that value as your games ID for treasure position.
	  SAVE TRAN SavepointA

		DECLARE @num INT = ROUND(RAND()*4,0) + 1
		INSERT Treasor (Treasor_Name) VALUES (CHOOSE(@num, 'Ancient Scroll', 'Golden Chalice', 'Healing Potion', 'Mystic Gem', 'Silver Sword'));
  
		SET @Tresor_ID = (SELECT TOP 1 (Tresor_ID) FROM Treasor ORDER BY Tresor_ID DESC);

      SAVE TRAN SavepointA

		INSERT TreasorPosition (GameS_ID, Tresor_ID, Position_X, Position_Y, Timestamp) 
		VALUES (@GameS_ID, @Tresor_ID, FLOOR(RAND()*(@max_X-@min_X+1)+@min_X), FLOOR(RAND()*(@max_Y-@min_Y+1)+@min_Y), GETDATE())
	  SAVE TRAN SavepointA
  	  ROLLBACK TRAN SavepointA
    COMMIT TRAN GenerateRect

 GO
--
--CREATE PROCEDURE GenerateMapSize
--AS 
-- BEGIN TRAN GenerateRect
--  INSERT INTO GameSession(Rect_min_x, Rect_max_x, Rect_min_y, Rect_max_y) VALUES (FLOOR(RAND()*(10-5)), FLOOR(RAND()*(10+5)),FLOOR(RAND()*(10-5)), FLOOR(RAND()*(10+5)));
--  --will not allow to commit without the GameS_MaxPlayers initialized.
-- COMMIT TRAN GenerateRect
----PRINT 'x min = ' '; x max = '
--GO;

----------------------------------

-- Propose and implement a solution to save the entire history of players' positions.

----------------------------------

-- Write a trigger on the PlayerPosition table that corrects a player's position if they move beyond the boundary.
-- For example, if new_x > max_x, then set new_x = max_x.

ALTER TRIGGER OutOfBounds ON PlayerPosition AFTER UPDATE
AS
BEGIN
INSERT GameSessions AS GS
	UPDATE PlayerPosition SET Position_X = (SELECT GS.Rect_min_x FROM GameSession GS WHERE GS.GameS_ID = GameS_ID) 
	WHERE Position_X < (SELECT GS.Rect_min_x FROM GameSession GS WHERE GS.GameS_ID = GameS_ID)
	UPDATE PlayerPosition SET Position_X = (SELECT GS.Rect_max_x FROM GameSession GS WHERE GS.GameS_ID = GameS_ID) 
	WHERE Position_X > (SELECT GS.Rect_max_x FROM GameSession GS WHERE GS.GameS_ID = GameS_ID)
	UPDATE PlayerPosition SET Position_Y = (SELECT GS.Rect_min_y FROM GameSession GS WHERE GS.GameS_ID = GameS_ID) 
	WHERE Position_Y < (SELECT GS.Rect_min_y FROM GameSession GS WHERE GS.GameS_ID = GameS_ID)
	UPDATE PlayerPosition SET Position_Y = (SELECT GS.Rect_max_y FROM GameSession GS WHERE GS.GameS_ID = GameS_ID) 
	WHERE Position_Y > (SELECT GS.Rect_max_y FROM GameSession GS WHERE GS.GameS_ID = GameS_ID)
END;
