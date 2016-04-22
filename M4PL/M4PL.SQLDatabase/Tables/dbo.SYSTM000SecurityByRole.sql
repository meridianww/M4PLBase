CREATE TABLE [dbo].[SYSTM000SecurityByRole] (
    [SecurityLevelID]  INT           IDENTITY (1, 1) NOT NULL,
    [OrgRoleID]        INT           NULL,
    [SecLineOrder]     INT           NULL,
    [SecModule]        INT           NULL,
    [SecSecurityMenu]  INT           NULL,
    [SecSecurityData]  INT           NULL,
    [SecDateEntered]   DATETIME2 (7) NULL,
    [SecEnteredBy]     NVARCHAR (50) NULL,
    [SecDateChanged]   DATETIME2 (7) NULL,
    [SecDateChangedBy] NVARCHAR (50) NULL,
    CONSTRAINT [PK_SYSTM000SecurityByRole] PRIMARY KEY CLUSTERED ([SecurityLevelID] ASC),
    CONSTRAINT [FK_SYSTM000SecurityByRole_ORGAN010Ref_Roles] FOREIGN KEY ([OrgRoleID]) REFERENCES [dbo].[ORGAN010Ref_Roles] ([OrgRoleID]) ON UPDATE CASCADE
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Security Level Record ID', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'SYSTM000SecurityByRole', @level2type = N'COLUMN', @level2name = N'SecurityLevelID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Organization Role ID', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'SYSTM000SecurityByRole', @level2type = N'COLUMN', @level2name = N'OrgRoleID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Line Order (Brought In By Other File and May not be necessary)', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'SYSTM000SecurityByRole', @level2type = N'COLUMN', @level2name = N'SecLineOrder';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Module to Secure and Grant (See Query for Record Sourch to choose from Combo Box)', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'SYSTM000SecurityByRole', @level2type = N'COLUMN', @level2name = N'SecModule';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Menu Level of Menu', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'SYSTM000SecurityByRole', @level2type = N'COLUMN', @level2name = N'SecSecurityMenu';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Data Level:     0 No Rights, 1 Read Rights, 2 Edit Actuals, 3 Edit All, 4 All Add/Edit/Delete', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'SYSTM000SecurityByRole', @level2type = N'COLUMN', @level2name = N'SecSecurityData';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Date Role Was Entered', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'SYSTM000SecurityByRole', @level2type = N'COLUMN', @level2name = N'SecDateEntered';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Who Initiated the Record', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'SYSTM000SecurityByRole', @level2type = N'COLUMN', @level2name = N'SecEnteredBy';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Date Changed', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'SYSTM000SecurityByRole', @level2type = N'COLUMN', @level2name = N'SecDateChanged';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Who Changed the record', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'SYSTM000SecurityByRole', @level2type = N'COLUMN', @level2name = N'SecDateChangedBy';

