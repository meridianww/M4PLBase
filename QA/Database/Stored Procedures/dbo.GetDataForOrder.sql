SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:                    Prashant Aggarwal         
-- Create date:               10/04/2019      
-- Description:               Get Column List For Order
-- Execution:                [dbo].[GetDataForOrder] 'SalesOrder',26455
-- =============================================
CREATE PROCEDURE [dbo].[GetDataForOrder] (
	@EntityName NVARCHAR(150)
	,@JobId BIGINT
	)
AS
BEGIN
	SET NOCOUNT ON;

	IF OBJECT_ID('tempdb..#SelectQueryTemp') IS NOT NULL
	BEGIN
		DROP TABLE #SelectQueryTemp
	END

	CREATE TABLE #SelectQueryTemp (SelectQuery NVARCHAR(Max))

	INSERT INTO #SelectQueryTemp
	EXEC [dbo].[GetColumnListForOrder] @EntityName

	DECLARE @SelectOrderQuery NVARCHAR(Max),@SelectItemQuery NVARCHAR(Max)

	SELECT @SelectOrderQuery = SelectQuery
	FROM #SelectQueryTemp

	IF(@EntityName = 'SalesOrder')
	BEGIN
	SET @SelectOrderQuery = 'Select ' + @SelectOrderQuery + ' From dbo.JOBDL000Master Job
               INNER JOIN dbo.PRGRM000Master Program ON Program.Id = Job.ProgramID
               INNER JOIN dbo.CUST000Master Customer ON Customer.Id = Program.PrgCustID Where Job.Id=' + '' + CAST(@JobId AS VARCHAR) + ''
    END

	DELETE FROM #SelectQueryTemp
	INSERT INTO #SelectQueryTemp
	EXEC [dbo].[GetColumnListForOrder] 'ShippingItem'

	SELECT @SelectItemQuery = SelectQuery
	FROM #SelectQueryTemp

	SET @SelectItemQuery = 'Select ' + @SelectItemQuery + ' From dbo.JOBDL000Master Job Where Job.Id=' + '' + CAST(@JobId AS VARCHAR) + ''
	SET @SelectOrderQuery = @SelectOrderQuery + ' ' + @SelectItemQuery

	EXEC (@SelectOrderQuery)

	DROP TABLE #SelectQueryTemp
END
GO

