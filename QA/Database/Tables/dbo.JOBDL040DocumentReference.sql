SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[JOBDL040DocumentReference](
	[JobID] [bigint] NULL,
	[JdrItemNumber] [int] NULL,
	[JdrCode] [nvarchar](20) NULL,
	[JdrTitle] [nvarchar](50) NULL,
	[DocTypeId] [int] NULL,
	[JdrDescription] [varbinary](max) NULL,
	[JdrAttachment] [int] NULL,
	[JdrDateStart] [datetime2](7) NULL,
	[JdrDateEnd] [datetime2](7) NULL,
	[JdrRenewal] [bit] NULL,
	[StatusId] [int] NULL,
	[EnteredBy] [nvarchar](50) NULL,
	[DateEntered] [datetime2](7) NULL,
	[ChangedBy] [nvarchar](50) NULL,
	[DateChanged] [datetime2](7) NULL,
	[Id] [bigint] NOT NULL,
 CONSTRAINT [PK_JOBDL040DocumentReference] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[JOBDL040DocumentReference] ADD  CONSTRAINT [DF_JOBDL040DocumentReference_JdrRenewal]  DEFAULT ((0)) FOR [JdrRenewal]
GO
ALTER TABLE [dbo].[JOBDL040DocumentReference] ADD  CONSTRAINT [DF_JOBDL040DocumentReference_DateEntered]  DEFAULT (getutcdate()) FOR [DateEntered]
GO
ALTER TABLE [dbo].[JOBDL040DocumentReference]  WITH NOCHECK ADD  CONSTRAINT [FK_JOBDL040DocumentReference_DocType_SYSTM000Ref_Options] FOREIGN KEY([DocTypeId])
REFERENCES [dbo].[SYSTM000Ref_Options] ([Id])
GO
ALTER TABLE [dbo].[JOBDL040DocumentReference] CHECK CONSTRAINT [FK_JOBDL040DocumentReference_DocType_SYSTM000Ref_Options]
GO
ALTER TABLE [dbo].[JOBDL040DocumentReference]  WITH CHECK ADD  CONSTRAINT [FK_JOBDL040DocumentReference_JOBDL000Master] FOREIGN KEY([JobID])
REFERENCES [dbo].[JOBDL000Master] ([Id])
GO
ALTER TABLE [dbo].[JOBDL040DocumentReference] CHECK CONSTRAINT [FK_JOBDL040DocumentReference_JOBDL000Master]
GO
ALTER TABLE [dbo].[JOBDL040DocumentReference]  WITH NOCHECK ADD  CONSTRAINT [FK_JOBDL040DocumentReference_Status_SYSTM000Ref_Options] FOREIGN KEY([StatusId])
REFERENCES [dbo].[SYSTM000Ref_Options] ([Id])
GO
ALTER TABLE [dbo].[JOBDL040DocumentReference] CHECK CONSTRAINT [FK_JOBDL040DocumentReference_Status_SYSTM000Ref_Options]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Job ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'JOBDL040DocumentReference', @level2type=N'COLUMN',@level2name=N'JobID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Item or Line Item Number for sorting other than Alpha Sort' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'JOBDL040DocumentReference', @level2type=N'COLUMN',@level2name=N'JdrItemNumber'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Document Code' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'JOBDL040DocumentReference', @level2type=N'COLUMN',@level2name=N'JdrCode'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Document Title' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'JOBDL040DocumentReference', @level2type=N'COLUMN',@level2name=N'JdrTitle'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Document, Brochure, Agreement, Contract, Proposal, Insurance, License, any official document needed for doing business with this customer' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'JOBDL040DocumentReference', @level2type=N'COLUMN',@level2name=N'DocTypeId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Overview or Prolog to Document' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'JOBDL040DocumentReference', @level2type=N'COLUMN',@level2name=N'JdrDescription'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Attachments Count Needed' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'JOBDL040DocumentReference', @level2type=N'COLUMN',@level2name=N'JdrAttachment'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Agreement Start' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'JOBDL040DocumentReference', @level2type=N'COLUMN',@level2name=N'JdrDateStart'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Agreement Finish' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'JOBDL040DocumentReference', @level2type=N'COLUMN',@level2name=N'JdrDateEnd'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Renew On Date' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'JOBDL040DocumentReference', @level2type=N'COLUMN',@level2name=N'JdrRenewal'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Entered On' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'JOBDL040DocumentReference', @level2type=N'COLUMN',@level2name=N'DateEntered'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Modified By' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'JOBDL040DocumentReference', @level2type=N'COLUMN',@level2name=N'ChangedBy'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Modified On' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'JOBDL040DocumentReference', @level2type=N'COLUMN',@level2name=N'DateChanged'
GO
