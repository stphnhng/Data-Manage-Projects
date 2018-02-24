-- Question 1
-- Retrieve all employees that have two or more managers. 
-- Output their IDs and names.

SELECT e.eid, e.name
FROM Employee e, Manager m
WHERE e.eid = m.eid
GROUP BY m.mid
HAVING COUNT(*) > 2;


-- Question 2
-- Retrieve all employees that have no managers. 
-- (For example, the CEO of the company has no manager.) 
-- Output their IDs and names.

SELECT DISTINCT e.eid, e.name
FROM Employee AS e
WHERE e.eid NOT IN (
SELECT e.eid
FROM Employee e, Manager m
WHERE e.eid = m.eid
);

-- Question 3
-- Retrieve the offices of all managers of employees named 'Alice'. 
-- (Note that there could be multiple employees named 'Alice', and each such employee could have multiple managers.)

SELECT e.office
FROM Employee AS e, Manager as m
WHERE e.eid = m.eid
	AND e.name = 'Alice';



-- Question 4
-- Find all the managers with the property that every employee they manage is located in same office. 
-- Output the manager's ID and name and the office where all their employees are located.


SELECT m.mid 
FROM Manager m
WHERE m.mid NOT IN (
SELECT m.mid
FROM Employee AS e, Employee AS e2, Manager AS m, Manager AS m2
WHERE m.eid = e.eid
	AND m2.eid = e2.eid
	AND e.eid != e2.eid
	AND e.office != e2.office
	AND m.mid = m2.mid
);

Subquery: $\pi_{m.mid}( \sigma_{e.eid != e2.eid, e.office ! = e2.office}( $Employee AS e $\Join_{e.eid = m.eid}$ Manager AS m$) \Join_{m.mid = m2.mid}$ Manager AS m2)\Join_{m2.eid = e2.eid} $Employee AS e2$ )
$

Actual Query: $\pi_{m.mid}($Manager AS m-$Subquery)$

-- Question 5
-- Find all the "second-level managers", that is, those managers who manage at least one employee that is also a manager 
-- (i.e., that manages at least one other employee). 
-- Output each second-level manager's ID and name.

SELECT DISTINCT m1.mid, e2.name
FROM Employee AS e, Manager AS m1, Manager AS m2, Employee AS e2
WHERE m1.eid = e.eid 
	AND m1.eid = m2.mid
	AND m2.mid != m1.mid
	AND m1.mid = e2.eid;




