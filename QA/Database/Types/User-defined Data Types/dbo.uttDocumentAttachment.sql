CREATE TYPE [dbo].[uttDocumentAttachment] AS TABLE (
     [Id] [bigint]  NULL
	,[FileName] [nvarchar](50) NULL
	,[Content] [varbinary](max) NULL
	,[EntityName] [nvarchar](100) NULL
	,[ItemNumber] [INT] NULL
	,[Type] [int] NULL
	,[Title] [nvarchar](50) NULL
	,[StatusId] [int] NULL
	)