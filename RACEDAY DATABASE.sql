-- ============================================
-- 1. CREATE DATABASE
-- ============================================

-- Create the RaceDay database
CREATE DATABASE RaceDay;
GO

-- Use the RaceDay database
USE RaceDay;
GO

-- ============================================
-- 2. CREATE TABLES
-- ============================================

-- Table: Roles
CREATE TABLE Roles (
    RoleID INT IDENTITY(1,1) PRIMARY KEY,
    RoleName VARCHAR(50) NOT NULL UNIQUE,
    Description VARCHAR(200) NOT NULL
);
GO

-- Table: Users
CREATE TABLE Users (
    UserID INT IDENTITY(1,1) PRIMARY KEY,
    RoleID INT NOT NULL,
    Email VARCHAR(100) NOT NULL UNIQUE,
    PasswordHash VARCHAR(255) NOT NULL, -- For Part 2, we'll hash passwords
    FullName VARCHAR(100) NOT NULL,
    PhoneNumber VARCHAR(20) NULL,
    CreatedAt DATETIME DEFAULT GETDATE(),
    IsActive BIT DEFAULT 1,
    CONSTRAINT FK_Users_Roles FOREIGN KEY (RoleID) REFERENCES Roles(RoleID)
);
GO

-- Table: Categories
CREATE TABLE Categories (
    CategoryID INT IDENTITY(1,1) PRIMARY KEY,
    CategoryName VARCHAR(50) NOT NULL UNIQUE,
    Description VARCHAR(200) NULL,
    DistanceKm DECIMAL(5,2) NOT NULL
);
GO

-- Table: Events
CREATE TABLE Events (
    EventID INT IDENTITY(1,1) PRIMARY KEY,
    OrganiserID INT NOT NULL,
    EventName VARCHAR(100) NOT NULL,
    Description VARCHAR(500) NULL,
    EventDate DATETIME NOT NULL,
    Location VARCHAR(200) NOT NULL,
    MaxCapacity INT NOT NULL,
    IsActive BIT DEFAULT 1,
    CreatedAt DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_Events_Users FOREIGN KEY (OrganiserID) REFERENCES Users(UserID)
);
GO

-- Table: EventCategories (Junction table for many-to-many between Events and Categories)
CREATE TABLE EventCategories (
    EventCategoryID INT IDENTITY(1,1) PRIMARY KEY,
    EventID INT NOT NULL,
    CategoryID INT NOT NULL,
    EntryFee DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    StartTime TIME NOT NULL,
    IsActive BIT DEFAULT 1,
    CONSTRAINT FK_EventCategories_Events FOREIGN KEY (EventID) REFERENCES Events(EventID),
    CONSTRAINT FK_EventCategories_Categories FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID),
    CONSTRAINT UQ_EventCategory UNIQUE (EventID, CategoryID)
);
GO

-- Table: Enrolments
CREATE TABLE Enrolments (
    EnrolmentID INT IDENTITY(1,1) PRIMARY KEY,
    EventCategoryID INT NOT NULL,
    ParticipantID INT NOT NULL,
    EnrolmentDate DATETIME DEFAULT GETDATE(),
    Status VARCHAR(20) DEFAULT 'Pending' CHECK (Status IN ('Pending', 'Approved', 'Rejected', 'Cancelled', 'Completed')),
    CONSTRAINT FK_Enrolments_EventCategories FOREIGN KEY (EventCategoryID) REFERENCES EventCategories(EventCategoryID),
    CONSTRAINT FK_Enrolments_Users FOREIGN KEY (ParticipantID) REFERENCES Users(UserID),
    CONSTRAINT UQ_Enrolment_Participant_Event UNIQUE (EventCategoryID, ParticipantID)
);
GO

-- Table: Results
CREATE TABLE Results (
    ResultID INT IDENTITY(1,1) PRIMARY KEY,
    EnrolmentID INT NOT NULL,
    FinishTime TIME NULL,
    Position INT NULL,
    Status VARCHAR(20) DEFAULT 'Pending' CHECK (Status IN ('Pending', 'Verified', 'Disqualified')),
    RecordedAt DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_Results_Enrolments FOREIGN KEY (EnrolmentID) REFERENCES Enrolments(EnrolmentID),
    CONSTRAINT UQ_Result_Enrolment UNIQUE (EnrolmentID)
);
GO

-- ============================================
-- 3. INSERT SAMPLE DATA (SEED DATA)
-- ============================================

-- Insert Roles
INSERT INTO Roles (RoleName, Description) VALUES 
('Organiser', 'Event organisers who create and manage events'),
('Participant', 'Participants who browse events and enrol in races');
GO

-- Insert Organisers (RoleID = 1)
INSERT INTO Users (RoleID, Email, PasswordHash, FullName, PhoneNumber) VALUES 
(1, 'john.organiser@raceday.co.za', 'hashed_password_here', 'John Ndlovu', '0821234567'),
(1, 'sarah.organiser@raceday.co.za', 'hashed_password_here', 'Sarah Naidoo', '0839876543');
GO

-- Insert Participants (RoleID = 2)
INSERT INTO Users (RoleID, Email, PasswordHash, FullName, PhoneNumber) VALUES 
(2, 'thabo.running@email.com', 'hashed_password_here', 'Thabo Mokoena', '0712345678'),
(2, 'zanele.cycling@email.com', 'hashed_password_here', 'Zanele Nkosi', '0723456789'),
(2, 'pieter.athlete@email.com', 'hashed_password_here', 'Pieter Venter', '0734567890');
GO

-- Insert Categories
INSERT INTO Categories (CategoryName, Description, DistanceKm) VALUES 
('5km Fun Run', 'Family-friendly 5 kilometre run/walk', 5.00),
('10km Road Race', 'Challenging 10 kilometre road race', 10.00),
('21km Half Marathon', 'Competitive half marathon distance', 21.10),
('42km Marathon', 'Full marathon distance', 42.20),
('50km Cycle', 'Road cycling event - 50km', 50.00),
('100km Cycle', 'Long distance cycling event - 100km', 100.00);
GO

-- Insert Events
INSERT INTO Events (OrganiserID, EventName, Description, EventDate, Location, MaxCapacity) VALUES 
(1, 'Soweto Marathon 2026', 'Annual Soweto Marathon featuring half and full marathon distances', '2026-11-15 06:00:00', 'Soweto, Johannesburg', 25000),
(1, 'Cape Town Cycle Tour', 'The largest timed cycling event in the world', '2026-03-08 07:00:00', 'Cape Town, Western Cape', 35000),
(2, 'Durban Summer Run', 'Scenic coastal run in Durban with multiple distances', '2026-01-25 05:30:00', 'Durban, KwaZulu-Natal', 15000);
GO

-- Insert EventCategories (Linking Events to Categories)
-- Soweto Marathon (EventID = 1)
INSERT INTO EventCategories (EventID, CategoryID, EntryFee, StartTime) VALUES 
(1, 3, 350.00, '06:00:00'), -- Half Marathon
(1, 4, 450.00, '06:00:00'); -- Full Marathon

-- Cape Town Cycle Tour (EventID = 2)
INSERT INTO EventCategories (EventID, CategoryID, EntryFee, StartTime) VALUES 
(2, 5, 200.00, '07:30:00'), -- 50km Cycle
(2, 6, 350.00, '07:00:00'); -- 100km Cycle

-- Durban Summer Run (EventID = 3)
INSERT INTO EventCategories (EventID, CategoryID, EntryFee, StartTime) VALUES 
(3, 1, 100.00, '05:30:00'), -- 5km Fun Run
(3, 2, 180.00, '06:00:00'); -- 10km Road Race

GO

-- Insert Enrolments
-- Thabo enrols in Soweto Marathon - Half Marathon (EventCategoryID = 1)
INSERT INTO Enrolments (EventCategoryID, ParticipantID, Status) VALUES 
(1, 3, 'Approved'),  -- Thabo in Half Marathon
(2, 3, 'Pending'),   -- Thabo in Full Marathon

-- Zanele enrols in Cape Town Cycle Tour - 100km (EventCategoryID = 4)
(4, 4, 'Approved'),  -- Zanele in 100km Cycle

-- Pieter enrols in Durban Summer Run - 10km (EventCategoryID = 6)
(6, 5, 'Approved'),  -- Pieter in 10km

-- Thabo also enrols in Durban Summer Run - 10km (EventCategoryID = 6)
(6, 3, 'Pending');   -- Thabo in 10km
GO

-- Insert Results
-- Results for approved enrolments
INSERT INTO Results (EnrolmentID, FinishTime, Position, Status) VALUES 
(1, '02:15:30', 45, 'Verified'),    -- Thabo - Half Marathon
(3, '04:30:15', 120, 'Verified'),   -- Zanele - 100km Cycle
(4, '00:55:45', 23, 'Verified');    -- Pieter - 10km
GO

-- ============================================
-- 4. VIEW DATA (For verification)
-- ============================================

-- View all users with roles
SELECT u.UserID, u.FullName, u.Email, r.RoleName 
FROM Users u
INNER JOIN Roles r ON u.RoleID = r.RoleID;
GO

-- View all events with organiser details
SELECT e.EventID, e.EventName, e.EventDate, e.Location, u.FullName AS Organiser
FROM Events e
INNER JOIN Users u ON e.OrganiserID = u.UserID;
GO

-- View all event categories with fees
SELECT e.EventName, c.CategoryName, ec.EntryFee, ec.StartTime
FROM EventCategories ec
INNER JOIN Events e ON ec.EventID = e.EventID
INNER JOIN Categories c ON ec.CategoryID = c.CategoryID;
GO

-- View enrolments with participant and event details
SELECT 
    en.EnrolmentID,
    u.FullName AS Participant,
    e.EventName,
    c.CategoryName,
    en.Status AS EnrolmentStatus,
    en.EnrolmentDate
FROM Enrolments en
INNER JOIN EventCategories ec ON en.EventCategoryID = ec.EventCategoryID
INNER JOIN Events e ON ec.EventID = e.EventID
INNER JOIN Categories c ON ec.CategoryID = c.CategoryID
INNER JOIN Users u ON en.ParticipantID = u.UserID;
GO

-- View results with participant names and event details
SELECT 
    r.ResultID,
    u.FullName AS Participant,
    e.EventName,
    c.CategoryName,
    r.FinishTime,
    r.Position,
    r.Status AS ResultStatus
FROM Results r
INNER JOIN Enrolments en ON r.EnrolmentID = en.EnrolmentID
INNER JOIN EventCategories ec ON en.EventCategoryID = ec.EventCategoryID
INNER JOIN Events e ON ec.EventID = e.EventID
INNER JOIN Categories c ON ec.CategoryID = c.CategoryID
INNER JOIN Users u ON en.ParticipantID = u.UserID
ORDER BY r.Position;
GO

-- ============================================
-- END OF SQL SCRIPT
-- ============================================