CREATE DATABASE Hospital;
USE Hospital;

CREATE TABLE Departments (
    DepartmentID INT PRIMARY KEY,
    Name NVARCHAR(50) NOT NULL,
    Building NVARCHAR(50) NOT NULL,
    Donation MONEY NOT NULL DEFAULT 0
);

CREATE TABLE Doctors (
    DoctorID INT PRIMARY KEY,
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    Rate MONEY NOT NULL,
    DepartmentID INT FOREIGN KEY REFERENCES Departments(DepartmentID)
);

CREATE TABLE Wards (
    WardID INT PRIMARY KEY,
    Name NVARCHAR(50) NOT NULL,
    Capacity INT NOT NULL,
    DepartmentID INT FOREIGN KEY REFERENCES Departments(DepartmentID)
);

CREATE TABLE Sponsors (
    SponsorID INT PRIMARY KEY,
    Name NVARCHAR(50) NOT NULL
);

CREATE TABLE Donations (
    DonationID INT PRIMARY KEY,
    Amount MONEY NOT NULL,
    SponsorID INT FOREIGN KEY REFERENCES Sponsors(SponsorID),
    DepartmentID INT FOREIGN KEY REFERENCES Departments(DepartmentID)
);

CREATE TABLE Examinations (
    ExaminationID INT PRIMARY KEY,
    StartTime TIME NOT NULL,
    EndTime TIME NOT NULL,
    DoctorID INT FOREIGN KEY REFERENCES Doctors(DoctorID),
    DepartmentID INT FOREIGN KEY REFERENCES Departments(DepartmentID)
);

INSERT INTO Departments (DepartmentID, Name, Building, Donation) VALUES
(1, 'Cardiology', 'Building A', 5000),
(2, 'Gastroenterology', 'Building A', 8000),
(3, 'General Surgery', 'Building B', 6000),
(4, 'Microbiology', 'Building C', 3000),
(5, 'Neurology', 'Building B', 4000),
(6, 'Oncology', 'Building C', 7000);

INSERT INTO Doctors (DoctorID, FirstName, LastName, Rate, DepartmentID) VALUES
(1, 'John', 'Smith', 120, 1),
(2, 'Jane', 'Doe', 150, 2),
(3, 'Thomas', 'Gerada', 130, 3),
(4, 'Anthony', 'Davis', 140, 4),
(5, 'Joshua', 'Bell', 110, 5);

INSERT INTO Wards (WardID, Name, Capacity, DepartmentID) VALUES
(1, 'Ward 101', 20, 1),
(2, 'Ward 201', 15, 2),
(3, 'Ward 301', 25, 3),
(4, 'Ward 102', 18, 1),
(5, 'Ward 202', 12, 2);

INSERT INTO Sponsors (SponsorID, Name) VALUES
(1, 'ABC Foundation'),
(2, 'XYZ Corporation'),
(3, '123 Charity');

INSERT INTO Donations (DonationID, Amount, SponsorID, DepartmentID) VALUES
(1, 2000, 1, 1),
(2, 3000, 2, 2),
(3, 1500, 3, 3),
(4, 1200, 1, 4),
(5, 1800, 2, 5);

INSERT INTO Examinations (ExaminationID, StartTime, EndTime, DoctorID, DepartmentID) VALUES
(1, '12:30', '14:30', 1, 1),
(2, '14:00', '16:00', 2, 2),
(3, '12:00', '13:30', 3, 3),
(4, '15:00', '16:30', 4, 4),
(5, '11:00', '12:30', 5, 5);

SELECT Name FROM Departments
WHERE Building = (SELECT Building FROM Departments WHERE Name = 'Cardiology');

SELECT Name FROM Departments
WHERE Building = (SELECT Building FROM Departments WHERE Name IN ('Gastroenterology', 'General Surgery'));

SELECT TOP 1 Name
FROM Departments
ORDER BY Donation;

SELECT LastName
FROM Doctors
WHERE Rate > (SELECT Rate FROM Doctors WHERE LastName = 'Thomas Gerada');

SELECT Wards.Name
FROM Wards
INNER JOIN Departments ON Wards.DepartmentID = Departments.DepartmentID
WHERE Departments.Name = 'Microbiology' AND Wards.Capacity > (SELECT AVG(Wards.Capacity) FROM Wards WHERE Wards.DepartmentID = Departments.DepartmentID);

SELECT CONCAT(FirstName, ' ', LastName) AS FullName
FROM Doctors
WHERE Rate + (SELECT Rate FROM Doctors WHERE LastName = 'Anthony Davis') > 100 + (SELECT Rate FROM Doctors WHERE LastName = 'Anthony Davis');

SELECT DISTINCT Departments.Name
FROM Examinations
INNER JOIN Departments ON Examinations.DepartmentID = Departments.DepartmentID
INNER JOIN Doctors ON Examinations.DoctorID = Doctors.DoctorID
WHERE Doctors.FirstName = 'Joshua' AND Doctors.LastName = 'Bell';

SELECT DISTINCT Sponsors.Name
FROM Sponsors
WHERE NOT EXISTS (
    SELECT 1
    FROM Departments
    WHERE Departments.Name IN ('Neurology', 'Oncology')
    AND NOT EXISTS (
        SELECT 1
        FROM Donations
        WHERE Donations.SponsorID = Sponsors.SponsorID AND Donations.DepartmentID = Departments.DepartmentID
    )
);

SELECT DISTINCT Doctors.LastName
FROM Examinations
INNER JOIN Doctors ON Examinations.DoctorID = Doctors.DoctorID
WHERE StartTime >= '12:00' AND EndTime <= '15:00';
