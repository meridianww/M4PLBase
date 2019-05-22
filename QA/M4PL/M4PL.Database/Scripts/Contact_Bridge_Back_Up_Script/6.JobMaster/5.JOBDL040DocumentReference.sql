INSERT INTO [dbo].[JOBDL040DocumentReference]
           ([JobID]
           ,[JdrItemNumber]
           ,[JdrCode]
           ,[JdrTitle]
           ,[DocTypeId]
           ,[JdrDescription]
           ,[JdrAttachment]
           ,[JdrDateStart]
           ,[JdrDateEnd]
           ,[JdrRenewal]
           ,[StatusId]
           ,[EnteredBy]
           ,[DateEntered]
           ,[ChangedBy]
           ,[DateChanged])
     SELECT
            j.Id
           ,JD.[JdrItemNumber]
           ,JD.[JdrCode]
           ,JD.[JdrTitle]
           ,JD.[DocTypeId]
           ,JD.[JdrDescription]
           ,JD.[JdrAttachment]
           ,JD.[JdrDateStart]
           ,JD.[JdrDateEnd]
           ,JD.[JdrRenewal]
           ,JD.[StatusId]
           ,JD.[EnteredBy]
           ,JD.[DateEntered]
           ,JD.[ChangedBy]
           ,JD.[DateChanged] FROM [M4PL_3030_Test].[dbo].[JOBDL040DocumentReference] JD
		   INNER JOIN [dbo].[JOBDL000Master] J ON J.[3030Id] = JD.JobID
		   INNER JOIN [dbo].[PRGRM000Master] P ON P.[Id] = J.ProgramID
		   WHERE P.PrgOrgID = 1 
 GO


