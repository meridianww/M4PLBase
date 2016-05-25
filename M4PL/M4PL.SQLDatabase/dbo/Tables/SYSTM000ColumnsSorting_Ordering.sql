CREATE TABLE [dbo].[SYSTM000ColumnsSorting&Ordering] (
    [ColColumnSortId]  INT            IDENTITY (1, 1) NOT NULL,
    [ColUserId]        INT            NULL,
    [ColTableName]     NVARCHAR (50)  NULL,
    [ColPageName]      NVARCHAR (50)  NULL,
    [ColSortColumn]    NVARCHAR (50)  NULL,
    [ColGridLayout]    NVARCHAR (MAX) NULL,
    [ColOrderingQuery] NVARCHAR (MAX) NULL,
    [ColDateEntered]   DATETIME2 (7)  CONSTRAINT [DF__tmp_ms_xx__ColDa__0A9D95DB] DEFAULT (getdate()) NULL,
    [ColEnteredBy]     NVARCHAR (50)  NULL,
    [ColDateChanged]   DATETIME2 (7)  NULL,
    [ColDateChangedBy] NVARCHAR (50)  NULL,
    CONSTRAINT [PK__tmp_ms_x__9FD529EF46D8C22E] PRIMARY KEY CLUSTERED ([ColColumnSortId] ASC)
);

