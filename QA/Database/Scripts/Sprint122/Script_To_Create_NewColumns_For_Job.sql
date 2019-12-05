IF COL_LENGTH('dbo.JOBDL000Master', 'JobCubesUnitTypeId') IS NULL
BEGIN
ALTER TABLE dbo.JOBDL000Master ADD JobCubesUnitTypeId INT NULL

ALTER TABLE [dbo].[JOBDL000Master]  WITH CHECK ADD  CONSTRAINT [FK_JOBDL000Master_JobCubesUnitTypeId_SYSTM000Ref_Options] FOREIGN KEY([JobCubesUnitTypeId])
REFERENCES [dbo].[SYSTM000Ref_Options] ([Id])

ALTER TABLE [dbo].[JOBDL000Master] CHECK CONSTRAINT [FK_JOBDL000Master_JobCubesUnitTypeId_SYSTM000Ref_Options]
END
IF COL_LENGTH('dbo.JOBDL000Master', 'JobWeightUnitTypeId') IS NULL
BEGIN
ALTER TABLE dbo.JOBDL000Master ADD JobWeightUnitTypeId  INT NULL

ALTER TABLE [dbo].[JOBDL000Master]  WITH CHECK ADD  CONSTRAINT [FK_JOBDL000Master_JobWeightUnitTypeId_SYSTM000Ref_Options] FOREIGN KEY([JobWeightUnitTypeId])
REFERENCES [dbo].[SYSTM000Ref_Options] ([Id])

ALTER TABLE [dbo].[JOBDL000Master] CHECK CONSTRAINT [FK_JOBDL000Master_JobWeightUnitTypeId_SYSTM000Ref_Options]
END

IF COL_LENGTH('dbo.JOBDL000Master', 'JobTotalWeight') IS NULL
BEGIN
ALTER TABLE dbo.JOBDL000Master ADD JobTotalWeight Decimal(18,2) NULL
END

Declare @LkpCubesUnitTypeId INT, @LkpWeightUnitTypeId INT
IF NOT EXISTS (Select 1 From SYSTM000Ref_Lookup Where LkupCode = 'CubesUnitType')
BEGIN
INSERT INTO SYSTM000Ref_Lookup (LkupCode, LkupTableName)
Values ('CubesUnitType', 'Global')
END

IF NOT EXISTS (Select 1 From SYSTM000Ref_Lookup Where LkupCode = 'WeightUnitType')
BEGIN
INSERT INTO SYSTM000Ref_Lookup (LkupCode, LkupTableName)
Values ('WeightUnitType', 'Global')
END

Select @LkpCubesUnitTypeId = ID FROM SYSTM000Ref_Lookup Where LkupCode = 'CubesUnitType'
Select @LkpWeightUnitTypeId = ID FROM SYSTM000Ref_Lookup Where LkupCode = 'WeightUnitType'

IF NOT EXISTS (Select 1 From SYSTM000Ref_Options Where SysLookupCode = 'CubesUnitType' AND SysOptionName = 'E')
BEGIN
INSERT INTO SYSTM000Ref_Options (SysLookupId, SysLookupCode, SysOptionName,SysSortOrder, SysDefault,IsSysAdmin,StatusId,DateEntered)
VALUES (@LkpCubesUnitTypeId, 'CubesUnitType','E',1,1,0,1,GetDate())
END

IF NOT EXISTS (Select 1 From SYSTM000Ref_Options Where SysLookupCode = 'CubesUnitType' AND SysOptionName = 'X')
BEGIN
INSERT INTO SYSTM000Ref_Options (SysLookupId, SysLookupCode, SysOptionName,SysSortOrder, SysDefault,IsSysAdmin,StatusId,DateEntered)
VALUES (@LkpCubesUnitTypeId, 'CubesUnitType','X',1,0,0,1,GetDate())
END

IF NOT EXISTS (Select 1 From SYSTM000Ref_Options Where SysLookupCode = 'WeightUnitType' AND SysOptionName = 'K')
BEGIN
INSERT INTO SYSTM000Ref_Options (SysLookupId, SysLookupCode, SysOptionName,SysSortOrder, SysDefault,IsSysAdmin,StatusId,DateEntered)
VALUES (@LkpWeightUnitTypeId, 'WeightUnitType','K',1,1,0,1,GetDate())
END

IF NOT EXISTS (Select 1 From SYSTM000Ref_Options Where SysLookupCode = 'WeightUnitType' AND SysOptionName = 'L')
BEGIN
INSERT INTO SYSTM000Ref_Options (SysLookupId, SysLookupCode, SysOptionName,SysSortOrder, SysDefault,IsSysAdmin,StatusId,DateEntered)
VALUES (@LkpWeightUnitTypeId, 'WeightUnitType','L',1,0,0,1,GetDate())
END


IF NOT EXISTS (Select 1 From dbo.SYSTM000ColumnsAlias Where ColTableName ='Job' AND ColColumnName = 'JobCubesUnitTypeId')
BEGIN
INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColGridAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask, IsGridColumn)
VALUES ('EN', 'Job', NULL, 'JobCubesUnitTypeId', 'Cubes Unit Type', 'Cubes Unit Type', 'Cubes Unit Type', @LkpCubesUnitTypeId, 'CubesUnitType', '', 133, 0, 1, 1, 1, NULL, 0, 0, NULL, 0)
END
IF NOT EXISTS (Select 1 From dbo.SYSTM000ColumnsAlias Where ColTableName ='Job' AND ColColumnName = 'JobWeightUnitTypeId')
BEGIN
INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColGridAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask, IsGridColumn)
VALUES ('EN', 'Job', NULL, 'JobWeightUnitTypeId', 'Weight Unit Type', 'Weight Unit Type', 'Weight Unit Type', @LkpWeightUnitTypeId, 'WeightUnitType', '', 134, 0, 1, 1, 1, NULL, 0, 0, NULL, 0)
END

IF NOT EXISTS (Select 1 From dbo.SYSTM000ColumnsAlias Where ColTableName ='Job' AND ColColumnName = 'JobTotalWeight')
BEGIN
INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColGridAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask, IsGridColumn)
VALUES ('EN', 'Job', NULL, 'JobTotalWeight', 'Total Weight', 'Total Weight', 'Total Weight', NULL, NULL, '', 135, 0, 1, 1, 1, NULL, 0, 0, NULL, 0)
END

