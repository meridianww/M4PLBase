SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Prashant Aggarwal
-- Create date: 5/7/2020
-- Description:	GetCostCodeListByProgramId 10012,2,null,1234
-- =============================================
CREATE PROCEDURE [dbo].[GetCostCodeListByProgramId] (
	@programId BIGINT
	,@userId BIGINT
	,@locationCode NVARCHAR(150)
	,@jobId BIGINT
	)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @Count INT = 0
		,@CategoryId INT
		,@IsJobReturn BIT

	SELECT @IsJobReturn = CASE 
			WHEN JobType = 'Return'
				THEN CAST(1 AS BIT)
			ELSE CAST(0 AS BIT)
			END
	FROM dbo.JOBDL000Master
	WHERE Id = @jobId

	SELECT @CategoryId = Id
	FROM SYSTM000Ref_Options
	WHERE SysLookupCode = 'RateCategoryType'
		AND SysOptionName = 'Return'

	IF (ISNULL(@programId, 0) = 0)
	BEGIN
		SELECT @programId = ProgramId
			,@locationCode = JobSiteCode
		FROM dbo.JobDL000Master
		WHERE Id = @jobId
	END

	SELECT @Count = Count(Pcr.Id)
	FROM [dbo].[PRGRM041ProgramCostRate] pcr
	INNER JOIN [PRGRM043ProgramCostLocations] pcl ON pcl.Id = pcr.ProgramLocationId
		AND Pcl.StatusId IN (1, 2)
	INNER JOIN [dbo].[fnGetUserStatuses](@userId) fgus ON pcr.StatusId = fgus.StatusId
	WHERE pcl.PclLocationCode = @locationCode
		AND pcl.PclProgramID = @ProgramID

IF OBJECT_ID('tempdb..#CostCodeData') IS NOT NULL DROP TABLE #CostCodeData
	CREATE TABLE #CostCodeData (
		ItemNumber INT
		,ProgramLocationId BIGINT
		,Id BIGINT
		,PcrCode NVARCHAR(150)
		,PcrVendorCode NVARCHAR(150)
		,PcrTitle NVARCHAR(500)
		,RateUnitTypeId INT
		,PcrCostRate [decimal](18, 2)
		,RateTypeId INT
		,PcrElectronicBilling BIT
		,StatusId INT
		,IsDefault BIT
		,[RateCategoryTypeId] [int]
		)

	IF (ISNULL(@Count, 0) = 0)
	BEGIN
		INSERT INTO #CostCodeData (
			ItemNumber
			,Id
			,PcrCode
			,PcrVendorCode
			,PcrTitle
			,RateUnitTypeId
			,PcrCostRate
			,RateTypeId
			,StatusId
			,PcrElectronicBilling
			,IsDefault
			,RateCategoryTypeId
			)
		SELECT TOP 1 CAST(ROW_NUMBER() OVER (
					ORDER BY pcr.[Id]
					) AS INT) ItemNumber
			,pcr.[Id]
			,pcr.[PcrCode]
			,pcr.[PcrVendorCode]
			,pcr.[PcrTitle]
			,pcr.[RateUnitTypeId]
			,pcr.[PcrCostRate]
			,pcr.[RateTypeId]
			,pcr.[StatusId]
			,pcr.[PcrElectronicBilling]
			,CAST(1 AS BIT) IsDefault
			,pcr.RateCategoryTypeId
		FROM [dbo].[PRGRM041ProgramCostRate] pcr
		INNER JOIN [PRGRM043ProgramCostLocations] pcl ON pcl.Id = pcr.ProgramLocationId
			AND Pcl.StatusId IN (1, 2)
		INNER JOIN [dbo].[fnGetUserStatuses](@userId) fgus ON pcr.StatusId = fgus.StatusId
		WHERE pcl.PclLocationCode = 'Default'
			AND pcl.PclProgramID = @ProgramID
			AND CASE 
				WHEN ISNULL(pcr.[PcrCode], '') <> ''
					AND LEN(pcr.[PcrCode]) >= 3
					AND SUBSTRING(pcr.[PcrCode], LEN(pcr.[PcrCode]) - 2, 3) = 'DEL'
					THEN 1
				ELSE 0
				END = 1
		ORDER BY pcr.Id
	END
	ELSE
	BEGIN
		INSERT INTO #CostCodeData (
			ItemNumber
			,Id
			,PcrCode
			,PcrVendorCode
			,PcrTitle
			,RateUnitTypeId
			,PcrCostRate
			,RateTypeId
			,StatusId
			,PcrElectronicBilling
			,IsDefault
			,RateCategoryTypeId
			)
		SELECT CAST(ROW_NUMBER() OVER (
					ORDER BY pcr.[Id]
					) AS INT) ItemNumber
			,pcr.[Id]
			,pcr.[PcrCode]
			,pcr.[PcrVendorCode]
			,pcr.[PcrTitle]
			,pcr.[RateUnitTypeId]
			,pcr.[PcrCostRate]
			,pcr.[RateTypeId]
			,pcr.[StatusId]
			,pcr.[PcrElectronicBilling]
			,CASE 
				WHEN ISNULL(pcr.[PcrCode], '') <> ''
					AND LEN(pcr.[PcrCode]) >= 3
					AND SUBSTRING(pcr.[PcrCode], LEN(pcr.[PcrCode]) - 2, 3) = 'DEL'
					THEN CAST(1 AS BIT)
				ELSE CASE 
						WHEN @locationCode = 'Default'
							THEN CAST(1 AS BIT)
						ELSE CAST(0 AS BIT)
						END
				END IsDefault
			,pcr.RateCategoryTypeId
		FROM [dbo].[PRGRM041ProgramCostRate] pcr
		INNER JOIN [PRGRM043ProgramCostLocations] pcl ON pcl.Id = pcr.ProgramLocationId
			AND Pcl.StatusId IN (1, 2)
		INNER JOIN [dbo].[fnGetUserStatuses](@userId) fgus ON pcr.StatusId = fgus.StatusId
		WHERE pcl.PclLocationCode = @locationCode
			AND pcl.PclProgramID = @ProgramID
		ORDER BY pcr.Id
	END

	IF (ISNULL(@IsJobReturn, 0) = 1)
	BEGIN
		SELECT ItemNumber
			,Id
			,PcrCode
			,PcrVendorCode
			,PcrTitle
			,RateUnitTypeId
			,PcrCostRate
			,RateTypeId
			,StatusId
			,PcrElectronicBilling
			,IsDefault
		FROM #CostCodeData
		WHERE RateCategoryTypeId = @CategoryId
	END
	ELSE
	BEGIN
		SELECT ItemNumber
			,Id
			,PcrCode
			,PcrVendorCode
			,PcrTitle
			,RateUnitTypeId
			,PcrCostRate
			,RateTypeId
			,StatusId
			,PcrElectronicBilling
			,IsDefault
		FROM #CostCodeData
		WHERE RateCategoryTypeId <> @CategoryId
	END

	DROP TABLE #CostCodeData
END
GO

