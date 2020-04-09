SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [Xcbl].[Address](
	[AddressId] [bigint] IDENTITY(1,1) NOT NULL,
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
	[LocationID] [varchar](150) NULL,
	[LocationName] [varchar](150) NULL,
	[ContactEmail] [varchar](256) NULL,
 CONSTRAINT [PK_Address] PRIMARY KEY CLUSTERED 
(
	[AddressId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [Xcbl].[Address]  WITH CHECK ADD  CONSTRAINT [FK_Address_AddressType] FOREIGN KEY([AddressTypeId])
REFERENCES [Xcbl].[AddressType] ([AddressTypeId])
GO

ALTER TABLE [Xcbl].[Address] CHECK CONSTRAINT [FK_Address_AddressType]
GO

ALTER TABLE [Xcbl].[Address]  WITH CHECK ADD  CONSTRAINT [FK_Address_SummaryHeaderId] FOREIGN KEY([SummaryHeaderId])
REFERENCES [Xcbl].[SummaryHeader] ([SummaryHeaderId])
GO

ALTER TABLE [Xcbl].[Address] CHECK CONSTRAINT [FK_Address_SummaryHeaderId]
GO


