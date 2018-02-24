-- Question 1

SELECT DISTINCT f.flight_num, f.origin_city, f.dest_city, c.name, w.day_of_week
FROM Flights f
JOIN Carriers c, Weekdays w
ON c.name='Alaska Airlines Inc.'
	AND f.carrier_id = c.cid
	AND w.day_of_week='Monday'
	AND f.day_of_week_id = w.did
WHERE f.origin_city = 'Seattle WA'
	AND f.dest_city = 'Boston MA';

-- Query Result: 3 Rows


-- Question 2

SELECT c.name, f.flight_num AS flight_num_1, f.origin_city, f.dest_city, f.actual_time AS f1_actual_time, f2.flight_num AS flight_num_2, f2.origin_city, f2.dest_city, f2.actual_time AS f2_actual_time, (f.actual_time + f2.actual_time) AS total_time
FROM Flights f, Carriers c, Flights f2
JOIN Months m
ON f.month_id = m.mid
	AND m.month = 'July'
WHERE f.year = 2015
	AND f.day_of_month = 15
	AND f2.day_of_month = 15
	AND f.day_of_week_id = f2.day_of_week_id
	AND f.carrier_id = f2.carrier_id
	AND (f.actual_time + f2.actual_time) < 420
	AND f.origin_city = 'Seattle WA'
	AND f.dest_city = f2.origin_city
	AND f2.dest_city = 'Boston MA'
GROUP BY flight_num_1, flight_num_2 LIMIT 20;

-- Query Result: 488 Rows

-- name                  flight_num_1  origin_city  dest_city   f1_actual_time  flight_num_2  origin_city  dest_city   f2_actual_time  total_time
-- --------------------  ------------  -----------  ----------  --------------  ------------  -----------  ----------  --------------  ----------
-- Skyway Aviation Inc.  42            Seattle WA   Chicago IL  228             26            Chicago IL   Boston MA   150             378       
-- Skyway Aviation Inc.  42            Seattle WA   Chicago IL  228             186           Chicago IL   Boston MA   137             365       
-- Skyway Aviation Inc.  42            Seattle WA   Chicago IL  228             288           Chicago IL   Boston MA   137             365       
-- Skyway Aviation Inc.  42            Seattle WA   Chicago IL  228             366           Chicago IL   Boston MA   150             378       
-- Skyway Aviation Inc.  42            Seattle WA   Chicago IL  228             1205          Chicago IL   Boston MA   128             356       
-- Skyway Aviation Inc.  42            Seattle WA   Chicago IL  228             1240          Chicago IL   Boston MA   130             358       
-- Skyway Aviation Inc.  42            Seattle WA   Chicago IL  228             1299          Chicago IL   Boston MA   133             361       
-- Skyway Aviation Inc.  42            Seattle WA   Chicago IL  228             1435          Chicago IL   Boston MA   133             361       
-- Skyway Aviation Inc.  42            Seattle WA   Chicago IL  228             1557          Chicago IL   Boston MA   122             350       
-- Skyway Aviation Inc.  42            Seattle WA   Chicago IL  228             2503          Chicago IL   Boston MA   127             355       
-- Skyway Aviation Inc.  44            Seattle WA   New York N  322             84            New York NY  Boston MA   74              396       
-- Skyway Aviation Inc.  44            Seattle WA   New York N  322             199           New York NY  Boston MA   80              402       
-- Skyway Aviation Inc.  44            Seattle WA   New York N  322             235           New York NY  Boston MA   91              413       
-- Skyway Aviation Inc.  44            Seattle WA   New York N  322             1443          New York NY  Boston MA   80              402       
-- Skyway Aviation Inc.  44            Seattle WA   New York N  322             2118          New York NY  Boston MA                   322       
-- Skyway Aviation Inc.  44            Seattle WA   New York N  322             2121          New York NY  Boston MA   74              396       
-- Skyway Aviation Inc.  44            Seattle WA   New York N  322             2122          New York NY  Boston MA   65              387       
-- Skyway Aviation Inc.  44            Seattle WA   New York N  322             2126          New York NY  Boston MA   60              382       
-- Skyway Aviation Inc.  44            Seattle WA   New York N  322             2128          New York NY  Boston MA   83              405       
-- Skyway Aviation Inc.  44            Seattle WA   New York N  322             2131          New York NY  Boston MA   70              392    

-- Question 3

-- Find the day of the week with the longest average arrival delay. Return the name of the day and the average delay. [1 row]


SELECT w.day_of_week, AVG(f.arrival_delay)
FROM Flights f
JOIN Weekdays w
ON w.did = f.day_of_week_id
GROUP BY day_of_week_id 
ORDER BY AVG(arrival_delay) DESC
LIMIT 1;

-- Query Result: 1 Row

-- Question 4

SELECT DISTINCT c.name
FROM Flights f, Carriers c
WHERE c.cid = f.carrier_id
GROUP BY c.name, f.day_of_week_id, f.day_of_month, f.year
HAVING COUNT(*) > 1000;

-- Query Result: 11 Rows


-- Question 5

-- Find all airlines that had more than 0.5 percent of their flights out of Seattle be canceled. 
-- Return the name of the airline and the percentage of canceled flight out of Seattle. 
-- Order the results by the percentage of canceled flights in ascending order.

SELECT c.name, SUM(f.canceled = 1)*100.0/COUNT(*) AS percentage
FROM Flights f, Carriers c
WHERE c.cid = f.carrier_id
	AND f.origin_city = 'Seattle WA'
GROUP BY c.name
HAVING percentage > 0.5
ORDER BY percentage ASC;

-- Query Result: 6 Rows





