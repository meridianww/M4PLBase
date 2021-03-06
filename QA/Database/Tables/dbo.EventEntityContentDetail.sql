SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EventEntityContentDetail](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[EventEntityRelationId] [int] NULL,
	[Subject] [varchar](50) NULL,
	[IsBodyHtml] [bit] NULL,
	[Body] [varchar](500) NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[EventEntityContentDetail]  WITH CHECK ADD FOREIGN KEY([EventEntityRelationId])
REFERENCES [dbo].[EventEntityRelation] ([ID])
GO
