SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Kirti Anurag         
-- Create date:               09/24/2019      
-- Description:               Get GetUserPageOptnLevelAndPermission
-- ============================================= 
CREATE PROCEDURE [dbo].[GetUserPageOptnLevelAndPermission] @userId BIGINT
	,@orgId BIGINT
	,@roleId BIGINT
	,@entity NVARCHAR(100)
AS
BEGIN TRY
	SET NOCOUNT ON;

	DECLARE @currentModuleId INT

	SELECT @currentModuleId = TblMainModuleId
	FROM [dbo].[SYSTM000Ref_Table]
	WHERE SysRefName = @entity

	IF OBJECT_ID('tempdb..#TempRole') IS NOT NULL
		DROP TABLE #TempRole

	CREATE TABLE #TempRole (
		ID BIGINT
		,SecMainModuleId INT
		,SecMenuOptionLevelId INT
		,SecMenuAccessLevelId INT
		)

	INSERT INTO #TempRole
	EXEC [dbo].[GetUserSecurities] @userId = @userId
		,@orgId = @orgId
		,@roleId = @roleId

	SELECT @userId AS Id
		,SecMainModuleId
		,SecMenuOptionLevelId
		,SecMenuAccessLevelId
	FROM #TempRole
	WHERE SecMainModuleId = @currentModuleId

	DROP TABLE #TempRole
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
