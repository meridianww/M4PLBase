SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SYSTM000VdcLocationPreferences](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[OrganizationId] [bigint] NOT NULL,
	[UserId] [bigint] NOT NULL,
	[ContactType] [int] NOT NULL,
	[LangCode] [nvarchar](10) NULL,
	[VdcLocationCode] [nvarchar](max) NULL,
 CONSTRAINT [PK_[SYSTM000VdcLocationPreferences] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[SYSTM000VdcLocationPreferences]  WITH CHECK ADD  CONSTRAINT [FK_SYSTM000VdcLocationPreferences_ORGAN000Master] FOREIGN KEY([OrganizationId])
REFERENCES [dbo].[ORGAN000Master] ([Id])
GO
ALTER TABLE [dbo].[SYSTM000VdcLocationPreferences] CHECK CONSTRAINT [FK_SYSTM000VdcLocationPreferences_ORGAN000Master]
GO
ALTER TABLE [dbo].[SYSTM000VdcLocationPreferences]  WITH CHECK ADD  CONSTRAINT [FK_SYSTM000VdcLocationPreferences_SYSTM000OpnSezMe] FOREIGN KEY([UserId])
REFERENCES [dbo].[SYSTM000OpnSezMe] ([Id])
GO
ALTER TABLE [dbo].[SYSTM000VdcLocationPreferences] CHECK CONSTRAINT [FK_SYSTM000VdcLocationPreferences_SYSTM000OpnSezMe]
GO
ALTER TABLE [dbo].[SYSTM000VdcLocationPreferences]  WITH CHECK ADD  CONSTRAINT [FK_SYSTM000VdcLocationPreferences_SYSTM000Ref_Options] FOREIGN KEY([ContactType])
REFERENCES [dbo].[SYSTM000Ref_Options] ([Id])
GO
ALTER TABLE [dbo].[SYSTM000VdcLocationPreferences] CHECK CONSTRAINT [FK_SYSTM000VdcLocationPreferences_SYSTM000Ref_Options]
GO
