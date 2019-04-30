
INSERT INTO [dbo].[CONTC010Bridge]
           (ConOrgId
		   ,ContactMSTRID
           ,ConTableName
           ,ConPrimaryRecordId
           ,ConTableTypeId
           ,ConTypeId
           ,[ConItemNumber]
           ,[ConCode]
           ,[ConTitle]
           ,[ConDescription]
           ,[ConInstruction]
           ,[StatusId]
		   ,[ConIsDefault]
           ,[EnteredBy]
           ,[DateEntered]
           ,[ChangedBy]
           ,[DateChanged])
SELECT (select ConOrgId from CONTC000Master where id = CustContactMSTRID)
      ,CustContactMSTRID
      ,'CustContact'
      ,CustCustomerID
      ,7
      ,64
      ,CustItemNumber
      ,CustContactCode
      ,CustContactTitle
      ,NULL
      ,NULL
      ,StatusId
	  ,0
	  ,EnteredBy
	  ,DateEntered
	  ,ChangedBy
	  ,DateChanged
  FROM [dbo].[CUST010Contacts]