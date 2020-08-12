CREATE TABLE [dbo].[EmailAttachment]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[EmailDetailID] [int] NOT NULL,
[AttachmentName] [varchar] (100) NULL,
[Attachment] [varbinary] (max) NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
ALTER TABLE [dbo].[EmailAttachment] ADD 
CONSTRAINT [PK_EmailAttachment] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [IX_EmailAttachment_EmailDetailID] ON [dbo].[EmailAttachment] ([EmailDetailID]) ON [PRIMARY]
GO
