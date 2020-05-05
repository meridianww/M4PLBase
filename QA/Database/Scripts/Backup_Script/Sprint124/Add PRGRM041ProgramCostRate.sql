
IF NOT EXISTS (
		SELECT *
		FROM sys.columns
		WHERE object_id = OBJECT_ID(N'[dbo].[PRGRM041ProgramCostRate]')
			AND name = 'PcrElectronicBilling'
		)
BEGIN
	ALTER TABLE [PRGRM041ProgramCostRate] ADD PcrElectronicBilling BIT NOT NULL DEFAULT(0)
END

IF NOT EXISTS (
		SELECT *
		FROM sys.columns
		WHERE object_id = OBJECT_ID(N'[dbo].[JOBDL062CostSheet]')
			AND name = 'CstElectronicBilling'
		)
BEGIN
	ALTER TABLE [JOBDL062CostSheet] ADD CstElectronicBilling BIT NOT NULL DEFAULT(0)
END

IF NOT EXISTS (
		SELECT *
		FROM sys.columns
		WHERE object_id = OBJECT_ID(N'[dbo].[PRGRM040ProgramBillableRate]')
			AND name = 'PbrElectronicBilling'
		)
BEGIN
	ALTER TABLE PRGRM040ProgramBillableRate ADD PbrElectronicBilling BIT NOT NULL DEFAULT(0)
END

IF NOT EXISTS (
		SELECT *
		FROM sys.columns
		WHERE object_id = OBJECT_ID(N'[dbo].[JOBDL061BillableSheet]')
			AND name = 'PrcElectronicBilling'
		)
BEGIN
	ALTER TABLE JOBDL061BillableSheet ADD PrcElectronicBilling BIT NOT NULL DEFAULT(0)
END
