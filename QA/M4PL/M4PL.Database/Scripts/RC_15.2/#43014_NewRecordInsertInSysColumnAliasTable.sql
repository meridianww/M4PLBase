/*
This script was created by Visual Studio on 4/29/2019 at 3:16 PM.
Run this script on 172.30.255.62\MSSQLSERVER,1433.M4PL_DEV (akhil1) to make it the same as DOLAP101\SQLEXPRESS2014.M4PL_DEV (DREAMORBIT\nikhil.chauhan).
This script performs its actions in the following order:
1. Disable foreign-key constraints.
2. Perform DELETE commands. 
3. Perform UPDATE commands.
4. Perform INSERT commands.
5. Re-enable foreign-key constraints.
Please back up your target database before running this script.
*/
SET NUMERIC_ROUNDABORT OFF
GO
SET XACT_ABORT, ANSI_PADDING, ANSI_WARNINGS, CONCAT_NULL_YIELDS_NULL, ARITHABORT, QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*Pointer used for text / image updates. This might not be needed, but is declared here just in case*/
DECLARE @pv binary(16)
BEGIN TRANSACTION
ALTER TABLE [dbo].[SYSTM000ColumnsAlias] DROP CONSTRAINT [FK_SYSTM000ColumnsAlias_Status_SYSTM000Ref_Options]
ALTER TABLE [dbo].[SYSTM000ColumnsAlias] DROP CONSTRAINT [FK_SYSTM000ColumnsAlias_SYSTM000Ref_Lookup]
ALTER TABLE [dbo].[SYSTM000ColumnsAlias] DROP CONSTRAINT [FK_SYSTM000ColumnsAlias_SYSTM000Ref_Table]
UPDATE [dbo].[SYSTM000ColumnsAlias] SET [ColAliasName]=N'Job Title', [ColCaption]=N'Job Title' WHERE [Id]=12057
UPDATE [dbo].[SYSTM000ColumnsAlias] SET [ColColumnName]=N'ConAssignment', [ColIsVisible]=1 WHERE [Id]=12060
UPDATE [dbo].[SYSTM000ColumnsAlias] SET [ColColumnName]=N'ConGateway', [ColIsVisible]=1 WHERE [Id]=12061
UPDATE [dbo].[SYSTM000ColumnsAlias] SET [ColLookupId]=54, [ColLookupCode]=N'VendorLocationRoleType', [ColIsReadOnly]=0 WHERE [Id]=22068
UPDATE [dbo].[SYSTM000ColumnsAlias] SET [ColIsReadOnly]=0 WHERE [Id]=22069
UPDATE [dbo].[SYSTM000ColumnsAlias] SET [ColIsReadOnly]=0 WHERE [Id]=22070
UPDATE [dbo].[SYSTM000ColumnsAlias] SET [ColIsReadOnly]=0 WHERE [Id]=22071
UPDATE [dbo].[SYSTM000ColumnsAlias] SET [ColTableName]=N'VendDcLocationContact', [ColColumnName]=N'ConBusinessAddress1', [ColAliasName]=N'Business Address Line 1', [ColCaption]=N'', [ColDescription]=N'', [ColSortOrder]=17, [ColIsReadOnly]=0, [ColIsVisible]=0 WHERE [Id]=32110
SET IDENTITY_INSERT [dbo].[SYSTM000ColumnsAlias] ON
INSERT INTO [dbo].[SYSTM000ColumnsAlias] ([Id], [LangCode], [ColTableName], [ColColumnName], [ColAliasName], [ColCaption], [ColLookupId], [ColLookupCode], [ColDescription], [ColSortOrder], [ColIsReadOnly], [ColIsVisible], [ColIsDefault], [StatusId], [ColDisplayFormat], [ColAllowNegativeValue], [ColIsGroupBy], [ColMask]) VALUES (32111, N'EN', N'VendDcLocationContact', N'ConBusinessAddress2', N'Business Address Line 2', N'Business Address', NULL, NULL, N'', 18, 0, 0, 1, 1, NULL, 0, 0, NULL)
INSERT INTO [dbo].[SYSTM000ColumnsAlias] ([Id], [LangCode], [ColTableName], [ColColumnName], [ColAliasName], [ColCaption], [ColLookupId], [ColLookupCode], [ColDescription], [ColSortOrder], [ColIsReadOnly], [ColIsVisible], [ColIsDefault], [StatusId], [ColDisplayFormat], [ColAllowNegativeValue], [ColIsGroupBy], [ColMask]) VALUES (32112, N'EN', N'VendDcLocationContact', N'ConBusinessCity', N'Business City', N'Business City', NULL, NULL, N'', 19, 0, 0, 1, 1, NULL, 0, 0, NULL)
INSERT INTO [dbo].[SYSTM000ColumnsAlias] ([Id], [LangCode], [ColTableName], [ColColumnName], [ColAliasName], [ColCaption], [ColLookupId], [ColLookupCode], [ColDescription], [ColSortOrder], [ColIsReadOnly], [ColIsVisible], [ColIsDefault], [StatusId], [ColDisplayFormat], [ColAllowNegativeValue], [ColIsGroupBy], [ColMask]) VALUES (32113, N'EN', N'VendDcLocationContact', N'ConBusinessCountryId', N'Business Country Region', N'', 51, N'Countries', N'', 22, 0, 0, 1, 1, NULL, 0, 0, NULL)
INSERT INTO [dbo].[SYSTM000ColumnsAlias] ([Id], [LangCode], [ColTableName], [ColColumnName], [ColAliasName], [ColCaption], [ColLookupId], [ColLookupCode], [ColDescription], [ColSortOrder], [ColIsReadOnly], [ColIsVisible], [ColIsDefault], [StatusId], [ColDisplayFormat], [ColAllowNegativeValue], [ColIsGroupBy], [ColMask]) VALUES (32114, N'EN', N'VendDcLocationContact', N'ConBusinessStateId', N'Business State Province', N'', NULL, NULL, N'', 20, 0, 0, 1, 1, NULL, 0, 0, NULL)
INSERT INTO [dbo].[SYSTM000ColumnsAlias] ([Id], [LangCode], [ColTableName], [ColColumnName], [ColAliasName], [ColCaption], [ColLookupId], [ColLookupCode], [ColDescription], [ColSortOrder], [ColIsReadOnly], [ColIsVisible], [ColIsDefault], [StatusId], [ColDisplayFormat], [ColAllowNegativeValue], [ColIsGroupBy], [ColMask]) VALUES (32115, N'EN', N'VendDcLocationContact', N'ConBusinessZipPostal', N'Business Zip Postal', N'', NULL, NULL, N'', 21, 0, 0, 1, 1, NULL, 0, 0, NULL)
INSERT INTO [dbo].[SYSTM000ColumnsAlias] ([Id], [LangCode], [ColTableName], [ColColumnName], [ColAliasName], [ColCaption], [ColLookupId], [ColLookupCode], [ColDescription], [ColSortOrder], [ColIsReadOnly], [ColIsVisible], [ColIsDefault], [StatusId], [ColDisplayFormat], [ColAllowNegativeValue], [ColIsGroupBy], [ColMask]) VALUES (32116, N'EN', N'VendDcLocationContact', N'ConEmailAddress', N'Work Email', N'Work Email', NULL, NULL, N'', 8, 0, 0, 1, 1, NULL, 0, 0, NULL)
INSERT INTO [dbo].[SYSTM000ColumnsAlias] ([Id], [LangCode], [ColTableName], [ColColumnName], [ColAliasName], [ColCaption], [ColLookupId], [ColLookupCode], [ColDescription], [ColSortOrder], [ColIsReadOnly], [ColIsVisible], [ColIsDefault], [StatusId], [ColDisplayFormat], [ColAllowNegativeValue], [ColIsGroupBy], [ColMask]) VALUES (32117, N'EN', N'VendDcLocationContact', N'ConEmailAddress2', N'Individual Email/System', N'Individual Email/System', NULL, NULL, N'', 9, 0, 0, 1, 1, NULL, 0, 0, NULL)
INSERT INTO [dbo].[SYSTM000ColumnsAlias] ([Id], [LangCode], [ColTableName], [ColColumnName], [ColAliasName], [ColCaption], [ColLookupId], [ColLookupCode], [ColDescription], [ColSortOrder], [ColIsReadOnly], [ColIsVisible], [ColIsDefault], [StatusId], [ColDisplayFormat], [ColAllowNegativeValue], [ColIsGroupBy], [ColMask]) VALUES (32118, N'EN', N'VendDcLocationContact', N'ConFirstName', N'First Name', N'', NULL, NULL, N'', 6, 0, 0, 1, 1, NULL, 0, 0, NULL)
INSERT INTO [dbo].[SYSTM000ColumnsAlias] ([Id], [LangCode], [ColTableName], [ColColumnName], [ColAliasName], [ColCaption], [ColLookupId], [ColLookupCode], [ColDescription], [ColSortOrder], [ColIsReadOnly], [ColIsVisible], [ColIsDefault], [StatusId], [ColDisplayFormat], [ColAllowNegativeValue], [ColIsGroupBy], [ColMask]) VALUES (32119, N'EN', N'VendDcLocationContact', N'ConFullName', N'Full Name', N'Full Name', NULL, NULL, N'', 34, 1, 0, 1, 1, NULL, 0, 0, NULL)
INSERT INTO [dbo].[SYSTM000ColumnsAlias] ([Id], [LangCode], [ColTableName], [ColColumnName], [ColAliasName], [ColCaption], [ColLookupId], [ColLookupCode], [ColDescription], [ColSortOrder], [ColIsReadOnly], [ColIsVisible], [ColIsDefault], [StatusId], [ColDisplayFormat], [ColAllowNegativeValue], [ColIsGroupBy], [ColMask]) VALUES (32120, N'EN', N'VendDcLocationContact', N'ConJobTitle', N'Job Title', N'Job Title', NULL, NULL, N'', 11, 0, 0, 1, 3, NULL, 0, 0, NULL)
INSERT INTO [dbo].[SYSTM000ColumnsAlias] ([Id], [LangCode], [ColTableName], [ColColumnName], [ColAliasName], [ColCaption], [ColLookupId], [ColLookupCode], [ColDescription], [ColSortOrder], [ColIsReadOnly], [ColIsVisible], [ColIsDefault], [StatusId], [ColDisplayFormat], [ColAllowNegativeValue], [ColIsGroupBy], [ColMask]) VALUES (32121, N'EN', N'VendDcLocationContact', N'ConLastName', N'Last Name', N'', NULL, NULL, N'', 5, 0, 0, 1, 1, NULL, 0, 0, NULL)
INSERT INTO [dbo].[SYSTM000ColumnsAlias] ([Id], [LangCode], [ColTableName], [ColColumnName], [ColAliasName], [ColCaption], [ColLookupId], [ColLookupCode], [ColDescription], [ColSortOrder], [ColIsReadOnly], [ColIsVisible], [ColIsDefault], [StatusId], [ColDisplayFormat], [ColAllowNegativeValue], [ColIsGroupBy], [ColMask]) VALUES (32122, N'EN', N'VendDcLocationContact', N'ConMiddleName', N'Middle Name', NULL, NULL, NULL, N'', 7, 0, 0, 1, 1, NULL, 0, 0, NULL)
INSERT INTO [dbo].[SYSTM000ColumnsAlias] ([Id], [LangCode], [ColTableName], [ColColumnName], [ColAliasName], [ColCaption], [ColLookupId], [ColLookupCode], [ColDescription], [ColSortOrder], [ColIsReadOnly], [ColIsVisible], [ColIsDefault], [StatusId], [ColDisplayFormat], [ColAllowNegativeValue], [ColIsGroupBy], [ColMask]) VALUES (32123, N'EN', N'VendDcLocationContact', N'ConTitleId', N'Title', N'', 6, N'ContactTitle', N'', 4, 0, 1, 1, 1, NULL, 0, 0, NULL)
INSERT INTO [dbo].[SYSTM000ColumnsAlias] ([Id], [LangCode], [ColTableName], [ColColumnName], [ColAliasName], [ColCaption], [ColLookupId], [ColLookupCode], [ColDescription], [ColSortOrder], [ColIsReadOnly], [ColIsVisible], [ColIsDefault], [StatusId], [ColDisplayFormat], [ColAllowNegativeValue], [ColIsGroupBy], [ColMask]) VALUES (32124, N'EN', N'VendDcLocationContact', N'ConTypeId', N'Type', N'', 7, N'ContactType', N'', 33, 0, 0, 1, 1, NULL, 0, 0, NULL)
INSERT INTO [dbo].[SYSTM000ColumnsAlias] ([Id], [LangCode], [ColTableName], [ColColumnName], [ColAliasName], [ColCaption], [ColLookupId], [ColLookupCode], [ColDescription], [ColSortOrder], [ColIsReadOnly], [ColIsVisible], [ColIsDefault], [StatusId], [ColDisplayFormat], [ColAllowNegativeValue], [ColIsGroupBy], [ColMask]) VALUES (32125, N'EN', N'VendDcLocationContact', N'BusinessAddress', N'Address', N'Business Address', NULL, NULL, NULL, 16, 1, 0, 0, NULL, NULL, 0, 0, NULL)
INSERT INTO [dbo].[SYSTM000ColumnsAlias] ([Id], [LangCode], [ColTableName], [ColColumnName], [ColAliasName], [ColCaption], [ColLookupId], [ColLookupCode], [ColDescription], [ColSortOrder], [ColIsReadOnly], [ColIsVisible], [ColIsDefault], [StatusId], [ColDisplayFormat], [ColAllowNegativeValue], [ColIsGroupBy], [ColMask]) VALUES (32126, N'EN', N'VendDcLocationContact', N'ConOrgId', N'Company', N'Company', NULL, NULL, NULL, 3, 1, 0, 1, 1, NULL, 0, 0, NULL)
SET IDENTITY_INSERT [dbo].[SYSTM000ColumnsAlias] OFF
ALTER TABLE [dbo].[SYSTM000ColumnsAlias]
    ADD CONSTRAINT [FK_SYSTM000ColumnsAlias_Status_SYSTM000Ref_Options] FOREIGN KEY ([StatusId]) REFERENCES [dbo].[SYSTM000Ref_Options] ([Id])
ALTER TABLE [dbo].[SYSTM000ColumnsAlias]
    ADD CONSTRAINT [FK_SYSTM000ColumnsAlias_SYSTM000Ref_Lookup] FOREIGN KEY ([ColLookupId]) REFERENCES [dbo].[SYSTM000Ref_Lookup] ([Id])
ALTER TABLE [dbo].[SYSTM000ColumnsAlias]
    ADD CONSTRAINT [FK_SYSTM000ColumnsAlias_SYSTM000Ref_Table] FOREIGN KEY ([ColTableName]) REFERENCES [dbo].[SYSTM000Ref_Table] ([SysRefName])
COMMIT TRANSACTION
