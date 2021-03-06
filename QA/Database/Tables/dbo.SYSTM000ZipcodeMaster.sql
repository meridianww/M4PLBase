SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SYSTM000ZipcodeMaster](
	[Zipcode] [nvarchar](15) NOT NULL,
	[ZipCity] [nvarchar](50) NULL,
	[ZipState] [nvarchar](50) NULL,
	[ZipLatitude] [float] NULL,
	[ZipLongitude] [float] NULL,
	[ZipTimezone] [float] NULL,
	[ZipDST] [float] NULL,
	[MrktID] [bigint] NULL,
	[DateEntered] [datetime2](7) NULL,
	[EnteredBy] [nvarchar](50) NULL,
	[DateChanged] [datetime2](7) NULL,
	[ChangedBy] [nvarchar](50) NULL,
 CONSTRAINT [PK_SYSTM000ZipcodeMaster] PRIMARY KEY CLUSTERED 
(
	[Zipcode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SYSTM000ZipcodeMaster] ADD  CONSTRAINT [DF_SYSTM000ZipcodeMaster_DateEntered]  DEFAULT (getutcdate()) FOR [DateEntered]
GO
ALTER TABLE [dbo].[SYSTM000ZipcodeMaster]  WITH NOCHECK ADD  CONSTRAINT [FK_SYSTM000ZipcodeMaster_ORGAN002MRKT_OrgSupport] FOREIGN KEY([MrktID])
REFERENCES [dbo].[ORGAN002MRKT_OrgSupport] ([Id])
GO
ALTER TABLE [dbo].[SYSTM000ZipcodeMaster] CHECK CONSTRAINT [FK_SYSTM000ZipcodeMaster_ORGAN002MRKT_OrgSupport]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Date Zipcode Was Entered' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000ZipcodeMaster', @level2type=N'COLUMN',@level2name=N'DateEntered'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Who Initiated the Record' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000ZipcodeMaster', @level2type=N'COLUMN',@level2name=N'EnteredBy'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Date Changed' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000ZipcodeMaster', @level2type=N'COLUMN',@level2name=N'DateChanged'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Who Changed the record' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000ZipcodeMaster', @level2type=N'COLUMN',@level2name=N'ChangedBy'
GO
