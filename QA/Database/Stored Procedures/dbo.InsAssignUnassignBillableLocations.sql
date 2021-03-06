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
	,@dateEntered DATETIME2(7)
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
					SELECT PvlVendorID
					FROM PRGRM051VendorLocations
					WHERE Id = Item
					) PblVendorID
				,ISNULL(@MaxItemNumber, 0) + Row_Number() OVER (
					ORDER BY Item
					) PblItemNumber
				,(
					SELECT PvlLocationCode
					FROM PRGRM051VendorLocations
					WHERE Id = Item
					) PblLocationCode
				,(
					SELECT PvlLocationTitle
					FROM PRGRM051VendorLocations
					WHERE Id = Item
					) PblLocationTitle
				,1 StatusId
				,@enteredBy EnteredBy
				,ISNULL(@assignedOn, @dateEntered) DateEntered
				,(
					SELECT Id
					FROM PRGRM051VendorLocations
					WHERE Id = Item
					) PclID
					,(
					SELECT VendDCLocationId
					FROM PRGRM051VendorLocations
					WHERE Id = Item
					) VendDCLocationId INTO #TempBillable
			FROM dbo.fnSplitString(@locationIds, ',')

			-- map vendor locations by location Ids            
			INSERT INTO [dbo].[PRGRM042ProgramBillableLocations] (
			     PblVenderLocationId
                ,PblVenderDCLocationId 
				,PblProgramID
				,PblVendorID
				,PblItemNumber
				,PblLocationCode
				,PblLocationTitle
				,StatusId
				,EnteredBy
				,DateEntered
				)
			Select PclID,VendDCLocationId, PblProgramID
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
				,PvlVendorID PblVendorID
				,ISNULL(@MaxItemNumber, 0) + Row_Number() OVER (
					ORDER BY Id
					) PblItemNumber
				,PvlLocationCode PblLocationCode
				,PvlLocationTitle PblLocationTitle
				,1 StatusId
				,@enteredBy EnteredBy
				,ISNULL(@assignedOn, @dateEntered) DateEntered,ID PclID, VendDCLocationId INTO #BillableLocation1
			FROM PRGRM051VendorLocations
			WHERE PvlProgramID = @parentId AND PvlVendorID IN (
					SELECT Item
					FROM dbo.fnSplitString(@vendorIds, ',')
					)
				AND StatusId = 1
				AND PvlLocationCode NOT IN (
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
			    PblVenderLocationId
				,PblVenderDCLocationId
				,PblProgramID
				,PblVendorID
				,PblItemNumber
				,PblLocationCode
				,PblLocationTitle
				,StatusId
				,EnteredBy
				,DateEntered
				)
				Select PclID,VendDCLocationId, PblProgramID
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

			SET @success = 1
		END
	END
	ELSE
	BEGIN
		IF LEN(ISNULL(@locationIds, '')) > 0
		BEGIN
			UPDATE BL
			SET BL.StatusId = 3
				,BL.DateChanged = ISNULL(@assignedOn, @dateEntered)
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
				,DateChanged = ISNULL(@assignedOn, @dateEntered)
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

GO
