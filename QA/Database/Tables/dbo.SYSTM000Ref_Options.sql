SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SYSTM000Ref_Options](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[SysLookupId] [int] NULL,
	[SysLookupCode] [nvarchar](100) NULL,
	[SysOptionName] [nvarchar](100) NULL,
	[SysSortOrder] [int] NULL,
	[SysDefault] [bit] NULL,
	[IsSysAdmin] [bit] NOT NULL,
	[StatusId] [int] NULL,
	[DateEntered] [datetime2](7) NULL,
	[EnteredBy] [nvarchar](50) NULL,
	[DateChanged] [datetime2](7) NULL,
	[ChangedBy] [nvarchar](50) NULL,
 CONSTRAINT [PK_SYSTM000RefOptions] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SYSTM000Ref_Options] ADD  CONSTRAINT [DF_SYSTM000Ref_Options_SysDefault]  DEFAULT ((0)) FOR [SysDefault]
GO
ALTER TABLE [dbo].[SYSTM000Ref_Options] ADD  CONSTRAINT [DF_SYSTM000Ref_Options_IsSysAdmin]  DEFAULT ((0)) FOR [IsSysAdmin]
GO
ALTER TABLE [dbo].[SYSTM000Ref_Options] ADD  CONSTRAINT [DF_SYSTM000Ref_Options_DateEntered]  DEFAULT (getutcdate()) FOR [DateEntered]
GO
ALTER TABLE [dbo].[SYSTM000Ref_Options]  WITH NOCHECK ADD  CONSTRAINT [FK_SYSTM000Ref_Options_Lookup_SYSTM000Ref_Lookup] FOREIGN KEY([SysLookupId])
REFERENCES [dbo].[SYSTM000Ref_Lookup] ([Id])
GO
ALTER TABLE [dbo].[SYSTM000Ref_Options] CHECK CONSTRAINT [FK_SYSTM000Ref_Options_Lookup_SYSTM000Ref_Lookup]
GO
ALTER TABLE [dbo].[SYSTM000Ref_Options]  WITH NOCHECK ADD  CONSTRAINT [FK_SYSTM000Ref_Options_StatusId_SYSTM000Ref_Options] FOREIGN KEY([StatusId])
REFERENCES [dbo].[SYSTM000Ref_Options] ([Id])
GO
ALTER TABLE [dbo].[SYSTM000Ref_Options] CHECK CONSTRAINT [FK_SYSTM000Ref_Options_StatusId_SYSTM000Ref_Options]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Column in the Table that the reference option is used' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000Ref_Options', @level2type=N'COLUMN',@level2name=N'SysLookupId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Text for the Option Value' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000Ref_Options', @level2type=N'COLUMN',@level2name=N'SysOptionName'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'To get sort order on UI' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000Ref_Options', @level2type=N'COLUMN',@level2name=N'SysSortOrder'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'To get this value is default visible or selected on UI' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000Ref_Options', @level2type=N'COLUMN',@level2name=N'SysDefault'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Date Referenc Option Was Entered' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000Ref_Options', @level2type=N'COLUMN',@level2name=N'DateEntered'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Who Initiated the Record' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000Ref_Options', @level2type=N'COLUMN',@level2name=N'EnteredBy'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Date Changed' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000Ref_Options', @level2type=N'COLUMN',@level2name=N'DateChanged'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Who Changed the record' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000Ref_Options', @level2type=N'COLUMN',@level2name=N'ChangedBy'
GO
