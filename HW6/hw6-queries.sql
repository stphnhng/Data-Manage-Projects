-- Question 1
%sql
SELECT COUNT(*)
FROM fbFacts

/*
Result:

563,980,447
*/

-- Question 2

%sql
SELECT COUNT(DISTINCT predicate)
FROM fbFacts

/*
Result:

18,944
*/

-- Question 3


%sql
SELECT DISTINCT *
FROM fbFacts
WHERE subject = '/m/0284r5q'

/*
Result:

subject	predicate	obj	context
/m/0284r5q	/common/topic/article	/m/0284r5t	
/m/0284r5q	/type/object/type	/common/topic	
/m/0284r5q	/type/object/type	/food/candy_bar	
/m/0284r5q	/common/topic/notable_types	/business/brand	
/m/0284r5q	/type/object/key	/wikipedia/en_id	9,327,603
/m/0284r5q	/food/candy_bar/manufacturer	/m/01kh5q	
/m/0284r5q	/common/topic/image	/m/04v6jtv	
/m/0284r5q	/type/object/type	/base/tagit/concept	
/m/0284r5q	/type/object/key	/wikipedia/en_title	Flyte_$0028chocolate_bar$0029
/m/0284r5q	/type/object/key	/wikipedia/en	Flyte_$0028chocolate_bar$0029
/m/0284r5q	/food/candy_bar/sold_in	/m/09c7w0	
/m/0284r5q	/type/object/type	/business/brand	
/m/0284r5q	/common/topic/notable_for		{"types":[], "id":"/food/candy_bar", "property":"/type/object/type", "name":"Candy bar"}
/m/0284r5q	/common/topic/notable_types	/food/candy_bar	
/m/0284r5q	/type/object/name	/lang/en	Flyte
*/

-- Question 4


%sql
SELECT COUNT(DISTINCT *)
FROM fbFacts
WHERE predicate = '/type/object/type'
AND obj = '/travel/travel_destination'

/*
Result:

295 rows
*/


-- Question 5

%sql
SELECT fb2.context AS location_name, COUNT(fb3.predicate) AS attractions
FROM fbFacts fb1, fbFacts fb2, fbFacts fb3
WHERE fb1.predicate = '/type/object/name'
AND fb1.obj = '/lang/en'
AND fb2.predicate = '/type/object/type'
AND fb2.obj = '/travel/travel_destination'
AND fb2.subject = fb1.subject
AND fb3.predicate = '/travel/travel_destination/tourist_attractions'
AND fb2.subject = fb3.subject
GROUP BY fb2.context
ORDER BY attractions DESC, location_name
LIMIT 20

/*
Result:

location_name	attractions
London	109
Norway	74
Finland	59
Burlington	41
Rome	40
Toronto	36
Beijing	32
Buenos Aires	28
San Francisco	26
Bangkok	20
Munich	19
Sierra Leone	19
Vienna	19
Montpelier	18
Athens	17
Atlanta	17
Tanzania	17
Berlin	16
Laos	16
Portland	15
*/

-- Question 6

%sql
SELECT DISTINCT subject, COUNT(predicate)
FROM fbFacts
GROUP BY subject


-- Additional Questions

-- 1.) b

-- 2.) c

-- 3.) d

-- 4.) b

-- 5a.) F

-- 5b.) T

-- 5c.) T

-- 5d.) F







