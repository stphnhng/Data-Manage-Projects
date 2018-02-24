-- Question 2

CREATE TABLE InsuranceCo(
	name VARCHAR(50) PRIMARY KEY,
	phone VARCHAR(50)
);

CREATE TABLE Vehicle(
	licensePlate VARCHAR(100) PRIMARY KEY,
	year INT,
	maxLiability INT,
	maxLossDamage INT,
	name VARCHAR(30) REFERENCES InsuranceCo
	SSN VARCHAR(15) REFERENCES Person
);

CREATE TABLE Person(
	name VARCHAR(50),
	SSN VARCHAR(15) PRIMARY KEY
);

CREATE TABLE Driver(
	licenseNo VARCHAR(20) PRIMARY KEY
	SSN VARCHAR(15) REFERENCES Person
);

CREATE TABLE Car(
	make VARCHAR(20) 
	licensePlate VARCHAR(100) PRIMARY KEY,
	FOREIGN KEY(licensePlate) REFERENCES Vehicle
);

CREATE TABLE Truck(
	capacity INT,
	licensePlate VARCHAR(100) PRIMARY KEY,
	licenseNo VARCHAR(20) REFERENCES ProfessionalDriver
	FOREIGN KEY(licensePlate) REFERENCES Vehicle
);

CREATE TABLE NonProfessionalDriver(
	licenseNo VARCHAR(20) PRIMARY KEY
	FOREIGN KEY(licenseNo) REFERENCES Driver
);

CREATE TABLE ProfessionalDriver(
	medicalHistory VARCHAR(100),
	licenseNo VARCHAR(20) PRIMARY KEY
	FOREIGN KEY(licenseNo) REFERENCES Driver
);

CREATE TABLE drives(
	licenseNo VARCHAR(20) REFERENCES NonProfessionalDriver,
	licensePlate VARCHAR(100) REFERENCES Car,
	PRIMARY KEY(licenseNo, licensePlate)
);


