SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Prashant Aggarwal
-- Create date: 4/6/2021
-- Description:	Import Vendor Profile
-- =============================================
CREATE PROCEDURE [dbo].[ImportVendorProfile] 
(
@uttVendorProfile [dbo].[uttVendorProfile] READONLY,
@isDataStatusUpdate BIT = 0
)
AS
BEGIN
	SET NOCOUNT ON;

	IF(@isDataStatusUpdate = 1)
	BEGIN
	UPDATE [dbo].[VendProfile000Master]
	SET StatusId = 3
	END

	INSERT INTO [dbo].[VendProfile000Master] (
		[PostalCode]
		,[Sunday]
		,[Monday]
		,[Tuesday]
		,[Wednesday]
		,[Thursday]
		,[Friday]
		,[Saturday]
		,[FanRun]
		,[VendorCode]
		,[StatusId]
		,[EnteredBy]
		,[EnteredDate]
		)
	SELECT [PostalCode]
		,[Sunday]
		,[Monday]
		,[Tuesday]
		,[Wednesday]
		,[Thursday]
		,[Friday]
		,[Saturday]
		,[FanRun]
		,[VendorCode]
		,[StatusId]
		,[EnteredBy]
		,[EnteredDate]
	FROM @uttVendorProfile 
END
GO

