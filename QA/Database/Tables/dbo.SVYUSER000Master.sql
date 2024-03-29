SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SVYUSER000Master](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](500) NULL,
	[Age] [int] NULL,
	[GenderId] [int] NULL,
	[EntityTypeId] [nvarchar](50) NULL,
	[EntityType] [nvarchar](50) NULL,
	[UserId] [bigint] NULL,
	[DateEntered] [datetime2](7) NOT NULL,
	[Feedback] [nvarchar](max) NULL,
	[SurveyId] [bigint] NULL,
	[LocationCode] [varchar](30) NULL,
	[DriverId] [varchar](50) NULL,
	[ContractNumber] [nvarchar](50) NULL,
	[CustName] [nvarchar](100) NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[SVYUSER000Master] ADD  CONSTRAINT [DF_SVYUSER000Master_DateEntered]  DEFAULT (getutcdate()) FOR [DateEntered]
GO
ALTER TABLE [dbo].[SVYUSER000Master]  WITH CHECK ADD  CONSTRAINT [FK_SVYUSER000Master_SYSTM000Ref_Options] FOREIGN KEY([GenderId])
REFERENCES [dbo].[SYSTM000Ref_Options] ([Id])
GO
ALTER TABLE [dbo].[SVYUSER000Master] CHECK CONSTRAINT [FK_SVYUSER000Master_SYSTM000Ref_Options]
GO
