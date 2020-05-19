SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Prashant Aggarwal
-- Create date: 5/7/2020
-- Description:	GetCostCodeListByProgramId
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
		AND Pcl.StatusId IN (
			1
			,2
			)
	INNER JOIN [dbo].[fnGetUserStatuses](@userId) fgus ON pcr.StatusId = fgus.StatusId
	WHERE pcl.PclLocationCode = @locationCode
		AND pcl.PclProgramID = @ProgramID

	IF (ISNULL(@Count, 0) = 0)
	BEGIN
		SET @locationCode = 'Default'
	END

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
			ELSE CAST(0 AS BIT)
			END IsDefault
	FROM [dbo].[PRGRM041ProgramCostRate] pcr
	INNER JOIN [PRGRM043ProgramCostLocations] pcl ON pcl.Id = pcr.ProgramLocationId
		AND Pcl.StatusId IN (
			1
			,2
			)
	INNER JOIN [dbo].[fnGetUserStatuses](@userId) fgus ON pcr.StatusId = fgus.StatusId
	WHERE pcl.PclLocationCode = @locationCode
		AND pcl.PclProgramID = @ProgramID
	ORDER BY pcr.Id
END
GO

