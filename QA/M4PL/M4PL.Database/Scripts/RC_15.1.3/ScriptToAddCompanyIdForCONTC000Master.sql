ALTER TABLE [dbo].[CONTC000Master] ADD [ConCompanyId] [bigint] NULL

ALTER TABLE [dbo].[CONTC000Master]  WITH NOCHECK ADD  CONSTRAINT [FK_CONTC000Master_ConCompanyId] FOREIGN KEY([ConCompanyId])
REFERENCES [dbo].[COMP000Master] ([Id])
GO

ALTER TABLE [dbo].[CONTC000Master] CHECK CONSTRAINT [FK_CONTC000Master_ConCompanyId]
GO