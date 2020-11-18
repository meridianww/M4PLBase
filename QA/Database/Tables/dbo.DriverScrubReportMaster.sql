SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[DriverScrubReportMaster](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[CustomerId] [bigint] NOT NULL,
	[StartDate] [datetime2](7) NOT NULL,
	[EndDate] [datetime2](7) NOT NULL,
	[Description] [varchar](max) NULL,
 CONSTRAINT [PK_DriverScrubReportMaster] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[DriverScrubReportMaster]  WITH CHECK ADD  CONSTRAINT [FK_DriverScrubReportMaster_CUST000Master] FOREIGN KEY([CustomerId])
REFERENCES [dbo].[CUST000Master] ([Id])
GO

ALTER TABLE [dbo].[DriverScrubReportMaster] CHECK CONSTRAINT [FK_DriverScrubReportMaster_CUST000Master]
GO


