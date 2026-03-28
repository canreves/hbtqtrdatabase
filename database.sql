-- ==========================================
-- HABIT QUITTER DATABASE
-- ==========================================

-- ==========================================
-- PART 1: TABLE CREATION
-- ==========================================

-- 1. Main entity: User
CREATE TABLE User (
    User_ID INT PRIMARY KEY,
    Username VARCHAR(50) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    Join_Date DATE NOT NULL
);

-- 2. Entities dependent on User
CREATE TABLE Habit_Plan (
    Plan_ID INT PRIMARY KEY,
    User_ID INT NOT NULL, -- Total participation rule
    Habit_Name VARCHAR(100) NOT NULL,
    Start_Date DATE NOT NULL,
    Daily_Limit_Goal INT,
    CONSTRAINT fk_user_plan FOREIGN KEY (User_ID) REFERENCES User(User_ID)
);

CREATE TABLE Accountability_Partner (
    Partner_ID INT PRIMARY KEY,
    User_ID INT NOT NULL, -- Total participation rule
    Partner_Name VARCHAR(100) NOT NULL,
    Contact_Email VARCHAR(100) NOT NULL,
    Partner_Role VARCHAR(50),
    CONSTRAINT fk_user_partner FOREIGN KEY (User_ID) REFERENCES User(User_ID)
);

-- 3. Entities dependent on Habit_Plan
CREATE TABLE Relapse_Log (
    Log_ID INT PRIMARY KEY,
    Plan_ID INT NOT NULL, -- Total participation rule
    Incident_Date TIMESTAMP NOT NULL,
    Trigger_Reason VARCHAR(255),
    Severity_Level INT CHECK(Severity_Level BETWEEN 1 AND 10),
    User_Journal TEXT,
    CONSTRAINT fk_plan_log FOREIGN KEY (Plan_ID) REFERENCES Habit_Plan(Plan_ID)
);

CREATE TABLE Alternative_Activity (
    Activity_ID INT PRIMARY KEY,
    Plan_ID INT NOT NULL, -- Total participation rule
    Activity_Name VARCHAR(100) NOT NULL,
    Duration_Mins INT NOT NULL,
    CONSTRAINT fk_plan_activity FOREIGN KEY (Plan_ID) REFERENCES Habit_Plan(Plan_ID)
);

CREATE TABLE Progress_Report (
    Report_ID INT PRIMARY KEY,
    Plan_ID INT NOT NULL, -- Total participation rule
    Generation_Date DATE NOT NULL,
    Success_Score DECIMAL(5,2),
    AI_Summary_Text TEXT,
    CONSTRAINT fk_plan_report FOREIGN KEY (Plan_ID) REFERENCES Habit_Plan(Plan_ID)
);

-- 4. Weak entity dependent on Habit_Plan with composite key
CREATE TABLE Milestone (
    Plan_ID INT,
    Target_Day_Count INT,
    Description VARCHAR(255),
    PRIMARY KEY (Plan_ID, Target_Day_Count), -- Composite PK
    CONSTRAINT fk_plan_milestone FOREIGN KEY (Plan_ID) REFERENCES Habit_Plan(Plan_ID) ON DELETE CASCADE
);

-- 5. Weak entity dependent on Milestone
CREATE TABLE Reward (
    Reward_ID INT PRIMARY KEY,
    Plan_ID INT NOT NULL, -- Total participation rule
    Target_Day_Count INT NOT NULL, -- Total participation rule
    Badge_Name VARCHAR(100) NOT NULL,
    Issue_Date DATE NOT NULL,
    CONSTRAINT fk_milestone_reward FOREIGN KEY (Plan_ID, Target_Day_Count) 
        REFERENCES Milestone(Plan_ID, Target_Day_Count)
);


-- ==========================================
-- PART 2: DATA POPULATION (DML - Insert Operations)
-- ==========================================

-- 1. USER TABLE (Independent table, populated first)
INSERT INTO User (User_ID, Username, Email, Join_Date) VALUES
(1, 'cansever', 'can.sever@gmail.com', '2023-11-15'),
(2, 'emreaksoy', 'emre.aksoy@gmail.com', '2023-12-01'),
(3, 'erenharley', 'eren.harley@gmail.com', '2024-01-10'),
(4, 'johndoe', 'johndoe@gmail.com', '2024-02-20'),
(5, 'alicesmith', 'alice.smith@gmail.com', '2024-03-05');

-- 2. HABIT_PLAN TABLE (Dependent on User)
INSERT INTO Habit_Plan (Plan_ID, User_ID, Habit_Name, Start_Date, Daily_Limit_Goal) VALUES
(1, 1, 'Smoking', '2024-01-01', 5),
(2, 1, 'Sugar', '2024-02-01', 50),
(3, 2, 'Vaping', '2024-01-15', 2),
(4, 3, 'Fast Food', '2024-03-01', 1),
(5, 4, 'Nail Biting', '2024-03-10', 0);

-- 3. ACCOUNTABILITY_PARTNER TABLE (Dependent on User)
INSERT INTO Accountability_Partner (Partner_ID, User_ID, Partner_Name, Contact_Email, Partner_Role) VALUES
(1, 1, 'Ali Veli', 'ali@gmail.com', 'Friend'),
(2, 2, 'Ayse Yilmaz', 'ayse@gmail.com', 'Sister'),
(3, 3, 'Dr. Smith', 'smith@gmail.com', 'Therapist'),
(4, 4, 'Bob Doe', 'bob@gmail.com', 'Brother'),
(5, 5, 'Eve Adams', 'eve@gmail.com', 'Friend');

-- 4. RELAPSE_LOG TABLE (Dependent on Habit_Plan)
INSERT INTO Relapse_Log (Log_ID, Plan_ID, Incident_Date, Trigger_Reason, Severity_Level, User_Journal) VALUES
(1, 1, '2024-01-05 10:00:00', 'Stress at work', 8, 'Had a really bad meeting.'),
(2, 1, '2024-01-10 14:00:00', 'Social pressure', 5, 'Friends were smoking outside.'),
(3, 2, '2024-02-14 20:00:00', 'Craving', 9, 'Ate a whole chocolate cake.'),
(4, 3, '2024-01-20 09:00:00', 'Morning routine', 7, 'Forgot I was quitting for a second.'),
(5, 4, '2024-03-05 12:00:00', 'Hunger', 6, 'Ordered a burger because I had no time.');

-- 5. ALTERNATIVE_ACTIVITY TABLE (Dependent on Habit_Plan)
INSERT INTO Alternative_Activity (Activity_ID, Plan_ID, Activity_Name, Duration_Mins) VALUES
(1, 1, 'Drink a glass of water', 5),
(2, 1, 'Chew nicotine gum', 10),
(3, 2, 'Eat an apple', 5),
(4, 3, 'Deep Breathing exercise', 3),
(5, 4, 'Cook a quick healthy meal', 30);

-- 6. PROGRESS_REPORT TABLE (Dependent on Habit_Plan)
INSERT INTO Progress_Report (Report_ID, Plan_ID, Generation_Date, Success_Score, AI_Summary_Text) VALUES
(1, 1, '2024-01-08', 80.50, 'Good start, keep managing stress.'),
(2, 1, '2024-01-15', 75.00, 'Slight dip due to social triggers.'),
(3, 2, '2024-02-10', 90.00, 'Excellent sugar reduction!'),
(4, 3, '2024-01-30', 85.00, 'Doing well, maintain morning focus.'),
(5, 4, '2024-03-15', 60.00, 'Needs work on meal prepping.');

-- 7. MILESTONE TABLE (Dependent on Habit_Plan)
INSERT INTO Milestone (Plan_ID, Target_Day_Count, Description) VALUES
(1, 7, '1 Week Smoke Free'),
(1, 14, '2 Weeks Smoke Free'),
(2, 7, '1 Week Sugar Free'),
(3, 30, '1 Month Vape Free'),
(4, 7, '1 Week Healthy Eating');

-- 8. REWARD TABLE (Dependent on Milestone)
INSERT INTO Reward (Reward_ID, Plan_ID, Target_Day_Count, Badge_Name, Issue_Date) VALUES
(1, 1, 7, 'Bronze Lung', '2024-01-08'),
(2, 1, 14, 'Silver Lung', '2024-01-15'),
(3, 2, 7, 'Sugar Detox Rookie', '2024-02-08'),
(4, 3, 30, 'Vape Free Champion', '2024-02-15'),
(5, 4, 7, 'Healthy Chef', '2024-03-08');