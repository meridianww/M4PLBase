SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SYSTM000Ref_Dashboard](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[OrganizationId] [bigint] NULL,
	[DshMainModuleId] [int] NULL,
	[DshName] [nvarchar](100) NOT NULL,
	[DshTemplate] [varbinary](max) NULL,
	[DshDescription] [nvarchar](255) NULL,
	[DshIsDefault] [bit] NOT NULL,
	[StatusId] [int] NULL,
	[DateEntered] [datetime2](7) NULL,
	[EnteredBy] [nvarchar](50) NULL,
	[DateChanged] [datetime2](7) NULL,
	[ChangedBy] [nvarchar](50) NULL,
 CONSTRAINT [PK_SYSTM000Ref_Dashboard] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[SYSTM000Ref_Dashboard] ADD  CONSTRAINT [DF_SYSTM000Ref_Dashboard_IsDefault]  DEFAULT ((0)) FOR [DshIsDefault]
GO
ALTER TABLE [dbo].[SYSTM000Ref_Dashboard] ADD  CONSTRAINT [DF_SYSTM000Ref_Dashboard_DateEntered]  DEFAULT (getutcdate()) FOR [DateEntered]
GO
ALTER TABLE [dbo].[SYSTM000Ref_Dashboard]  WITH NOCHECK ADD  CONSTRAINT [FK_SYSTM000Ref_Dashboard_MainModule_SYSTM000Ref_Options] FOREIGN KEY([DshMainModuleId])
REFERENCES [dbo].[SYSTM000Ref_Options] ([Id])
GO
ALTER TABLE [dbo].[SYSTM000Ref_Dashboard] CHECK CONSTRAINT [FK_SYSTM000Ref_Dashboard_MainModule_SYSTM000Ref_Options]
GO
ALTER TABLE [dbo].[SYSTM000Ref_Dashboard]  WITH NOCHECK ADD  CONSTRAINT [FK_SYSTM000Ref_Dashboard_ORGAN000Master] FOREIGN KEY([OrganizationId])
REFERENCES [dbo].[ORGAN000Master] ([Id])
GO
ALTER TABLE [dbo].[SYSTM000Ref_Dashboard] CHECK CONSTRAINT [FK_SYSTM000Ref_Dashboard_ORGAN000Master]
GO
ALTER TABLE [dbo].[SYSTM000Ref_Dashboard]  WITH NOCHECK ADD  CONSTRAINT [FK_SYSTM000Ref_Dashboard_Status_SYSTM000Ref_Options] FOREIGN KEY([StatusId])
REFERENCES [dbo].[SYSTM000Ref_Options] ([Id])
GO
ALTER TABLE [dbo].[SYSTM000Ref_Dashboard] CHECK CONSTRAINT [FK_SYSTM000Ref_Dashboard_Status_SYSTM000Ref_Options]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Record Identifier' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000Ref_Dashboard', @level2type=N'COLUMN',@level2name=N'Id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Dashboard Name' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYSTM000Ref_Dashboard', @level2type=N'COLUMN',@level2name=N'DshName'
GO
