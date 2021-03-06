SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Copyright (2018) Meridian Worldwide Transportation Group
-- All Rights Reserved Worldwide
-- Author:		Nathan Fujimoto
-- Create date: 6/19/2018
-- Description:	The stored procedure Merges the Scanner Cargo Quantities and Coordinates back into the Job Cargo table
-- =============================================
CREATE PROCEDURE [dbo].[scanMergeScannerCargoQtyIntoJobCargoQty]
	-- Add the parameters for the stored procedure here
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


	-- Merge the JOBDL010Cargo table with the SCN005Cargo table
	MERGE JOBDL010Cargo As TARGET
	USING SCN005Cargo As SOURCE ON (TARGET.Id = SOURCE.CargoId) --AND TARGET.Id = 197175
	WHEN MATCHED AND SOURCE.CgoProFlag12 = 'U' AND SOURCE.CgoProFlag14 Is NULL THEN
	UPDATE SET
      TARGET.[CgoQtyCounted] = SOURCE.CgoQtyCounted
	  ,TARGET.[CgoQtyExpected] = SOURCE.CgoQtyExpected
      ,TARGET.[CgoQtyDamaged] = SOURCE.CgoQtyDamaged
	  ,TARGET.[CgoQtyOrdered] = SOURCE.CgoQtyOrdered
	  ,TARGET.[CgoQtyOnHold] = SOURCE.CgoQtyOnHold
	  ,TARGET.[CgoQtyShortOver] = CASE WHEN (SOURCE.CgoQtyShort > 0) THEN (-SOURCE.CgoQtyShort) WHEN (SOURCE.CgoQtyOver > 0) THEN SOURCE.CgoQtyOver ELSE 0 end
      ,TARGET.[CgoLongitude] = SOURCE.CgoLong
      ,TARGET.[CgoLatitude] = SOURCE.CgoLat;
	-- When no record is matched then insert the cargo record;
End
GO
