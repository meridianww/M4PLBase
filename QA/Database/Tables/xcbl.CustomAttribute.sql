SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [Xcbl].[CustomAttribute](
	[CustomAttributeId] [bigint] IDENTITY(1,1) NOT NULL,
	[SummaryHeaderId] [bigint] NOT NULL,
	[CustomAttribute01] [varchar](1) NULL,
	[CustomAttribute02] [varchar](1) NULL,
	[CustomAttribute03] [varchar](1) NULL,
	[CustomAttribute04] [varchar](1) NULL,
	[CustomAttribute05] [varchar](1) NULL,
	[CustomAttribute06] [varchar](1) NULL,
	[CustomAttribute07] [varchar](1) NULL,
	[CustomAttribute08] [varchar](1) NULL,
	[CustomAttribute09] [varchar](1) NULL,
	[CustomAttribute10] [varchar](1) NULL,
	[CustomAttribute11] [varchar](1) NULL,
	[CustomAttribute12] [varchar](1) NULL,
	[CustomAttribute13] [varchar](1) NULL,
	[CustomAttribute14] [varchar](1) NULL,
	[CustomAttribute15] [varchar](1) NULL,
	[CustomAttribute16] [varchar](1) NULL,
	[CustomAttribute17] [varchar](1) NULL,
	[CustomAttribute18] [varchar](1) NULL,
	[CustomAttribute19] [varchar](1) NULL,
	[CustomAttribute20] [varchar](1) NULL,
PRIMARY KEY CLUSTERED 
(
	[CustomAttributeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [Xcbl].[CustomAttribute]  WITH CHECK ADD  CONSTRAINT [FK_CustomAttribute_SummaryHeaderId] FOREIGN KEY([SummaryHeaderId])
REFERENCES [Xcbl].[SummaryHeader] ([SummaryHeaderId])
GO

ALTER TABLE [Xcbl].[CustomAttribute] CHECK CONSTRAINT [FK_CustomAttribute_SummaryHeaderId]
GO


