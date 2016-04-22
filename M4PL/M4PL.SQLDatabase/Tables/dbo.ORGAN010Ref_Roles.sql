CREATE TABLE [dbo].[ORGAN010Ref_Roles] (
    [OrgRoleID]                  INT            IDENTITY (1, 1) NOT NULL,
    [OrgID]                      INT            NULL,
    [PrgID]                      INT            NULL,
    [PrjID]                      INT            NULL,
    [JobID]                      INT            NULL,
    [OrgRoleSortOrder]           INT            NULL,
    [OrgRoleCode]                NVARCHAR (25)  NULL,
    [OrgRoleTitle]               NVARCHAR (50)  NULL,
    [OrgRoleDesc]                NTEXT          NULL,
    [OrgRoleContactID]           INT            NULL,
    [OrgRoleType]                NVARCHAR (20)  NULL,
    [PrxContactDefault]          BIT            NULL,
    [PrxJobDefaultAnalyst]       BIT            NULL,
    [PrxJobGWDefaultAnalyst]     BIT            NULL,
    [PrxJobGWDefaultResponsible] BIT            NULL,
    [OrgComments]                NVARCHAR (MAX) NULL,
    [OrgDateEntered]             DATETIME2 (7)  NULL,
    [OrgEnteredBy]               NVARCHAR (50)  NULL,
    [OrgDateChanged]             DATETIME2 (7)  NULL,
    [OrgDateChangedBy]           NVARCHAR (50)  NULL,
    CONSTRAINT [PK_ORGAN010Ref_Roles] PRIMARY KEY CLUSTERED ([OrgRoleID] ASC),
    CONSTRAINT [FK_ORGAN010Ref_Roles_ORGAN000Master] FOREIGN KEY ([OrgID]) REFERENCES [dbo].[ORGAN000Master] ([OrganizationID]) ON UPDATE CASCADE
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Organization Primary Key for the Roles Table', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ORGAN010Ref_Roles', @level2type = N'COLUMN', @level2name = N'OrgRoleID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Which organization does this belong to (Relate to ORG Master File) (Break By Tab)', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ORGAN010Ref_Roles', @level2type = N'COLUMN', @level2name = N'OrgID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Program ID when Pointed to a Program (Relate to PRG Master File)  (Break By Tab)', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ORGAN010Ref_Roles', @level2type = N'COLUMN', @level2name = N'PrgID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Project ID when Pointed to a Project       (Relate to PRJ Master File)  (Break By Tab)', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ORGAN010Ref_Roles', @level2type = N'COLUMN', @level2name = N'PrjID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Job ID from Delivery ((Relate to JOB Master File))', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ORGAN010Ref_Roles', @level2type = N'COLUMN', @level2name = N'JobID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'List number to keep in order if the alhpabetic sort is not correct', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ORGAN010Ref_Roles', @level2type = N'COLUMN', @level2name = N'OrgRoleSortOrder';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Short Role Code', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ORGAN010Ref_Roles', @level2type = N'COLUMN', @level2name = N'OrgRoleCode';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Title of Role as a Prompt', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ORGAN010Ref_Roles', @level2type = N'COLUMN', @level2name = N'OrgRoleTitle';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'A written description for the role code', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ORGAN010Ref_Roles', @level2type = N'COLUMN', @level2name = N'OrgRoleDesc';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The contact the role is pointed to (Who?)', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ORGAN010Ref_Roles', @level2type = N'COLUMN', @level2name = N'OrgRoleContactID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Value List from Reference Table', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ORGAN010Ref_Roles', @level2type = N'COLUMN', @level2name = N'OrgRoleType';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Points to Contacts Database', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ORGAN010Ref_Roles', @level2type = N'COLUMN', @level2name = N'PrxContactDefault';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Job Level responsible analyst', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ORGAN010Ref_Roles', @level2type = N'COLUMN', @level2name = N'PrxJobDefaultAnalyst';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Boolean for Project or Program', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ORGAN010Ref_Roles', @level2type = N'COLUMN', @level2name = N'PrxJobGWDefaultAnalyst';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Boolean for Project or Program', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ORGAN010Ref_Roles', @level2type = N'COLUMN', @level2name = N'PrxJobGWDefaultResponsible';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Comments to Record', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ORGAN010Ref_Roles', @level2type = N'COLUMN', @level2name = N'OrgComments';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Date Role Was Entered', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ORGAN010Ref_Roles', @level2type = N'COLUMN', @level2name = N'OrgDateEntered';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Who Initiated the Record', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ORGAN010Ref_Roles', @level2type = N'COLUMN', @level2name = N'OrgEnteredBy';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Date Changed', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ORGAN010Ref_Roles', @level2type = N'COLUMN', @level2name = N'OrgDateChanged';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Who Changed the record', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ORGAN010Ref_Roles', @level2type = N'COLUMN', @level2name = N'OrgDateChangedBy';

