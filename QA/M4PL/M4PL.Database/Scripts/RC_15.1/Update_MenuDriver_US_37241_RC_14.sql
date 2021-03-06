/*
This script was created by Visual Studio on 9/17/2018 at 12:28 PM.
Run this script on 172.30.255.28\MSSQLSERVER,1433.M4PL_3030_Test (akhil1) to make it the same as 172.30.255.28\MSSQLSERVER,1433.M4PL_TEST (akhil1).
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
ALTER TABLE [dbo].[SYSTM000MenuDriver] DROP CONSTRAINT [FK_SYSTM000MenuDriver_SYSTM000Ref_Table]
ALTER TABLE [dbo].[SYSTM000MenuDriver] DROP CONSTRAINT [FK_SYSTM000MenuDriver_Status_SYSTM000Ref_Options]
ALTER TABLE [dbo].[SYSTM000MenuDriver] DROP CONSTRAINT [FK_SYSTM000MenuDriver_Access_SYSTM000Ref_Options]
ALTER TABLE [dbo].[SYSTM000MenuDriver] DROP CONSTRAINT [FK_SYSTM000MenuDriver_Classification_SYSTM000Ref_Options]
ALTER TABLE [dbo].[SYSTM000MenuDriver] DROP CONSTRAINT [FK_SYSTM000MenuDriver_MainModule_SYSTM000Ref_Options]
ALTER TABLE [dbo].[SYSTM000MenuDriver] DROP CONSTRAINT [FK_SYSTM000MenuDriver_Option_SYSTM000Ref_Options]
ALTER TABLE [dbo].[SYSTM000MenuDriver] DROP CONSTRAINT [FK_SYSTM000MenuDriver_Program_SYSTM000Ref_Options]
SET IDENTITY_INSERT [dbo].[SYSTM000MenuDriver] ON
INSERT INTO [dbo].[SYSTM000MenuDriver] ([Id], [LangCode], [MnuModuleId], [MnuTableName], [MnuBreakDownStructure], [MnuTitle], [MnuDescription], [MnuTabOver], [MnuMenuItem], [MnuRibbon], [MnuRibbonTabName], [MnuIconVerySmall], [MnuIconSmall], [MnuIconMedium], [MnuIconLarge], [MnuExecuteProgram], [MnuClassificationId], [MnuProgramTypeId], [MnuOptionLevelId], [MnuAccessLevelId], [MnuHelpFile], [MnuHelpBookMark], [MnuHelpPageNumber], [StatusId], [DateEntered], [EnteredBy], [DateChanged], [ChangedBy]) VALUES (109, N'EN', NULL, NULL, N'01.08.01.05', N'Sync Outlook', NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, N'SyncOutlook', 53, 50, NULL, 17, NULL, NULL, NULL, 1, '20180914 18:31:45.0300000', NULL, NULL, NULL)
SET IDENTITY_INSERT [dbo].[SYSTM000MenuDriver] OFF
ALTER TABLE [dbo].[SYSTM000MenuDriver]
    ADD CONSTRAINT [FK_SYSTM000MenuDriver_SYSTM000Ref_Table] FOREIGN KEY ([MnuTableName]) REFERENCES [dbo].[SYSTM000Ref_Table] ([SysRefName])
ALTER TABLE [dbo].[SYSTM000MenuDriver]
    ADD CONSTRAINT [FK_SYSTM000MenuDriver_Status_SYSTM000Ref_Options] FOREIGN KEY ([StatusId]) REFERENCES [dbo].[SYSTM000Ref_Options] ([Id])
ALTER TABLE [dbo].[SYSTM000MenuDriver]
    ADD CONSTRAINT [FK_SYSTM000MenuDriver_Access_SYSTM000Ref_Options] FOREIGN KEY ([MnuAccessLevelId]) REFERENCES [dbo].[SYSTM000Ref_Options] ([Id])
ALTER TABLE [dbo].[SYSTM000MenuDriver]
    ADD CONSTRAINT [FK_SYSTM000MenuDriver_Classification_SYSTM000Ref_Options] FOREIGN KEY ([MnuClassificationId]) REFERENCES [dbo].[SYSTM000Ref_Options] ([Id])
ALTER TABLE [dbo].[SYSTM000MenuDriver]
    ADD CONSTRAINT [FK_SYSTM000MenuDriver_MainModule_SYSTM000Ref_Options] FOREIGN KEY ([MnuModuleId]) REFERENCES [dbo].[SYSTM000Ref_Options] ([Id])
ALTER TABLE [dbo].[SYSTM000MenuDriver]
    ADD CONSTRAINT [FK_SYSTM000MenuDriver_Option_SYSTM000Ref_Options] FOREIGN KEY ([MnuOptionLevelId]) REFERENCES [dbo].[SYSTM000Ref_Options] ([Id])
ALTER TABLE [dbo].[SYSTM000MenuDriver]
    ADD CONSTRAINT [FK_SYSTM000MenuDriver_Program_SYSTM000Ref_Options] FOREIGN KEY ([MnuProgramTypeId]) REFERENCES [dbo].[SYSTM000Ref_Options] ([Id])
COMMIT TRANSACTION
