CREATE TYPE [dbo].[uttReasonCode] AS TABLE(
[ReasonCode] [nvarchar](150) NULL,
[InternalCode] [nvarchar](50) NULL,
[PriorityCode] [nvarchar](50) NULL,
[Title] [nvarchar](150) NULL,
[Description] [nvarchar](MAX) NULL,
[Comment] [nvarchar](MAX) NULL,
[CategoryCode] [nvarchar](150) NULL,
[User01Code] [nvarchar](150) NULL,
[User02Code] [nvarchar](150) NULL,
[User03Code] [nvarchar](150) NULL,
[User04Code] [nvarchar](150) NULL,
[User05Code] [nvarchar](150) NULL
)
GO