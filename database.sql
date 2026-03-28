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