CREATE TABLE [dbo].[ErrorLog] (
    [Id]                INT             IDENTITY (1, 1) NOT NULL,
    [RelatedTo]         VARCHAR (100)   NULL,
    [InnerException]    NVARCHAR (1024) NULL,
    [Message]           NVARCHAR (MAX)  NULL,
    [Source]            NVARCHAR (64)   NULL,
    [StackTrace]        NVARCHAR (MAX)  NULL,
    [AdditionalMessage] NVARCHAR (4000) NULL,
    [DateStamp]         DATETIME        NOT NULL,
    CONSTRAINT [PK_ErrorLog] PRIMARY KEY CLUSTERED ([Id] ASC)
);

