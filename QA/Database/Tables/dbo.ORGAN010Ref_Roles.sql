SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ORGAN010Ref_Roles](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[OrgID] [bigint] NULL,
	[OrgRoleSortOrder] [int] NULL,
	[OrgRoleCode] [nvarchar](25) NULL,
	[OrgRoleDefault] [bit] NULL,
	[OrgRoleTitle] [nvarchar](50) NULL,
	[OrgRoleContactID] [bigint] NULL,
	[RoleTypeId] [int] NULL,
	[StatusId] [int] NULL,
	[OrgRoleDescription] [varbinary](max) NULL,
	[OrgComments] [varbinary](max) NULL,
	[PrxJobDefaultAnalyst] [bit] NULL,
	[PrxJobDefaultResponsible] [bit] NULL,
	[PrxJobGWDefaultAnalyst] [bit] NULL,
	[PrxJobGWDefaultResponsible] [bit] NULL,
	[DateEntered] [datetime2](7) NOT NULL,
	[EnteredBy] [nvarchar](50) NULL,
	[DateChanged] [datetime2](7) NULL,
	[ChangedBy] [nvarchar](50) NULL,
 CONSTRAINT [PK_ORGAN010Ref_Roles] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[ORGAN010Ref_Roles] ADD  CONSTRAINT [DF_ORGAN010Ref_Roles_OrgRoleDefault]  DEFAULT ((0)) FOR [OrgRoleDefault]
GO
ALTER TABLE [dbo].[ORGAN010Ref_Roles] ADD  CONSTRAINT [DF_ORGAN010Ref_Roles_PrxJobDefaultAnalyst]  DEFAULT ((0)) FOR [PrxJobDefaultAnalyst]
GO
ALTER TABLE [dbo].[ORGAN010Ref_Roles] ADD  CONSTRAINT [DF_ORGAN010Ref_Roles_PrxJobDefaultResponsible]  DEFAULT ((0)) FOR [PrxJobDefaultResponsible]
GO
ALTER TABLE [dbo].[ORGAN010Ref_Roles] ADD  CONSTRAINT [DF_ORGAN010Ref_Roles_PrxJobGWDefaultAnalyst]  DEFAULT ((0)) FOR [PrxJobGWDefaultAnalyst]
GO
ALTER TABLE [dbo].[ORGAN010Ref_Roles] ADD  CONSTRAINT [DF_ORGAN010Ref_Roles_PrxJobGWDefaultResponsible]  DEFAULT ((0)) FOR [PrxJobGWDefaultResponsible]
GO
ALTER TABLE [dbo].[ORGAN010Ref_Roles] ADD  CONSTRAINT [DF_ORGAN010Ref_Roles_DateEntered]  DEFAULT (getutcdate()) FOR [DateEntered]
GO
ALTER TABLE [dbo].[ORGAN010Ref_Roles]  WITH NOCHECK ADD  CONSTRAINT [FK_ORGAN010Ref_Roles_CONTC000Master] FOREIGN KEY([OrgRoleContactID])
REFERENCES [dbo].[CONTC000Master] ([Id])
GO
ALTER TABLE [dbo].[ORGAN010Ref_Roles] CHECK CONSTRAINT [FK_ORGAN010Ref_Roles_CONTC000Master]
GO
ALTER TABLE [dbo].[ORGAN010Ref_Roles]  WITH NOCHECK ADD  CONSTRAINT [FK_ORGAN010Ref_Roles_ORGAN000Master] FOREIGN KEY([OrgID])
REFERENCES [dbo].[ORGAN000Master] ([Id])
GO
ALTER TABLE [dbo].[ORGAN010Ref_Roles] CHECK CONSTRAINT [FK_ORGAN010Ref_Roles_ORGAN000Master]
GO
ALTER TABLE [dbo].[ORGAN010Ref_Roles]  WITH NOCHECK ADD  CONSTRAINT [FK_ORGAN010Ref_Roles_RoleType_SYSTM000Ref_Options] FOREIGN KEY([RoleTypeId])
REFERENCES [dbo].[SYSTM000Ref_Options] ([Id])
GO
ALTER TABLE [dbo].[ORGAN010Ref_Roles] CHECK CONSTRAINT [FK_ORGAN010Ref_Roles_RoleType_SYSTM000Ref_Options]
GO
ALTER TABLE [dbo].[ORGAN010Ref_Roles]  WITH NOCHECK ADD  CONSTRAINT [FK_ORGAN010Ref_Roles_SYSTM000Ref_Options] FOREIGN KEY([StatusId])
REFERENCES [dbo].[SYSTM000Ref_Options] ([Id])
GO
ALTER TABLE [dbo].[ORGAN010Ref_Roles] CHECK CONSTRAINT [FK_ORGAN010Ref_Roles_SYSTM000Ref_Options]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Organization Primary Key for the Active Roles Table' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ORGAN010Ref_Roles', @level2type=N'COLUMN',@level2name=N'Id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Which organization does this belong to (Relate to ORG Master File) (Break By Tab)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ORGAN010Ref_Roles', @level2type=N'COLUMN',@level2name=N'OrgID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'List number to keep in order if the alhpabetic sort is not correct' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ORGAN010Ref_Roles', @level2type=N'COLUMN',@level2name=N'OrgRoleSortOrder'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Short Role Code' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ORGAN010Ref_Roles', @level2type=N'COLUMN',@level2name=N'OrgRoleCode'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'If Role should be default selection ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ORGAN010Ref_Roles', @level2type=N'COLUMN',@level2name=N'OrgRoleDefault'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Title of Role as a Prompt' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ORGAN010Ref_Roles', @level2type=N'COLUMN',@level2name=N'OrgRoleTitle'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The contact the role is pointed to (Who?)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ORGAN010Ref_Roles', @level2type=N'COLUMN',@level2name=N'OrgRoleContactID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Value List from Reference Table' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ORGAN010Ref_Roles', @level2type=N'COLUMN',@level2name=N'RoleTypeId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'A written description for the role code' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ORGAN010Ref_Roles', @level2type=N'COLUMN',@level2name=N'OrgRoleDescription'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Comments to Record' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ORGAN010Ref_Roles', @level2type=N'COLUMN',@level2name=N'OrgComments'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Job Level responsible analyst' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ORGAN010Ref_Roles', @level2type=N'COLUMN',@level2name=N'PrxJobDefaultAnalyst'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Boolean for Project or Program' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ORGAN010Ref_Roles', @level2type=N'COLUMN',@level2name=N'PrxJobGWDefaultAnalyst'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Boolean for Project or Program' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ORGAN010Ref_Roles', @level2type=N'COLUMN',@level2name=N'PrxJobGWDefaultResponsible'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Date Role Was Entered' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ORGAN010Ref_Roles', @level2type=N'COLUMN',@level2name=N'DateEntered'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Who Initiated the Record' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ORGAN010Ref_Roles', @level2type=N'COLUMN',@level2name=N'EnteredBy'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Date Changed' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ORGAN010Ref_Roles', @level2type=N'COLUMN',@level2name=N'DateChanged'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Who Changed the record' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ORGAN010Ref_Roles', @level2type=N'COLUMN',@level2name=N'ChangedBy'
GO
