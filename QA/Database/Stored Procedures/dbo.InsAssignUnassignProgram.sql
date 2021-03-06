SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Janardana         
-- Create date:               12/01/2018      
-- Description:               Map vendor Locations
-- Execution:                 EXEC [dbo].[InsAssignUnassignProgram]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- =============================================  
CREATE PROCEDURE [dbo].[InsAssignUnassignProgram] @userId BIGINT
	,@parentId BIGINT
	,@assign BIT
	,@locationIds VARCHAR(MAX)
	,@vendorIds VARCHAR(MAX) = NULL
	,@enteredBy NVARCHAR(50) = NULL
	,@assignedOn DATETIME2(7) = NULL
	,@dateEntered DATETIME2(7)
AS
BEGIN TRY
	BEGIN TRANSACTION

	DECLARE @success BIT = 0, @UpdatedDCLocationId BIGINT, @BridgeTempCount INT
	DECLARE @DCLocationMapping TABLE (
	   Id BIGINT
		)
	IF @assign = 1
	BEGIN
		DECLARE @MaxItemNumber INT

		SELECT @MaxItemNumber = PvlItemNumber
		FROM [dbo].[PRGRM051VendorLocations]
		WHERE PvlProgramID = @parentId
			AND StatusId IN (
				1
				,2
				)

 IF OBJECT_ID('tempdb..#BridgeTemp') IS NOT NULL
BEGIN
DROP TABLE #BridgeTemp
END
CREATE TABLE #BridgeTemp
	(
	ID INT IDENTITY(1,1),
	VendorId BIGINT,
	VendCode NVARCHAR (120),
	VendTitle NVARCHAR (150),
	ConOrgId INT,
	ContactMSTRID BIGINT,
	ConTableName VARCHAR (150),
	ConPrimaryRecordId NVARCHAR (1000),
	ConTableTypeId INT,
	ConTypeId INT,
	ConItemNumber INT,
	ConCodeId INT,
	ConTitle VARCHAR (150),
	StatusId INT,
	EnteredBy NVARCHAR (150),
	DateEntered DATETIME2
	)

IF LEN(ISNULL(@locationIds, '')) > 0
		BEGIN
			-- map vendor locations by location Ids            
			INSERT INTO [dbo].[PRGRM051VendorLocations] (
			     VendDCLocationId
				,PvlProgramID
				,PvlVendorID
				,PvlItemNumber
				,PvlLocationCode
				,PvlLocationTitle
				,PvlContactMSTRID
				,StatusId
				,EnteredBy
				,DateEntered
				)
			SELECT VD.Id
			    ,@parentId
				,VD.VdcVendorID
				,ISNULL(@MaxItemNumber, 0) + Row_Number() OVER (
					ORDER BY TM.Item
					)
				,VD.VdcLocationCode
				,VD.VdcLocationTitle
				,CB.ContactMSTRID
				,1
				,@enteredBy
				,ISNULL(@assignedOn, @dateEntered)
			FROM VEND040DCLocations VD
			INNER JOIN dbo.fnSplitString(@locationIds, ',') TM ON TM.Item = VD.Id
			INNER JOIN CONTC010Bridge CB ON  CB.ConPrimaryRecordId = VD.Id AND cb.ConTableName ='VendDcLocation'

			--UPDATE Billable
			--SET Billable.PblLocationCode = PVL.PvlLocationCode
			--,Billable.PblLocationTitle = PVL.PvlLocationTitle
			--,Billable.PblLocationCodeVendor = PVL.PvlLocationCodeCustomer
			--FROM PRGRM042ProgramBillableLocations Billable
			--INNER JOIN [dbo].[PRGRM051VendorLocations] PVL ON PVL.VendDCLocationId = Billable.PblVenderDCLocationId AND PVL.StatusId = 1
			--INNER JOIN dbo.fnSplitString(@locationIds, ',') TM ON TM.Item = PVL.VendDCLocationId
			--Where  Billable.PblProgramID = @parentId AND Billable.StatusId = 1

			--UPDATE Location
			--SET Location.PclLocationCode = PVL.PvlLocationCode
			--,Location.PclLocationTitle = PVL.PvlLocationTitle
			--,Location.PclLocationCodeCustomer = PVL.PvlLocationCodeCustomer
			--FROM PRGRM043ProgramCostLocations Location
			--INNER JOIN [dbo].[PRGRM051VendorLocations] PVL ON PVL.VendDCLocationId = Location.PclVenderDCLocationId AND PVL.StatusId = 1
			--INNER JOIN dbo.fnSplitString(@locationIds, ',') TM ON TM.Item = PVL.VendDCLocationId
			--Where  Location.PclProgramID = @parentId AND Location.StatusId = 1

			SET @success = 1
		END

-- map vendor locations by vendor Ids            
IF LEN(ISNULL(@vendorIds, '')) > 0
BEGIN
			SELECT @MaxItemNumber = PvlItemNumber
			FROM [dbo].[PRGRM051VendorLocations]
			WHERE PvlProgramID = @parentId
				AND StatusId IN (
					1
					,2
					)

			DECLARE @conTypeId INT

			SELECT @conTypeId = Id
			FROM [dbo].[SYSTM000Ref_Options]
			WHERE SysLookupCode = 'ContactType'
				AND SysOptionName = 'Vendor'
				AND StatusId = 1

			DECLARE @conTableTypeId INT

			SELECT @conTableTypeId = Id
			FROM [dbo].[SYSTM000Ref_Options]
			WHERE SysLookupCode = 'ContactType'
				AND SysOptionName = 'Consultant'
				AND StatusId = 1

            INSERT INTO #BridgeTemp
			(
			VendorId ,
	VendCode ,
	VendTitle ,
	ConOrgId ,
	ContactMSTRID,
	ConTableName,
	ConPrimaryRecordId,
	ConTableTypeId ,
	ConTypeId ,
	ConItemNumber ,
	ConCodeId ,
	ConTitle,
	StatusId ,
	EnteredBy ,
	DateEntered
			)
			SELECT VD.Id VendorId
				,VendCode
				,VendTitle
				,1 ConOrgId
				,CASE 
					WHEN ISNULL(VD.VendWorkAddressId, '') <> ''
						AND VD.VendWorkAddressId > 0
						THEN VD.VendWorkAddressId
					WHEN ISNULL(VD.VendCorporateAddressId, '') <> ''
						AND VD.VendCorporateAddressId > 0
						THEN VD.VendCorporateAddressId
					WHEN ISNULL(VD.VendBusinessAddressId, '') <> ''
						AND VD.VendBusinessAddressId > 0
						THEN VD.VendBusinessAddressId
					ELSE NULL
					END ContactMSTRID
				,'VendContact' ConTableName
				,TM.Item ConPrimaryRecordId
				,@conTableTypeId ConTableTypeId
				,@conTypeId ConTypeId
				,1 ConItemNumber
				,NULL ConCodeId
				,'Vendor_default' ConTitle
				,1 StatusId
				,@enteredBy EnteredBy
				,ISNULL(@assignedOn,@dateEntered) DateEntered
			FROM VEND000Master VD
			INNER JOIN dbo.fnSplitString(@vendorIds, ',') TM ON TM.Item = VD.Id
			WHERE ITEM NOT IN (
					SELECT VdcVendorID
					FROM VEND040DCLocations
					WHERE vdcvendorId IN (
							SELECT Item
							FROM dbo.fnSplitString(@vendorIds, ',')
							)
						AND StatusId = 1
					);

			Select @BridgeTempCount = Count(ID) From #BridgeTemp

			INSERT INTO [dbo].[PRGRM051VendorLocations] (
			     VendDCLocationId
				,PvlProgramID
				,PvlVendorID
				,PvlItemNumber
				,PvlLocationCode
				,PvlLocationTitle
				,PvlContactMSTRID
				,StatusId
				,EnteredBy
				,DateEntered
				)
			SELECT VD.ID
			    ,@parentId
				,VdcVendorID
				,ISNULL(@MaxItemNumber, 0) + Row_Number() OVER (
					ORDER BY VD.Id
					)
				,VdcLocationCode
				,VdcLocationTitle
				,CB.ContactMSTRID
				,1
				,@enteredBy
				,ISNULL(@assignedOn, @dateEntered)
			FROM VEND040DCLocations VD
			INNER JOIN CONTC010Bridge CB ON  CB.ConPrimaryRecordId = VD.Id AND (CB.ConTableName ='VendDcLocation' OR (CB.ConTableName ='VendContact' AND ConTitle ='Vendor_default'))
			WHERE VD.VdcVendorID IN (
					SELECT Item
					FROM dbo.fnSplitString(@vendorIds, ',')
					)
				AND VD.StatusId = 1
				AND VD.VdcLocationCode NOT IN (
					SELECT PvlLocationCode
					FROM PRGRM051VendorLocations
					WHERE PvlProgramID = @parentId
						AND StatusId IN (
							1
							,2
							)
						AND PvlVendorID IN (
							SELECT Item
							FROM dbo.fnSplitString(@vendorIds, ',')
							)
					);

   --         UPDATE Billable
			--SET Billable.PblLocationCode = PVL.PvlLocationCode
			--,Billable.PblLocationTitle = PVL.PvlLocationTitle
			--,Billable.PblLocationCodeVendor = PVL.PvlLocationCodeCustomer
			--FROM PRGRM042ProgramBillableLocations Billable
			--INNER JOIN [dbo].[PRGRM051VendorLocations] PVL ON PVL.VendDCLocationId = Billable.PblVenderDCLocationId AND PVL.StatusId = 1
			--INNER JOIN dbo.fnSplitString(@vendorIds, ',') TM ON TM.Item = PVL.PvlVendorID
			--Where  Billable.PblProgramID = @parentId AND Billable.StatusId = 1

			--UPDATE Location
			--SET Location.PclLocationCode = PVL.PvlLocationCode
			--,Location.PclLocationTitle = PVL.PvlLocationTitle
			--,Location.PclLocationCodeCustomer = PVL.PvlLocationCodeCustomer
			--FROM PRGRM043ProgramCostLocations Location
			--INNER JOIN [dbo].[PRGRM051VendorLocations] PVL ON PVL.VendDCLocationId = Location.PclVenderDCLocationId AND PVL.StatusId = 1
			--INNER JOIN dbo.fnSplitString(@vendorIds, ',') TM ON TM.Item = PVL.PvlVendorID
			--Where  Location.PclProgramID = @parentId AND Location.StatusId = 1

			IF(ISNULL(@BridgeTempCount,0) > 0)
			BEGIN
			WHILE (@BridgeTempCount > 0)
			BEGIN
			-- Create DC Locations for the vendor When location is not exits        
			INSERT INTO VEND040DCLocations (
				VdcVendorID
				,VdcItemNumber
				,VdcLocationCode
				,VdcCustomerCode
				,VdcLocationTitle
				,StatusId
				,EnteredBy
				,DateEntered
				)
				OUTPUT INSERTED.Id
	          INTO @DCLocationMapping
			SELECT VendorId
				,1
				,VendCode
				,VendCode
				,VendTitle
				,1
				,@enteredBy
				,ISNULL(@assignedOn, @dateEntered)
			FROM #BridgeTemp
			Where Id = @BridgeTempCount

			Select @UpdatedDCLocationId = Id From @DCLocationMapping

			INSERT INTO [dbo].[PRGRM051VendorLocations] (
			     VendDCLocationId
			    ,PvlProgramID
				,PvlVendorID
				,PvlItemNumber
				,PvlLocationCode
				,PvlLocationTitle
				,PvlContactMSTRID
				,StatusId
				,EnteredBy
				,DateEntered
				)
			SELECT @UpdatedDCLocationId
			    ,@parentId
				,VendorId
				,ISNULL(@MaxItemNumber, 0) + Row_Number() OVER (
					ORDER BY VendorId
					)
				,VendCode
				,VendTitle
				,ContactMSTRID
				,1
				,@enteredBy
				,ISNULL(@assignedOn, @dateEntered)
			FROM #BridgeTemp
			Where Id = @BridgeTempCount

			-- Create Vendor Contact end here
			INSERT INTO [dbo].[CONTC010Bridge] (
				[ConOrgId]
				,[ContactMSTRID]
				,[ConTableName]
				,[ConPrimaryRecordId]
				,[ConTableTypeId]
				,[ConTypeId]
				,[ConItemNumber]
				,[ConCodeId]
				,[ConTitle]
				,[StatusId]
				,[EnteredBy]
				,[DateEntered]
				)
			SELECT [ConOrgId]
				,[ContactMSTRID]
				,[ConTableName]
				,[ConPrimaryRecordId]
				,[ConTableTypeId]
				,[ConTypeId]
				,[ConItemNumber]
				,[ConCodeId]
				,[ConTitle]
				,[StatusId]
				,[EnteredBy]
				,[DateEntered]
			FROM #BridgeTemp
			Where Id = @BridgeTempCount
    
			INSERT INTO [dbo].[CONTC010Bridge] (
				[ConOrgId]
				,[ContactMSTRID]
				,[ConTableName]
				,[ConPrimaryRecordId]
				,[ConTableTypeId]
				,[ConTypeId]
				,[ConItemNumber]
				,[ConCodeId]
				,[ConTitle]
				,[StatusId]
				,[EnteredBy]
				,[DateEntered]
				)
			 
			SELECT CB.[ConOrgId]
				,CB.[ContactMSTRID]
				,CB.[ConTableName]
				,VDC.Id
				,CB.[ConTableTypeId]
				,CB.[ConTypeId]
				,CB.[ConItemNumber]
				,CB.[ConCodeId]
				,CB.[ConTitle]
				,CB.[StatusId]
				,CB.[EnteredBy]
				,CB.[DateEntered]
			FROM   #BridgeTemp CB 
			Inner Join VEND040DCLocations  VDC ON CB.VendorId = VDC.VdcVendorID
			WHERE CB.VendorId=VDC.VdcVendorID AND CB.Id = @BridgeTempCount

			--Update vendor contact count
			UPDATE VM
			SET VM.VendContacts = VM.VendContacts + 1
			FROM VEND000Master VM
			INNER JOIN #BridgeTemp TM ON TM.VendorId = VM.Id
			Where TM.Id = @BridgeTempCount

			SET @BridgeTempCount = @BridgeTempCount - 1
			END
			END
			SET @success = 1
		END
	END
	ELSE
	BEGIN
		IF LEN(ISNULL(@locationIds, '')) > 0
		BEGIN
			UPDATE [dbo].[PRGRM051VendorLocations]
			SET StatusId = 3
				,DateChanged = ISNULL(@assignedOn, @dateEntered)
				,ChangedBy = @enteredBy
			WHERE Id IN (
					SELECT Item
					FROM dbo.fnSplitString(@LocationIds, ',')
					)
				AND PvlProgramID = @parentId;

			UPDATE Billable
			SET Billable.StatusId = 3
			FROM PRGRM042ProgramBillableLocations Billable
			INNER JOIN [dbo].[PRGRM051VendorLocations] PVL ON PVL.VendDCLocationId = Billable.PblVenderDCLocationId
			INNER JOIN dbo.fnSplitString(@locationIds, ',') TM ON TM.Item = PVL.VendDCLocationId
			Where  Billable.PblProgramID = @parentId AND Billable.StatusId IN (1,2)

			UPDATE Location
			SET Location.StatusId = 3
			FROM PRGRM043ProgramCostLocations Location
			INNER JOIN [dbo].[PRGRM051VendorLocations] PVL ON PVL.VendDCLocationId = Location.PclVenderDCLocationId
			INNER JOIN dbo.fnSplitString(@locationIds, ',') TM ON TM.Item = PVL.VendDCLocationId
			Where  Location.PclProgramID = @parentId AND Location.StatusId IN (1,2)

			Update Job
			SET Job.JobSiteCode = NULL, Job.VendDCLocationId = NULL
			From JOBDL000Master Job
			INNER JOIN [dbo].[PRGRM051VendorLocations] PVL ON PVL.VendDCLocationId = Job.VendDCLocationId
			INNER JOIN dbo.fnSplitString(@locationIds, ',') TM ON TM.Item = PVL.VendDCLocationId
			Where  Job.ProgramId = @parentId AND Job.StatusId IN (1,2)
		END

		IF LEN(ISNULL(@vendorIds, '')) > 0
		BEGIN
			UPDATE [dbo].[PRGRM051VendorLocations]
			SET StatusId = 3
				,DateChanged = ISNULL(@assignedOn, @dateEntered)
				,ChangedBy = @enteredBy
			WHERE Id IN (
					SELECT Id
					FROM PRGRM051VendorLocations
					WHERE PvlVendorID IN (
							SELECT Item
							FROM dbo.fnSplitString(@vendorIds, ',')
							)
						AND StatusId IN (
							1
							,2
							)
					)
				AND PvlProgramID = @parentId;

			UPDATE Billable
			SET Billable.StatusId = 3
			,Billable.DateChanged = ISNULL(@assignedOn, @dateEntered)
			,Billable.ChangedBy = @enteredBy
			FROM PRGRM042ProgramBillableLocations Billable
			INNER JOIN [dbo].[PRGRM051VendorLocations] PVL ON PVL.VendDCLocationId = Billable.PblVenderDCLocationId
			INNER JOIN dbo.fnSplitString(@vendorIds, ',') TM ON TM.Item = PVL.PvlVendorID
			Where  Billable.PblProgramID = @parentId AND Billable.StatusId IN (1,2)

			UPDATE Location
			SET Location.StatusId = 3
			,Location.DateChanged = ISNULL(@assignedOn, @dateEntered)
			,Location.ChangedBy = @enteredBy
			FROM PRGRM043ProgramCostLocations Location
			INNER JOIN [dbo].[PRGRM051VendorLocations] PVL ON PVL.VendDCLocationId = Location.PclVenderDCLocationId
			INNER JOIN dbo.fnSplitString(@vendorIds, ',') TM ON TM.Item = PVL.PvlVendorID
			Where  Location.PclProgramID = @parentId AND Location.StatusId IN (1,2)

			Update Job
			SET Job.JobSiteCode = NULL, Job.VendDCLocationId = NULL
			From JOBDL000Master Job
			INNER JOIN [dbo].[PRGRM051VendorLocations] PVL ON PVL.VendDCLocationId = Job.VendDCLocationId
			INNER JOIN dbo.fnSplitString(@vendorIds, ',') TM ON TM.Item = PVL.PvlVendorID
			Where  Job.ProgramId = @parentId AND Job.StatusId IN (1,2)
		END

		--Update Item No after delete           
		CREATE TABLE #temptable (
			Id BIGINT
			,PvlItemNumber INT
			)

		INSERT INTO #temptable (
			Id
			,PvlItemNumber
			)
		SELECT Id
			,ROW_NUMBER() OVER (
				ORDER BY PvlItemNumber
				)
		FROM PRGRM051VendorLocations
		WHERE PvlProgramID = @parentId
			AND StatusId IN (
				1
				,2
				)
		ORDER BY Id

		MERGE INTO PRGRM051VendorLocations c1
		USING #temptable c2
			ON c1.Id = c2.Id
		WHEN MATCHED
			THEN
				UPDATE
				SET c1.PvlItemNumber = c2.PvlItemNumber;

		SET @success = 1
	END
	COMMIT TRANSACTION

	IF OBJECT_ID('tempdb..#BridgeTemp') IS NOT NULL
     BEGIN
     DROP TABLE #BridgeTemp
     END
	SELECT @success
END TRY

BEGIN CATCH
	ROLLBACK TRANSACTION

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
