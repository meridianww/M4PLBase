SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/* Copyright (2018) Meridian Worldwide Transportation Group  
   All Rights Reserved Worldwide */
-- =============================================          
-- Author:                    Nikhil Chauhan           
-- Create date:               08/2/2019       
-- Description:               Get SiteCode for Program Id passed
-- Execution:                 EXEC [dbo].[GetJobsSiteCodeByProgram]     
-- =============================================        C
ALTER PROCEDURE [dbo].[GetJobsSiteCodeByProgram] @userId BIGINT
	,@roleId BIGINT
	,@orgId BIGINT
	,@id BIGINT
	,@parentId BIGINT
AS
BEGIN TRY
	SET NOCOUNT ON;

	SELECT pvl.PvlLocationCode
		,PvlVendorID
	FROM [PRGRM051VendorLocations] pvl
	INNER JOIN PRGRM000MASTER pm ON pm.Id = pvl.PvlProgramID
	WHERE pm.id = @parentId
		AND pvl.StatusId IN (
			1
			,2
			)
		AND pm.PrgOrgID = @orgId
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

