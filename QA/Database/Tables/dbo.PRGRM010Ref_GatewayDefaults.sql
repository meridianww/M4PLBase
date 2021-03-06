SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PRGRM010Ref_GatewayDefaults](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[PgdProgramID] [bigint] NULL,
	[PgdGatewaySortOrder] [int] NULL,
	[PgdGatewayCode] [nvarchar](20) NULL,
	[PgdGatewayTitle] [nvarchar](50) NULL,
	[PgdGatewayDescription] [varbinary](max) NULL,
	[PgdGatewayDuration] [decimal](18, 0) NULL,
	[UnitTypeId] [int] NULL,
	[PgdGatewayDefault] [bit] NULL,
	[GatewayTypeId] [int] NULL,
	[GatewayDateRefTypeId] [int] NULL,
	[Scanner] [bit] NULL,
	[PgdShipStatusReasonCode] [nvarchar](20) NULL,
	[PgdShipApptmtReasonCode] [nvarchar](20) NULL,
	[PgdOrderType] [nvarchar](20) NULL,
	[PgdShipmentType] [nvarchar](20) NULL,
	[PgdGatewayResponsible] [bigint] NULL,
	[PgdGatewayAnalyst] [bigint] NULL,
	[StatusId] [int] NULL,
	[PgdGatewayComment] [varbinary](max) NULL,
	[DateEntered] [datetime2](7) NULL,
	[EnteredBy] [nvarchar](50) NULL,
	[DateChanged] [datetime2](7) NULL,
	[ChangedBy] [nvarchar](50) NULL,
	[PgdGatewayDefaultComplete] [bit] NULL,
	[InstallStatusId] [bigint] NULL,
	[MappingId] [varchar](100) NULL,
	[PgdGatewayStatusCode] [nvarchar](20) NULL,
	[PgdGatewayDefaultForJob] [bit] NULL,
	[TransitionStatusId] [int] NULL,
 CONSTRAINT [PK_PRGRM010Ref_GatewayDefaults] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[PRGRM010Ref_GatewayDefaults] ADD  CONSTRAINT [DF_PRGRM010Ref_GatewayDefaults_PgdGatewayDefault]  DEFAULT ((0)) FOR [PgdGatewayDefault]
GO
ALTER TABLE [dbo].[PRGRM010Ref_GatewayDefaults] ADD  CONSTRAINT [DF_PRGRM010Ref_GatewayDefaults_Scanner]  DEFAULT ((0)) FOR [Scanner]
GO
ALTER TABLE [dbo].[PRGRM010Ref_GatewayDefaults] ADD  CONSTRAINT [DF_PRGRM010Ref_GatewayDefaults_PgdDateEntered]  DEFAULT (getutcdate()) FOR [DateEntered]
GO
ALTER TABLE [dbo].[PRGRM010Ref_GatewayDefaults] ADD  DEFAULT ((0)) FOR [PgdGatewayDefaultComplete]
GO
ALTER TABLE [dbo].[PRGRM010Ref_GatewayDefaults]  WITH NOCHECK ADD  CONSTRAINT [FK_PRGRM010Ref_GatewayDefaults_Analyst_CONTC000Master] FOREIGN KEY([PgdGatewayAnalyst])
REFERENCES [dbo].[CONTC000Master] ([Id])
GO
ALTER TABLE [dbo].[PRGRM010Ref_GatewayDefaults] CHECK CONSTRAINT [FK_PRGRM010Ref_GatewayDefaults_Analyst_CONTC000Master]
GO
ALTER TABLE [dbo].[PRGRM010Ref_GatewayDefaults]  WITH NOCHECK ADD  CONSTRAINT [FK_PRGRM010Ref_GatewayDefaults_DateRef_SYSTM000Ref_Options] FOREIGN KEY([GatewayDateRefTypeId])
REFERENCES [dbo].[SYSTM000Ref_Options] ([Id])
GO
ALTER TABLE [dbo].[PRGRM010Ref_GatewayDefaults] CHECK CONSTRAINT [FK_PRGRM010Ref_GatewayDefaults_DateRef_SYSTM000Ref_Options]
GO
ALTER TABLE [dbo].[PRGRM010Ref_GatewayDefaults]  WITH NOCHECK ADD  CONSTRAINT [FK_PRGRM010Ref_GatewayDefaults_InstallStatusId] FOREIGN KEY([InstallStatusId])
REFERENCES [dbo].[JOBDL023GatewayInstallStatusMaster] ([Id])
GO
ALTER TABLE [dbo].[PRGRM010Ref_GatewayDefaults] CHECK CONSTRAINT [FK_PRGRM010Ref_GatewayDefaults_InstallStatusId]
GO
ALTER TABLE [dbo].[PRGRM010Ref_GatewayDefaults]  WITH NOCHECK ADD  CONSTRAINT [FK_PRGRM010Ref_GatewayDefaults_PRGRM000Master] FOREIGN KEY([PgdProgramID])
REFERENCES [dbo].[PRGRM000Master] ([Id])
GO
ALTER TABLE [dbo].[PRGRM010Ref_GatewayDefaults] CHECK CONSTRAINT [FK_PRGRM010Ref_GatewayDefaults_PRGRM000Master]
GO
ALTER TABLE [dbo].[PRGRM010Ref_GatewayDefaults]  WITH NOCHECK ADD  CONSTRAINT [FK_PRGRM010Ref_GatewayDefaults_Responsible_CONTC000Master] FOREIGN KEY([PgdGatewayResponsible])
REFERENCES [dbo].[CONTC000Master] ([Id])
GO
ALTER TABLE [dbo].[PRGRM010Ref_GatewayDefaults] CHECK CONSTRAINT [FK_PRGRM010Ref_GatewayDefaults_Responsible_CONTC000Master]
GO
ALTER TABLE [dbo].[PRGRM010Ref_GatewayDefaults]  WITH NOCHECK ADD  CONSTRAINT [FK_PRGRM010Ref_GatewayDefaults_Status_SYSTM000Ref_Options] FOREIGN KEY([StatusId])
REFERENCES [dbo].[SYSTM000Ref_Options] ([Id])
GO
ALTER TABLE [dbo].[PRGRM010Ref_GatewayDefaults] CHECK CONSTRAINT [FK_PRGRM010Ref_GatewayDefaults_Status_SYSTM000Ref_Options]
GO
ALTER TABLE [dbo].[PRGRM010Ref_GatewayDefaults]  WITH NOCHECK ADD  CONSTRAINT [FK_PRGRM010Ref_GatewayDefaults_Transition_SYSTM000Ref_Options] FOREIGN KEY([TransitionStatusId])
REFERENCES [dbo].[SYSTM000Ref_Options] ([Id])
GO
ALTER TABLE [dbo].[PRGRM010Ref_GatewayDefaults] CHECK CONSTRAINT [FK_PRGRM010Ref_GatewayDefaults_Transition_SYSTM000Ref_Options]
GO
ALTER TABLE [dbo].[PRGRM010Ref_GatewayDefaults]  WITH NOCHECK ADD  CONSTRAINT [FK_PRGRM010Ref_GatewayDefaults_Type_SYSTM000Ref_Options] FOREIGN KEY([GatewayTypeId])
REFERENCES [dbo].[SYSTM000Ref_Options] ([Id])
GO
ALTER TABLE [dbo].[PRGRM010Ref_GatewayDefaults] CHECK CONSTRAINT [FK_PRGRM010Ref_GatewayDefaults_Type_SYSTM000Ref_Options]
GO
ALTER TABLE [dbo].[PRGRM010Ref_GatewayDefaults]  WITH NOCHECK ADD  CONSTRAINT [FK_PRGRM010Ref_GatewayDefaults_Unit_SYSTM000Ref_Options] FOREIGN KEY([UnitTypeId])
REFERENCES [dbo].[SYSTM000Ref_Options] ([Id])
GO
ALTER TABLE [dbo].[PRGRM010Ref_GatewayDefaults] CHECK CONSTRAINT [FK_PRGRM010Ref_GatewayDefaults_Unit_SYSTM000Ref_Options]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Program Gateway Record ID (Used as Reference)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRGRM010Ref_GatewayDefaults', @level2type=N'COLUMN',@level2name=N'Id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Program Reference ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRGRM010Ref_GatewayDefaults', @level2type=N'COLUMN',@level2name=N'PgdProgramID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Order other than by Code' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRGRM010Ref_GatewayDefaults', @level2type=N'COLUMN',@level2name=N'PgdGatewaySortOrder'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Short Code' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRGRM010Ref_GatewayDefaults', @level2type=N'COLUMN',@level2name=N'PgdGatewayCode'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Title' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRGRM010Ref_GatewayDefaults', @level2type=N'COLUMN',@level2name=N'PgdGatewayTitle'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Long Description for Record Meaning' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRGRM010Ref_GatewayDefaults', @level2type=N'COLUMN',@level2name=N'PgdGatewayDescription'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Duration Positive or Negative Value' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRGRM010Ref_GatewayDefaults', @level2type=N'COLUMN',@level2name=N'PgdGatewayDuration'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Short Code' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRGRM010Ref_GatewayDefaults', @level2type=N'COLUMN',@level2name=N'UnitTypeId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Is a Default' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRGRM010Ref_GatewayDefaults', @level2type=N'COLUMN',@level2name=N'PgdGatewayDefault'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Values: Gateway, Action, Document, Comment, possible other values' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRGRM010Ref_GatewayDefaults', @level2type=N'COLUMN',@level2name=N'GatewayTypeId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'List to set by Manual, EDI, SCAN, xCBL, Electronic, Manual (Default Value)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRGRM010Ref_GatewayDefaults', @level2type=N'COLUMN',@level2name=N'GatewayDateRefTypeId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Comments about this entry' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRGRM010Ref_GatewayDefaults', @level2type=N'COLUMN',@level2name=N'PgdGatewayComment'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Date Gateway Was Entered' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRGRM010Ref_GatewayDefaults', @level2type=N'COLUMN',@level2name=N'DateEntered'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Who Initiated the Record' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRGRM010Ref_GatewayDefaults', @level2type=N'COLUMN',@level2name=N'EnteredBy'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Date Changed' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRGRM010Ref_GatewayDefaults', @level2type=N'COLUMN',@level2name=N'DateChanged'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Who Changed the Record' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRGRM010Ref_GatewayDefaults', @level2type=N'COLUMN',@level2name=N'ChangedBy'
GO
