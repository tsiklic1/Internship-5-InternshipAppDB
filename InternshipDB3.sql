--Fields
CREATE TABLE Fields(
	FieldId SERIAL PRIMARY KEY,
	Name VARCHAR(30) NOT NULL
);
	
INSERT INTO Fields (Name) VALUES
('Programiranje'),
('Multimedija'),
('Dizajn'),
('Marketing');	
	
SELECT * FROM Fields

--Interns
CREATE TABLE Interns(
	InternId SERIAL PRIMARY KEY,
	FirstName VARCHAR(30),
	LastName VARCHAR(30),
	Pin VARCHAR(11) CHECK(LENGTH(Pin) = 11),
	DateOfBirth TIMESTAMP,
	Gender VARCHAR(1) CHECK(Gender IN('M','F')),
	PlaceOfResidence VARCHAR (30) NOT NULL,
	CONSTRAINT InternOlderThan16 CHECK((CURRENT_TIMESTAMP - DateOfBirth) >= INTERVAL '16 year'),
	CONSTRAINT InternYoungerThan24 CHECK((CURRENT_TIMESTAMP - DateOfBirth) <= INTERVAL '24 year'),
	CONSTRAINT InternPinIsUnique UNIQUE(Pin)
);


INSERT INTO Interns(FirstName, LastName, Pin, DateOfBirth, Gender, PlaceOfResidence) VALUES
('Mijo', 'Catipovic', '39204716391', '2000-1-1', 'M', 'Split'),
('Dorian', 'Bralic', '11111111111', '2000-4-4', 'M', 'Split'),
('Duje', 'Matkovic', '22222222222', '2004-7-2', 'M', 'Split'),
('Branka', 'Glavurdic', '33333333333', '2000-5-5', 'F', 'Omis'),
('Ljiljana', 'Tomic', '44444444444', '2002-11-7', 'F', 'Zagreb'),
('Tea', 'Franic', '55555555555', '2004-7-1', 'F', 'Trogir'),
('Marita', 'Andrijolic', '20473928450','2002-4-8', 'F', 'Split'),
('Roko', 'Burazin', '29305489100','1999-12-12', 'M', 'Split');


SELECT * FROM Interns

--Members
CREATE TABLE Members(
	MemberId SERIAL PRIMARY KEY,
	FirstName VARCHAR (30),
	LastName VARCHAR (30),
	Pin VARCHAR(11) CHECK(LENGTH(Pin) = 11) UNIQUE,
	DateOfBirth TIMESTAMP,
	Gender VARCHAR(1) CHECK(Gender IN('M', 'F')),
	PlaceOfResidence VARCHAR (30) NOT NULL
);

INSERT INTO Members (FirstName, LastName, Pin, DateOfBirth, Gender, PlaceOfResidence) VALUES
('Jure', 'Mesin', '34294846701', '1995-3-2', 'M', 'Split'),
('Lana', 'Hrstic', '49375638104', '1999-4-8', 'F', 'Sinj'),
('Mirta', 'Jozic', '48929471740', '2003-7-7', 'F', 'Split'),
('Ivo', 'Ivic', '31038572850', '1999-1-12', 'M', 'Makarska'),
('Miro', 'Trogrlic', '49204817493', '2001-2-2', 'M', 'Split'),
('Dino', 'Dabic', '30182859309', '2002-5-2', 'M', 'Zagreb'),
('Tina', 'Barun', '12121212121', '2003-3-8', 'F', 'Split'),
('Marko', 'Peric', '34562739581', '2000-1-2', 'M', 'Trogir');


SELECT * FROM Members;	

--Phases
CREATE TABLE Phases(
	PhaseId SERIAL PRIMARY KEY,
	Name VARCHAR(12) CHECK(Name IN('U pripremi','U tijeku', 'Zavrsen'))
);
	
INSERT INTO Phases (Name) VALUES
('U pripremi'),
('U tijeku'),
('Zavrsen');

SELECT * FROM Phases	

--Internships
CREATE TABLE Internships(
	InternshipId SERIAL PRIMARY KEY,
	BeginDate TIMESTAMP,
	EndDate TIMESTAMP,
	PhaseId INT REFERENCES Phases(PhaseId),
	LeaderId INT REFERENCES Members(MemberId),
);

ALTER TABLE Internships
DROP COLUMN LeaderId

INSERT INTO Internships (BeginDate, EndDate, PhaseId) VALUES
('2021-11-1', '2022-5-1', 3),
('2022-11-3', '2023-4-28', 2),
('2023-10-30', '2024-4-30', 1);

SELECT * FROM Internships;

--InternshipsLeaders
CREATE TABLE InternshipsLeader(
	Id SERIAL PRIMARY KEY,
	InternshipId INT REFERENCES Internships(InternshipId),
	LeaderId INT REFERENCES Members(MemberId),
	CONSTRAINT UniqueInternshipLeaderPair UNIQUE (InternshipId, LeaderId)
)
ALTER TABLE InternshipsLeader
	ADD CONSTRAINT UniqueInternship UNIQUE (InternshipId)

INSERT INTO InternshipsLeader (InternshipId, LeaderId) VALUES
(3,66),
(1,2),
(2,5);

SELECT * FROM InternshipsLeader

--Statuses
CREATE TABLE Statuses(
	StatusId SERIAL PRIMARY KEY,
	InternId INT REFERENCES Interns(InternId),
	FieldId INT REFERENCES Fields(FieldId),
	InternshipId INT REFERENCES Internships(InternshipId),
	Status VARCHAR (30) CHECK (Status IN ('pripravnik', 'izbacen', 'zavrsen internship'))
);

INSERT INTO Statuses (InternId, FieldId, InternshipId, Status) VALUES
(2, 2, 1, 'izbacen'),
(3, 3, 2, 'pripravnik'),
(4, 4, 2, 'pripravnik'),
(1, 1, 2, 'pripravnik');

INSERT INTO Statuses (InternId, FieldId, InternshipId, Status) VALUES
(5,4, 2, 'izbacen'),
(5,2,1, 'zavrsen internship'),
(6,1,2, 'izbacen'),
(7,2,2, 'pripravnik'),
(8, 3, 1, 'izbacen');


SELECT * FROM Statuses;


--MembersFields
CREATE TABLE MembersFields(
	MemberId INT REFERENCES Members(MemberId),
	FieldId INT REFERENCES Fields(FieldId),
	PRIMARY KEY (MemberId, FieldId),
	CONSTRAINT StatusCascadeDeleteMember FOREIGN KEY (MemberId)
	REFERENCES Members(MemberId) ON DELETE CASCADE	
);

INSERT INTO MembersFields (MemberId, FieldId) VALUES
(66,1),
(2,1),
(3,2),
(3,3),
(4,3),
(5,4),
(6,1),
(6,4),
(7,2),
(8,1);

SELECT * FROM MembersFields

--Homeworks
CREATE TABLE Homeworks(
	HomeworkId SERIAL PRIMARY KEY,
	InternId INT REFERENCES Interns(InternId),
	FieldId INT REFERENCES Fields(FieldId),
	MemberId INT REFERENCES Members(MemberId),
	Grade INT CHECK(Grade >= 1 AND Grade<=5),
	CONSTRAINT StatusCascadeDeleteMember FOREIGN KEY (MemberId)
	REFERENCES Members (MemberId) ON DELETE CASCADE,
	CONSTRAINT StatusCascadeDeleteIntern FOREIGN KEY (InternId)
	REFERENCES Interns (InternId) ON DELETE CASCADE
	
);

ALTER TABLE Homeworks
DROP CONSTRAINT StatusCascadeDeleteMember,
DROP CONSTRAINT StatusCascadeDeleteIntern;


INSERT INTO Homeworks (InternId, FieldId, MemberId, Grade) VALUES
(1,1,66, 3),
(1,1,66, 2),
(1,1,66, 1),
(3,3,4, 5),
(3,3,4, 3);

INSERT INTO Homeworks(InternId, FieldId, MemberId, Grade) VALUES


--queries
--1
SELECT FirstName, LastName FROM Members
	WHERE PlaceOfResidence NOT LIKE 'Split'
--2
SELECT BeginDate, EndDate FROM Internships
	ORDER BY BeginDate DESC
--3
SELECT FirstName, LastName FROM Interns intern
	WHERE (SELECT COUNT(*) FROM Statuses st WHERE intern.InternId = InternId AND 
		   (SELECT COUNT(*) FROM Internships WHERE 
			st.InternshipId = InternshipId AND date_part('year', BeginDate) = 2021) > 0) > 0

--4 
SELECT COUNT (*) AS NumberOfFemaleInterns FROM Interns intern
	WHERE (intern.Gender = 'F' AND 
		   (SELECT COUNT (*) FROM Statuses st WHERE intern.InternId = InternId AND 
		   (SELECT COUNT (*) FROM Internships WHERE st.InternshipId = InternshipId AND 
			(CURRENT_TIMESTAMP BETWEEN BeginDate AND EndDate))>0) > 0)
			
--5
SELECT COUNT (*) AS NumberOfKickedOutMarketingInterns FROM Statuses st
	WHERE (Status = 'izbacen' AND 
		  (SELECT COUNT(*) FROM Fields WHERE st.FieldId = FieldId AND Name = 'Marketing') > 0)
--6
UPDATE Members	
	SET PlaceOfResidence = 'Moskva'
	WHERE LastName LIKE '%in';

SELECT * FROM Members

--query 7

UPDATE Homeworks hom
	SET MemberId = NULL
	WHERE (SELECT COUNT(*) FROM Members WHERE hom.MemberId = MemberId AND 
		   (CURRENT_TIMESTAMP - DateOfBirth) >= INTERVAL '25 year') > 0;

DELETE FROM MembersFields mem
	WHERE (SELECT COUNT(*) FROM Members WHERE mem.MemberId = MemberId AND 
		   (CURRENT_TIMESTAMP - DateOfBirth) >= INTERVAL '25 year') > 0;

/*UPDATE Statuses st --ovo nije dobro
	SET InternshipId = NULL
	WHERE (SELECT COUNT (*) FROM Internships ints WHERE st.InternshipId = ints.InternshipId AND
		  (SELECT COUNT(*) FROM Members WHERE ints.LeaderId = MemberId AND 
		   (CURRENT_TIMESTAMP - DateOfBirth) >= INTERVAL '25 year') > 0) > 0;*/

UPDATE InternshipsLeader ints
	SET LeaderId = NULL
	WHERE (SELECT COUNT(*) FROM Members WHERE ints.LeaderId = MemberId AND 
		   (CURRENT_TIMESTAMP - DateOfBirth) >= INTERVAL '25 year') > 0;
SELECT * FROM InternshipsLeader 
 
DELETE FROM Members
	WHERE (CURRENT_TIMESTAMP - DateOfBirth) >= INTERVAL '25 year'
	
--8
UPDATE Statuses st
	SET Status = 'izbacen'
	WHERE (SELECT AVG(Grade) FROM Homeworks hw WHERE st.InternId = hw.InternId AND st.FieldId = hw.FieldId
		  GROUP BY hw.Internid,hw.FieldId) < 2.4;
SELECT * FROM Statuses	  
		
		  
		  



