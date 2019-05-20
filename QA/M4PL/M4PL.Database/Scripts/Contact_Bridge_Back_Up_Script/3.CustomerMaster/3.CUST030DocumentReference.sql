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
           ,(SELECT TOP 1 C.ID FROM [dbo].[CUST000Master] C WHERE C.CustCode = CU.CustCode) [CdrCustomerID]
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
		   left join [M4PL_3030_Test].[dbo].[CUST000Master] CU on CU.ID = CD.CdrCustomerID
		   WHERE CD.CdrOrgID = 1  
GO


