SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Prashant Aggarwal
-- Create date: 06/11/2020
-- Description:	Get All Training Detail
--  EXEC [GetAllTrainingDetail] 'Document'
-- =============================================
CREATE PROCEDURE [dbo].[GetAllTrainingDetail]
@traingType NVARCHAR(10)
AS
BEGIN
	SET NOCOUNT ON;

	SELECT VC.CategoryId
		,VC.DisplayName CategoryName
		,SD.DisplayName VideoName
		,SD.URL VideoURL
	FROM SYSTM000KnowdlegeDetail SD
	INNER JOIN SYSTM000KnowdlegeCategory VC ON VC.CategoryId = SD.CategoryId
	INNER JOIN SYSTM000KnowdlegeCategoryType SKC ON SKC.CategoryTypeId = VC.CategoryTypeId
	WHERE SD.StatusId = 1 AND SKC.CategoryType = @traingType
END

GO
