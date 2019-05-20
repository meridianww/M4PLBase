INSERT INTO [dbo].[CUST050Finacial_Cal]
           ([OrgID]
           ,[CustID]
           ,[FclPeriod]
           ,[FclPeriodCode]
           ,[FclPeriodStart]
           ,[FclPeriodEnd]
           ,[FclPeriodTitle]
           ,[FclAutoShortCode]
           ,[FclWorkDays]
           ,[FinCalendarTypeId]
           ,[StatusId]
           ,[FclDescription]
           ,[DateEntered]
           ,[EnteredBy]
           ,[DateChanged]
           ,[ChangedBy])
     SELECT
           1 AS [OrgID]
           ,[CustID]
           ,[FclPeriod]
           ,[FclPeriodCode]
           ,[FclPeriodStart]
           ,[FclPeriodEnd]
           ,[FclPeriodTitle]
           ,[FclAutoShortCode]
           ,[FclWorkDays]
           ,[FinCalendarTypeId]
           ,[StatusId]
           ,[FclDescription]
           ,[DateEntered]
           ,[EnteredBy]
           ,[DateChanged]
           ,[ChangedBy] FROM [M4PL_3030_Test].[dbo].[CUST050Finacial_Cal]
		   WHERE OrgID = 1
GO


