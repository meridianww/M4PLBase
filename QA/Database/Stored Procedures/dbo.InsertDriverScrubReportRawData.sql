SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Prashant Aggarwal
-- Create date: 08/27/2020
-- Description:	Insert AWC Driver Scrub Report Raw Data
-- =============================================
CREATE PROCEDURE [dbo].[InsertDriverScrubReportRawData] (
	 @CustomerId BIGINT
	,@Description VARCHAR(Max)
	,@StartDate DATETIME2(7)
	,@EndDate DATETIME2(7)
	,@EnteredDate DATETIME2(7)
	,@EnteredBy NVARCHAR(150)
	,@uttAWCDriverScrubReport [dbo].[uttAWCDriverScrubReport] READONLY
	,@uttCommonDriverScrubReport [dbo].[uttCommonDriverScrubReport] READONLY
	)
AS
BEGIN
	SET NOCOUNT ON;
IF(@CustomerId = 10007)
BEGIN
EXEC [dbo].[InsertAWCDriverScrubReportRawData]
     @CustomerId 
	,@Description 
	,@StartDate 
	,@EndDate 
	,@EnteredDate 
	,@EnteredBy 
	,@uttAWCDriverScrubReport
END
ELSE
BEGIN
EXEC [dbo].[InsertCommonDriverScrubReportRawData]
     @CustomerId 
	,@Description 
	,@StartDate 
	,@EndDate 
	,@EnteredDate 
	,@EnteredBy 
	,@uttCommonDriverScrubReport
END
END
GO

