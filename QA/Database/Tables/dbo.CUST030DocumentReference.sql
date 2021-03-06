SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CUST030DocumentReference](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[CdrOrgID] [bigint] NULL,
	[CdrCustomerID] [bigint] NULL,
	[CdrItemNumber] [int] NULL,
	[CdrCode] [nvarchar](20) NULL,
	[CdrTitle] [nvarchar](50) NULL,
	[DocRefTypeId] [int] NULL,
	[DocCategoryTypeId] [int] NULL,
	[CdrDescription] [varbinary](max) NULL,
	[CdrAttachment] [int] NULL,
	[CdrDateStart] [datetime2](7) NULL,
	[CdrDateEnd] [datetime2](7) NULL,
	[CdrRenewal] [bit] NULL,
	[StatusId] [int] NULL,
	[EnteredBy] [nvarchar](50) NULL,
	[DateEntered] [datetime2](7) NULL,
	[ChangedBy] [nvarchar](50) NULL,
	[DateChanged] [datetime2](7) NULL,
 CONSTRAINT [PK_CUST030DocumentReference] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[CUST030DocumentReference] ADD  CONSTRAINT [DF_CUST030DocumentReference_CdrRenewal]  DEFAULT ((0)) FOR [CdrRenewal]
GO
ALTER TABLE [dbo].[CUST030DocumentReference] ADD  CONSTRAINT [DF_CUST030DocumentReference_DateEntered]  DEFAULT (getutcdate()) FOR [DateEntered]
GO
ALTER TABLE [dbo].[CUST030DocumentReference]  WITH NOCHECK ADD  CONSTRAINT [FK_CUST030DocumentReference_CUST000Master] FOREIGN KEY([CdrCustomerID])
REFERENCES [dbo].[CUST000Master] ([Id])
GO
ALTER TABLE [dbo].[CUST030DocumentReference] CHECK CONSTRAINT [FK_CUST030DocumentReference_CUST000Master]
GO
ALTER TABLE [dbo].[CUST030DocumentReference]  WITH NOCHECK ADD  CONSTRAINT [FK_CUST030DocumentReference_DocCat_SYSTM000Ref_Options] FOREIGN KEY([DocCategoryTypeId])
REFERENCES [dbo].[SYSTM000Ref_Options] ([Id])
GO
ALTER TABLE [dbo].[CUST030DocumentReference] CHECK CONSTRAINT [FK_CUST030DocumentReference_DocCat_SYSTM000Ref_Options]
GO
ALTER TABLE [dbo].[CUST030DocumentReference]  WITH NOCHECK ADD  CONSTRAINT [FK_CUST030DocumentReference_DocRef_SYSTM000Ref_Options] FOREIGN KEY([DocRefTypeId])
REFERENCES [dbo].[SYSTM000Ref_Options] ([Id])
GO
ALTER TABLE [dbo].[CUST030DocumentReference] CHECK CONSTRAINT [FK_CUST030DocumentReference_DocRef_SYSTM000Ref_Options]
GO
ALTER TABLE [dbo].[CUST030DocumentReference]  WITH NOCHECK ADD  CONSTRAINT [FK_CUST030DocumentReference_ORGAN000Master] FOREIGN KEY([CdrOrgID])
REFERENCES [dbo].[ORGAN000Master] ([Id])
GO
ALTER TABLE [dbo].[CUST030DocumentReference] CHECK CONSTRAINT [FK_CUST030DocumentReference_ORGAN000Master]
GO
ALTER TABLE [dbo].[CUST030DocumentReference]  WITH NOCHECK ADD  CONSTRAINT [FK_CUST030DocumentReference_Status_SYSTM000Ref_Options] FOREIGN KEY([StatusId])
REFERENCES [dbo].[SYSTM000Ref_Options] ([Id])
GO
ALTER TABLE [dbo].[CUST030DocumentReference] CHECK CONSTRAINT [FK_CUST030DocumentReference_Status_SYSTM000Ref_Options]
GO
