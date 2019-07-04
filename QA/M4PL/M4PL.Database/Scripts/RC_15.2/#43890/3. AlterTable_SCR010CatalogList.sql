ALTER TABLE [dbo].[SCR010CatalogList]
ALTER COLUMN CatalogWLHUoM int;
GO

ALTER TABLE [dbo].[SCR010CatalogList]  WITH CHECK ADD  CONSTRAINT [FK_SCR010CatalogList_CatalogWLHUoM_SYSTM000Ref_Options] FOREIGN KEY([CatalogWLHUoM])
REFERENCES [dbo].[SYSTM000Ref_Options] ([Id])
GO

ALTER TABLE [dbo].[SCR010CatalogList] CHECK CONSTRAINT [FK_SCR010CatalogList_CatalogWLHUoM_SYSTM000Ref_Options]
GO

ALTER TABLE [dbo].[SCR010CatalogList]
ALTER COLUMN CatalogWeight int;
GO

ALTER TABLE [dbo].[SCR010CatalogList]  WITH CHECK ADD  CONSTRAINT [FK_SCR010CatalogList_CatalogWeight_SYSTM000Ref_Options] FOREIGN KEY([CatalogWeight])
REFERENCES [dbo].[SYSTM000Ref_Options] ([Id])
GO

ALTER TABLE [dbo].[SCR010CatalogList] CHECK CONSTRAINT [FK_SCR010CatalogList_CatalogWeight_SYSTM000Ref_Options]
GO