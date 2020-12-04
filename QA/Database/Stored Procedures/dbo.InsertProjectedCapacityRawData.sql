SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Kamal
-- Create date: 04-10-2020
-- Description:	Insert record into [LocationProjectedCapacity]
-- =============================================
CREATE PROCEDURE [dbo].[InsertProjectedCapacityRawData] (
	 @CustomerId BIGINT
	,@Year INT
	,@EnteredBy NVARCHAR(150)
	,@EnteredDate DATETIME2(7)
	,@uttProjectedCapacityReport dbo.uttProjectedCapacityReport READONLY
	)
AS
BEGIN
	SET NOCOUNT ON;

	UPDATE [dbo].[LocationProjectedCapacity]
	SET StatusId = 3
	WHERE [Year] = @Year

	INSERT INTO [dbo].[LocationProjectedCapacity] (
		[CustomerId]
		,[Year]
		,[Location]
		,[ProjectedCapacity]
		,[EnteredBy]
		,[EnteredDate]
		,[StatusId]
		,[DockSize]
		)
	SELECT @CustomerId
		,@Year
		,Location
		,ProjectedCapacity
		,@EnteredBy
		,@EnteredDate
		,1
		,Size
	FROM @uttProjectedCapacityReport
END
GO

