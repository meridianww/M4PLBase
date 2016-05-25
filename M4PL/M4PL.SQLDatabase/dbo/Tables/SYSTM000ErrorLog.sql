CREATE TABLE [dbo].[SYSTM000ErrorLog] (
    [ErrorId]              INT             IDENTITY (1, 1) NOT NULL,
    [ErrRelatedTo]         VARCHAR (100)   NULL,
    [ErrInnerException]    NVARCHAR (1024) NULL,
    [ErrMessage]           NVARCHAR (MAX)  NULL,
    [ErrSource]            NVARCHAR (64)   NULL,
    [ErrStackTrace]        NVARCHAR (MAX)  NULL,
    [ErrAdditionalMessage] NVARCHAR (4000) NULL,
    [ErrDateStamp]         DATETIME        NOT NULL
);

