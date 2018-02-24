-- Question C1
-- Number of Rows returned: 333
-- Amount of time for Query: 00:00:10 

SELECT DISTINCT f1.origin_city, f1.dest_city, f1.actual_time 
FROM Flights f1, 
(
SELECT origin_city, MAX(actual_time) AS actual_time
FROM Flights f
GROUP BY origin_city
) AS f2
WHERE f1.origin_city = f2.origin_city
	AND f1.actual_time = f2.actual_time
ORDER BY f1.origin_city, f1.dest_city;

-- First 20 rows or less:
--Aberdeen SD	Minneapolis MN	106
--Abilene TX	Dallas/Fort Worth TX	111
--Adak Island AK	Anchorage AK	165
--Aguadilla PR	Newark NJ	272
--Akron OH	Denver CO	224
--Albany GA	Atlanta GA	111
--Albany NY	Las Vegas NV	360
--Albuquerque NM	Baltimore MD	297
--Alexandria LA	Atlanta GA	179
--Allentown/Bethlehem/Easton PA	Atlanta GA	199
--Alpena MI	Detroit MI	80
--Amarillo TX	Houston TX	176
--Anchorage AK	Houston TX	448
--Appleton WI	Atlanta GA	180
--Arcata/Eureka CA	San Francisco CA	136
--Asheville NC	Newark NJ	189
--Ashland WV	Cincinnati OH	84
--Aspen CO	Chicago IL	183
--Atlanta GA	Honolulu HI	649
--Atlantic City NJ	Fort Lauderdale FL	212



-- Question C2
-- Number of Rows returned: 147
-- Amount of time for Query: 00:00:06 

SELECT f1.origin_city
FROM
(
SELECT origin_city, MAX(actual_time) AS actual_time
FROM Flights
GROUP BY origin_city
HAVING MAX(actual_time) < 180
	OR MAX(actual_time) IS NULL
) AS f1
ORDER BY f1.origin_city;

-- First 20 rows or less:
--Aberdeen SD
--Abilene TX
--Adak Island AK
--Albany GA
--Alexandria LA
--Alpena MI
--Amarillo TX
--Arcata/Eureka CA
--Ashland WV
--Augusta GA
--Barrow AK
--Beaumont/Port Arthur TX
--Bemidji MN
--Bethel AK
--Binghamton NY
--Bloomington/Normal IL
--Brainerd MN
--Bristol/Johnson City/Kingsport TN
--Brownsville TX
--Brunswick GA



-- Question C3
-- Number of Rows returned: 327
-- Amount of time for Query: 00:00:29

SELECT f1.origin_city, AVG(f2.numflights * 100.0 / f3.numflights ) AS percentage
FROM Flights f1,
(
SELECT origin_city, 
		SUM(CASE WHEN 
			actual_time < 180 
			OR actual_time IS NULL 
			THEN 1 END) * 100.0
		/ COUNT(actual_time) AS numflights
FROM Flights
GROUP BY origin_city
) AS f2,
(
SELECT origin_city, COUNT(*) AS numflights
FROM Flights
GROUP BY origin_city
) AS f3
WHERE f1.origin_city = f2.origin_city AND f2.origin_city = f3.origin_city
GROUP BY f1.origin_city
ORDER BY percentage


-- First 20 rows or less: 
--Guam TT	NULL
--Pago Pago TT	NULL
--Chicago IL	0.11169345661651731522
--Atlanta GA	0.12734047738596622889
--Los Angeles CA	0.14581384451909651962
--Dallas/Fort Worth TX	0.16415837247207683741
--New York NY	0.17017395021553631429
--Houston TX	0.18742641711597082141
--San Francisco CA	0.21999370332593788437
--Denver CO	0.23035499996097699134
--Phoenix AZ	0.24382176288496258666
--Las Vegas NV	0.24498148727154275987
--Seattle WA	0.26392588470132354274
--Washington DC	0.26776081505803151419
--Newark NJ	0.30037678705291827128
--Minneapolis MN	0.31562330215610960456
--Boston MA	0.32904431021127311194
--Salt Lake City UT	0.35857646885189762431
--Detroit MI	0.38311726965797509570
--Philadelphia PA	0.40466795046112197928



-- Question C4
-- Number of Rows returned: 256
-- Amount of time for Query: 00:03:32

SELECT DISTINCT dest_city
FROM Flights
WHERE dest_city NOT IN
(
SELECT DISTINCT dest_city
FROM Flights
WHERE origin_city = 'Seattle WA'
)
AND 
dest_city IN  
(
SELECT DISTINCT f2.dest_city
FROM Flights f1, Flights f2
WHERE f1.origin_city = 'Seattle WA'
AND f1.dest_city = f2.origin_city
)
AND dest_city != 'Seattle WA'
ORDER BY dest_city ASC;


-- First 20 rows or less:

--Aberdeen SD
--Abilene TX
--Adak Island AK
--Aguadilla PR
--Akron OH
--Albany GA
--Albany NY
--Alexandria LA
--Allentown/Bethlehem/Easton PA
--Alpena MI
--Amarillo TX
--Appleton WI
--Arcata/Eureka CA
--Asheville NC
--Ashland WV
--Aspen CO
--Atlantic City NJ
--Augusta GA
--Bakersfield CA
--Bangor ME


-- Question C5
-- Number of Rows returned: 3
-- Amount of time for Query: 00:03:41

SELECT DISTINCT dest_city
FROM Flights
WHERE dest_city NOT IN (
SELECT dest_city
FROM Flights
WHERE origin_city = 'Seattle WA'
)
AND
dest_city NOT IN (
SELECT DISTINCT f2.dest_city
FROM Flights f1, Flights f2
WHERE f1.origin_city = 'Seattle WA'
AND f1.dest_city = f2.origin_city
)
ORDER BY dest_city;


-- First 20 rows or less: 
--Devils Lake ND
--Hattiesburg/Laurel MS
--St. Augustine FL

-- Quesiton D1a

CREATE INDEX idx_actualtime ON Flights(actual_time)
-- I created this index there is already a clustered index for the selection query
-- but the actual_time query is less efficient due to the comparison.


-- Question D1b

-- Query i
-- The index was not used. I believe this is because 
-- only the primary key / clustered index is needed in the queries.

-- Query ii
-- The index was not used. I believe this is because 
-- only the primary key / clustered index is needed in the queries.

-- Query iii
-- The index was used

SELECT DISTINCT carrier_id
FROM Flights
WHERE origin_city = 'Seattle WA' AND actual_time <= 30;

-- Question 2

CREATE INDEX idx_origincity ON Flights(origin_city)
-- I chose origin_city as my index because the query is selecting origin_city

-- Question 3

SELECT DISTINCT F2.origin_city
FROM Flights F1, Flights F2
WHERE F1.dest_city = F2.dest_city
  AND F1.origin_city='Gunnison CO'
  AND F1.actual_time <= 30;

 -- The index was used


 -- Question 4

 -- C1
 -- Before Index: 00:00:10
 -- After Index: 00:00:15

 -- C2
 -- Before Index: 00:00:06
 -- After Index: 00:00:08

 -- C3
 -- Before Index: 00:00:29
 -- After Index: 00:00:30

 -- C4
 -- Before Index: 00:03:32
 -- After Index: 00:04:02

 -- C5
 -- Before Index: 00:03:41
 -- After Index: 00:04:13


 -- Question E

 -- My experience with Microsoft Azure DBMS was good. 
 -- The only part about this assignment I didn't like was that I could not use a SSMS on a mac.

 -- I think the usage of a DBMS on the cloud is good because of the accessibility but
 -- I believe that the cloud may increase the query times for servers.

