SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[VEND030DocumentReference](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[VdrOrgID] [bigint] NULL,
	[VdrVendorID] [bigint] NULL,
	[VdrItemNumber] [int] NULL,
	[VdrCode] [nvarchar](20) NULL,
	[VdrTitle] [nvarchar](50) NULL,
	[DocRefTypeId] [int] NULL,
	[DocCategoryTypeId] [int] NULL,
	[VdrDescription] [varbinary](max) NULL,
	[VdrAttachment] [int] NULL,
	[VdrDateStart] [datetime2](7) NULL,
	[VdrDateEnd] [datetime2](7) NULL,
	[VdrRenewal] [bit] NULL,
	[StatusId] [int] NULL,
	[EnteredBy] [nvarchar](50) NULL,
	[DateEntered] [datetime2](7) NULL,
	[ChangedBy] [nvarchar](50) NULL,
	[DateChanged] [datetime2](7) NULL,
 CONSTRAINT [PK_VEND030DocumentReference] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[VEND030DocumentReference] ADD  CONSTRAINT [DF_VEND030DocumentReference_VdrRenewal]  DEFAULT ((0)) FOR [VdrRenewal]
GO
ALTER TABLE [dbo].[VEND030DocumentReference] ADD  CONSTRAINT [DF_VEND030DocumentReference_VdrEnteredOn]  DEFAULT (getdate()) FOR [DateEntered]
GO
ALTER TABLE [dbo].[VEND030DocumentReference]  WITH NOCHECK ADD  CONSTRAINT [FK_VEND030DocumentReference_DocCat_SYSTM000Ref_Options] FOREIGN KEY([DocCategoryTypeId])
REFERENCES [dbo].[SYSTM000Ref_Options] ([Id])
GO
ALTER TABLE [dbo].[VEND030DocumentReference] CHECK CONSTRAINT [FK_VEND030DocumentReference_DocCat_SYSTM000Ref_Options]
GO
ALTER TABLE [dbo].[VEND030DocumentReference]  WITH NOCHECK ADD  CONSTRAINT [FK_VEND030DocumentReference_DocRef_SYSTM000Ref_Options] FOREIGN KEY([DocRefTypeId])
REFERENCES [dbo].[SYSTM000Ref_Options] ([Id])
GO
ALTER TABLE [dbo].[VEND030DocumentReference] CHECK CONSTRAINT [FK_VEND030DocumentReference_DocRef_SYSTM000Ref_Options]
GO
ALTER TABLE [dbo].[VEND030DocumentReference]  WITH NOCHECK ADD  CONSTRAINT [FK_VEND030DocumentReference_ORGAN000Master] FOREIGN KEY([VdrOrgID])
REFERENCES [dbo].[ORGAN000Master] ([Id])
GO
ALTER TABLE [dbo].[VEND030DocumentReference] CHECK CONSTRAINT [FK_VEND030DocumentReference_ORGAN000Master]
GO
ALTER TABLE [dbo].[VEND030DocumentReference]  WITH NOCHECK ADD  CONSTRAINT [FK_VEND030DocumentReference_Status_SYSTM000Ref_Options] FOREIGN KEY([StatusId])
REFERENCES [dbo].[SYSTM000Ref_Options] ([Id])
GO
ALTER TABLE [dbo].[VEND030DocumentReference] CHECK CONSTRAINT [FK_VEND030DocumentReference_Status_SYSTM000Ref_Options]
GO
ALTER TABLE [dbo].[VEND030DocumentReference]  WITH NOCHECK ADD  CONSTRAINT [FK_VEND030DocumentReference_VEND000Master] FOREIGN KEY([VdrVendorID])
REFERENCES [dbo].[VEND000Master] ([Id])
GO
ALTER TABLE [dbo].[VEND030DocumentReference] CHECK CONSTRAINT [FK_VEND030DocumentReference_VEND000Master]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Business Document ID (bdc)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'VEND030DocumentReference', @level2type=N'COLUMN',@level2name=N'Id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Organization ID (Auto Input Once Record is Created)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'VEND030DocumentReference', @level2type=N'COLUMN',@level2name=N'VdrOrgID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Customer ID Only Show Short Code like AWC' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'VEND030DocumentReference', @level2type=N'COLUMN',@level2name=N'VdrVendorID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Item or Line Item Number for sorting other than Alpha Sort' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'VEND030DocumentReference', @level2type=N'COLUMN',@level2name=N'VdrItemNumber'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Document Code' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'VEND030DocumentReference', @level2type=N'COLUMN',@level2name=N'VdrCode'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Document Title' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'VEND030DocumentReference', @level2type=N'COLUMN',@level2name=N'VdrTitle'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Document, Brochure, Agreement, Contract, Proposal, Insurance, License, any official document needed for doing business with this customer' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'VEND030DocumentReference', @level2type=N'COLUMN',@level2name=N'DocRefTypeId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Public, Private, Work' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'VEND030DocumentReference', @level2type=N'COLUMN',@level2name=N'DocCategoryTypeId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Overview or Prolog to Document' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'VEND030DocumentReference', @level2type=N'COLUMN',@level2name=N'VdrDescription'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Attachments Count Needed' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'VEND030DocumentReference', @level2type=N'COLUMN',@level2name=N'VdrAttachment'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Agreement Start' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'VEND030DocumentReference', @level2type=N'COLUMN',@level2name=N'VdrDateStart'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Agreement Finish' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'VEND030DocumentReference', @level2type=N'COLUMN',@level2name=N'VdrDateEnd'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Renew On Date' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'VEND030DocumentReference', @level2type=N'COLUMN',@level2name=N'VdrRenewal'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Entered On' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'VEND030DocumentReference', @level2type=N'COLUMN',@level2name=N'DateEntered'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Modified By' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'VEND030DocumentReference', @level2type=N'COLUMN',@level2name=N'ChangedBy'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Modified On' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'VEND030DocumentReference', @level2type=N'COLUMN',@level2name=N'DateChanged'
GO
