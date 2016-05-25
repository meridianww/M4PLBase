CREATE TABLE [dbo].[SYSTM000ColumnsAlias] (
    [ColAliasID]     BIGINT         NULL,
    [ColTableName]   NVARCHAR (50)  NOT NULL,
    [ColColumnName]  NVARCHAR (50)  NOT NULL,
    [ColAliasName]   NVARCHAR (50)  NULL,
    [ColCaption]     NVARCHAR (50)  NULL,
    [ColDescription] NVARCHAR (255) NULL,
    [ColCulture]     NVARCHAR (20)  NULL,
    [ColIsVisible]   BIT            CONSTRAINT [DF__SYSTM000C__ColIs__22751F6C] DEFAULT ((0)) NOT NULL,
    [ColIsDefault]   BIT            CONSTRAINT [DF__SYSTM000C__ColIs__236943A5] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK__tmp_ms_x__D73B5B5DF9D6D995] PRIMARY KEY CLUSTERED ([ColTableName] ASC, [ColColumnName] ASC)
);

