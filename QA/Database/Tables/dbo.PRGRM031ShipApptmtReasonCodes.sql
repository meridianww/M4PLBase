SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PRGRM031ShipApptmtReasonCodes](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[PacOrgID] [bigint] NULL,
	[PacProgramID] [bigint] NULL,
	[PacApptItem] [int] NULL,
	[PacApptReasonCode] [nvarchar](20) NULL,
	[PacApptLength] [int] NULL,
	[PacApptInternalCode] [nvarchar](20) NULL,
	[PacApptPriorityCode] [nvarchar](20) NULL,
	[PacApptTitle] [nvarchar](50) NULL,
	[PacApptDescription] [varbinary](max) NULL,
	[PacApptComment] [varbinary](max) NULL,
	[PacApptCategoryCodeId] [int] NULL,
	[PacApptUser01Code] [nvarchar](20) NULL,
	[PacApptUser02Code] [nvarchar](20) NULL,
	[PacApptUser03Code] [nvarchar](20) NULL,
	[PacApptUser04Code] [nvarchar](20) NULL,
	[PacApptUser05Code] [nvarchar](20) NULL,
	[StatusId] [int] NULL,
	[DateEntered] [datetime2](7) NULL,
	[EnteredBy] [nvarchar](50) NULL,
	[DateChanged] [datetime2](7) NULL,
	[ChangedBy] [nvarchar](50) NULL,
 CONSTRAINT [PK_PRGRM031ShipApptmtReasonCodes] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[PRGRM031ShipApptmtReasonCodes] ADD  CONSTRAINT [DF_PRGRM031ShipApptmtReasonCodes_PacDateEntered]  DEFAULT (getutcdate()) FOR [DateEntered]
GO
ALTER TABLE [dbo].[PRGRM031ShipApptmtReasonCodes]  WITH NOCHECK ADD  CONSTRAINT [FK_PRGRM031ShipApptmtReasonCodes_ORGAN000Master] FOREIGN KEY([PacOrgID])
REFERENCES [dbo].[ORGAN000Master] ([Id])
GO
ALTER TABLE [dbo].[PRGRM031ShipApptmtReasonCodes] CHECK CONSTRAINT [FK_PRGRM031ShipApptmtReasonCodes_ORGAN000Master]
GO
ALTER TABLE [dbo].[PRGRM031ShipApptmtReasonCodes]  WITH NOCHECK ADD  CONSTRAINT [FK_PRGRM031ShipApptmtReasonCodes_PRGRM000Master] FOREIGN KEY([PacProgramID])
REFERENCES [dbo].[PRGRM000Master] ([Id])
GO
ALTER TABLE [dbo].[PRGRM031ShipApptmtReasonCodes] CHECK CONSTRAINT [FK_PRGRM031ShipApptmtReasonCodes_PRGRM000Master]
GO
ALTER TABLE [dbo].[PRGRM031ShipApptmtReasonCodes]  WITH NOCHECK ADD  CONSTRAINT [FK_PRGRM031ShipApptmtReasonCodes_SYSTM000Ref_Options] FOREIGN KEY([StatusId])
REFERENCES [dbo].[SYSTM000Ref_Options] ([Id])
GO
ALTER TABLE [dbo].[PRGRM031ShipApptmtReasonCodes] CHECK CONSTRAINT [FK_PRGRM031ShipApptmtReasonCodes_SYSTM000Ref_Options]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Appointment Status Date Identification' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRGRM031ShipApptmtReasonCodes', @level2type=N'COLUMN',@level2name=N'Id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Organization Identification' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRGRM031ShipApptmtReasonCodes', @level2type=N'COLUMN',@level2name=N'PacOrgID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Program Identification' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRGRM031ShipApptmtReasonCodes', @level2type=N'COLUMN',@level2name=N'PacProgramID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Used for Ordering - This could be a Breakdown Structure' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRGRM031ShipApptmtReasonCodes', @level2type=N'COLUMN',@level2name=N'PacApptItem'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Appointment Reason Code 20 Character MAX - EDI Uses 2 Characters' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRGRM031ShipApptmtReasonCodes', @level2type=N'COLUMN',@level2name=N'PacApptReasonCode'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Length In Characters ANSI X12 214 - Two Characters Only; Default to 2 Length in characters' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRGRM031ShipApptmtReasonCodes', @level2type=N'COLUMN',@level2name=N'PacApptLength'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Appt Internal Code - What is the Reason Code Called Internally within Organization; Default to Reason Code' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRGRM031ShipApptmtReasonCodes', @level2type=N'COLUMN',@level2name=N'PacApptInternalCode'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Priority Code' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRGRM031ShipApptmtReasonCodes', @level2type=N'COLUMN',@level2name=N'PacApptPriorityCode'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Title' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRGRM031ShipApptmtReasonCodes', @level2type=N'COLUMN',@level2name=N'PacApptTitle'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Description (Rich Text) - Used to define what the code is' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRGRM031ShipApptmtReasonCodes', @level2type=N'COLUMN',@level2name=N'PacApptDescription'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Comments (Rich Text) - Used to instruct how the code should be used' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRGRM031ShipApptmtReasonCodes', @level2type=N'COLUMN',@level2name=N'PacApptComment'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Catagory Code - Used to Indicate if Reason Code is Controllable or Uncontrollable, or any other reason' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRGRM031ShipApptmtReasonCodes', @level2type=N'COLUMN',@level2name=N'PacApptCategoryCodeId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'User Defined - Use Alias Utility to Change Name - There are Five (5)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRGRM031ShipApptmtReasonCodes', @level2type=N'COLUMN',@level2name=N'PacApptUser01Code'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'User Defined - Use Alias Utility to Change Name' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRGRM031ShipApptmtReasonCodes', @level2type=N'COLUMN',@level2name=N'PacApptUser02Code'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'User Defined - Use Alias Utility to Change Name' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRGRM031ShipApptmtReasonCodes', @level2type=N'COLUMN',@level2name=N'PacApptUser03Code'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'User Defined - Use Alias Utility to Change Name' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRGRM031ShipApptmtReasonCodes', @level2type=N'COLUMN',@level2name=N'PacApptUser04Code'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'User Defined - Use Alias Utility to Change Name' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRGRM031ShipApptmtReasonCodes', @level2type=N'COLUMN',@level2name=N'PacApptUser05Code'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Active, Archive, Delete, Inactive' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRGRM031ShipApptmtReasonCodes', @level2type=N'COLUMN',@level2name=N'StatusId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Date Entered for First Time' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRGRM031ShipApptmtReasonCodes', @level2type=N'COLUMN',@level2name=N'DateEntered'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Who Entered the record' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRGRM031ShipApptmtReasonCodes', @level2type=N'COLUMN',@level2name=N'EnteredBy'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'When the record was last changed' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRGRM031ShipApptmtReasonCodes', @level2type=N'COLUMN',@level2name=N'DateChanged'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Who last changed the record' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRGRM031ShipApptmtReasonCodes', @level2type=N'COLUMN',@level2name=N'ChangedBy'
GO
