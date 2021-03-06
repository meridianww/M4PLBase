SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CUST000Master](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[CustERPID] [nvarchar](10) NULL,
	[CustOrgId] [bigint] NULL,
	[CustItemNumber] [int] NULL,
	[CustCode] [nvarchar](20) NULL,
	[CustTitle] [nvarchar](50) NULL,
	[CustDescription] [varbinary](max) NULL,
	[CustWorkAddressId] [bigint] NULL,
	[CustBusinessAddressId] [bigint] NULL,
	[CustCorporateAddressId] [bigint] NULL,
	[CustContacts] [int] NULL,
	[CustLogo] [image] NULL,
	[CustNotes] [varbinary](max) NULL,
	[CustTypeId] [int] NULL,
	[CustWebPage] [nvarchar](100) NULL,
	[StatusId] [int] NULL,
	[EnteredBy] [nvarchar](50) NULL,
	[DateEntered] [datetime2](7) NULL,
	[ChangedBy] [nvarchar](50) NULL,
	[DateChanged] [datetime2](7) NULL,
 CONSTRAINT [PK_CUST000Master] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[CUST000Master] ADD  CONSTRAINT [DF_CUST000Master_DateEntered]  DEFAULT (getutcdate()) FOR [DateEntered]
GO
ALTER TABLE [dbo].[CUST000Master]  WITH NOCHECK ADD  CONSTRAINT [FK_CUST000Master_BusiAddress_CONTC000Master] FOREIGN KEY([CustBusinessAddressId])
REFERENCES [dbo].[CONTC000Master] ([Id])
GO
ALTER TABLE [dbo].[CUST000Master] CHECK CONSTRAINT [FK_CUST000Master_BusiAddress_CONTC000Master]
GO
ALTER TABLE [dbo].[CUST000Master]  WITH NOCHECK ADD  CONSTRAINT [FK_CUST000Master_CopAddress_CONTC000Master] FOREIGN KEY([CustCorporateAddressId])
REFERENCES [dbo].[CONTC000Master] ([Id])
GO
ALTER TABLE [dbo].[CUST000Master] CHECK CONSTRAINT [FK_CUST000Master_CopAddress_CONTC000Master]
GO
ALTER TABLE [dbo].[CUST000Master]  WITH NOCHECK ADD  CONSTRAINT [FK_CUST000Master_ORGAN000Master] FOREIGN KEY([CustOrgId])
REFERENCES [dbo].[ORGAN000Master] ([Id])
GO
ALTER TABLE [dbo].[CUST000Master] CHECK CONSTRAINT [FK_CUST000Master_ORGAN000Master]
GO
ALTER TABLE [dbo].[CUST000Master]  WITH NOCHECK ADD  CONSTRAINT [FK_CUST000Master_Status_SYSTM000Ref_Options] FOREIGN KEY([StatusId])
REFERENCES [dbo].[SYSTM000Ref_Options] ([Id])
GO
ALTER TABLE [dbo].[CUST000Master] CHECK CONSTRAINT [FK_CUST000Master_Status_SYSTM000Ref_Options]
GO
ALTER TABLE [dbo].[CUST000Master]  WITH NOCHECK ADD  CONSTRAINT [FK_CUST000Master_Type_SYSTM000Ref_Options] FOREIGN KEY([CustTypeId])
REFERENCES [dbo].[SYSTM000Ref_Options] ([Id])
GO
ALTER TABLE [dbo].[CUST000Master] CHECK CONSTRAINT [FK_CUST000Master_Type_SYSTM000Ref_Options]
GO
ALTER TABLE [dbo].[CUST000Master]  WITH NOCHECK ADD  CONSTRAINT [FK_CUST000Master_WorkAddress_CONTC000Master] FOREIGN KEY([CustWorkAddressId])
REFERENCES [dbo].[CONTC000Master] ([Id])
GO
ALTER TABLE [dbo].[CUST000Master] CHECK CONSTRAINT [FK_CUST000Master_WorkAddress_CONTC000Master]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Customer Identifier' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUST000Master', @level2type=N'COLUMN',@level2name=N'Id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ERP Identifier Must Be Unique' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUST000Master', @level2type=N'COLUMN',@level2name=N'CustERPID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Organization ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUST000Master', @level2type=N'COLUMN',@level2name=N'CustOrgId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'List Number to Order Other Than by Alpha' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUST000Master', @level2type=N'COLUMN',@level2name=N'CustItemNumber'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Customer Code eg (AWC)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUST000Master', @level2type=N'COLUMN',@level2name=N'CustCode'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Long Title (American Wordmark Corporation)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUST000Master', @level2type=N'COLUMN',@level2name=N'CustTitle'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Longer Description of Customer' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUST000Master', @level2type=N'COLUMN',@level2name=N'CustDescription'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Comes From Contact' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUST000Master', @level2type=N'COLUMN',@level2name=N'CustWorkAddressId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Comes From Contact' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUST000Master', @level2type=N'COLUMN',@level2name=N'CustBusinessAddressId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Comes From Contact' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUST000Master', @level2type=N'COLUMN',@level2name=N'CustCorporateAddressId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Number of Contacts Listed With This Customer (May Not Be Needed)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUST000Master', @level2type=N'COLUMN',@level2name=N'CustContacts'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Logo of customer - Official' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUST000Master', @level2type=N'COLUMN',@level2name=N'CustLogo'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Notes' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUST000Master', @level2type=N'COLUMN',@level2name=N'CustNotes'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Customer Type Home Delivery or Brokerage or Other' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUST000Master', @level2type=N'COLUMN',@level2name=N'CustTypeId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Webpage Link' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUST000Master', @level2type=N'COLUMN',@level2name=N'CustWebPage'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Active, Suspended, Archive, Delete? (Combo Box)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUST000Master', @level2type=N'COLUMN',@level2name=N'StatusId'
GO
