SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               08/16/2018      
-- Description:               Get a ScnOrderOSD
-- Execution:                 EXEC [dbo].[GetScnOrderOSD]
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)    
-- Modified Desc:  
-- ============================================= 
CREATE PROCEDURE  [dbo].[GetScnOrderOSD]
    @userId BIGINT,
    @roleId BIGINT,
	@orgId BIGINT,
    @id BIGINT
AS
BEGIN TRY                
 SET NOCOUNT ON;   
  SELECT scn.[CargoOSDID]
		,scn.[OSDID]
		,scn.[DateTime]
		,scn.[CargoDetailID]
		,scn.[CargoID]
		,scn.[CgoSerialNumber]
		,scn.[OSDReasonID]
		,scn.[OSDQty]
		,scn.[Notes]
		,scn.[EditCD]
		,scn.[StatusID]
		,scn.[CgoSeverityCode]
  FROM [dbo].[SCN014OrderOSD] scn
 WHERE scn.[CargoOSDID] = @id
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
