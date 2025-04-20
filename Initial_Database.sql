--===================== CREATE DATABASE, TABLES, INDEXES, and RELATIONSHIPS
------- Create database
Create database [MasterProject_Upwork];
GO
Use [MasterProject_Upwork];
GO

------- Create table: Job_Post_Temp (to store semi data from .xlsx file that was exported from Python)
CREATE TABLE Job_Post_Temp (
	JobPostID int PRIMARY KEY IDENTITY(1,1) NOT NULL,
	JobTitle nvarchar(250) NULL,
	ExperienceLevelID varchar(10) NULL,
	ExperienceLevelName nvarchar(100) NULL,
	SearchKeyword nvarchar(50) NULL,
	PostedDate datetime NULL,
	JobDurationID varchar(10) NULL,
	JobDurationName nvarchar(250) NULL,
	WorkingHourID varchar(10) NULL,
	WorkingHourName nvarchar(250) NULL,
	JobDescription nvarchar(max) NULL,
	Highlight nvarchar(50) NULL,
	JobCategoryID int NULL,
	JobCateName nvarchar(100) NULL,
	Skill01 int NULL,
	SkillName01 nvarchar(250) NULL,
	Skill02 int NULL,
	SkillName02 nvarchar(250) NULL,
	Skill03 int NULL,
	SkillName03 nvarchar(250) NULL,
	Skill04 int NULL,
	SkillName04 nvarchar(250) NULL,
	Skill05 int NULL,
	SkillName05 nvarchar(250) NULL,
	Skill06 int NULL,
	SkillName06 nvarchar(250) NULL,
	Skill07 int NULL,
	SkillName07 nvarchar(250) NULL,
	Skill08 int NULL,
	SkillName08 nvarchar(250) NULL,
	Skill09 int NULL,
	SkillName09 nvarchar(250) NULL,
	ApplicantsNum nvarchar(100) NULL,
	PaymentSituation nvarchar(50) NULL,
	EnterpriseClient nvarchar(50) NULL,
	FreelancersNum int NULL,
	Spent decimal(20, 2) NULL,
	CountryISOCode varchar(3) NULL,
	CountryName nvarchar(250) NULL,
	ConnectsNum int NULL,
	NewConnectsNum int NULL,
	Rating float NULL,
	FeedbackNum int NULL,
	IsTrueRating int NULL,
	PaymentType nvarchar(50) NULL,
	JobCost decimal(20, 2) NULL,
	HourlyStartRate decimal(8, 2) NULL,
	HourlyEndRate decimal(8, 2) NULL
);

----- Create table: Country
CREATE TABLE Country(
	CountryISOCode varchar(3) PRIMARY KEY NOT NULL,
	CountryName nvarchar(250) NOT NULL,
	Sorting nvarchar(250) NULL
	);

----- Create table: Job_Category

CREATE TABLE Job_Category(
	JobCategoryID int PRIMARY KEY IDENTITY(1,1) NOT NULL,
	JobCateName nvarchar(100) NOT NULL,
	KeywordList nvarchar(2000) NULL
	);

----- Create table: Experience_Level
CREATE TABLE Experience_Level(
	ExperienceLevelID varchar(10) PRIMARY KEY NOT NULL,
	ExperienceLevelName nvarchar(100) NOT NULL
	);

----- Create table: Skill
CREATE TABLE Skill(
	SkillID int NOT NULL,
	SkillName nvarchar(250) NOT NULL
	);

----- Create table: Job_Post
CREATE TABLE Job_Post (
	JobPostID int PRIMARY KEY IDENTITY(1,1) NOT NULL,
	JobTitle nvarchar(250) NULL,
	ExperienceLevelID varchar(10) NULL,
	SearchKeyword nvarchar(50) NULL,
	PostedDate datetime NULL,
	JobDurationName nvarchar(250) NULL,
	WorkingHourName nvarchar(250) NULL,
	JobDescription nvarchar(max) NULL,
	Highlight nvarchar(50) NULL,
	JobCategoryID int NULL,
	Skill01 int NULL,
	Skill02 int NULL,
	Skill03 int NULL,
	Skill04 int NULL,
	Skill05 int NULL,
	Skill06 int NULL,
	Skill07 int NULL,
	Skill08 int NULL,
	Skill09 int NULL,
	ApplicantsNum nvarchar(100) NULL,
	PaymentSituation nvarchar(50) NULL,
	EnterpriseClient nvarchar(50) NULL,
	FreelancersNum int NULL,
	Spent decimal(20, 2) NULL,
	CountryISOCode varchar(3) NULL,
	ConnectsNum int NULL,
	NewConnectsNum int NULL,
	Rating float NULL,
	FeedbackNum int NULL,
	IsTrueRating int NULL,
	PaymentType nvarchar(50) NULL,
	JobCost decimal(20, 2) NULL,
	HourlyStartRate decimal(8, 2) NULL,
	HourlyEndRate decimal(8, 2) NULL,
	JobPostTempID int NULL,
	JobFromHighRating int NULL,
	RatingGroup varchar(50) NULL,
	Client nvarchar(250) NULL,
	Applicant nvarchar(250) NULL,
	NumberOfApplicants int NULL
);

ALTER TABLE Job_Post ADD FOREIGN KEY(CountryISOCode)
REFERENCES Country(CountryISOCode);

ALTER TABLE Job_Post ADD FOREIGN KEY(ExperienceLevelID)
REFERENCES Experience_Level(ExperienceLevelID);

ALTER TABLE Job_Post ADD FOREIGN KEY(JobCategoryID)
REFERENCES Job_Category (JobCategoryID);


CREATE NONCLUSTERED INDEX IDX_JobPost_PostedDate ON Job_Post(PostedDate);

CREATE NONCLUSTERED INDEX IDX_JobPost_SearchKeyword ON Job_Post(SearchKeyword);

CREATE NONCLUSTERED INDEX IDX_JobPost_CountryISOCode ON Job_Post(CountryISOCode);

CREATE NONCLUSTERED INDEX IDX_JobPost_ExperienceLevelID ON Job_Post(ExperienceLevelID);

CREATE NONCLUSTERED INDEX IDX_JobPost_JobCategoryID ON Job_Post(JobCategoryID);

----- Create table: JobPost_Skills to store skills set of each job
CREATE TABLE JobPost_Skills(
	JobPostID int NOT NULL,
	SkillID int NOT NULL,
	SkillName nvarchar(250) NOT NULL
	);

ALTER TABLE JobPost_Skills ADD FOREIGN KEY(JobPostID)
REFERENCES Job_Post (JobPostID);


CREATE NONCLUSTERED INDEX IDX_JobPostSkills_JobPostID ON JobPost_Skills(JobPostID);

CREATE NONCLUSTERED INDEX IDX_JobPostSkills_SkillName ON JobPost_Skills(SkillName);

