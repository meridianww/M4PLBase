SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SYSTM000SecurityByRole](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[OrgRefRoleId] [bigint] NOT NULL,
	[SecLineOrder] [int] NULL,
	[SecMainModuleId] [int] NULL,
	[SecMenuOptionLevelId] [int] NULL,
	[SecMenuAccessLevelId] [int] NULL,
	[StatusId] [int] NULL,
	[DateEntered] [datetime2](7) NOT NULL,
	[EnteredBy] [nvarchar](50) NULL,
	[DateChanged] [datetime2](7) NULL,
	[ChangedBy] [nvarchar](50) NULL,
 CONSTRAINT [PK_SYSTM000SecurityByRole] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SYSTM000SecurityByRole] ADD  CONSTRAINT [DF_SYSTM000SecurityByRole_DateEntered]  DEFAULT (getutcdate()) FOR [DateEntered]
GO
ALTER TABLE [dbo].[SYSTM000SecurityByRole]  WITH NOCHECK ADD  CONSTRAINT [FK_SYSTM000SecurityByRole_MainModule_SYSTM000Ref_Options] FOREIGN KEY([SecMainModuleId])
REFERENCES [dbo].[SYSTM000Ref_Options] ([Id])
GO
ALTER TABLE [dbo].[SYSTM000SecurityByRole] CHECK CONSTRAINT [FK_SYSTM000SecurityByRole_MainModule_SYSTM000Ref_Options]
GO
ALTER TABLE [dbo].[SYSTM000SecurityByRole]  WITH NOCHECK ADD  CONSTRAINT [FK_SYSTM000SecurityByRole_MenuAccess_SYSTM000Ref_Options] FOREIGN KEY([SecMenuAccessLevelId])
REFERENCES [dbo].[SYSTM000Ref_Options] ([Id])
GO
ALTER TABLE [dbo].[SYSTM000SecurityByRole] CHECK CONSTRAINT [FK_SYSTM000SecurityByRole_MenuAccess_SYSTM000Ref_Options]
GO
ALTER TABLE [dbo].[SYSTM000SecurityByRole]  WITH NOCHECK ADD  CONSTRAINT [FK_SYSTM000SecurityByRole_MenuOption_SYSTM000Ref_Options] FOREIGN KEY([SecMenuOptionLevelId])
REFERENCES [dbo].[SYSTM000Ref_Options] ([Id])
GO
ALTER TABLE [dbo].[SYSTM000SecurityByRole] CHECK CONSTRAINT [FK_SYSTM000SecurityByRole_MenuOption_SYSTM000Ref_Options]
GO
ALTER TABLE [dbo].[SYSTM000SecurityByRole]  WITH NOCHECK ADD  CONSTRAINT [FK_SYSTM000SecurityByRole_ORGAN010Ref_Roles] FOREIGN KEY([OrgRefRoleId])
REFERENCES [dbo].[ORGAN010Ref_Roles] ([Id])
GO
ALTER TABLE [dbo].[SYSTM000SecurityByRole] CHECK CONSTRAINT [FK_SYSTM000SecurityByRole_ORGAN010Ref_Roles]
GO
ALTER TABLE [dbo].[SYSTM000SecurityByRole]  WITH NOCHECK ADD  CONSTRAINT [FK_SYSTM000SecurityByRole_StatusId_SYSTM000Ref_Options] FOREIGN KEY([StatusId])
REFERENCES [dbo].[SYSTM000Ref_Options] ([Id])
GO
ALTER TABLE [dbo].[SYSTM000SecurityByRole] CHECK CONSTRAINT [FK_SYSTM000SecurityByRole_StatusId_SYSTM000Ref_Options]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Security Level Record ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000SecurityByRole', @level2type=N'COLUMN',@level2name=N'Id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Organization Role Code' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000SecurityByRole', @level2type=N'COLUMN',@level2name=N'OrgRefRoleId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Line Order (Brought In By Other File and May not be necessary)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000SecurityByRole', @level2type=N'COLUMN',@level2name=N'SecLineOrder'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ModuleId to Secure and Grant (See Query for Record Sourch to choose from Combo Box)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000SecurityByRole', @level2type=N'COLUMN',@level2name=N'SecMainModuleId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Menu Level of Menu' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000SecurityByRole', @level2type=N'COLUMN',@level2name=N'SecMenuOptionLevelId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Data Level:     0 No Rights, 1 Read Rights, 2 Edit Actuals, 3 Edit All, 4 All Add/Edit/Delete' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000SecurityByRole', @level2type=N'COLUMN',@level2name=N'SecMenuAccessLevelId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Date Role Was Entered' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000SecurityByRole', @level2type=N'COLUMN',@level2name=N'DateEntered'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Who Initiated the Record' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000SecurityByRole', @level2type=N'COLUMN',@level2name=N'EnteredBy'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Date Changed' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000SecurityByRole', @level2type=N'COLUMN',@level2name=N'DateChanged'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Who Changed the record' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000SecurityByRole', @level2type=N'COLUMN',@level2name=N'ChangedBy'
GO
