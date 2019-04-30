
INSERT INTO [dbo].[CONTC010Bridge]
           (ConOrgId
		   ,ContactMSTRID
           ,ConTableName
           ,ConPrimaryRecordId
           ,ConTableTypeId
           ,ConTypeId
           ,[ConItemNumber]
           ,[ConCode]
           ,[ConTitle]
           ,[ConDescription]
           ,[ConInstruction]
           ,[StatusId]
		   ,[ConIsDefault]
           ,[EnteredBy]
           ,[DateEntered]
           ,[ChangedBy]
           ,[DateChanged])
SELECT (select ConOrgId from CONTC000Master where id = ContactID)
      ,ContactID
      ,'OrgPocContact'
      ,OrgID
      ,PocTypeId
      ,31
      ,PocSortOrder
      ,PocCode
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