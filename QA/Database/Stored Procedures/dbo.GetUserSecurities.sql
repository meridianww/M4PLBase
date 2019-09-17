SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Prashant Aggarwal       
-- Create date:               09/17/2019      
-- Description:               Get user securities 
-- Execution:                 EXEC [dbo].[GetUserSecurities] 10013,1, 10036 
-- =============================================   
CREATE PROCEDURE [dbo].[GetUserSecurities]
	@userId BIGINT
	,@orgId BIGINT
	,@roleId BIGINT
AS
BEGIN TRY
	SET NOCOUNT ON;

	DECLARE @minMenuOptionLevelId INT
		,@minMenuAccessLevelId INT
		,@ModuleId BIGINT
		,@OptionLevelId INT
		,@AccessLevelId INT
		,@JobModuleId BIGINT
		,@IsCustomerDCLocation BIT
		,@IsCustContact BIT
		,@IsVendContact BIT
		,@IsVendorDCLocation BIT
		,@maxMenuOptionLevelId INT
		,@maxMenuAccessLevelId INT
		,@SysAdminUserId BIGINT
		,@mainModuleLookupId INT
		,@menuOptionLevelLookupId INT
		,@menuAccessLevelLookupId INT;

	SELECT @SysAdminUserId = Id
	FROM [dbo].[SYSTM000OpnSezMe]
	WHERE Id = @userId
		AND IsSysAdmin = 1

	SELECT @mainModuleLookupId = Id
	FROM [dbo].[SYSTM000Ref_Lookup]
	WHERE LkupCode LIKE 'MainModule%';

	SELECT @menuOptionLevelLookupId = Id
	FROM [dbo].[SYSTM000Ref_Lookup]
	WHERE LkupCode LIKE 'MenuOptionLevel%';

	SELECT @menuAccessLevelLookupId = Id
	FROM [dbo].[SYSTM000Ref_Lookup]
	WHERE LkupCode LIKE 'MenuAccessLevel%'

	SELECT @minMenuOptionLevelId = Id
	FROM [dbo].[SYSTM000Ref_Options]
	WHERE SysLookupId = @menuOptionLevelLookupId
	ORDER BY SysSortOrder DESC

	SELECT @maxMenuOptionLevelId = Id
	FROM [dbo].[SYSTM000Ref_Options]
	WHERE SysSortOrder > 0
		AND SysLookupId = @menuOptionLevelLookupId
	ORDER BY SysSortOrder

	SELECT @minMenuAccessLevelId = Id
	FROM [dbo].[SYSTM000Ref_Options]
	WHERE SysLookupId = @menuAccessLevelLookupId
	ORDER BY SysSortOrder DESC

	SELECT @maxMenuAccessLevelId = Id
	FROM [dbo].[SYSTM000Ref_Options]
	WHERE SysSortOrder > 0
		AND SysLookupId = @menuAccessLevelLookupId
	ORDER BY SysSortOrder

	CREATE TABLE #TempSecurity (
		Id INT
		,SecMainModuleId INT
		,SecMenuOptionLevelId INT
		,SecMenuAccessLevelId INT
		)

	SELECT CB.ContableName
		,CB.COnCodeId
		,CB.ContactMSTRId
	INTO #TempBridge
	FROM CONTC010Bridge CB
	INNER JOIN [dbo].[SYSTM000OpnSezMe] SM ON SM.SysUserContactId = CB.ContactMSTRId
	WHERE SM.Id = @userId
		AND ISNULL(CB.StatusId, 0) = 1
		AND ISNULL(CB.ConTableTypeId, 0) > 0

	SELECT @IsCustomerDCLocation = CASE 
			WHEN ISNULL(DC.CdcContactMSTRID, 0) > 0
				THEN 1
			ELSE 0
			END
	FROM CUST040DCLocations DC
	INNER JOIN [dbo].[SYSTM000OpnSezMe] SM ON SM.SysUserContactId = DC.CdcContactMSTRID
	WHERE SM.Id = @userId
		AND ISNULL(DC.StatusId, 0) = 1

	SELECT @IsVendorDCLocation = CASE 
			WHEN ISNULL(DC.vdcContactMSTRID, 0) > 0
				THEN 1
			ELSE 0
			END
	FROM VEND040DCLocations DC
	INNER JOIN [dbo].[SYSTM000OpnSezMe] SM ON SM.SysUserContactId = DC.vdcContactMSTRID
	WHERE SM.Id = @userId
		AND ISNULL(DC.StatusId, 0) = 1

	SELECT @IsCustContact = CASE 
			WHEN ISNULL(ContableName, '') <> ''
				THEN 1
			ELSE 0
			END
	FROM #TempBridge
	WHERE ContableName = 'CustContact'

	SELECT @IsVendContact = CASE 
			WHEN ISNULL(ContableName, '') <> ''
				THEN 1
			ELSE 0
			END
	FROM #TempBridge
	WHERE ContableName = 'VendContact'

	SELECT @OptionLevelId = Id
	FROM [dbo].[SYSTM000Ref_Options]
	WHERE SysLookupId = @menuOptionLevelLookupId
		AND SysOptionName = 'Systems'
	ORDER BY SysSortOrder DESC

	SELECT @AccessLevelId = Id
	FROM [dbo].[SYSTM000Ref_Options]
	WHERE SysSortOrder > 0
		AND SysOptionName = 'Add, Edit & Delete'
		AND SysLookupId = @menuAccessLevelLookupId
	ORDER BY SysSortOrder

	IF (ISNULL(@SysAdminUserId, 0) = 0)
	BEGIN
		IF (@IsCustContact = 1)
		BEGIN
			SELECT @ModuleId = Id
			FROM [dbo].[SYSTM000Ref_Options]
			WHERE SysLookupId = @mainModuleLookupId
				AND SysOptionName = 'Customer'

			IF NOT EXISTS (
					SELECT 1
					FROM [SYSTM000SecurityByRole]
					WHERE [SecMainModuleId] = @ModuleId
						AND [OrgRefRoleId] = @roleId
					)
			BEGIN
				INSERT INTO #TempSecurity (
					SecMainModuleId
					,SecMenuOptionLevelId
					,SecMenuAccessLevelId
					)
				SELECT @ModuleId
					,@OptionLevelId
					,@AccessLevelId
			END
		END

		IF (@IsVendContact = 1)
		BEGIN
			SELECT @ModuleId = Id
			FROM [dbo].[SYSTM000Ref_Options]
			WHERE SysLookupId = @mainModuleLookupId
				AND SysOptionName = 'Vendor'

			IF NOT EXISTS (
					SELECT 1
					FROM [SYSTM000SecurityByRole]
					WHERE [SecMainModuleId] = @ModuleId
						AND [OrgRefRoleId] = @roleId
					)
			BEGIN
				INSERT INTO #TempSecurity (
					SecMainModuleId
					,SecMenuOptionLevelId
					,SecMenuAccessLevelId
					)
				SELECT @ModuleId
					,@OptionLevelId
					,@AccessLevelId
			END
		END

		IF (
				@IsCustContact = 1
				OR @IsVendContact = 1
				OR @IsCustomerDCLocation = 1
				OR @IsVendorDCLocation = 1
				)
		BEGIN
			SELECT @ModuleId = Id
			FROM [dbo].[SYSTM000Ref_Options]
			WHERE SysLookupId = @mainModuleLookupId
				AND SysOptionName = 'Program'

			SELECT @JobModuleId = Id
			FROM [dbo].[SYSTM000Ref_Options]
			WHERE SysLookupId = @mainModuleLookupId
				AND SysOptionName = 'Job'

			IF NOT EXISTS (
					SELECT 1
					FROM [SYSTM000SecurityByRole]
					WHERE [SecMainModuleId] = @ModuleId
						AND [OrgRefRoleId] = @roleId
					)
			BEGIN
				INSERT INTO #TempSecurity (
					SecMainModuleId
					,SecMenuOptionLevelId
					,SecMenuAccessLevelId
					)
				SELECT @ModuleId
					,@OptionLevelId
					,@AccessLevelId
			END

			IF NOT EXISTS (
					SELECT 1
					FROM [SYSTM000SecurityByRole]
					WHERE [SecMainModuleId] = @JobModuleId
						AND [OrgRefRoleId] = @roleId
					)
			BEGIN
				INSERT INTO #TempSecurity (
					SecMainModuleId
					,SecMenuOptionLevelId
					,SecMenuAccessLevelId
					)
				SELECT @JobModuleId
					,@OptionLevelId
					,@AccessLevelId
			END
		END
	END

	IF (ISNULL(@SysAdminUserId, 0) > 0)
	BEGIN
		INSERT INTO #TempSecurity (
			SecMainModuleId
			,SecMenuOptionLevelId
			,SecMenuAccessLevelId
			)
		SELECT Id AS SecMainModuleId
			,@maxMenuOptionLevelId AS SecMenuOptionLevelId
			,@maxMenuAccessLevelId AS SecMenuAccessLevelId
		FROM [dbo].[SYSTM000Ref_Options]
		WHERE SysLookupId = @mainModuleLookupId;
	END
	ELSE
	BEGIN
		INSERT INTO #TempSecurity (
			Id
			,SecMainModuleId
			,SecMenuOptionLevelId
			,SecMenuAccessLevelId
			)
		SELECT sbr.Id
			,sbr.[SecMainModuleId]
			,sbr.[SecMenuOptionLevelId]
			,sbr.[SecMenuAccessLevelId]
		FROM [dbo].[ORGAN010Ref_Roles](NOLOCK) refRole
		INNER JOIN [dbo].[SYSTM000SecurityByRole](NOLOCK) sbr ON sbr.[OrgRefRoleId] = refRole.[Id]
			AND (sbr.SecMenuOptionLevelId > @minMenuOptionLevelId)
			AND (sbr.SecMenuAccessLevelId > @minMenuAccessLevelId)
		WHERE refRole.[OrgId] = @orgId
			AND refRole.Id = @roleId
			AND (ISNULL(sbr.StatusId, 1) = 1)
	END

	SELECT CASE 
			WHEN ISNULL(@SysAdminUserId, 0) > 0
				THEN 0
			ELSE Id
			END Id
		,[SecMainModuleId]
		,[SecMenuOptionLevelId]
		,[SecMenuAccessLevelId]
	FROM #TempSecurity

	DROP TABLE #TempSecurity

	DROP TABLE #TempBridge
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

