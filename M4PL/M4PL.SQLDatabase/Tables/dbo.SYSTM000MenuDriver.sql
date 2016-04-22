CREATE TABLE [dbo].[SYSTM000MenuDriver] (
    [MenuID]                INT            IDENTITY (1, 1) NOT NULL,
    [MnuBreakDownStructure] NVARCHAR (20)  NULL,
    [MnuModule]             INT            NULL,
    [MnuTitle]              NVARCHAR (50)  NULL,
    [MnuDescription]        NTEXT          NULL,
    [MnuTabOver]            NVARCHAR (25)  NULL,
    [MnuIconVerySmall]      IMAGE          NULL,
    [MnuIconSmall]          IMAGE          NULL,
    [MnuIconMedium]         IMAGE          NULL,
    [MnuIconLarge]          IMAGE          NULL,
    [MnuRibbon]             BIT            NULL,
    [MnuRibbonTabName]      NVARCHAR (255) NULL,
    [MnuMenuItem]           BIT            NULL,
    [MnuExecuteProgram]     NVARCHAR (255) NULL,
    [MnuProgramType]        NVARCHAR (20)  NULL,
    [MnuClassification]     NVARCHAR (20)  NULL,
    [MnuOptionLevel]        INT            NULL,
    [MnuDateEntered]        DATETIME2 (7)  NULL,
    [MnyDateEnteredBy]      NVARCHAR (255) NULL,
    [MnuDateChanged]        DATETIME2 (7)  NULL,
    [MnuDateChangedBy]      NVARCHAR (50)  NULL,
    CONSTRAINT [PK_SYSTM000MenuDriver] PRIMARY KEY CLUSTERED ([MenuID] ASC)
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Record ID for Menu', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'SYSTM000MenuDriver', @level2type = N'COLUMN', @level2name = N'MenuID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Menu Driver Breakdown Structure (MB) (Hierarchical)', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'SYSTM000MenuDriver', @level2type = N'COLUMN', @level2name = N'MnuBreakDownStructure';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Module which should come from a drop down', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'SYSTM000MenuDriver', @level2type = N'COLUMN', @level2name = N'MnuModule';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Descriptive Title', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'SYSTM000MenuDriver', @level2type = N'COLUMN', @level2name = N'MnuTitle';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Description - Long Text Format', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'SYSTM000MenuDriver', @level2type = N'COLUMN', @level2name = N'MnuDescription';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Tab Over Description', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'SYSTM000MenuDriver', @level2type = N'COLUMN', @level2name = N'MnuTabOver';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'16 X 16', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'SYSTM000MenuDriver', @level2type = N'COLUMN', @level2name = N'MnuIconVerySmall';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'24 X 24', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'SYSTM000MenuDriver', @level2type = N'COLUMN', @level2name = N'MnuIconSmall';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'32 X 32', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'SYSTM000MenuDriver', @level2type = N'COLUMN', @level2name = N'MnuIconMedium';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'48 X 48', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'SYSTM000MenuDriver', @level2type = N'COLUMN', @level2name = N'MnuIconLarge';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Is On Ribbon (Could be Either Or)', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'SYSTM000MenuDriver', @level2type = N'COLUMN', @level2name = N'MnuRibbon';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Tab On Ribbon', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'SYSTM000MenuDriver', @level2type = N'COLUMN', @level2name = N'MnuRibbonTabName';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Menu Item', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'SYSTM000MenuDriver', @level2type = N'COLUMN', @level2name = N'MnuMenuItem';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'What is Being Executed?', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'SYSTM000MenuDriver', @level2type = N'COLUMN', @level2name = N'MnuExecuteProgram';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'What Type of Executable? - Executable;Batch;MS Office;Menus', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'SYSTM000MenuDriver', @level2type = N'COLUMN', @level2name = N'MnuProgramType';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'List: Screen, Report, Process, Dashboard', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'SYSTM000MenuDriver', @level2type = N'COLUMN', @level2name = N'MnuClassification';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'List - 0 No Rights; 1 Read; 2 Edit; 3 Add/Delete (All)', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'SYSTM000MenuDriver', @level2type = N'COLUMN', @level2name = N'MnuOptionLevel';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Date Entered for the First Time', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'SYSTM000MenuDriver', @level2type = N'COLUMN', @level2name = N'MnuDateEntered';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Entered By Whom?', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'SYSTM000MenuDriver', @level2type = N'COLUMN', @level2name = N'MnyDateEnteredBy';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Changed On Date', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'SYSTM000MenuDriver', @level2type = N'COLUMN', @level2name = N'MnuDateChanged';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Changed by Whom?', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'SYSTM000MenuDriver', @level2type = N'COLUMN', @level2name = N'MnuDateChangedBy';

