ALTER TABLE [dbo].[CUST000Master] DROP CONSTRAINT [FK_CUST000Master_WorkAddress_CONTC000Master]
GO
ALTER TABLE [dbo].[CUST000Master] DROP CONSTRAINT [FK_CUST000Master_CopAddress_CONTC000Master]
GO
ALTER TABLE [dbo].[CUST000Master] DROP CONSTRAINT [FK_CUST000Master_BusiAddress_CONTC000Master]
GO

ALTER TABLE [dbo].[VEND000Master] DROP CONSTRAINT [FK_VEND000Master_BusiAddress_CONTC000Master]
GO
ALTER TABLE [dbo].[VEND000Master] DROP CONSTRAINT [FK_VEND000Master_CopAddress_CONTC000Master]
GO
ALTER TABLE [dbo].[VEND000Master] DROP CONSTRAINT [FK_VEND000Master_WorkAddress_CONTC000Master]
GO




