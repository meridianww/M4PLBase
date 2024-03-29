SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PRGRM000Master](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[PrgOrgID] [bigint] NULL,
	[PrgCustID] [bigint] NULL,
	[PrgItemNumber] [nvarchar](20) NULL,
	[PrgProgramCode] [nvarchar](20) NULL,
	[PrgProjectCode] [nvarchar](20) NULL,
	[PrgPhaseCode] [nvarchar](20) NULL,
	[PrgProgramTitle] [nvarchar](50) NULL,
	[PrgAccountCode] [nvarchar](50) NULL,
	[DelEarliest] [decimal](18, 2) NULL,
	[DelLatest] [decimal](18, 2) NULL,
	[DelDay] [bit] NULL,
	[PckEarliest] [decimal](18, 2) NULL,
	[PckLatest] [decimal](18, 2) NULL,
	[PckDay] [bit] NULL,
	[StatusId] [int] NULL,
	[PrgDateStart] [datetime2](7) NULL,
	[PrgDateEnd] [datetime2](7) NULL,
	[PrgDeliveryTimeDefault] [datetime2](7) NULL,
	[PrgPickUpTimeDefault] [datetime2](7) NULL,
	[PrgDescription] [varbinary](max) NULL,
	[PrgNotes] [varbinary](max) NULL,
	[PrgHierarchyID] [hierarchyid] NULL,
	[PrgHierarchyLevel]  AS ([PrgHierarchyID].[GetLevel]()),
	[DateEntered] [datetime2](7) NULL,
	[EnteredBy] [nvarchar](50) NULL,
	[DateChanged] [datetime2](7) NULL,
	[ChangedBy] [nvarchar](50) NULL,
	[PrgRollUpBilling] [bit] NULL,
	[PrgRollUpBillingJobFieldId] [bigint] NULL,
	[PrgElectronicInvoice] [bit] NOT NULL,
 CONSTRAINT [PK_PRGRM000Master] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[PRGRM000Master] ADD  CONSTRAINT [DF_PRGRM000Master_DelDay]  DEFAULT ((0)) FOR [DelDay]
GO
ALTER TABLE [dbo].[PRGRM000Master] ADD  CONSTRAINT [DF_PRGRM000Master_PckDay]  DEFAULT ((0)) FOR [PckDay]
GO
ALTER TABLE [dbo].[PRGRM000Master] ADD  CONSTRAINT [DF_PRGRM000Master_PrgDateEntered]  DEFAULT (getutcdate()) FOR [DateEntered]
GO
ALTER TABLE [dbo].[PRGRM000Master] ADD  DEFAULT ((0)) FOR [PrgRollUpBilling]
GO
ALTER TABLE [dbo].[PRGRM000Master] ADD  DEFAULT ((0)) FOR [PrgElectronicInvoice]
GO
ALTER TABLE [dbo].[PRGRM000Master]  WITH NOCHECK ADD  CONSTRAINT [FK_PRGRM000Master_CUST000Master] FOREIGN KEY([PrgCustID])
REFERENCES [dbo].[CUST000Master] ([Id])
GO
ALTER TABLE [dbo].[PRGRM000Master] CHECK CONSTRAINT [FK_PRGRM000Master_CUST000Master]
GO
ALTER TABLE [dbo].[PRGRM000Master]  WITH NOCHECK ADD  CONSTRAINT [FK_PRGRM000Master_ORGAN000Master] FOREIGN KEY([PrgOrgID])
REFERENCES [dbo].[ORGAN000Master] ([Id])
GO
ALTER TABLE [dbo].[PRGRM000Master] CHECK CONSTRAINT [FK_PRGRM000Master_ORGAN000Master]
GO
ALTER TABLE [dbo].[PRGRM000Master]  WITH NOCHECK ADD  CONSTRAINT [FK_PRGRM000Master_Status_SYSTM000Ref_Options] FOREIGN KEY([StatusId])
REFERENCES [dbo].[SYSTM000Ref_Options] ([Id])
GO
ALTER TABLE [dbo].[PRGRM000Master] CHECK CONSTRAINT [FK_PRGRM000Master_Status_SYSTM000Ref_Options]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Program Identification' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRGRM000Master', @level2type=N'COLUMN',@level2name=N'Id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Key to Organization Program belongs to' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRGRM000Master', @level2type=N'COLUMN',@level2name=N'PrgOrgID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Customer ID - Who is the Customer' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRGRM000Master', @level2type=N'COLUMN',@level2name=N'PrgCustID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Order Number - Breakdown Structure' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRGRM000Master', @level2type=N'COLUMN',@level2name=N'PrgItemNumber'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Short Code for the Program' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRGRM000Master', @level2type=N'COLUMN',@level2name=N'PrgProgramCode'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Short Code for Project - Must have a preceding Program' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRGRM000Master', @level2type=N'COLUMN',@level2name=N'PrgProjectCode'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Short Code for Phase - Must have a preceding Project' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRGRM000Master', @level2type=N'COLUMN',@level2name=N'PrgPhaseCode'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Title' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRGRM000Master', @level2type=N'COLUMN',@level2name=N'PrgProgramTitle'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Revenue Account Code (Accounting) (44000 Account)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRGRM000Master', @level2type=N'COLUMN',@level2name=N'PrgAccountCode'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Program Status: Active, Delete, Archive' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRGRM000Master', @level2type=N'COLUMN',@level2name=N'StatusId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Start Date' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRGRM000Master', @level2type=N'COLUMN',@level2name=N'PrgDateStart'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Finish Date' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRGRM000Master', @level2type=N'COLUMN',@level2name=N'PrgDateEnd'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Deliery Time Default' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRGRM000Master', @level2type=N'COLUMN',@level2name=N'PrgDeliveryTimeDefault'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Pickup Time Default' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRGRM000Master', @level2type=N'COLUMN',@level2name=N'PrgPickUpTimeDefault'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Description on Program, Project, or Phase' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRGRM000Master', @level2type=N'COLUMN',@level2name=N'PrgDescription'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Program Notes' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRGRM000Master', @level2type=N'COLUMN',@level2name=N'PrgNotes'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Hierarchical Order for Programs, Projects, Phases' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRGRM000Master', @level2type=N'COLUMN',@level2name=N'PrgHierarchyID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Date Entered for First Time' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRGRM000Master', @level2type=N'COLUMN',@level2name=N'DateEntered'
GO
