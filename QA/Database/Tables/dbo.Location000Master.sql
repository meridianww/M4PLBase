SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Location000Master](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[PostalCode] [varchar](10) NULL,
	[City] [varchar](50) NULL,
	[State] [varchar](50) NULL,
	[StateCode] [char](2) NULL,
	[TimeZoneShortName] [varchar](20) NULL,
	[UTC] [int] NULL,
	[IsDaylightSaving] [bit] NULL,
	[GeoLocation] [geography] NULL,
	[Latitude] [decimal](18, 15) NULL,
	[Longitude] [decimal](18, 15) NULL,
	[Country] [varchar](3) NULL,
	[TimeZone] [varchar](150) NULL,
	[TimeZoneAbbreviation] [varchar](150) NULL,
 CONSTRAINT [PK_Location000Master] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
