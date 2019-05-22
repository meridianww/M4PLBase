INSERT INTO [dbo].[PRGRM071EdiMapping]
           ([PemHeaderID]
           ,[PemEdiTableName]
           ,[PemEdiFieldName]
           ,[PemEdiFieldDataType]
           ,[PemSysTableName]
           ,[PemSysFieldName]
           ,[PemSysFieldDataType]
           ,[StatusId]
           ,[PemInsertUpdate]
           ,[PemDateStart]
           ,[PemDateEnd]
           ,[EnteredBy]
           ,[DateEntered]
           ,[ChangedBy]
           ,[DateChanged])
     
       SELECT PMH.[ID]
           ,TS.[PemEdiTableName]
           ,TS.[PemEdiFieldName]
           ,TS.[PemEdiFieldDataType]
           ,TS.[PemSysTableName]
           ,TS.[PemSysFieldName]
           ,TS.[PemSysFieldDataType]
           ,TS.[StatusId]
           ,TS.[PemInsertUpdate]
           ,TS.[PemDateStart]
           ,TS.[PemDateEnd]
           ,TS.[EnteredBy]
           ,TS.[DateEntered]
           ,TS.[ChangedBy]
           ,TS.[DateChanged] FROM [M4PL_3030_Test].[dbo].[PRGRM071EdiMapping] TS
		   INNER JOIN [dbo].[PRGRM070EdiHeader] PMH on PMH.[3030Id] = TS.PemHeaderID
		   INNER JOIN [dbo].[PRGRM000Master] PR on PR.[Id] = PMH.PehProgramID
		   WHERE PR.PrgOrgID = 1
GO


