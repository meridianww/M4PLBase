SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/* Copyright (2018) Meridian Worldwide Transportation Group        
   All Rights Reserved Worldwide */
-- =============================================                
-- Author:                    Prashant Aggarwal                
-- Create date:               10/30/2019              
-- Description:               Insert Job Cost Sheet                      
-- =============================================              
CREATE PROCEDURE [dbo].[InsJobCostSheet] (
	@userId BIGINT
	,@roleId BIGINT
	,@entity NVARCHAR(100)
	,@JobID [bigint]
	,@CstLineItem [nvarchar](20)
	,@CstChargeCode [nvarchar](25)
	,@CstTitle [nvarchar](50)
	,@CstChargeID [int]
	,@CstSurchargeOrder [bigint]
	,@CstSurchargePercent [float]
	,@ChargeTypeId [int]
	,@CstNumberUsed [int]
	,@CstDuration [decimal](18, 2)
	,@CstQuantity [decimal](18, 2)
	,@costUnitId [int]
	,@cstCostRate [decimal](18, 2)
	,@cstCost [decimal](18, 2)
	,@cstMarkupPercent [float]
	,@statusId [int]
	,@enteredBy NVARCHAR(50) = NULL
	,@dateEntered DATETIME2(7) = NULL
	,@cstElectronicBilling BIT = 0
	,@isProblem BIT = 0
	)
AS
BEGIN TRY
	SET NOCOUNT ON;

	DECLARE @currentId BIGINT
		,@updatedItemNumber INT

	SELECT @currentId = ID
	FROM [dbo].[JOBDL062CostSheet]
	WHERE ISNULL(CstChargeID, 0) = 0
		AND JobId = @JobID
		AND CstChargeCode = @CstChargeCode
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
		UPDATE [dbo].[JOBDL062CostSheet]
		SET [CstTitle] = @CstTitle
			,[CstChargeID] = @CstChargeID
			,[CstSurchargeOrder] = @CstSurchargeOrder
			,[CstSurchargePercent] = CASE 
				WHEN ISNULL(@CstSurchargePercent, 0) > 0
					THEN CAST(@CstSurchargePercent AS FLOAT)
				ELSE NULL
				END
			,[CstNumberUsed] = @CstNumberUsed
			,[CstDuration] = CASE 
				WHEN ISNULL(@CstDuration, 0) > 0
					THEN CAST(@CstDuration AS DECIMAL(18, 2))
				ELSE NULL
				END
			,[CstQuantity] = CASE 
				WHEN ISNULL(@CstQuantity, 0) > 0
					THEN CAST(@CstQuantity AS DECIMAL(18, 2))
				ELSE NULL
				END
			,[CstUnitId] = @costUnitId
			,[CstRate] = CASE 
				WHEN ISNULL(@CstCostRate, 0) > 0
					THEN CAST(@CstCostRate AS DECIMAL(18, 2))
				ELSE NULL
				END
			,[CstAmount] = CASE 
				WHEN ISNULL(@CstCost, 0) > 0
					THEN CAST(@CstCost AS DECIMAL(18, 2))
				ELSE NULL
				END
			,[StatusId] = @statusId
			,[CstMarkupPercent] = CASE 
				WHEN ISNULL(@cstMarkupPercent, 0) > 0
					THEN CAST(@cstMarkupPercent AS FLOAT)
				ELSE NULL
				END
			,CstElectronicBilling = @cstElectronicBilling
			,IsProblem = 0
			,[ChangedBy] = @enteredBy
			,[DateChanged] = @dateEntered
		WHERE ISNULL(CstChargeID, 0) = 0
		AND JobId = @JobID
		AND CstChargeCode = @CstChargeCode
		AND StatusId = 1
	END
	ELSE
	BEGIN
		INSERT INTO [dbo].[JOBDL062CostSheet] (
			[JobID]
			,[CstLineItem]
			,[CstChargeCode]
			,[CstTitle]
			,[CstChargeID]
			,[CstSurchargeOrder]
			,[CstSurchargePercent]
			,[ChargeTypeId]
			,[CstNumberUsed]
			,[CstDuration]
			,[CstQuantity]
			,[CstUnitId]
			,[CstRate]
			,[CstAmount]
			,[CstMarkupPercent]
			,[CstElectronicBilling]
			,[IsProblem]
			,[StatusId]
			,[EnteredBy]
			,[DateEntered]
			)
		VALUES (
			@JobID
			,@updatedItemNumber
			,@CstChargeCode
			,@CstTitle
			,@CstChargeID
			,@CstSurchargeOrder
			,@CstSurchargePercent
			,@ChargeTypeId
			,@CstNumberUsed
			,@CstDuration
			,CASE WHEN ISNULL(@CstQuantity, 0) = 0 
			 AND ISNULL(@CstChargeCode, '') <> '' 
			 AND LEN(@CstChargeCode) >= 3 
			 AND SUBSTRING(@CstChargeCode, LEN(@CstChargeCode) - 2, 3) IN ('MIL','STO') 
			 THEN 1 ELSE @CstQuantity END 
			,@costUnitId
			,@cstCostRate
			,@cstCost
			,@cstMarkupPercent
			,@cstElectronicBilling
			,@isProblem
			,@statusId
			,@enteredBy
			,@dateEntered
			)

		SET @currentId = SCOPE_IDENTITY();
	END

	EXEC [dbo].[UpdateLineNumberForJobCostSheet] @JobID

	EXEC [dbo].[GetJobCostSheet] @userId
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
