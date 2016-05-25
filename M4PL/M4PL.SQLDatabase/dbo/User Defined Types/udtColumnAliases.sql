CREATE TYPE [dbo].[udtColumnAliases] AS TABLE (
    [ColColumnName]  NVARCHAR (50)  NOT NULL,
    [ColAliasName]   NVARCHAR (50)  NULL,
    [ColCaption]     NVARCHAR (50)  NULL,
    [ColDescription] NVARCHAR (255) NULL,
    [ColIsVisible]   BIT            NOT NULL,
    [ColIsDefault]   BIT            NOT NULL);

