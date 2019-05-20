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
      ,(select TOP 1 f.id from [dbo].[CONTC000Master] f where f.ConEmailAddress = ISNULL((select TOP 1 m.ConEmailAddress from [M4PL_3030_Test].[dbo].[CONTC000Master] m where m.Id = VC.VendContactMSTRID), -1)) as VendContactMSTRID  --VC.VendContactMSTRID
      ,'VendContact'
      ,VC.VendVendorID
      ,183
      ,(select TOP 1 f.ConTypeId from [dbo].[CONTC000Master] f where f.ConEmailAddress = ISNULL((select TOP 1 m.ConEmailAddress from [M4PL_3030_Test].[dbo].[CONTC000Master] m where m.Id = VC.VendContactMSTRID), -1)) as ConTypeId
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
  INNER JOIN [M4PL_3030_Test].[dbo].[VEND000Master] V on V.Id = VC.VendVendorID
  WHERE (select TOP 1 f.id from [dbo].[CONTC000Master] f where f.ConEmailAddress = ISNULL((select TOP 1 m.ConEmailAddress from [M4PL_3030_Test].[dbo].[CONTC000Master] m where m.Id = VC.VendContactMSTRID), -1)) IS NOT NULL
  AND V.VendOrgID = 1
