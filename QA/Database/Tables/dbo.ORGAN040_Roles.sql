SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ORGAN040_Roles](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[OrgID] [bigint] NULL,
	[OrgRoleCode] [nvarchar](25) NULL,
	[OrgRoleTitle] [nvarchar](50) NULL,
	[OrgRoleDefault] [bit] NULL,
	[StatusId] [int] NULL,
	[DateEntered] [datetime2](7) NOT NULL,
	[EnteredBy] [nvarchar](50) NULL,
	[DateChanged] [datetime2](7) NULL,
	[ChangedBy] [nvarchar](50) NULL,
 CONSTRAINT [PK_ORGAN040_Roles] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ORGAN040_Roles] ADD  CONSTRAINT [DF_ORGAN040_Roles_OrgRoleDefault]  DEFAULT ((0)) FOR [OrgRoleDefault]
GO
ALTER TABLE [dbo].[ORGAN040_Roles] ADD  CONSTRAINT [DF_ORGAN040_Roles_DateEntered]  DEFAULT (getutcdate()) FOR [DateEntered]
GO
ALTER TABLE [dbo].[ORGAN040_Roles]  WITH NOCHECK ADD  CONSTRAINT [FK_ORGAN040_Roles_ORGAN000Master] FOREIGN KEY([OrgID])
REFERENCES [dbo].[ORGAN000Master] ([Id])
GO
ALTER TABLE [dbo].[ORGAN040_Roles] CHECK CONSTRAINT [FK_ORGAN040_Roles_ORGAN000Master]
GO
ALTER TABLE [dbo].[ORGAN040_Roles]  WITH NOCHECK ADD  CONSTRAINT [FK_ORGAN040_Roles_Status_SYSTM000Ref_Options] FOREIGN KEY([StatusId])
REFERENCES [dbo].[SYSTM000Ref_Options] ([Id])
GO
ALTER TABLE [dbo].[ORGAN040_Roles] CHECK CONSTRAINT [FK_ORGAN040_Roles_Status_SYSTM000Ref_Options]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Organization Primary Key for the Active Roles Table' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ORGAN040_Roles', @level2type=N'COLUMN',@level2name=N'Id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Which organization does this belong to (Relate to ORG Master File) (Break By Tab)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ORGAN040_Roles', @level2type=N'COLUMN',@level2name=N'OrgID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Short Role Code' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ORGAN040_Roles', @level2type=N'COLUMN',@level2name=N'OrgRoleCode'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Title of Role as a Prompt' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ORGAN040_Roles', @level2type=N'COLUMN',@level2name=N'OrgRoleTitle'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'If Role should be default selection ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ORGAN040_Roles', @level2type=N'COLUMN',@level2name=N'OrgRoleDefault'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Status of the Role Active,Inactive,Archive' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ORGAN040_Roles', @level2type=N'COLUMN',@level2name=N'StatusId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Date Role Was Entered' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ORGAN040_Roles', @level2type=N'COLUMN',@level2name=N'DateEntered'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Who Initiated the Record' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ORGAN040_Roles', @level2type=N'COLUMN',@level2name=N'EnteredBy'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Date Changed' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ORGAN040_Roles', @level2type=N'COLUMN',@level2name=N'DateChanged'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Who Changed the record' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ORGAN040_Roles', @level2type=N'COLUMN',@level2name=N'ChangedBy'
GO
