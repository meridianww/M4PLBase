SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SYSTM000ColumnsAlias](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[LangCode] [nvarchar](10) NULL,
	[ColTableName] [nvarchar](100) NOT NULL,
	[ColAssociatedTableName] [nvarchar](100) NULL,
	[ColColumnName] [nvarchar](50) NOT NULL,
	[ColAliasName] [nvarchar](50) NULL,
	[ColCaption] [nvarchar](50) NULL,
	[ColLookupId] [int] NULL,
	[ColLookupCode] [nvarchar](100) NULL,
	[ColDescription] [nvarchar](255) NULL,
	[ColSortOrder] [int] NULL,
	[ColIsReadOnly] [bit] NULL,
	[ColIsVisible] [bit] NOT NULL,
	[ColIsDefault] [bit] NOT NULL,
	[StatusId] [int] NULL,
	[ColDisplayFormat] [nvarchar](200) NULL,
	[ColAllowNegativeValue] [bit] NULL,
	[ColIsGroupBy] [bit] NOT NULL,
	[ColMask] [varchar](25) NULL,
	[IsGridColumn] [bit] NULL,
	[ColGridAliasName] [varchar](max) NULL,
 CONSTRAINT [PK__tmp_ms_x__D73B5B5DF9D6D995] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[SYSTM000ColumnsAlias] ADD  CONSTRAINT [DF__SYSTM000C__ColIs__22751F6C]  DEFAULT ((0)) FOR [ColIsVisible]
GO
ALTER TABLE [dbo].[SYSTM000ColumnsAlias] ADD  CONSTRAINT [DF__SYSTM000C__ColIs__236943A5]  DEFAULT ((0)) FOR [ColIsDefault]
GO
ALTER TABLE [dbo].[SYSTM000ColumnsAlias] ADD  CONSTRAINT [DF__SYSTM000C__ColIs__7E188EBC]  DEFAULT ((0)) FOR [ColIsGroupBy]
GO
