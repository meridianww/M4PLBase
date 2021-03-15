CREATE TYPE [dbo].[uttAppointmentCode] AS TABLE(
[ReasonCode] [nvarchar](150) NULL,
[InternalCode] [nvarchar](50) NULL,
[PriorityCode] [nvarchar](50) NULL,
[Title] [nvarchar](150) NULL,
[Description] [varbinary](MAX) NULL,
[Comment] [varbinary](MAX) NULL,
[CategoryCodeId] [int] NULL,
[User01Code] [nvarchar](150) NULL,
[User02Code] [nvarchar](150) NULL,
[User03Code] [nvarchar](150) NULL,
[User04Code] [nvarchar](150) NULL,
[User05Code] [nvarchar](150) NULL
)
GO