SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


/* Copyright (2019) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Nikhil Chauhan         
-- Create date:               10/15/2019     
-- Description:               GetVendorIdforSiteCode
-- Execution:                 EXEC GetVendorIdforSiteCode
-- ============================================= 
CREATE PROCEDURE [dbo].[GetVendorIdforSiteCode] 
     @userId BIGINT
	,@roleId BIGINT
	,@conOrgId BIGINT
	,@programId BIGINT
	,@jobSiteCode NVARCHAR(50)
	,@langCode nvarchar(50) = 'EN'
AS
BEGIN TRY

	SET NOCOUNT ON;

	 DECLARE @vendorId bigint; 
	
 
	IF  EXISTS(SELECT TOP 1 1  FROM [dbo].[PRGRM051VendorLocations]  where PvlLocationCode = @jobSiteCode  and  PvlProgramID = @programId  AND StatusId IN (1,2) )
	BEGIN 
	SELECT  @vendorId =  com.Id FROM [dbo].[PRGRM051VendorLocations]  pvl INNER JOIN [COMP000Master] com on com.CompPrimaryRecordId = pvl.PvlVendorID where pvl.PvlLocationCode = @jobSiteCode  and  pvl.PvlProgramID = @programId  AND pvl.StatusId IN (1,2)
	END
	ELSE
	BEGIN
	SET  @vendorId =  0;
	END
	Select @vendorId;
END TRY

BEGIN CATCH

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


