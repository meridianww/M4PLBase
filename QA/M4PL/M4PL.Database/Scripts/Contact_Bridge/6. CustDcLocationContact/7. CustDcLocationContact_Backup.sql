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
      ,CLC.ClcContactMSTRID
      ,'CustDcLocationContact'
      ,CLC.ClcCustDcLocationId
      ,CM.ConUDF01
      ,CM.ConTypeId
      ,CLC.ClcItemNumber
      ,0
      ,CLC.ClcContactTitle
      ,NULL
      ,NULL
      ,CLC.StatusId
	  ,0
	  ,CLC.EnteredBy
	  ,CLC.DateEntered
	  ,CLC.ChangedBy
	  ,CLC.DateChanged
  FROM [dbo].CUST041DCLocationContacts CLC LEFT JOIN
  [dbo].[CONTC000Master] CM ON CLC.ContactMSTRID = CM.Id