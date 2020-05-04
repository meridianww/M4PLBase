IF NOT EXISTS (SELECT 1  FROM SYSTM000ColumnsAlias WHERE ColTableName = 'JobCargo' AND ColColumnName = 'CgoComment')
BEGIN

INSERT INTO [dbo].[SYSTM000ColumnsAlias]
           ([LangCode]
           ,[ColTableName]
           ,[ColAssociatedTableName]
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
           ,[ColMask]
           ,[IsGridColumn]
           ,[ColGridAliasName])
     VALUES
           ('EN'
           ,'JobCargo'
           ,NULL
           ,'CgoComment'
           ,'Comment'
           ,'Comment'
           ,NULL
           ,NULL
           ,NULL
           ,42
           ,0
           ,1
           ,1
           ,1
           ,NULL
           ,0
           ,0
           ,NULL
           ,0
           ,'Comment')

END
