CREATE TYPE [dbo].[uttDocumentAttachment] AS TABLE(
	[FileName] [nvarchar](50) NULL,
	[Content] [varbinary](max) NULL,
	[EntityName] [nvarchar](100) NULL,
	[ItemNumber] [int] NULL,
	[Title] [nvarchar](50) NULL
)
GO
