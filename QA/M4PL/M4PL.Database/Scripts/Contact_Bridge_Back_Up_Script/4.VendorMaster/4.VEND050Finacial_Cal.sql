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
           ,CU.Id
           ,[FclPeriod]
           ,[FclPeriodCode]
           ,[FclPeriodStart]
           ,[FclPeriodEnd]
           ,[FclPeriodTitle]
           ,[FclAutoShortCode]
           ,[FclWorkDays]
           ,[FinCalendarTypeId]
           ,CD.[StatusId]
           ,[FclDescription]
           ,CD.[DateEntered]
           ,CD.[EnteredBy]
           ,CD.[DateChanged]
           ,CD.[ChangedBy] FROM [M4PL_3030_Test].[dbo].[VEND050Finacial_Cal] CD
		   INNER join [dbo].[CUST000Master] CU on CU.[3030Id] = CD.VendID
		   WHERE OrgID = 1
GO


