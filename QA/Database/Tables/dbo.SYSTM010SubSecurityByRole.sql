SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SYSTM010SubSecurityByRole](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[SecByRoleId] [bigint] NULL,
	[RefTableName] [nvarchar](100) NULL,
	[SubsMenuOptionLevelId] [int] NULL,
	[SubsMenuAccessLevelId] [int] NULL,
	[StatusId] [int] NULL,
	[DateEntered] [datetime2](7) NULL,
	[EnteredBy] [nvarchar](50) NULL,
	[DateChanged] [datetime2](7) NULL,
	[ChangedBy] [nvarchar](50) NULL,
 CONSTRAINT [PK_SYSTM010SubSecurityByRole] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SYSTM010SubSecurityByRole] ADD  CONSTRAINT [DF_SYSTM010SubSecurityByRole_DateEntered]  DEFAULT (getutcdate()) FOR [DateEntered]
GO
ALTER TABLE [dbo].[SYSTM010SubSecurityByRole]  WITH NOCHECK ADD  CONSTRAINT [FK_SYSTM010SubSecurityByRole_Access_SYSTM000Ref_Options] FOREIGN KEY([SubsMenuAccessLevelId])
REFERENCES [dbo].[SYSTM000Ref_Options] ([Id])
GO
ALTER TABLE [dbo].[SYSTM010SubSecurityByRole] CHECK CONSTRAINT [FK_SYSTM010SubSecurityByRole_Access_SYSTM000Ref_Options]
GO
ALTER TABLE [dbo].[SYSTM010SubSecurityByRole]  WITH NOCHECK ADD  CONSTRAINT [FK_SYSTM010SubSecurityByRole_Option_SYSTM000Ref_Options] FOREIGN KEY([SubsMenuOptionLevelId])
REFERENCES [dbo].[SYSTM000Ref_Options] ([Id])
GO
ALTER TABLE [dbo].[SYSTM010SubSecurityByRole] CHECK CONSTRAINT [FK_SYSTM010SubSecurityByRole_Option_SYSTM000Ref_Options]
GO
ALTER TABLE [dbo].[SYSTM010SubSecurityByRole]  WITH NOCHECK ADD  CONSTRAINT [FK_SYSTM010SubSecurityByRole_Status_SYSTM000Ref_Options] FOREIGN KEY([StatusId])
REFERENCES [dbo].[SYSTM000Ref_Options] ([Id])
GO
ALTER TABLE [dbo].[SYSTM010SubSecurityByRole] CHECK CONSTRAINT [FK_SYSTM010SubSecurityByRole_Status_SYSTM000Ref_Options]
GO
ALTER TABLE [dbo].[SYSTM010SubSecurityByRole]  WITH NOCHECK ADD  CONSTRAINT [FK_SYSTM010SubSecurityByRole_SYSTM000Ref_Table] FOREIGN KEY([RefTableName])
REFERENCES [dbo].[SYSTM000Ref_Table] ([SysRefName])
GO
ALTER TABLE [dbo].[SYSTM010SubSecurityByRole] CHECK CONSTRAINT [FK_SYSTM010SubSecurityByRole_SYSTM000Ref_Table]
GO
ALTER TABLE [dbo].[SYSTM010SubSecurityByRole]  WITH NOCHECK ADD  CONSTRAINT [FK_SYSTM010SubSecurityByRole_SYSTM000SecurityByRole] FOREIGN KEY([SecByRoleId])
REFERENCES [dbo].[SYSTM000SecurityByRole] ([Id])
GO
ALTER TABLE [dbo].[SYSTM010SubSecurityByRole] CHECK CONSTRAINT [FK_SYSTM010SubSecurityByRole_SYSTM000SecurityByRole]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Identifier for record' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM010SubSecurityByRole', @level2type=N'COLUMN',@level2name=N'Id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Id from security by Role table like for Customer' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM010SubSecurityByRole', @level2type=N'COLUMN',@level2name=N'SecByRoleId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The sub module name like Program ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM010SubSecurityByRole', @level2type=N'COLUMN',@level2name=N'RefTableName'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'When created this record?' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM010SubSecurityByRole', @level2type=N'COLUMN',@level2name=N'DateEntered'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Who created ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM010SubSecurityByRole', @level2type=N'COLUMN',@level2name=N'EnteredBy'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Last changed date' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM010SubSecurityByRole', @level2type=N'COLUMN',@level2name=N'DateChanged'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Who changed' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM010SubSecurityByRole', @level2type=N'COLUMN',@level2name=N'ChangedBy'
GO
