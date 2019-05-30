USE [M4PL_FreshCopy]
GO

INSERT INTO [dbo].[MVOC000Program]
           ([VocOrgID]
           ,[VocProgramID]
           ,[VocSurveyCode]
           ,[VocSurveyTitle]
           ,[VocDescription]
           ,[StatusId]
           ,[VocDateOpen]
           ,[VocDateClose]
           ,[DateEntered]
           ,[EnteredBy]
           ,[DateChanged]
           ,[ChangedBy])
     SELECT [VocOrgID]
      ,PM.ID
      ,[VocSurveyCode]
      ,[VocSurveyTitle]
      ,[VocDescription]
      ,TS.[StatusId]
      ,[VocDateOpen]
      ,[VocDateClose]
      ,TS.[DateEntered]
      ,TS.[EnteredBy]
      ,TS.[DateChanged]
      ,TS.[ChangedBy]
	FROM M4PL_3030_Test.[dbo].[MVOC000Program]  TS
		   INNER join [dbo].[PRGRM000Master] PM on TS.[VocProgramID] = PM.[3030Id]
	WHERE VocOrgID=1

