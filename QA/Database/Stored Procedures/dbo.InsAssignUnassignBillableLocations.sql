SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Prashant Aggarwal
-- Create date:               01/08/2018      
-- Description:               Map vendor Locations
-- Execution:                 EXEC [dbo].[InsAssignUnassignBillableLocations]
-- =============================================  
CREATE PROCEDURE [dbo].[InsAssignUnassignBillableLocations] 
	@userId BIGINT
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

		SELECT @MaxItemNumber = PblItemNumber
		FROM [dbo].[PRGRM042ProgramBillableLocations]
		WHERE PblProgramID = @parentId
			AND StatusId IN (
				1
				,2
				)

		IF LEN(ISNULL(@locationIds, '')) > 0
		BEGIN
		SELECT @parentId PblProgramID
				,(
					SELECT VdcVendorID
					FROM VEND040DCLocations
					WHERE Id = Item
					) PblVendorID
				,ISNULL(@MaxItemNumber, 0) + Row_Number() OVER (
					ORDER BY Item
					) PblItemNumber
				,(
					SELECT VdcLocationCode
					FROM VEND040DCLocations
					WHERE Id = Item
					) PblLocationCode
				,(
					SELECT VdcLocationTitle
					FROM VEND040DCLocations
					WHERE Id = Item
					) PblLocationTitle
				,1 StatusId
				,@enteredBy EnteredBy
				,ISNULL(@assignedOn, GETUTCDATE()) DateEntered INTO #TempBillable
			FROM dbo.fnSplitString(@locationIds, ',')
			-- map vendor locations by location Ids            
			INSERT INTO [dbo].[PRGRM042ProgramBillableLocations] (
				PblProgramID
				,PblVendorID
				,PblItemNumber
				,PblLocationCode
				,PblLocationTitle
				,StatusId
				,EnteredBy
				,DateEntered
				)
			Select PblProgramID
				,PblVendorID
				,PblItemNumber
				,PblLocationCode
				,PblLocationTitle
				,StatusId
				,EnteredBy
				,DateEntered From #TempBillable

				UPDATE PL
				SET [PblLocationCodeVendor] = PVL.pvlLocationCodeCustomer
	                ,[PblUserCode1] = PVL.pvlUserCode1
	                ,[PblUserCode2] = PVL.pvlUserCode2
	                ,[PblUserCode3] = PVL.pvlUserCode3
	                ,[PblUserCode4] = PVL.pvlUserCode4
	                ,[PblUserCode5] = PVL.pvlUserCode5
				FROM [dbo].[PRGRM042ProgramBillableLocations] PL
				INNER JOIN #TempBillable TM ON TM.PblProgramID = PL.PblProgramID AND TM.PblVendorID = PL.PblVendorID AND TM.PblLocationCode = PL.PblLocationCode
				INNER JOIN PRGRM051VendorLocations PVL ON PVL.PvlProgramID = TM.PblProgramID AND PVL.PvlVendorID = TM.PblVendorID AND PVL.PvlLocationCode = TM.PblLocationCode
				Where PL.PBLProgramId=@parentId

				DROP TABLE #TempBillable

			SET @success = 1
		END

		IF LEN(ISNULL(@vendorIds, '')) > 0
		BEGIN
			SELECT @MaxItemNumber = PblItemNumber
			FROM [dbo].[PRGRM042ProgramBillableLocations]
			WHERE PblProgramID = @parentId
				AND StatusId IN (
					1
					,2
					)

            SELECT @parentId PblProgramID
				,VdcVendorID PblVendorID
				,ISNULL(@MaxItemNumber, 0) + Row_Number() OVER (
					ORDER BY Id
					) PblItemNumber
				,VdcLocationCode PblLocationCode
				,VdcLocationTitle PblLocationTitle
				,1 StatusId
				,@enteredBy EnteredBy
				,ISNULL(@assignedOn, GETUTCDATE()) DateEntered INTO #BillableLocation1
			FROM VEND040DCLocations
			WHERE VdcVendorID IN (
					SELECT Item
					FROM dbo.fnSplitString(@vendorIds, ',')
					)
				AND StatusId = 1
				AND VdcLocationCode NOT IN (
					SELECT PblLocationCode
					FROM [dbo].[PRGRM042ProgramBillableLocations]
					WHERE PblProgramID = @parentId
						AND StatusId IN (
							1
							,2
							)
						AND PblVendorID IN (
							SELECT Item
							FROM dbo.fnSplitString(@vendorIds, ',')
							)
					);

			INSERT INTO [dbo].[PRGRM042ProgramBillableLocations] (
				PblProgramID
				,PblVendorID
				,PblItemNumber
				,PblLocationCode
				,PblLocationTitle
				,StatusId
				,EnteredBy
				,DateEntered
				)
				Select PblProgramID
				,PblVendorID
				,PblItemNumber
				,PblLocationCode
				,PblLocationTitle
				,StatusId
				,EnteredBy
				,DateEntered  FROM #BillableLocation1

	            UPDATE PL
				SET [PblLocationCodeVendor] = PVL.pvlLocationCodeCustomer
	                ,[PblUserCode1] = PVL.pvlUserCode1
	                ,[PblUserCode2] = PVL.pvlUserCode2
	                ,[PblUserCode3] = PVL.pvlUserCode3
	                ,[PblUserCode4] = PVL.pvlUserCode4
	                ,[PblUserCode5] = PVL.pvlUserCode5
				FROM [dbo].[PRGRM042ProgramBillableLocations] PL
				INNER JOIN #BillableLocation1 TM ON TM.PblProgramID = PL.PblProgramID AND TM.PblVendorID = PL.PblVendorID AND TM.PblLocationCode = PL.PblLocationCode
				INNER JOIN PRGRM051VendorLocations PVL ON PVL.PvlProgramID = TM.PblProgramID AND PVL.PvlVendorID = TM.PblVendorID AND PVL.PvlLocationCode = TM.PblLocationCode
				Where PL.PBLProgramId=@parentId

				DROP TABLE #BillableLocation1
			

			SELECT @parentId PblProgramID
				,Item PblVendorID
				,ISNULL(@MaxItemNumber, 0) + Row_Number() OVER (
					ORDER BY Item
					) PblItemNumber
				,(
					SELECT VendCode
					FROM VEND000Master
					WHERE Id = Item
					) PblLocationCode
				,(
					SELECT VendTitle
					FROM VEND000Master
					WHERE Id = Item
					) PblLocationTitle
				,1 StatusId
				,@enteredBy EnteredBy
				,ISNULL(@assignedOn, GETUTCDATE()) DateEntered INTO #BillableLocation2
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

			INSERT INTO [dbo].[PRGRM042ProgramBillableLocations] (
				PblProgramID
				,PblVendorID
				,PblItemNumber
				,PblLocationCode
				,PblLocationTitle
				,StatusId
				,EnteredBy
				,DateEntered
				)
				Select PblProgramID
				,PblVendorID
				,PblItemNumber
				,PblLocationCode
				,PblLocationTitle
				,StatusId
				,EnteredBy
				,DateEntered  FROM #BillableLocation2

	            UPDATE PL
				SET [PblLocationCodeVendor] = PVL.pvlLocationCodeCustomer
	                ,[PblUserCode1] = PVL.pvlUserCode1
	                ,[PblUserCode2] = PVL.pvlUserCode2
	                ,[PblUserCode3] = PVL.pvlUserCode3
	                ,[PblUserCode4] = PVL.pvlUserCode4
	                ,[PblUserCode5] = PVL.pvlUserCode5
				FROM [dbo].[PRGRM042ProgramBillableLocations] PL
				INNER JOIN #BillableLocation2 TM ON TM.PblProgramID = PL.PblProgramID AND TM.PblVendorID = PL.PblVendorID AND TM.PblLocationCode = PL.PblLocationCode
				INNER JOIN PRGRM051VendorLocations PVL ON PVL.PvlProgramID = TM.PblProgramID AND PVL.PvlVendorID = TM.PblVendorID AND PVL.PvlLocationCode = TM.PblLocationCode
				Where PL.PBLProgramId=@parentId

				DROP TABLE #BillableLocation2
			

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
			FROM [dbo].[PRGRM042ProgramBillableLocations] BL
			INNER JOIN [dbo].PRGRM051VendorLocations VL ON VL.PVLLocationCode = BL.PblLocationCode
			INNER JOIN dbo.fnSplitString(@LocationIds, ',') TM ON TM.Item = Vl.Id
			WHERE BL.PblProgramID = @parentId
		END

		IF LEN(ISNULL(@vendorIds, '')) > 0
		BEGIN
			UPDATE [dbo].[PRGRM042ProgramBillableLocations]
			SET StatusId = 3
				,DateChanged = ISNULL(@assignedOn, GETUTCDATE())
				,ChangedBy = @enteredBy
			WHERE Id IN (
					SELECT Id
					FROM [dbo].[PRGRM042ProgramBillableLocations]
					WHERE PblVendorID IN (
							SELECT Item
							FROM dbo.fnSplitString(@vendorIds, ',')
							)
						AND StatusId IN (
							1
							,2
							)
					)
				AND PblProgramID = @parentId;
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
				ORDER BY PblItemNumber
				)
		FROM [PRGRM042ProgramBillableLocations]
		WHERE PblProgramID = @parentId
			AND StatusId IN (
				1
				,2
				)
		ORDER BY Id

		MERGE INTO [PRGRM042ProgramBillableLocations] c1
		USING #temptable c2
			ON c1.Id = c2.Id
		WHEN MATCHED
			THEN
				UPDATE
				SET c1.PblItemNumber = c2.PvlItemNumber;

		SET @success = 1

		DROP TABLE #temptable
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