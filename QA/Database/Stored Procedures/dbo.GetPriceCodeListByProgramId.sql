SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Prashant Aggarwal
-- Create date: 5/7/2020
-- Description:	GetPriceCodeListByProgramId 10012,2,' CA',1234
-- =============================================
CREATE PROCEDURE [dbo].[GetPriceCodeListByProgramId] (
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

	SELECT @Count = Count(Pbr.Id)
	FROM [dbo].[PRGRM040ProgramBillableRate] Pbr
	INNER JOIN PRGRM042ProgramBillableLocations pbl ON pbl.Id = pbr.ProgramLocationId
		AND Pbl.StatusId IN (1, 2)
	INNER JOIN [dbo].[fnGetUserStatuses](@userId) fgus ON pbr.StatusId = fgus.StatusId
	WHERE PblProgramId = @programId
		AND PBLLocationCode = @locationCode

IF OBJECT_ID('tempdb..#PriceCodeData') IS NOT NULL DROP TABLE #PriceCodeData
	CREATE TABLE #PriceCodeData (
		ItemNumber INT
		,ProgramLocationId BIGINT
		,Id BIGINT
		,PbrCode NVARCHAR(150)
		,PbrCustomerCode NVARCHAR(150)
		,PbrTitle NVARCHAR(500)
		,RateUnitTypeId INT
		,PbrBillablePrice [decimal](18, 2)
		,RateTypeId INT
		,PbrElectronicBilling BIT
		,StatusId INT
		,IsDefault BIT
		,[RateCategoryTypeId] [int]
		)

	IF (ISNULL(@Count, 0) = 0)
	BEGIN
		INSERT INTO #PriceCodeData (
			ItemNumber
			,ProgramLocationId
			,Id
			,PbrCode
			,PbrCustomerCode
			,PbrTitle
			,RateUnitTypeId
			,PbrBillablePrice
			,RateTypeId
			,PbrElectronicBilling
			,StatusId
			,IsDefault
			,RateCategoryTypeId
			)
		SELECT TOP 1 CAST(ROW_NUMBER() OVER (
					ORDER BY Pbr.[Id]
					) AS INT) ItemNumber
			,Pbr.ProgramLocationId
			,Pbr.[Id]
			,Pbr.[PbrCode]
			,Pbr.PbrCustomerCode
			,Pbr.[PbrTitle]
			,Pbr.[RateUnitTypeId]
			,Pbr.[PbrBillablePrice]
			,Pbr.[RateTypeId]
			,Pbr.[PbrElectronicBilling]
			,Pbr.[StatusId]
			,CAST(1 AS BIT) IsDefault
			,Pbr.RateCategoryTypeId
		FROM [dbo].[PRGRM040ProgramBillableRate] Pbr
		INNER JOIN PRGRM042ProgramBillableLocations pbl ON pbl.Id = pbr.ProgramLocationId
			AND PBL.StatusId IN (1, 2)
		INNER JOIN [dbo].[fnGetUserStatuses](@userId) fgus ON Pbr.StatusId = fgus.StatusId
		WHERE pbl.PblLocationCode = 'Default'
			AND pbl.pblProgramID = @programId
			AND CASE 
				WHEN ISNULL(Pbr.[PbrCode], '') <> ''
					AND LEN(Pbr.[PbrCode]) >= 3
					AND SUBSTRING(Pbr.[PbrCode], LEN(Pbr.[PbrCode]) - 2, 3) = 'DEL'
					THEN 1
				ELSE 0
				END = 1
		ORDER BY Pbr.Id
	END
	ELSE
	BEGIN
		INSERT INTO #PriceCodeData (
			ItemNumber
			,ProgramLocationId
			,Id
			,PbrCode
			,PbrCustomerCode
			,PbrTitle
			,RateUnitTypeId
			,PbrBillablePrice
			,RateTypeId
			,PbrElectronicBilling
			,StatusId
			,IsDefault
			,RateCategoryTypeId
			)
		SELECT CAST(ROW_NUMBER() OVER (
					ORDER BY Pbr.[Id]
					) AS INT) ItemNumber
			,Pbr.ProgramLocationId
			,Pbr.[Id]
			,Pbr.[PbrCode]
			,Pbr.PbrCustomerCode
			,Pbr.[PbrTitle]
			,Pbr.[RateUnitTypeId]
			,Pbr.[PbrBillablePrice]
			,Pbr.[RateTypeId]
			,Pbr.[PbrElectronicBilling]
			,Pbr.[StatusId]
			,CASE 
				WHEN ISNULL(Pbr.[PbrCode], '') <> ''
					AND LEN(Pbr.[PbrCode]) >= 3
					AND SUBSTRING(Pbr.[PbrCode], LEN(Pbr.[PbrCode]) - 2, 3) = 'DEL'
					THEN CAST(1 AS BIT)
				ELSE CAST(0 AS BIT)
				END IsDefault
			,Pbr.RateCategoryTypeId
		FROM [dbo].[PRGRM040ProgramBillableRate] Pbr
		INNER JOIN PRGRM042ProgramBillableLocations pbl ON pbl.Id = pbr.ProgramLocationId
			AND PBL.StatusId IN (1, 2)
		INNER JOIN [dbo].[fnGetUserStatuses](@userId) fgus ON Pbr.StatusId = fgus.StatusId
		WHERE pbl.PblLocationCode = @locationCode
			AND pbl.pblProgramID = @programId
		ORDER BY Pbr.Id
	END

	IF (ISNULL(@IsJobReturn, 0) = 1)
	BEGIN
		SELECT ItemNumber
			,ProgramLocationId
			,Id
			,PbrCode
			,PbrCustomerCode
			,PbrTitle
			,RateUnitTypeId
			,PbrBillablePrice
			,RateTypeId
			,PbrElectronicBilling
			,StatusId
			,IsDefault
		FROM #PriceCodeData
		WHERE RateCategoryTypeId = @CategoryId
	END
	ELSE
	BEGIN
		SELECT ItemNumber
			,ProgramLocationId
			,Id
			,PbrCode
			,PbrCustomerCode
			,PbrTitle
			,RateUnitTypeId
			,PbrBillablePrice
			,RateTypeId
			,PbrElectronicBilling
			,StatusId
			,IsDefault
		FROM #PriceCodeData
		WHERE RateCategoryTypeId <> @CategoryId
	END

	DROP TABLE #PriceCodeData
END
GO

