SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               08/16/2018      
-- Description:               Get a ScnCargo
-- Execution:                 EXEC [dbo].[GetScnCargo]
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)    
-- Modified Desc:  
-- ============================================= 
CREATE PROCEDURE  [dbo].[GetScnCargo]
    @userId BIGINT,
    @roleId BIGINT,
	@orgId BIGINT,
    @id BIGINT
AS
BEGIN TRY                
 SET NOCOUNT ON;   
  SELECT scn.[CargoID]
		,scn.[JobID]
		,scn.[CgoLineItem]
		,scn.[CgoPartNumCode]
		,scn.[CgoQtyOrdered]
		,scn.[CgoQtyExpected]
		,scn.[CgoQtyCounted]
		,scn.[CgoQtyDamaged]
		,scn.[CgoQtyOnHold]
		,scn.[CgoQtyShort]
		,scn.[CgoQtyOver]
		,scn.[CgoQtyUnits]
		,scn.[CgoStatus]
		,scn.[CgoInfoID]
		,scn.[ColorCD]
		,scn.[CgoSerialCD]
		,scn.[CgoLong]
		,scn.[CgoLat]
		,scn.[CgoProFlag01]
		,scn.[CgoProFlag02]
		,scn.[CgoProFlag03]
		,scn.[CgoProFlag04]
		,scn.[CgoProFlag05]
		,scn.[CgoProFlag06]
		,scn.[CgoProFlag07]
		,scn.[CgoProFlag08]
		,scn.[CgoProFlag09]
		,scn.[CgoProFlag10]
		,scn.[CgoProFlag11]
		,scn.[CgoProFlag12]
		,scn.[CgoProFlag13]
		,scn.[CgoProFlag14]
		,scn.[CgoProFlag15]
		,scn.[CgoProFlag16]
		,scn.[CgoProFlag17]
		,scn.[CgoProFlag18]
		,scn.[CgoProFlag19]
		,scn.[CgoProFlag20]
  FROM [dbo].[SCN005Cargo] scn
 WHERE scn.[CargoID] = @id
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
