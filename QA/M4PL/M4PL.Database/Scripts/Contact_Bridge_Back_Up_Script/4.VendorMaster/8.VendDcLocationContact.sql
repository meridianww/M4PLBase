
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
      ,(select TOP 1 f.id from [dbo].[CONTC000Master] f where f.ConEmailAddress = ISNULL((select TOP 1 m.ConEmailAddress from [M4PL_3030_Test].[dbo].[CONTC000Master] m where m.Id = VN.VlcContactMSTRID), -1)) as VendContactMSTRID --VN.VlcContactMSTRID--
      ,'VendDcLocationContact'
      ,VN.VlcVendDcLocationId
      ,7
      ,63
      ,VN.VlcItemNumber
      ,13
      ,VN.VlcContactTitle
      ,NULL
      ,NULL
      ,VN.StatusId
	  ,0
	  ,VN.EnteredBy
	  ,VN.DateEntered
	  ,VN.ChangedBy
	  ,VN.DateChanged
  FROM [M4PL_3030_Test].[dbo].[VEND041DCLocationContacts] VN 
  INNER JOIN [M4PL_3030_Test].[dbo].[VEND040DCLocations] VL on VL.Id = VN.VlcVendDcLocationId
  INNER JOIN [M4PL_3030_Test].[dbo].[VEND000Master] V on V.Id = VL.VdcVendorID
  WHERE (select TOP 1 f.id from [dbo].[CONTC000Master] f where f.ConEmailAddress = ISNULL((select TOP 1 m.ConEmailAddress from [M4PL_3030_Test].[dbo].[CONTC000Master] m where m.Id = VN.VlcContactMSTRID), -1)) is not null
  and V.VendOrgID = 1