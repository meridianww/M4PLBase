SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Kirti Anurag         
-- Create date:               09/24/2019      
-- Description:               EXEC GetUserPageOptnLevelAndPermission 2,1,14,'Customer'
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
		,@CurrentModuleId = @CurrentModuleId
		,@PageLevelPermission = 1


	IF EXISTS (SELECT 1 FROM [dbo].[SYSTM010SubSecurityByRole] WHERE StatusId =1 AND RefTableName = @entity)
	BEGIN
		DECLARE @getSecByRoleId BIGINT, @subSecMenuOptionLevelId INT, @subSecMenuAccessLevelId INT;
		SELECT @getSecByRoleId = ID FROM #TempRoleData where SecMainModuleId = @currentModuleId;

		IF OBJECT_ID('tempdb..#TempSubRoleData') IS NOT NULL
		DROP TABLE #TempRole

		CREATE TABLE #TempSubRoleData (
			 SecByRoleId BIGINT
			,RefTableName VARCHAR(50)
			,SubsMenuOptionLevelId INT
			,SubsMenuAccessLevelId INT
			)
			
		INSERT INTO #TempSubRoleData
		EXEC [dbo].[GetUserSubSecurities] 
		 @userId = @userId
		,@secByRoleId = @getSecByRoleId
		,@orgId = @orgId
		,@roleId = @roleId

		IF EXISTS (SELECT 1 FROM #TempSubRoleData WHERE RefTableName = @entity)
		BEGIN
			SELECT @subSecMenuOptionLevelId = SubsMenuOptionLevelId, @subSecMenuAccessLevelId = SubsMenuAccessLevelId 
			FROM #TempSubRoleData WHERE RefTableName = @entity
			UPDATE #TempRoleData 
			SET SecMenuOptionLevelId = @subSecMenuOptionLevelId
				, SecMenuAccessLevelId = @subSecMenuAccessLevelId
			WHERE SecMainModuleId = @currentModuleId
		END
	END

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
