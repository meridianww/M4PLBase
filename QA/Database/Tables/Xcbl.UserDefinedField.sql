SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [Xcbl].[UserDefinedField](
	[UserDefinedFieldId] [bigint] IDENTITY(1,1) NOT NULL,
	[SummaryHeaderId] [bigint] NOT NULL,
	[UDF01] [varchar](30) NULL,
	[UDF02] [varchar](30) NULL,
	[UDF03] [varchar](30) NULL,
	[UDF04] [varchar](30) NULL,
	[UDF05] [varchar](30) NULL,
	[UDF06] [varchar](30) NULL,
	[UDF07] [varchar](30) NULL,
	[UDF08] [varchar](30) NULL,
	[UDF09] [varchar](30) NULL,
	[UDF10] [varchar](30) NULL,
PRIMARY KEY CLUSTERED 
(
	[UserDefinedFieldId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [Xcbl].[UserDefinedField]  WITH CHECK ADD  CONSTRAINT [FK_UserDefinedField_SummaryHeaderId] FOREIGN KEY([SummaryHeaderId])
REFERENCES [Xcbl].[SummaryHeader] ([SummaryHeaderId])
GO

ALTER TABLE [Xcbl].[UserDefinedField] CHECK CONSTRAINT [FK_UserDefinedField_SummaryHeaderId]
GO

