IF NOT EXISTS(SELECT 1 FROM [dbo].[SYSTM000ColumnsAlias] where ColTableName= 'JOB' AND [ColColumnName] = 'IsJobVocSurvey' )
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
           ,'Job'
           ,NULL
           ,'IsJobVocSurvey'
           ,'Voc Survey'
           ,'Voc Survey'
           ,NULL
           ,NULL
           ,NULL
           , (select MAX([ColSortOrder]) +1   FROM [dbo].[SYSTM000ColumnsAlias] where ColTableName= 'JOB' )
           ,0
           ,1
           ,1
           ,1
           ,NULL
           ,0
           ,0
           ,NULL
           ,1
           ,'Voc Survey')

END


