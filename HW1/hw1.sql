-- Stephen Hung
-- CSE 414 AB
--------------------------------------------------
-- PROBLEM 1 
-- a.)
CREATE TABLE Edges(
	Source INT, 
	Destination INT);

-- b.)
INSERT INTO Edges 
VALUES(10,5);

INSERT INTO Edges 
VALUES(6,25);

INSERT INTO Edges 
VALUES(1,3);

INSERT INTO Edges 
VALUES(4,4);

-- c.) 
SELECT * 
FROM Edges;

-- d.)
SELECT Source 
FROM Edges;

-- e.)
SELECT * 
FROM Edges 
WHERE Source > Destination;

-- f.)
INSERT INTO Edges 
VALUES('-1','2000'); 
-- I did not get an error. Why?

--------------------------------------------------
-- PROBLEM 2

CREATE TABLE MyRestaurants(
	Name VARCHAR(20), 
	'Type of food' VARCHAR(20), 
	'Distance' INT, 
	'Last_Visit' VARCHAR(20), 
	'Like' INT);

--------------------------------------------------
-- PROBLEM 3

INSERT INTO MyRestaurants 
VALUES('Yummy Bites','Asian Fusion', 20, '2017-09-24', 1);

INSERT INTO MyRestaurants 
VALUES('Sizzle&Crunch','Vietnamese', 24, '2017-09-29', NULL);

INSERT INTO MyRestaurants 
VALUES('Pike Place Chowder','Seafood', 35, '2017-06-10', 1);

INSERT INTO MyRestaurants 
VALUES('Rancho Bravo Tacos','Mexican', 9, '2017-06-03', 0);

INSERT INTO MyRestaurants 
VALUES('Tim Ho Wan','Dim Sum', 855, '2017-07-29', 1);

--------------------------------------------------
-- PROBLEM 4

-- a.)

.header on
.mode list
SELECT *
FROM MyRestaurants;

.header off
SELECT *
FROM MyRestaurants;

-- b.)

.header on
.mode csv
SELECT *
FROM MyRestaurants;

.header off
SELECT *
FROM MyRestaurants;

-- c.)

.width 15 15 15 15 15
.mode column
.header on
SELECT *
FROM MyRestaurants;

.header off
SELECT *
FROM MyRestaurants;

--------------------------------------------------
-- PROBLEM 5

SELECT Name, Distance
FROM MyRestaurants
WHERE Distance > 0 AND 
	  Distance <= 20 
ORDER BY Name ASC;

--------------------------------------------------
-- PROBLEM 6

SELECT * 
FROM MyRestaurants
WHERE Like = 1 AND
	  Last_Visit < date('now', '-3 month');





