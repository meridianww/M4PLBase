SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ORGAN020Financial_Cal](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[OrgID] [bigint] NULL,
	[FclPeriod] [int] NULL,
	[FclPeriodCode] [nvarchar](20) NULL,
	[FclPeriodStart] [datetime2](7) NULL,
	[FclPeriodEnd] [datetime2](7) NULL,
	[FclPeriodTitle] [nvarchar](50) NULL,
	[FclAutoShortCode] [nvarchar](15) NULL,
	[FclWorkDays] [int] NULL,
	[FinCalendarTypeId] [int] NULL,
	[StatusId] [int] NULL,
	[FclDescription] [varbinary](max) NULL,
	[DateEntered] [datetime2](7) NULL,
	[EnteredBy] [nvarchar](50) NULL,
	[DateChanged] [datetime2](7) NULL,
	[ChangedBy] [nvarchar](50) NULL,
 CONSTRAINT [PK_ORGAN020Financial_Cal] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[ORGAN020Financial_Cal] ADD  CONSTRAINT [DF_ORGAN020Financial_Cal_DateEntered]  DEFAULT (getutcdate()) FOR [DateEntered]
GO
ALTER TABLE [dbo].[ORGAN020Financial_Cal]  WITH NOCHECK ADD  CONSTRAINT [FK_ORGAN020Financial_Cal_FinCalType_SYSTM000Ref_Options] FOREIGN KEY([FinCalendarTypeId])
REFERENCES [dbo].[SYSTM000Ref_Options] ([Id])
GO
ALTER TABLE [dbo].[ORGAN020Financial_Cal] CHECK CONSTRAINT [FK_ORGAN020Financial_Cal_FinCalType_SYSTM000Ref_Options]
GO
ALTER TABLE [dbo].[ORGAN020Financial_Cal]  WITH NOCHECK ADD  CONSTRAINT [FK_ORGAN020Financial_Cal_ORGAN000Master] FOREIGN KEY([OrgID])
REFERENCES [dbo].[ORGAN000Master] ([Id])
GO
ALTER TABLE [dbo].[ORGAN020Financial_Cal] CHECK CONSTRAINT [FK_ORGAN020Financial_Cal_ORGAN000Master]
GO
ALTER TABLE [dbo].[ORGAN020Financial_Cal]  WITH NOCHECK ADD  CONSTRAINT [FK_ORGAN020Financial_Cal_Status_SYSTM000Ref_Options] FOREIGN KEY([StatusId])
REFERENCES [dbo].[SYSTM000Ref_Options] ([Id])
GO
ALTER TABLE [dbo].[ORGAN020Financial_Cal] CHECK CONSTRAINT [FK_ORGAN020Financial_Cal_Status_SYSTM000Ref_Options]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Financial Calendar ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ORGAN020Financial_Cal', @level2type=N'COLUMN',@level2name=N'Id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Organizational ID Owning This Calendar' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ORGAN020Financial_Cal', @level2type=N'COLUMN',@level2name=N'OrgID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Order number presumed to be a period within one year' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ORGAN020Financial_Cal', @level2type=N'COLUMN',@level2name=N'FclPeriod'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Period Code' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ORGAN020Financial_Cal', @level2type=N'COLUMN',@level2name=N'FclPeriodCode'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Date Period Starts (Consider 4-4-5 or 13 Month Periods)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ORGAN020Financial_Cal', @level2type=N'COLUMN',@level2name=N'FclPeriodStart'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Date Period Ends' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ORGAN020Financial_Cal', @level2type=N'COLUMN',@level2name=N'FclPeriodEnd'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Period Title (Fully Written Out)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ORGAN020Financial_Cal', @level2type=N'COLUMN',@level2name=N'FclPeriodTitle'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Period Title (Fully Written Out)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ORGAN020Financial_Cal', @level2type=N'COLUMN',@level2name=N'FclAutoShortCode'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Workdays Between Dates Including Holidays' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ORGAN020Financial_Cal', @level2type=N'COLUMN',@level2name=N'FclWorkDays'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Holiday or Financial (Default is Financial)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ORGAN020Financial_Cal', @level2type=N'COLUMN',@level2name=N'FinCalendarTypeId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Holiday or Financial (Default is Financial)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ORGAN020Financial_Cal', @level2type=N'COLUMN',@level2name=N'FclDescription'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Date Entered' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ORGAN020Financial_Cal', @level2type=N'COLUMN',@level2name=N'DateEntered'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Entered By (User)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ORGAN020Financial_Cal', @level2type=N'COLUMN',@level2name=N'EnteredBy'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Modified On This Date' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ORGAN020Financial_Cal', @level2type=N'COLUMN',@level2name=N'DateChanged'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Modified By (User)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ORGAN020Financial_Cal', @level2type=N'COLUMN',@level2name=N'ChangedBy'
GO
