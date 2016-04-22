CREATE TABLE [dbo].[ORGAN000Master] (
    [OrganizationID]   INT           IDENTITY (1, 1) NOT NULL,
    [OrgCode]          NVARCHAR (25) NULL,
    [OrgTitle]         NVARCHAR (50) NULL,
    [OrgGroup]         NVARCHAR (25) NULL,
    [OrgSortOrder]     INT           NULL,
    [OrgDesc]          NTEXT         NULL,
    [OrgStatus]        NVARCHAR (20) NULL,
    [OrgDateEntered]   DATETIME2 (7) NULL,
    [OrgEnteredBy]     NVARCHAR (50) NULL,
    [OrgDateChanged]   DATETIME2 (7) NULL,
    [OrgDateChangedBy] NVARCHAR (50) NULL,
    CONSTRAINT [PK_ORGAN000Master] PRIMARY KEY CLUSTERED ([OrganizationID] ASC)
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Unique Organization ID number Auto generated', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ORGAN000Master', @level2type = N'COLUMN', @level2name = N'OrganizationID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Organization Short Name', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ORGAN000Master', @level2type = N'COLUMN', @level2name = N'OrgCode';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Organization Title (Long Name)', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ORGAN000Master', @level2type = N'COLUMN', @level2name = N'OrgTitle';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Organization Group (Different from Org. Code to Delineate Program Types Like Brokerage and Home Delivery', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ORGAN000Master', @level2type = N'COLUMN', @level2name = N'OrgGroup';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'If the organization is to be ordered in lists', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ORGAN000Master', @level2type = N'COLUMN', @level2name = N'OrgSortOrder';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Long Description of the organization in prose', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ORGAN000Master', @level2type = N'COLUMN', @level2name = N'OrgDesc';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Status - Active, Archive, Delete', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ORGAN000Master', @level2type = N'COLUMN', @level2name = N'OrgStatus';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Date Organization Was Entered', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ORGAN000Master', @level2type = N'COLUMN', @level2name = N'OrgDateEntered';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Who Initiated the Record', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ORGAN000Master', @level2type = N'COLUMN', @level2name = N'OrgEnteredBy';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Date Changed', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ORGAN000Master', @level2type = N'COLUMN', @level2name = N'OrgDateChanged';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Who Changed the record', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ORGAN000Master', @level2type = N'COLUMN', @level2name = N'OrgDateChangedBy';

