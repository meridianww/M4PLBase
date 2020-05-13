/****** Object:  Table [dbo].[EntitySequenceReference]    Script Date: 2020-05-13 14:49:24 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[EntitySequenceReference](
	[Id] [int] IDENTITY (1,1) NOT NULL,
	[SequenceNumber] [bigint] NOT NULL,
	[Entity] [varchar](50) NOT NULL,
	[IsUsed] BIT 
 CONSTRAINT [PK_EntitySequenceReference] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


