CREATE TABLE Fields(
	FieldId SERIAL PRIMARY KEY,
	Name VARCHAR(30) NOT NULL
)
--
CREATE TABLE Interns(
	InternId SERIAL PRIMARY KEY,
	FirstName VARCHAR(30),
	LastName VARCHAR(30),
	Pin VARCHAR(11) CHECK(LENGTH(Pin) = 11),
	DateOfBirth TIMESTAMP,
	Gender VARCHAR(1) CHECK(Gender IN('M','F'))
)
--
CREATE TABLE Members(
	MemberId SERIAL PRIMARY KEY,
	FirstName VARCHAR (30),
	LastName VARCHAR (30),
	Pin VARCHAR(11) CHECK(LENGTH(Pin) = 11),
	DateOfBirth TIMESTAMP,
	Gender VARCHAR(1) CHECK(Gender IN('M', 'F'))
)

CREATE TABLE Phases(
	PhaseId SERIAL PRIMARY KEY,
	Name VARCHAR(12) CHECK(Name IN('U pripremi','U tijeku', 'Zavrsen'))
)

CREATE TABLE Statuses(
	StatusId SERIAL PRIMARY KEY,
	Name VARCHAR (30) CHECK(Name IN('pripravnik', 'izbacen', 'zavrsen Internship'))
)









