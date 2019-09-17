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
-- Execution:                 EXEC [dbo].[GetCustomEntityIdByEntityName] 10013, 10036,1,'Customer'
-- =============================================   
CREATE PROCEDURE [dbo].[GetCustomEntityIdByEntityName] 
	(
	@userId BIGINT
	,@roleId BIGINT
	,@orgId BIGINT
	,@entity NVARCHAR(100)
	)
AS
BEGIN
	SET NOCOUNT ON;

	IF NOT EXISTS (
			SELECT 1
			FROM [dbo].[SYSTM000OpnSezMe]
			WHERE Id = 1
				AND IsSysAdmin = 1
			)
	BEGIN
		DECLARE @minMenuOptionLevelId INT
			,@minMenuAccessLevelId INT
			,@maxMenuOptionLevelId INT
			,@maxMenuAccessLevelId INT
			,@mainModuleLookupId INT
			,@menuOptionLevelLookupId INT
			,@menuAccessLevelLookupId INT;

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

		IF NOT EXISTS (
				SELECT 1
				FROM #TempSecurity TS
				INNER JOIN [dbo].[SYSTM000Ref_Options] RO ON RO.Id = TS.SecMainModuleId
				WHERE RO.SysLookupId = @mainModuleLookupId
					AND RO.SysOptionName = @entity
				)
		BEGIN
			IF (@entity = 'Customer')
			BEGIN
				SELECT CB.ConPrimaryRecordId EntityId
				FROM CONTC010Bridge CB
				INNER JOIN [dbo].[SYSTM000OpnSezMe] SM ON SM.SysUserContactId = CB.ContactMSTRID
				WHERE SM.Id = @userId
					AND CB.ConTableName = 'CustContact' AND CB.StatusId IN (1,2)
			END
			ELSE IF (@entity = 'Vendor')
			BEGIN
				SELECT CB.ConPrimaryRecordId EntityId
				FROM CONTC010Bridge CB
				INNER JOIN [dbo].[SYSTM000OpnSezMe] SM ON SM.SysUserContactId = CB.ContactMSTRID
				WHERE SM.Id = @userId
					AND CB.ConTableName = 'VendContact' AND CB.StatusId IN (1,2)
			END
		END

		DROP TABLE #TempSecurity
	END
END
GO

