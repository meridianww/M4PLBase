/****** Object:  Table [Xcbl].[AddressType]    Script Date: 2020-04-01 13:22:12 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [Xcbl].[AddressType](
	[AddressTypeId] [tinyint] NOT NULL,
	[AddressTypeName] [varchar](50) NOT NULL,
 CONSTRAINT [PK_AddressType] PRIMARY KEY CLUSTERED 
(
	[AddressTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

