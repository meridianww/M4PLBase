SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NAV000JobOrderItemMapping](
	[JobOrderItemMappingId] [bigint] IDENTITY(1,1) NOT NULL,
	[JobId] [bigint] NOT NULL,
	[EntityName] [nvarchar](150) NULL,
	[LineNumber] [INT] NULL,
	[DateEntered] [datetime2](7) NOT NULL,
	[EnteredBy] [nvarchar](50) NULL,
 CONSTRAINT [PK_NAV000JobOrderItemMapping] PRIMARY KEY CLUSTERED 
(
	[JobOrderItemMappingId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
ALTER TABLE [dbo].[NAV000JobOrderItemMapping] ADD  CONSTRAINT [DF_NAV000JobOrderItemMapping_DateEntered]  DEFAULT (getdate()) FOR [DateEntered]
GO
ALTER TABLE [dbo].[NAV000JobOrderItemMapping]  WITH CHECK ADD  CONSTRAINT [FK_NAV000JobOrderItemMapping_JOBDL000Master] FOREIGN KEY([JobId])
REFERENCES [dbo].[JOBDL000Master] ([Id])
GO
ALTER TABLE [dbo].[NAV000JobOrderItemMapping] CHECK CONSTRAINT [FK_NAV000JobOrderItemMapping_JOBDL000Master]
GO
