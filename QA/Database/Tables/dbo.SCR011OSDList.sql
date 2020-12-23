SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SCR011OSDList](
	[OSDID] [bigint] IDENTITY(1,1) NOT NULL,
	[ProgramID] [bigint] NULL,
	[OSDItemNumber] [int] NULL,
	[OSDCode] [nvarchar](20) NULL,
	[OSDTitle] [nvarchar](50) NULL,
	[OSDType] [nvarchar](20) NULL,
	[OSDNote] [nvarchar](max) NULL,
	[StatusId] [int] NULL,
	[DateEntered] [datetime2](7) NULL,
	[EnteredBy] [nvarchar](50) NULL,
	[DateChanged] [datetime2](7) NULL,
	[ChangedBy] [nvarchar](50) NULL,
 CONSTRAINT [PK_SCR011OSDList] PRIMARY KEY CLUSTERED 
(
	[OSDID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[SCR011OSDList] ADD  CONSTRAINT [DF_SCR011OSDList_DateEntered]  DEFAULT (getutcdate()) FOR [DateEntered]
GO
ALTER TABLE [dbo].[SCR011OSDList]  WITH NOCHECK ADD  CONSTRAINT [FK_SCR011OSDList_Status_SYSTM000Ref_Options] FOREIGN KEY([StatusId])
REFERENCES [dbo].[SYSTM000Ref_Options] ([Id])
GO
ALTER TABLE [dbo].[SCR011OSDList] CHECK CONSTRAINT [FK_SCR011OSDList_Status_SYSTM000Ref_Options]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Scanner OSD Identification' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SCR011OSDList', @level2type=N'COLUMN',@level2name=N'OSDID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Program Identification' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SCR011OSDList', @level2type=N'COLUMN',@level2name=N'ProgramID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Item Number' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SCR011OSDList', @level2type=N'COLUMN',@level2name=N'OSDItemNumber'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Code -Unique' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SCR011OSDList', @level2type=N'COLUMN',@level2name=N'OSDCode'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Title for OSD' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SCR011OSDList', @level2type=N'COLUMN',@level2name=N'OSDTitle'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Short Code for Project - Must have a preceding Program' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SCR011OSDList', @level2type=N'COLUMN',@level2name=N'OSDNote'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'StatusId of OSD(Active.Inactive,Archive,Delete)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SCR011OSDList', @level2type=N'COLUMN',@level2name=N'StatusId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Date of record entered' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SCR011OSDList', @level2type=N'COLUMN',@level2name=N'DateEntered'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Record Entered by' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SCR011OSDList', @level2type=N'COLUMN',@level2name=N'EnteredBy'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Record Modified on' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SCR011OSDList', @level2type=N'COLUMN',@level2name=N'DateChanged'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Record Changed by' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SCR011OSDList', @level2type=N'COLUMN',@level2name=N'ChangedBy'
GO
