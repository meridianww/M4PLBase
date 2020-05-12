--ALTER TABLE [dbo].[JOBDL020Gateways]  WITH NOCHECK ADD  CONSTRAINT [FK_JOBDL020Gateways_InstallStatusId] 
--FOREIGN KEY([GwyExceptionStatusId]) REFERENCES [dbo].[JOBDL023GatewayInstallStatusMaster] ([Id])
--GO
--ALTER TABLE [dbo].[JOBDL020Gateways] CHECK CONSTRAINT [FK_JOBDL020Gateways_InstallStatusId]
--GO

--ALTER TABLE [dbo].[JOBDL020Gateways]  WITH NOCHECK ADD  CONSTRAINT [FK_JOBDL020Gateways_GwyExceptionTitleId] FOREIGN KEY([GwyExceptionTitleId])
--REFERENCES [dbo].[JOBDL022GatewayExceptionReason] ([Id])
--GO

--ALTER TABLE [dbo].[JOBDL020Gateways] CHECK CONSTRAINT [FK_JOBDL020Gateways_GwyExceptionTitleId]
--GO

--ALTER TABLE [dbo].[JOBDL020Gateways]  WITH NOCHECK ADD  CONSTRAINT [FK_PRGRM010Ref_GatewayDefaults_GwyCargoId] FOREIGN KEY([GwyCargoId])
--REFERENCES [dbo].[JOBDL010Cargo] ([Id])
--GO

--ALTER TABLE [dbo].[JOBDL020Gateways] CHECK CONSTRAINT [FK_PRGRM010Ref_GatewayDefaults_GwyCargoId]
--GO

--ALTER TABLE [JOBDL020Gateways]
--DROP CONSTRAINT [FK_JOBDL020Gateways_InstallStatusId]
--ALTER TABLE [JOBDL020Gateways]
--DROP CONSTRAINT [FK_JOBDL020Gateways_GwyExceptionTitleId]
--ALTER TABLE [JOBDL020Gateways]
--DROP CONSTRAINT [FK_PRGRM010Ref_GatewayDefaults_GwyCargoId]
