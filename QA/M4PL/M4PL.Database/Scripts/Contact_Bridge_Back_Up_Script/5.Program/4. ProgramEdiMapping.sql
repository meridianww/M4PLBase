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
     
     SELECT PEH.[ID]
           ,TS.[PemEdiTableName]
           ,TS.[PemEdiFieldName]
           ,TS.[PemEdiFieldDataType]
           ,TS.[PemSysTableName]
           ,TS.[PemSysFieldName]
           ,TS.[PemSysFieldDataType]
           ,PSR.Id--TS.[StatusId]
           ,SRP.Id--TS.[PemInsertUpdate]
           ,TS.[PemDateStart]
           ,TS.[PemDateEnd]
           ,TS.[EnteredBy]
           ,TS.[DateEntered]
           ,TS.[ChangedBy]
           ,TS.[DateChanged] FROM [M4PL_3030_Test].[dbo].[PRGRM071EdiMapping] TS
		   LEFT JOIN [M4PL_3030_Test].[dbo].[PRGRM070EdiHeader] PMH on PMH.Id = TS.PemHeaderID
		   LEFT JOIN [dbo].[PRGRM070EdiHeader] PEH on PMH.PehEdiCode = PEH.PehEdiCode
		   LEFT JOIN [M4PL_3030_Test].[dbo].[PRGRM000Master] PR on PR.Id = PMH.PehProgramID
		   LEFT JOIN [M4PL_3030_Test].[dbo].[SYSTM000Ref_Options] RP ON TS.PemInsertUpdate = RP.Id
		   LEFT JOIN [dbo].[SYSTM000Ref_Options] SRP ON SRP.SysLookupId = RP.SysLookupId AND SRP.SysLookupCode = RP.SysLookupCode AND SRP.SysOptionName = RP.SysOptionName
		   LEFT JOIN [M4PL_3030_Test].[dbo].[SYSTM000Ref_Options] RPS ON TS.StatusId = RPS.Id
			LEFT JOIN [dbo].[SYSTM000Ref_Options] PSR ON PSR.SysLookupId = RPS.SysLookupId AND PSR.SysLookupCode = RPS.SysLookupCode AND PSR.SysOptionName = RPS.SysOptionName
		   WHERE PR.PrgOrgID = 1
GO


