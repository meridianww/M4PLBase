SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[NAV000OrderMapping](
	[OrderMappingId] [int] IDENTITY(1,1) NOT NULL,
	[M4PLColumn] [nvarchar](150) NULL,
	[NavColumn] [nvarchar](150) NULL,
	[TableName] [nvarchar](150) NULL,
	[EntityName] [nvarchar](150) NULL,
	[DefaultValue] [nvarchar](150) NULL
) ON [PRIMARY]

GO
