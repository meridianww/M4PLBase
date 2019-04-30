CREATE TABLE [dbo].[CONTC010Bridge] (
    [Id]                 BIGINT         IDENTITY (1, 1) NOT NULL,
    [ConOrgId]           BIGINT         NOT NULL,
    [ContactMSTRID]      BIGINT         NOT NULL,
    [ConTableName]       NVARCHAR (100) NULL,
    [ConPrimaryRecordId] BIGINT         NULL,
    [ConItemNumber]      INT            NULL,
    [ConCode]            NVARCHAR (20)  NULL,
    [ConTitle]           NVARCHAR (50)  NULL,
    [ConTypeId]          INT            NULL,
    [StatusId]           INT            NULL,
    [ConIsDefault]       BIT            NULL,
    [ConTableTypeId]     INT            NOT NULL,
	[ConDescription]     VARBINARY(MAX) NULL,
	[ConInstruction]     VARBINARY(MAX)  NULL,
	[ConAssignment]      NVARCHAR (20)  NULL,
	[ConGateway]         NVARCHAR (20)  NULL,
    [EnteredBy]          NVARCHAR (50)  NULL,
    [DateEntered]        DATETIME2 (7)  NULL,
    [ChangedBy]          NVARCHAR (50)  NULL,
    [DateChanged]        DATETIME2 (7)  NULL,
    CONSTRAINT [PK_CONTC010Bridge] PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
PRINT N'Creating [dbo].[FK_CONTC010Bridge_ConTableTypeId_SYSTM000Ref_Options]...';


GO
ALTER TABLE [dbo].[CONTC010Bridge] WITH NOCHECK
    ADD CONSTRAINT [FK_CONTC010Bridge_ConTableTypeId_SYSTM000Ref_Options] FOREIGN KEY ([ConTableTypeId]) REFERENCES [dbo].[SYSTM000Ref_Options] ([Id]);


GO
PRINT N'Creating [dbo].[FK_CONTC010Bridge_ConTypeId_SYSTM000Ref_Options]...';


GO
ALTER TABLE [dbo].[CONTC010Bridge] WITH NOCHECK
    ADD CONSTRAINT [FK_CONTC010Bridge_ConTypeId_SYSTM000Ref_Options] FOREIGN KEY ([ConTypeId]) REFERENCES [dbo].[SYSTM000Ref_Options] ([Id]);


GO
PRINT N'Creating [dbo].[FK_CONTC010Bridge_ORGAN000Master]...';


GO
ALTER TABLE [dbo].[CONTC010Bridge] WITH NOCHECK
    ADD CONSTRAINT [FK_CONTC010Bridge_ORGAN000Master] FOREIGN KEY ([ConOrgId]) REFERENCES [dbo].[ORGAN000Master] ([Id]);


GO
PRINT N'Creating [dbo].[FK_CONTC010Bridge_StatusId_SYSTM000Ref_Options]...';


GO
ALTER TABLE [dbo].[CONTC010Bridge] WITH NOCHECK
    ADD CONSTRAINT [FK_CONTC010Bridge_StatusId_SYSTM000Ref_Options] FOREIGN KEY ([StatusId]) REFERENCES [dbo].[SYSTM000Ref_Options] ([Id]);


GO
PRINT N'Creating [dbo].[FK_CONTC010Bridge_SYSTM000Ref_Table]...';


GO
ALTER TABLE [dbo].[CONTC010Bridge] WITH NOCHECK
    ADD CONSTRAINT [FK_CONTC010Bridge_SYSTM000Ref_Table] FOREIGN KEY ([ConTableName]) REFERENCES [dbo].[SYSTM000Ref_Table] ([SysRefName]);


GO
PRINT N'Creating [dbo].[FK_CONTC010Bridge_CONTC000Master]...';


GO
ALTER TABLE [dbo].[CONTC010Bridge] WITH NOCHECK
    ADD CONSTRAINT [FK_CONTC010Bridge_CONTC000Master] FOREIGN KEY ([ContactMSTRID]) REFERENCES [dbo].[CONTC000Master] ([Id]);



GO