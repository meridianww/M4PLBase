CREATE TYPE [Xcbl].[UttAddress] AS TABLE(
	[SummaryHeaderId] [bigint] NOT NULL,
	[AddressTypeId] [tinyint] NOT NULL,
	[Name] [varchar](60) NULL,
	[NameID] [bigint] NULL,
	[Address1] [varchar](75) NULL,
	[Address2] [varchar](75) NULL,
	[City] [varchar](75) NULL,
	[State] [varchar](25) NULL,
	[PostalCode] [varchar](15) NULL,
	[CountryCode] [varchar](10) NULL,
	[ContactName] [varchar](75) NULL,
	[ContactNumber] [varchar](80) NULL,
	[AltContName] [varchar](75) NULL,
	[AltContNumber] [varchar](80) NULL,
	[StreetAddress3] [nvarchar](75) NULL,
	[StreetAddress4] [nvarchar](75) NULL,
	[LocationID] [Varchar](150)  NULL,
    [LocationName] [Varchar](150)  NULL,
    [ContactEmail] [Varchar](256)  NULL
)
GO


