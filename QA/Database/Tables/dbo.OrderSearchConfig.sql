CREATE TABLE [dbo].[OrderSearchConfig]
(
[EntityName] [varchar](50) NOT NULL,
[LastExecutedDatetime] [datetime] NOT NULL,
[Interval] [TINYINT] NULL,
[LastLSN] [binary](10) NULL,
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[OrderSearchConfig] ADD PRIMARY KEY CLUSTERED  ([EntityName]) ON [PRIMARY]
GO