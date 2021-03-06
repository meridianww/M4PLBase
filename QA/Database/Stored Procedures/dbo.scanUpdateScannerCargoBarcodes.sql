SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Copyright (2018) Meridian Worldwide Transportation Group
-- All Rights Reserved Worldwide
-- Author:		Nathan Fujimoto
-- Create date: 6/10/2018
-- Description:	The stored procedure Inserts the Scanner Cargo Detail records
-- =============================================
CREATE PROCEDURE [dbo].[scanUpdateScannerCargoBarcodes]
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	INSERT INTO SCN006CargoDetail 
		(CargoID,
		DetSerialNumber,
		DetQtyCounted,
		DetQtyDamaged,
		DetQtyShort,
		DetQtyOver,
		DetLong,
		DetLat)
		SELECT scanCargo.CargoID, jobCargo.CgoSerialNumber, scanCargo.CgoQtyCounted, scanCargo.CgoQtyDamaged, scanCargo.CgoQtyShort, scanCargo.CgoQtyOver, scanCargo.CgoLong, scanCargo.CgoLat
		FROM SCN005Cargo scanCargo LEFT JOIN JOBDL010Cargo jobCargo  ON scanCargo.CargoID = jobCargo.Id
END
GO
