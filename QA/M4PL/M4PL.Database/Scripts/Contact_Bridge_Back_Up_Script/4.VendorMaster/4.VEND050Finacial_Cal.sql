INSERT INTO [dbo].[VEND050Finacial_Cal]
           ([OrgID]
           ,[VendID]
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
           1 [OrgID]
           ,[VendID]
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
           ,[ChangedBy] FROM [M4PL_3030_Test].[dbo].[VEND050Finacial_Cal]
		   WHERE OrgID = 1
GO


