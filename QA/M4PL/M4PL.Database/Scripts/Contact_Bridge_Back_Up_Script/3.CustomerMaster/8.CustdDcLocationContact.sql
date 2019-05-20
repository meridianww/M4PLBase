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
      ,C.Id--CLC.ClcContactMSTRID
      ,'CustDcLocationContact'
      ,CLC.ClcCustDcLocationId
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
  LEFT JOIN [M4PL_3030_Test].[dbo].[CONTC000Master] CM ON CLC.ClcContactMSTRID = CM.Id
  LEFT JOIN [dbo].[CONTC000Master] C ON C.ConEmailAddress = CM.ConEmailAddress
  WHERE 1 = (SELECT TOP 1 org.Id FROM [dbo].[ORGAN000Master] org WHERE org.OrgTitle = CM.ConCompany)
