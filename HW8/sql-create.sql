CREATE TABLE Customer(
	uid INT,
	full_name VARCHAR(100),
	handle VARCHAR(50),
	password VARCHAR(100),
	PRIMARY KEY(uid, handle)
);