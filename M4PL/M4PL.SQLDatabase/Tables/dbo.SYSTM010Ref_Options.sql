CREATE TABLE [dbo].[SYSTM010Ref_Options] (
    [SysOptionID]      INT           NOT NULL,
    [SysOptionName]    NVARCHAR (25) NULL,
    [SysTableName]     NVARCHAR (50) NULL,
    [SysColumnName]    NVARCHAR (50) NULL,
    [SysSortOrder]     INT           NULL,
    [SysDefault]       BIT           NULL,
    [SysDateEntered]   DATETIME2 (7) NULL,
    [SysEnteredBy]     NVARCHAR (50) NULL,
    [SysDateChanged]   DATETIME2 (7) NULL,
    [SysDateChangedBy] NVARCHAR (50) NULL,
    CONSTRAINT [PK_SYSTM010RefOptions] PRIMARY KEY CLUSTERED ([SysOptionID] ASC)
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The Text for the Option Value', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'SYSTM010Ref_Options', @level2type = N'COLUMN', @level2name = N'SysOptionName';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The Table that the reference option is used', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'SYSTM010Ref_Options', @level2type = N'COLUMN', @level2name = N'SysTableName';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The Column in the Table that the reference option is used', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'SYSTM010Ref_Options', @level2type = N'COLUMN', @level2name = N'SysColumnName';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'List number to keep in order if the alhpabetic sort is not correct', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'SYSTM010Ref_Options', @level2type = N'COLUMN', @level2name = N'SysSortOrder';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'If the Reference Option is a default value', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'SYSTM010Ref_Options', @level2type = N'COLUMN', @level2name = N'SysDefault';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Date Referenc Option Was Entered', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'SYSTM010Ref_Options', @level2type = N'COLUMN', @level2name = N'SysDateEntered';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Who Initiated the Record', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'SYSTM010Ref_Options', @level2type = N'COLUMN', @level2name = N'SysEnteredBy';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Date Changed', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'SYSTM010Ref_Options', @level2type = N'COLUMN', @level2name = N'SysDateChanged';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Who Changed the record', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'SYSTM010Ref_Options', @level2type = N'COLUMN', @level2name = N'SysDateChangedBy';

