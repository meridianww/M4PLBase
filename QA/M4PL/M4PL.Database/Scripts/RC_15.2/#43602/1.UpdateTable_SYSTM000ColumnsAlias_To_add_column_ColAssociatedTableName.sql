GO
PRINT N'Dropping [dbo].[DF__SYSTM000C__ColIs__22751F6C]...';


GO
ALTER TABLE [dbo].[SYSTM000ColumnsAlias] DROP CONSTRAINT [DF__SYSTM000C__ColIs__22751F6C];


GO
PRINT N'Dropping [dbo].[DF__SYSTM000C__ColIs__236943A5]...';


GO
ALTER TABLE [dbo].[SYSTM000ColumnsAlias] DROP CONSTRAINT [DF__SYSTM000C__ColIs__236943A5];


GO
PRINT N'Dropping unnamed constraint on [dbo].[SYSTM000ColumnsAlias]...';


GO
ALTER TABLE [dbo].[SYSTM000ColumnsAlias] DROP CONSTRAINT [DF__SYSTM000C__ColIs__7E188EBC];


GO
PRINT N'Dropping [dbo].[FK_SYSTM000ColumnsAlias_Status_SYSTM000Ref_Options]...';


GO
ALTER TABLE [dbo].[SYSTM000ColumnsAlias] DROP CONSTRAINT [FK_SYSTM000ColumnsAlias_Status_SYSTM000Ref_Options];


GO
PRINT N'Dropping [dbo].[FK_SYSTM000ColumnsAlias_SYSTM000Ref_Lookup]...';


GO
ALTER TABLE [dbo].[SYSTM000ColumnsAlias] DROP CONSTRAINT [FK_SYSTM000ColumnsAlias_SYSTM000Ref_Lookup];


GO
PRINT N'Dropping [dbo].[FK_SYSTM000ColumnsAlias_SYSTM000Ref_Table]...';


GO
ALTER TABLE [dbo].[SYSTM000ColumnsAlias] DROP CONSTRAINT [FK_SYSTM000ColumnsAlias_SYSTM000Ref_Table];


GO
PRINT N'Starting rebuilding table [dbo].[SYSTM000ColumnsAlias]...';


GO
BEGIN TRANSACTION;

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

SET XACT_ABORT ON;

CREATE TABLE [dbo].[tmp_ms_xx_SYSTM000ColumnsAlias] (
    [Id]                     BIGINT         IDENTITY (1, 1) NOT NULL,
    [LangCode]               NVARCHAR (10)  NULL,
    [ColTableName]           NVARCHAR (100) NOT NULL,
    [ColAssociatedTableName] NVARCHAR (100) NULL,
    [ColColumnName]          NVARCHAR (50)  NOT NULL,
    [ColAliasName]           NVARCHAR (50)  NULL,
    [ColCaption]             NVARCHAR (50)  NULL,
    [ColLookupId]            INT            NULL,
    [ColLookupCode]          NVARCHAR (100) NULL,
    [ColDescription]         NVARCHAR (255) NULL,
    [ColSortOrder]           INT            NULL,
    [ColIsReadOnly]          BIT            NULL,
    [ColIsVisible]           BIT            CONSTRAINT [DF__SYSTM000C__ColIs__22751F6C] DEFAULT ((0)) NOT NULL,
    [ColIsDefault]           BIT            CONSTRAINT [DF__SYSTM000C__ColIs__236943A5] DEFAULT ((0)) NOT NULL,
    [StatusId]               INT            NULL,
    [ColDisplayFormat]       NVARCHAR (200) NULL,
    [ColAllowNegativeValue]  BIT            NULL,
    [ColIsGroupBy]           BIT            CONSTRAINT [DF__SYSTM000C__ColIs__7E188EBC] DEFAULT ((0)) NOT NULL,
    [ColMask]                VARCHAR (25)   NULL,
    CONSTRAINT [tmp_ms_xx_constraint_PK__tmp_ms_x__D73B5B5DF9D6D9951] PRIMARY KEY CLUSTERED ([Id] ASC)
);

IF EXISTS (SELECT TOP 1 1 
           FROM   [dbo].[SYSTM000ColumnsAlias])
    BEGIN
        SET IDENTITY_INSERT [dbo].[tmp_ms_xx_SYSTM000ColumnsAlias] ON;
        INSERT INTO [dbo].[tmp_ms_xx_SYSTM000ColumnsAlias] ([Id], [LangCode], [ColTableName], [ColColumnName], [ColAliasName], [ColCaption], [ColLookupId], [ColLookupCode], [ColDescription], [ColSortOrder], [ColIsReadOnly], [ColIsVisible], [ColIsDefault], [StatusId], [ColDisplayFormat], [ColAllowNegativeValue], [ColIsGroupBy], [ColMask])
        SELECT   [Id],
                 [LangCode],
                 [ColTableName],
                 [ColColumnName],
                 [ColAliasName],
                 [ColCaption],
                 [ColLookupId],
                 [ColLookupCode],
                 [ColDescription],
                 [ColSortOrder],
                 [ColIsReadOnly],
                 [ColIsVisible],
                 [ColIsDefault],
                 [StatusId],
                 [ColDisplayFormat],
                 [ColAllowNegativeValue],
                 [ColIsGroupBy],
                 [ColMask]
        FROM     [dbo].[SYSTM000ColumnsAlias]
        ORDER BY [Id] ASC;
        SET IDENTITY_INSERT [dbo].[tmp_ms_xx_SYSTM000ColumnsAlias] OFF;
    END

DROP TABLE [dbo].[SYSTM000ColumnsAlias];

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_SYSTM000ColumnsAlias]', N'SYSTM000ColumnsAlias';

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_constraint_PK__tmp_ms_x__D73B5B5DF9D6D9951]', N'PK__tmp_ms_x__D73B5B5DF9D6D995', N'OBJECT';

COMMIT TRANSACTION;

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;