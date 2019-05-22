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
      ,CM.Id--CLC.ClcContactMSTRID
      ,'CustDcLocationContact'
      ,DL.Id
      ,CM.ConUDF01
      ,CM.ConTypeId
      ,CLC.ClcItemNumber
      ,13
      ,CLC.ClcContactTitle
      ,NULL
      ,NULL
      ,CLC.StatusId
	  ,0
	  ,CLC.EnteredBy
	  ,CLC.DateEntered
	  ,CLC.ChangedBy
	  ,CLC.DateChanged
  FROM [M4PL_3030_Test].[dbo].CUST041DCLocationContacts CLC 
  INNER JOIN [dbo].[CONTC000Master] CM ON CLC.ClcContactMSTRID = CM.[3030Id]
  INNER JOIN [dbo].[CUST040DCLocations] DL ON DL.[3030Id] = CLC.ClcCustDcLocationId
