
INSERT INTO [dbo].[CONTC010Bridge]
           (ConOrgId
		   ,ContactMSTRID
           ,ConTableName
           ,ConPrimaryRecordId
           ,ConTableTypeId
           ,ConTypeId
           ,[ConItemNumber]
           ,[ConCodeId]
           ,[ConTitle]
           ,[ConDescription]
           ,[ConInstruction]
           ,[StatusId]
		   ,[ConIsDefault]
           ,[EnteredBy]
           ,[DateEntered]
           ,[ChangedBy]
           ,[DateChanged])
SELECT (select [ConOrgId] from [dbo].[CONTC000Master] where id = ContactID)
      ,ContactID
      ,'OrgPocContact'
      ,OrgID
      ,PocTypeId
      ,(select ConTypeId from [dbo].[CONTC000Master] where  id = ContactID) as ConTypeId
      ,PocSortOrder
      ,NULL
      ,PocTitle
      ,PocDescription
      ,PocInstructions
      ,StatusId
	  ,PocDefault
	  ,EnteredBy
	  ,DateEntered
	  ,ChangedBy
	  ,DateChanged
  FROM [dbo].[ORGAN001POC_Contacts]