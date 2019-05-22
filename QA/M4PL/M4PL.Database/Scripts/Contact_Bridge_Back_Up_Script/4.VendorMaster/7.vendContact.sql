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
SELECT 1
      ,CM.Id
      ,'VendContact'
      ,CU.Id
      ,183
      ,CM.ConTypeId
	  ,VC.VendItemNumber
      ,13
      ,VC.VendContactTitle
      ,NULL
      ,NULL
      ,VC.StatusId
	  ,0
	  ,VC.EnteredBy
	  ,VC.DateEntered
	  ,VC.ChangedBy
	  ,VC.DateChanged
  FROM [M4PL_3030_Test].[dbo].[VEND010Contacts]  VC 
 INNER JOIN [CONTC000Master] CM ON VC.VendContactMSTRID = CM.[3030Id] 
  INNER JOIN [dbo].[CUST000Master] CU ON CU.[3030Id] = vc.VendVendorID
  WHERE CU.CustOrgId = 1
