SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Copyright (2018) Meridian Worldwide Transportation Group
-- All Rights Reserved Worldwide
-- Author:		Nathan Fujimoto
-- Create date: 6/17/2018
-- Description:	The stored procedure Merges the Job and Scanner Cargo Detail between the JOBDL010Cargo(Source) and SCN006CargoDetail(Target)
-- =============================================
CREATE PROCEDURE [dbo].[scanMergeJobAndScannerCargoDetail]
	-- Add the parameters for the stored procedure here
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


	-- Merge the JOBDL010Cargo table with the SCN005Cargo table
	MERGE SCN006CargoDetail As TARGET
	USING JOBDL010Cargo As SOURCE ON (SOURCE.Id = TARGET.CargoId)
	WHEN MATCHED AND SOURCE.ProFlags12 = 'S' AND SOURCE.ProFlags14 Is NULL THEN
	UPDATE SET
      TARGET.[DetSerialNumber] = SOURCE.CgoSerialNumber
      ,TARGET.[DetQtyCounted] = SOURCE.CgoQtyCounted
      ,TARGET.[DetQtyDamaged] = SOURCE.CgoQtyDamaged
      ,TARGET.[DetQtyShort] = CASE WHEN (SOURCE.CgoQtyOrdered - SOURCE.CgoQtyOnHand > 0) Then 0 else Abs(SOURCE.CgoQtyOrdered - SOURCE.CgoQtyOnHand) end
      ,TARGET.[DetQtyOver] = CASE WHEN (SOURCE.CgoQtyOrdered - SOURCE.CgoQtyOnHand < 0) Then 0 else Abs(SOURCE.CgoQtyOrdered - SOURCE.CgoQtyOnHand) end      
      ,TARGET.[DetLong] = SOURCE.CgoLongitude
      ,TARGET.[DetLat] = SOURCE.CgoLatitude
	-- When no record is matched then insert the cargo record
	WHEN NOT MATCHED BY TARGET AND SOURCE.ProFlags12 = 'S' AND SOURCE.ProFlags14 Is Null Then
	  INSERT  
           ([CargoID]
           ,[DetSerialNumber]
           ,[DetQtyCounted]
           ,[DetQtyDamaged]
           ,[DetQtyShort]
           ,[DetQtyOver]           
           ,[DetLong]
           ,[DetLat])
     VALUES
           (SOURCE.Id
           ,SOURCE.CgoSerialNumber
           ,SOURCE.CgoQtyCounted
           ,SOURCE.CgoQtyDamaged
           ,CASE WHEN (SOURCE.CgoQtyOrdered - SOURCE.CgoQtyOnHand > 0) Then 0 else Abs(SOURCE.CgoQtyOrdered - SOURCE.CgoQtyOnHand) end
           ,CASE WHEN (SOURCE.CgoQtyOrdered - SOURCE.CgoQtyOnHand < 0) Then 0 else Abs(SOURCE.CgoQtyOrdered - SOURCE.CgoQtyOnHand) end
           ,SOURCE.CgoLongitude
           ,SOURCE.CgoLatitude)
		WHEN NOT MATCHED BY SOURCE THEN
		DELETE;
End
GO
