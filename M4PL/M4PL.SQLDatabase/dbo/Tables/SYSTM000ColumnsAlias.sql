CREATE TABLE [dbo].[SYSTM000ColumnsAlias] (
    [ColTableName]  NVARCHAR (50) NOT NULL,
    [ColColumnName] NVARCHAR (50) NOT NULL,
    [ColAliasName]  NVARCHAR (50) NULL,
    PRIMARY KEY CLUSTERED ([ColTableName] ASC, [ColColumnName] ASC)
);

