


GO
PRINT N'Dropping [dbo].[DF_JOBDL000Master_JobCompleted]...';


GO
ALTER TABLE [dbo].[JOBDL000Master] DROP CONSTRAINT [DF_JOBDL000Master_JobCompleted];


GO
PRINT N'Dropping [dbo].[DF_JOBDL000Master_EnteredBy]...';


GO
ALTER TABLE [dbo].[JOBDL000Master] DROP CONSTRAINT [DF_JOBDL000Master_EnteredBy];


GO
PRINT N'Dropping [dbo].[DF_Table_1_CustEnteredOn]...';


GO
ALTER TABLE [dbo].[JOBDL000Master] DROP CONSTRAINT [DF_Table_1_CustEnteredOn];


GO
PRINT N'Dropping [dbo].[FK_SYSTM000_StatusLog_JobID_JOBDL000Master]...';


GO
ALTER TABLE [dbo].[SYSTM000_StatusLog] DROP CONSTRAINT [FK_SYSTM000_StatusLog_JobID_JOBDL000Master];


GO
PRINT N'Dropping [dbo].[FK_JOBDL000Master_PRGRM000Master]...';


GO
ALTER TABLE [dbo].[JOBDL000Master] DROP CONSTRAINT [FK_JOBDL000Master_PRGRM000Master];


GO
PRINT N'Dropping [dbo].[FK_JOBDL000Master_Status_SYSTM000Ref_Options]...';


GO
ALTER TABLE [dbo].[JOBDL000Master] DROP CONSTRAINT [FK_JOBDL000Master_Status_SYSTM000Ref_Options];


GO
PRINT N'Dropping [dbo].[FK_JOBDL000Master_DeliveryAnalyst_CONTC000Master]...';


GO
ALTER TABLE [dbo].[JOBDL000Master] DROP CONSTRAINT [FK_JOBDL000Master_DeliveryAnalyst_CONTC000Master];


GO
PRINT N'Dropping [dbo].[FK_JOBDL000Master_DeliveryResponsible_CONTC000Master]...';


GO
ALTER TABLE [dbo].[JOBDL000Master] DROP CONSTRAINT [FK_JOBDL000Master_DeliveryResponsible_CONTC000Master];


GO
PRINT N'Dropping [dbo].[FK_JOBDL000Master_JobDriver_CONTC000Master]...';


GO
ALTER TABLE [dbo].[JOBDL000Master] DROP CONSTRAINT [FK_JOBDL000Master_JobDriver_CONTC000Master];


GO
PRINT N'Dropping [dbo].[FK_JOBDL000Master_OriginResponsible_CONTC000Master]...';


GO
ALTER TABLE [dbo].[JOBDL000Master] DROP CONSTRAINT [FK_JOBDL000Master_OriginResponsible_CONTC000Master];


GO
PRINT N'Dropping [dbo].[FK_BillableSheet_JobMaster]...';


GO
ALTER TABLE [dbo].[JOBDL061BillableSheet] DROP CONSTRAINT [FK_BillableSheet_JobMaster];


GO
PRINT N'Dropping [dbo].[FK_JOBDL020Gateways_JOBDL000Master]...';


GO
ALTER TABLE [dbo].[JOBDL020Gateways] DROP CONSTRAINT [FK_JOBDL020Gateways_JOBDL000Master];


GO
PRINT N'Dropping [dbo].[FK_JOBDL030Attributes_JOBDL000Master]...';


GO
ALTER TABLE [dbo].[JOBDL030Attributes] DROP CONSTRAINT [FK_JOBDL030Attributes_JOBDL000Master];


GO
PRINT N'Dropping [dbo].[FK_JOBDL040DocumentReference_JOBDL000Master]...';


GO
ALTER TABLE [dbo].[JOBDL040DocumentReference] DROP CONSTRAINT [FK_JOBDL040DocumentReference_JOBDL000Master];


GO
PRINT N'Dropping [dbo].[FK_JOBDL050Ref_Status_JOBDL000Master]...';


GO
ALTER TABLE [dbo].[JOBDL050Ref_Status] DROP CONSTRAINT [FK_JOBDL050Ref_Status_JOBDL000Master];


GO
PRINT N'Dropping [dbo].[FK_JOBDL060Ref_CostSheetJob_JOBDL000Master]...';


GO
ALTER TABLE [dbo].[JOBDL060Ref_CostSheetJob] DROP CONSTRAINT [FK_JOBDL060Ref_CostSheetJob_JOBDL000Master];


GO
PRINT N'Dropping [dbo].[FK_JOBDL010Cargo_JOBDL000Master]...';


GO
ALTER TABLE [dbo].[JOBDL010Cargo] DROP CONSTRAINT [FK_JOBDL010Cargo_JOBDL000Master];


GO
PRINT N'Dropping [dbo].[FK_CostSheet_JobMaster]...';


GO
ALTER TABLE [dbo].[JOBDL062CostSheet] DROP CONSTRAINT [FK_CostSheet_JobMaster];


GO
PRINT N'Starting rebuilding table [dbo].[JOBDL000Master]...';


GO
BEGIN TRANSACTION;

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

SET XACT_ABORT ON;

CREATE TABLE [dbo].[tmp_ms_xx_JOBDL000Master] (
    [Id]                              BIGINT          IDENTITY (1, 1) NOT NULL,
    [JobMITJobID]                     BIGINT          NULL,
    [ProgramID]                       BIGINT          NULL,
    [JobSiteCode]                     NVARCHAR (30)   NULL,
    [JobConsigneeCode]                NVARCHAR (30)   NULL,
    [JobCustomerSalesOrder]           NVARCHAR (30)   NULL,
    [JobBOL]                          NVARCHAR (30)   NULL,
    [JobBOLMaster]                    NVARCHAR (30)   NULL,
    [JobBOLChild]                     NVARCHAR (30)   NULL,
    [JobCustomerPurchaseOrder]        NVARCHAR (30)   NULL,
    [JobCarrierContract]              NVARCHAR (30)   NULL,
    [JobManifestNo]                   VARCHAR (30)    NULL,
    [JobQtyOrdered]                   DECIMAL (18, 2) NULL,
    [JobQtyActual]                    DECIMAL (18, 2) NULL,
    [JobQtyUnitTypeId]                BIGINT          NULL,
    [JobPartsOrdered]                 DECIMAL (18, 2) NULL,
    [JobPartsActual]                  DECIMAL (18, 2) NULL,
    [JobTotalCubes]                   DECIMAL (18, 2) NULL,
    [JobServiceMode]                  NVARCHAR (30)   NULL,
    [JobChannel]                      NVARCHAR (30)   NULL,
    [JobProductType]                  NVARCHAR (30)   NULL,
    [JobGatewayStatus]                NVARCHAR (50)   NULL,
    [StatusId]                        INT             NULL,
    [JobStatusedDate]                 DATETIME2 (7)   NULL,
    [JobCompleted]                    BIT             CONSTRAINT [DF_JOBDL000Master_JobCompleted] DEFAULT ((0)) NULL,
    [JobType]                         NVARCHAR (20)   NULL,
    [ShipmentType]                    NVARCHAR (20)   NULL,
    [JobDeliveryAnalystContactID]     BIGINT          NULL,
    [JobDeliveryResponsibleContactID] BIGINT          NULL,
    [PlantIDCode]                     NVARCHAR (30)   NULL,
    [JobRouteId]                      INT             NULL,
    [JobDriverId]                     BIGINT          NULL,
    [JobStop]                         NVARCHAR (20)   NULL,
    [CarrierID]                       NVARCHAR (30)   NULL,
    [JobSignText]                     NVARCHAR (75)   NULL,
    [JobSignLatitude]                 NVARCHAR (50)   NULL,
    [JobSignLongitude]                NVARCHAR (50)   NULL,
    [WindowDelStartTime]              DATETIME2 (7)   NULL,
    [WindowDelEndTime]                DATETIME2 (7)   NULL,
    [WindowPckStartTime]              DATETIME2 (7)   NULL,
    [WindowPckEndTime]                DATETIME2 (7)   NULL,
    [JobDeliverySitePOC]              NVARCHAR (75)   NULL,
    [JobDeliverySitePOCPhone]         NVARCHAR (50)   NULL,
    [JobDeliverySitePOCEmail]         NVARCHAR (50)   NULL,
    [JobDeliverySiteName]             NVARCHAR (50)   NULL,
    [JobDeliveryStreetAddress]        NVARCHAR (100)  NULL,
    [JobDeliveryStreetAddress2]       NVARCHAR (100)  NULL,
    [JobDeliveryCity]                 NVARCHAR (50)   NULL,
    [JobDeliveryState]                NVARCHAR (50)   NULL,
    [JobDeliveryPostalCode]           NVARCHAR (50)   NULL,
    [JobDeliveryCountry]              NVARCHAR (50)   NULL,
    [JobDeliveryTimeZone]             NVARCHAR (15)   NULL,
    [JobDeliveryDateTimePlanned]      DATETIME2 (7)   NULL,
    [JobDeliveryDateTimeActual]       DATETIME2 (7)   NULL,
    [JobDeliveryDateTimeBaseline]     DATETIME2 (7)   NULL,
    [JobDeliveryComment]              VARBINARY (MAX) NULL,
    [JobDeliveryRecipientPhone]       NVARCHAR (50)   NULL,
    [JobDeliveryRecipientEmail]       NVARCHAR (50)   NULL,
    [JobLatitude]                     NVARCHAR (50)   NULL,
    [JobLongitude]                    NVARCHAR (50)   NULL,
    [JobOriginResponsibleContactID]   BIGINT          NULL,
    [JobOriginSiteCode]               NVARCHAR (50)   NULL,
    [JobOriginSitePOC]                NVARCHAR (75)   NULL,
    [JobOriginSitePOCPhone]           NVARCHAR (50)   NULL,
    [JobOriginSitePOCEmail]           NVARCHAR (50)   NULL,
    [JobOriginSiteName]               NVARCHAR (50)   NULL,
    [JobOriginStreetAddress]          NVARCHAR (100)  NULL,
    [JobOriginStreetAddress2]         NVARCHAR (100)  NULL,
    [JobOriginCity]                   NVARCHAR (50)   NULL,
    [JobOriginState]                  NVARCHAR (50)   NULL,
    [JobOriginPostalCode]             NVARCHAR (50)   NULL,
    [JobOriginCountry]                NVARCHAR (50)   NULL,
    [JobOriginTimeZone]               NVARCHAR (15)   NULL,
    [JobOriginDateTimePlanned]        DATETIME2 (7)   NULL,
    [JobOriginDateTimeActual]         DATETIME2 (7)   NULL,
    [JobOriginDateTimeBaseline]       DATETIME2 (7)   NULL,
    [JobProcessingFlags]              NVARCHAR (20)   NULL,
    [JobDeliverySitePOC2]             NVARCHAR (75)   NULL,
    [JobDeliverySitePOCPhone2]        NVARCHAR (50)   NULL,
    [JobDeliverySitePOCEmail2]        NVARCHAR (50)   NULL,
    [JobOriginSitePOC2]               NVARCHAR (75)   NULL,
    [JobOriginSitePOCPhone2]          NVARCHAR (50)   NULL,
    [JobOriginSitePOCEmail2]          NVARCHAR (50)   NULL,
    [JobSellerCode]                   NVARCHAR (20)   NULL,
    [JobSellerSitePOC]                NVARCHAR (75)   NULL,
    [JobSellerSitePOCPhone]           NVARCHAR (50)   NULL,
    [JobSellerSitePOCEmail]           NVARCHAR (50)   NULL,
    [JobSellerSitePOC2]               NVARCHAR (75)   NULL,
    [JobSellerSitePOCPhone2]          NVARCHAR (50)   NULL,
    [JobSellerSitePOCEmail2]          NVARCHAR (50)   NULL,
    [JobSellerSiteName]               NVARCHAR (50)   NULL,
    [JobSellerStreetAddress]          NVARCHAR (100)  NULL,
    [JobSellerStreetAddress2]         NVARCHAR (100)  NULL,
    [JobSellerCity]                   NVARCHAR (50)   NULL,
    [JobSellerState]                  NVARCHAR (50)   NULL,
    [JobSellerPostalCode]             NVARCHAR (50)   NULL,
    [JobSellerCountry]                NVARCHAR (50)   NULL,
    [JobUser01]                       NVARCHAR (20)   NULL,
    [JobUser02]                       NVARCHAR (20)   NULL,
    [JobUser03]                       NVARCHAR (20)   NULL,
    [JobUser04]                       NVARCHAR (20)   NULL,
    [JobUser05]                       NVARCHAR (20)   NULL,
    [JobStatusFlags]                  NVARCHAR (20)   NULL,
    [JobScannerFlags]                 NVARCHAR (20)   NULL,
    [ProFlags01]                      NVARCHAR (1)    NULL,
    [ProFlags02]                      NVARCHAR (1)    NULL,
    [ProFlags03]                      NVARCHAR (1)    NULL,
    [ProFlags04]                      NVARCHAR (1)    NULL,
    [ProFlags05]                      NVARCHAR (1)    NULL,
    [ProFlags06]                      NVARCHAR (1)    NULL,
    [ProFlags07]                      NVARCHAR (1)    NULL,
    [ProFlags08]                      NVARCHAR (1)    NULL,
    [ProFlags09]                      NVARCHAR (1)    NULL,
    [ProFlags10]                      NVARCHAR (1)    NULL,
    [ProFlags11]                      NVARCHAR (1)    NULL,
    [ProFlags12]                      NVARCHAR (1)    NULL,
    [ProFlags13]                      NVARCHAR (1)    NULL,
    [ProFlags14]                      NVARCHAR (1)    NULL,
    [ProFlags15]                      NVARCHAR (1)    NULL,
    [ProFlags16]                      NVARCHAR (1)    NULL,
    [ProFlags17]                      NVARCHAR (1)    NULL,
    [ProFlags18]                      NVARCHAR (1)    NULL,
    [ProFlags19]                      NVARCHAR (1)    NULL,
    [ProFlags20]                      NVARCHAR (1)    NULL,
    [EnteredBy]                       NVARCHAR (50)   CONSTRAINT [DF_JOBDL000Master_EnteredBy] DEFAULT (getutcdate()) NULL,
    [DateEntered]                     DATETIME2 (7)   CONSTRAINT [DF_Table_1_CustEnteredOn] DEFAULT (getutcdate()) NULL,
    [ChangedBy]                       NVARCHAR (50)   NULL,
    [DateChanged]                     DATETIME2 (7)   NULL,
    CONSTRAINT [tmp_ms_xx_constraint_PK_JOBDL000Master1] PRIMARY KEY CLUSTERED ([Id] ASC)
);

IF EXISTS (SELECT TOP 1 1 
           FROM   [dbo].[JOBDL000Master])
    BEGIN
        SET IDENTITY_INSERT [dbo].[tmp_ms_xx_JOBDL000Master] ON;
        INSERT INTO [dbo].[tmp_ms_xx_JOBDL000Master] ([Id], [JobMITJobID], [ProgramID], [JobSiteCode], [JobConsigneeCode], [JobCustomerSalesOrder], [JobBOL], [JobBOLMaster], [JobBOLChild], [JobCustomerPurchaseOrder], [JobCarrierContract], [JobManifestNo], [JobGatewayStatus], [StatusId], [JobStatusedDate], [JobCompleted], [JobType], [ShipmentType], [JobDeliveryAnalystContactID], [JobDeliveryResponsibleContactID], [PlantIDCode], [JobRouteId], [JobDriverId], [JobStop], [CarrierID], [JobSignText], [JobSignLatitude], [JobSignLongitude], [WindowDelStartTime], [WindowDelEndTime], [WindowPckStartTime], [WindowPckEndTime], [JobDeliverySitePOC], [JobDeliverySitePOCPhone], [JobDeliverySitePOCEmail], [JobDeliverySiteName], [JobDeliveryStreetAddress], [JobDeliveryStreetAddress2], [JobDeliveryCity], [JobDeliveryState], [JobDeliveryPostalCode], [JobDeliveryCountry], [JobDeliveryTimeZone], [JobDeliveryDateTimePlanned], [JobDeliveryDateTimeActual], [JobDeliveryDateTimeBaseline], [JobDeliveryComment], [JobDeliveryRecipientPhone], [JobDeliveryRecipientEmail], [JobLatitude], [JobLongitude], [JobOriginResponsibleContactID], [JobOriginSiteCode], [JobOriginSitePOC], [JobOriginSitePOCPhone], [JobOriginSitePOCEmail], [JobOriginSiteName], [JobOriginStreetAddress], [JobOriginStreetAddress2], [JobOriginCity], [JobOriginState], [JobOriginPostalCode], [JobOriginCountry], [JobOriginTimeZone], [JobOriginDateTimePlanned], [JobOriginDateTimeActual], [JobOriginDateTimeBaseline], [JobProcessingFlags], [JobDeliverySitePOC2], [JobDeliverySitePOCPhone2], [JobDeliverySitePOCEmail2], [JobOriginSitePOC2], [JobOriginSitePOCPhone2], [JobOriginSitePOCEmail2], [JobSellerCode], [JobSellerSitePOC], [JobSellerSitePOCPhone], [JobSellerSitePOCEmail], [JobSellerSitePOC2], [JobSellerSitePOCPhone2], [JobSellerSitePOCEmail2], [JobSellerSiteName], [JobSellerStreetAddress], [JobSellerStreetAddress2], [JobSellerCity], [JobSellerState], [JobSellerPostalCode], [JobSellerCountry], [JobUser01], [JobUser02], [JobUser03], [JobUser04], [JobUser05], [JobStatusFlags], [JobScannerFlags], [ProFlags01], [ProFlags02], [ProFlags03], [ProFlags04], [ProFlags05], [ProFlags06], [ProFlags07], [ProFlags08], [ProFlags09], [ProFlags10], [ProFlags11], [ProFlags12], [ProFlags13], [ProFlags14], [ProFlags15], [ProFlags16], [ProFlags17], [ProFlags18], [ProFlags19], [ProFlags20], [EnteredBy], [DateEntered], [ChangedBy], [DateChanged])
        SELECT   [Id],
                 [JobMITJobID],
                 [ProgramID],
                 [JobSiteCode],
                 [JobConsigneeCode],
                 [JobCustomerSalesOrder],
                 [JobBOL],
                 [JobBOLMaster],
                 [JobBOLChild],
                 [JobCustomerPurchaseOrder],
                 [JobCarrierContract],
                 [JobManifestNo],
                 [JobGatewayStatus],
                 [StatusId],
                 [JobStatusedDate],
                 [JobCompleted],
                 [JobType],
                 [ShipmentType],
                 [JobDeliveryAnalystContactID],
                 [JobDeliveryResponsibleContactID],
                 [PlantIDCode],
                 [JobRouteId],
                 [JobDriverId],
                 [JobStop],
                 [CarrierID],
                 [JobSignText],
                 [JobSignLatitude],
                 [JobSignLongitude],
                 [WindowDelStartTime],
                 [WindowDelEndTime],
                 [WindowPckStartTime],
                 [WindowPckEndTime],
                 [JobDeliverySitePOC],
                 [JobDeliverySitePOCPhone],
                 [JobDeliverySitePOCEmail],
                 [JobDeliverySiteName],
                 [JobDeliveryStreetAddress],
                 [JobDeliveryStreetAddress2],
                 [JobDeliveryCity],
                 [JobDeliveryState],
                 [JobDeliveryPostalCode],
                 [JobDeliveryCountry],
                 [JobDeliveryTimeZone],
                 [JobDeliveryDateTimePlanned],
                 [JobDeliveryDateTimeActual],
                 [JobDeliveryDateTimeBaseline],
                 [JobDeliveryComment],
                 [JobDeliveryRecipientPhone],
                 [JobDeliveryRecipientEmail],
                 [JobLatitude],
                 [JobLongitude],
                 [JobOriginResponsibleContactID],
                 [JobOriginSiteCode],
                 [JobOriginSitePOC],
                 [JobOriginSitePOCPhone],
                 [JobOriginSitePOCEmail],
                 [JobOriginSiteName],
                 [JobOriginStreetAddress],
                 [JobOriginStreetAddress2],
                 [JobOriginCity],
                 [JobOriginState],
                 [JobOriginPostalCode],
                 [JobOriginCountry],
                 [JobOriginTimeZone],
                 [JobOriginDateTimePlanned],
                 [JobOriginDateTimeActual],
                 [JobOriginDateTimeBaseline],
                 [JobProcessingFlags],
                 [JobDeliverySitePOC2],
                 [JobDeliverySitePOCPhone2],
                 [JobDeliverySitePOCEmail2],
                 [JobOriginSitePOC2],
                 [JobOriginSitePOCPhone2],
                 [JobOriginSitePOCEmail2],
                 [JobSellerCode],
                 [JobSellerSitePOC],
                 [JobSellerSitePOCPhone],
                 [JobSellerSitePOCEmail],
                 [JobSellerSitePOC2],
                 [JobSellerSitePOCPhone2],
                 [JobSellerSitePOCEmail2],
                 [JobSellerSiteName],
                 [JobSellerStreetAddress],
                 [JobSellerStreetAddress2],
                 [JobSellerCity],
                 [JobSellerState],
                 [JobSellerPostalCode],
                 [JobSellerCountry],
                 [JobUser01],
                 [JobUser02],
                 [JobUser03],
                 [JobUser04],
                 [JobUser05],
                 [JobStatusFlags],
                 [JobScannerFlags],
                 [ProFlags01],
                 [ProFlags02],
                 [ProFlags03],
                 [ProFlags04],
                 [ProFlags05],
                 [ProFlags06],
                 [ProFlags07],
                 [ProFlags08],
                 [ProFlags09],
                 [ProFlags10],
                 [ProFlags11],
                 [ProFlags12],
                 [ProFlags13],
                 [ProFlags14],
                 [ProFlags15],
                 [ProFlags16],
                 [ProFlags17],
                 [ProFlags18],
                 [ProFlags19],
                 [ProFlags20],
                 [EnteredBy],
                 [DateEntered],
                 [ChangedBy],
                 [DateChanged]
        FROM     [dbo].[JOBDL000Master]
        ORDER BY [Id] ASC;
        SET IDENTITY_INSERT [dbo].[tmp_ms_xx_JOBDL000Master] OFF;
    END

DROP TABLE [dbo].[JOBDL000Master];

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_JOBDL000Master]', N'JOBDL000Master';

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_constraint_PK_JOBDL000Master1]', N'PK_JOBDL000Master', N'OBJECT';

COMMIT TRANSACTION;

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;


GO
PRINT N'Creating [dbo].[FK_SYSTM000_StatusLog_JobID_JOBDL000Master]...';


GO
ALTER TABLE [dbo].[SYSTM000_StatusLog] WITH NOCHECK
    ADD CONSTRAINT [FK_SYSTM000_StatusLog_JobID_JOBDL000Master] FOREIGN KEY ([JobID]) REFERENCES [dbo].[JOBDL000Master] ([Id]);


GO
PRINT N'Creating [dbo].[FK_JOBDL000Master_PRGRM000Master]...';


GO
ALTER TABLE [dbo].[JOBDL000Master] WITH NOCHECK
    ADD CONSTRAINT [FK_JOBDL000Master_PRGRM000Master] FOREIGN KEY ([ProgramID]) REFERENCES [dbo].[PRGRM000Master] ([Id]);


GO
PRINT N'Creating [dbo].[FK_JOBDL000Master_Status_SYSTM000Ref_Options]...';


GO
ALTER TABLE [dbo].[JOBDL000Master] WITH NOCHECK
    ADD CONSTRAINT [FK_JOBDL000Master_Status_SYSTM000Ref_Options] FOREIGN KEY ([StatusId]) REFERENCES [dbo].[SYSTM000Ref_Options] ([Id]);


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
PRINT N'Creating [dbo].[FK_JOBDL000Master_JobDriver_CONTC000Master]...';


GO
ALTER TABLE [dbo].[JOBDL000Master] WITH NOCHECK
    ADD CONSTRAINT [FK_JOBDL000Master_JobDriver_CONTC000Master] FOREIGN KEY ([JobDriverId]) REFERENCES [dbo].[CONTC000Master] ([Id]);


GO
PRINT N'Creating [dbo].[FK_JOBDL000Master_OriginResponsible_CONTC000Master]...';


GO
ALTER TABLE [dbo].[JOBDL000Master] WITH NOCHECK
    ADD CONSTRAINT [FK_JOBDL000Master_OriginResponsible_CONTC000Master] FOREIGN KEY ([JobOriginResponsibleContactID]) REFERENCES [dbo].[CONTC000Master] ([Id]);


GO
PRINT N'Creating [dbo].[FK_BillableSheet_JobMaster]...';


GO
ALTER TABLE [dbo].[JOBDL061BillableSheet] WITH NOCHECK
    ADD CONSTRAINT [FK_BillableSheet_JobMaster] FOREIGN KEY ([JobID]) REFERENCES [dbo].[JOBDL000Master] ([Id]);


GO
PRINT N'Creating [dbo].[FK_JOBDL020Gateways_JOBDL000Master]...';


GO
ALTER TABLE [dbo].[JOBDL020Gateways] WITH NOCHECK
    ADD CONSTRAINT [FK_JOBDL020Gateways_JOBDL000Master] FOREIGN KEY ([JobID]) REFERENCES [dbo].[JOBDL000Master] ([Id]);


GO
PRINT N'Creating [dbo].[FK_JOBDL030Attributes_JOBDL000Master]...';


GO
ALTER TABLE [dbo].[JOBDL030Attributes] WITH NOCHECK
    ADD CONSTRAINT [FK_JOBDL030Attributes_JOBDL000Master] FOREIGN KEY ([JobID]) REFERENCES [dbo].[JOBDL000Master] ([Id]);


GO
PRINT N'Creating [dbo].[FK_JOBDL040DocumentReference_JOBDL000Master]...';


GO
ALTER TABLE [dbo].[JOBDL040DocumentReference] WITH NOCHECK
    ADD CONSTRAINT [FK_JOBDL040DocumentReference_JOBDL000Master] FOREIGN KEY ([JobID]) REFERENCES [dbo].[JOBDL000Master] ([Id]);


GO
PRINT N'Creating [dbo].[FK_JOBDL050Ref_Status_JOBDL000Master]...';


GO
ALTER TABLE [dbo].[JOBDL050Ref_Status] WITH NOCHECK
    ADD CONSTRAINT [FK_JOBDL050Ref_Status_JOBDL000Master] FOREIGN KEY ([JobID]) REFERENCES [dbo].[JOBDL000Master] ([Id]);


GO
PRINT N'Creating [dbo].[FK_JOBDL060Ref_CostSheetJob_JOBDL000Master]...';


GO
ALTER TABLE [dbo].[JOBDL060Ref_CostSheetJob] WITH NOCHECK
    ADD CONSTRAINT [FK_JOBDL060Ref_CostSheetJob_JOBDL000Master] FOREIGN KEY ([JobID]) REFERENCES [dbo].[JOBDL000Master] ([Id]);


GO
PRINT N'Creating [dbo].[FK_JOBDL010Cargo_JOBDL000Master]...';


GO
ALTER TABLE [dbo].[JOBDL010Cargo] WITH NOCHECK
    ADD CONSTRAINT [FK_JOBDL010Cargo_JOBDL000Master] FOREIGN KEY ([JobID]) REFERENCES [dbo].[JOBDL000Master] ([Id]);


GO
PRINT N'Creating [dbo].[FK_CostSheet_JobMaster]...';


GO
ALTER TABLE [dbo].[JOBDL062CostSheet] WITH NOCHECK
    ADD CONSTRAINT [FK_CostSheet_JobMaster] FOREIGN KEY ([JobID]) REFERENCES [dbo].[JOBDL000Master] ([Id]);


GO
PRINT N'Creating [dbo].[JOBDL000Master].[Id].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Unique Job ID', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'JOBDL000Master', @level2type = N'COLUMN', @level2name = N'Id';


GO
PRINT N'Creating [dbo].[JOBDL000Master].[JobMITJobID].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Relate a Child Job for Merge In Transit (MIT)', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'JOBDL000Master', @level2type = N'COLUMN', @level2name = N'JobMITJobID';


GO
PRINT N'Creating [dbo].[JOBDL000Master].[ProgramID].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Program ID', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'JOBDL000Master', @level2type = N'COLUMN', @level2name = N'ProgramID';


GO
PRINT N'Creating [dbo].[JOBDL000Master].[JobSiteCode].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Site Code (Short Text)', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'JOBDL000Master', @level2type = N'COLUMN', @level2name = N'JobSiteCode';


GO
PRINT N'Creating [dbo].[JOBDL000Master].[JobConsigneeCode].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Consignee Code Identifies Who the Customer is From Customer Source', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'JOBDL000Master', @level2type = N'COLUMN', @level2name = N'JobConsigneeCode';


GO
PRINT N'Creating [dbo].[JOBDL000Master].[JobCustomerSalesOrder].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Sales Order Number From Customer', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'JOBDL000Master', @level2type = N'COLUMN', @level2name = N'JobCustomerSalesOrder';


GO
PRINT N'Creating [dbo].[JOBDL000Master].[JobBOLMaster].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Phase of BOL Master', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'JOBDL000Master', @level2type = N'COLUMN', @level2name = N'JobBOLMaster';


GO
PRINT N'Creating [dbo].[JOBDL000Master].[JobBOLChild].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Bill of Lading of Order Child to Above Master', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'JOBDL000Master', @level2type = N'COLUMN', @level2name = N'JobBOLChild';


GO
PRINT N'Creating [dbo].[JOBDL000Master].[JobCustomerPurchaseOrder].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Customer Purchase Order', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'JOBDL000Master', @level2type = N'COLUMN', @level2name = N'JobCustomerPurchaseOrder';


GO
PRINT N'Creating [dbo].[JOBDL000Master].[JobCarrierContract].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Provider Carrier Contract Number', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'JOBDL000Master', @level2type = N'COLUMN', @level2name = N'JobCarrierContract';


GO
PRINT N'Creating [dbo].[JOBDL000Master].[JobGatewayStatus].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Gate Way Status Indicator', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'JOBDL000Master', @level2type = N'COLUMN', @level2name = N'JobGatewayStatus';


GO
PRINT N'Creating [dbo].[JOBDL000Master].[StatusId].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Job Status (Active, Completed, Postponed, there are more...)', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'JOBDL000Master', @level2type = N'COLUMN', @level2name = N'StatusId';


GO
PRINT N'Creating [dbo].[JOBDL000Master].[JobStatusedDate].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Date Last Statused', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'JOBDL000Master', @level2type = N'COLUMN', @level2name = N'JobStatusedDate';


GO
PRINT N'Creating [dbo].[JOBDL000Master].[JobCompleted].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Is the Job Completed', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'JOBDL000Master', @level2type = N'COLUMN', @level2name = N'JobCompleted';


GO
PRINT N'Creating [dbo].[JOBDL000Master].[JobType].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Type of Job(Original,Return)', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'JOBDL000Master', @level2type = N'COLUMN', @level2name = N'JobType';


GO
PRINT N'Creating [dbo].[JOBDL000Master].[ShipmentType].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Type of Shipement(Cross-Dock Shipment, Direct Shipment)', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'JOBDL000Master', @level2type = N'COLUMN', @level2name = N'ShipmentType';


GO
PRINT N'Creating [dbo].[JOBDL000Master].[JobDeliveryResponsibleContactID].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'From Program (Not a strong Link)', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'JOBDL000Master', @level2type = N'COLUMN', @level2name = N'JobDeliveryResponsibleContactID';


GO
PRINT N'Creating [dbo].[JOBDL000Master].[JobDeliverySitePOC].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Delivery Point of Contact (POC) (Can Come from EDI)', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'JOBDL000Master', @level2type = N'COLUMN', @level2name = N'JobDeliverySitePOC';


GO
PRINT N'Creating [dbo].[JOBDL000Master].[JobDeliverySitePOCPhone].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'POC Phone', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'JOBDL000Master', @level2type = N'COLUMN', @level2name = N'JobDeliverySitePOCPhone';


GO
PRINT N'Creating [dbo].[JOBDL000Master].[JobDeliverySitePOCEmail].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'POC Email', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'JOBDL000Master', @level2type = N'COLUMN', @level2name = N'JobDeliverySitePOCEmail';


GO
PRINT N'Creating [dbo].[JOBDL000Master].[JobDeliverySiteName].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Site Name for Delivery', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'JOBDL000Master', @level2type = N'COLUMN', @level2name = N'JobDeliverySiteName';


GO
PRINT N'Creating [dbo].[JOBDL000Master].[JobDeliveryStreetAddress].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Street Address ', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'JOBDL000Master', @level2type = N'COLUMN', @level2name = N'JobDeliveryStreetAddress';


GO
PRINT N'Creating [dbo].[JOBDL000Master].[JobDeliveryStreetAddress2].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Street Address 2', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'JOBDL000Master', @level2type = N'COLUMN', @level2name = N'JobDeliveryStreetAddress2';


GO
PRINT N'Creating [dbo].[JOBDL000Master].[JobDeliveryCity].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Delivery City', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'JOBDL000Master', @level2type = N'COLUMN', @level2name = N'JobDeliveryCity';


GO
PRINT N'Creating [dbo].[JOBDL000Master].[JobDeliveryState].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Deliver State', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'JOBDL000Master', @level2type = N'COLUMN', @level2name = N'JobDeliveryState';


GO
PRINT N'Creating [dbo].[JOBDL000Master].[JobDeliveryPostalCode].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Delivery Postal Code', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'JOBDL000Master', @level2type = N'COLUMN', @level2name = N'JobDeliveryPostalCode';


GO
PRINT N'Creating [dbo].[JOBDL000Master].[JobDeliveryCountry].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Delivery Country', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'JOBDL000Master', @level2type = N'COLUMN', @level2name = N'JobDeliveryCountry';


GO
PRINT N'Creating [dbo].[JOBDL000Master].[JobDeliveryTimeZone].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Delivery Time Zone', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'JOBDL000Master', @level2type = N'COLUMN', @level2name = N'JobDeliveryTimeZone';


GO
PRINT N'Creating [dbo].[JOBDL000Master].[JobDeliveryDateTimePlanned].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Delivery Date Planned', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'JOBDL000Master', @level2type = N'COLUMN', @level2name = N'JobDeliveryDateTimePlanned';


GO
PRINT N'Creating [dbo].[JOBDL000Master].[JobDeliveryDateTimeActual].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Delivery Date Actual', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'JOBDL000Master', @level2type = N'COLUMN', @level2name = N'JobDeliveryDateTimeActual';


GO
PRINT N'Creating [dbo].[JOBDL000Master].[JobDeliveryDateTimeBaseline].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Delivery Date Baseline (When was the Original Target Date)', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'JOBDL000Master', @level2type = N'COLUMN', @level2name = N'JobDeliveryDateTimeBaseline';


GO
PRINT N'Creating [dbo].[JOBDL000Master].[JobDeliveryComment].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Delivery Comment (Job Level)', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'JOBDL000Master', @level2type = N'COLUMN', @level2name = N'JobDeliveryComment';


GO
PRINT N'Creating [dbo].[JOBDL000Master].[JobDeliveryRecipientPhone].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Phone', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'JOBDL000Master', @level2type = N'COLUMN', @level2name = N'JobDeliveryRecipientPhone';


GO
PRINT N'Creating [dbo].[JOBDL000Master].[JobDeliveryRecipientEmail].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Email', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'JOBDL000Master', @level2type = N'COLUMN', @level2name = N'JobDeliveryRecipientEmail';


GO
PRINT N'Creating [dbo].[JOBDL000Master].[JobLatitude].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Latitude of the Delivery Site', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'JOBDL000Master', @level2type = N'COLUMN', @level2name = N'JobLatitude';


GO
PRINT N'Creating [dbo].[JOBDL000Master].[JobLongitude].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Longitude of the Delivery Site', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'JOBDL000Master', @level2type = N'COLUMN', @level2name = N'JobLongitude';


GO
PRINT N'Creating [dbo].[JOBDL000Master].[JobOriginResponsibleContactID].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Responsible at Origin''s location from contact (Loose relationship)', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'JOBDL000Master', @level2type = N'COLUMN', @level2name = N'JobOriginResponsibleContactID';


GO
PRINT N'Creating [dbo].[JOBDL000Master].[JobOriginSitePOC].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Origin Point of Contact (POC) (Can Come from EDI)', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'JOBDL000Master', @level2type = N'COLUMN', @level2name = N'JobOriginSitePOC';


GO
PRINT N'Creating [dbo].[JOBDL000Master].[JobOriginSitePOCPhone].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Origin POC Phone', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'JOBDL000Master', @level2type = N'COLUMN', @level2name = N'JobOriginSitePOCPhone';


GO
PRINT N'Creating [dbo].[JOBDL000Master].[JobOriginSitePOCEmail].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Origin POC Email', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'JOBDL000Master', @level2type = N'COLUMN', @level2name = N'JobOriginSitePOCEmail';


GO
PRINT N'Creating [dbo].[JOBDL000Master].[JobOriginSiteName].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Origin - is the Front of the Delivery - Typically this would be a DC?', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'JOBDL000Master', @level2type = N'COLUMN', @level2name = N'JobOriginSiteName';


GO
PRINT N'Creating [dbo].[JOBDL000Master].[JobOriginStreetAddress].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Origin - is the Front of the Delivery - Typically this would be a DC?', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'JOBDL000Master', @level2type = N'COLUMN', @level2name = N'JobOriginStreetAddress';


GO
PRINT N'Creating [dbo].[JOBDL000Master].[JobOriginStreetAddress2].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Origin Street Address 2', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'JOBDL000Master', @level2type = N'COLUMN', @level2name = N'JobOriginStreetAddress2';


GO
PRINT N'Creating [dbo].[JOBDL000Master].[JobOriginCity].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Origin City', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'JOBDL000Master', @level2type = N'COLUMN', @level2name = N'JobOriginCity';


GO
PRINT N'Creating [dbo].[JOBDL000Master].[JobOriginState].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Origin State or Province', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'JOBDL000Master', @level2type = N'COLUMN', @level2name = N'JobOriginState';


GO
PRINT N'Creating [dbo].[JOBDL000Master].[JobOriginPostalCode].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Origin Postal Code', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'JOBDL000Master', @level2type = N'COLUMN', @level2name = N'JobOriginPostalCode';


GO
PRINT N'Creating [dbo].[JOBDL000Master].[JobOriginCountry].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Origin Country', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'JOBDL000Master', @level2type = N'COLUMN', @level2name = N'JobOriginCountry';


GO
PRINT N'Creating [dbo].[JOBDL000Master].[JobOriginTimeZone].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Origin Time Zone', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'JOBDL000Master', @level2type = N'COLUMN', @level2name = N'JobOriginTimeZone';


GO
PRINT N'Creating [dbo].[JOBDL000Master].[JobOriginDateTimePlanned].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Origin Date Planned', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'JOBDL000Master', @level2type = N'COLUMN', @level2name = N'JobOriginDateTimePlanned';


GO
PRINT N'Creating [dbo].[JOBDL000Master].[JobOriginDateTimeActual].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Origin Date Actual', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'JOBDL000Master', @level2type = N'COLUMN', @level2name = N'JobOriginDateTimeActual';


GO
PRINT N'Creating [dbo].[JOBDL000Master].[JobOriginDateTimeBaseline].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Origin Date Baseline (When was the Original Target Date)', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'JOBDL000Master', @level2type = N'COLUMN', @level2name = N'JobOriginDateTimeBaseline';


GO
PRINT N'Creating [dbo].[JOBDL000Master].[JobProcessingFlags].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'One character processing flags to highlight conditions; used by Engineering only. Flags are one character text fields alpha-numeric and issued by position in this field.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'JOBDL000Master', @level2type = N'COLUMN', @level2name = N'JobProcessingFlags';


GO
PRINT N'Creating [dbo].[JOBDL000Master].[EnteredBy].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Who Initiated the Record', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'JOBDL000Master', @level2type = N'COLUMN', @level2name = N'EnteredBy';


GO
PRINT N'Creating [dbo].[JOBDL000Master].[DateEntered].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Date Record was Entered', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'JOBDL000Master', @level2type = N'COLUMN', @level2name = N'DateEntered';


GO
PRINT N'Creating [dbo].[JOBDL000Master].[ChangedBy].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Who changed the record', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'JOBDL000Master', @level2type = N'COLUMN', @level2name = N'ChangedBy';


GO
PRINT N'Creating [dbo].[JOBDL000Master].[DateChanged].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Date Changed', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'JOBDL000Master', @level2type = N'COLUMN', @level2name = N'DateChanged';


GO
PRINT N'Refreshing [dbo].[ediGetActiveCompleteEdiGateways]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ediGetActiveCompleteEdiGateways]';


GO
PRINT N'Refreshing [dbo].[ediGetEdiCompletedGateways_REMOVE]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ediGetEdiCompletedGateways_REMOVE]';


GO
PRINT N'Refreshing [dbo].[ediGetJobIdFromCustomerReferenceNo]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ediGetJobIdFromCustomerReferenceNo]';


GO
PRINT N'Refreshing [dbo].[ediUpdateJobMasterStatus]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ediUpdateJobMasterStatus]';


GO
PRINT N'Refreshing [dbo].[GetIsJobCompleted]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[GetIsJobCompleted]';


GO
PRINT N'Refreshing [dbo].[GetJob]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[GetJob]';


GO
PRINT N'Refreshing [dbo].[GetJob2ndPoc]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[GetJob2ndPoc]';


GO
PRINT N'Refreshing [dbo].[GetJobActions]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[GetJobActions]';


GO
PRINT N'Refreshing [dbo].[GetJobDestination]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[GetJobDestination]';


GO
PRINT N'Refreshing [dbo].[GetJobGateway]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[GetJobGateway]';


GO
PRINT N'Refreshing [dbo].[GetJobMapRoute]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[GetJobMapRoute]';


GO
PRINT N'Refreshing [dbo].[GetJobSeller]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[GetJobSeller]';


GO
PRINT N'Refreshing [dbo].[InsJob]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[InsJob]';


GO
PRINT N'Refreshing [dbo].[InsJobGateway]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[InsJobGateway]';


GO
PRINT N'Refreshing [dbo].[scanGetActiveUpcomingJobs]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[scanGetActiveUpcomingJobs]';


GO
PRINT N'Refreshing [dbo].[scanInsertActiveUpcomingJobs]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[scanInsertActiveUpcomingJobs]';


GO
PRINT N'Refreshing [dbo].[scanMergeJobAndScannerProcessingFlags]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[scanMergeJobAndScannerProcessingFlags]';


GO
PRINT N'Refreshing [dbo].[scanUpdateJobGatewayStatus]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[scanUpdateJobGatewayStatus]';


GO
PRINT N'Refreshing [dbo].[scanUpdateJobHeaderComplete]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[scanUpdateJobHeaderComplete]';


GO
PRINT N'Refreshing [dbo].[scanUpdateJobProcessStep]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[scanUpdateJobProcessStep]';


GO
PRINT N'Refreshing [dbo].[scanUpdateJobRouteInfo]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[scanUpdateJobRouteInfo]';


GO
PRINT N'Refreshing [dbo].[scanUpdateJobScannerProcessStep]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[scanUpdateJobScannerProcessStep]';


GO
PRINT N'Refreshing [dbo].[scanUpdateScannerCargoProcessingFlags]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[scanUpdateScannerCargoProcessingFlags]';


GO
PRINT N'Refreshing [dbo].[scanUpdateScannerOrderJobInformation]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[scanUpdateScannerOrderJobInformation]';


GO
PRINT N'Checking existing data against newly created constraints';




GO
ALTER TABLE [dbo].[SYSTM000_StatusLog] WITH CHECK CHECK CONSTRAINT [FK_SYSTM000_StatusLog_JobID_JOBDL000Master];

ALTER TABLE [dbo].[JOBDL000Master] WITH CHECK CHECK CONSTRAINT [FK_JOBDL000Master_PRGRM000Master];

ALTER TABLE [dbo].[JOBDL000Master] WITH CHECK CHECK CONSTRAINT [FK_JOBDL000Master_Status_SYSTM000Ref_Options];

ALTER TABLE [dbo].[JOBDL000Master] WITH CHECK CHECK CONSTRAINT [FK_JOBDL000Master_DeliveryAnalyst_CONTC000Master];

ALTER TABLE [dbo].[JOBDL000Master] WITH CHECK CHECK CONSTRAINT [FK_JOBDL000Master_DeliveryResponsible_CONTC000Master];

ALTER TABLE [dbo].[JOBDL000Master] WITH CHECK CHECK CONSTRAINT [FK_JOBDL000Master_JobDriver_CONTC000Master];

ALTER TABLE [dbo].[JOBDL000Master] WITH CHECK CHECK CONSTRAINT [FK_JOBDL000Master_OriginResponsible_CONTC000Master];

ALTER TABLE [dbo].[JOBDL061BillableSheet] WITH CHECK CHECK CONSTRAINT [FK_BillableSheet_JobMaster];

ALTER TABLE [dbo].[JOBDL020Gateways] WITH CHECK CHECK CONSTRAINT [FK_JOBDL020Gateways_JOBDL000Master];

ALTER TABLE [dbo].[JOBDL030Attributes] WITH CHECK CHECK CONSTRAINT [FK_JOBDL030Attributes_JOBDL000Master];

ALTER TABLE [dbo].[JOBDL040DocumentReference] WITH CHECK CHECK CONSTRAINT [FK_JOBDL040DocumentReference_JOBDL000Master];

ALTER TABLE [dbo].[JOBDL050Ref_Status] WITH CHECK CHECK CONSTRAINT [FK_JOBDL050Ref_Status_JOBDL000Master];

ALTER TABLE [dbo].[JOBDL060Ref_CostSheetJob] WITH CHECK CHECK CONSTRAINT [FK_JOBDL060Ref_CostSheetJob_JOBDL000Master];

ALTER TABLE [dbo].[JOBDL010Cargo] WITH CHECK CHECK CONSTRAINT [FK_JOBDL010Cargo_JOBDL000Master];

ALTER TABLE [dbo].[JOBDL062CostSheet] WITH CHECK CHECK CONSTRAINT [FK_CostSheet_JobMaster];


GO
PRINT N'Update complete.';


GO
