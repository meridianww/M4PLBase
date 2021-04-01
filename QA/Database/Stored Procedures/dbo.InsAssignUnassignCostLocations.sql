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
	,@dateEntered DATETIME2(7)
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
			AND StatusId IN (1, 2)


		IF LEN(ISNULL(@locationIds, '')) > 0
		BEGIN
				SELECT @parentId PclProgramID
			          ,VL.PvlVendorID PclVendorID
			          ,ISNULL(@MaxItemNumber, 0) + Row_Number() OVER (ORDER BY Item) PclItemNumber
			          ,VL.PvlLocationCode PclLocationCode
			          ,VL.PvlLocationTitle PclLocationTitle
			          ,1 StatusId
			          ,@enteredBy EnteredBy
			          ,ISNULL(@assignedOn, @dateEntered) DateEntered
			          ,VL.Id PclID
			          ,VL.VendDCLocationId VendDCLocationId
					  ,VL.PvlLocationCodeCustomer
					  ,VL.PvlUserCode1
					  ,VL.PvlUserCode2
					  ,VL.PvlUserCode3
					  ,VL.PvlUserCode4
					  ,VL.PvlUserCode5
		INTO #LocationTemp
		FROM dbo.PRGRM051VendorLocations VL
		INNER JOIN dbo.fnSplitString(@locationIds, ',') T ON T.Item = VL.Id
		WHERE VL.PvlProgramID = @parentId

			-- map vendor locations by location Ids            
			INSERT INTO [dbo].[PRGRM043ProgramCostLocations] (
				PclVenderLocationId
				,PclVenderDCLocationId
				,PclProgramID
				,PclVendorID
				,PclItemNumber
				,PclLocationCode
				,PclLocationTitle
				,StatusId
				,EnteredBy
				,DateEntered
				,PclLocationCodeCustomer
				,PclUserCode1
				,PclUserCode2
				,PclUserCode3
				,PclUserCode4
				,PclUserCode5
				)
			SELECT PclID
				,VendDCLocationId
				,PclProgramID
				,PclVendorID
				,PclItemNumber
				,PclLocationCode
				,PclLocationTitle
				,StatusId
				,EnteredBy
				,DateEntered
				,PvlLocationCodeCustomer
				,PvlUserCode1
				,PvlUserCode2
				,PvlUserCode3
				,PvlUserCode4
				,PvlUserCode5
			FROM #LocationTemp

			DROP TABLE #LocationTemp

			SET @success = 1
		END

		-- map vendor locations by vendor Ids            
		IF LEN(ISNULL(@vendorIds, '')) > 0
		BEGIN
			SELECT @MaxItemNumber = PclItemNumber
			FROM [dbo].[PRGRM043ProgramCostLocations]
			WHERE PclProgramID = @parentId
				AND StatusId IN (1, 2)

     SELECT @parentId PclProgramID
     	,PvlVendorID PclVendorID
     	,ISNULL(@MaxItemNumber, 0) + Row_Number() OVER (ORDER BY Id) PclItemNumber
     	,PvlLocationCode PclLocationCode
     	,PvlLocationTitle PclLocationTitle
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
     INTO #PRGMTemp1
     FROM PRGRM051VendorLocations VL
     INNER JOIN dbo.fnSplitString(@vendorIds, ',') T1 ON T1.Item = VL.PvlVendorID
     WHERE PvlProgramID = @parentId
	 AND StatusId = 1 AND PvlLocationCode NOT IN (SELECT PclLocationCode FROM PRGRM043ProgramCostLocations PCL
	 INNER JOIN dbo.fnSplitString(@vendorIds, ',') T2 ON T2.Item = PCL.PclVendorID
	 WHERE PclProgramID = @parentId AND StatusId IN (1, 2))

			INSERT INTO [dbo].[PRGRM043ProgramCostLocations] (
				PclVenderLocationId
				,PclVenderDCLocationId
				,PclProgramID
				,PclVendorID
				,PclItemNumber
				,PclLocationCode
				,PclLocationTitle
				,StatusId
				,EnteredBy
				,DateEntered
				,PclLocationCodeCustomer
				,PclUserCode1
				,PclUserCode2
				,PclUserCode3
				,PclUserCode4
				,PclUserCode5
				)
			SELECT PclID
				,VendDCLocationId
				,PclProgramID
				,PclVendorID
				,PclItemNumber
				,PclLocationCode
				,PclLocationTitle
				,StatusId
				,EnteredBy
				,DateEntered
				,PvlLocationCodeCustomer
				,PvlUserCode1
				,PvlUserCode2
				,PvlUserCode3
				,PvlUserCode4
				,PvlUserCode5
			FROM #PRGMTemp1

			DROP TABLE #PRGMTemp1

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
			FROM [dbo].[PRGRM043ProgramCostLocations] BL
			INNER JOIN [dbo].PRGRM051VendorLocations VL ON VL.PVLLocationCode = BL.PclLocationCode
			INNER JOIN dbo.fnSplitString(@LocationIds, ',') TM ON TM.Item = Vl.Id
			WHERE BL.PclProgramID = @parentId
		END

		IF LEN(ISNULL(@vendorIds, '')) > 0
		BEGIN
			UPDATE [dbo].[PRGRM043ProgramCostLocations]
			SET StatusId = 3
				,DateChanged = ISNULL(@assignedOn, @dateEntered)
				,ChangedBy = @enteredBy
			WHERE Id IN (
					SELECT Id
					FROM PRGRM043ProgramCostLocations
					WHERE PclVendorID IN (
							SELECT Item
							FROM dbo.fnSplitString(@vendorIds, ',')
							)
						AND StatusId IN (1, 2)
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
			AND StatusId IN (1, 2)
		ORDER BY Id

		MERGE INTO PRGRM043ProgramCostLocations c1
		USING #temptable c2
			ON c1.Id = c2.Id
		WHEN MATCHED
			THEN
				UPDATE
				SET c1.PclItemNumber = c2.PvlItemNumber;

		DROP TABLE #temptable

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
GO

