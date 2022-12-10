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

ALTER TABLE Interns
	ADD CONSTRAINT InternOlderThan16 CHECK((CURRENT_TIMESTAMP - DateOfBirth) >= INTERVAL '16 year')
	
ALTER TABLE Interns
	ADD CONSTRAINT InternYoungerThan24 CHECK((CURRENT_TIMESTAMP - DateOfBirth) <= INTERVAL '24 year')

INSERT INTO Interns(FirstName, LastName, Pin, DateOfBirth, Gender, PlaceOfResidence) VALUES
('Mijo', 'Catipovic', '39204716391', '2000-1-1', 'M', 'Split'),
('Dorian', 'Bralic', '11111111111', '2000-4-4', 'M', 'Split'),
('Duje', 'Matkovic', '22222222222', '2004-7-2', 'M', 'Split'),
('Branka', 'Glavurdic', '33333333333', '2000-5-5', 'F', 'Omis'),
('Ljiljana', 'Tomic', '44444444444', '2002-11-7', 'F', 'Zagreb'),
('Tea', 'Franic', '55555555555', '2004-7-1', 'F', 'Trogir'),
('Marita', 'Andrijolic', '20473928450','2002-4-8', 'F', 'Split'),
('Roko', 'Burazin', '29305489100','1999-12-12', 'M', 'Split')

SELECT * FROM Interns
--
CREATE TABLE Members(
	MemberId SERIAL PRIMARY KEY,
	FirstName VARCHAR (30),
	LastName VARCHAR (30),
	Pin VARCHAR(11) CHECK(LENGTH(Pin) = 11),
	DateOfBirth TIMESTAMP,
	Gender VARCHAR(1) CHECK(Gender IN('M', 'F'))
)

CREATE TABLE InternsFields(
	InternId INT REFERENCES Interns(InternId),
	FieldId INT REFERENCES Fields(FieldId)
)


ALTER TABLE Members
	ADD CONSTRAINT PinIsUnique UNIQUE(Pin)
	
ALTER TABLE Interns
	ADD CONSTRAINT InternPinIsUnique UNIQUE(Pin)
--
CREATE TABLE Phases(
	PhaseId SERIAL PRIMARY KEY,
	Name VARCHAR(12) CHECK(Name IN('U pripremi','U tijeku', 'Zavrsen'))
)
--
CREATE TABLE Statuses(
	StatusId SERIAL PRIMARY KEY,
	Name VARCHAR (30) CHECK(Name IN('pripravnik', 'izbacen', 'zavrsen Internship'))
)
--
CREATE TABLE Internships(
	InternshipId SERIAL PRIMARY KEY,
	BeginDate TIMESTAMP,
	EndDate TIMESTAMP,
	PhaseId INT REFERENCES Phases(PhaseId),
	LeaderId INT REFERENCES Members(MemberId)
)
--

INSERT INTO Internships (BeginDate, EndDate, PhaseId, LeaderId) VALUES
('2020-1-11','2021-1-5', 3, 3)

SELECT * FROM Internships

DELETE FROM Internships 

INSERT INTO Internships (BeginDate, EndDate, PhaseId, LeaderId) VALUES
('2021-11-1', '2022-5-1', 3, 14),
('2022-11-3', '2023-4-28', 2, 17),
('2023-10-30', '2024-4-30', 1, 21)

ALTER TABLE Fields
	ADD COLUMN LeaderId INT REFERENCES Members(MemberId)
--

INSERT INTO Members (FirstName, LastName, Pin, DateOfBirth, Gender, PlaceOfResidence) VALUES
('Mate', 'Matic', '12345678901', '1997-10-10', 'M', 'Split'),
('Stipe', 'Stipic', '10987654321', '2000-1-1', 'M', 'Zagreb')

INSERT INTO Members (FirstName, LastName, Pin, DateOfBirth, Gender, PlaceOfResidence) VALUES
('Jure', 'Mesin', '34294846701', '2002-3-2', 'M', 'Split'),
('Lana', 'Hrstic', '49375638104', '1999-4-8', 'F', 'Sinj'),
('Mirta', 'Jozic', '48929471740', '2003-7-7', 'F', 'Split'),
('Ivo', 'Ivic', '31038572850', '1999-1-12', 'M', 'Makarska'),
('Miro', 'Trogrlic', '49204817493', '2001-2-2', 'M', 'Split'),
('Dino', 'Dabic', '30182859309', '2002-5-2', 'M', 'Zagreb'),
('Tina', 'Barun', '12121212121', '2003-3-8', 'F', 'Split'),
('Marko', 'Peric', '34562739581', '2000-1-2', 'M', 'Trogir')


SELECT * FROM Members

SELECT FirstName, LastName FROM Members
	WHERE PlaceOfResidence NOT LIKE 'Split'

DELETE FROM Members

ALTER TABLE Members
	ADD COLUMN PlaceOfResidence VARCHAR (30) NOT NULL

ALTER TABLE Interns
	ADD COLUMN PlaceOfResidence VARCHAR (30) NOT NULL


INSERT INTO Phases (Name) VALUES
('U pripremi'),
('U tijeku'),
('Zavrsen')

SELECT * FROM Phases

INSERT INTO Statuses (Name) VALUES
('pripravnik'),
('izbacen'),
('zavrsen Internship')

SELECT * FROM Statuses

CREATE TABLE MemebersFields(
	MemberId INT REFERENCES Members(MemberId),
	FieldId INT REFERENCES Fields(FieldId),
	PRIMARY KEY (MemberId, FieldId)
)

ALTER TABLE MemebersFields
	RENAME TO MembersFields

SELECT * FROM MembersFields

SELECT * FROM Fields

ALTER TABLE Fields
	DROP COLUMN LeaderId

INSERT INTO Fields (Name) VALUES
('Programiranje'),
('Multimedija'),
('Dizajn'),
('Marketing')



INSERT INTO MembersFields (MemberId, FieldId) VALUES
(3,1),
(4,1),
(14,2),
(14,3),
(15,3),
(16,4),
(17,1),
(17,4),
(18,2),
(19,1),
(20,1),
(21,3)

DROP TABLE Statuses


CREATE TABLE Statuses(
	InternId INT REFERENCES Interns(InternId),
	FieldId INT REFERENCES Fields(FieldId),
	InternshipId INT REFERENCES Internships(InternshipId),
	Status VARCHAR (15) CHECK (Status IN ('pripravnik', 'izbacen', 'zavrsen internship')),
	PRIMARY KEY (InternId, FieldId, InternshipId)
)

ALTER TABLE  Statuses
	ALTER COLUMN Status TYPE VARCHAR (30)

INSERT INTO Statuses (InternId, FieldId, InternshipId, Status) VALUES
(7, 1, 4, 'pripravnik'),
(7, 2, 4, 'pripravnik'),
(8, 3, 3, 'izbacen'),
(8, 3, 4, 'pripravnik'),
(9, 4, 4, 'izbacen'),
(10, 1, 3, 'zavrsen internship'),
(11, 2, 4, 'pripravnik'),
(11, 1, 4, 'izbacen'),
(12, 4, 4, 'izbacen'),
(13, 2, 3, 'zavrsen internship'),
(13, 1, 4, 'pripravnik'),
(14, 3, 3, 'izbacen')

INSERT INTO Statuses (InternId, FieldId, InternshipId, Status) VALUES
(10, 4, 3, 'zavrsen internship')
(8,1,3,'izbacen')
--triba ovo napunit sa ovin kombinacijama i posli toga ostaje ove ocjene risit

--queries
--1
SELECT FirstName, LastName FROM Members
	WHERE PlaceOfResidence NOT LIKE 'Split'
--2
SELECT BeginDate, EndDate FROM Internships
	ORDER BY BeginDate DESC
--3
SELECT FirstName, LastName FROM Interns intern
	WHERE (SELECT COUNT(*) FROM Statuses WHERE InternshipId = 3 AND intern.InternId = InternId) > 0
	
--3 (drugi nacin koji je valjda bolji)
SELECT FirstName, LastName FROM Interns intern
	WHERE (SELECT COUNT(*) FROM Statuses st WHERE intern.InternId = InternId AND 
		   (SELECT COUNT(*) FROM Internships WHERE 
			st.InternshipId = InternshipId AND date_part('year', BeginDate) = 2021) > 0) > 0

--4
SELECT COUNT(*) AS NumberOfFemaleInterns FROM Interns intern
	WHERE (SELECT COUNT (*) FROM Statuses WHERE InternshipId = 4 AND intern.InternId = InternId AND intern.Gender = 'F') > 0
--4 drugi nacin (ovo je valjda bolje)
SELECT COUNT (*) AS NumberOfFemaleInterns FROM Interns intern
	WHERE (intern.Gender = 'F' AND 
		   (SELECT COUNT (*) FROM Statuses st WHERE intern.InternId = InternId AND 
		   (SELECT COUNT (*) FROM Internships WHERE st.InternshipId = InternshipId AND 
			(CURRENT_TIMESTAMP BETWEEN BeginDate AND EndDate))>0) > 0)
--5
SELECT COUNT (*) AS NumberOfKickedOutMarketingInterns FROM Statuses
	WHERE (Status = 'izbacen' AND FieldId = 4)
--6

	