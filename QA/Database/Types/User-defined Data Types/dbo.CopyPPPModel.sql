CREATE TYPE [dbo].[CopyPPPModel] AS TABLE(
	[RecordId] [bigint] NULL,
	[SelectAll] [bit] NULL,
	[ConfigurationIds] [nvarchar](max) NULL,
	[ToPPPIds] [nvarchar](max) NULL,
	[ParentId] [bigint] NULL
)
GO
