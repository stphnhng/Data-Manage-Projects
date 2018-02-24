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
	carrier_id VARCHAR(5),
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

PRAGMA foreign_keys=ON;

.mode csv

.import carriers.csv Carriers

.import months.csv Months

.import weekdays.csv Weekdays

.import flights-small.csv Flights
