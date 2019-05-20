Delete from [SYSTM000ColumnsAlias] where  [LangCode] ='EN' And [ColTableName] = 'Contact' and [ColColumnName] = 'ConCompanyName' and [ColAliasName] ='Company Name'
INSERT INTO [dbo].[SYSTM000ColumnsAlias]
           ([LangCode]
           ,[ColTableName]
           ,[ColColumnName]
           ,[ColAliasName]
           ,[ColCaption]
           ,[ColLookupId]
           ,[ColLookupCode]
           ,[ColDescription]
           ,[ColSortOrder]
           ,[ColIsReadOnly]
           ,[ColIsVisible]
           ,[ColIsDefault]
           ,[StatusId]
           ,[ColDisplayFormat]
           ,[ColAllowNegativeValue]
           ,[ColIsGroupBy]
           ,[ColMask])
     VALUES
           ('EN'
           ,'Contact'
           ,'ConCompanyName'
           ,'Company Name'
           ,'Company Name'
           ,NULL
           ,NULL
           ,NULL
           ,NULL
           ,0
           ,1
           ,0
           ,1
           ,NULL
           ,NULL
           ,0
           ,NULL)
