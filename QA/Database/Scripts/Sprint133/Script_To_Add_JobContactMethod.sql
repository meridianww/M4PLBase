
ALTER TABLE [dbo].[JOBDL000Master] ADD JobPreferredMethod INT NULL


IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS WHERE CONSTRAINT_NAME ='FK_JOBDL000Master_JobPreferredMethod_SYSTM000Ref_Options')
BEGIN
ALTER TABLE [dbo].[JOBDL000Master]  WITH CHECK ADD  CONSTRAINT [FK_JOBDL000Master_JobPreferredMethod_SYSTM000Ref_Options] FOREIGN KEY([JobPreferredMethod])
REFERENCES [dbo].[SYSTM000Ref_Options] ([Id])
END

Declare @LookupId INT
IF NOT EXISTS (Select 1 From SYSTM000Ref_Lookup Where LkupCode = 'JobPreferredMethod')
BEGIN
INSERT INTO SYSTM000Ref_Lookup (LkupCode,LkupTableName)
Values ('JobPreferredMethod', 'Global')
END
Select @LookupId = ID From SYSTM000Ref_Lookup Where LkupCode = 'JobPreferredMethod'

IF NOT EXISTS (Select 1 From dbo.SYSTM000Ref_Options Where SysLookupId = @LookupId AND SysLookupCode = 'JobPreferredMethod' AND SysOptionName = 'Phone')
BEGIN
INSERT INTO dbo.SYSTM000Ref_Options (SysLookupId,SysLookupCode,SysOptionName,SysSortOrder,SysDefault,IsSysAdmin,StatusId,DateEntered,EnteredBy)
Values (@LookupId,'JobPreferredMethod','Phone',1,1,0,1,GetDate(),NULL)
END
IF NOT EXISTS (Select 1 From dbo.SYSTM000Ref_Options Where SysLookupId = @LookupId AND SysLookupCode = 'JobPreferredMethod' AND SysOptionName = 'Text')
BEGIN
INSERT INTO dbo.SYSTM000Ref_Options (SysLookupId,SysLookupCode,SysOptionName,SysSortOrder,SysDefault,IsSysAdmin,StatusId,DateEntered,EnteredBy)
Values (@LookupId,'JobPreferredMethod','Text',2,0,0,1,GetDate(),NULL)
END
IF NOT EXISTS (Select 1 From dbo.SYSTM000Ref_Options Where SysLookupId = @LookupId AND SysLookupCode = 'JobPreferredMethod' AND SysOptionName = 'Email')
BEGIN
INSERT INTO dbo.SYSTM000Ref_Options (SysLookupId,SysLookupCode,SysOptionName,SysSortOrder,SysDefault,IsSysAdmin,StatusId,DateEntered,EnteredBy)
Values (@LookupId,'JobPreferredMethod','Email',3,0,0,1,GetDate(),NULL)
END

IF NOT EXISTS (Select * From dbo.SYSTM000ColumnsAlias Where ColTableName = 'Job' AND ColColumnName = 'JobPreferredMethod')
BEGIN
INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColGridAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask, IsGridColumn)
VALUES ('EN', 'Job', NULL, 'JobPreferredMethod', 'Contact Method', 'Contact Method', 'Contact Method', @LookupId, 'JobPreferredMethod', '', 136, 0, 1, 1, 1, NULL, 0, 0, NULL, 0)
END
