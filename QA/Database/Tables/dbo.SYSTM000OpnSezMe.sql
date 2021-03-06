SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SYSTM000OpnSezMe](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[SysUserContactID] [bigint] NULL,
	[SysScreenName] [nvarchar](50) NULL,
	[SysPassword] [nvarchar](250) NOT NULL,
	[SysComments] [varbinary](max) NULL,
	[SysOrgId] [bigint] NULL,
	[SysOrgRefRoleId] [bigint] NULL,
	[IsSysAdmin] [bit] NOT NULL,
	[SysAttempts] [int] NOT NULL,
	[SysLoggedIn] [bit] NULL,
	[SysLoggedInCount] [int] NULL,
	[SysDateLastAttempt] [datetime2](7) NULL,
	[SysLoggedInStart] [datetime2](7) NULL,
	[SysLoggedInEnd] [datetime2](7) NULL,
	[StatusId] [int] NULL,
	[DateEntered] [datetime2](7) NOT NULL,
	[EnteredBy] [nvarchar](50) NULL,
	[DateChanged] [datetime2](7) NULL,
	[ChangedBy] [nvarchar](50) NULL,
 CONSTRAINT [PK__SYSTM000__13CC504168487DD7] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[SYSTM000OpnSezMe] ADD  CONSTRAINT [DF_SYSTM000OpnSezMe_IsSysAdmin]  DEFAULT ((0)) FOR [IsSysAdmin]
GO
ALTER TABLE [dbo].[SYSTM000OpnSezMe] ADD  CONSTRAINT [DF_SYSTM000OpnSezMe_SysAttempts]  DEFAULT ((0)) FOR [SysAttempts]
GO
ALTER TABLE [dbo].[SYSTM000OpnSezMe] ADD  CONSTRAINT [DF_SYSTM000OpnSezMe_SysLoggedIn]  DEFAULT ((0)) FOR [SysLoggedIn]
GO
ALTER TABLE [dbo].[SYSTM000OpnSezMe] ADD  CONSTRAINT [DF_SYSTM000OpnSezMe_DateEntered]  DEFAULT (getutcdate()) FOR [DateEntered]
GO
ALTER TABLE [dbo].[SYSTM000OpnSezMe]  WITH NOCHECK ADD  CONSTRAINT [FK_SYSTM000OpnSezMe_CONTC000Master] FOREIGN KEY([SysUserContactID])
REFERENCES [dbo].[CONTC000Master] ([Id])
GO
ALTER TABLE [dbo].[SYSTM000OpnSezMe] CHECK CONSTRAINT [FK_SYSTM000OpnSezMe_CONTC000Master]
GO
ALTER TABLE [dbo].[SYSTM000OpnSezMe]  WITH NOCHECK ADD  CONSTRAINT [FK_SYSTM000OpnSezMe_ORGAN000Master] FOREIGN KEY([SysOrgId])
REFERENCES [dbo].[ORGAN000Master] ([Id])
GO
ALTER TABLE [dbo].[SYSTM000OpnSezMe] CHECK CONSTRAINT [FK_SYSTM000OpnSezMe_ORGAN000Master]
GO
ALTER TABLE [dbo].[SYSTM000OpnSezMe]  WITH NOCHECK ADD  CONSTRAINT [FK_SYSTM000OpnSezMe_ORGAN010Ref_Roles] FOREIGN KEY([SysOrgRefRoleId])
REFERENCES [dbo].[ORGAN010Ref_Roles] ([Id])
GO
ALTER TABLE [dbo].[SYSTM000OpnSezMe] CHECK CONSTRAINT [FK_SYSTM000OpnSezMe_ORGAN010Ref_Roles]
GO
ALTER TABLE [dbo].[SYSTM000OpnSezMe]  WITH NOCHECK ADD  CONSTRAINT [FK_SYSTM000OpnSezMe_Status_SYSTM000Ref_Options] FOREIGN KEY([StatusId])
REFERENCES [dbo].[SYSTM000Ref_Options] ([Id])
GO
ALTER TABLE [dbo].[SYSTM000OpnSezMe] CHECK CONSTRAINT [FK_SYSTM000OpnSezMe_Status_SYSTM000Ref_Options]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Internal: System User ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000OpnSezMe', @level2type=N'COLUMN',@level2name=N'Id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Contact ID: No Duplicates in This Table' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000OpnSezMe', @level2type=N'COLUMN',@level2name=N'SysUserContactID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Screen Name or First and Last (Nickname)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000OpnSezMe', @level2type=N'COLUMN',@level2name=N'SysScreenName'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'20 Character Password All Characters Allowed' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000OpnSezMe', @level2type=N'COLUMN',@level2name=N'SysPassword'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Text' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000OpnSezMe', @level2type=N'COLUMN',@level2name=N'SysComments'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Login Attempts from Security Processor - Limit is 6; when 6 Happens account should be suspended' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000OpnSezMe', @level2type=N'COLUMN',@level2name=N'SysOrgId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Role Assigned to User' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000OpnSezMe', @level2type=N'COLUMN',@level2name=N'SysAttempts'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Is Logged In (Yes or No)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000OpnSezMe', @level2type=N'COLUMN',@level2name=N'SysLoggedIn'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Date Last Log In was Attempted' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000OpnSezMe', @level2type=N'COLUMN',@level2name=N'SysDateLastAttempt'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'When Logged In Last' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000OpnSezMe', @level2type=N'COLUMN',@level2name=N'SysLoggedInStart'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'When Logged Out Last' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000OpnSezMe', @level2type=N'COLUMN',@level2name=N'SysLoggedInEnd'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Active (Default), Archive, Suspended' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000OpnSezMe', @level2type=N'COLUMN',@level2name=N'StatusId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Date Account Was Entered' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000OpnSezMe', @level2type=N'COLUMN',@level2name=N'DateEntered'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Who Initiated The Record' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000OpnSezMe', @level2type=N'COLUMN',@level2name=N'EnteredBy'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Date Changed' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000OpnSezMe', @level2type=N'COLUMN',@level2name=N'DateChanged'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Who Changed The Record' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000OpnSezMe', @level2type=N'COLUMN',@level2name=N'ChangedBy'
GO
