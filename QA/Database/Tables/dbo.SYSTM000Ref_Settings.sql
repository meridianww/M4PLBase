SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SYSTM000Ref_Settings](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[SysSessionTimeOut] [int] NULL,
	[SysWarningTime] [int] NULL,
	[SysMainModuleId] [int] NULL,
	[SysDefaultAction] [nvarchar](50) NULL,
	[SysStatusesIn] [nvarchar](50) NULL,
	[SysGridViewPageSizes] [nvarchar](50) NULL,
	[SysPageSize] [int] NULL,
	[SysComboBoxPageSize] [int] NULL,
	[SysThresholdPercentage] [int] NULL,
	[SysDateFormat] [nvarchar](200) NULL,
 CONSTRAINT [PK_SYSTM000Ref_Settings] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SYSTM000Ref_Settings]  WITH NOCHECK ADD  CONSTRAINT [FK_SYSTM000Ref_Settings_SYSTM000Ref_Options] FOREIGN KEY([SysMainModuleId])
REFERENCES [dbo].[SYSTM000Ref_Options] ([Id])
GO
ALTER TABLE [dbo].[SYSTM000Ref_Settings] CHECK CONSTRAINT [FK_SYSTM000Ref_Settings_SYSTM000Ref_Options]
GO
