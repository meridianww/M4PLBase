INSERT INTO [dbo].[CUST030DocumentReference]
           ([CdrOrgID]
           ,[CdrCustomerID]
           ,[CdrItemNumber]
           ,[CdrCode]
           ,[CdrTitle]
           ,[DocRefTypeId]
           ,[DocCategoryTypeId]
           ,[CdrDescription]
           ,[CdrAttachment]
           ,[CdrDateStart]
           ,[CdrDateEnd]
           ,[CdrRenewal]
           ,[StatusId]
           ,[EnteredBy]
           ,[DateEntered]
           ,[ChangedBy]
           ,[DateChanged])
     SELECT
            1
           ,CU.Id
           ,CD.[CdrItemNumber]
           ,CD.[CdrCode]
           ,CD.[CdrTitle]
           ,CD.[DocRefTypeId]
           ,CD.[DocCategoryTypeId]
           ,CD.[CdrDescription]
           ,CD.[CdrAttachment]
           ,CD.[CdrDateStart]
           ,CD.[CdrDateEnd]
           ,CD.[CdrRenewal]
           ,CD.[StatusId]
           ,CD.[EnteredBy]
           ,CD.[DateEntered]
           ,CD.[ChangedBy]
           ,CD.[DateChanged] FROM [M4PL_3030_Test].[dbo].[CUST030DocumentReference] CD
		   INNER join [dbo].[CUST000Master] CU on CU.[3030Id] = CD.CdrCustomerID
		   WHERE CD.CdrOrgID = 1  
GO


