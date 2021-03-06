SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SYSTM000ColumnSettingsByUser](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[ColUserId] [bigint] NULL,
	[ColTableName] [nvarchar](100) NULL,
	[ColSortOrder] [nvarchar](4000) NULL,
	[ColNotVisible] [nvarchar](4000) NULL,
	[ColIsFreezed] [nvarchar](4000) NULL,
	[ColIsDefault] [nvarchar](4000) NULL,
	[ColGroupBy] [nvarchar](4000) NULL,
	[ColGridLayout] [nvarchar](4000) NULL,
	[DateEntered] [datetime2](7) NULL,
	[EnteredBy] [nvarchar](50) NULL,
	[DateChanged] [datetime2](7) NULL,
	[ChangedBy] [nvarchar](50) NULL,
	[ColMask] [nvarchar](50) NULL,
 CONSTRAINT [PK__SYSTM000__3214EC07E9A12DB5] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SYSTM000ColumnSettingsByUser] ADD  CONSTRAINT [DF__SYSTM000C__DateE__2EC5E7B8]  DEFAULT (getutcdate()) FOR [DateEntered]
GO
ALTER TABLE [dbo].[SYSTM000ColumnSettingsByUser]  WITH NOCHECK ADD  CONSTRAINT [FK_SYSTM000ColumnSettingsByUser_SYSTM000Ref_Table] FOREIGN KEY([ColTableName])
REFERENCES [dbo].[SYSTM000Ref_Table] ([SysRefName])
GO
ALTER TABLE [dbo].[SYSTM000ColumnSettingsByUser] CHECK CONSTRAINT [FK_SYSTM000ColumnSettingsByUser_SYSTM000Ref_Table]
GO
