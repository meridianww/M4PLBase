CREATE TABLE [dbo].[SYSTM000ColumnOrdering] (
    [ColColumnOrderId] INT           IDENTITY (1, 1) NOT NULL,
    [ColTableName]     NVARCHAR (50) NULL,
    [ColPageName]      NVARCHAR (50) NULL,
    [ColUserId]        INT           NULL,
    [ColColumnName]    NVARCHAR (50) NULL,
    [ColSortOrder]     TINYINT       NULL,
    [ColIsDefault]     BIT           DEFAULT ((0)) NOT NULL,
    [ColDateEntered]   DATETIME2 (7) DEFAULT (getdate()) NULL,
    [ColEnteredBy]     NVARCHAR (50) NULL,
    [ColDateChanged]   DATETIME2 (7) NULL,
    [ColDateChangedBy] NVARCHAR (50) NULL,
    PRIMARY KEY CLUSTERED ([ColColumnOrderId] ASC)
);

