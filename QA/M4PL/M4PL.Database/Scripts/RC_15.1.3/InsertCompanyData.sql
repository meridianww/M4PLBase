INSERT INTO [dbo].[COMP000Master]
           ([CompOrgId]
           ,[CompTableName]
           ,[CompPrimaryRecordId]
           ,[CompCode]
           ,[CompTitle]
           ,[StatusId]
		   ,[EnteredBy]
           ,[DateEntered]
		   ,[ChangedBy]
           ,[DateChanged])
SELECT [CustOrgId],'Customer' TableName, [Id]
      ,[CustCode]
      ,[CustTitle]
	  ,[StatusId]
     ,ISNULL(EnteredBy, '') EnteredBy
      ,ISNULL(DateEntered,GETUTCDATE()) DateEntered
      ,[ChangedBy]
      ,[DateChanged]
  FROM [dbo].[CUST000Master]
  Where [CustOrgId] = 1
  UNION
  SELECT [VendOrgId],'Vendor' TableName, [Id]
      ,[VendCode]
      ,[VendTitle]
	  ,[StatusId]
     ,ISNULL(EnteredBy, '') EnteredBy
      ,ISNULL(DateEntered,GETUTCDATE()) DateEntered
      ,[ChangedBy]
      ,[DateChanged]
  FROM [dbo].[Vend000Master]
  Where [VendOrgId] = 1
  UNION
  SELECT [Id],'Organization' TableName, [Id]
      ,[OrgCode]
      ,[OrgTitle]
	  ,[StatusId]
	  ,ISNULL(EnteredBy, '') EnteredBy
      ,ISNULL(DateEntered,GETUTCDATE()) DateEntered
      ,[ChangedBy]
      ,[DateChanged]
  FROM [dbo].[ORGAN000Master]
  Where [Id] = 1


