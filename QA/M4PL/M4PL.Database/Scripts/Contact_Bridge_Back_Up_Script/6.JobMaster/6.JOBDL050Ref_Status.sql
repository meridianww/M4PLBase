USE [M4PL_FreshCopy]
GO

INSERT INTO [dbo].[JOBDL050Ref_Status]
           ([JobID]
           ,[JbsOutlineCode]
           ,[JbsStatusCode]
           ,[JbsTitle]
           ,[JbsDescription]
           ,[StatusId]
           ,[SeverityId]
           ,[EnteredBy]
           ,[DateEntered]
           ,[ChangedBy]
           ,[DateChanged])
     SELECT
            j.Id
           ,JR.[JbsOutlineCode]
           ,JR.[JbsStatusCode]
           ,JR.[JbsTitle]
           ,JR.[JbsDescription]
           ,JR.[StatusId]
           ,JR.[SeverityId]
           ,JR.[EnteredBy]
           ,JR.[DateEntered]
           ,JR.[ChangedBy]
           ,JR.[DateChanged] FROM [M4PL_3030_Test].[dbo].[JOBDL050Ref_Status] JR 
		   INNER JOIN [dbo].[JOBDL000Master] J ON J.[3030Id] = JR.JobID
		   INNER JOIN [dbo].[PRGRM000Master] P ON P.[Id] = J.ProgramID
		   WHERE P.PrgOrgID = 1 
GO


