SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Copyright (2018) Meridian Worldwide Transportation Group
-- All Rights Reserved Worldwide
-- Author:		Nathan Fujimoto
-- Create date: 6/17/2018
-- Description:	The stored procedure Merges the Job and Scanner Cargo between the JOBDL010Cargo(Source) and SCN005Cargo (Target)
-- =============================================
CREATE PROCEDURE [dbo].[scanMergeJobAndScannerCargo]
	-- Add the parameters for the stored procedure here
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


	-- Merge the JOBDL010Cargo table with the SCN005Cargo table
	MERGE SCN005Cargo As TARGET
	USING JOBDL010Cargo As SOURCE ON (SOURCE.Id = TARGET.CargoId)
	WHEN MATCHED AND SOURCE.ProFlags12 = 'S' AND TARGET.CgoProFlag12 <> 'D' AND SOURCE.ProFlags14 Is NULL AND TARGET.CgoProFlag14 Is NULL THEN
	UPDATE SET
		TARGET.[JobID] = SOURCE.JobId
      ,TARGET.[CgoLineItem] = SOURCE.CgoLineItem
      ,TARGET.[CgoPartNumCode] = SOURCE.CgoPartNumCode
      ,TARGET.[CgoQtyOrdered] = SOURCE.CgoQtyOrdered
      ,TARGET.[CgoQtyExpected] = SOURCE.CgoQtyExpected
      ,TARGET.[CgoQtyCounted] = SOURCE.CgoQtyCounted
      ,TARGET.[CgoQtyDamaged] = SOURCE.CgoQtyDamaged
      ,TARGET.[CgoQtyOnHold] = SOURCE.CgoQtyOnHold
      ,TARGET.[CgoQtyShort] = CASE WHEN (SOURCE.CgoQtyOrdered - SOURCE.CgoQtyOnHand > 0) Then 0 else Abs(SOURCE.CgoQtyOrdered - SOURCE.CgoQtyOnHand) end
      ,TARGET.[CgoQtyOver] = CASE WHEN (SOURCE.CgoQtyOrdered - SOURCE.CgoQtyOnHand < 0) Then 0 else Abs(SOURCE.CgoQtyOrdered - SOURCE.CgoQtyOnHand) end
      ,TARGET.[CgoQtyUnits] = SOURCE.CgoQtyUnits
      --,TARGET.[CgoStatus] = SOURCE.CgoStatus -- Need to discuss this with RfGen
      ,TARGET.[CgoLong] = SOURCE.CgoLongitude
      ,TARGET.[CgoLat] = SOURCE.CgoLatitude
      ,TARGET.[CgoProFlag11] = SOURCE.ProFlags11
      ,TARGET.[CgoProFlag12] = SOURCE.ProFlags12
      ,TARGET.[CgoProFlag13] = SOURCE.ProFlags13
      ,TARGET.[CgoProFlag14] = SOURCE.ProFlags14
	-- When no record is matched then insert the cargo record
	WHEN NOT MATCHED BY TARGET AND SOURCE.ProFlags12 = 'S' AND SOURCE.ProFlags14 Is Null Then
	
	--AND TARGET.CgoProFlag12 <> 'D' AND SOURCE.ProFlags14 Is NULL AND TARGET.CgoProFlag14 Is NULL THEN
	  
	  INSERT  
           ([CargoID]
           ,[JobID]
           ,[CgoLineItem]
           ,[CgoPartNumCode]
           ,[CgoQtyOrdered]
           ,[CgoQtyExpected]
           ,[CgoQtyCounted]
           ,[CgoQtyDamaged]
           ,[CgoQtyOnHold]
           ,[CgoQtyShort]
           ,[CgoQtyOver]
           ,[CgoQtyUnits]           
           ,[CgoLong]
           ,[CgoLat]
		   ,[CgoProFlag11]
		   ,[CgoProFlag12]
		   ,[CgoProFlag13]
		   ,[CgoProFlag14])
     VALUES
           (SOURCE.Id
           ,SOURCE.JobId
           ,SOURCE.CgoLineItem
           ,SOURCE.CgoPartNumCode
           ,SOURCE.CgoQtyOrdered
           ,SOURCE.CgoQtyExpected
           ,SOURCE.CgoQtyCounted
           ,SOURCE.CgoQtyDamaged
           ,SOURCE.CgoQtyOnHold
           ,CASE WHEN (SOURCE.CgoQtyOrdered - SOURCE.CgoQtyOnHand > 0) Then 0 else Abs(SOURCE.CgoQtyOrdered - SOURCE.CgoQtyOnHand) end
           ,CASE WHEN (SOURCE.CgoQtyOrdered - SOURCE.CgoQtyOnHand < 0) Then 0 else Abs(SOURCE.CgoQtyOrdered - SOURCE.CgoQtyOnHand) end
           ,SOURCE.CgoQtyUnits
           ,SOURCE.CgoLongitude
           ,SOURCE.CgoLatitude
		   ,SOURCE.ProFlags11
		   ,SOURCE.ProFlags12
		   ,SOURCE.ProFlags13
		   ,SOURCE.ProFlags14)
		WHEN NOT MATCHED BY SOURCE AND TARGET.CgoProFlag12 <> 'D' AND TARGET.CgoProFlag14 IS NULL THEN
		DELETE;
End
GO
