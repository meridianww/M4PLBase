SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[LocationProjectedCapacity](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[CustomerId] [bigint] NULL,
	[Year] [int] NULL,
	[Location] [nvarchar](150) NULL,
	[ProjectedCapacity] [int] NULL,
	[EnteredBy] [nvarchar](150) NULL,
	[EnteredDate] [datetime2](7) NULL,
	[StatusId] [int] NULL,
 CONSTRAINT [PK_LocationProjectedCapacity] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO


