SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Prashant Aggarwal
-- Create date: 10/07/2019
-- Description:	Update Job Sales Order Mapping In Database
-- =============================================
CREATE PROCEDURE [dbo].[UpdJobSalesOrderMapping] (
	 @JobIdList uttIDList READONLY
	,@SONumber [nvarchar](100)
	,@IsElectronicInvoiced [bit]
	,@EnteredBy [nvarchar](50) = NULL
	)
AS
BEGIN TRY
	SET NOCOUNT ON;

	MERGE dbo.NAV000JobSalesOrderMapping AS TARGET
	USING @JobIdList AS SOURCE
		ON (TARGET.JobId = SOURCE.Id AND TARGET.IsElectronicInvoiced = @IsElectronicInvoiced)
	WHEN MATCHED
		THEN
			UPDATE
			SET TARGET.SONumber = @SONumber
				,TARGET.IsElectronicInvoiced = @IsElectronicInvoiced
				,TARGET.EnteredBy = @EnteredBy
	WHEN NOT MATCHED BY TARGET
		THEN
			INSERT (
				JobId
				,SONumber
				,IsElectronicInvoiced
				,EnteredBy
				)
			VALUES (
				SOURCE.Id
				,@SONumber
				,@IsElectronicInvoiced
				,@EnteredBy
				);

	SELECT JobSalesOrderMappingId From dbo.NAV000JobSalesOrderMapping Where SONumber = @SONumber AND IsElectronicInvoiced = @IsElectronicInvoiced
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

