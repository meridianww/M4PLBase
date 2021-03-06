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
	,@prcElectronicBilling BIT = 0
	,@isProblem BIT = 0
	)
AS
BEGIN TRY
	SET NOCOUNT ON;

	DECLARE @currentId BIGINT
		,@updatedItemNumber INT

	SELECT @currentId = ID
	FROM [dbo].[JOBDL061BillableSheet]
	WHERE ISNULL(prcChargeID, 0) = 0
		AND JobId = @JobID
		AND PrcChargeCode = @prcChargeCode
		AND StatusId = 1

	EXEC [dbo].[ResetItemNumber] @userId
		,0
		,@JobID
		,@entity
		,NULL
		,@statusId
		,NULL
		,NULL
		,@updatedItemNumber OUTPUT

	IF (ISNULL(@currentId, 0) > 0)
	BEGIN
		UPDATE [dbo].[JOBDL061BillableSheet]
		SET [prcTitle] = @prcTitle
			,[prcChargeID] = @prcChargeID
			,[prcSurchargeOrder] = @prcSurchargeOrder
			,[prcSurchargePercent] = CASE 
				WHEN ISNULL(@prcSurchargePercent, 0) > 0
					THEN CAST(@prcSurchargePercent AS FLOAT)
				ELSE NULL
				END
			,[prcNumberUsed] = @prcNumberUsed
			,[prcDuration] = CASE 
				WHEN ISNULL(@prcDuration, 0) > 0
					THEN CAST(@prcDuration AS DECIMAL(18, 2))
				ELSE NULL
				END
			,[prcQuantity] = CASE 
				WHEN ISNULL(@prcQuantity, 0) > 0
					THEN CAST(@prcQuantity AS DECIMAL(18, 2))
				ELSE NULL
				END
			,[prcUnitId] = @costUnitId
			,[prcRate] = CASE 
				WHEN ISNULL(@prcCostRate, 0) > 0
					THEN CAST(@prcCostRate AS DECIMAL(18, 2))
				ELSE NULL
				END
			,[prcAmount] = CASE 
				WHEN ISNULL(@prcCost, 0) > 0
					THEN CAST(@prcCost AS DECIMAL(18, 2))
				ELSE NULL
				END
			,[StatusId] = @statusId
			,[prcMarkupPercent] = CASE 
				WHEN ISNULL(@prcMarkupPercent, 0) > 0
					THEN CAST(@prcMarkupPercent AS FLOAT)
				ELSE NULL
				END
			,PrcElectronicBilling = @prcElectronicBilling
			,IsProblem = 0
			,[ChangedBy] = @enteredBy
			,[DateChanged] = @dateEntered
		WHERE ISNULL(prcChargeID, 0) = 0
		AND JobId = @JobID
		AND PrcChargeCode = @prcChargeCode
		AND StatusId = 1
	END
	ELSE
	BEGIN
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
			,[PrcElectronicBilling]
			,[IsProblem]
			,[StatusId]
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
			,@prcElectronicBilling
			,@isProblem
			,@statusId
			,@enteredBy
			,@dateEntered
			)

		SET @currentId = SCOPE_IDENTITY();
	END

	EXEC [dbo].[UpdateLineNumberForJobBillableSheet] @JobID

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
