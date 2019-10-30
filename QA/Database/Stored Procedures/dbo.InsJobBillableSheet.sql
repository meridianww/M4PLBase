SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/* Copyright (2018) Meridian Worldwide Transportation Group        
   All Rights Reserved Worldwide */
-- =============================================                
-- Author:                    Prashant Aggarwal                
-- Create date:               10/30/2019              
-- Description:               Insert Job Billable Sheet                      
-- =============================================              
CREATE PROCEDURE [dbo].[InsJobBillableSheet] (
	 @userId BIGINT
	,@roleId BIGINT
	,@entity NVARCHAR(100)
	,@JobID [bigint]
	,@prcLineItem [nvarchar](20)
	,@prcChargeCode [nvarchar](25)
	,@prcTitle [nvarchar](50)
	,@prcChargeId [int]
	,@prcSurchargeOrder [bigint]
	,@prcSurchargePercent [float]
	,@chargeTypeId [int]
	,@prcNumberUsed [int]
	,@prcDuration [decimal](18, 2)
	,@prcQuantity [decimal](18, 2)
	,@costUnitId [int]
	,@prcCostRate [decimal](18, 2)
	,@prcCost [decimal](18, 2)
	,@prcMarkupPercent [float]
	,@statusId [int]
	,@enteredBy NVARCHAR(50) = NULL
	,@dateEntered DATETIME2(7) = NULL
	)
AS
BEGIN TRY
	SET NOCOUNT ON;

	DECLARE @LineNumber INT
		,@currentId BIGINT
		,@updatedItemNumber INT

	SELECT @LineNumber = CASE 
			WHEN ISNULL(MAX(LineNumber), 0) = 0
				THEN 10000
			ELSE MAX(LineNumber) + 1
			END
	FROM [dbo].[JOBDL061BillableSheet]
	WHERE JobId = @JobID
		AND StatusId IN (
			1
			,2
			)


	EXEC [dbo].[ResetItemNumber] @userId
		,0
		,@JobID
		,@entity
		,null
		,@statusId
		,NULL
		,NULL
		,@updatedItemNumber OUTPUT

	INSERT INTO [dbo].[JOBDL061BillableSheet] (
		 [JobID]
		,[prcLineItem]
		,[prcChargeCode]
		,[prcTitle]
		,[prcChargeID]
		,[prcSurchargeOrder]
		,[prcSurchargePercent]
		,[ChargeTypeId]
		,[prcNumberUsed]
		,[prcDuration]
		,[prcQuantity]
		,[prcUnitId]
		,[prcRate]
		,[prcAmount]
		,[prcMarkupPercent]
		,[StatusId]
		,[LineNumber]
		,[EnteredBy]
		,[DateEntered]
		)
	VALUES (
		@JobID
		,@updatedItemNumber
		,@prcChargeCode
		,@prcTitle
		,@prcChargeID
		,@prcSurchargeOrder
		,@prcSurchargePercent
		,@ChargeTypeId
		,@prcNumberUsed
		,@prcDuration
		,@prcQuantity
		,@costUnitId
		,@prcCostRate
		,@prcCost
		,@prcMarkupPercent
		,@statusId
		,@LineNumber
		,@enteredBy
		,@dateEntered
		)

	SET @currentId = SCOPE_IDENTITY();

	EXEC [dbo].[GetJobBillableSheet] @userId
		,@roleId
		,0
		,@currentId
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

