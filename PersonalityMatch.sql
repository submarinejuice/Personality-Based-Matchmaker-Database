
CREATE DATABASE IF NOT EXISTS PersonalityMatch;
USE PersonalityMatch;

CREATE TABLE IF NOT EXISTS User (
    UserID INT PRIMARY KEY,
    Name VARCHAR(50) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    PhoneNumber VARCHAR(15) UNIQUE NOT NULL,
    DOB DATE,
    Username VARCHAR(50) UNIQUE,
    Location VARCHAR(100),
    Gender VARCHAR(10)
);

CREATE TABLE IF NOT EXISTS PersonalityTypes (
    PersonalityID INT PRIMARY KEY,
    PersonalityName VARCHAR(50) NOT NULL,
    PersonalityDescription VARCHAR(255)
);

CREATE TABLE IF NOT EXISTS PersonalityProfile (
    ProfileID INT PRIMARY KEY,
    UserID INT NOT NULL,
    PersonalityID INT NOT NULL,
    CompatibilityScore FLOAT NOT NULL DEFAULT 0.0,
    CHECK (CompatibilityScore >= 0.0 AND CompatibilityScore <= 100.0),
    FOREIGN KEY (UserID) REFERENCES User(UserID),
    FOREIGN KEY (PersonalityID) REFERENCES PersonalityTypes(PersonalityID)
);

CREATE TABLE IF NOT EXISTS Matches (
    MatchID INT PRIMARY KEY,
    UserID1 INT NOT NULL,
    UserID2 INT NOT NULL,
    DateMatched DATE,
    CompatibilityScore FLOAT NOT NULL,
    FOREIGN KEY (UserID1) REFERENCES User(UserID),
    FOREIGN KEY (UserID2) REFERENCES User(UserID)
);

CREATE TABLE IF NOT EXISTS InteractionHistory (
    InteractionID INT PRIMARY KEY,
    MatchID INT NOT NULL,
    Message TEXT,
    InteractionDate DATETIME,
    FOREIGN KEY (MatchID) REFERENCES Matches(MatchID)
);

CREATE TABLE IF NOT EXISTS UserPreferences (
    PreferenceID INT PRIMARY KEY,
    UserID INT NOT NULL,
    PreferenceType VARCHAR(50),
    PreferenceValue VARCHAR(100),
    FOREIGN KEY (UserID) REFERENCES User(UserID)
);

CREATE TABLE IF NOT EXISTS Interests (
    InterestID INT PRIMARY KEY,
    InterestName VARCHAR(50) NOT NULL,
    InterestDescription VARCHAR(255)
);

CREATE TABLE IF NOT EXISTS UserInterests (
    InterestID INT NOT NULL,
    UserID INT NOT NULL,
    PRIMARY KEY (InterestID, UserID),
    FOREIGN KEY (InterestID) REFERENCES Interests(InterestID),
    FOREIGN KEY (UserID) REFERENCES User(UserID)
);

CREATE TABLE IF NOT EXISTS ActivityLog (
    LogID INT PRIMARY KEY,
    UserID INT NOT NULL,
    ActivityType VARCHAR(50),
    ActivityTimeStamp DATETIME,
    FOREIGN KEY (UserID) REFERENCES User(UserID)
);

CREATE TABLE IF NOT EXISTS Compatibility (
    CompatibilityID INT PRIMARY KEY,
    UserID1 INT NOT NULL,
    UserID2 INT NOT NULL,
    CompatibilityScore FLOAT NOT NULL,
    FOREIGN KEY (UserID1) REFERENCES User(UserID),
    FOREIGN KEY (UserID2) REFERENCES User(UserID)
);


INSERT IGNORE INTO User (UserID, Name, Email, PhoneNumber, DOB, Username, Location, Gender)
VALUES
(1, 'Aidan Lin', 'linx2628@mylaurier.ca', '2263950488', '2004-11-23', 'Sushi4aidan', 'Waterloo, Canada', 'Male'),
(2, 'Michelle Chala', 'Chal1836@mylaurier.ca', '1231902389', '2004-07-11', 'doobie', 'Waterloo, Canada', 'Female');


INSERT IGNORE INTO PersonalityTypes (PersonalityID, PersonalityName, PersonalityDescription)
VALUES
(0,'Lazy', 'Loves doing nothing but napping and staying at home'),
(1,'Normal','Just your average everyday person'),
(2,'Peppy','A go-getter facing everyday with a smile'),
(3,'Jock','Sporty, in-shape, and loves to be out'),
(4,'Cranky','Might not be the happiest around, but still loving'),
(5,'Snooty','Prickly like a rose, but beautiful on the inside'),
(6,'Sisterly','Looks after everybody with their undying love'),
(7,'Smug','Shows off whenever they get an opportunity'),
(8,'Open','Their soul is a gallery ready for others to see'),
(9,'Conscientious','Always follows the rules, does what is right'),
(10,'Extroverted','The more the merrier! They love being around others'),
(11,'Introverted','Would rather be on their own, crowds are scary!'),
(12,'Neurodivergent','On the spectrum definitely!');


INSERT IGNORE INTO Compatibility (CompatibilityID, UserID1, UserID2, CompatibilityScore)
VALUES
(1,1,2,85.5);


INSERT IGNORE INTO PersonalityProfile (ProfileID, UserID, PersonalityID, CompatibilityScore)
VALUES
(0,1,0,85.5),
(1,2,6,85.5);


INSERT IGNORE INTO Matches (MatchID, UserID1, UserID2, DateMatched, CompatibilityScore)
VALUES
(1,1,2,'2025-02-07',85.5);

INSERT IGNORE INTO InteractionHistory (InteractionID, MatchID, Message, InteractionDate)
VALUES
(0,1,'hey girl - Sushi4aidan','2025-02-07 14:30:00'),
(1,1,'hey king - doobie','2025-02-07 14:45:00');


INSERT IGNORE INTO UserPreferences (PreferenceID, UserID, PreferenceType, PreferenceValue)
VALUES
(1,1,'Sexuality','Gay'),
(2,2,'Sexuality','Straight'),
(3,2,'Location','Waterloo'),
(4,2,'Screen Mode','Dark');


INSERT IGNORE INTO Interests (InterestID, InterestName, InterestDescription)
VALUES
(0,'Sports','Watching, playing sports'),
(1,'Make-up','Applying, experimenting, using make-up products'),
(2,'Video Games','Playing, discussing, and learning about video games'),
(3,'Movies','Watching and discussing movies'),
(4,'Fashion','Dressing up, shopping for clothes, discussing fashion trends'),
(6,'Music','Listening to, discussing music, and attending concerts');


INSERT IGNORE INTO UserInterests (InterestID, UserID)
VALUES
(2,1),
(6,1),
(2,2),
(6,2);


INSERT IGNORE INTO ActivityLog (LogID, UserID, ActivityType, ActivityTimeStamp)
VALUES
(0,2,'Sent Message','2025-02-07 14:30:00'),
(1,1,'Sent Message','2025-02-07 14:45:00');


WITH RECURSIVE UserNetwork AS (
    SELECT 
        UserID AS Origin, 
        UserID AS ConnectedUser,
        CAST(UserID AS CHAR(100)) AS path
    FROM User
    WHERE UserID = 1

    UNION ALL

    SELECT 
        un.Origin,
        CASE 
            WHEN m.UserID1 = un.ConnectedUser THEN m.UserID2 
            ELSE m.UserID1 
        END AS ConnectedUser,
        CONCAT(un.path, ',', CASE 
            WHEN m.UserID1 = un.ConnectedUser THEN m.UserID2 
            ELSE m.UserID1 
        END) AS path
    FROM Matches m
    JOIN UserNetwork un 
      ON (m.UserID1 = un.ConnectedUser OR m.UserID2 = un.ConnectedUser)
    WHERE FIND_IN_SET(
            CASE 
                WHEN m.UserID1 = un.ConnectedUser THEN m.UserID2 
                ELSE m.UserID1 
            END, un.path) = 0
)
SELECT DISTINCT ConnectedUser
FROM UserNetwork
WHERE ConnectedUser <> 1;


(SELECT DISTINCT u.UserID, u.Name, 'High Match' AS Source
 FROM User u
 JOIN Matches m 
    ON u.UserID = m.UserID1 OR u.UserID = m.UserID2 
 WHERE m.CompatibilityScore > 80)
UNION
(SELECT DISTINCT u.UserID, u.Name, 'Recent Activity' AS Source 
 FROM User u
 JOIN ActivityLog a1
    ON u.UserID = a1.UserID
 WHERE a1.ActivityTimeStamp >= DATE_SUB(CURDATE(), INTERVAL 1 MONTH)
);


SELECT 
    u.Location,
    AVG(m.CompatibilityScore) AS AvgCompatibilityScore,
    COUNT(*) AS TotalMatches
FROM User u
JOIN Matches m
    ON u.UserID = m.UserID1 OR u.UserID = m.UserID2
GROUP BY u.Location
ORDER BY AvgCompatibilityScore DESC;

SELECT 
    u.UserID,
    u.Name,
    COUNT(m.MatchID) AS TotalMatches,
    RANK() OVER (ORDER BY COUNT(m.MatchID) DESC) AS MatchRank
FROM User u
LEFT JOIN Matches m
    ON u.UserID = m.UserID1 OR u.UserID = m.UserID2
GROUP BY u.UserID, u.Name
ORDER BY MatchRank;


SELECT 
    pt.PersonalityName,
    MIN(pp.CompatibilityScore) AS MinScore,
    MAX(pp.CompatibilityScore) AS MaxScore,
    AVG(pp.CompatibilityScore) AS AvgScore,
    STD(pp.CompatibilityScore) AS StdDevScore
FROM PersonalityTypes pt
JOIN PersonalityProfile pp
    ON pt.PersonalityID = pp.PersonalityID
GROUP BY pt.PersonalityName
ORDER BY AvgScore DESC;


SELECT 
    m.MatchID,
    m.UserID1,
    m.UserID2,
    COUNT(ih.InteractionID) AS InteractionCount
FROM Matches m
JOIN InteractionHistory ih
    ON m.MatchID = ih.MatchID
GROUP BY m.MatchID, m.UserID1, m.UserID2
HAVING InteractionCount > (
    SELECT AVG(cnt)
    FROM (
        SELECT COUNT(*) AS cnt
        FROM InteractionHistory
        GROUP BY MatchID
    ) AS InteractionCounts
);


SELECT DISTINCT 
    u.UserID,
    u.Name,
    i.InterestName
FROM User u
JOIN UserInterests ui
    ON u.UserID = ui.UserID
JOIN Interests i
    ON ui.InterestID = i.InterestID
WHERE i.InterestID IN (
    SELECT ui2.InterestID
    FROM UserInterests ui2
    WHERE ui2.UserID = 1
)
  AND u.UserID <> 1
  AND u.UserID IN (
      SELECT CASE
          WHEN m.UserID1 = 1 THEN m.UserID2
          ELSE m.UserID1
      END
      FROM Matches m 
      WHERE (m.UserID1 = 1 OR m.UserID2 = 1)
        AND m.CompatibilityScore > 80
  ) 
ORDER BY u.Name, i.InterestName;

CREATE OR REPLACE VIEW UserMatchCountView AS
SELECT
    u.UserID,
    u.Name,
    u.Email,
    (SELECT COUNT(*)
     FROM Matches m
     WHERE m.UserID1 = u.UserID OR m.UserID2 = u.UserID) AS TotalMatches
FROM User u;

SELECT * FROM UserMatchCountView;

CREATE OR REPLACE VIEW HighCompatibilityUsersView AS
SELECT
    d.UserID,
    d.Name,
    d.MaxCompatibility
FROM (
    SELECT
        u.UserID,
        u.Name,
        MAX(pp.CompatibilityScore) AS MaxCompatibility
    FROM User u
    JOIN PersonalityProfile pp 
        ON u.UserID = pp.UserID
    GROUP BY u.UserID, u.Name
) AS d
WHERE d.MaxCompatibility >= 80;

SELECT * FROM HighCompatibilityUsersView;

CREATE OR REPLACE VIEW ActiveUsersView AS
SELECT 
    u.UserID,
    u.Name,
    u.Email
FROM User u
WHERE u.UserID IN (
    SELECT DISTINCT a1.UserID
    FROM ActivityLog a1
    WHERE a1.ActivityTimeStamp >= DATE_SUB(CURDATE(), INTERVAL 1 MONTH)
);

SELECT * FROM ActiveUsersView;


SHOW DATABASES;
