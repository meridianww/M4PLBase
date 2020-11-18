SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[AWCDriverScrubReport](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[DriverScrubReportMasterId] [int] NOT NULL,
	[QMSShippedOn] [nvarchar](1000) NULL,
	[QMSPSDisposition] [nvarchar](1000) NULL,
	[QMSStatusDescription] [nvarchar](1000) NULL,
	[FouthParty] [nvarchar](1000) NULL,
	[ThirdParty] [nvarchar](1000) NULL,
	[ActualControlId] [nvarchar](150) NULL,
	[QMSControlId] [nvarchar](150) NULL,
	[QRCGrouping] [nvarchar](150) NULL,
	[QRCDescription] [nvarchar](1000) NULL,
	[ProductCategory] [nvarchar](150) NULL,
	[ProductSubCategory] [nvarchar](150) NULL,
	[ProductSubCategory2] [nvarchar](150) NULL,
	[ModelName] [nvarchar](1000) NULL,
	[CustomerBusinessType] [nvarchar](1000) NULL,
	[ChannelCD] [nvarchar](1000) NULL,
	[NationalAccountName] [nvarchar](1000) NULL,
	[CustomerName] [nvarchar](1000) NULL,
	[ShipFromLocation] [nvarchar](150) NULL,
	[QMSRemark] [varchar](max) NULL,
	[DaysToAccept] [int] NULL,
	[QMSTotalUnit] [int] NULL,
	[QMSTotalPrice] [money] NULL,
	[EnteredBy] [nvarchar](150) NULL,
	[EnteredDate] [datetime2](7) NOT NULL,
 CONSTRAINT [PK_AWCDriverScrubReport] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[AWCDriverScrubReport]  WITH CHECK ADD  CONSTRAINT [FK_AWCDriverScrubReport_DriverScrubReportMaster] FOREIGN KEY([DriverScrubReportMasterId])
REFERENCES [dbo].[DriverScrubReportMaster] ([Id])
GO

ALTER TABLE [dbo].[AWCDriverScrubReport] CHECK CONSTRAINT [FK_AWCDriverScrubReport_DriverScrubReportMaster]
GO


