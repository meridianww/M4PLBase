SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Prashant Aggarwal
-- Create date: 08/27/2020
-- Description:	Insert AWC Driver Scrub Report Raw Data
-- =============================================
CREATE PROCEDURE [dbo].[InsertAWCDriverScrubReportRawData] (
	 @CustomerId BIGINT
	,@Description VARCHAR(Max)
	,@StartDate DATETIME2(7)
	,@EndDate DATETIME2(7)
	,@EnteredDate DATETIME2(7)
	,@EnteredBy NVARCHAR(150)
	,@uttAWCDriverScrubReport [dbo].[uttAWCDriverScrubReport] READONLY
	)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @MasterDataID INT

	INSERT INTO DriverScrubReportMaster (
		CustomerId
		,StartDate
		,EndDate
		,Description
		)
	VALUES (
		@CustomerId
		,@StartDate
		,@EndDate
		,@Description
		)

	SET @MasterDataID = SCOPE_IDENTITY()

	IF (@MasterDataID > 0)
	BEGIN
		INSERT INTO [dbo].[AWCDriverScrubReport] (
			[DriverScrubReportMasterId]
			,[QMSShippedOn]
			,[QMSPSDisposition]
			,[QMSStatusDescription]
			,[FouthParty]
			,[ThirdParty]
			,[ActualControlId]
			,[QMSControlId]
			,[QRCGrouping]
			,[QRCDescription]
			,[ProductCategory]
			,[ProductSubCategory]
			,[ProductSubCategory2]
			,[ModelName]
			,[CustomerBusinessType]
			,[ChannelCD]
			,[NationalAccountName]
			,[CustomerName]
			,[ShipFromLocation]
			,[QMSRemark]
			,[DaysToAccept]
			,[QMSTotalUnit]
			,[QMSTotalPrice]
			,[ShipDate]
			,[JobId]
			,[EnteredBy]
			,[EnteredDate]
			)
		SELECT @MasterDataID
			,[QMSShippedOn]
			,[QMSPSDisposition]
			,[QMSStatusDescription]
			,[FouthParty]
			,[ThirdParty]
			,[ActualControlId]
			,[QMSControlId]
			,[QRCGrouping]
			,[QRCDescription]
			,[ProductCategory]
			,[ProductSubCategory]
			,[ProductSubCategory2]
			,[ModelName]
			,[CustomerBusinessType]
			,[ChannelCD]
			,[NationalAccountName]
			,[CustomerName]
			,[ShipFromLocation]
			,[QMSRemark]
			,[DaysToAccept]
			,[QMSTotalUnit]
			,[QMSTotalPrice]
			,[ShipDate]
			,[JobId]
			,@EnteredBy
			,@EnteredDate
		FROM @uttAWCDriverScrubReport
	END
END
GO

