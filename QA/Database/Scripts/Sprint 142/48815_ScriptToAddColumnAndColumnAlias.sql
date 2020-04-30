IF  NOT EXISTS(SELECT TOP 1 * FROM INFORMATION_SCHEMA.COLUMNS WHERE [TABLE_NAME] = 'JOBDL000Master'AND [COLUMN_NAME] = 'JobServiceOrder')
BEGIN
ALTER TABLE [dbo].[JOBDL000Master]
    ADD [JobServiceOrder]  INT NULL

END
IF  NOT EXISTS(SELECT TOP 1 * FROM INFORMATION_SCHEMA.COLUMNS WHERE [TABLE_NAME] = 'JOBDL000Master'AND [COLUMN_NAME] = 'JobServiceActual')
BEGIN
ALTER TABLE [dbo].[JOBDL000Master]
    ADD [JobServiceActual]  INT NULL

END



IF NOT EXISTS(select top 1 1 from [SYSTM000ColumnsAlias] where  ColTableName = 'Job' AND  ColColumnName = 'JobServiceOrder')
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
           ,'JobServiceOrder'
           ,'Service Order'
           ,'Service Order'
           ,NULL
           ,NULL
           ,NULL
           ,(select MAX(ColSortOrder)+1 from  [SYSTM000ColumnsAlias] where ColTableName = 'JOB')
           ,0 
           ,1
           ,1
           ,1
           ,NULL
		   ,0
		   ,0
		   ,NULL
		   ,1
           ,'Service Order')
 END
IF NOT EXISTS(select top 1 1 from [SYSTM000ColumnsAlias] where  ColTableName = 'Job' AND  ColColumnName = 'JobServiceActual')
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
           ,'JobServiceActual'
           ,'Service Actual'
           ,'Service Actual'
           ,NULL
           ,NULL
           ,NULL
           ,(select MAX(ColSortOrder)+1 from  [SYSTM000ColumnsAlias] where ColTableName = 'JOB' )
           ,0 
           ,1
           ,1
           ,1
           ,NULL
		   ,0
		   ,0
		   ,NULL
		   ,1
           ,'Service Actual')
 END


