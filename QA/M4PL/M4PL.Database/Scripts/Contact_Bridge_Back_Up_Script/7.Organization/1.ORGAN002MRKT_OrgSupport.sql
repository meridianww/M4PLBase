INSERT INTO [dbo].[ORGAN002MRKT_OrgSupport]
           ([OrgID]
           ,[MrkOrder]
           ,[MrkCode]
           ,[MrkTitle]
           ,[MrkDescription]
           ,[MrkInstructions]
           ,[DateEntered]
           ,[EnteredBy]
           ,[DateChanged]
           ,[ChangedBy])
     SELECT
           1 [OrgID]
           ,[MrkOrder]
           ,[MrkCode]
           ,[MrkTitle]
           ,[MrkDescription]
           ,[MrkInstructions]
           ,[DateEntered]
           ,[EnteredBy]
           ,[DateChanged]
           ,[ChangedBy] FROM [M4PL_3030_Test].[dbo].[ORGAN002MRKT_OrgSupport]
		   WHERE OrgID = 1
GO


