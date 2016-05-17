CREATE TABLE [dbo].[SYSTM000ColumnsSorting&Ordering] (
    [ColColumnSortId]  INT            IDENTITY (1, 1) NOT NULL,
    [ColTableName]     NVARCHAR (50)  NULL,
    [ColPageName]      NVARCHAR (50)  NULL,
    [ColSortColumn]    NVARCHAR (50)  NULL,
    [ColUserId]        INT            NULL,
    [ColOrderingQuery] NVARCHAR (MAX) NULL,
    [ColDateEntered]   DATETIME2 (7)  DEFAULT (getdate()) NULL,
    [ColEnteredBy]     NVARCHAR (50)  NULL,
    [ColDateChanged]   DATETIME2 (7)  NULL,
    [ColDateChangedBy] NVARCHAR (50)  NULL,
    PRIMARY KEY CLUSTERED ([ColColumnSortId] ASC)
);

