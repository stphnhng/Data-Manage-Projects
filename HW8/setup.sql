CREATE TABLE Carriers(
	cid VARCHAR(10) PRIMARY KEY,
	name VARCHAR(85)
);

CREATE TABLE Months(
	mid INT PRIMARY KEY,
	month VARCHAR(10)
);

CREATE TABLE Weekdays(
	did INT PRIMARY KEY,
	day_of_week VARCHAR(10)
);

CREATE TABLE Flights(
	fid INT PRIMARY KEY,
	year INT,
	month_id INT,
	day_of_month INT,
	day_of_week_id INT,
	carrier_id VARCHAR(10),
	flight_num INT,
	origin_city VARCHAR(50),
	origin_state VARCHAR(50),
	dest_city VARCHAR(50),
	dest_state VARCHAR(50),
	departure_delay INT,
	taxi_out INT,
	arrival_delay INT,
	canceled INT,
	actual_time INT,
	distance INT,
		FOREIGN KEY(month_id) REFERENCES Months(mid),
		FOREIGN KEY(day_of_week_id) REFERENCES Weekdays(did),
		FOREIGN KEY(carrier_id) REFERENCES Carriers(cid) 
);

-- Create Table for Customers

/*
You will need to create a Customer table. 
It should store, for each known user, 
their unique user ID, 
their full name, 
their handle (the short name they use to log in — it is also unique), 
and their password.
*/
CREATE TABLE Customer(
	uid INT,
	full_name VARCHAR(100),
	handle VARCHAR(50),
	password VARCHAR(100),
	PRIMARY KEY(uid, handle)
);

INSERT INTO Customer
VALUES(
	1,
	'John Lim',
	'jlim1',
	'hunter2'
);

INSERT INTO Customer
VALUES(
	2,
	'Steven Smith',
	'ssmith1',
	'hunter1'
);

INSERT INTO Customer
VALUES(
	3,
	'Jeff Smith',
	'jsmith1',
	'hunter0'
);

INSERT INTO Customer
VALUES(
	4,
	'Lily Nguyen',
	'lnguyen1',
	'flowers1'
);

-- Create Table for Reservation

CREATE TABLE Reservation(
	user_id INT,
	handle VARCHAR(50),
	flight_id INT,
	FOREIGN KEY (user_id,handle) REFERENCES Customer(uid,handle),
	PRIMARY KEY(user_id, flight_id)
);

SELECT * FROM Reservation;

SELECT TOP 10 * FROM Flights ORDER BY fid DESC;

INSERT INTO Reservation
VALUES(
	1, 
	'jlim1', 
	2
);

INSERT INTO Reservation
VALUES(
	2,
	'ssmith1',
	329
);

INSERT INTO Reservation
VALUES(
	3,
	'jsmith1',
	4028
);

























