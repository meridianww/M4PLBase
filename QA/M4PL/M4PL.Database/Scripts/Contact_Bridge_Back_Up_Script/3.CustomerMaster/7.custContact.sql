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
SELECT 1 as conOrgId
      ,CM.Id--CC.CustContactMSTRID
      ,'CustContact'
      ,CU.Id --CC.CustCustomerID
      ,183
      ,CM.ConTypeId
	  ,CC.CustItemNumber
      ,8
      ,CC.CustContactTitle
      ,NULL
      ,NULL
      ,CC.StatusId
	  ,0
	  ,CC.EnteredBy
	  ,CC.DateEntered
	  ,CC.ChangedBy
	  ,CC.DateChanged
  FROM [M4PL_3030_Test].[dbo].[CUST010Contacts]  CC 
  INNER JOIN [CONTC000Master] CM ON CC.CustContactMSTRID = CM.[3030Id] 
  INNER JOIN [dbo].[CUST000Master] CU ON CU.[3030Id] = CC.[CustCustomerID]
where CU.CustOrgId = 1