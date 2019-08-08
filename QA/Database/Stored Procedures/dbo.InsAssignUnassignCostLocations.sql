SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Prashant Aggawal         
-- Create date:              07/31/2019   
-- Description:               Save all Cost rates under the specified program 
-- =============================================    
CREATE PROCEDURE [dbo].[InsAssignUnassignCostLocations] @userId BIGINT
	,@parentId BIGINT
	,@assign BIT
	,@locationIds VARCHAR(MAX)
	,@vendorIds VARCHAR(MAX) = NULL
	,@enteredBy NVARCHAR(50) = NULL
	,@assignedOn DATETIME2(7) = NULL
AS
BEGIN TRY
	BEGIN TRANSACTION

	DECLARE @success BIT = 0

	IF @assign = 1
	BEGIN
		DECLARE @MaxItemNumber INT

		SELECT @MaxItemNumber = PclItemNumber
		FROM [dbo].[PRGRM043ProgramCostLocations]
		WHERE PclProgramID = @parentId
			AND StatusId IN (
				1
				,2
				)

		IF LEN(ISNULL(@locationIds, '')) > 0
		BEGIN
			-- map vendor locations by location Ids            
			INSERT INTO [dbo].[PRGRM043ProgramCostLocations] (
				PclProgramID
				,PclVendorID
				,PclItemNumber
				,PclLocationCode
				,PclLocationTitle
				,StatusId
				,EnteredBy
				,DateEntered
				)
			SELECT @parentId
				,(
					SELECT VdcVendorID
					FROM VEND040DCLocations
					WHERE Id = Item
					)
				,ISNULL(@MaxItemNumber, 0) + Row_Number() OVER (
					ORDER BY Item
					)
				,(
					SELECT VdcLocationCode
					FROM VEND040DCLocations
					WHERE Id = Item
					)
				,(
					SELECT VdcLocationTitle
					FROM VEND040DCLocations
					WHERE Id = Item
					)
				,1
				,@enteredBy
				,ISNULL(@assignedOn, GETUTCDATE())
			FROM dbo.fnSplitString(@locationIds, ',');

			SET @success = 1
		END

		-- map vendor locations by vendor Ids            
		IF LEN(ISNULL(@vendorIds, '')) > 0
		BEGIN
			SELECT @MaxItemNumber = PclItemNumber
			FROM [dbo].[PRGRM043ProgramCostLocations]
			WHERE PclProgramID = @parentId
				AND StatusId IN (
					1
					,2
					)

			INSERT INTO [dbo].[PRGRM043ProgramCostLocations] (
				PclProgramID
				,PclVendorID
				,PclItemNumber
				,PclLocationCode
				,PclLocationTitle
				,StatusId
				,EnteredBy
				,DateEntered
				)
			SELECT @parentId
				,VdcVendorID
				,ISNULL(@MaxItemNumber, 0) + Row_Number() OVER (
					ORDER BY Id
					)
				,VdcLocationCode
				,VdcLocationTitle
				,1
				,@enteredBy
				,ISNULL(@assignedOn, GETUTCDATE())
			FROM VEND040DCLocations
			WHERE VdcVendorID IN (
					SELECT Item
					FROM dbo.fnSplitString(@vendorIds, ',')
					)
				AND StatusId = 1
				AND VdcLocationCode NOT IN (
					SELECT PclLocationCode
					FROM PRGRM043ProgramCostLocations
					WHERE PclProgramID = @parentId
						AND StatusId IN (
							1
							,2
							)
						AND PclVendorID IN (
							SELECT Item
							FROM dbo.fnSplitString(@vendorIds, ',')
							)
					);

			INSERT INTO [dbo].[PRGRM043ProgramCostLocations] (
				PclProgramID
				,PclVendorID
				,PclItemNumber
				,PclLocationCode
				,PclLocationTitle
				,StatusId
				,EnteredBy
				,DateEntered
				)
			SELECT @parentId
				,Item
				,ISNULL(@MaxItemNumber, 0) + Row_Number() OVER (
					ORDER BY Item
					)
				,(
					SELECT VendCode
					FROM VEND000Master
					WHERE Id = Item
					)
				,(
					SELECT VendTitle
					FROM VEND000Master
					WHERE Id = Item
					)
				,1
				,@enteredBy
				,ISNULL(@assignedOn, GETUTCDATE())
			FROM dbo.fnSplitString(@vendorIds, ',')
			WHERE ITEM NOT IN (
					SELECT VdcVendorID
					FROM VEND040DCLocations
					WHERE vdcvendorId IN (
							SELECT Item
							FROM dbo.fnSplitString(@vendorIds, ',')
							)
						AND StatusId = 1
					);

			SET @success = 1
		END
	END
	ELSE
	BEGIN
		IF LEN(ISNULL(@locationIds, '')) > 0
		BEGIN
			UPDATE BL
			SET BL.StatusId = 3
				,BL.DateChanged = ISNULL(@assignedOn, GETUTCDATE())
				,BL.ChangedBy = @enteredBy
			FROM [dbo].[PRGRM043ProgramCostLocations] BL
			INNER JOIN [dbo].PRGRM051VendorLocations VL ON VL.PVLLocationCode = BL.PclLocationCode
			INNER JOIN dbo.fnSplitString(@LocationIds, ',') TM ON TM.Item = Vl.Id
			WHERE BL.PclProgramID = @parentId
		END

		IF LEN(ISNULL(@vendorIds, '')) > 0
		BEGIN
			UPDATE [dbo].[PRGRM043ProgramCostLocations]
			SET StatusId = 3
				,DateChanged = ISNULL(@assignedOn, GETUTCDATE())
				,ChangedBy = @enteredBy
			WHERE Id IN (
					SELECT Id
					FROM PRGRM043ProgramCostLocations
					WHERE PclVendorID IN (
							SELECT Item
							FROM dbo.fnSplitString(@vendorIds, ',')
							)
						AND StatusId IN (
							1
							,2
							)
					)
				AND PclProgramID = @parentId;
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
				ORDER BY PclItemNumber
				)
		FROM PRGRM043ProgramCostLocations
		WHERE PclProgramID = @parentId
			AND StatusId IN (
				1
				,2
				)
		ORDER BY Id

		MERGE INTO PRGRM043ProgramCostLocations c1
		USING #temptable c2
			ON c1.Id = c2.Id
		WHEN MATCHED
			THEN
				UPDATE
				SET c1.PclItemNumber = c2.PvlItemNumber;

		SET @success = 1
	END

	COMMIT TRANSACTION

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