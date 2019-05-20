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
SELECT (select ConOrgId from CONTC000Master where id = VlcContactMSTRID)
      ,VlcContactMSTRID
      ,'VendDcLocationContact'
      ,VlcVendDcLocationId
      ,(select [ConUDF01] from [dbo].[CONTC000Master] where  id = VlcContactMSTRID) as ConTableTypeId
      ,(select ConTypeId from [dbo].[CONTC000Master] where  id = VlcContactMSTRID) as ConTypeId
      ,VlcItemNumber
      ,Null
      ,VlcContactTitle
      ,NULL
      ,NULL
      ,StatusId
	  ,0
	  ,EnteredBy
	  ,DateEntered
	  ,ChangedBy
	  ,DateChanged
  FROM [dbo].VEND041DCLocationContacts