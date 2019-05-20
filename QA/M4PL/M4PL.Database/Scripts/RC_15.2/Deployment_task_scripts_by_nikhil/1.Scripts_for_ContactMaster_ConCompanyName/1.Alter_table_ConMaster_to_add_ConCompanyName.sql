

GO
PRINT N'Dropping [dbo].[DF_CONTC000Master_DateEntered]...';


GO
ALTER TABLE [dbo].[CONTC000Master] DROP CONSTRAINT [DF_CONTC000Master_DateEntered];


GO
PRINT N'Dropping [dbo].[FK_JOBDL020Gateways_CONTC000Master]...';


GO
ALTER TABLE [dbo].[JOBDL020Gateways] DROP CONSTRAINT [FK_JOBDL020Gateways_CONTC000Master];


GO
PRINT N'Dropping [dbo].[FK_JOBDL020Gateways_GwyGatewayAnalyst_CONTC000Master]...';


GO
ALTER TABLE [dbo].[JOBDL020Gateways] DROP CONSTRAINT [FK_JOBDL020Gateways_GwyGatewayAnalyst_CONTC000Master];


GO
PRINT N'Dropping [dbo].[FK_PRGRM051VendorLocations_CONTC000Master]...';


GO
ALTER TABLE [dbo].[PRGRM051VendorLocations] DROP CONSTRAINT [FK_PRGRM051VendorLocations_CONTC000Master];


GO
PRINT N'Dropping [dbo].[FK_VEND000Master_BusiAddress_CONTC000Master]...';


GO
ALTER TABLE [dbo].[VEND000Master] DROP CONSTRAINT [FK_VEND000Master_BusiAddress_CONTC000Master];


GO
PRINT N'Dropping [dbo].[FK_VEND000Master_CopAddress_CONTC000Master]...';


GO
ALTER TABLE [dbo].[VEND000Master] DROP CONSTRAINT [FK_VEND000Master_CopAddress_CONTC000Master];


GO
PRINT N'Dropping [dbo].[FK_VEND000Master_WorkAddress_CONTC000Master]...';


GO
ALTER TABLE [dbo].[VEND000Master] DROP CONSTRAINT [FK_VEND000Master_WorkAddress_CONTC000Master];


GO
PRINT N'Dropping [dbo].[FK_CUST000Master_WorkAddress_CONTC000Master]...';


GO
ALTER TABLE [dbo].[CUST000Master] DROP CONSTRAINT [FK_CUST000Master_WorkAddress_CONTC000Master];


GO
PRINT N'Dropping [dbo].[FK_CUST000Master_BusiAddress_CONTC000Master]...';


GO
ALTER TABLE [dbo].[CUST000Master] DROP CONSTRAINT [FK_CUST000Master_BusiAddress_CONTC000Master];


GO
PRINT N'Dropping [dbo].[FK_CUST000Master_CopAddress_CONTC000Master]...';


GO
ALTER TABLE [dbo].[CUST000Master] DROP CONSTRAINT [FK_CUST000Master_CopAddress_CONTC000Master];


GO
PRINT N'Dropping [dbo].[FK_CONTC000Master_Business_State_SYSTM000Ref_States]...';


GO
ALTER TABLE [dbo].[CONTC000Master] DROP CONSTRAINT [FK_CONTC000Master_Business_State_SYSTM000Ref_States];


GO
PRINT N'Dropping [dbo].[FK_CONTC000Master_Country_SYSTM000Ref_Options]...';


GO
ALTER TABLE [dbo].[CONTC000Master] DROP CONSTRAINT [FK_CONTC000Master_Country_SYSTM000Ref_Options];


GO
PRINT N'Dropping [dbo].[FK_CONTC000Master_Home_Country_SYSTM000Ref_Options]...';


GO
ALTER TABLE [dbo].[CONTC000Master] DROP CONSTRAINT [FK_CONTC000Master_Home_Country_SYSTM000Ref_Options];


GO
PRINT N'Dropping [dbo].[FK_CONTC000Master_Home_State_SYSTM000Ref_States]...';


GO
ALTER TABLE [dbo].[CONTC000Master] DROP CONSTRAINT [FK_CONTC000Master_Home_State_SYSTM000Ref_States];


GO
PRINT N'Dropping [dbo].[FK_CONTC000Master_Status_SYSTM000Ref_Options]...';


GO
ALTER TABLE [dbo].[CONTC000Master] DROP CONSTRAINT [FK_CONTC000Master_Status_SYSTM000Ref_Options];


GO
PRINT N'Dropping [dbo].[FK_CONTC000Master_ConOrgId_ORGAN000Master]...';


GO
ALTER TABLE [dbo].[CONTC000Master] DROP CONSTRAINT [FK_CONTC000Master_ConOrgId_ORGAN000Master];


GO
PRINT N'Dropping [dbo].[FK_CONTC000Master_Title_CONTC000Master]...';


GO
ALTER TABLE [dbo].[CONTC000Master] DROP CONSTRAINT [FK_CONTC000Master_Title_CONTC000Master];


GO
PRINT N'Dropping [dbo].[FK_CONTC000Master_Type_SYSTM000Ref_Options]...';


GO
ALTER TABLE [dbo].[CONTC000Master] DROP CONSTRAINT [FK_CONTC000Master_Type_SYSTM000Ref_Options];


GO
PRINT N'Dropping [dbo].[FK_CONTC000Master_ConUDF01_SYSTM000Ref_Options]...';


GO
ALTER TABLE [dbo].[CONTC000Master] DROP CONSTRAINT [FK_CONTC000Master_ConUDF01_SYSTM000Ref_Options];


GO
PRINT N'Dropping [dbo].[FK_ORGAN010Ref_Roles_CONTC000Master]...';


GO
ALTER TABLE [dbo].[ORGAN010Ref_Roles] DROP CONSTRAINT [FK_ORGAN010Ref_Roles_CONTC000Master];


GO
PRINT N'Dropping [dbo].[FK_PRGRM020Program_Role_CONTC000Master]...';


GO
ALTER TABLE [dbo].[PRGRM020Program_Role] DROP CONSTRAINT [FK_PRGRM020Program_Role_CONTC000Master];


GO
PRINT N'Dropping [dbo].[FK_JOBDL000Master_DeliveryAnalyst_CONTC000Master]...';


GO
ALTER TABLE [dbo].[JOBDL000Master] DROP CONSTRAINT [FK_JOBDL000Master_DeliveryAnalyst_CONTC000Master];


GO
PRINT N'Dropping [dbo].[FK_JOBDL000Master_DeliveryResponsible_CONTC000Master]...';


GO
ALTER TABLE [dbo].[JOBDL000Master] DROP CONSTRAINT [FK_JOBDL000Master_DeliveryResponsible_CONTC000Master];


GO
PRINT N'Dropping [dbo].[FK_JOBDL000Master_OriginResponsible_CONTC000Master]...';


GO
ALTER TABLE [dbo].[JOBDL000Master] DROP CONSTRAINT [FK_JOBDL000Master_OriginResponsible_CONTC000Master];


GO
PRINT N'Dropping [dbo].[FK_JOBDL000Master_JobDriver_CONTC000Master]...';


GO
ALTER TABLE [dbo].[JOBDL000Master] DROP CONSTRAINT [FK_JOBDL000Master_JobDriver_CONTC000Master];


GO
PRINT N'Dropping [dbo].[FK_ORGAN020Act_Roles_CONTC000Master]...';


GO
ALTER TABLE [dbo].[ORGAN020Act_Roles] DROP CONSTRAINT [FK_ORGAN020Act_Roles_CONTC000Master];


GO
PRINT N'Dropping [dbo].[FK_PRGRM010Ref_GatewayDefaults_Responsible_CONTC000Master]...';


GO
ALTER TABLE [dbo].[PRGRM010Ref_GatewayDefaults] DROP CONSTRAINT [FK_PRGRM010Ref_GatewayDefaults_Responsible_CONTC000Master];


GO
PRINT N'Dropping [dbo].[FK_PRGRM010Ref_GatewayDefaults_Analyst_CONTC000Master]...';


GO
ALTER TABLE [dbo].[PRGRM010Ref_GatewayDefaults] DROP CONSTRAINT [FK_PRGRM010Ref_GatewayDefaults_Analyst_CONTC000Master];


GO
PRINT N'Dropping [dbo].[FK_CONTC010Bridge_CONTC000Master]...';


GO
ALTER TABLE [dbo].[CONTC010Bridge] DROP CONSTRAINT [FK_CONTC010Bridge_CONTC000Master];


GO
PRINT N'Dropping [dbo].[FK_CUST040DCLocations_CONTC000Master]...';


GO
ALTER TABLE [dbo].[CUST040DCLocations] DROP CONSTRAINT [FK_CUST040DCLocations_CONTC000Master];


GO
PRINT N'Dropping [dbo].[FK_VEND040DCLocations_CONTC000Master]...';


GO
ALTER TABLE [dbo].[VEND040DCLocations] DROP CONSTRAINT [FK_VEND040DCLocations_CONTC000Master];


GO
PRINT N'Dropping [dbo].[FK_SYSTM000OpnSezMe_CONTC000Master]...';


GO
ALTER TABLE [dbo].[SYSTM000OpnSezMe] DROP CONSTRAINT [FK_SYSTM000OpnSezMe_CONTC000Master];


GO
PRINT N'Dropping <unnamed>...';


GO
EXECUTE sp_droprolemember @rolename = N'db_owner', @membername = N'akhil1';


GO
PRINT N'Dropping <unnamed>...';


GO
EXECUTE sp_droprolemember @rolename = N'db_owner', @membername = N'DREAMORBIT\janardana.behara';


GO
PRINT N'Dropping <unnamed>...';


GO
EXECUTE sp_droprolemember @rolename = N'db_owner', @membername = N'DREAMORBIT\dharmendra.verma';


GO
PRINT N'Starting rebuilding table [dbo].[CONTC000Master]...';


GO
BEGIN TRANSACTION;

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

SET XACT_ABORT ON;

CREATE TABLE [dbo].[tmp_ms_xx_CONTC000Master] (
    [Id]                   BIGINT         IDENTITY (1, 1) NOT NULL,
    [ConERPId]             NVARCHAR (50)  NULL,
    [ConOrgId]             BIGINT         NULL,
    [ConCompanyName]       NVARCHAR (100) NULL,
    [ConTitleId]           INT            NULL,
    [ConLastName]          NVARCHAR (25)  NULL,
    [ConFirstName]         NVARCHAR (25)  NULL,
    [ConMiddleName]        NVARCHAR (25)  NULL,
    [ConEmailAddress]      NVARCHAR (100) NULL,
    [ConEmailAddress2]     NVARCHAR (100) NULL,
    [ConImage]             IMAGE          NULL,
    [ConJobTitle]          NVARCHAR (50)  NULL,
    [ConBusinessPhone]     NVARCHAR (25)  NULL,
    [ConBusinessPhoneExt]  NVARCHAR (15)  NULL,
    [ConHomePhone]         NVARCHAR (25)  NULL,
    [ConMobilePhone]       NVARCHAR (25)  NULL,
    [ConFaxNumber]         NVARCHAR (25)  NULL,
    [ConBusinessAddress1]  NVARCHAR (255) NULL,
    [ConBusinessAddress2]  VARCHAR (150)  NULL,
    [ConBusinessCity]      NVARCHAR (25)  NULL,
    [ConBusinessStateId]   INT            NULL,
    [ConBusinessZipPostal] NVARCHAR (20)  NULL,
    [ConBusinessCountryId] INT            NULL,
    [ConHomeAddress1]      NVARCHAR (150) NULL,
    [ConHomeAddress2]      NVARCHAR (150) NULL,
    [ConHomeCity]          NVARCHAR (25)  NULL,
    [ConHomeStateId]       INT            NULL,
    [ConHomeZipPostal]     NVARCHAR (20)  NULL,
    [ConHomeCountryId]     INT            NULL,
    [ConAttachments]       INT            NULL,
    [ConWebPage]           NTEXT          NULL,
    [ConNotes]             NTEXT          NULL,
    [StatusId]             INT            NULL,
    [ConTypeId]            INT            NULL,
    [ConFullName]          AS             ((isnull([ConFirstName], '') + ' ') + isnull([ConLastName], '')),
    [ConFileAs]            AS             (([ConLastName] + ', ') + [ConFirstName]),
    [ConOutlookId]         NVARCHAR (50)  NULL,
    [ConUDF01]             INT            NULL,
    [ConUDF02]             NVARCHAR (20)  NULL,
    [ConUDF03]             NVARCHAR (20)  NULL,
    [ConUDF04]             NVARCHAR (20)  NULL,
    [ConUDF05]             NVARCHAR (20)  NULL,
    [DateEntered]          DATETIME2 (7)  CONSTRAINT [DF_CONTC000Master_DateEntered] DEFAULT (getutcdate()) NOT NULL,
    [EnteredBy]            NVARCHAR (50)  NULL,
    [DateChanged]          DATETIME2 (7)  NULL,
    [ChangedBy]            NVARCHAR (50)  NULL,
    CONSTRAINT [tmp_ms_xx_constraint_PK_CONTC000Master1] PRIMARY KEY CLUSTERED ([Id] ASC)
);

IF EXISTS (SELECT TOP 1 1 
           FROM   [dbo].[CONTC000Master])
    BEGIN
        SET IDENTITY_INSERT [dbo].[tmp_ms_xx_CONTC000Master] ON;
        INSERT INTO [dbo].[tmp_ms_xx_CONTC000Master] ([Id], [ConERPId], [ConTitleId], [ConLastName], [ConFirstName], [ConMiddleName], [ConEmailAddress], [ConEmailAddress2], [ConImage], [ConJobTitle], [ConBusinessPhone], [ConBusinessPhoneExt], [ConHomePhone], [ConMobilePhone], [ConFaxNumber], [ConBusinessAddress1], [ConBusinessAddress2], [ConBusinessCity], [ConBusinessStateId], [ConBusinessZipPostal], [ConBusinessCountryId], [ConHomeAddress1], [ConHomeAddress2], [ConHomeCity], [ConHomeStateId], [ConHomeZipPostal], [ConHomeCountryId], [ConAttachments], [ConWebPage], [ConNotes], [StatusId], [ConTypeId], [ConOutlookId], [ConUDF01], [ConUDF02], [ConUDF03], [ConUDF04], [ConUDF05], [DateEntered], [EnteredBy], [DateChanged], [ChangedBy], [ConOrgId])
        SELECT   [Id],
                 [ConERPId],
                 [ConTitleId],
                 [ConLastName],
                 [ConFirstName],
                 [ConMiddleName],
                 [ConEmailAddress],
                 [ConEmailAddress2],
                 [ConImage],
                 [ConJobTitle],
                 [ConBusinessPhone],
                 [ConBusinessPhoneExt],
                 [ConHomePhone],
                 [ConMobilePhone],
                 [ConFaxNumber],
                 [ConBusinessAddress1],
                 [ConBusinessAddress2],
                 [ConBusinessCity],
                 [ConBusinessStateId],
                 [ConBusinessZipPostal],
                 [ConBusinessCountryId],
                 [ConHomeAddress1],
                 [ConHomeAddress2],
                 [ConHomeCity],
                 [ConHomeStateId],
                 [ConHomeZipPostal],
                 [ConHomeCountryId],
                 [ConAttachments],
                 [ConWebPage],
                 [ConNotes],
                 [StatusId],
                 [ConTypeId],
                 [ConOutlookId],
                 [ConUDF01],
                 [ConUDF02],
                 [ConUDF03],
                 [ConUDF04],
                 [ConUDF05],
                 [DateEntered],
                 [EnteredBy],
                 [DateChanged],
                 [ChangedBy],
                 [ConOrgId]
        FROM     [dbo].[CONTC000Master]
        ORDER BY [Id] ASC;
        SET IDENTITY_INSERT [dbo].[tmp_ms_xx_CONTC000Master] OFF;
    END

DROP TABLE [dbo].[CONTC000Master];

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_CONTC000Master]', N'CONTC000Master';

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_constraint_PK_CONTC000Master1]', N'PK_CONTC000Master', N'OBJECT';

COMMIT TRANSACTION;

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;


GO
PRINT N'Creating [dbo].[FK_JOBDL020Gateways_CONTC000Master]...';


GO
ALTER TABLE [dbo].[JOBDL020Gateways] WITH NOCHECK
    ADD CONSTRAINT [FK_JOBDL020Gateways_CONTC000Master] FOREIGN KEY ([GwyGatewayResponsible]) REFERENCES [dbo].[CONTC000Master] ([Id]);


GO
PRINT N'Creating [dbo].[FK_JOBDL020Gateways_GwyGatewayAnalyst_CONTC000Master]...';


GO
ALTER TABLE [dbo].[JOBDL020Gateways] WITH NOCHECK
    ADD CONSTRAINT [FK_JOBDL020Gateways_GwyGatewayAnalyst_CONTC000Master] FOREIGN KEY ([GwyGatewayAnalyst]) REFERENCES [dbo].[CONTC000Master] ([Id]);


GO
PRINT N'Creating [dbo].[FK_PRGRM051VendorLocations_CONTC000Master]...';


GO
ALTER TABLE [dbo].[PRGRM051VendorLocations] WITH NOCHECK
    ADD CONSTRAINT [FK_PRGRM051VendorLocations_CONTC000Master] FOREIGN KEY ([PvlContactMSTRID]) REFERENCES [dbo].[CONTC000Master] ([Id]);


GO
PRINT N'Creating [dbo].[FK_VEND000Master_BusiAddress_CONTC000Master]...';


GO
ALTER TABLE [dbo].[VEND000Master] WITH NOCHECK
    ADD CONSTRAINT [FK_VEND000Master_BusiAddress_CONTC000Master] FOREIGN KEY ([VendBusinessAddressId]) REFERENCES [dbo].[CONTC000Master] ([Id]);


GO
PRINT N'Creating [dbo].[FK_VEND000Master_CopAddress_CONTC000Master]...';


GO
ALTER TABLE [dbo].[VEND000Master] WITH NOCHECK
    ADD CONSTRAINT [FK_VEND000Master_CopAddress_CONTC000Master] FOREIGN KEY ([VendCorporateAddressId]) REFERENCES [dbo].[CONTC000Master] ([Id]);


GO
PRINT N'Creating [dbo].[FK_VEND000Master_WorkAddress_CONTC000Master]...';


GO
ALTER TABLE [dbo].[VEND000Master] WITH NOCHECK
    ADD CONSTRAINT [FK_VEND000Master_WorkAddress_CONTC000Master] FOREIGN KEY ([VendWorkAddressId]) REFERENCES [dbo].[CONTC000Master] ([Id]);


GO
PRINT N'Creating [dbo].[FK_CUST000Master_WorkAddress_CONTC000Master]...';


GO
ALTER TABLE [dbo].[CUST000Master] WITH NOCHECK
    ADD CONSTRAINT [FK_CUST000Master_WorkAddress_CONTC000Master] FOREIGN KEY ([CustWorkAddressId]) REFERENCES [dbo].[CONTC000Master] ([Id]);


GO
PRINT N'Creating [dbo].[FK_CUST000Master_BusiAddress_CONTC000Master]...';


GO
ALTER TABLE [dbo].[CUST000Master] WITH NOCHECK
    ADD CONSTRAINT [FK_CUST000Master_BusiAddress_CONTC000Master] FOREIGN KEY ([CustBusinessAddressId]) REFERENCES [dbo].[CONTC000Master] ([Id]);


GO
PRINT N'Creating [dbo].[FK_CUST000Master_CopAddress_CONTC000Master]...';


GO
ALTER TABLE [dbo].[CUST000Master] WITH NOCHECK
    ADD CONSTRAINT [FK_CUST000Master_CopAddress_CONTC000Master] FOREIGN KEY ([CustCorporateAddressId]) REFERENCES [dbo].[CONTC000Master] ([Id]);


GO
PRINT N'Creating [dbo].[FK_ORGAN010Ref_Roles_CONTC000Master]...';


GO
ALTER TABLE [dbo].[ORGAN010Ref_Roles] WITH NOCHECK
    ADD CONSTRAINT [FK_ORGAN010Ref_Roles_CONTC000Master] FOREIGN KEY ([OrgRoleContactID]) REFERENCES [dbo].[CONTC000Master] ([Id]);


GO
PRINT N'Creating [dbo].[FK_PRGRM020Program_Role_CONTC000Master]...';


GO
ALTER TABLE [dbo].[PRGRM020Program_Role] WITH NOCHECK
    ADD CONSTRAINT [FK_PRGRM020Program_Role_CONTC000Master] FOREIGN KEY ([PrgRoleContactID]) REFERENCES [dbo].[CONTC000Master] ([Id]);


GO
PRINT N'Creating [dbo].[FK_JOBDL000Master_DeliveryAnalyst_CONTC000Master]...';


GO
ALTER TABLE [dbo].[JOBDL000Master] WITH NOCHECK
    ADD CONSTRAINT [FK_JOBDL000Master_DeliveryAnalyst_CONTC000Master] FOREIGN KEY ([JobDeliveryAnalystContactID]) REFERENCES [dbo].[CONTC000Master] ([Id]);


GO
PRINT N'Creating [dbo].[FK_JOBDL000Master_DeliveryResponsible_CONTC000Master]...';


GO
ALTER TABLE [dbo].[JOBDL000Master] WITH NOCHECK
    ADD CONSTRAINT [FK_JOBDL000Master_DeliveryResponsible_CONTC000Master] FOREIGN KEY ([JobDeliveryResponsibleContactID]) REFERENCES [dbo].[CONTC000Master] ([Id]);


GO
PRINT N'Creating [dbo].[FK_JOBDL000Master_OriginResponsible_CONTC000Master]...';


GO
ALTER TABLE [dbo].[JOBDL000Master] WITH NOCHECK
    ADD CONSTRAINT [FK_JOBDL000Master_OriginResponsible_CONTC000Master] FOREIGN KEY ([JobOriginResponsibleContactID]) REFERENCES [dbo].[CONTC000Master] ([Id]);


GO
PRINT N'Creating [dbo].[FK_JOBDL000Master_JobDriver_CONTC000Master]...';


GO
ALTER TABLE [dbo].[JOBDL000Master] WITH NOCHECK
    ADD CONSTRAINT [FK_JOBDL000Master_JobDriver_CONTC000Master] FOREIGN KEY ([JobDriverId]) REFERENCES [dbo].[CONTC000Master] ([Id]);


GO
PRINT N'Creating [dbo].[FK_ORGAN020Act_Roles_CONTC000Master]...';


GO
ALTER TABLE [dbo].[ORGAN020Act_Roles] WITH NOCHECK
    ADD CONSTRAINT [FK_ORGAN020Act_Roles_CONTC000Master] FOREIGN KEY ([OrgRoleContactID]) REFERENCES [dbo].[CONTC000Master] ([Id]);


GO
PRINT N'Creating [dbo].[FK_PRGRM010Ref_GatewayDefaults_Responsible_CONTC000Master]...';


GO
ALTER TABLE [dbo].[PRGRM010Ref_GatewayDefaults] WITH NOCHECK
    ADD CONSTRAINT [FK_PRGRM010Ref_GatewayDefaults_Responsible_CONTC000Master] FOREIGN KEY ([PgdGatewayResponsible]) REFERENCES [dbo].[CONTC000Master] ([Id]);


GO
PRINT N'Creating [dbo].[FK_PRGRM010Ref_GatewayDefaults_Analyst_CONTC000Master]...';


GO
ALTER TABLE [dbo].[PRGRM010Ref_GatewayDefaults] WITH NOCHECK
    ADD CONSTRAINT [FK_PRGRM010Ref_GatewayDefaults_Analyst_CONTC000Master] FOREIGN KEY ([PgdGatewayAnalyst]) REFERENCES [dbo].[CONTC000Master] ([Id]);


GO
PRINT N'Creating [dbo].[FK_CONTC010Bridge_CONTC000Master]...';


GO
ALTER TABLE [dbo].[CONTC010Bridge] WITH NOCHECK
    ADD CONSTRAINT [FK_CONTC010Bridge_CONTC000Master] FOREIGN KEY ([ContactMSTRID]) REFERENCES [dbo].[CONTC000Master] ([Id]);


GO
PRINT N'Creating [dbo].[FK_CUST040DCLocations_CONTC000Master]...';


GO
ALTER TABLE [dbo].[CUST040DCLocations] WITH NOCHECK
    ADD CONSTRAINT [FK_CUST040DCLocations_CONTC000Master] FOREIGN KEY ([CdcContactMSTRID]) REFERENCES [dbo].[CONTC000Master] ([Id]);


GO
PRINT N'Creating [dbo].[FK_VEND040DCLocations_CONTC000Master]...';


GO
ALTER TABLE [dbo].[VEND040DCLocations] WITH NOCHECK
    ADD CONSTRAINT [FK_VEND040DCLocations_CONTC000Master] FOREIGN KEY ([VdcContactMSTRID]) REFERENCES [dbo].[CONTC000Master] ([Id]);


GO
PRINT N'Creating [dbo].[FK_SYSTM000OpnSezMe_CONTC000Master]...';


GO
ALTER TABLE [dbo].[SYSTM000OpnSezMe] WITH NOCHECK
    ADD CONSTRAINT [FK_SYSTM000OpnSezMe_CONTC000Master] FOREIGN KEY ([SysUserContactID]) REFERENCES [dbo].[CONTC000Master] ([Id]);


GO
PRINT N'Creating [dbo].[CONTC000Master].[Id].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Contact Id that can be associated to Organization, Program, Job, and all job related tables where assigned.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CONTC000Master', @level2type = N'COLUMN', @level2name = N'Id';


GO
PRINT N'Creating [dbo].[CONTC000Master].[ConERPId].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'ERP like Dynamics NAV Reference (CHAR Type)', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CONTC000Master', @level2type = N'COLUMN', @level2name = N'ConERPId';


GO
PRINT N'Creating [dbo].[CONTC000Master].[ConLastName].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Last Name', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CONTC000Master', @level2type = N'COLUMN', @level2name = N'ConLastName';


GO
PRINT N'Creating [dbo].[CONTC000Master].[ConFirstName].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'First Name', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CONTC000Master', @level2type = N'COLUMN', @level2name = N'ConFirstName';


GO
PRINT N'Creating [dbo].[CONTC000Master].[ConMiddleName].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Middle Name or Initial', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CONTC000Master', @level2type = N'COLUMN', @level2name = N'ConMiddleName';


GO
PRINT N'Creating [dbo].[CONTC000Master].[ConEmailAddress].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Email Address 1', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CONTC000Master', @level2type = N'COLUMN', @level2name = N'ConEmailAddress';


GO
PRINT N'Creating [dbo].[CONTC000Master].[ConEmailAddress2].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Email Address #2', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CONTC000Master', @level2type = N'COLUMN', @level2name = N'ConEmailAddress2';


GO
PRINT N'Creating [dbo].[CONTC000Master].[ConJobTitle].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Job Title', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CONTC000Master', @level2type = N'COLUMN', @level2name = N'ConJobTitle';


GO
PRINT N'Creating [dbo].[CONTC000Master].[ConBusinessPhone].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Business Phone', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CONTC000Master', @level2type = N'COLUMN', @level2name = N'ConBusinessPhone';


GO
PRINT N'Creating [dbo].[CONTC000Master].[ConBusinessPhoneExt].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Extension', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CONTC000Master', @level2type = N'COLUMN', @level2name = N'ConBusinessPhoneExt';


GO
PRINT N'Creating [dbo].[CONTC000Master].[ConHomePhone].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Home Phone', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CONTC000Master', @level2type = N'COLUMN', @level2name = N'ConHomePhone';


GO
PRINT N'Creating [dbo].[CONTC000Master].[ConMobilePhone].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Mobile Phone', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CONTC000Master', @level2type = N'COLUMN', @level2name = N'ConMobilePhone';


GO
PRINT N'Creating [dbo].[CONTC000Master].[ConFaxNumber].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Fax Number', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CONTC000Master', @level2type = N'COLUMN', @level2name = N'ConFaxNumber';


GO
PRINT N'Creating [dbo].[CONTC000Master].[ConBusinessAddress1].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Business Address', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CONTC000Master', @level2type = N'COLUMN', @level2name = N'ConBusinessAddress1';


GO
PRINT N'Creating [dbo].[CONTC000Master].[ConBusinessCity].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'City', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CONTC000Master', @level2type = N'COLUMN', @level2name = N'ConBusinessCity';


GO
PRINT N'Creating [dbo].[CONTC000Master].[ConBusinessStateId].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'State', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CONTC000Master', @level2type = N'COLUMN', @level2name = N'ConBusinessStateId';


GO
PRINT N'Creating [dbo].[CONTC000Master].[ConBusinessZipPostal].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Postal Code (Canadian and Mexican as well)', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CONTC000Master', @level2type = N'COLUMN', @level2name = N'ConBusinessZipPostal';


GO
PRINT N'Creating [dbo].[CONTC000Master].[ConBusinessCountryId].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Country', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CONTC000Master', @level2type = N'COLUMN', @level2name = N'ConBusinessCountryId';


GO
PRINT N'Creating [dbo].[CONTC000Master].[ConAttachments].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Counts the number of attachments from the attachments list', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CONTC000Master', @level2type = N'COLUMN', @level2name = N'ConAttachments';


GO
PRINT N'Creating [dbo].[CONTC000Master].[ConWebPage].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Web Page Address', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CONTC000Master', @level2type = N'COLUMN', @level2name = N'ConWebPage';


GO
PRINT N'Creating [dbo].[CONTC000Master].[ConNotes].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Contact Notes', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CONTC000Master', @level2type = N'COLUMN', @level2name = N'ConNotes';


GO
PRINT N'Creating [dbo].[CONTC000Master].[StatusId].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Active, Delete, Archive', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CONTC000Master', @level2type = N'COLUMN', @level2name = N'StatusId';


GO
PRINT N'Creating [dbo].[CONTC000Master].[ConTypeId].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'May need a reference table Type=Customer, Vendor, CSR, Driver, and other (Temporary or Permanent)', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CONTC000Master', @level2type = N'COLUMN', @level2name = N'ConTypeId';


GO
PRINT N'Creating [dbo].[CONTC000Master].[ConOutlookId].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Outlook Id to Update', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CONTC000Master', @level2type = N'COLUMN', @level2name = N'ConOutlookId';


GO
PRINT N'Creating [dbo].[CONTC000Master].[DateEntered].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Date Entered', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CONTC000Master', @level2type = N'COLUMN', @level2name = N'DateEntered';


GO
PRINT N'Creating [dbo].[CONTC000Master].[EnteredBy].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Entered By User Id', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CONTC000Master', @level2type = N'COLUMN', @level2name = N'EnteredBy';


GO
PRINT N'Creating [dbo].[CONTC000Master].[DateChanged].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Changed Date', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CONTC000Master', @level2type = N'COLUMN', @level2name = N'DateChanged';


GO
PRINT N'Creating [dbo].[CONTC000Master].[ChangedBy].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Changed By User Id', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CONTC000Master', @level2type = N'COLUMN', @level2name = N'ChangedBy';


GO
PRINT N'Refreshing [dbo].[GetComboBoxContacts]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[GetComboBoxContacts]';


GO
PRINT N'Refreshing [dbo].[GetContactByOwner]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[GetContactByOwner]';


GO
PRINT N'Refreshing [dbo].[GetCustDcLocationContact]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[GetCustDcLocationContact]';


GO
PRINT N'Refreshing [dbo].[GetJobAnalystComboboxContacts]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[GetJobAnalystComboboxContacts]';


GO
PRINT N'Refreshing [dbo].[GetJobGateway]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[GetJobGateway]';


GO
PRINT N'Refreshing [dbo].[GetJobResponsibleComboboxContacts]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[GetJobResponsibleComboboxContacts]';


GO
PRINT N'Refreshing [dbo].[GetOrgActRole]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[GetOrgActRole]';


GO
PRINT N'Refreshing [dbo].[GetOrganizationImages]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[GetOrganizationImages]';


GO
PRINT N'Refreshing [dbo].[GetPPPGatewayContactCombobox]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[GetPPPGatewayContactCombobox]';


GO
PRINT N'Refreshing [dbo].[GetUserSysSetting]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[GetUserSysSetting]';


GO
PRINT N'Refreshing [dbo].[GetVendDcLocationContact]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[GetVendDcLocationContact]';


GO
PRINT N'Refreshing [dbo].[InsCustDcLocationContact]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[InsCustDcLocationContact]';


GO
PRINT N'Refreshing [dbo].[InsVendDcLocationContact]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[InsVendDcLocationContact]';


GO
PRINT N'Refreshing [dbo].[UpdContactCard]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[UpdContactCard]';


GO
PRINT N'Refreshing [dbo].[UpdCustDcLocationContact]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[UpdCustDcLocationContact]';


GO
PRINT N'Refreshing [dbo].[UpdVendDcLocationContact]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[UpdVendDcLocationContact]';


GO
PRINT N'Refreshing [dbo].[InsOrgActRole]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[InsOrgActRole]';


GO
PRINT N'Refreshing [dbo].[InsOrUpdOrgActRole]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[InsOrUpdOrgActRole]';


GO
PRINT N'Checking existing data against newly created constraints';



GO
ALTER TABLE [dbo].[JOBDL020Gateways] WITH CHECK CHECK CONSTRAINT [FK_JOBDL020Gateways_CONTC000Master];

ALTER TABLE [dbo].[JOBDL020Gateways] WITH CHECK CHECK CONSTRAINT [FK_JOBDL020Gateways_GwyGatewayAnalyst_CONTC000Master];

ALTER TABLE [dbo].[PRGRM051VendorLocations] WITH CHECK CHECK CONSTRAINT [FK_PRGRM051VendorLocations_CONTC000Master];

ALTER TABLE [dbo].[VEND000Master] WITH CHECK CHECK CONSTRAINT [FK_VEND000Master_BusiAddress_CONTC000Master];

ALTER TABLE [dbo].[VEND000Master] WITH CHECK CHECK CONSTRAINT [FK_VEND000Master_CopAddress_CONTC000Master];

ALTER TABLE [dbo].[VEND000Master] WITH CHECK CHECK CONSTRAINT [FK_VEND000Master_WorkAddress_CONTC000Master];

ALTER TABLE [dbo].[CUST000Master] WITH CHECK CHECK CONSTRAINT [FK_CUST000Master_WorkAddress_CONTC000Master];

ALTER TABLE [dbo].[CUST000Master] WITH CHECK CHECK CONSTRAINT [FK_CUST000Master_BusiAddress_CONTC000Master];

ALTER TABLE [dbo].[CUST000Master] WITH CHECK CHECK CONSTRAINT [FK_CUST000Master_CopAddress_CONTC000Master];

ALTER TABLE [dbo].[ORGAN010Ref_Roles] WITH CHECK CHECK CONSTRAINT [FK_ORGAN010Ref_Roles_CONTC000Master];

ALTER TABLE [dbo].[PRGRM020Program_Role] WITH CHECK CHECK CONSTRAINT [FK_PRGRM020Program_Role_CONTC000Master];

ALTER TABLE [dbo].[JOBDL000Master] WITH CHECK CHECK CONSTRAINT [FK_JOBDL000Master_DeliveryAnalyst_CONTC000Master];

ALTER TABLE [dbo].[JOBDL000Master] WITH CHECK CHECK CONSTRAINT [FK_JOBDL000Master_DeliveryResponsible_CONTC000Master];

ALTER TABLE [dbo].[JOBDL000Master] WITH CHECK CHECK CONSTRAINT [FK_JOBDL000Master_OriginResponsible_CONTC000Master];

ALTER TABLE [dbo].[JOBDL000Master] WITH CHECK CHECK CONSTRAINT [FK_JOBDL000Master_JobDriver_CONTC000Master];

ALTER TABLE [dbo].[ORGAN020Act_Roles] WITH CHECK CHECK CONSTRAINT [FK_ORGAN020Act_Roles_CONTC000Master];

ALTER TABLE [dbo].[PRGRM010Ref_GatewayDefaults] WITH CHECK CHECK CONSTRAINT [FK_PRGRM010Ref_GatewayDefaults_Responsible_CONTC000Master];

ALTER TABLE [dbo].[PRGRM010Ref_GatewayDefaults] WITH CHECK CHECK CONSTRAINT [FK_PRGRM010Ref_GatewayDefaults_Analyst_CONTC000Master];

ALTER TABLE [dbo].[CONTC010Bridge] WITH CHECK CHECK CONSTRAINT [FK_CONTC010Bridge_CONTC000Master];

ALTER TABLE [dbo].[CUST040DCLocations] WITH CHECK CHECK CONSTRAINT [FK_CUST040DCLocations_CONTC000Master];

ALTER TABLE [dbo].[VEND040DCLocations] WITH CHECK CHECK CONSTRAINT [FK_VEND040DCLocations_CONTC000Master];

ALTER TABLE [dbo].[SYSTM000OpnSezMe] WITH CHECK CHECK CONSTRAINT [FK_SYSTM000OpnSezMe_CONTC000Master];


GO
PRINT N'Update complete.';


GO
