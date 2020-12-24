SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SCR010InfoList](
	[InfoListID] [bigint] NOT NULL,
	[InfoListDesc] [nvarchar](max) NULL,
	[InfoListPhoto] [image] NULL,
 CONSTRAINT [PK__SCR010In__A014E73F3FF05625] PRIMARY KEY CLUSTERED 
(
	[InfoListID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
