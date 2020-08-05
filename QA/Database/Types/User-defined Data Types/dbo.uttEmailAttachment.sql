CREATE TYPE [dbo].[uttEmailAttachment] AS TABLE
(
[AttachmentName] [varchar] (100) NULL,
[Attachment] [varbinary] (max) NULL
)
GO