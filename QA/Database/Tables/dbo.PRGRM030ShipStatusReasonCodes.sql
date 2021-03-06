SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PRGRM030ShipStatusReasonCodes](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[PscOrgID] [bigint] NULL,
	[PscProgramID] [bigint] NULL,
	[PscShipItem] [int] NULL,
	[PscShipReasonCode] [nvarchar](20) NULL,
	[PscShipLength] [int] NULL,
	[PscShipInternalCode] [nvarchar](20) NULL,
	[PscShipPriorityCode] [nvarchar](20) NULL,
	[PscShipTitle] [nvarchar](50) NULL,
	[PscShipDescription] [varbinary](max) NULL,
	[PscShipComment] [varbinary](max) NULL,
	[PscShipCategoryCode] [nvarchar](20) NULL,
	[PscShipUser01Code] [nvarchar](20) NULL,
	[PscShipUser02Code] [nvarchar](20) NULL,
	[PscShipUser03Code] [nvarchar](20) NULL,
	[PscShipUser04Code] [nvarchar](20) NULL,
	[PscShipUser05Code] [nvarchar](20) NULL,
	[StatusId] [int] NULL,
	[DateEntered] [datetime2](7) NULL,
	[EnteredBy] [nvarchar](50) NULL,
	[DateChanged] [datetime2](7) NULL,
	[ChangedBy] [nvarchar](50) NULL,
 CONSTRAINT [PK_PRGRM030ShipStatusReasonCodes] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[PRGRM030ShipStatusReasonCodes] ADD  CONSTRAINT [DF_PRGRM030ShipStatusReasonCodes_PscDateEntered]  DEFAULT (getutcdate()) FOR [DateEntered]
GO
ALTER TABLE [dbo].[PRGRM030ShipStatusReasonCodes]  WITH NOCHECK ADD  CONSTRAINT [FK_PRGRM030ShipStatusReasonCodes_ORGAN000Master] FOREIGN KEY([PscOrgID])
REFERENCES [dbo].[ORGAN000Master] ([Id])
GO
ALTER TABLE [dbo].[PRGRM030ShipStatusReasonCodes] CHECK CONSTRAINT [FK_PRGRM030ShipStatusReasonCodes_ORGAN000Master]
GO
ALTER TABLE [dbo].[PRGRM030ShipStatusReasonCodes]  WITH NOCHECK ADD  CONSTRAINT [FK_PRGRM030ShipStatusReasonCodes_PRGRM000Master] FOREIGN KEY([PscProgramID])
REFERENCES [dbo].[PRGRM000Master] ([Id])
GO
ALTER TABLE [dbo].[PRGRM030ShipStatusReasonCodes] CHECK CONSTRAINT [FK_PRGRM030ShipStatusReasonCodes_PRGRM000Master]
GO
ALTER TABLE [dbo].[PRGRM030ShipStatusReasonCodes]  WITH NOCHECK ADD  CONSTRAINT [FK_PRGRM030ShipStatusReasonCodes_Status_SYSTM000Ref_Options] FOREIGN KEY([StatusId])
REFERENCES [dbo].[SYSTM000Ref_Options] ([Id])
GO
ALTER TABLE [dbo].[PRGRM030ShipStatusReasonCodes] CHECK CONSTRAINT [FK_PRGRM030ShipStatusReasonCodes_Status_SYSTM000Ref_Options]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ship Status DAte Identification' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRGRM030ShipStatusReasonCodes', @level2type=N'COLUMN',@level2name=N'Id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Organization Identification' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRGRM030ShipStatusReasonCodes', @level2type=N'COLUMN',@level2name=N'PscOrgID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Program Identification' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRGRM030ShipStatusReasonCodes', @level2type=N'COLUMN',@level2name=N'PscProgramID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Used for Ordering - This could be a Breakdown Structure' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRGRM030ShipStatusReasonCodes', @level2type=N'COLUMN',@level2name=N'PscShipItem'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Shipment Reason Code 20 Character MAX - EDI Uses 2 Characters' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRGRM030ShipStatusReasonCodes', @level2type=N'COLUMN',@level2name=N'PscShipReasonCode'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Length In Characters ANSI X12 214 - Two Characters Only; Default to 2 Length in characters' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRGRM030ShipStatusReasonCodes', @level2type=N'COLUMN',@level2name=N'PscShipLength'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Internal Code - What is the Reason Code Called Internally within Organization; Default to Reason Code' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRGRM030ShipStatusReasonCodes', @level2type=N'COLUMN',@level2name=N'PscShipInternalCode'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Priority Code' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRGRM030ShipStatusReasonCodes', @level2type=N'COLUMN',@level2name=N'PscShipPriorityCode'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Title' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRGRM030ShipStatusReasonCodes', @level2type=N'COLUMN',@level2name=N'PscShipTitle'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Description (Rich Text) - Used to define what the code is' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRGRM030ShipStatusReasonCodes', @level2type=N'COLUMN',@level2name=N'PscShipDescription'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Comments (Rich Text) - Used to instruct how the code should be used' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRGRM030ShipStatusReasonCodes', @level2type=N'COLUMN',@level2name=N'PscShipComment'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Catagory Code - Used to Indicate if Reason Code is Controllable or UnCOntrollable, or any other reason' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRGRM030ShipStatusReasonCodes', @level2type=N'COLUMN',@level2name=N'PscShipCategoryCode'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'User Defined - Use Alias Utility to Change Name - There are Five (5)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRGRM030ShipStatusReasonCodes', @level2type=N'COLUMN',@level2name=N'PscShipUser01Code'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'User Defined - Use Alias Utility to Change Name' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRGRM030ShipStatusReasonCodes', @level2type=N'COLUMN',@level2name=N'PscShipUser02Code'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'User Defined - Use Alias Utility to Change Name' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRGRM030ShipStatusReasonCodes', @level2type=N'COLUMN',@level2name=N'PscShipUser03Code'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'User Defined - Use Alias Utility to Change Name' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRGRM030ShipStatusReasonCodes', @level2type=N'COLUMN',@level2name=N'PscShipUser04Code'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'User Defined - Use Alias Utility to Change Name' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRGRM030ShipStatusReasonCodes', @level2type=N'COLUMN',@level2name=N'PscShipUser05Code'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Active, Archive, Delete, Inactive' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRGRM030ShipStatusReasonCodes', @level2type=N'COLUMN',@level2name=N'StatusId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Date Entered for First Time' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRGRM030ShipStatusReasonCodes', @level2type=N'COLUMN',@level2name=N'DateEntered'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Who Entered the record' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRGRM030ShipStatusReasonCodes', @level2type=N'COLUMN',@level2name=N'EnteredBy'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'When the record was last changed' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRGRM030ShipStatusReasonCodes', @level2type=N'COLUMN',@level2name=N'DateChanged'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Who last changed the record' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRGRM030ShipStatusReasonCodes', @level2type=N'COLUMN',@level2name=N'ChangedBy'
GO
