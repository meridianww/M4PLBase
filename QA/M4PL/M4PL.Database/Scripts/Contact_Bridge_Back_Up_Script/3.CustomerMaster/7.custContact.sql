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
      ,c.id--CC.CustContactMSTRID
      ,'CustContact'
      ,cum.Id --CC.CustCustomerID
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
  INNER JOIN [M4PL_3030_Test].[dbo].[CONTC000Master] CM ON CC.CustContactMSTRID = CM.Id 
  INNER JOIN [M4PL_3030_Test].[dbo].[CUST000Master] CU ON CU.Id = CC.CustCustomerID
  LEFT JOIN [dbo].[CUST000Master] cum on cum.CustCode = CU.CustCode
  LEFT join dbo.CONTC000Master c on ((c.ConEmailAddress = CM.ConEmailAddress or c.ConEmailAddress = CM.ConEmailAddress2) and c.ConFirstName = CM.ConFirstName)
where c.id is not null and cum.Id is not null and cum.CustOrgId = 1