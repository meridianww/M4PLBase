SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[JOBDL020Gateways](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[JobID] [bigint] NULL,
	[ProgramID] [bigint] NULL,
	[GwyGatewaySortOrder] [int] NULL,
	[GwyGatewayCode] [nvarchar](20) NULL,
	[GwyGatewayTitle] [nvarchar](50) NULL,
	[GwyGatewayDescription] [varbinary](max) NULL,
	[GwyGatewayDuration] [decimal](18, 2) NULL,
	[GwyGatewayDefault] [bit] NULL,
	[GatewayTypeId] [int] NULL,
	[GwyGatewayAnalyst] [bigint] NULL,
	[GwyGatewayResponsible] [bigint] NULL,
	[GwyPerson] [nvarchar](50) NULL,
	[GwyPhone] [nvarchar](25) NULL,
	[GwyEmail] [nvarchar](100) NULL,
	[GwyTitle] [nvarchar](50) NULL,
	[GwyDDPCurrent] [datetime2](7) NULL,
	[GwyDDPNew] [datetime2](7) NULL,
	[GwyUprWindow] [decimal](18, 2) NULL,
	[GwyLwrWindow] [decimal](18, 2) NULL,
	[GwyUprDate] [datetime2](7) NULL,
	[GwyLwrDate] [datetime2](7) NULL,
	[GwyGatewayPCD] [datetime2](7) NULL,
	[GwyGatewayECD] [datetime2](7) NULL,
	[GwyGatewayACD] [datetime2](7) NULL,
	[GwyCompleted] [bit] NULL,
	[GatewayUnitId] [int] NULL,
	[GwyAttachments] [int] NULL,
	[GwyComment] [varbinary](max) NULL,
	[GwyProcessingFlags] [nvarchar](20) NULL,
	[GwyDateRefTypeId] [int] NULL,
	[Scanner] [bit] NULL,
	[GwyShipStatusReasonCode] [nvarchar](20) NULL,
	[GwyShipApptmtReasonCode] [nvarchar](20) NULL,
	[GwyOrderType] [nvarchar](20) NULL,
	[GwyShipmentType] [nvarchar](20) NULL,
	[StatusId] [int] NULL,
	[GwyUpdatedById] [int] NULL,
	[GwyClosedOn] [datetime2](7) NULL,
	[GwyClosedBy] [nvarchar](50) NULL,
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
	[DateEntered] [datetime2](7) NULL,
	[EnteredBy] [nvarchar](50) NULL,
	[DateChanged] [datetime2](7) NULL,
	[ChangedBy] [nvarchar](50) NULL,
	[isActionAdded] [bit] NOT NULL,
	[GwyPreferredMethod] [int] NULL,
	[xCBLHeaderId] [bigint] NULL,
	[GwyCargoId] [bigint] NULL,
	[GwyExceptionTitleId] [bigint] NULL,
	[GwyExceptionStatusId] [bigint] NULL,
	[GwyAddtionalComment] [nvarchar](max) NULL,
	[GwyDateCancelled] [datetime2](7) NULL,
	[GwyCancelOrder] [bit] NULL,
	[StatusCode] [nvarchar](50) NULL,
 CONSTRAINT [PK_JOBDL020Gateways] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[JOBDL020Gateways] ADD  CONSTRAINT [DF_JOBDL020Gateways_GwyGatewayDefault]  DEFAULT ((0)) FOR [GwyGatewayDefault]
GO
ALTER TABLE [dbo].[JOBDL020Gateways] ADD  CONSTRAINT [DF_JOBDL020Gateways_GwyCompleted]  DEFAULT ((0)) FOR [GwyCompleted]
GO
ALTER TABLE [dbo].[JOBDL020Gateways] ADD  CONSTRAINT [DF_JOBDL020Gateways_Scanner]  DEFAULT ((0)) FOR [Scanner]
GO
ALTER TABLE [dbo].[JOBDL020Gateways] ADD  CONSTRAINT [DF_Table_1_PgdDateEntered]  DEFAULT (getutcdate()) FOR [DateEntered]
GO
ALTER TABLE [dbo].[JOBDL020Gateways] ADD  DEFAULT ((0)) FOR [isActionAdded]
GO
ALTER TABLE [dbo].[JOBDL020Gateways] ADD  DEFAULT ((0)) FOR [GwyCancelOrder]
GO
ALTER TABLE [dbo].[JOBDL020Gateways]  WITH NOCHECK ADD  CONSTRAINT [FK_JOBDL020Gateways_CONTC000Master] FOREIGN KEY([GwyGatewayResponsible])
REFERENCES [dbo].[CONTC000Master] ([Id])
GO
ALTER TABLE [dbo].[JOBDL020Gateways] CHECK CONSTRAINT [FK_JOBDL020Gateways_CONTC000Master]
GO
ALTER TABLE [dbo].[JOBDL020Gateways]  WITH NOCHECK ADD  CONSTRAINT [FK_JOBDL020Gateways_GatewayDateRef_SYSTM000Ref_Options] FOREIGN KEY([GwyDateRefTypeId])
REFERENCES [dbo].[SYSTM000Ref_Options] ([Id])
GO
ALTER TABLE [dbo].[JOBDL020Gateways] CHECK CONSTRAINT [FK_JOBDL020Gateways_GatewayDateRef_SYSTM000Ref_Options]
GO
ALTER TABLE [dbo].[JOBDL020Gateways]  WITH NOCHECK ADD  CONSTRAINT [FK_JOBDL020Gateways_GatewayType_SYSTM000Ref_Options] FOREIGN KEY([GatewayTypeId])
REFERENCES [dbo].[SYSTM000Ref_Options] ([Id])
GO
ALTER TABLE [dbo].[JOBDL020Gateways] CHECK CONSTRAINT [FK_JOBDL020Gateways_GatewayType_SYSTM000Ref_Options]
GO
ALTER TABLE [dbo].[JOBDL020Gateways]  WITH NOCHECK ADD  CONSTRAINT [FK_JOBDL020Gateways_GatewayUnit_SYSTM000Ref_Options] FOREIGN KEY([GatewayUnitId])
REFERENCES [dbo].[SYSTM000Ref_Options] ([Id])
GO
ALTER TABLE [dbo].[JOBDL020Gateways] CHECK CONSTRAINT [FK_JOBDL020Gateways_GatewayUnit_SYSTM000Ref_Options]
GO
ALTER TABLE [dbo].[JOBDL020Gateways]  WITH NOCHECK ADD  CONSTRAINT [FK_JOBDL020Gateways_GatewayUpdate_SYSTM000Ref_Options] FOREIGN KEY([GwyUpdatedById])
REFERENCES [dbo].[SYSTM000Ref_Options] ([Id])
GO
ALTER TABLE [dbo].[JOBDL020Gateways] CHECK CONSTRAINT [FK_JOBDL020Gateways_GatewayUpdate_SYSTM000Ref_Options]
GO
ALTER TABLE [dbo].[JOBDL020Gateways]  WITH NOCHECK ADD  CONSTRAINT [FK_JOBDL020Gateways_GwyExceptionTitleId] FOREIGN KEY([GwyExceptionTitleId])
REFERENCES [dbo].[JOBDL022GatewayExceptionReason] ([Id])
GO
ALTER TABLE [dbo].[JOBDL020Gateways] CHECK CONSTRAINT [FK_JOBDL020Gateways_GwyExceptionTitleId]
GO
ALTER TABLE [dbo].[JOBDL020Gateways]  WITH NOCHECK ADD  CONSTRAINT [FK_JOBDL020Gateways_GwyGatewayAnalyst_CONTC000Master] FOREIGN KEY([GwyGatewayAnalyst])
REFERENCES [dbo].[CONTC000Master] ([Id])
GO
ALTER TABLE [dbo].[JOBDL020Gateways] CHECK CONSTRAINT [FK_JOBDL020Gateways_GwyGatewayAnalyst_CONTC000Master]
GO
ALTER TABLE [dbo].[JOBDL020Gateways]  WITH CHECK ADD  CONSTRAINT [FK_JOBDL020Gateways_GwyPreferredMethod_SYSTM000Ref_Options] FOREIGN KEY([GwyPreferredMethod])
REFERENCES [dbo].[SYSTM000Ref_Options] ([Id])
GO
ALTER TABLE [dbo].[JOBDL020Gateways] CHECK CONSTRAINT [FK_JOBDL020Gateways_GwyPreferredMethod_SYSTM000Ref_Options]
GO
ALTER TABLE [dbo].[JOBDL020Gateways]  WITH NOCHECK ADD  CONSTRAINT [FK_JOBDL020Gateways_InstallStatusId] FOREIGN KEY([GwyExceptionStatusId])
REFERENCES [dbo].[JOBDL023GatewayInstallStatusMaster] ([Id])
GO
ALTER TABLE [dbo].[JOBDL020Gateways] CHECK CONSTRAINT [FK_JOBDL020Gateways_InstallStatusId]
GO
ALTER TABLE [dbo].[JOBDL020Gateways]  WITH CHECK ADD  CONSTRAINT [FK_JOBDL020Gateways_JOBDL000Master] FOREIGN KEY([JobID])
REFERENCES [dbo].[JOBDL000Master] ([Id])
GO
ALTER TABLE [dbo].[JOBDL020Gateways] CHECK CONSTRAINT [FK_JOBDL020Gateways_JOBDL000Master]
GO
ALTER TABLE [dbo].[JOBDL020Gateways]  WITH NOCHECK ADD  CONSTRAINT [FK_JOBDL020Gateways_PRGRM000Master] FOREIGN KEY([ProgramID])
REFERENCES [dbo].[PRGRM000Master] ([Id])
GO
ALTER TABLE [dbo].[JOBDL020Gateways] CHECK CONSTRAINT [FK_JOBDL020Gateways_PRGRM000Master]
GO
ALTER TABLE [dbo].[JOBDL020Gateways]  WITH NOCHECK ADD  CONSTRAINT [FK_JOBDL020Gateways_Status_SYSTM000Ref_Options] FOREIGN KEY([StatusId])
REFERENCES [dbo].[SYSTM000Ref_Options] ([Id])
GO
ALTER TABLE [dbo].[JOBDL020Gateways] CHECK CONSTRAINT [FK_JOBDL020Gateways_Status_SYSTM000Ref_Options]
GO
ALTER TABLE [dbo].[JOBDL020Gateways]  WITH NOCHECK ADD  CONSTRAINT [FK_PRGRM010Ref_GatewayDefaults_GwyCargoId] FOREIGN KEY([GwyCargoId])
REFERENCES [dbo].[JOBDL010Cargo] ([Id])
GO
ALTER TABLE [dbo].[JOBDL020Gateways] CHECK CONSTRAINT [FK_PRGRM010Ref_GatewayDefaults_GwyCargoId]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Unique Gateway ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'JOBDL020Gateways', @level2type=N'COLUMN',@level2name=N'Id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Job ID to which related' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'JOBDL020Gateways', @level2type=N'COLUMN',@level2name=N'JobID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Program ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'JOBDL020Gateways', @level2type=N'COLUMN',@level2name=N'ProgramID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Gateway Execution Order' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'JOBDL020Gateways', @level2type=N'COLUMN',@level2name=N'GwyGatewaySortOrder'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Short Code' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'JOBDL020Gateways', @level2type=N'COLUMN',@level2name=N'GwyGatewayCode'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Title' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'JOBDL020Gateways', @level2type=N'COLUMN',@level2name=N'GwyGatewayTitle'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Description' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'JOBDL020Gateways', @level2type=N'COLUMN',@level2name=N'GwyGatewayDescription'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Duration (Days Hours Minutes) Positive or Negative Values' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'JOBDL020Gateways', @level2type=N'COLUMN',@level2name=N'GwyGatewayDuration'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Default Logical (Mostly for Program)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'JOBDL020Gateways', @level2type=N'COLUMN',@level2name=N'GwyGatewayDefault'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Type of Entry (Gateway, Comment, Log, Inquiry)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'JOBDL020Gateways', @level2type=N'COLUMN',@level2name=N'GatewayTypeId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Analyst Responsible (Contact ID)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'JOBDL020Gateways', @level2type=N'COLUMN',@level2name=N'GwyGatewayAnalyst'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Driver or persone Responsible to execute the Gateway (Contact ID) Do we hold on to Name and Number in record?' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'JOBDL020Gateways', @level2type=N'COLUMN',@level2name=N'GwyGatewayResponsible'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The person that the Action or Comment is related to' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'JOBDL020Gateways', @level2type=N'COLUMN',@level2name=N'GwyPerson'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Phone Number of the person' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'JOBDL020Gateways', @level2type=N'COLUMN',@level2name=N'GwyPhone'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Email Address of the person' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'JOBDL020Gateways', @level2type=N'COLUMN',@level2name=N'GwyEmail'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Title of the Action or Comment' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'JOBDL020Gateways', @level2type=N'COLUMN',@level2name=N'GwyTitle'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Current Delivery Date Planned for the Job' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'JOBDL020Gateways', @level2type=N'COLUMN',@level2name=N'GwyDDPCurrent'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'New Delivery Date Planned for the Job' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'JOBDL020Gateways', @level2type=N'COLUMN',@level2name=N'GwyDDPNew'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Upper Window value to calculate the Delivery Date Window' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'JOBDL020Gateways', @level2type=N'COLUMN',@level2name=N'GwyUprWindow'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Lower Window value to calculate the Delivery Date Window' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'JOBDL020Gateways', @level2type=N'COLUMN',@level2name=N'GwyLwrWindow'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The New Upper Delivery Date Window' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'JOBDL020Gateways', @level2type=N'COLUMN',@level2name=N'GwyUprDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The New Lower Delivery Date Window' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'JOBDL020Gateways', @level2type=N'COLUMN',@level2name=N'GwyLwrDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Planned Completion Date' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'JOBDL020Gateways', @level2type=N'COLUMN',@level2name=N'GwyGatewayPCD'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Estimated Completion Date' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'JOBDL020Gateways', @level2type=N'COLUMN',@level2name=N'GwyGatewayECD'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Actual Completion Date' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'JOBDL020Gateways', @level2type=N'COLUMN',@level2name=N'GwyGatewayACD'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Completed Flag (Yes/No)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'JOBDL020Gateways', @level2type=N'COLUMN',@level2name=N'GwyCompleted'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Units Duration?' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'JOBDL020Gateways', @level2type=N'COLUMN',@level2name=N'GatewayUnitId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Attachments for a Gateway' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'JOBDL020Gateways', @level2type=N'COLUMN',@level2name=N'GwyAttachments'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Comment' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'JOBDL020Gateways', @level2type=N'COLUMN',@level2name=N'GwyComment'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Processing Flags highlight special conditions about the data when they are found; they are used by Engineering only; Codes are single character and alpha-numeric.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'JOBDL020Gateways', @level2type=N'COLUMN',@level2name=N'GwyProcessingFlags'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Date Reference? (Pickup or Delivery)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'JOBDL020Gateways', @level2type=N'COLUMN',@level2name=N'GwyDateRefTypeId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Status Flag Completed, Active, Discarded' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'JOBDL020Gateways', @level2type=N'COLUMN',@level2name=N'StatusId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Manual, Scanner, EDI' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'JOBDL020Gateways', @level2type=N'COLUMN',@level2name=N'GwyUpdatedById'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Date and Time Closed' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'JOBDL020Gateways', @level2type=N'COLUMN',@level2name=N'GwyClosedOn'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Closed By Whom' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'JOBDL020Gateways', @level2type=N'COLUMN',@level2name=N'GwyClosedBy'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Date Gateway Was Entered' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'JOBDL020Gateways', @level2type=N'COLUMN',@level2name=N'DateEntered'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Who Initiated the Record' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'JOBDL020Gateways', @level2type=N'COLUMN',@level2name=N'EnteredBy'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Date Changed' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'JOBDL020Gateways', @level2type=N'COLUMN',@level2name=N'DateChanged'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Who Changed the Record' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'JOBDL020Gateways', @level2type=N'COLUMN',@level2name=N'ChangedBy'
GO
