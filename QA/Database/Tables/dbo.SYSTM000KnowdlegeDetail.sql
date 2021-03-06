SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SYSTM000KnowdlegeDetail](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[CategoryId] [int] NULL,
	[Name] [varchar](500) NULL,
	[DisplayName] [varchar](500) NULL,
	[URL] [varchar](5000) NULL,
	[DateEntered] [datetime] NULL,
	[EnteredBy] [varchar](150) NULL,
	[StatusId] [int] NULL,
 CONSTRAINT [PK_SYSTM000VideoDetail] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SYSTM000KnowdlegeDetail] ADD  CONSTRAINT [DF_SYSTM000VideoDetail_DateEntered]  DEFAULT (getdate()) FOR [DateEntered]
GO
ALTER TABLE [dbo].[SYSTM000KnowdlegeDetail]  WITH NOCHECK ADD  CONSTRAINT [FK_SYSTM000VideoDetail_CategoryId_SYSTM000VideoCategory] FOREIGN KEY([CategoryId])
REFERENCES [dbo].[SYSTM000KnowdlegeCategory] ([CategoryId])
GO
ALTER TABLE [dbo].[SYSTM000KnowdlegeDetail] CHECK CONSTRAINT [FK_SYSTM000VideoDetail_CategoryId_SYSTM000VideoCategory]
GO
