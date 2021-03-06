SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PRGRM020_Roles](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[OrgID] [bigint] NULL,
	[ProgramID] [bigint] NULL,
	[PrgRoleCode] [nvarchar](25) NULL,
	[PrgRoleTitle] [nvarchar](50) NULL,
	[StatusId] [int] NULL,
	[DateEntered] [datetime2](7) NULL,
	[EnteredBy] [nvarchar](50) NULL,
	[DateChanged] [datetime2](7) NULL,
	[ChangedBy] [nvarchar](50) NULL,
 CONSTRAINT [PK_PRGRM020_Roles] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[PRGRM020_Roles] ADD  CONSTRAINT [DF_PRGRM020_Roles_DateEntered]  DEFAULT (getutcdate()) FOR [DateEntered]
GO
ALTER TABLE [dbo].[PRGRM020_Roles]  WITH NOCHECK ADD  CONSTRAINT [FK_PRGRM020_Roles_ORGAN000Master] FOREIGN KEY([OrgID])
REFERENCES [dbo].[ORGAN000Master] ([Id])
GO
ALTER TABLE [dbo].[PRGRM020_Roles] CHECK CONSTRAINT [FK_PRGRM020_Roles_ORGAN000Master]
GO
ALTER TABLE [dbo].[PRGRM020_Roles]  WITH NOCHECK ADD  CONSTRAINT [FK_PRGRM020_Roles_PRGRM000Master] FOREIGN KEY([ProgramID])
REFERENCES [dbo].[PRGRM000Master] ([Id])
GO
ALTER TABLE [dbo].[PRGRM020_Roles] CHECK CONSTRAINT [FK_PRGRM020_Roles_PRGRM000Master]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Prorgam Role Identifiction' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRGRM020_Roles', @level2type=N'COLUMN',@level2name=N'Id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Organization Identifiction' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRGRM020_Roles', @level2type=N'COLUMN',@level2name=N'OrgID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Program Identifiction' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRGRM020_Roles', @level2type=N'COLUMN',@level2name=N'ProgramID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Program Role Code Unique for programs' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRGRM020_Roles', @level2type=N'COLUMN',@level2name=N'PrgRoleCode'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'title default to organization' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRGRM020_Roles', @level2type=N'COLUMN',@level2name=N'PrgRoleTitle'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Date Attribute Was Entered' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRGRM020_Roles', @level2type=N'COLUMN',@level2name=N'DateEntered'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Who Initiated the Record' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRGRM020_Roles', @level2type=N'COLUMN',@level2name=N'EnteredBy'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Date Changed' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRGRM020_Roles', @level2type=N'COLUMN',@level2name=N'DateChanged'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Who Changed the Record' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRGRM020_Roles', @level2type=N'COLUMN',@level2name=N'ChangedBy'
GO
