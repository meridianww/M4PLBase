SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Kirti Anurag         
-- Create date:               09/24/2019      
-- Description:               Get GetUserPageOptnLevelAndPermission 1,1,14,'Customer'
-- ============================================= 
CREATE PROCEDURE [dbo].[GetUserPageOptnLevelAndPermission] @userId BIGINT
	,@orgId BIGINT
	,@roleId BIGINT
	,@entity NVARCHAR(100)
AS
BEGIN TRY
	SET NOCOUNT ON;

	DECLARE @currentModuleId INT

	SELECT @currentModuleId = ISNULL(TblMainModuleId,0)
	FROM [dbo].[SYSTM000Ref_Table]
	WHERE SysRefName = @entity

	IF(@currentModuleId = 0)
	BEGIN
	SELECT @userId AS Id
		,NULL SecMainModuleId
		,-1 SecMenuOptionLevelId
		,- 1 SecMenuAccessLevelId
	END
	ELSE
	BEGIN
	IF OBJECT_ID('tempdb..#TempRoleData') IS NOT NULL
		DROP TABLE #TempRole

	CREATE TABLE #TempRoleData (
		ID BIGINT
		,SecMainModuleId INT
		,SecMenuOptionLevelId INT
		,SecMenuAccessLevelId INT
		)

	INSERT INTO #TempRoleData
	EXEC [dbo].[GetUserSecurities] @userId = @userId
		,@orgId = @orgId
		,@roleId = @roleId

	SELECT @userId AS Id
		,SecMainModuleId
		,SecMenuOptionLevelId
		,SecMenuAccessLevelId
	FROM #TempRoleData
	WHERE SecMainModuleId = @currentModuleId

	DROP TABLE #TempRoleData
	END
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
