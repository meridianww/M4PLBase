SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/* Copyright (2019) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Nikhil Chauhan         
-- Create date:               10/25/2019      
-- Description:               Sync Vendor information to DC location when PPP Mapped vendor updated.
-- Execution:                 EXEC [dbo].[SyncVendDCLocation]
-- =============================================  
CREATE PROCEDURE [dbo].[SyncVendDCLocation] (
	 @userId BIGINT
	,@pvlId BIGINT
	,@entity NVARCHAR(100)
	,@pvlProgramID BIGINT = NULL
	,@pvlLocationCode NVARCHAR(20) = NULL
	,@pvlLocationCodeCustomer NVARCHAR(20) = NULL
	,@pvlLocationTitle NVARCHAR(50) = NULL
	,@changedBy NVARCHAR(50) = NULL
	,@dateChanged DATETIME2(7) = NULL
	
	)
AS
BEGIN TRY
BEGIN TRAN
UPDATE Pvl_Other
	SET Pvl_Other.PvlLocationCode =  CASE WHEN (Pvl_Other.PvlProgramID  <>  @pvlProgramID ) THEN @pvlLocationCode  ELSE  Pvl_Other.PvlLocationCode END  
	   ,Pvl_Other.PvlLocationTitle =  CASE WHEN (Pvl_Other.PvlProgramID  <>  @pvlProgramID )  THEN @pvlLocationTitle ELSE  Pvl_Other.PvlLocationTitle END 
	   ,Pvl_Other.ChangedBy =  @changedBy
	   ,Pvl_Other.DateChanged =  @dateChanged
	From [dbo].[PRGRM051VendorLocations] Pvl_Other
	INNER JOIN [dbo].[PRGRM051VendorLocations] PVL ON  PVL.PvlVendorID  = Pvl_Other.PvlVendorID   AND PVL.PvlLocationTitle= Pvl_Other.PvlLocationTitle AND PVL.PvlLocationCode = Pvl_Other.PvlLocationCode
	INNER JOIN [dbo].[fnGetUserStatuses](@userId) PVL_fgus ON ISNULL(PVL.[StatusId], 1) = PVL_fgus.[StatusId] 
	INNER JOIN [dbo].[fnGetUserStatuses](@userId) Pvl_Other_fgus ON ISNULL(Pvl_Other.[StatusId], 1) = Pvl_Other_fgus.[StatusId] 
	Where  PVL.Id = @pvlId 


	--UPDATE VDC
	--SET VDC.VdcLocationCode = ISNULL(@pvlLocationCode,VDC.VdcLocationCode)
	--   --,VDC.VdcLocationTitle = ISNULL(@pvlLocationTitle,VDC.VdcLocationTitle)
	--   ,VDC.ChangedBy =  @changedBy
	--   ,VDC.DateChanged =  @dateChanged
	--From [dbo].[VEND040DCLocations] VDC
	--INNER JOIN [dbo].[PRGRM051VendorLocations] PVL
	--ON  PVL.PvlVendorID  = VDC.VdcVendorID  AND  VDC.VdcLocationCode = PVL.PvlLocationCode   AND  VDC.VdcLocationTitle =  PVL.PvlLocationTitle  
	--INNER JOIN [dbo].[fnGetUserStatuses](@userId) PVL_fgus ON ISNULL(PVL.[StatusId], 1) = PVL_fgus.[StatusId] 
	--INNER JOIN [dbo].[fnGetUserStatuses](@userId) VDC_fgus ON ISNULL(VDC.[StatusId], 1) = VDC_fgus.[StatusId] 
	--Where  PVL.Id = @pvlId 
	COMMIT
END TRY

BEGIN CATCH
ROLLBACK
	DECLARE @ErrorMessage VARCHAR(MAX) = (
			SELECT ERROR_MESSAGE()
			)
		,@ErrorSeverity VARCHAR(MAX) = (
			SELECT ERROR_SEVERITY()
			)
		,@RelatedTo VARCHAR(100) = (
			SELECT OBJECT_NAME(@@PROCID)
			)

	EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo
		,NULL
		,@ErrorMessage
		,NULL
		,NULL
		,@ErrorSeverity
END CATCH

GO
