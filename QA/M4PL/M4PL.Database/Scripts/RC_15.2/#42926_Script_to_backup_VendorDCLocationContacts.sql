
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
SELECT (select ConOrgId from CONTC000Master where id = VlcContactMSTRID)
      ,VlcContactMSTRID
      ,'VendDcLocationContact'
      ,VlcVendDcLocationId
      ,7
      ,63
      ,VlcItemNumber
      ,VlcContactCode
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