SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:                    Prashant Aggarwal         
-- Create date:               10/04/2019      
-- Description:               Get Column List For Order
-- Execution:                [dbo].[GetDataForOrder] 'ShippingItem',26455
-- =============================================
CREATE PROCEDURE [dbo].[GetDataForOrder] (
	@EntityName NVARCHAR(150)
	,@JobId BIGINT
	)
AS
BEGIN TRY
	SET NOCOUNT ON;

	IF OBJECT_ID('tempdb..#SelectQueryTemp') IS NOT NULL
	BEGIN
		DROP TABLE #SelectQueryTemp
	END

	CREATE TABLE #SelectQueryTemp (SelectQuery NVARCHAR(Max))
	Declare @AddressType INT
    Select @AddressType = ID From SYSTM000Ref_Options Where SysLookupCode='AddressType' AND SysOptionName = 'Business'

	INSERT INTO #SelectQueryTemp
	EXEC [dbo].[GetColumnListForOrder] @EntityName

	DECLARE @SelectOrderQuery NVARCHAR(Max)

	SELECT @SelectOrderQuery = SelectQuery
	FROM #SelectQueryTemp

	IF(@EntityName = 'SalesOrder')
	BEGIN
	SET @SelectOrderQuery = 'Select ' + @SelectOrderQuery + ' From dbo.JOBDL000Master Job
               INNER JOIN dbo.PRGRM000Master Program ON Program.Id = Job.ProgramID
               INNER JOIN dbo.CUST000Master Customer ON Customer.Id = Program.PrgCustID 
			   INNER JOIN dbo.COMP000Master Company ON Company.CompPrimaryRecordId = Customer.Id AND Company.CompTableName = ''Customer''
			   LEFT JOIN dbo.COMPADD000Master ComapnyAddress On ComapnyAddress.AddCompId = Company.Id AND ComapnyAddress.AddTypeId = ' + '' + CAST(@AddressType AS VARCHAR) + ''+
              ' Where Job.Id=' + '' + CAST(@JobId AS VARCHAR) + ''
	END
	IF(@EntityName = 'ShippingItem')
	BEGIN
	SET @SelectOrderQuery = 'Select ' + @SelectOrderQuery + ' From dbo.JOBDL000Master Job 
	INNER JOIN dbo.NAV000JobOrderMapping JobOrderMapping ON JobOrderMapping.JobId = Job.Id
	Where Job.Id=' + '' + CAST(@JobId AS VARCHAR) + ''
	END

	IF(@EntityName = 'ShipSalesOrderPart')
	BEGIN
	SET @SelectOrderQuery = 'Select ' + @SelectOrderQuery + ' From dbo.JOBDL000Master Job 
	Where Job.Id=' + '' + CAST(@JobId AS VARCHAR) + ''
	END

	EXEC (@SelectOrderQuery)

	DROP TABLE #SelectQueryTemp
END TRY

BEGIN CATCH
	DECLARE @ErrorMessage VARCHAR(MAX) = (
			SELECT ERROR_MESSAGE()
			)
		,@ErrorSeverity VARCHAR(MAX) = (
			SELECT ERROR_SEVERITY()
			)
		,@RelatedTo VARCHAR(100) = (
			SELECT OBJECT_NAME(@@PROCID)
			)

	EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo
		,NULL
		,@ErrorMessage
		,NULL
		,NULL
		,@ErrorSeverity
END CATCH
GO

