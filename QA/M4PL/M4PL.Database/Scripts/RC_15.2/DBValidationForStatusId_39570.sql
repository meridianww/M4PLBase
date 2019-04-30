
INSERT INTO [dbo].[SYSTM000Validation]
           ([LangCode]
           ,[ValTableName]
           ,[RefTabPageId]
           ,[ValFieldName]
           ,[ValRequired]
           ,[ValRequiredMessage]
           ,[ValUnique]
           ,[StatusId]
           ,[DateEntered]
           ,[EnteredBy])
     VALUES
           ('EN'
           ,'SubSecurityByRole'
           ,0
           ,'StatusId'
           ,1
           ,'Status is Required'
           ,0
		   ,1
		   , CAST(N'2018-05-21 09:03:49.0000000' AS DateTime2)
		   , N'SimonDekker'
          )
INSERT INTO [dbo].[SYSTM000Validation]
           ([LangCode]
           ,[ValTableName]
           ,[RefTabPageId]
           ,[ValFieldName]
           ,[ValRequired]
           ,[ValRequiredMessage]
           ,[ValUnique]
           ,[StatusId]
           ,[DateEntered]
           ,[EnteredBy])
     VALUES
           ('EN'
           ,'OrgActSubSecurityByRole'
           ,0
           ,'StatusId'
           ,1
           ,'Status is Required'
           ,0
		   ,1
		   , CAST(N'2018-05-21 09:03:49.0000000' AS DateTime2)
		   , N'SimonDekker'
          )
