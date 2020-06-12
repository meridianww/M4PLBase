SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Prashant Aggarwal
-- Create date: 06/11/2020
-- Description:	Get All Training Detail
-- =============================================
CREATE PROCEDURE [dbo].[GetAllTrainingDetail]
AS
BEGIN
	SET NOCOUNT ON;

	SELECT VC.CategoryId
		,VC.DisplayName CategoryName
		,SD.DisplayName VideoName
		,SD.URL VideoURL
	FROM SYSTM000VideoDetail SD
	INNER JOIN SYSTM000VideoCategory VC ON VC.CategoryId = SD.CategoryId
	WHERE SD.StatusId = 1
END
GO

