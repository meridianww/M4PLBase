SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Job080ReportColumnRelation](
	[ReportId] [int] NULL,
	[ColumnId] [bigint] NULL
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[Job080ReportColumnRelation]  WITH CHECK ADD  CONSTRAINT [FK_Job080ReportColumnRelation_SYSTM000ColumnsAlias] FOREIGN KEY([ColumnId])
REFERENCES [dbo].[SYSTM000ColumnsAlias] ([Id])
GO

ALTER TABLE [dbo].[Job080ReportColumnRelation] CHECK CONSTRAINT [FK_Job080ReportColumnRelation_SYSTM000ColumnsAlias]
GO

ALTER TABLE [dbo].[Job080ReportColumnRelation]  WITH CHECK ADD  CONSTRAINT [FK_Job080ReportColumnRelation_SYSTM000Ref_Options] FOREIGN KEY([ReportId])
REFERENCES [dbo].[SYSTM000Ref_Options] ([Id])
GO

ALTER TABLE [dbo].[Job080ReportColumnRelation] CHECK CONSTRAINT [FK_Job080ReportColumnRelation_SYSTM000Ref_Options]
GO


