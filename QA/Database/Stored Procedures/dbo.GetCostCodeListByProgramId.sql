SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Prashant Aggarwal
-- Create date: 5/7/2020
-- Description:	GetCostCodeListByProgramId
-- =============================================
CREATE PROCEDURE [dbo].[GetCostCodeListByProgramId](
	@programId BIGINT
	,@userId BIGINT
	)
AS
BEGIN
	SET NOCOUNT ON;

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
		FROM [dbo].[PRGRM041ProgramCostRate] pcr
		INNER JOIN [PRGRM043ProgramCostLocations] pcl ON pcl.Id = pcr.ProgramLocationId AND Pcl.StatusId IN (1,2)
		INNER JOIN [dbo].[fnGetUserStatuses](@userId) fgus ON pcr.StatusId = fgus.StatusId
		WHERE pcl.PclProgramID = @ProgramID
		ORDER BY pcr.Id
END
GO

