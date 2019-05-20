
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
      ,CC.CustContactMSTRID
      ,'CustContact'
      ,CC.CustCustomerID
      ,CM.ConUDF01
      ,CM.ConTypeId
	  ,CC.CustItemNumber
      ,0
      ,CC.CustContactTitle
      ,NULL
      ,NULL
      ,CC.StatusId
	  ,0
	  ,CC.EnteredBy
	  ,CC.DateEntered
	  ,CC.ChangedBy
	  ,CC.DateChanged
  FROM [dbo].[CUST010Contacts]  CC LEFT JOIN
  [dbo].[CONTC000Master] CM ON CC.ContactMSTRID = CM.Id