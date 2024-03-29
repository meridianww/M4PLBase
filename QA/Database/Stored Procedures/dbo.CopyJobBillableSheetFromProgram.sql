SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/* Copyright (2019) Meridian Worldwide Transportation Group        
   All Rights Reserved Worldwide */
-- =============================================                
-- Author:                  Nikhil Chauhan          
-- Create date:             08/07/2019              
-- Description:             Copy Billable sheet from program        
-- Execution:               EXEC [dbo].[CopyJobBillableSheetFromProgram] 26609,10012,'2019-10-10','Test','SACRAMENTO CA',2
-- Modified on:          
-- =============================================              
CREATE PROCEDURE [dbo].[CopyJobBillableSheetFromProgram] (
	@JobID BIGINT
	,@ProgramID BIGINT
	,@dateEntered DATETIME2(7)
	,@enteredBy NVARCHAR(50)
	,@jobSiteCode NVARCHAR(30)
	,@userId BIGINT
	)
AS
BEGIN TRY
	IF OBJECT_ID('tempdb..#BillableSheetTemp') IS NOT NULL
	BEGIN
		DROP TABLE #BillableSheetTemp
	END

	CREATE TABLE #BillableSheetTemp (
		[LineNumber] INT IDENTITY(10000, 1)
		,[JobID] [bigint] NULL
		,[prcLineItem] [nvarchar](20) NULL
		,[prcChargeID] [int] NULL
		,[prcChargeCode] [nvarchar](25) NULL
		,[prcTitle] [nvarchar](50) NULL
		,[prcUnitId] [int] NULL
		,[prcRate] [decimal](18, 2) NULL
		,[ChargeTypeId] [int] NULL
		,[PrcElectronicBilling] [Bit] NULL
		,[StatusId] [int] NULL
		,[EnteredBy] [nvarchar](50) NULL
		,[DateEntered] [datetime2](7) NULL
		)

	IF (ISNULL(@jobSiteCode, '') <> '')
	BEGIN
		IF EXISTS (
				SELECT 1
				FROM PRGRM042ProgramBillableLocations PBL
				INNER JOIN [dbo].[PRGRM040ProgramBillableRate] Pbr ON pbr.ProgramLocationId = PBL.Id
				INNER JOIN [dbo].[fnGetUserStatuses](@userId) STA ON STA.StatusId = PBL.StatusId
				WHERE PBL.PblLocationCode = @jobSiteCode
					AND PBL.PblProgramID = @ProgramID
					AND PBL.StatusId IN (
						1
						,2
						)
				)
		BEGIN
			INSERT INTO #BillableSheetTemp (
				[JobID]
				,[prcLineItem]
				,[prcChargeID]
				,[prcChargeCode]
				,[prcTitle]
				,[prcUnitId]
				,[prcRate]
				,[ChargeTypeId]
				,[PrcElectronicBilling]
				,[StatusId]
				,[EnteredBy]
				,[DateEntered]
				)
			SELECT @JobID
				,ROW_NUMBER() OVER (
					ORDER BY Pbr.[Id]
					) -- this line needs to be updated 
				,Pbr.[Id]
				,Pbr.[PbrCode]
				,Pbr.[PbrTitle]
				,Pbr.[RateUnitTypeId]
				,Pbr.[PbrBillablePrice]
				,Pbr.[RateTypeId]
				,Pbr.[PbrElectronicBilling]
				,pbr.[StatusId]
				,@enteredBy
				,@dateEntered
			FROM [dbo].[PRGRM040ProgramBillableRate] Pbr
			INNER JOIN PRGRM042ProgramBillableLocations pbl ON pbl.Id = pbr.ProgramLocationId
				AND PBL.StatusId IN (
					1
					,2
					)
			INNER JOIN [dbo].[fnGetUserStatuses](@userId) fgus ON pbr.StatusId = fgus.StatusId
			WHERE PBL.PblLocationCode = @jobSiteCode
				AND pbl.PblProgramID = @ProgramID
			ORDER BY pbr.Id
		END
		ELSE
		BEGIN
			INSERT INTO #BillableSheetTemp (
				[JobID]
				,[prcLineItem]
				,[prcChargeID]
				,[prcChargeCode]
				,[prcTitle]
				,[prcUnitId]
				,[prcRate]
				,[ChargeTypeId]
				,[PrcElectronicBilling]
				,[StatusId]
				,[EnteredBy]
				,[DateEntered]
				)
			SELECT @JobID
				,ROW_NUMBER() OVER (
					ORDER BY Pbr.[Id]
					) -- this line needs to be updated  
				,Pbr.[Id]
				,Pbr.[PbrCode]
				,Pbr.[PbrTitle]
				,Pbr.[RateUnitTypeId]
				,Pbr.[PbrBillablePrice]
				,Pbr.[RateTypeId]
				,Pbr.[PbrElectronicBilling]
				,Pbr.[StatusId]
				,@enteredBy
				,@dateEntered
			FROM [dbo].[PRGRM040ProgramBillableRate] Pbr
			INNER JOIN PRGRM042ProgramBillableLocations pbl ON pbl.Id = pbr.ProgramLocationId
				AND PBL.StatusId IN (
					1
					,2
					)
			INNER JOIN [dbo].[fnGetUserStatuses](@userId) fgus ON Pbr.StatusId = fgus.StatusId
			WHERE pbl.pblProgramID = @ProgramID
				AND Pbl.PblLocationCode = 'Default'
			AND CASE WHEN ISNULL(pbr.[PbrCode], '') <> '' AND LEN(pbr.[PbrCode]) >= 3 AND SUBSTRING(pbr.[PbrCode], LEN(pbr.[PbrCode]) - 2, 3) = 'DEL'THEN 1 ELSE 0 END = 1
			ORDER BY Pbr.Id
		END
	END
	ELSE
	BEGIN
		INSERT INTO #BillableSheetTemp (
			[JobID]
			,[prcLineItem]
			,[prcChargeID]
			,[prcChargeCode]
			,[prcTitle]
			,[prcUnitId]
			,[prcRate]
			,[ChargeTypeId]
			,[PrcElectronicBilling]
			,[StatusId]
			,[EnteredBy]
			,[DateEntered]
			)
		SELECT @JobID
			,ROW_NUMBER() OVER (
				ORDER BY Pbr.[Id]
				) -- this line needs to be updated  
			,Pbr.[Id]
			,Pbr.[PbrCode]
			,Pbr.[PbrTitle]
			,Pbr.[RateUnitTypeId]
			,Pbr.[PbrBillablePrice]
			,Pbr.[RateTypeId]
			,Pbr.[PbrElectronicBilling]
			,Pbr.[StatusId]
			,@enteredBy
			,@dateEntered
		FROM [dbo].[PRGRM040ProgramBillableRate] Pbr
		INNER JOIN PRGRM042ProgramBillableLocations pbl ON pbl.Id = pbr.ProgramLocationId
			AND PBL.StatusId IN (
				1
				,2
				)
		INNER JOIN [dbo].[fnGetUserStatuses](@userId) fgus ON Pbr.StatusId = fgus.StatusId
		WHERE pbl.pblProgramID = @ProgramID
			AND Pbl.PblLocationCode = 'Default'
			AND CASE WHEN ISNULL(pbr.[PbrCode], '') <> '' AND LEN(pbr.[PbrCode]) >= 3 AND SUBSTRING(pbr.[PbrCode], LEN(pbr.[PbrCode]) - 2, 3) = 'DEL'THEN 1 ELSE 0 END = 1
		ORDER BY Pbr.Id
	END

	INSERT INTO [dbo].[JOBDL061BillableSheet] (
		[LineNumber]
		,[JobID]
		,[prcLineItem]
		,[prcChargeID]
		,[prcChargeCode]
		,[prcTitle]
		,[prcUnitId]
		,[prcRate]
		,[ChargeTypeId]
		,[PrcElectronicBilling]
		,[PrcQuantity]
		,[StatusId]
		,[EnteredBy]
		,[DateEntered]
		)
	SELECT [LineNumber]
		,[JobID]
		,[prcLineItem]
		,[prcChargeID]
		,[prcChargeCode]
		,[prcTitle]
		,[prcUnitId]
		,[prcRate]
		,[ChargeTypeId]
		,[PrcElectronicBilling]
		,1
		,[StatusId]
		,[EnteredBy]
		,[DateEntered]
	FROM #BillableSheetTemp

	EXEC [dbo].[UpdateLineNumberForJobBillableSheet] @JobID

	DROP TABLE #BillableSheetTemp
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
