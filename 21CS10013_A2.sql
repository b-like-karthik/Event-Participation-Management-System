---- BANOTHU KARTHIK
---- 21CS10013

CREATE TABLE Role(
	RID INT NOT NULL PRIMARY KEY,
	Rname VARCHAR(100),
	Description VARCHAR(200)
);

CREATE TABLE College(
	Name VARCHAR(100) NOT NULL PRIMARY KEY,
	Location VARCHAR(100)
);

CREATE TABLE Event(
	EID INT NOT NULL PRIMARY KEY,
	date DATE,
	Ename VARCHAR(100),
	Type VARCHAR(100)
	
);

CREATE TABLE Volunteer(
	ROLL INT NOT NULL PRIMARY KEY
);

CREATE TABLE Student(
	Name VARCHAR(100),
	ROLL INT NOT NULL PRIMARY KEY,
	Dept VARCHAR(100),
	RID INT,
	FOREIGN KEY (RID) REFERENCES Role(RID)
);

CREATE TABLE Participants(
	PID INT NOT NULL PRIMARY KEY,
	Name VARCHAR(100),
	Cname VARCHAR(100),
	FOREIGN KEY (CName) REFERENCES College(Name)
);

-- relations

CREATE TABLE StudentEvent(
	ROLL INT,
	EID INT,
	FOREIGN KEY (ROLL) REFERENCES Student(ROLL),
	FOREIGN KEY (EID) REFERENCES Event(EID)
);

CREATE TABLE EventParticipants(
	EID INT,
	PID INT,
	FOREIGN KEY (EID) REFERENCES Event(EID),
	FOREIGN KEY (PID) REFERENCES Participants(PID)
);

CREATE TABLE EventVolunteer(
	EID INT,
	ROLL INT,
	FOREIGN KEY (EID) REFERENCES Event(EID),
	FOREIGN KEY (ROLL) REFERENCES Volunteer(ROLL)
);


-- insert data in to tables -- 

INSERT INTO Role (RID, Rname, Description)
VALUES (1, 'President', 'Head of the student organization');
  	(2, 'Secretary', 'Manages administrative tasks');
  	(3, 'Treasurer', 'Handles financial matters');
  	(4, 'Coordinator', 'Coordinates events');
  	(5, 'Member', 'General member of the organization');

INSERT INTO College (Name, Location)
VALUES ('IITB', 'Mumbai'),
  	('IITKGP', 'KHARAGPUR'),
  	('ABC University', 'City ABC'),
  	('DEF Institute', 'City DEF'),
  	('GHI College', 'City GHI');

INSERT INTO Student (Name, ROLL, Dept, RID)
VALUES ('John Doe', 12345, 'CSE', 1),
  	('Jane Smith', 67890, 'EEE', 2),
  	('Bob Johnson', 11111, 'MECH', 2),
  	('Alice Williams', 22222, 'CHEM', 4),
  	('Charlie Brown', 33333, 'BIO', 5),
  	('AA', 11, 'CSE', NULL),
  	('BB', 12, 'ECE',NULL),
  	('CC', 15, 'CSE',NULL),
  	('DD', 13, 'CSE',NULL),
  	('EE', 14, 'CSE',NULL);

INSERT INTO Volunteer (ROLL)
VALUES (11),
  	(12),
  	(13),
  	(14),
  	(15);

INSERT INTO Event (EID, date, Ename, Type)
VALUES (1001, '2024-01-25', 'Megaevent', 'Technical'),
  	(1002, '2024-02-15', 'Cultural Night', 'Cultural'),
  	(1003, '2024-03-10', 'Sports Meet', 'Sports'),
  	(1004, '2024-04-05', 'Science Expo', 'Science'),
  	(1005, '2024-05-20', 'Music Festival', 'Music');

INSERT INTO Participants(PID,Name,CName)
VALUES (100,'KARTHIK','IITKGP'),
	(200,'AKASH','IITB'),
	(300,'SNADEEP','IITB'),
	(400,'NAVEEN','IITB'),
	(500,'RAGHAV','IITKGP'),
	(600,'KANNA','IITKGP'),
	(700,'KAA', 'IITKGP');

INSERT INTO StudentEvent(ROLL,EID)
VALUES (12345, 1001),
	(12345, 1002),
	(67890, 1001),
	(11111, 1003),
	(33333, 1004);

INSERT INTO EventParticipants(EID,PID)
VALUES (1001, 100),
	(1001, 200),
	(1002, 200),
	(1003, 300),
	(1004, 400),
	(1001, 300),
	(1001, 600),
	(1001, 700);

INSERT INTO EventVolunteer(EID,ROLL)
VALUES (1001, 11),
	(1001, 12),
	(1002, 12),
	(1003, 13),
	(1004, 14),
	(1001, 15);


-- 1
SELECT Student.ROLL, Student.Name 
FROM Student 
INNER JOIN StudentEvent ON Student.ROLL= StudentEvent.ROLL 
WHERE StudentEvent.EID = ( SELECT Event.EID FROM Event WHERE Ename='Megaevent' ) ;

--2
SELECT Student.ROLL, Student.Name 
FROM Student 
INNER JOIN Role ON Student.RID = Role.RID 
INNER JOIN StudentEvent ON Student.ROLL=StudentEvent.ROLL
WHERE Role.Rname = 'Secretary' and StudentEvent.EID = (SELECT Event.EID FROM Event WHERE Event.Ename= 'Megaevent');

--3
SELECT Participants.Name
FROM Participants
INNER JOIN EventParticipants ON Participants.PID = EventParticipants.PID
WHERE Participants.CName = 'IITB' AND EventParticipants.EID = (SELECT Event.EID FROM Event WHERE Event.Ename = 'Megaevent');

--4
SELECT DISTINCT Participants.CName
FROM Participants
INNER JOIN EventParticipants ON Participants.PID = EventParticipants.PID
WHERE EventParticipants.EID = (SELECT Event.EID FROM Event WHERE Event.Ename = 'Megaevent');

--5
SELECT Event.Ename
FROM Event
INNER JOIN StudentEvent ON Event.EID = StudentEvent.EID
INNER JOIN Student ON StudentEvent.ROLL = Student.ROLL
INNER JOIN Role ON Student.RID = Role.RID
WHERE Role.Rname = 'Secretary';

--6
SELECT Student.Name
FROM Student
INNER JOIN EventVolunteer ON Student.ROLL = EventVolunteer.ROLL
INNER JOIN Event ON EventVolunteer.EID = Event.EID
WHERE Event.Ename = 'Megaevent' AND Student.Dept = 'CSE';

--7
SELECT DISTINCT Event.Ename
FROM Event
INNER JOIN EventVolunteer ON Event.EID = EventVolunteer.EID
INNER JOIN Student ON EventVolunteer.ROLL = Student.ROLL
WHERE Student.Dept = 'CSE';

--8
SELECT Participants.CName
FROM Participants
INNER JOIN EventParticipants ON Participants.PID = EventParticipants.PID
INNER JOIN Event ON EventParticipants.EID = Event.EID
WHERE Event.Ename = 'Megaevent'
GROUP BY Participants.cName
ORDER BY COUNT(*) DESC
LIMIT 1;

--9
SELECT Participants.CName
FROM Participants
GROUP BY Participants.cName
ORDER BY COUNT(*) DESC
LIMIT 1;

--10
SELECT Student.Dept
FROM Student
WHERE Student.ROLL IN (
    SELECT DISTINCT EventVolunteer.ROLL
    FROM EventVolunteer
    INNER JOIN EventParticipants ON EventVolunteer.EID = EventParticipants.EID
    INNER JOIN Participants ON EventParticipants.PID = Participants.PID
    WHERE Participants.CName = 'IITB'
)
GROUP BY Student.Dept
ORDER BY COUNT(*) DESC
LIMIT 1;

