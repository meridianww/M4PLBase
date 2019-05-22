
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
	,(select TOP 1 f.id from [dbo].[CONTC000Master] f where f.[3030Id] =  OG.ContactID)-- ContactID
	  ,'OrgPocContact'
      ,OG.OrgID
      ,OG.PocTypeId
      ,31
      ,OG.PocSortOrder
      ,1
      ,OG.PocTitle
      ,OG.PocDescription
      ,OG.PocInstructions
      ,OG.StatusId
	  ,OG.PocDefault
	  ,OG.EnteredBy
	  ,OG.DateEntered
	  ,OG.ChangedBy
	  ,OG.DateChanged
  FROM [M4PL_3030_Test].[dbo].[ORGAN001POC_Contacts] OG 
  WHERE OG.OrgID = 1