
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
SELECT CM.ConOrgId
      ,VC.VendContactMSTRID
      ,'VendContact'
      ,VC.VendVendorID
      ,CM.ConUDF01
      ,CM.ConTypeId
	  ,VC.VendItemNumber
      ,0
      ,VC.VendContactTitle
      ,NULL
      ,NULL
      ,VC.StatusId
	  ,0
	  ,VC.EnteredBy
	  ,VC.DateEntered
	  ,VC.ChangedBy
	  ,VC.DateChanged
  FROM [dbo].[VEND010Contacts]  VC LEFT JOIN
  [dbo].[CONTC000Master] CM ON VC.ContactMSTRID = CM.Id