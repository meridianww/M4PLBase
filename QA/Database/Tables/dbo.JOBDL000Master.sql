SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[JOBDL000Master](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[JobMITJobID] [bigint] NULL,
	[ProgramID] [bigint] NULL,
	[JobSiteCode] [nvarchar](30) NULL,
	[JobConsigneeCode] [nvarchar](30) NULL,
	[JobCustomerSalesOrder] [nvarchar](30) NULL,
	[JobBOL] [nvarchar](30) NULL,
	[JobBOLMaster] [nvarchar](30) NULL,
	[JobBOLChild] [nvarchar](30) NULL,
	[JobCustomerPurchaseOrder] [nvarchar](30) NULL,
	[JobCarrierContract] [nvarchar](30) NULL,
	[JobManifestNo] [varchar](30) NULL,
	[JobQtyOrdered] [int] NULL,
	[JobQtyActual] [int] NULL,
	[JobQtyUnitTypeId] [int] NULL,
	[JobPartsOrdered] [int] NULL,
	[JobPartsActual] [int] NULL,
	[JobTotalCubes] [decimal](18, 2) NULL,
	[JobServiceMode] [nvarchar](30) NULL,
	[JobChannel] [nvarchar](30) NULL,
	[JobProductType] [nvarchar](30) NULL,
	[JobGatewayStatus] [nvarchar](50) NULL,
	[StatusId] [int] NULL,
	[JobStatusedDate] [datetime2](7) NULL,
	[JobCompleted] [bit] NULL,
	[JobType] [nvarchar](20) NULL,
	[ShipmentType] [nvarchar](20) NULL,
	[JobDeliveryAnalystContactID] [bigint] NULL,
	[JobDeliveryResponsibleContactID] [bigint] NULL,
	[PlantIDCode] [nvarchar](30) NULL,
	[JobRouteId] [nvarchar](20) NULL,
	[JobDriverId] [bigint] NULL,
	[JobStop] [nvarchar](20) NULL,
	[CarrierID] [nvarchar](30) NULL,
	[JobSignText] [nvarchar](75) NULL,
	[JobSignLatitude] [nvarchar](50) NULL,
	[JobSignLongitude] [nvarchar](50) NULL,
	[WindowDelStartTime] [datetime2](7) NULL,
	[WindowDelEndTime] [datetime2](7) NULL,
	[WindowPckStartTime] [datetime2](7) NULL,
	[WindowPckEndTime] [datetime2](7) NULL,
	[JobDeliverySitePOC] [nvarchar](75) NULL,
	[JobDeliverySitePOCPhone] [nvarchar](50) NULL,
	[JobDeliverySitePOCEmail] [nvarchar](50) NULL,
	[JobDeliverySiteName] [nvarchar](50) NULL,
	[JobDeliveryStreetAddress] [nvarchar](100) NULL,
	[JobDeliveryStreetAddress2] [nvarchar](100) NULL,
	[JobDeliveryCity] [nvarchar](50) NULL,
	[JobDeliveryState] [nvarchar](50) NULL,
	[JobDeliveryPostalCode] [nvarchar](50) NULL,
	[JobDeliveryCountry] [nvarchar](50) NULL,
	[JobDeliveryTimeZone] [nvarchar](15) NULL,
	[JobDeliveryDateTimePlanned] [datetime2](7) NULL,
	[JobDeliveryDateTimeActual] [datetime2](7) NULL,
	[JobDeliveryDateTimeBaseline] [datetime2](7) NULL,
	[JobDeliveryComment] [varbinary](max) NULL,
	[JobDeliveryRecipientPhone] [nvarchar](50) NULL,
	[JobDeliveryRecipientEmail] [nvarchar](50) NULL,
	[JobLatitude] [nvarchar](50) NULL,
	[JobLongitude] [nvarchar](50) NULL,
	[JobOriginResponsibleContactID] [bigint] NULL,
	[JobOriginSiteCode] [nvarchar](50) NULL,
	[JobOriginSitePOC] [nvarchar](75) NULL,
	[JobOriginSitePOCPhone] [nvarchar](50) NULL,
	[JobOriginSitePOCEmail] [nvarchar](50) NULL,
	[JobOriginSiteName] [nvarchar](50) NULL,
	[JobOriginStreetAddress] [nvarchar](100) NULL,
	[JobOriginStreetAddress2] [nvarchar](100) NULL,
	[JobOriginCity] [nvarchar](50) NULL,
	[JobOriginState] [nvarchar](50) NULL,
	[JobOriginPostalCode] [nvarchar](50) NULL,
	[JobOriginCountry] [nvarchar](50) NULL,
	[JobOriginTimeZone] [nvarchar](15) NULL,
	[JobOriginDateTimePlanned] [datetime2](7) NULL,
	[JobOriginDateTimeActual] [datetime2](7) NULL,
	[JobOriginDateTimeBaseline] [datetime2](7) NULL,
	[JobProcessingFlags] [nvarchar](20) NULL,
	[JobDeliverySitePOC2] [nvarchar](75) NULL,
	[JobDeliverySitePOCPhone2] [nvarchar](50) NULL,
	[JobDeliverySitePOCEmail2] [nvarchar](50) NULL,
	[JobOriginSitePOC2] [nvarchar](75) NULL,
	[JobOriginSitePOCPhone2] [nvarchar](50) NULL,
	[JobOriginSitePOCEmail2] [nvarchar](50) NULL,
	[JobSellerCode] [nvarchar](20) NULL,
	[JobSellerSitePOC] [nvarchar](75) NULL,
	[JobSellerSitePOCPhone] [nvarchar](50) NULL,
	[JobSellerSitePOCEmail] [nvarchar](50) NULL,
	[JobSellerSitePOC2] [nvarchar](75) NULL,
	[JobSellerSitePOCPhone2] [nvarchar](50) NULL,
	[JobSellerSitePOCEmail2] [nvarchar](50) NULL,
	[JobSellerSiteName] [nvarchar](50) NULL,
	[JobSellerStreetAddress] [nvarchar](100) NULL,
	[JobSellerStreetAddress2] [nvarchar](100) NULL,
	[JobSellerCity] [nvarchar](50) NULL,
	[JobSellerState] [nvarchar](50) NULL,
	[JobSellerPostalCode] [nvarchar](50) NULL,
	[JobSellerCountry] [nvarchar](50) NULL,
	[JobUser01] [nvarchar](20) NULL,
	[JobUser02] [nvarchar](20) NULL,
	[JobUser03] [nvarchar](20) NULL,
	[JobUser04] [nvarchar](20) NULL,
	[JobUser05] [nvarchar](20) NULL,
	[JobStatusFlags] [nvarchar](20) NULL,
	[JobScannerFlags] [nvarchar](20) NULL,
	[ProFlags01] [nvarchar](1) NULL,
	[ProFlags02] [nvarchar](1) NULL,
	[ProFlags03] [nvarchar](1) NULL,
	[ProFlags04] [nvarchar](1) NULL,
	[ProFlags05] [nvarchar](1) NULL,
	[ProFlags06] [nvarchar](1) NULL,
	[ProFlags07] [nvarchar](1) NULL,
	[ProFlags08] [nvarchar](1) NULL,
	[ProFlags09] [nvarchar](1) NULL,
	[ProFlags10] [nvarchar](1) NULL,
	[ProFlags11] [nvarchar](1) NULL,
	[ProFlags12] [nvarchar](1) NULL,
	[ProFlags13] [nvarchar](1) NULL,
	[ProFlags14] [nvarchar](1) NULL,
	[ProFlags15] [nvarchar](1) NULL,
	[ProFlags16] [nvarchar](1) NULL,
	[ProFlags17] [nvarchar](1) NULL,
	[ProFlags18] [nvarchar](1) NULL,
	[ProFlags19] [nvarchar](1) NULL,
	[ProFlags20] [nvarchar](1) NULL,
	[EnteredBy] [nvarchar](50) NULL,
	[DateEntered] [datetime2](7) NULL,
	[ChangedBy] [nvarchar](50) NULL,
	[DateChanged] [datetime2](7) NULL,
	[JobOrderedDate] [datetime2](7) NULL,
	[JobShipmentDate] [datetime2](7) NULL,
	[JobInvoicedDate] [datetime2](7) NULL,
	[JobShipFromSiteName] [nvarchar](50) NULL,
	[JobShipFromStreetAddress] [nvarchar](100) NULL,
	[JobShipFromStreetAddress2] [nvarchar](100) NULL,
	[JobShipFromCity] [nvarchar](50) NULL,
	[JobShipFromState] [nvarchar](50) NULL,
	[JobShipFromPostalCode] [nvarchar](50) NULL,
	[JobShipFromCountry] [nvarchar](50) NULL,
	[JobShipFromSitePOC] [nvarchar](75) NULL,
	[JobShipFromSitePOCPhone] [nvarchar](50) NULL,
	[JobShipFromSitePOCEmail] [nvarchar](50) NULL,
	[JobShipFromSitePOC2] [nvarchar](75) NULL,
	[JobShipFromSitePOCPhone2] [nvarchar](50) NULL,
	[JobShipFromSitePOCEmail2] [nvarchar](50) NULL,
	[VendDCLocationId] [bigint] NULL,
	[JobElectronicInvoice] [bit] NOT NULL,
	[JobOriginStreetAddress3] [nvarchar](100) NULL,
	[JobOriginStreetAddress4] [nvarchar](100) NULL,
	[JobDeliveryStreetAddress3] [nvarchar](100) NULL,
	[JobDeliveryStreetAddress4] [nvarchar](100) NULL,
	[JobSellerStreetAddress3] [nvarchar](100) NULL,
	[JobSellerStreetAddress4] [nvarchar](100) NULL,
	[JobShipFromStreetAddress3] [nvarchar](100) NULL,
	[JobShipFromStreetAddress4] [nvarchar](100) NULL,
	[JobCubesUnitTypeId] [int] NULL,
	[JobWeightUnitTypeId] [int] NULL,
	[JobTotalWeight] [decimal](18, 2) NULL,
	[JobMileage] [decimal](18, 2) NOT NULL,
	[JobPreferredMethod] [int] NULL,
	[JobServiceOrder] [int] NULL,
	[JobServiceActual] [int] NULL,
	[IsCancelled] [bit] NULL,
	[IsJobVocSurvey] [bit] NULL,
	[JobTransitionStatusId] [int] NULL,
	[JobDriverAlert] [nvarchar](max) NULL,
	[JobIsSchedule] [bit] NULL,
	[JobSalesInvoiceNumber] [nvarchar](50) NULL,
	[JobPurchaseInvoiceNumber] [nvarchar](50) NULL,
	[UdcWhLoc] [nvarchar](20) NULL,
 CONSTRAINT [PK_JOBDL000Master] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[JOBDL000Master] ADD  CONSTRAINT [DF_JOBDL000Master_JobCompleted]  DEFAULT ((0)) FOR [JobCompleted]
GO
ALTER TABLE [dbo].[JOBDL000Master] ADD  CONSTRAINT [DF_JOBDL000Master_EnteredBy]  DEFAULT (getutcdate()) FOR [EnteredBy]
GO
ALTER TABLE [dbo].[JOBDL000Master] ADD  CONSTRAINT [DF_Table_1_CustEnteredOn]  DEFAULT (getutcdate()) FOR [DateEntered]
GO
ALTER TABLE [dbo].[JOBDL000Master] ADD  DEFAULT ((0)) FOR [JobElectronicInvoice]
GO
ALTER TABLE [dbo].[JOBDL000Master] ADD  DEFAULT ((0)) FOR [JobMileage]
GO
ALTER TABLE [dbo].[JOBDL000Master] ADD  DEFAULT ((0)) FOR [IsCancelled]
GO
ALTER TABLE [dbo].[JOBDL000Master] ADD  DEFAULT ((0)) FOR [IsJobVocSurvey]
GO
ALTER TABLE [dbo].[JOBDL000Master]  WITH CHECK ADD  CONSTRAINT [FK_JOBDL000Master_DeliveryAnalyst_CONTC000Master] FOREIGN KEY([JobDeliveryAnalystContactID])
REFERENCES [dbo].[CONTC000Master] ([Id])
GO
ALTER TABLE [dbo].[JOBDL000Master] CHECK CONSTRAINT [FK_JOBDL000Master_DeliveryAnalyst_CONTC000Master]
GO
ALTER TABLE [dbo].[JOBDL000Master]  WITH CHECK ADD  CONSTRAINT [FK_JOBDL000Master_DeliveryResponsible_CONTC000Master] FOREIGN KEY([JobDeliveryResponsibleContactID])
REFERENCES [dbo].[CONTC000Master] ([Id])
GO
ALTER TABLE [dbo].[JOBDL000Master] CHECK CONSTRAINT [FK_JOBDL000Master_DeliveryResponsible_CONTC000Master]
GO
ALTER TABLE [dbo].[JOBDL000Master]  WITH CHECK ADD  CONSTRAINT [FK_JOBDL000Master_JobCubesUnitTypeId_SYSTM000Ref_Options] FOREIGN KEY([JobCubesUnitTypeId])
REFERENCES [dbo].[SYSTM000Ref_Options] ([Id])
GO
ALTER TABLE [dbo].[JOBDL000Master] CHECK CONSTRAINT [FK_JOBDL000Master_JobCubesUnitTypeId_SYSTM000Ref_Options]
GO
ALTER TABLE [dbo].[JOBDL000Master]  WITH CHECK ADD  CONSTRAINT [FK_JOBDL000Master_JobDriver_CONTC000Master] FOREIGN KEY([JobDriverId])
REFERENCES [dbo].[CONTC000Master] ([Id])
GO
ALTER TABLE [dbo].[JOBDL000Master] CHECK CONSTRAINT [FK_JOBDL000Master_JobDriver_CONTC000Master]
GO
ALTER TABLE [dbo].[JOBDL000Master]  WITH CHECK ADD  CONSTRAINT [FK_JOBDL000Master_JobPreferredMethod_SYSTM000Ref_Options] FOREIGN KEY([JobPreferredMethod])
REFERENCES [dbo].[SYSTM000Ref_Options] ([Id])
GO
ALTER TABLE [dbo].[JOBDL000Master] CHECK CONSTRAINT [FK_JOBDL000Master_JobPreferredMethod_SYSTM000Ref_Options]
GO
ALTER TABLE [dbo].[JOBDL000Master]  WITH NOCHECK ADD  CONSTRAINT [FK_JOBDL000Master_JobQtyUnitTypeId_SYSTM000Ref_Options] FOREIGN KEY([JobQtyUnitTypeId])
REFERENCES [dbo].[SYSTM000Ref_Options] ([Id])
GO
ALTER TABLE [dbo].[JOBDL000Master] CHECK CONSTRAINT [FK_JOBDL000Master_JobQtyUnitTypeId_SYSTM000Ref_Options]
GO
ALTER TABLE [dbo].[JOBDL000Master]  WITH CHECK ADD  CONSTRAINT [FK_JOBDL000Master_JobWeightUnitTypeId_SYSTM000Ref_Options] FOREIGN KEY([JobWeightUnitTypeId])
REFERENCES [dbo].[SYSTM000Ref_Options] ([Id])
GO
ALTER TABLE [dbo].[JOBDL000Master] CHECK CONSTRAINT [FK_JOBDL000Master_JobWeightUnitTypeId_SYSTM000Ref_Options]
GO
ALTER TABLE [dbo].[JOBDL000Master]  WITH CHECK ADD  CONSTRAINT [FK_JOBDL000Master_OriginResponsible_CONTC000Master] FOREIGN KEY([JobOriginResponsibleContactID])
REFERENCES [dbo].[CONTC000Master] ([Id])
GO
ALTER TABLE [dbo].[JOBDL000Master] CHECK CONSTRAINT [FK_JOBDL000Master_OriginResponsible_CONTC000Master]
GO
ALTER TABLE [dbo].[JOBDL000Master]  WITH CHECK ADD  CONSTRAINT [FK_JOBDL000Master_PRGRM000Master] FOREIGN KEY([ProgramID])
REFERENCES [dbo].[PRGRM000Master] ([Id])
GO
ALTER TABLE [dbo].[JOBDL000Master] CHECK CONSTRAINT [FK_JOBDL000Master_PRGRM000Master]
GO
ALTER TABLE [dbo].[JOBDL000Master]  WITH CHECK ADD  CONSTRAINT [FK_JOBDL000Master_Status_SYSTM000Ref_Options] FOREIGN KEY([StatusId])
REFERENCES [dbo].[SYSTM000Ref_Options] ([Id])
GO
ALTER TABLE [dbo].[JOBDL000Master] CHECK CONSTRAINT [FK_JOBDL000Master_Status_SYSTM000Ref_Options]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Unique Job ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'JOBDL000Master', @level2type=N'COLUMN',@level2name=N'Id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Relate a Child Job for Merge In Transit (MIT)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'JOBDL000Master', @level2type=N'COLUMN',@level2name=N'JobMITJobID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Program ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'JOBDL000Master', @level2type=N'COLUMN',@level2name=N'ProgramID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Site Code (Short Text)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'JOBDL000Master', @level2type=N'COLUMN',@level2name=N'JobSiteCode'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Consignee Code Identifies Who the Customer is From Customer Source' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'JOBDL000Master', @level2type=N'COLUMN',@level2name=N'JobConsigneeCode'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Sales Order Number From Customer' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'JOBDL000Master', @level2type=N'COLUMN',@level2name=N'JobCustomerSalesOrder'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Phase of BOL Master' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'JOBDL000Master', @level2type=N'COLUMN',@level2name=N'JobBOLMaster'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Bill of Lading of Order Child to Above Master' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'JOBDL000Master', @level2type=N'COLUMN',@level2name=N'JobBOLChild'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Customer Purchase Order' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'JOBDL000Master', @level2type=N'COLUMN',@level2name=N'JobCustomerPurchaseOrder'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Provider Carrier Contract Number' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'JOBDL000Master', @level2type=N'COLUMN',@level2name=N'JobCarrierContract'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Gate Way Status Indicator' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'JOBDL000Master', @level2type=N'COLUMN',@level2name=N'JobGatewayStatus'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Job Status (Active, Completed, Postponed, there are more...)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'JOBDL000Master', @level2type=N'COLUMN',@level2name=N'StatusId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Date Last Statused' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'JOBDL000Master', @level2type=N'COLUMN',@level2name=N'JobStatusedDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Is the Job Completed' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'JOBDL000Master', @level2type=N'COLUMN',@level2name=N'JobCompleted'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Type of Job(Original,Return)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'JOBDL000Master', @level2type=N'COLUMN',@level2name=N'JobType'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Type of Shipement(Cross-Dock Shipment, Direct Shipment)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'JOBDL000Master', @level2type=N'COLUMN',@level2name=N'ShipmentType'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'From Program (Not a strong Link)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'JOBDL000Master', @level2type=N'COLUMN',@level2name=N'JobDeliveryResponsibleContactID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Delivery Point of Contact (POC) (Can Come from EDI)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'JOBDL000Master', @level2type=N'COLUMN',@level2name=N'JobDeliverySitePOC'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'POC Phone' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'JOBDL000Master', @level2type=N'COLUMN',@level2name=N'JobDeliverySitePOCPhone'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'POC Email' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'JOBDL000Master', @level2type=N'COLUMN',@level2name=N'JobDeliverySitePOCEmail'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Site Name for Delivery' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'JOBDL000Master', @level2type=N'COLUMN',@level2name=N'JobDeliverySiteName'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Street Address ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'JOBDL000Master', @level2type=N'COLUMN',@level2name=N'JobDeliveryStreetAddress'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Street Address 2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'JOBDL000Master', @level2type=N'COLUMN',@level2name=N'JobDeliveryStreetAddress2'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Delivery City' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'JOBDL000Master', @level2type=N'COLUMN',@level2name=N'JobDeliveryCity'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Deliver State' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'JOBDL000Master', @level2type=N'COLUMN',@level2name=N'JobDeliveryState'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Delivery Postal Code' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'JOBDL000Master', @level2type=N'COLUMN',@level2name=N'JobDeliveryPostalCode'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Delivery Country' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'JOBDL000Master', @level2type=N'COLUMN',@level2name=N'JobDeliveryCountry'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Delivery Time Zone' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'JOBDL000Master', @level2type=N'COLUMN',@level2name=N'JobDeliveryTimeZone'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Delivery Date Planned' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'JOBDL000Master', @level2type=N'COLUMN',@level2name=N'JobDeliveryDateTimePlanned'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Delivery Date Actual' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'JOBDL000Master', @level2type=N'COLUMN',@level2name=N'JobDeliveryDateTimeActual'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Delivery Date Baseline (When was the Original Target Date)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'JOBDL000Master', @level2type=N'COLUMN',@level2name=N'JobDeliveryDateTimeBaseline'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Delivery Comment (Job Level)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'JOBDL000Master', @level2type=N'COLUMN',@level2name=N'JobDeliveryComment'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Phone' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'JOBDL000Master', @level2type=N'COLUMN',@level2name=N'JobDeliveryRecipientPhone'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Email' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'JOBDL000Master', @level2type=N'COLUMN',@level2name=N'JobDeliveryRecipientEmail'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Latitude of the Delivery Site' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'JOBDL000Master', @level2type=N'COLUMN',@level2name=N'JobLatitude'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Longitude of the Delivery Site' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'JOBDL000Master', @level2type=N'COLUMN',@level2name=N'JobLongitude'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Responsible at Origin''s location from contact (Loose relationship)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'JOBDL000Master', @level2type=N'COLUMN',@level2name=N'JobOriginResponsibleContactID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Origin Point of Contact (POC) (Can Come from EDI)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'JOBDL000Master', @level2type=N'COLUMN',@level2name=N'JobOriginSitePOC'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Origin POC Phone' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'JOBDL000Master', @level2type=N'COLUMN',@level2name=N'JobOriginSitePOCPhone'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Origin POC Email' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'JOBDL000Master', @level2type=N'COLUMN',@level2name=N'JobOriginSitePOCEmail'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Origin - is the Front of the Delivery - Typically this would be a DC?' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'JOBDL000Master', @level2type=N'COLUMN',@level2name=N'JobOriginSiteName'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Origin - is the Front of the Delivery - Typically this would be a DC?' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'JOBDL000Master', @level2type=N'COLUMN',@level2name=N'JobOriginStreetAddress'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Origin Street Address 2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'JOBDL000Master', @level2type=N'COLUMN',@level2name=N'JobOriginStreetAddress2'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Origin City' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'JOBDL000Master', @level2type=N'COLUMN',@level2name=N'JobOriginCity'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Origin State or Province' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'JOBDL000Master', @level2type=N'COLUMN',@level2name=N'JobOriginState'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Origin Postal Code' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'JOBDL000Master', @level2type=N'COLUMN',@level2name=N'JobOriginPostalCode'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Origin Country' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'JOBDL000Master', @level2type=N'COLUMN',@level2name=N'JobOriginCountry'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Origin Time Zone' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'JOBDL000Master', @level2type=N'COLUMN',@level2name=N'JobOriginTimeZone'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Origin Date Planned' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'JOBDL000Master', @level2type=N'COLUMN',@level2name=N'JobOriginDateTimePlanned'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Origin Date Actual' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'JOBDL000Master', @level2type=N'COLUMN',@level2name=N'JobOriginDateTimeActual'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Origin Date Baseline (When was the Original Target Date)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'JOBDL000Master', @level2type=N'COLUMN',@level2name=N'JobOriginDateTimeBaseline'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'One character processing flags to highlight conditions; used by Engineering only. Flags are one character text fields alpha-numeric and issued by position in this field.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'JOBDL000Master', @level2type=N'COLUMN',@level2name=N'JobProcessingFlags'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Who Initiated the Record' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'JOBDL000Master', @level2type=N'COLUMN',@level2name=N'EnteredBy'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Date Record was Entered' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'JOBDL000Master', @level2type=N'COLUMN',@level2name=N'DateEntered'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Who changed the record' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'JOBDL000Master', @level2type=N'COLUMN',@level2name=N'ChangedBy'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Date Changed' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'JOBDL000Master', @level2type=N'COLUMN',@level2name=N'DateChanged'
GO
