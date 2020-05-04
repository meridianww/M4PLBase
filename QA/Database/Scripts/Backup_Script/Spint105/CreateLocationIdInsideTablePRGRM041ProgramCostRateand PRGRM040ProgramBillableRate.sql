--------------------------------------- Update Changes For PRGRM041ProgramCostRate--------------------------------------------------------------------------------------------------
Truncate Table [PRGRM041ProgramCostRate]
ALTER TABLE [dbo].[PRGRM041ProgramCostRate] DROP CONSTRAINT [FK_PRGRM041ProgramCostRate_PRGRM000Master]
GO

ALTER TABLE [dbo].[PRGRM041ProgramCostRate] DROP COLUMN  [PcrPrgrmID]

ALTER TABLE [dbo].[PRGRM041ProgramCostRate] ADD ProgramLocationId BIGINT NULL

ALTER TABLE [dbo].[PRGRM041ProgramCostRate]  WITH NOCHECK ADD  CONSTRAINT [FK_PRGRM041ProgramCostRate_PRGRM043ProgramCostLocations] FOREIGN KEY([ProgramLocationId])
REFERENCES [dbo].[PRGRM043ProgramCostLocations] ([Id])
GO

ALTER TABLE [dbo].[PRGRM041ProgramCostRate] CHECK CONSTRAINT [FK_PRGRM041ProgramCostRate_PRGRM043ProgramCostLocations]
GO

--------------------------------------- Update Changes For PRGRM040ProgramBillableRate--------------------------------------------------------------------------------------------------
Truncate Table [PRGRM040ProgramBillableRate]
ALTER TABLE [dbo].[PRGRM040ProgramBillableRate] DROP CONSTRAINT [FK_PRGRM040ProgramBillableRate_PRGRM000Master]
GO
 ALTER TABLE [dbo].[PRGRM040ProgramBillableRate] DROP COLUMN  [PbrPrgrmID]

 ALTER TABLE [dbo].[PRGRM040ProgramBillableRate] ADD ProgramLocationId BIGINT NULL

ALTER TABLE [dbo].[PRGRM040ProgramBillableRate]  WITH NOCHECK ADD  CONSTRAINT [FK_PRGRM040ProgramBillableRate_PRGRM042ProgramBillableLocations] FOREIGN KEY([ProgramLocationId])
REFERENCES [dbo].[PRGRM042ProgramBillableLocations] ([Id])
GO

ALTER TABLE [dbo].[PRGRM040ProgramBillableRate] CHECK CONSTRAINT [FK_PRGRM040ProgramBillableRate_PRGRM042ProgramBillableLocations]
GO