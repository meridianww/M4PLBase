INSERT INTO [dbo].[CUST020BusinessTerms]
           ([LangCode]
           ,[CbtOrgID]
           ,[CbtCustomerId]
           ,[CbtItemNumber]
           ,[CbtCode]
           ,[CbtTitle]
           ,[CbtDescription]
           ,[BusinessTermTypeId]
           ,[CbtActiveDate]
           ,[CbtValue]
           ,[CbtHiThreshold]
           ,[CbtLoThreshold]
           ,[CbtAttachment]
           ,[StatusId]
           ,[EnteredBy]
           ,[DateEntered]
           ,[ChangedBy]
           ,[DateChanged])
     SELECT
           CB.[LangCode]
           ,CB.[CbtOrgID]
           ,(select top 1 c.id from dbo.CUST000Master c where c.CustCode = cu.CustCode)
		   [CbtCustomerId]
           ,CB.[CbtItemNumber]
           ,CB.[CbtCode]
           ,CB.[CbtTitle]
           ,CB.[CbtDescription]
           ,CB.[BusinessTermTypeId]
           ,CB.[CbtActiveDate]
           ,CB.[CbtValue]
           ,CB.[CbtHiThreshold]
           ,CB.[CbtLoThreshold]
           ,CB.[CbtAttachment]
           ,CB.[StatusId]
           ,CB.[EnteredBy]
           ,CB.[DateEntered]
           ,CB.[ChangedBy]
           ,CB.[DateChanged] FROM [M4PL_3030_Test].[dbo].[CUST020BusinessTerms] CB
		   left join M4PL_3030_Test.dbo.CUST000Master cu on cu.id = CB.CbtCustomerId
		   WHERE CbtOrgID = 1 
GO


