IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'JOBDL000Master' AND COLUMN_NAME = 'jobQtyOrdered')
BEGIN
ALTER TABLE [dbo].[JOBDL000Master] ADD jobQtyOrdered decimal(18,2) NULL
END

IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'JOBDL000Master' AND COLUMN_NAME = 'jobQtyActual')
BEGIN
ALTER TABLE [dbo].[JOBDL000Master] ADD jobQtyActual  decimal(18,2) NULL
END

IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'JOBDL000Master' AND COLUMN_NAME = 'jobQtyUnitTypeId')
BEGIN
ALTER TABLE [dbo].[JOBDL000Master] ADD jobQtyUnitTypeId  int NULL
END

IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'JOBDL000Master' AND COLUMN_NAME = 'jobPartsOrdered')
BEGIN
ALTER TABLE [dbo].[JOBDL000Master] ADD jobPartsOrdered  decimal(18,2) NULL
END

IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'JOBDL000Master' AND COLUMN_NAME = 'jobPartsActual')
BEGIN
ALTER TABLE [dbo].[JOBDL000Master] ADD jobPartsActual  decimal(18,2) NULL
END

IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'JOBDL000Master' AND COLUMN_NAME = 'JobTotalCubes')
BEGIN
ALTER TABLE [dbo].[JOBDL000Master] ADD JobTotalCubes  decimal(18,2) NULL
END

IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'JOBDL000Master' AND COLUMN_NAME = 'jobServiceMode')
BEGIN
ALTER TABLE [dbo].[JOBDL000Master] ADD jobServiceMode  nvarchar(30) NULL
END

IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'JOBDL000Master' AND COLUMN_NAME = 'jobChannel')
BEGIN
ALTER TABLE [dbo].[JOBDL000Master] ADD jobChannel  nvarchar(30) NULL
END

IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'JOBDL000Master' AND COLUMN_NAME = 'jobProductType')
BEGIN
ALTER TABLE [dbo].[JOBDL000Master] ADD jobProductType  nvarchar(30) NULL
END

