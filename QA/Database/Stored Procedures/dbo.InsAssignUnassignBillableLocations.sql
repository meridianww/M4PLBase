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
					SELECT PL.Id PclID
	                ,ISNULL(@MaxItemNumber, 0) + Row_Number() OVER (ORDER BY Item) PblItemNumber
	                ,PL.VendDCLocationId VendDCLocationId
	                ,@parentId PblProgramID
	                ,PL.PvlVendorID PblVendorID
	                ,PvlLocationCode PblLocationCode
	                ,PvlLocationTitle PblLocationTitle
	                ,1 StatusId
	                ,@enteredBy EnteredBy
	                ,ISNULL(@assignedOn, @dateEntered) DateEntered
					,PL.PvlLocationCodeCustomer
					,PL.PvlUserCode1
					,PL.PvlUserCode2
					,PL.PvlUserCode3
					,PL.PvlUserCode4
					,PL.PvlUserCode5
	                INTO #TempBillable
                    FROM dbo.PRGRM051VendorLocations PL
                    INNER JOIN dbo.fnSplitString(@locationIds, ',') T ON T.Item = PL.Id
					Where PL.PvlProgramID = @parentId

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
				,PblLocationCodeVendor
				,PblUserCode1
				,PblUserCode2
				,PblUserCode3
				,PblUserCode4
				,PblUserCode5
				)
			Select PclID,VendDCLocationId, PblProgramID
				,PblVendorID
				,PblItemNumber
				,PblLocationCode
				,PblLocationTitle
				,StatusId
				,EnteredBy
				,DateEntered
				,PvlLocationCodeCustomer
				,PvlUserCode1
				,PvlUserCode2
				,PvlUserCode3
				,PvlUserCode4
				,PvlUserCode5
				From #TempBillable

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
	,ISNULL(@assignedOn, @dateEntered) DateEntered
	,ID PclID
	,VendDCLocationId
	,PvlLocationCodeCustomer
	,PvlUserCode1
	,PvlUserCode2
	,PvlUserCode3
	,PvlUserCode4
	,PvlUserCode5
INTO #BillableLocation1
FROM PRGRM051VendorLocations VL
INNER JOIN dbo.fnSplitString(@vendorIds, ',') T ON T.Item = VL.PvlVendorID
WHERE PvlProgramID = @parentId AND VL.StatusId = 1 
AND PvlLocationCode NOT IN (SELECT PblLocationCode FROM [dbo].[PRGRM042ProgramBillableLocations] BL
INNER JOIN dbo.fnSplitString(@vendorIds, ',') T1 ON T1.Item = BL.PblVendorID
WHERE PblProgramID = @parentId AND StatusId IN (1, 2))
           

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
				,PblLocationCodeVendor
				,PblUserCode1
				,PblUserCode2
				,PblUserCode3
				,PblUserCode4
				,PblUserCode5
				)
				Select PclID,VendDCLocationId, PblProgramID
				,PblVendorID
				,PblItemNumber
				,PblLocationCode
				,PblLocationTitle
				,StatusId
				,EnteredBy
				,DateEntered
				,PvlLocationCodeCustomer
				,PvlUserCode1
				,PvlUserCode2
				,PvlUserCode3
				,PvlUserCode4
				,PvlUserCode5
				FROM #BillableLocation1

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
