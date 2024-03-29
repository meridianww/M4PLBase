SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ORGAN000Master](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[OrgCode] [nvarchar](25) NULL,
	[OrgTitle] [nvarchar](50) NULL,
	[OrgGroupId] [int] NULL,
	[OrgSortOrder] [int] NULL,
	[OrgDescription] [varbinary](max) NULL,
	[StatusId] [int] NULL,
	[DateEntered] [datetime2](7) NOT NULL,
	[EnteredBy] [nvarchar](50) NULL,
	[DateChanged] [datetime2](7) NULL,
	[ChangedBy] [nvarchar](50) NULL,
	[OrgContactId] [bigint] NULL,
	[OrgImage] [image] NULL,
	[OrgWorkAddressId] [bigint] NULL,
	[OrgBusinessAddressId] [bigint] NULL,
	[OrgCorporateAddressId] [bigint] NULL,
 CONSTRAINT [PK_ORGAN000Master] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[ORGAN000Master] ADD  CONSTRAINT [DF_ORGAN000Master_DateEntered]  DEFAULT (getutcdate()) FOR [DateEntered]
GO
ALTER TABLE [dbo].[ORGAN000Master]  WITH NOCHECK ADD  CONSTRAINT [FK_ORGAN000Master_BusiAddress_CONTC000Master] FOREIGN KEY([OrgBusinessAddressId])
REFERENCES [dbo].[CONTC000Master] ([Id])
GO
ALTER TABLE [dbo].[ORGAN000Master] CHECK CONSTRAINT [FK_ORGAN000Master_BusiAddress_CONTC000Master]
GO
ALTER TABLE [dbo].[ORGAN000Master]  WITH NOCHECK ADD  CONSTRAINT [FK_ORGAN000Master_CopAddress_CONTC000Master] FOREIGN KEY([OrgCorporateAddressId])
REFERENCES [dbo].[CONTC000Master] ([Id])
GO
ALTER TABLE [dbo].[ORGAN000Master] CHECK CONSTRAINT [FK_ORGAN000Master_CopAddress_CONTC000Master]
GO
ALTER TABLE [dbo].[ORGAN000Master]  WITH NOCHECK ADD  CONSTRAINT [FK_ORGAN000Master_OrgGroup_SYSTM000Ref_Options] FOREIGN KEY([OrgGroupId])
REFERENCES [dbo].[SYSTM000Ref_Options] ([Id])
GO
ALTER TABLE [dbo].[ORGAN000Master] CHECK CONSTRAINT [FK_ORGAN000Master_OrgGroup_SYSTM000Ref_Options]
GO
ALTER TABLE [dbo].[ORGAN000Master]  WITH NOCHECK ADD  CONSTRAINT [FK_ORGAN000Master_Status_SYSTM000Ref_Options] FOREIGN KEY([StatusId])
REFERENCES [dbo].[SYSTM000Ref_Options] ([Id])
GO
ALTER TABLE [dbo].[ORGAN000Master] CHECK CONSTRAINT [FK_ORGAN000Master_Status_SYSTM000Ref_Options]
GO
ALTER TABLE [dbo].[ORGAN000Master]  WITH NOCHECK ADD  CONSTRAINT [FK_ORGAN000Master_WorkAddress_CONTC000Master] FOREIGN KEY([OrgWorkAddressId])
REFERENCES [dbo].[CONTC000Master] ([Id])
GO
ALTER TABLE [dbo].[ORGAN000Master] CHECK CONSTRAINT [FK_ORGAN000Master_WorkAddress_CONTC000Master]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Unique Organization ID number Auto generated' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ORGAN000Master', @level2type=N'COLUMN',@level2name=N'Id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Organization Short Name' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ORGAN000Master', @level2type=N'COLUMN',@level2name=N'OrgCode'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Organization Title (Long Name)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ORGAN000Master', @level2type=N'COLUMN',@level2name=N'OrgTitle'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Organization Group (Different from Org. Code to Delineate Program Types Like Brokerage and Home Delivery' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ORGAN000Master', @level2type=N'COLUMN',@level2name=N'OrgGroupId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'If the organization is to be ordered in lists' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ORGAN000Master', @level2type=N'COLUMN',@level2name=N'OrgSortOrder'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Status - Active, Archive, Delete' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ORGAN000Master', @level2type=N'COLUMN',@level2name=N'StatusId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Date Organization Was Entered' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ORGAN000Master', @level2type=N'COLUMN',@level2name=N'DateEntered'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Who Initiated the Record' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ORGAN000Master', @level2type=N'COLUMN',@level2name=N'EnteredBy'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Date Changed' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ORGAN000Master', @level2type=N'COLUMN',@level2name=N'DateChanged'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Who Changed the record' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ORGAN000Master', @level2type=N'COLUMN',@level2name=N'ChangedBy'
GO
