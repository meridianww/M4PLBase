SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/* Copyright (2019) Meridian Worldwide Transportation Group        
   All Rights Reserved Worldwide */
-- =============================================                
-- Author:                  Nikhil Chauhan          
-- Create date:             08/06/2019              
-- Description:             Copy cost sheet from program        
-- Execution:               EXEC [dbo].[CopyJobCostSheetFromProgram]   26609,10012,'2019-10-10','Test','SACRAMENTO',2
-- Modified on:          
-- =============================================              
CREATE PROCEDURE [dbo].[CopyJobCostSheetFromProgram] (
	 @JobID BIGINT
	,@ProgramID BIGINT
	,@dateEntered DATETIME2(7)
	,@enteredBy NVARCHAR(50)
	,@jobSiteCode NVARCHAR(30)
	,@userId BIGINT
	)
AS
BEGIN TRY
	IF OBJECT_ID('tempdb..#CostSheetTemp') IS NOT NULL
	BEGIN
		DROP TABLE #CostSheetTemp
	END

	CREATE TABLE #CostSheetTemp (
		[LineNumber] INT IDENTITY(10000, 1)
		,[JobID] [bigint] NULL
		,[CstLineItem] [nvarchar](20) NULL
		,[CstChargeID] [int] NULL
		,[CstChargeCode] [nvarchar](25) NULL
		,[CstTitle] [nvarchar](50) NULL
		,[CstUnitId] [int] NULL
		,[CstRate] [decimal](18, 2) NULL
		,[ChargeTypeId] [int] NULL
		,[CstElectronicBilling] BIT NULL
		,[StatusId] [int] NULL
		,[EnteredBy] [nvarchar](50) NULL
		,[DateEntered] [datetime2](7) NULL
		)

	IF (ISNULL(@jobSiteCode, '') <> '')
	BEGIN
		IF EXISTS (
				SELECT 1
				FROM PRGRM043ProgramCostLocations Pcl
				INNER JOIN [dbo].[fnGetUserStatuses](@userId) STA ON STA.StatusId = Pcl.StatusId
				INNER JOIN [dbo].[PRGRM041ProgramCostRate] pcr ON pcr.ProgramLocationId = pcl.Id
				WHERE Pcl.PclLocationCode = @jobSiteCode
					AND Pcl.PclProgramID = @ProgramID
					AND Pcl.StatusId IN (1,2)
				)
		BEGIN
			INSERT INTO #CostSheetTemp (
				[JobID]
				,[CstLineItem]
				,[CstChargeID]
				,[CstChargeCode]
				,[CstTitle]
				,[CstUnitId]
				,[CstRate]
				,[ChargeTypeId]
				,[CstElectronicBilling]
				,[StatusId]
				,[EnteredBy]
				,[DateEntered]
				)
			SELECT @JobID
				,ROW_NUMBER() OVER (
					ORDER BY pcr.[Id]
					) 
				,pcr.[Id]
				,pcr.[PcrCode]
				,pcr.[PcrTitle]
				,pcr.[RateUnitTypeId]
				,pcr.[PcrCostRate]
				,pcr.[RateTypeId]
				,pcr.[PcrElectronicBilling]
				,pcr.[StatusId]
				,@enteredBy
				,@dateEntered
			FROM [dbo].[PRGRM041ProgramCostRate] pcr
			INNER JOIN [PRGRM043ProgramCostLocations] pcl ON pcl.Id = pcr.ProgramLocationId AND Pcl.StatusId IN (1,2)
			INNER JOIN [dbo].[fnGetUserStatuses](@userId) fgus ON pcr.StatusId = fgus.StatusId
			WHERE Pcl.PclLocationCode = @jobSiteCode
				AND pcl.PclProgramID = @ProgramID
			ORDER BY pcr.Id
		END
		ELSE
		BEGIN
			INSERT INTO #CostSheetTemp (
				[JobID]
				,[CstLineItem]
				,[CstChargeID]
				,[CstChargeCode]
				,[CstTitle]
				,[CstUnitId]
				,[CstRate]
				,[ChargeTypeId]
				,[CstElectronicBilling]
				,[StatusId]
				,[EnteredBy]
				,[DateEntered]
				)
			SELECT @JobID
				,ROW_NUMBER() OVER (
					ORDER BY pcr.[Id]
					) 
				,pcr.[Id]
				,pcr.[PcrCode]
				,pcr.[PcrTitle]
				,pcr.[RateUnitTypeId]
				,pcr.[PcrCostRate]
				,pcr.[RateTypeId]
				,pcr.[PcrElectronicBilling]
				,pcr.[StatusId]
				,@enteredBy
				,@dateEntered
			FROM [dbo].[PRGRM041ProgramCostRate] pcr
			INNER JOIN [PRGRM043ProgramCostLocations] pcl ON pcl.Id = pcr.ProgramLocationId AND Pcl.StatusId IN (1,2)
			INNER JOIN [dbo].[fnGetUserStatuses](@userId) fgus ON pcr.StatusId = fgus.StatusId
			WHERE pcl.PclProgramID = @ProgramID AND Pcl.PclLocationCode = 'Default' 
			AND CASE WHEN ISNULL(pcr.[PcrCode], '') <> '' AND LEN(pcr.[PcrCode]) >= 3 AND SUBSTRING(pcr.[PcrCode], LEN(pcr.[PcrCode]) - 2, 3) = 'DEL'THEN 1 ELSE 0 END = 1
			ORDER BY pcr.Id
		END
	END
	ELSE
	BEGIN
		INSERT INTO #CostSheetTemp (
			[JobID]
			,[CstLineItem] 
			,[CstChargeID]
			,[CstChargeCode]
			,[CstTitle]
			,[CstUnitId]
			,[CstRate]
			,[ChargeTypeId]
			,[CstElectronicBilling]
			,[StatusId]
			,[EnteredBy]
			,[DateEntered]
			)
		SELECT @JobID
			,ROW_NUMBER() OVER (
				ORDER BY pcr.[Id]
				) -- this line needs to be updated 
			,pcr.[Id]
			,pcr.[PcrCode]
			,pcr.[PcrTitle]
			,pcr.[RateUnitTypeId]
			,pcr.[PcrCostRate]
			,pcr.[RateTypeId]
			,pcr.[PcrElectronicBilling]
			,pcr.[StatusId]
			,@enteredBy
			,@dateEntered
		FROM [dbo].[PRGRM041ProgramCostRate] pcr
		INNER JOIN [PRGRM043ProgramCostLocations] pcl ON pcl.Id = pcr.ProgramLocationId AND Pcl.StatusId IN (1,2)
		INNER JOIN [dbo].[fnGetUserStatuses](@userId) fgus ON pcr.StatusId = fgus.StatusId
		WHERE pcl.PclProgramID = @ProgramID AND Pcl.PclLocationCode = 'Default' 
		AND CASE WHEN ISNULL(pcr.[PcrCode], '') <> '' AND LEN(pcr.[PcrCode]) >= 3 AND SUBSTRING(pcr.[PcrCode], LEN(pcr.[PcrCode]) - 2, 3) = 'DEL'THEN 1 ELSE 0 END = 1
		ORDER BY pcr.Id
	END

	INSERT INTO [dbo].[JOBDL062CostSheet] (
		 [LineNumber]
		,[JobID]
		,[CstLineItem]
		,[CstChargeID]
		,[CstChargeCode]
		,[CstTitle]
		,[CstUnitId]
		,[CstRate]
		,[ChargeTypeId]
		,[CstQuantity]
		,[CstElectronicBilling]
		,[StatusId]
		,[EnteredBy]
		,[DateEntered]
		)
	SELECT [LineNumber]
		,[JobID]
		,[CstLineItem]
		,[CstChargeID]
		,[CstChargeCode]
		,[CstTitle]
		,[CstUnitId]
		,[CstRate]
		,[ChargeTypeId]
		,1
		,[CstElectronicBilling]
		,[StatusId]
		,[EnteredBy]
		,[DateEntered]
	FROM #CostSheetTemp

	EXEC [dbo].[UpdateLineNumberForJobCostSheet] @JobID
	DROP TABLE #CostSheetTemp
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
