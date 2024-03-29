SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[VEND000Master](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[VendERPID] [nvarchar](10) NULL,
	[VendOrgID] [bigint] NULL,
	[VendItemNumber] [int] NULL,
	[VendCode] [nvarchar](20) NULL,
	[VendTitle] [nvarchar](50) NULL,
	[VendDescription] [varbinary](max) NULL,
	[VendWorkAddressId] [bigint] NULL,
	[VendBusinessAddressId] [bigint] NULL,
	[VendCorporateAddressId] [bigint] NULL,
	[VendContacts] [int] NULL,
	[VendLogo] [image] NULL,
	[VendNotes] [varbinary](max) NULL,
	[VendTypeId] [int] NULL,
	[VendWebPage] [nvarchar](100) NULL,
	[StatusId] [int] NULL,
	[EnteredBy] [nvarchar](50) NULL,
	[DateEntered] [datetime2](7) NULL,
	[ChangedBy] [nvarchar](50) NULL,
	[DateChanged] [datetime2](7) NULL,
 CONSTRAINT [PK_VEND000Master] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[VEND000Master] ADD  CONSTRAINT [DF_VEND000Master_VendEnteredOn]  DEFAULT (getutcdate()) FOR [DateEntered]
GO
ALTER TABLE [dbo].[VEND000Master]  WITH NOCHECK ADD  CONSTRAINT [FK_VEND000Master_BusiAddress_CONTC000Master] FOREIGN KEY([VendBusinessAddressId])
REFERENCES [dbo].[CONTC000Master] ([Id])
GO
ALTER TABLE [dbo].[VEND000Master] CHECK CONSTRAINT [FK_VEND000Master_BusiAddress_CONTC000Master]
GO
ALTER TABLE [dbo].[VEND000Master]  WITH NOCHECK ADD  CONSTRAINT [FK_VEND000Master_CopAddress_CONTC000Master] FOREIGN KEY([VendCorporateAddressId])
REFERENCES [dbo].[CONTC000Master] ([Id])
GO
ALTER TABLE [dbo].[VEND000Master] CHECK CONSTRAINT [FK_VEND000Master_CopAddress_CONTC000Master]
GO
ALTER TABLE [dbo].[VEND000Master]  WITH NOCHECK ADD  CONSTRAINT [FK_VEND000Master_ORGAN000Master] FOREIGN KEY([VendOrgID])
REFERENCES [dbo].[ORGAN000Master] ([Id])
GO
ALTER TABLE [dbo].[VEND000Master] CHECK CONSTRAINT [FK_VEND000Master_ORGAN000Master]
GO
ALTER TABLE [dbo].[VEND000Master]  WITH NOCHECK ADD  CONSTRAINT [FK_VEND000Master_Status_SYSTM000Ref_Options] FOREIGN KEY([StatusId])
REFERENCES [dbo].[SYSTM000Ref_Options] ([Id])
GO
ALTER TABLE [dbo].[VEND000Master] CHECK CONSTRAINT [FK_VEND000Master_Status_SYSTM000Ref_Options]
GO
ALTER TABLE [dbo].[VEND000Master]  WITH NOCHECK ADD  CONSTRAINT [FK_VEND000Master_Type_SYSTM000Ref_Options] FOREIGN KEY([VendTypeId])
REFERENCES [dbo].[SYSTM000Ref_Options] ([Id])
GO
ALTER TABLE [dbo].[VEND000Master] CHECK CONSTRAINT [FK_VEND000Master_Type_SYSTM000Ref_Options]
GO
ALTER TABLE [dbo].[VEND000Master]  WITH NOCHECK ADD  CONSTRAINT [FK_VEND000Master_WorkAddress_CONTC000Master] FOREIGN KEY([VendWorkAddressId])
REFERENCES [dbo].[CONTC000Master] ([Id])
GO
ALTER TABLE [dbo].[VEND000Master] CHECK CONSTRAINT [FK_VEND000Master_WorkAddress_CONTC000Master]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ERP Identifier Must Be Unique' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'VEND000Master', @level2type=N'COLUMN',@level2name=N'VendERPID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Organization ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'VEND000Master', @level2type=N'COLUMN',@level2name=N'VendOrgID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'List Number to Order Other Than by Alpha' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'VEND000Master', @level2type=N'COLUMN',@level2name=N'VendItemNumber'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Vendomer Code eg (AWC)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'VEND000Master', @level2type=N'COLUMN',@level2name=N'VendCode'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Long Title (American Wordmark Corporation)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'VEND000Master', @level2type=N'COLUMN',@level2name=N'VendTitle'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Longer Description of Vendomer' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'VEND000Master', @level2type=N'COLUMN',@level2name=N'VendDescription'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Comes From Contact' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'VEND000Master', @level2type=N'COLUMN',@level2name=N'VendWorkAddressId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Comes From Contact' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'VEND000Master', @level2type=N'COLUMN',@level2name=N'VendBusinessAddressId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Comes From Contact' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'VEND000Master', @level2type=N'COLUMN',@level2name=N'VendCorporateAddressId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Number of Contacts Listed With This Vendomer (May Not Be Needed)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'VEND000Master', @level2type=N'COLUMN',@level2name=N'VendContacts'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Logo of customer - Official' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'VEND000Master', @level2type=N'COLUMN',@level2name=N'VendLogo'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Notes' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'VEND000Master', @level2type=N'COLUMN',@level2name=N'VendNotes'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Vendomer Type Home Delivery or Brokerage or Other' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'VEND000Master', @level2type=N'COLUMN',@level2name=N'VendTypeId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Webpage Link' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'VEND000Master', @level2type=N'COLUMN',@level2name=N'VendWebPage'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Active, Suspended, Archive, Delete? (Combo Box)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'VEND000Master', @level2type=N'COLUMN',@level2name=N'StatusId'
GO
