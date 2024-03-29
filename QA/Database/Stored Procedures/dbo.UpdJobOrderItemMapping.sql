SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Prashant Aggarwal
-- Create date: 10/07/2019
-- Description:	Update Job Order Mapping In Database
-- =============================================
CREATE PROCEDURE [dbo].[UpdJobOrderItemMapping] 
(@JobIdList uttIDList READONLY
,@EntityName [nvarchar] (150)
,@LineNumber [int]
,@itemId [bigint]
,@documentNumber Varchar(50)
,@EnteredBy [nvarchar] (50) = NULL
)
AS
BEGIN TRY
	SET NOCOUNT ON;
	IF NOT EXISTS(Select 1 From dbo.NAV000JobOrderItemMapping NAV
INNER JOIN @JobIdList Job ON Job.Id = NAV.JobId
Where EntityName = @EntityName AND LineNumber = @LineNumber AND Document_Number = @documentNumber)
		INSERT INTO dbo.NAV000JobOrderItemMapping (
			 JobId
			,EntityName
			,LineNumber
			,M4PLItemId
			,EnteredBy
			,Document_Number
			)
		Select 
			Id
			,@EntityName
			,@LineNumber
			,@itemId
			,@EnteredBy
			,@documentNumber
			From @JobIdList
ELSE
BEGIN
Update NAV
SET NAV.M4PLItemId = @itemId,
NAV.EnteredBy = @EnteredBy
FROM dbo.NAV000JobOrderItemMapping NAV
INNER JOIN @JobIdList Job ON Job.Id = NAV.JobId
Where EntityName = @EntityName AND LineNumber = @LineNumber AND Document_Number = @documentNumber
END
	Select CAST(1 AS Bit)
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
