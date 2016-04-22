CREATE TABLE [dbo].[CONTC000Master] (
    [ContactID]           INT            IDENTITY (1, 1) NOT NULL,
    [ConERPID]            NVARCHAR (50)  NULL,
    [ConCompany]          NVARCHAR (100) NULL,
    [ConTitle]            NVARCHAR (5)   NULL,
    [ConLastName]         NVARCHAR (25)  NULL,
    [ConFirstName]        NVARCHAR (25)  NULL,
    [ConMiddleName]       NVARCHAR (25)  NULL,
    [ConEmailAddress]     NVARCHAR (100) NULL,
    [ConEmailAddress2]    NVARCHAR (100) NULL,
    [ConImage]            IMAGE          NULL,
    [ConJobTitle]         NVARCHAR (50)  NULL,
    [ConBusinessPhone]    NVARCHAR (25)  NULL,
    [ConBusinessPhoneExt] NVARCHAR (15)  NULL,
    [ConHomePhone]        NVARCHAR (25)  NULL,
    [ConMobilePhone]      NVARCHAR (25)  NULL,
    [ConFaxNumber]        NVARCHAR (25)  NULL,
    [ConAddress]          NVARCHAR (255) NULL,
    [ConCity]             NVARCHAR (25)  NULL,
    [ConStateProvince]    NVARCHAR (25)  NULL,
    [ConZIPPostal]        NVARCHAR (20)  NULL,
    [CountryRegion]       NVARCHAR (25)  NULL,
    [ConAttachments]      INT            NULL,
    [ConWebPage]          NTEXT          NULL,
    [ConNotes]            NTEXT          NULL,
    [ConStatus]           NVARCHAR (20)  NULL,
    [ConType]             NVARCHAR (20)  NULL,
    [ConFullName]         NVARCHAR (50)  NULL,
    [ConFileAs]           NVARCHAR (50)  NULL,
    [ConOutlookID]        NVARCHAR (50)  NULL,
    [ConDateEntered]      DATETIME2 (7)  NULL,
    [ConDateEnteredBy]    NVARCHAR (50)  NULL,
    [ConDateChanged]      DATETIME2 (7)  NULL,
    [ConDateChangedBy]    NVARCHAR (50)  NULL,
    CONSTRAINT [PK_CONTC000Master] PRIMARY KEY CLUSTERED ([ContactID] ASC)
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Contact ID that can be associated to Organization, Program, Job, and all job related tables where assigned.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CONTC000Master', @level2type = N'COLUMN', @level2name = N'ContactID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'ERP like Dynamics NAV Reference (CHAR Type)', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CONTC000Master', @level2type = N'COLUMN', @level2name = N'ConERPID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Company Name', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CONTC000Master', @level2type = N'COLUMN', @level2name = N'ConCompany';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Last Name', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CONTC000Master', @level2type = N'COLUMN', @level2name = N'ConLastName';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'First Name', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CONTC000Master', @level2type = N'COLUMN', @level2name = N'ConFirstName';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Middle Name or Initial', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CONTC000Master', @level2type = N'COLUMN', @level2name = N'ConMiddleName';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Email Address 1', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CONTC000Master', @level2type = N'COLUMN', @level2name = N'ConEmailAddress';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Email Address #2', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CONTC000Master', @level2type = N'COLUMN', @level2name = N'ConEmailAddress2';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Job Title', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CONTC000Master', @level2type = N'COLUMN', @level2name = N'ConJobTitle';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Business Phone', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CONTC000Master', @level2type = N'COLUMN', @level2name = N'ConBusinessPhone';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Extension', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CONTC000Master', @level2type = N'COLUMN', @level2name = N'ConBusinessPhoneExt';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Home Phone', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CONTC000Master', @level2type = N'COLUMN', @level2name = N'ConHomePhone';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Mobile Phone', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CONTC000Master', @level2type = N'COLUMN', @level2name = N'ConMobilePhone';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Fax Number', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CONTC000Master', @level2type = N'COLUMN', @level2name = N'ConFaxNumber';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Business Address', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CONTC000Master', @level2type = N'COLUMN', @level2name = N'ConAddress';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'City', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CONTC000Master', @level2type = N'COLUMN', @level2name = N'ConCity';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'State', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CONTC000Master', @level2type = N'COLUMN', @level2name = N'ConStateProvince';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Postal Code (Canadian and Mexican as well)', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CONTC000Master', @level2type = N'COLUMN', @level2name = N'ConZIPPostal';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Country', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CONTC000Master', @level2type = N'COLUMN', @level2name = N'CountryRegion';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Counts the number of attachments from the attachments list', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CONTC000Master', @level2type = N'COLUMN', @level2name = N'ConAttachments';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Web Page Address', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CONTC000Master', @level2type = N'COLUMN', @level2name = N'ConWebPage';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Contact Notes', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CONTC000Master', @level2type = N'COLUMN', @level2name = N'ConNotes';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Active, Delete, Archive', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CONTC000Master', @level2type = N'COLUMN', @level2name = N'ConStatus';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'May need a reference table Type=Customer, Vendor, CSR, Driver, and other (Temporary or Permanent)', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CONTC000Master', @level2type = N'COLUMN', @level2name = N'ConType';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Contact Full Name', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CONTC000Master', @level2type = N'COLUMN', @level2name = N'ConFullName';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Contact File as (Last Name, First Name, Middle Initial)', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CONTC000Master', @level2type = N'COLUMN', @level2name = N'ConFileAs';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Outlook ID to Update', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CONTC000Master', @level2type = N'COLUMN', @level2name = N'ConOutlookID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Date Entered', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CONTC000Master', @level2type = N'COLUMN', @level2name = N'ConDateEntered';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Entered By', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CONTC000Master', @level2type = N'COLUMN', @level2name = N'ConDateEnteredBy';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Changed Date', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CONTC000Master', @level2type = N'COLUMN', @level2name = N'ConDateChanged';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Changed By', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CONTC000Master', @level2type = N'COLUMN', @level2name = N'ConDateChangedBy';

