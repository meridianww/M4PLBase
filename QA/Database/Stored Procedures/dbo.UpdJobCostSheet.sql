SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/* Copyright (2018) Meridian Worldwide Transportation Group  
   All Rights Reserved Worldwide */
-- =============================================          
-- Author:                    Prashant Aggarwal           
-- Create date:               10/30/2019       
-- Description:               Update Job Cost Sheet       
-- =============================================       
CREATE PROCEDURE [dbo].[UpdJobCostSheet] (
	@userId BIGINT
	,@roleId BIGINT
	,@entity NVARCHAR(100)
	,@id BIGINT
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
	,@changedBy [nvarchar](50)
	,@dateChanged [datetime2](7)
	,@isFormView BIT = 0
	,@cstElectronicBilling BIT = 0
	)
AS
BEGIN TRY
	SET NOCOUNT ON;

	UPDATE [dbo].[JOBDL062CostSheet]
	SET [JobID] = CASE 
			WHEN (@isFormView = 1)
				THEN @JobID
			WHEN (
					(@isFormView = 0)
					AND (@JobID = - 100)
					)
				THEN NULL
			ELSE ISNULL(@JobID, [JobID])
			END
		,[CstLineItem] = CASE 
			WHEN (@isFormView = 1)
				THEN @CstLineItem
			WHEN (
					(@isFormView = 0)
					AND (@CstLineItem = '#M4PL#')
					)
				THEN NULL
			ELSE ISNULL(@CstLineItem, CstLineItem)
			END
		,[CstChargeCode] = CASE 
			WHEN (@isFormView = 1)
				THEN @CstChargeCode
			WHEN (
					(@isFormView = 0)
					AND (@CstChargeCode = '#M4PL#')
					)
				THEN NULL
			ELSE ISNULL(@CstChargeCode, CstChargeCode)
			END
		,[CstTitle] = CASE 
			WHEN (@isFormView = 1)
				THEN @CstTitle
			WHEN (
					(@isFormView = 0)
					AND (@CstTitle = '#M4PL#')
					)
				THEN NULL
			ELSE ISNULL(@CstTitle, CstTitle)
			END
		,[CstChargeID] = CASE 
			WHEN (@isFormView = 1)
				THEN @CstChargeID
			WHEN (
					(@isFormView = 0)
					AND (@CstChargeID = - 100)
					)
				THEN NULL
			ELSE ISNULL(@CstChargeID, [CstChargeID])
			END
		,[CstSurchargeOrder] = CASE 
			WHEN (@isFormView = 1)
				THEN @CstSurchargeOrder
			WHEN (
					(@isFormView = 0)
					AND (@CstSurchargeOrder = - 100)
					)
				THEN NULL
			ELSE ISNULL(@CstSurchargeOrder, [CstSurchargeOrder])
			END
		,[CstSurchargePercent] = CASE 
			WHEN (@isFormView = 1)
				THEN CASE 
						WHEN ISNULL(@CstSurchargePercent, 0) > 0
							THEN CAST(@CstSurchargePercent AS FLOAT)
						ELSE NULL
						END
			WHEN (
					(@isFormView = 0)
					AND (@CstSurchargePercent = - 100)
					)
				THEN NULL
			ELSE CASE 
					WHEN ISNULL(@CstSurchargePercent, 0) > 0
						THEN CAST(@CstSurchargePercent AS FLOAT)
					ELSE CstSurchargePercent
					END
			END
		,[ChargeTypeId] = CASE 
			WHEN (@isFormView = 1)
				THEN @ChargeTypeId
			WHEN (
					(@isFormView = 0)
					AND (@ChargeTypeId = - 100)
					)
				THEN NULL
			ELSE ISNULL(@ChargeTypeId, [ChargeTypeId])
			END
		,[CstNumberUsed] = CASE 
			WHEN (@isFormView = 1)
				THEN @CstNumberUsed
			WHEN (
					(@isFormView = 0)
					AND (@CstNumberUsed = - 100)
					)
				THEN NULL
			ELSE ISNULL(@CstNumberUsed, [CstNumberUsed])
			END
		,[CstDuration] = CASE 
			WHEN (@isFormView = 1)
				THEN CASE 
						WHEN ISNULL(@CstDuration, 0) > 0
							THEN CAST(@CstDuration AS DECIMAL(18, 2))
						ELSE NULL
						END
			WHEN (
					(@isFormView = 0)
					AND (@CstDuration = - 100)
					)
				THEN NULL
			ELSE CASE 
					WHEN ISNULL(@CstDuration, 0) > 0
						THEN CAST(@CstDuration AS DECIMAL(18, 2))
					ELSE CstDuration
					END
			END
		,[CstQuantity] = CASE 
			WHEN (@isFormView = 1)
				THEN CASE 
						WHEN ISNULL(@CstQuantity, 0) > 0
							THEN CAST(@CstQuantity AS DECIMAL(18, 2))
						ELSE NULL
						END
			WHEN (
					(@isFormView = 0)
					AND (@CstQuantity = - 100)
					)
				THEN NULL
			ELSE CASE 
					WHEN ISNULL(@CstQuantity, 0) > 0
						THEN CAST(@CstQuantity AS DECIMAL(18, 2))
					ELSE CstQuantity
					END
			END
		,[CstUnitId] = CASE 
			WHEN (@isFormView = 1)
				THEN @costUnitId
			WHEN (
					(@isFormView = 0)
					AND (@costUnitId = - 100)
					)
				THEN NULL
			ELSE ISNULL(@costUnitId, [CstUnitId])
			END
		,[CstRate] = CASE 
			WHEN (@isFormView = 1)
				THEN CASE 
						WHEN ISNULL(@CstCostRate, 0) > 0
							THEN CAST(@CstCostRate AS DECIMAL(18, 2))
						ELSE NULL
						END
			WHEN (
					(@isFormView = 0)
					AND (@CstCostRate = - 100)
					)
				THEN NULL
			ELSE CASE 
					WHEN ISNULL(@CstCostRate, 0) > 0
						THEN CAST(@CstCostRate AS DECIMAL(18, 2))
					ELSE CstRate
					END
			END
		,[CstAmount] = CASE 
			WHEN (@isFormView = 1)
				THEN CASE 
						WHEN ISNULL(@CstCost, 0) > 0
							THEN CAST(@CstCost AS DECIMAL(18, 2))
						ELSE NULL
						END
			WHEN (
					(@isFormView = 0)
					AND (@CstCost = - 100)
					)
				THEN NULL
			ELSE CASE 
					WHEN ISNULL(@CstCost, 0) > 0
						THEN CAST(@CstCost AS DECIMAL(18, 2))
					ELSE CstAmount
					END
			END
		,[StatusId] = CASE 
			WHEN (@isFormView = 1)
				THEN @statusId
			WHEN (
					(@isFormView = 0)
					AND (@statusId = - 100)
					)
				THEN NULL
			ELSE ISNULL(@statusId, StatusId)
			END
		,[CstMarkupPercent] = CASE 
			WHEN (@isFormView = 1)
				THEN CASE 
						WHEN ISNULL(@cstMarkupPercent, 0) > 0
							THEN CAST(@cstMarkupPercent AS FLOAT)
						ELSE NULL
						END
			WHEN (
					(@isFormView = 0)
					AND (@cstMarkupPercent = - 100)
					)
				THEN NULL
			ELSE CASE 
					WHEN ISNULL(@cstMarkupPercent, 0) > 0
						THEN CAST(@cstMarkupPercent AS FLOAT)
					ELSE CstMarkupPercent
					END
			END
		, CstElectronicBilling = ISNULL(@cstElectronicBilling,CstElectronicBilling)
		,[ChangedBy] = @changedBy
		,[DateChanged] = @dateChanged
	WHERE [Id] = @id;

	EXEC [dbo].[GetJobCostSheet] @userId
		,@roleId
		,0
		,@id
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

