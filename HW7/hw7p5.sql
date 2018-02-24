-- Question 5

CREATE TABLE Sales(
	name VARCHAR(20),
	discount VARCHAR(10),
	month VARCHAR(5),
	price INT
)


-- 2. ii)

-- name -> price
SELECT COUNT(*)
FROM Sales s, Sales s2
WHERE s.name = s2.name
AND s.price != s2.price;
-- Result: 0, this is a FD

-- month -> discount
SELECT COUNT(*)
FROM Sales s, Sales s2
WHERE s.month = s2.month
AND s.discount != s2.discount;
-- Result: 0, this is a FD

-- name -> discount, price
SELECT COUNT(*)
FROM Sales s, Sales s2
WHERE s.name = s2.name
AND s.discount != s2.discount
AND s.price != s2.price;
-- Result: 0, this is a FD

-- name -> month, price
SELECT COUNT(*)
FROM Sales s, Sales s2
WHERE s.name = s2.name
AND s.month != s2.month
AND s.price != s2.price;
-- Result: 0, this is a FD

-- month -> name, discount
SELECT COUNT(*)
FROM Sales s, Sales s2
WHERE s.month = s2.month
AND s.name != s2.name
AND s.discount != s2.discount;
-- Result: 0, this is a FD

-- month -> discount, price
SELECT COUNT(*)
FROM Sales s, Sales s2
WHERE s.month = s2.month
AND s.discount != s2.discount
AND s.price != s2.price;
-- Result: 0, this is a FD

-- name -> discount, month, price
SELECT COUNT(*)
FROM Sales s, Sales s2
WHERE s.name = s2.name
AND s.discount != s2.discount
AND s.month != s2.month
AND s.price != s2.price;
-- Result: 0, this is a FD

-- month -> name, discount, price
SELECT COUNT(*)
FROM Sales s, Sales s2
WHERE s.month = s2.month
AND s.name != s2.name
AND s.discount != s2.discount
AND s.price != s2.price;
-- Result: 0, this is a FD


-- 2 iii)

CREATE TABLE Sales1(
	name VARCHAR(20) PRIMARY KEY,
	price INT
);

CREATE TABLE Sales2(
	month VARCHAR(5) PRIMARY KEY,
	discount VARCHAR(10)
);

CREATE TABLE Sales3(
	name VARCHAR(20) REFERENCES Sales1,
	month VARCHAR(5) REFERENCES Sales2
);


-- 2 iv.)

-- Sales1
INSERT INTO Sales1
SELECT DISTINCT name, price 
FROM Sales;

/*
name        price     
----------  ----------
bar1        19        
bar8        19        
gizmo3      19        
gizmo7      19        
mouse1      19        
gizmo6      29        
gizmo4      29        
mouse3      29        
mouse7      29        
bar4        29        
bar7        29        
click7      29        
bar9        39        
click1      39        
click2      39        
click3      39        
click8      39        
click4      49        
click9      49        
gizmo1      49        
mouse2      49        
mouse8      59        
bar2        59        
bar3        59        
mouse9      69        
mouse4      69        
gizmo9      79        
gizmo5      79        
gizmo8      89        
mouse5      89        
click6      89        
bar5        89        
bar6        99        
mouse6      99        
click5      99        
gizmo2      99   
*/

-- Sales2

INSERT INTO Sales2
SELECT DISTINCT month, discount
FROM Sales;

/*
month       discount  
----------  ----------
apr         15%       
aug         15%       
dec         33%       
feb         10%       
jan         33%       
jul         33%       
jun         10%       
mar         15%       
may         10%       
nov         15%       
oct         10%       
sep         15% 
*/

-- Sales3

INSERT INTO Sales3
SELECT DISTINCT name, month
FROM Sales;

/*
name        month     
----------  ----------
bar1        apr       
bar8        apr       
gizmo3      apr       
gizmo7      apr       
mouse1      apr       
bar1        aug       
bar8        aug       
gizmo3      aug       
gizmo7      aug       
mouse1      aug       
bar1        dec       
bar8        dec       
gizmo3      dec       
gizmo7      dec       
mouse1      dec       
bar1        feb       
bar8        feb       
gizmo3      feb       
gizmo7      feb       
mouse1      feb       
bar1        jan       
bar8        jan       
gizmo3      jan       
gizmo7      jan       
bar1        jul       
bar8        jul       
gizmo3      jul       
gizmo7      jul       
mouse1      jul       
bar1        jun       
bar8        jun       
gizmo3      jun       
gizmo7      jun       
mouse1      jun       
bar1        mar       
bar8        mar       
gizmo3      mar       
gizmo7      mar       
mouse1      mar       
bar1        may       
bar8        may       
gizmo3      may       
gizmo7      may       
mouse1      may       
bar1        nov       
bar8        nov       
gizmo3      nov       
gizmo7      nov       
mouse1      nov       
bar1        oct       
bar8        oct       
gizmo3      oct       
gizmo7      oct       
mouse1      oct       
bar1        sep       
bar8        sep       
gizmo3      sep       
gizmo7      sep       
mouse1      sep       
gizmo6      sep       
gizmo4      sep       
mouse3      sep       
mouse7      sep       
mouse7      oct       
bar4        sep       
bar7        sep       
click7      sep       
gizmo6      oct       
mouse3      oct       
gizmo4      oct       
click7      oct       
bar4        oct       
bar7        oct       
mouse7      nov       
mouse3      nov       
gizmo6      nov       
gizmo4      nov       
bar4        nov       
bar7        nov       
click7      nov       
mouse7      may       
gizmo6      may       
mouse3      may       
gizmo4      may       
click7      may       
bar4        may       
bar7        may       
mouse7      mar       
mouse3      mar       
gizmo6      mar       
gizmo4      mar       
mouse7      jun       
bar4        mar       
bar7        mar       
click7      mar       
gizmo6      jun       
mouse3      jun       
gizmo4      jun       
click7      jun       
bar4        jun       
bar7        jun       
mouse7      jul       
mouse3      jul       
gizmo6      jul       
gizmo4      jul       
bar4        jul       
bar7        jul       
click7      jul       
mouse7      jan       
mouse3      jan       
gizmo4      jan       
gizmo6      jan       
click7      jan       
bar4        jan       
bar7        jan       
mouse7      feb       
mouse3      feb       
gizmo4      feb       
gizmo6      feb       
click7      feb       
mouse7      dec       
bar7        feb       
mouse3      dec       
gizmo4      dec       
gizmo6      dec       
bar7        dec       
click7      dec       
bar4        dec       
mouse7      aug       
mouse3      aug       
gizmo6      aug       
gizmo4      aug       
bar7        aug       
click7      aug       
bar4        aug       
mouse7      apr       
gizmo6      apr       
mouse3      apr       
gizmo4      apr       
bar7        apr       
click7      apr       
bar4        apr       
bar9        apr       
click1      apr       
click2      apr       
click3      apr       
click8      apr       
click8      aug       
bar9        aug       
click2      aug       
click3      aug       
bar9        dec       
click1      dec       
click2      dec       
click3      dec       
click8      dec       
click8      feb       
bar9        feb       
click1      feb       
click2      feb       
click3      feb       
bar9        jan       
click1      jan       
click2      jan       
click3      jan       
click8      jan       
bar9        jul       
click1      jul       
click2      jul       
click8      jul       
bar9        jun       
click1      jun       
click2      jun       
click3      jun       
click8      jun       
click8      mar       
bar9        mar       
click1      mar       
click2      mar       
click3      mar       
bar9        may       
click1      may       
click2      may       
click3      may       
click8      may       
bar9        nov       
click1      nov       
click2      nov       
click3      nov       
click8      nov       
bar9        oct       
click1      oct       
click2      oct       
click3      oct       
click8      oct       
click8      sep       
bar9        sep       
click1      sep       
click2      sep       
click3      sep       
click4      sep       
click9      sep       
gizmo1      sep       
click9      oct       
gizmo1      oct       
mouse2      oct       
click4      oct       
click9      nov       
gizmo1      nov       
mouse2      nov       
mouse2      sep       
click4      nov       
mouse2      may       
click9      may       
gizmo1      may       
click4      may       
click4      mar       
click9      mar       
gizmo1      mar       
mouse2      mar       
click9      jun       
gizmo1      jun       
mouse2      jun       
click4      jun       
click9      jul       
gizmo1      jul       
mouse2      jul       
click4      jul       
mouse2      jan       
click9      jan       
gizmo1      jan       
click4      jan       
mouse2      feb       
click4      feb       
click9      feb       
gizmo1      feb       
click9      dec       
gizmo1      dec       
mouse2      dec       
click4      dec       
mouse2      aug       
click4      aug       
click9      aug       
gizmo1      aug       
gizmo1      apr       
click4      apr       
mouse2      apr       
mouse8      apr       
bar2        aug       
bar3        aug       
bar2        apr       
bar3        apr       
mouse8      aug       
bar2        dec       
bar3        dec       
mouse8      dec       
bar2        feb       
bar3        feb       
mouse8      feb       
bar2        jan       
bar3        jan       
mouse8      jan       
bar2        jul       
bar3        jul       
mouse8      jul       
bar2        jun       
bar3        jun       
mouse8      mar       
bar2        may       
bar3        may       
mouse8      jun       
bar2        mar       
bar3        mar       
mouse8      may       
bar2        nov       
bar3        nov       
mouse8      sep       
mouse8      nov       
bar2        oct       
bar3        oct       
mouse8      oct       
bar2        sep       
bar3        sep       
mouse9      oct       
mouse4      oct       
mouse9      nov       
mouse4      nov       
mouse9      sep       
mouse4      sep       
mouse9      may       
mouse4      may       
mouse9      jun       
mouse9      mar       
mouse4      mar       
mouse9      jul       
mouse4      jul       
mouse4      jun       
mouse9      jan       
mouse4      jan       
mouse9      feb       
mouse4      feb       
mouse9      dec       
mouse4      dec       
mouse9      aug       
mouse4      aug       
mouse9      apr       
mouse4      apr       
gizmo9      apr       
gizmo5      apr       
gizmo5      aug       
gizmo9      aug       
gizmo9      dec       
gizmo5      feb       
gizmo9      feb       
gizmo5      jan       
gizmo9      jan       
gizmo9      jul       
gizmo5      jul       
gizmo9      jun       
gizmo5      jun       
gizmo9      mar       
gizmo5      mar       
gizmo9      may       
gizmo5      may       
gizmo9      sep       
gizmo5      sep       
gizmo9      nov       
gizmo5      nov       
gizmo9      oct       
gizmo5      oct       
gizmo8      oct       
mouse5      oct       
click6      sep       
bar5        sep       
gizmo8      nov       
click6      nov       
bar5        nov       
mouse5      nov       
click6      oct       
bar5        oct       
gizmo8      sep       
mouse5      sep       
gizmo8      may       
click6      may       
bar5        may       
mouse5      may       
gizmo8      mar       
mouse5      mar       
click6      mar       
bar5        mar       
gizmo8      jun       
mouse5      jun       
mouse5      jul       
click6      jun       
bar5        jun       
gizmo8      jul       
click6      jul       
bar5        jul       
gizmo8      jan       
mouse5      jan       
click6      jan       
bar5        jan       
click6      feb       
gizmo8      feb       
mouse5      feb       
bar5        feb       
mouse5      dec       
gizmo8      dec       
click6      dec       
gizmo8      aug       
click6      aug       
mouse5      aug       
bar5        dec       
click6      apr       
bar5        apr       
gizmo8      apr       
mouse5      apr       
bar5        aug       
bar6        aug       
mouse6      apr       
bar6        apr       
click5      apr       
gizmo2      apr       
bar6        dec       
click5      dec       
mouse6      aug       
gizmo2      aug       
click5      aug       
gizmo2      dec       
mouse6      dec       
bar6        feb       
gizmo2      feb       
click5      feb       
mouse6      feb       
bar6        jan       
click5      jan       
gizmo2      jan       
mouse6      jan       
click5      jul       
bar6        jul       
gizmo2      jul       
bar6        jun       
click5      jun       
mouse6      jul       
mouse6      jun       
gizmo2      jun       
bar6        mar       
gizmo2      mar       
click5      mar       
mouse6      mar       
mouse6      may       
click5      nov       
bar6        may       
click5      may       
gizmo2      may       
mouse6      sep       
bar6        oct       
click5      oct       
mouse6      nov       
bar6        nov       
gizmo2      nov       
bar6        sep       
gizmo2      sep       
click5      sep       
mouse6      oct       
gizmo2      oct 
*/


