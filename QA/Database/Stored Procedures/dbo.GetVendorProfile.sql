SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Prashant Aggarwal
-- Create date: 4/6/2021
-- Description:	Get Vendor Profile
-- =============================================
CREATE PROCEDURE [dbo].[GetVendorProfile] (
	@locationCode NVARCHAR(50)
	,@postalCode NVARCHAR(50)
	)
AS
BEGIN
	SET NOCOUNT ON;

	SELECT TOP 1 [PostalCode]
		,[Sunday]
		,[Monday]
		,[Tuesday]
		,[Wednesday]
		,[Thursday]
		,[Friday]
		,[Saturday]
		,[FanRun]
		,[VendorCode]
	FROM [dbo].[VendProfile000Master]
	WHERE PostalCode = @postalCode
		AND VendorCode = @locationCode
		AND StatusId = 1
	ORDER BY ID DESC
END
GO

