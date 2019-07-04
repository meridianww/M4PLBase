/****** Object:  Table [dbo].[NAV000Customer]    Script Date: 6/28/2019 3:12:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[NAV000Customer](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[No] [nvarchar](10) NULL,
	[PBS_Customer_Code] [nvarchar](50) NULL,
	[Name] [nvarchar](50) NULL,
	[StatusId] [int] NULL,
	[EnteredBy] [nvarchar](50) NULL,
	[DateEntered] [datetime2](7) NULL,
	[ChangedBy] [nvarchar](50) NULL,
	[DateChanged] [datetime2](7) NULL
) ON [PRIMARY]

GO


