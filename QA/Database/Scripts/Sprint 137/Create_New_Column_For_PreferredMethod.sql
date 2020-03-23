ALTER TABLE [dbo].[JOBDL020Gateways] ADD [GwyPreferredMethod] [int] NULL
ALTER TABLE [dbo].[JOBDL020Gateways]  WITH CHECK ADD  CONSTRAINT [FK_JOBDL020Gateways_GwyPreferredMethod_SYSTM000Ref_Options] FOREIGN KEY([GwyPreferredMethod])
REFERENCES [dbo].[SYSTM000Ref_Options] ([Id])
GO