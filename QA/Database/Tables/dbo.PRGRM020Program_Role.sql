SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PRGRM020Program_Role](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[OrgID] [bigint] NULL,
	[ProgramID] [bigint] NULL,
	[PrgRoleSortOrder] [int] NULL,
	[OrgRefRoleId] [bigint] NULL,
	[PrgRoleId] [bigint] NULL,
	[PrgRoleTitle] [nvarchar](50) NULL,
	[PrgRoleContactID] [bigint] NULL,
	[RoleTypeId] [int] NULL,
	[StatusId] [int] NULL,
	[PrxJobDefaultAnalyst] [bit] NULL,
	[PrxJobDefaultResponsible] [bit] NULL,
	[PrxJobGWDefaultAnalyst] [bit] NULL,
	[PrxJobGWDefaultResponsible] [bit] NULL,
	[PrgRoleDescription] [varbinary](max) NULL,
	[PrgComments] [varbinary](max) NULL,
	[DateEntered] [datetime2](7) NULL,
	[EnteredBy] [nvarchar](50) NULL,
	[DateChanged] [datetime2](7) NULL,
	[ChangedBy] [nvarchar](50) NULL,
 CONSTRAINT [PK_PRGRM020Program_Role] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[PRGRM020Program_Role] ADD  CONSTRAINT [DF_PRGRM020Program_Role_PrxJobDefaultAnalyst]  DEFAULT ((0)) FOR [PrxJobDefaultAnalyst]
GO
ALTER TABLE [dbo].[PRGRM020Program_Role] ADD  CONSTRAINT [DF_PRGRM020Program_Role_PrxJobDefaultResponsible]  DEFAULT ((0)) FOR [PrxJobDefaultResponsible]
GO
ALTER TABLE [dbo].[PRGRM020Program_Role] ADD  CONSTRAINT [DF_PRGRM020Program_Role_PrxJobGWDefaultAnalyst]  DEFAULT ((0)) FOR [PrxJobGWDefaultAnalyst]
GO
ALTER TABLE [dbo].[PRGRM020Program_Role] ADD  CONSTRAINT [DF_PRGRM020Program_Role_PrxJobGWDefaultResponsible]  DEFAULT ((0)) FOR [PrxJobGWDefaultResponsible]
GO
ALTER TABLE [dbo].[PRGRM020Program_Role] ADD  CONSTRAINT [DF_PRGRM020Program_Role_DateEntered]  DEFAULT (getutcdate()) FOR [DateEntered]
GO
ALTER TABLE [dbo].[PRGRM020Program_Role]  WITH NOCHECK ADD  CONSTRAINT [FK_PRGRM020Program_Role_CONTC000Master] FOREIGN KEY([PrgRoleContactID])
REFERENCES [dbo].[CONTC000Master] ([Id])
GO
ALTER TABLE [dbo].[PRGRM020Program_Role] CHECK CONSTRAINT [FK_PRGRM020Program_Role_CONTC000Master]
GO
ALTER TABLE [dbo].[PRGRM020Program_Role]  WITH NOCHECK ADD  CONSTRAINT [FK_PRGRM020Program_Role_ORGAN000Master] FOREIGN KEY([OrgID])
REFERENCES [dbo].[ORGAN000Master] ([Id])
GO
ALTER TABLE [dbo].[PRGRM020Program_Role] CHECK CONSTRAINT [FK_PRGRM020Program_Role_ORGAN000Master]
GO
ALTER TABLE [dbo].[PRGRM020Program_Role]  WITH NOCHECK ADD  CONSTRAINT [FK_PRGRM020Program_Role_OrgRefRole_ORGAN010Ref_Roles] FOREIGN KEY([OrgRefRoleId])
REFERENCES [dbo].[ORGAN010Ref_Roles] ([Id])
GO
ALTER TABLE [dbo].[PRGRM020Program_Role] CHECK CONSTRAINT [FK_PRGRM020Program_Role_OrgRefRole_ORGAN010Ref_Roles]
GO
ALTER TABLE [dbo].[PRGRM020Program_Role]  WITH NOCHECK ADD  CONSTRAINT [FK_PRGRM020Program_Role_PRGRM000Master] FOREIGN KEY([ProgramID])
REFERENCES [dbo].[PRGRM000Master] ([Id])
GO
ALTER TABLE [dbo].[PRGRM020Program_Role] CHECK CONSTRAINT [FK_PRGRM020Program_Role_PRGRM000Master]
GO
ALTER TABLE [dbo].[PRGRM020Program_Role]  WITH NOCHECK ADD  CONSTRAINT [FK_PRGRM020Program_Role_PRGRM020_Roles] FOREIGN KEY([PrgRoleId])
REFERENCES [dbo].[PRGRM020_Roles] ([Id])
GO
ALTER TABLE [dbo].[PRGRM020Program_Role] CHECK CONSTRAINT [FK_PRGRM020Program_Role_PRGRM020_Roles]
GO
ALTER TABLE [dbo].[PRGRM020Program_Role]  WITH NOCHECK ADD  CONSTRAINT [FK_PRGRM020Program_Role_RoleType_SYSTM000Ref_Options] FOREIGN KEY([RoleTypeId])
REFERENCES [dbo].[SYSTM000Ref_Options] ([Id])
GO
ALTER TABLE [dbo].[PRGRM020Program_Role] CHECK CONSTRAINT [FK_PRGRM020Program_Role_RoleType_SYSTM000Ref_Options]
GO
ALTER TABLE [dbo].[PRGRM020Program_Role]  WITH NOCHECK ADD  CONSTRAINT [FK_PRGRM020Program_Role_Status_SYSTM000Ref_Options] FOREIGN KEY([StatusId])
REFERENCES [dbo].[SYSTM000Ref_Options] ([Id])
GO
ALTER TABLE [dbo].[PRGRM020Program_Role] CHECK CONSTRAINT [FK_PRGRM020Program_Role_Status_SYSTM000Ref_Options]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Prorgam Role Identifiction' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRGRM020Program_Role', @level2type=N'COLUMN',@level2name=N'Id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Organization Identifiction' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRGRM020Program_Role', @level2type=N'COLUMN',@level2name=N'OrgID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Program Identifiction' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRGRM020Program_Role', @level2type=N'COLUMN',@level2name=N'ProgramID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Item Number for Sorting' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRGRM020Program_Role', @level2type=N'COLUMN',@level2name=N'PrgRoleSortOrder'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Organization Actrole Identification' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRGRM020Program_Role', @level2type=N'COLUMN',@level2name=N'OrgRefRoleId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Program Role Code Unique for programs' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRGRM020Program_Role', @level2type=N'COLUMN',@level2name=N'PrgRoleId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'title default to organization' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRGRM020Program_Role', @level2type=N'COLUMN',@level2name=N'PrgRoleTitle'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'actrole contactID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRGRM020Program_Role', @level2type=N'COLUMN',@level2name=N'PrgRoleContactID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'actrole type for sepecified rolecode' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRGRM020Program_Role', @level2type=N'COLUMN',@level2name=N'RoleTypeId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Descrirption' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRGRM020Program_Role', @level2type=N'COLUMN',@level2name=N'PrgRoleDescription'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Comments' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRGRM020Program_Role', @level2type=N'COLUMN',@level2name=N'PrgComments'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Date Attribute Was Entered' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRGRM020Program_Role', @level2type=N'COLUMN',@level2name=N'DateEntered'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Who Initiated the Record' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRGRM020Program_Role', @level2type=N'COLUMN',@level2name=N'EnteredBy'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Date Changed' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRGRM020Program_Role', @level2type=N'COLUMN',@level2name=N'DateChanged'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Who Changed the Record' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRGRM020Program_Role', @level2type=N'COLUMN',@level2name=N'ChangedBy'
GO
