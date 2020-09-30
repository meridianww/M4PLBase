/* Copyright (2020) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Prashant Aggarwal        
-- Create date:               08/17/2020      
-- Description:               Ins a Driver Contact To Job
-- Execution:                 EXEC [dbo].[InsDriverContact]
-- ============================================= 
ALTER PROCEDURE [dbo].[InsDriverContact] @userId BIGINT = NULL
	,@roleId BIGINT = NULL
	,@entity NVARCHAR(100) = NULL
	,@orgId BIGINT = 1
	,@bizMoblContactID NVARCHAR(50)
	,@locationCode NVARCHAR(50)
	,@firstName NVARCHAR(50)
	,@lastName NVARCHAR(50)
	,@jobId BIGINT
	,@routeId NVARCHAR(20) = NULL
	,@JobStop NVARCHAR(20) = NULL
	,@enteredBy NVARCHAR(50)
	,@dateEntered DateTime2(7)
AS
BEGIN TRY
		DECLARE @conBusinessAddress1 VARCHAR(MAX) = NULL
		,@conBusinessAddress2 VARCHAR(200) = NULL
		,@conBusinessCity VARCHAR(MAX) = NULL
		,@conBusinessStateId INT = NULL
		,@conBusinessZipPostal VARCHAR(MAX) = NULL
		,@conBusinessCountryId INT = NULL
	IF EXISTS (
			SELECT 1
			FROM [dbo].[JOBDL000Master]
			WHERE Id = @jobId
				AND StatusId = (
					SELECT ID
					FROM [SYSTM000Ref_Options]
					WHERE [SysOptionName] = 'Active'
						AND [SysLookupCode] = 'Status'
					)
			)
	BEGIN
		DECLARE @driverId BIGINT = 0
		,@conCodeId INT = 0
		,@conTypeId INT = 0
		,@dcLocationId INT = 0
		,@masterContactId BIGINT = 0
		

		SELECT @conCodeId = ID
		FROM [dbo].[ORGAN010Ref_Roles]
		WHERE OrgRoleCode LIKE '%DRIVER%'
			AND StatusId = 1
			AND OrgID = @orgId

		SELECT @conTypeId = ID
		FROM [SYSTM000Ref_Options]
		WHERE SysLookupCode = 'ContactType'
			AND SysOptionName LIKE '%DRIVER%'

		SELECT TOP 1 @dcLocationId = VDCL.ID
		,@conBusinessAddress1 = COMPADD.Address1
		,@conBusinessAddress2 = COMPADD.Address2
		,@conBusinessCity = COMPADD.City
		,@conBusinessStateId = COMPADD.StateId
		,@conBusinessZipPostal = COMPADD.ZipPostal
		,@conBusinessCountryId = COMPADD.CountryId
		FROM [JOBDL000Master] JB
		INNER JOIN PRGRM051VendorLocations PVL ON PVL.PvlProgramID = JB.ProgramID
		INNER JOIN VEND040DCLocations VDCL ON VDCL.ID = PVL.VendDCLocationId 
		INNER JOIN VEND000Master VEND ON VEND.Id = VDCL.VdcVendorID
		INNER JOIN COMP000Master COMP ON COMP.CompPrimaryRecordId = VEND.Id AND COMP.CompTableName = 'Vendor'
		LEFT JOIN COMPADD000Master COMPADD ON COMPADD.AddCompId = COMP.Id
		INNER JOIN SYSTM000Ref_Options OPT ON OPT.Id = COMPADD.AddTypeId AND SYSOPTIONNAME = 'BUSINESS'
		WHERE JB.Id = @jobId AND VDCL.VdcLocationCode = @locationCode

		IF (ISNULL(@dcLocationId, 0) <> 0)
		BEGIN
			IF NOT EXISTS (
					SELECT TOP 1 1
					FROM CONTC000Master
					WHERE ConTypeId = @conTypeId
						AND StatusId = 1
						AND ConUDF02 = @bizMoblContactID
					)
			BEGIN
				IF EXISTS (
						SELECT TOP 1 1
						FROM CONTC000Master
						WHERE ConFirstName = @firstName
							AND ConLastName = @lastName
							AND ConTypeId = @conTypeId
							AND StatusId = 1
							AND ConUDF02 IS NULL
						)
				BEGIN
					SELECT @masterContactId = ID
					FROM CONTC000Master
					WHERE ConFirstName = @firstName
						AND ConLastName = @lastName
						AND ConTypeId = @conTypeId
						AND StatusId = 1
					ORDER BY ID DESC

					UPDATE CONTC000Master
					SET [ConUDF02] = @bizMoblContactID
					WHERE ID = (
							SELECT TOP 1 ID
							FROM CONTC000Master
							WHERE ConFirstName = @firstName
								AND ConLastName = @lastName
								AND ConTypeId = @conTypeId
								AND StatusId = 1
							ORDER BY ID DESC
							)
				END
				ELSE
				BEGIN
					DECLARE @compId BIGINT = 0
					DECLARE @compTitle NVARCHAR(100)

					SELECT @compId = COMP.Id
						,@compTitle = COMP.CompTitle
					FROM [COMP000Master] COMP
					INNER JOIN [VEND000Master] VM ON VM.Id = COMP.CompPrimaryRecordId
						AND VM.STATUSID = 1
						AND COMP.CompTableName = 'Vendor'
					INNER JOIN VEND040DCLocations VDCL ON COMP.CompPrimaryRecordId = VDCL.VdcVendorID
						AND VDCL.StatusId = 1
						AND VDCL.Id = @dcLocationId
					
					INSERT INTO CONTC000Master (
						[ConOrgId]
						,[ConLastName]
						,[ConFirstName]
						,[ConEmailAddress]
						,[StatusId]
						,[ConTypeId]
						,[ConUDF02]
						,[ConCompanyId]
						,[ConCompanyName]
						,[ConJobTitle]
						,[ConBusinessAddress1]
						,[ConBusinessAddress2]
						,[ConBusinessCity]
						,[ConBusinessStateId]
						,[ConBusinessZipPostal]
						,[ConBusinessCountryId]
						,[EnteredBy]
						,[DateEntered]
						)
					VALUES (
						@orgId
						,@lastName
						,@firstName
						,(
							SELECT CONCAT (
									@bizMoblContactID
									,'@'
									,@locationCode
									,'.com'
									)
							)
						,1
						,@conTypeId
						,@bizMoblContactID
						,@compId
						,@compTitle
						,'Driver'
						,@conBusinessAddress1
						,@conBusinessAddress2
						,@conBusinessCity
						,@conBusinessStateId
						,@conBusinessZipPostal
						,@conBusinessCountryId
						,@enteredBy
						,@dateEntered
						)

					SET @masterContactId = SCOPE_IDENTITY();
				END
			END
			ELSE
			BEGIN
				SELECT @masterContactId = ID
				FROM CONTC000Master
				WHERE ConFirstName = @firstName
					AND ConLastName = @lastName
					AND ConTypeId = @conTypeId
					AND StatusId = 1
				ORDER BY ID DESC

				IF NOT EXISTS (
						SELECT TOP 1 1
						FROM CONTC000Master
						WHERE ConFirstName = @firstName
							AND ConLastName = @lastName
							AND ConTypeId = @conTypeId
							AND StatusId = 1
							AND ConUDF02 = @bizMoblContactID
						)
					UPDATE CONTC000Master
					SET ConFirstName = @firstName
						,ConLastName = @lastName
					WHERE ConUDF02 = @bizMoblContactID
			END

			SELECT @driverId = CM.Id
			FROM [JOBDL000Master] JB
			INNER JOIN PRGRM051VendorLocations PVL ON PVL.PvlProgramID = JB.ProgramID
			INNER JOIN VEND040DCLocations VDCL ON VDCL.ID = PVL.VendDCLocationId
			INNER JOIN [CONTC010Bridge] CB ON CB.ConPrimaryRecordId = VDCL.ID
				AND CB.ConTableName = 'VendDcLocationContact'
				AND CB.ConCodeId = @conCodeId
				AND CB.ConTypeId = @conTypeId
			INNER JOIN CONTC000Master CM ON CM.Id = CB.ContactMSTRID
			WHERE VDCL.VdcLocationCode = @locationCode
				AND CM.ConFirstName = @firstName
				AND CM.ConLastName = @lastName
				AND CM.ConUDF02 = @bizMoblContactID
				AND JB.Id = @jobId
				AND VDCL.StatusId = 1
				AND PVL.StatusId = 1

			IF (ISNULL(@driverId, 0) <> 0)
			BEGIN
				UPDATE [JOBDL000Master]
				SET JobDriverId = @driverId,
				JobRouteId = @routeId,
				JobStop = @JobStop
				WHERE Id = @jobId

				SELECT Id
					,@locationCode AS locationCode
					,ConFirstName AS firstName
					,ConLastName AS lastName
					,[ConUDF02] AS bizMoblContactID
					,@jobId AS jobId
				FROM CONTC000Master
				WHERE ID = @driverId
			END
			ELSE
			BEGIN
				UPDATE [JOBDL000Master]
				SET JobDriverId = @masterContactId,
				JobRouteId = @routeId,
				JobStop = @JobStop
				WHERE Id = @jobId

				INSERT INTO dbo.CONTC010Bridge (
					ConOrgId
					,ContactMSTRID
					,ConTableName
					,ConPrimaryRecordId
					,ConItemNumber
					,ConTitle
					,ConCodeId
					,ConTypeId
					,StatusId
					,ConIsDefault
					,ConDescription
					,ConInstruction
					,ConTableTypeId
					,EnteredBy
					,DateEntered
					,ChangedBy
					,DateChanged
					)
				VALUES (
					1
					,@masterContactId
					,'VendDcLocationContact'
					,@dcLocationId
					,3
					,'Driver'
					,@conCodeId
					,@conTypeId
					,1
					,NULL
					,NULL
					,NULL
					,183
					,@enteredBy
					,@dateEntered
					,NULL
					,NULL
					)

				SELECT Id
					,@locationCode AS locationCode
					,ConFirstName AS firstName
					,ConLastName AS lastName
					,ConUDF02 AS bizMoblContactID
					,@jobId AS jobId
				FROM CONTC000Master
				WHERE ID = @masterContactId
			END
		END
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