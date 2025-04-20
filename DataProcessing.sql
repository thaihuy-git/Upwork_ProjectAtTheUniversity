--========== 11. Categorize jobs by Job Category list based on Search Keyword (update data on Job_Post_Temp table)

-- Import Job Category list along with keywords (data from Upwork website): file Job_Categories.xlsx
-- Set job category for jobs
select * from Job_Category

select JobCategoryID, JobCateName, trim(kw.Value) as Keyword --SplitData
into #jobKeyword
from Job_Category
cross apply STRING_SPLIT (KeywordList, ',') kw

select * from #jobKeyword

Update Job_Post_Temp
Set Job_Post_Temp.JobCategoryID = kw.JobCategoryID,
	Job_Post_Temp.JobCateName = kw.JobCateName
From Job_Post_Temp
Left join #jobKeyword as kw on kw.Keyword = Job_Post_Temp.SearchKeyword

Drop table #jobKeyword

--============ 12. Update EX_level_demand is NULL --> Intermediate, then categorizing Experience Level list
-- Check Experience Level in dataset
Select distinct ExperienceLevelName from Job_Post_Temp

-- insert data into Experience_Level table
Insert into Experience_Level(ExperienceLevelID, ExperienceLevelName)
Values('EL', 'Entry Level'),
('EX', 'Expert'),
('IT', 'Intermediate'),
('ML', 'Mid Level');

-- as approval, update the empty experience levels to 'Intermediate' 
Update Job_Post_Temp
Set ExperienceLevelID = 'IT'
	,ExperienceLevelName = 'Intermediate'
Where ExperienceLevelName is null;

-- Update Experience Level ID
Update jpt
Set jpt.ExperienceLevelID = el.ExperienceLevelID
From Job_Post_Temp as jpt
left join Experience_Level el on el.ExperienceLevelName = jpt.ExperienceLevelName
Where jpt.ExperienceLevelID is null;

--Check again
select * from Job_Post_Temp;

Select * from Job_Post_Temp jpt
Where jpt.ExperienceLevelID is null;


--=========== 13. Standardize Country list

---- Import country list from .csv file
---- Update ISOCode to Job_Post_Temp table
-- Check CountryName
Select distinct jpt.CountryName from Job_Post_Temp jpt
Where not exists (Select 1 from Country c where c.CountryName = jpt.CountryName);

-- Correct CountryName
Update Job_Post_Temp
Set CountryName = 'Brunei'
Where CountryName = 'Brunei Darussalam';

Update Job_Post_Temp
Set CountryName = 'Democratic Republic of the Congo'
Where CountryName = 'Congo, the Democratic Republic of the';

Update Job_Post_Temp
Set CountryName = 'Ivory Coast'
Where CountryName = 'Cote d''Ivoire';

Update Job_Post_Temp
Set CountryName = 'France'
Where CountryName = 'Guadeloupe';

Update Job_Post_Temp
Set CountryName = 'Macau'
Where CountryName = 'Macao';

Update Job_Post_Temp
Set CountryName = 'Micronesia'
Where CountryName = 'Micronesia, Federated States of';

Update Job_Post_Temp
Set CountryName = 'Palestine'
Where CountryName = 'Palestinian Territories';

Update Job_Post_Temp
Set CountryName = 'Saint Martin'
Where CountryName = 'Saint Martin (French part)';

Update Job_Post_Temp
Set CountryName = 'Sint Maarten'
Where CountryName = 'Sint Maarten (Dutch part)';

Update Job_Post_Temp
Set CountryName = 'United States'
Where CountryName = 'United States Minor Outlying Islands';

Update Job_Post_Temp
Set CountryName = 'U.S. Virgin Islands'
Where CountryName = 'United States Virgin Islands';

Update Job_Post_Temp
Set CountryName = 'Finland'
Where CountryName = 'Aland Islands';

Update jpt
Set jpt.CountryISOCode = c.CountryISOCode
From Job_Post_Temp jpt
Left Join Country c on upper(c.CountryName) = upper(jpt.CountryName)
Where jpt.CountryName is not null;

-- Check data
select top(100) * from Job_Post_Temp;

Select distinct CountryName from Job_Post_Temp jpt where jpt.CountryISOCode is null;

--============ 14. Categorize Skill list
Insert Into Skill(SkillName)
Select distinct s.SkillName 
From (
		Select SkillName01 as SkillName From Job_Post_Temp Where Skill01 is not null
		union all
		Select SkillName02 From Job_Post_Temp Where Skill02 is not null
		union all
		Select SkillName03 From Job_Post_Temp Where Skill03 is not null
		union all
		Select SkillName04 From Job_Post_Temp Where Skill04 is not null
		union all
		Select SkillName05 From Job_Post_Temp Where Skill05 is not null
		union all
		Select SkillName06 From Job_Post_Temp Where Skill06 is not null
		union all
		Select SkillName07 From Job_Post_Temp Where Skill07 is not null
		union all
		Select SkillName08 From Job_Post_Temp Where Skill08 is not null
		union all
		Select SkillName09 From Job_Post_Temp Where Skill09 is not null
	) as s
order by SkillName;

-- Update SkillID for Job_Post_Temp
Update jpt
Set jpt.Skill01 = s.SkillID
From Job_Post_Temp jpt
Left Join Skill s on s.SkillName = jpt.SkillName01
Where jpt.SkillName01 is not null;

Update jpt
Set jpt.Skill02 = s.SkillID
From Job_Post_Temp jpt
Left Join Skill s on s.SkillName = jpt.SkillName02
Where jpt.SkillName02 is not null;

Update jpt
Set jpt.Skill03 = s.SkillID
From Job_Post_Temp jpt
Left Join Skill s on s.SkillName = jpt.SkillName03
Where jpt.SkillName03 is not null;

Update jpt
Set jpt.Skill04 = s.SkillID
From Job_Post_Temp jpt
Left Join Skill s on s.SkillName = jpt.SkillName04
Where jpt.SkillName04 is not null;

Update jpt
Set jpt.Skill05 = s.SkillID
From Job_Post_Temp jpt
Left Join Skill s on s.SkillName = jpt.SkillName05
Where jpt.SkillName05 is not null;

Update jpt
Set jpt.Skill06 = s.SkillID
From Job_Post_Temp jpt
Left Join Skill s on s.SkillName = jpt.SkillName06
Where jpt.SkillName06 is not null;

Update jpt
Set jpt.Skill07 = s.SkillID
From Job_Post_Temp jpt
Left Join Skill s on s.SkillName = jpt.SkillName07
Where jpt.SkillName07 is not null;

Update jpt
Set jpt.Skill08 = s.SkillID
From Job_Post_Temp jpt
Left Join Skill s on s.SkillName = jpt.SkillName08
Where jpt.SkillName08 is not null;

Update jpt
Set jpt.Skill09 = s.SkillID
From Job_Post_Temp jpt
Left Join Skill s on s.SkillName = jpt.SkillName09
Where jpt.SkillName09 is not null;

--============ 15. Update Start_Rate and End_Rate with the same value if Hourly_Rate is just one value
Update Job_Post_Temp
Set HourlyStartRate = HourlyEndRate
Where PaymentType = 'Hourly'
	and HourlyStartRate is null and HourlyEndRate is not null;

Update Job_Post_Temp
Set HourlyEndRate = HourlyStartRate
Where PaymentType = 'Hourly'
	and HourlyStartRate is not null and HourlyEndRate is null;

--============ 16. Payment_Type = “Hourly” but Hour_Rate is empty --> update to the average hourly rate of job category

DECLARE @jobPost_Cursor CURSOR;
DECLARE @jobPostID int, @jobCateID int;
DECLARE @a_startRate decimal(8,2), @a_endRate decimal(8,2);
BEGIN
	--Get list of data that needs to be updated
    SET @jobPost_Cursor = CURSOR FOR
    Select jpt.JobPostID, jpt.JobCategoryID
	From Job_Post_Temp jpt
	Where jpt.PaymentType = 'Hourly'
		and jpt.HourlyStartRate is null and jpt.HourlyEndRate is null;

	--Get the average hourly rate of job categories (to have better performance)
	Select jpt.JobCategoryID
			,ROUND(AVG(jpt.HourlyStartRate),2) as Avg_StartRate
			,ROUND(AVG(jpt.HourlyEndRate),2) as Avg_EndRate
	Into #Avg_Rate
	From Job_Post_Temp as jpt
	Where jpt.PaymentType = 'Hourly'
		and jpt.HourlyStartRate is not null and jpt.HourlyEndRate is not null
	Group by jpt.JobCategoryID;

	--Begin looping the cursor
    OPEN @jobPost_Cursor 
    FETCH NEXT FROM @jobPost_Cursor
    INTO @jobPostID, @jobCateID

    WHILE @@FETCH_STATUS = 0
    BEGIN
      -- Get the average hourly rate of job category
	  SET @a_startRate = (Select a.Avg_StartRate from #Avg_Rate as a Where a.JobCategoryID = @jobCateID);
	  SET @a_endRate = (Select a.Avg_EndRate from #Avg_Rate as a Where a.JobCategoryID = @jobCateID);

	  --Update the average hourly rate for Job_Post
	  Update Job_Post_Temp
	  Set HourlyStartRate = @a_startRate
		 ,HourlyEndRate = @a_endRate
	  Where JobPostID = @jobPostID;

	  --next record
      FETCH NEXT FROM @jobPost_Cursor 
      INTO @jobPostID, @jobCateID
    END;

	--Drop the temporary table
	Drop table #Avg_Rate;

    CLOSE @jobPost_Cursor ;
    DEALLOCATE @jobPost_Cursor;
END;

select * from Job_Post_Temp where PaymentType = 'Hourly' and JobCategoryID = 6

--============ 17. Payment_Type = “Fixed-price” but Job_Cost is empty --> update to the average of job category 
--					(Notice: for Design and Creative, update to $508 as source's requirement)
-- Update for Design and Creative category
Update Job_Post_Temp 
Set JobCost = 508
Where PaymentType = 'Fixed-price' and JobCost is null and JobCategoryID = 6;

-- Update the rest
DECLARE @jobPost_Cursor CURSOR;
DECLARE @jobPostID int, @jobCateID int;
DECLARE @a_jobCost decimal(20,2);
BEGIN
	--Get list of data that needs to be updated
    SET @jobPost_Cursor = CURSOR FOR
    Select jpt.JobPostID, jpt.JobCategoryID
	From Job_Post_Temp jpt
	Where jpt.PaymentType = 'Fixed-price'
		and jpt.JobCost is null;

	--Get the average hourly rate of job categories (to have better performance)
	Select jpt.JobCategoryID
			,ROUND(AVG(jpt.JobCost),2) as Avg_JobCost
	Into #Avg_Cost
	From Job_Post_Temp as jpt
	Where jpt.PaymentType = 'Fixed-price'
		and jpt.JobCost is not null
	Group by jpt.JobCategoryID;

	--Begin looping the cursor
    OPEN @jobPost_Cursor 
    FETCH NEXT FROM @jobPost_Cursor
    INTO @jobPostID, @jobCateID

    WHILE @@FETCH_STATUS = 0
    BEGIN
      -- Get the average hourly rate of job category
	  SET @a_jobCost = (Select a.Avg_JobCost from #Avg_Cost as a Where a.JobCategoryID = @jobCateID);

	  --Update the average hourly rate for Job_Post
	  Update Job_Post_Temp
	  Set JobCost = @a_jobCost
	  Where JobPostID = @jobPostID;

	  --next record
      FETCH NEXT FROM @jobPost_Cursor 
      INTO @jobPostID, @jobCateID
    END;

	--Drop the temporary table
	Drop table #Avg_Cost;

    CLOSE @jobPost_Cursor ;
    DEALLOCATE @jobPost_Cursor;
END;
--============ 18. The rating of clients: “Rating” is true if “Feedback_Num” is more than 10. 
Update Job_Post_Temp 
Set IsTrueRating = (case when FeedbackNum > 10 then 1 else 0);

--=========== 19. Update EnterpriseClient is NULL --> "Small Business & Individual"
Update Job_Post_Temp
Set EnterpriseClient = 'Small Business & Individual'
Where EnterpriseClient is null;

--====================== LOAD DATA TO Job_Post TABLE ==================================
Insert into Job_Post
(
	JobTitle,
	ExperienceLevelID,
	SearchKeyword,
	PostedDate,
	JobDurationName,
	WorkingHourName,
	JobDescription,
	Highlight,
	JobCategoryID,
	Skill01,
	Skill02,
	Skill03,
	Skill04,
	Skill05,
	Skill06,
	Skill07,
	Skill08,
	Skill09,
	ApplicantsNum,
	PaymentSituation,
	EnterpriseClient,
	FreelancersNum,
	Spent,
	CountryISOCode,
	ConnectsNum,
	NewConnectsNum,
	Rating,
	FeedbackNum,
	IsTrueRating,
	PaymentType,
	JobCost,
	HourlyStartRate,
	HourlyEndRate,
	JobPostTempID
)
Select
	JobTitle,
	ExperienceLevelID,
	SearchKeyword,
	PostedDate,
	JobDurationName,
	WorkingHourName,
	JobDescription,
	Highlight,
	JobCategoryID,
	Skill01,
	Skill02,
	Skill03,
	Skill04,
	Skill05,
	Skill06,
	Skill07,
	Skill08,
	Skill09,
	ApplicantsNum,
	PaymentSituation,
	EnterpriseClient,
	FreelancersNum,
	Spent,
	CountryISOCode,
	ConnectsNum,
	NewConnectsNum,
	Rating,
	FeedbackNum,
	IsTrueRating,
	PaymentType,
	JobCost,
	HourlyStartRate,
	HourlyEndRate,
	JobPostID
From Job_Post_Temp

------ Skill list of jobs
-- Get skill list from dataset and insert into Skill table
BEGIN
	Select distinct s.JobPostID, s.SkillID
	Into #jobSkill
	From (
			Select JobPostID, Skill01 as SkillID From Job_Post Where Skill01 is not null
			union all
			Select JobPostID, Skill02 From Job_Post Where Skill02 is not null
			union all
			Select JobPostID, Skill03 From Job_Post Where Skill03 is not null
			union all
			Select JobPostID, Skill04 From Job_Post Where Skill04 is not null
			union all
			Select JobPostID, Skill05 From Job_Post Where Skill05 is not null
			union all
			Select JobPostID, Skill06 From Job_Post Where Skill06 is not null
			union all
			Select JobPostID, Skill07 From Job_Post Where Skill07 is not null
			union all
			Select JobPostID, Skill08 From Job_Post Where Skill08 is not null
			union all
			Select JobPostID, Skill09 From Job_Post Where Skill09 is not null
		) as s
	order by JobPostID;
	Insert Into JobPost_Skills(JobPostID, SkillID, SkillName)
	Select js.JobPostID, js.SkillID, sk.SkillName
	From #jobSkill js
	Left Join Skill sk on sk.SkillID = js.SkillID;

	Drop table #jobSkill;
END;

--=========================== PREPARE DATA FOR GENERATING DUMMY DATA ============================
--=====  Skill list for job categories (after getting data, export it to .csv file)
Select distinct jp.JobCategoryID as JobCateID, js.SkillName
From JobPost_Skills js
Left Join Job_Post jp on jp.JobPostID = js.JobPostID;

--===== Keywords of Job Categories
Select distinct jp.JobCategoryID as JobCateID, jp.SearchKeyword
From Job_Post jp;

--===== Highlight of Job Categories
Select distinct jp.JobCategoryID as JobCateID, jp.Highlight
From Job_Post jp;

--===== JobTitle, Description of Job Categories
Select distinct jp.JobCategoryID as JobCateID, jp.JobTitle, jp.JobDescription
From Job_Post jp;

--===== Spent
Select jp.Spent from Job_Post jp;

--===== JobCost of Job Categories
Select distinct jp.JobCategoryID as JobCateID, jp.JobCost from Job_Post jp;

--===== Hourly Rate of Job Categories
Select distinct jp.JobCategoryID as JobCateID, jp.HourlyStartRate as StartRate, jp.HourlyEndRate as EndRate from Job_Post jp;

--===== Country (keep duplicates to generate dummy data)
select jp.CountryISOCode from Job_Post jp;

--==================================== ADD MORE INFORMATION FOR DATA ANALYSIS PURPOSES ==============================
--====== Add column JobFrom HighRating to mark the jobs that are from the high rating clients 
ALTER TABLE Job_Post
ADD JobFromHighRating int null;

--Update data for JobFromHighRating column: 1 if Rating is True and Rating >= 4, other wise 0
Update Job_Post
Set JobFromHighRating = (case when IsTrueRating = 1 and ISNULL(Rating,0) >= 4 then 1 else 0 end);

--======= Add column RatingGroup to categorize clients based on the rating
ALTER TABLE Job_Post
ADD RatingGroup varchar(50) null;

Update Job_Post
Set RatingGroup = (case when JobFromHighRating = 1 then 'High Rating' else 'Low Rating' end);

--======= Add column Client to identify the clients: combine Country and Company scale
ALTER TABLE Job_Post
ADD Client varchar(250) null;

Update jp
Set jp.Client = c.CountryName + ', ' + jp.EnterpriseClient
From Job_Post jp
Left join Country c on c.CountryISOCode = jp.CountryISOCode;

--======= Add column NumberOfApplicants to count applications 
ALTER TABLE Job_Post
ADD NumberOfApplicants int null;

--Convert ApplicantsNum to a number with a random number in range of ApplicantsNum
DECLARE @jobPost_Cursor CURSOR;
DECLARE @jobPostID int, @appNum nvarchar(100);
DECLARE @numOfApplicants int;
BEGIN
	--Get list of data that needs to be updated
    SET @jobPost_Cursor = CURSOR FOR
    Select jpt.JobPostID, jpt.ApplicantsNum
	From Job_Post jpt;

	--Begin looping the cursor
    OPEN @jobPost_Cursor 
    FETCH NEXT FROM @jobPost_Cursor
    INTO @jobPostID, @appNum

    WHILE @@FETCH_STATUS = 0
    BEGIN
      -- Get a random number
	  SET @numOfApplicants = (Select case when @appNum = 'Less than 5' then
											FLOOR(RAND() * (4 - 0 + 1)) + 0
										when @appNum = '5 to 10' then
											FLOOR(RAND() * (10 - 5 + 1)) + 5
										when @appNum = '10 to 15' then
											FLOOR(RAND() * (15 - 11 + 1)) + 15
										when @appNum = '15 to 20' then
											FLOOR(RAND() * (20 - 16 + 1)) + 16
										when @appNum = '20 to 50' then
											FLOOR(RAND() * (50 - 21 + 1)) + 21
										when @appNum = '50+' then
											FLOOR(RAND() * (100 - 51 + 1)) + 51
										else 0 end);

	  --Update the Number Of Applicants
	  Update Job_Post
	  Set NumberOfApplicants = @numOfApplicants
	  Where JobPostID = @jobPostID;

	  --next record
      FETCH NEXT FROM @jobPost_Cursor 
      INTO @jobPostID, @appNum
    END;


    CLOSE @jobPost_Cursor ;
    DEALLOCATE @jobPost_Cursor;
END;




