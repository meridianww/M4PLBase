
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
      ,CM.Id --VN.VlcContactMSTRID--
      ,'VendDcLocationContact'
      ,VL.Id
      ,CM.ConUDF01
      ,CM.ConTypeId
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
  INNER JOIN [M4PL_3030_Test].[dbo].[VEND040DCLocations] VL on VL.[3030Id] = VN.VlcVendDcLocationId  
  INNER JOIN [dbo].[CONTC000Master] CM ON VN.VlcContactMSTRID = CM.[3030Id]