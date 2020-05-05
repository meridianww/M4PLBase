ALTER TABLE [dbo].[JOBDL020Gateways] ADD [GwyPreferredMethod] [int] NULL
ALTER TABLE [dbo].[JOBDL020Gateways]  WITH CHECK ADD  CONSTRAINT [FK_JOBDL020Gateways_GwyPreferredMethod_SYSTM000Ref_Options] FOREIGN KEY([GwyPreferredMethod])
REFERENCES [dbo].[SYSTM000Ref_Options] ([Id])
GO
Declare @SysLookupId INT
Select  Top 1 @SysLookupId =  SysLookupId From [SYSTM000Ref_Options] Where SysLookupCode = 'JobPreferredMethod'

IF NOT EXISTS(Select 1 From dbo.SYSTM000ColumnsAlias Where ColtableName = 'JobGateway' AND ColColumnName = 'GwyPreferredMethod')
BEGIN
INSERT INTO dbo.SYSTM000ColumnsAlias (LangCode, ColTableName, ColAssociatedTableName, ColColumnName, ColAliasName, ColCaption, ColLookupId, ColLookupCode, ColDescription, ColSortOrder, ColIsReadOnly, ColIsVisible, ColIsDefault, StatusId, ColDisplayFormat, ColAllowNegativeValue, ColIsGroupBy, ColMask, IsGridColumn, ColGridAliasName)
VALUES ('EN', 'JobGateway', NULL, 'GwyPreferredMethod', 'Contact Method', 'Contact Method', @SysLookupId, 'JobPreferredMethod', '', 50, 0, 1, 1, 1, NULL, 0, 0, NULL, 0, 'Contact Method')
END