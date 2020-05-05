SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Location000Master](
	[PostalCode] [varchar](10) NULL,
	[City] [varchar](50) NULL,
	[StateCode] [varchar](2) NULL,
	[Latitude] [decimal](18, 15) NULL,
	[Longitude] [decimal](18, 15) NULL,
	[UTC] [int] NULL,
	[IsDaylightSaving] [bit] NULL,
	[TimeZone] [varchar](500) NULL,
	[TimeZoneAbbreviation] [varchar](10) NULL,
	[GeoLocation] [geography] NULL,
	[TimeZoneShortName] [varchar](50) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
