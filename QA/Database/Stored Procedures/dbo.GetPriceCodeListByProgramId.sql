SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Prashant Aggarwal
-- Create date: 5/7/2020
-- Description:	GetPriceCodeListByProgramId
-- =============================================
CREATE PROCEDURE [dbo].[GetPriceCodeListByProgramId] (
	@programId BIGINT
	,@userId BIGINT
	)
AS
BEGIN
	SET NOCOUNT ON;

	SELECT ROW_NUMBER() OVER (
			ORDER BY Pbr.[Id]
			) ItemNumber
		,Pbr.[Id]
		,Pbr.[PbrCode]
		,Pbr.[PbrTitle]
		,Pbr.[RateUnitTypeId]
		,Pbr.[PbrBillablePrice]
		,Pbr.[RateTypeId]
		,Pbr.[StatusId]
	FROM [dbo].[PRGRM040ProgramBillableRate] Pbr
	INNER JOIN PRGRM042ProgramBillableLocations pbl ON pbl.Id = pbr.ProgramLocationId
		AND PBL.StatusId IN (
			1
			,2
			)
	INNER JOIN [dbo].[fnGetUserStatuses](@userId) fgus ON Pbr.StatusId = fgus.StatusId
	WHERE pbl.pblProgramID = @programId
	ORDER BY Pbr.Id
END
GO

