SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               08/16/2018      
-- Description:               Get user securities  
-- Execution:                 EXEC [dbo].[GetUserSecurities]   
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)    
-- Modified Desc:  
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
		,@maxMenuOptionLevelId INT
		,@maxMenuAccessLevelId INT
		,@mainModuleLookupId INT
		,@menuOptionLevelLookupId INT
		,@menuAccessLevelLookupId INT;

	IF OBJECT_ID('tempdb..#UserRoleTemp') IS NOT NULL
		DROP TABLE #UserRoleTemp

	CREATE TABLE #UserRoleTemp (
		OptionLevelMaxId INT
		,OptionLevelMinId INT
		,MenuAccessLevelMaxId INT
		,MenuAccessLevelMinId INT
		,ModuleId INT
		)

	INSERT INTO #UserRoleTemp (
	     ModuleId
		,OptionLevelMaxId
		,OptionLevelMinId
		,MenuAccessLevelMaxId
		,MenuAccessLevelMinId
		)
SELECT SecMainModuleId
			,Max(SecMenuOptionLevelId) OptionLevelMaxId
			,MIn(SecMenuOptionLevelId) OptionLevelMinId
			,Max(SecMenuAccessLevelId) MenuAccessLevelMaxId
			,Min(SecMenuAccessLevelId) MenuAccessLevelMinId
		FROM [dbo].[SYSTM000SecurityByRole] SR
		INNER JOIN [dbo].[SYSTM000Ref_Options] SL ON SL.Id = SR.[SecMainModuleId]
		INNER JOIN dbo.CONTC010Bridge CB ON CB.ConCodeId = SR.OrgRefRoleId
		INNER JOIN [dbo].[SYSTM000OpnSezMe] SM ON SM.SysUserContactID = CB.ContactMSTRID
		WHERE SL.SysOptionName IN (
				'Customer'
				,'Vendor'
				) AND SM.Id = @userId AND CB.StatusId = 1
		GROUP BY SecMainModuleId

	INSERT INTO #UserRoleTemp (
	     ModuleId
		,OptionLevelMaxId
		,OptionLevelMinId
		,MenuAccessLevelMaxId
		,MenuAccessLevelMinId
		)
	SELECT SecMainModuleId
			,Max(SecMenuOptionLevelId) OptionLevelMaxId
			,MIn(SecMenuOptionLevelId) OptionLevelMinId
			,Max(SecMenuAccessLevelId) MenuAccessLevelMaxId
			,Min(SecMenuAccessLevelId) MenuAccessLevelMinId
		FROM [dbo].[SYSTM000SecurityByRole] SR
		INNER JOIN [dbo].[SYSTM000Ref_Options] SL ON SL.Id = SR.[SecMainModuleId]
		INNER JOIN PRGRM020Program_Role PR ON PR.OrgRefRoleId = SR.OrgRefRoleId
		INNER JOIN [dbo].[SYSTM000OpnSezMe] SM ON SM.SysUserContactID = PR.PrgRoleContactID
		WHERE SL.SysOptionName = 'Program' AND SM.Id = @userId AND PR.StatusId = 1
		GROUP BY SecMainModuleId

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

	IF EXISTS (
			SELECT Id
			FROM [dbo].[SYSTM000OpnSezMe]
			WHERE Id = @userId
				AND IsSysAdmin = 1
			)
	BEGIN
		SELECT Id AS SecMainModuleId
			,@maxMenuOptionLevelId AS SecMenuOptionLevelId
			,@maxMenuAccessLevelId AS SecMenuAccessLevelId
		FROM [dbo].[SYSTM000Ref_Options]
		WHERE SysLookupId = @mainModuleLookupId;
	END
	ELSE
	BEGIN
		SELECT DISTINCT sbr.Id
			,sbr.[SecMainModuleId]
			,CASE 
				WHEN ISNULL(tmp.ModuleId, 0) > 0
					AND sbr.[SecMenuOptionLevelId] < tmp.OptionLevelMaxId
					THEN tmp.OptionLevelMaxId
				ELSE sbr.[SecMenuOptionLevelId]
				END SecMenuOptionLevelId
			,CASE 
				WHEN ISNULL(tmp.ModuleId, 0) > 0
					AND sbr.[SecMenuAccessLevelId] < tmp.MenuAccessLevelMaxId
					THEN tmp.MenuAccessLevelMaxId
				ELSE sbr.[SecMenuAccessLevelId]
				END SecMenuAccessLevelId
		FROM [dbo].[ORGAN010Ref_Roles](NOLOCK) refRole
		INNER JOIN [dbo].[SYSTM000SecurityByRole](NOLOCK) sbr ON sbr.[OrgRefRoleId] = refRole.[Id]
			AND (sbr.SecMenuOptionLevelId > @minMenuOptionLevelId)
			AND (sbr.SecMenuAccessLevelId > @minMenuAccessLevelId)
		LEFT JOIN #UserRoleTemp tmp ON tmp.ModuleId = sbr.[SecMainModuleId]
		WHERE refRole.[OrgId] = @orgId
			AND refRole.Id = @roleId
			AND (ISNULL(sbr.StatusId, 1) = 1)
	END

	DROP TABLE #UserRoleTemp
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

