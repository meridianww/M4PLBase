SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/* Copyright (2018) Meridian Worldwide Transportation Group  
   All Rights Reserved Worldwide */
-- =============================================          
-- Author:                    Prashant Aggarwal           
-- Create date:               10/30/2019       
-- Description:               Update Job Billable Sheet       
-- =============================================       
CREATE PROCEDURE [dbo].[UpdJobBillableSheet] (
	 @userId BIGINT
	,@roleId BIGINT
	,@entity NVARCHAR(100)
	,@id BIGINT
	,@JobID [bigint]
	,@prcLineItem [nvarchar](20)
	,@prcChargeCode [nvarchar](25)
	,@prcTitle [nvarchar](50)
	,@prcChargeID [int]
	,@prcSurchargeOrder [bigint]
	,@prcSurchargePercent [float]
	,@ChargeTypeId [int]
	,@prcNumberUsed [int]
	,@prcDuration [decimal](18, 2)
	,@prcQuantity [decimal](18, 2)
	,@costUnitId [int]
	,@prcCostRate [decimal](18, 2)
	,@prcCost [decimal](18, 2)
	,@prcMarkupPercent [float]
	,@statusId [int]
	,@changedBy [nvarchar](50)
	,@dateChanged [datetime2](7)
	,@isFormView BIT = 0
	)
AS
BEGIN TRY
	SET NOCOUNT ON;

	UPDATE [dbo].[JOBDL061BillableSheet]
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
		,[prcLineItem] = CASE 
			WHEN (@isFormView = 1)
				THEN @prcLineItem
			WHEN (
					(@isFormView = 0)
					AND (@prcLineItem = '#M4PL#')
					)
				THEN NULL
			ELSE ISNULL(@prcLineItem, prcLineItem)
			END
		,[prcChargeCode] = CASE 
			WHEN (@isFormView = 1)
				THEN @prcChargeCode
			WHEN (
					(@isFormView = 0)
					AND (@prcChargeCode = '#M4PL#')
					)
				THEN NULL
			ELSE ISNULL(@prcChargeCode, prcChargeCode)
			END
		,[prcTitle] = CASE 
			WHEN (@isFormView = 1)
				THEN @prcTitle
			WHEN (
					(@isFormView = 0)
					AND (@prcTitle = '#M4PL#')
					)
				THEN NULL
			ELSE ISNULL(@prcTitle, prcTitle)
			END
		,[prcChargeID] = CASE 
			WHEN (@isFormView = 1)
				THEN @prcChargeID
			WHEN (
					(@isFormView = 0)
					AND (@prcChargeID = - 100)
					)
				THEN NULL
			ELSE ISNULL(@prcChargeID, [prcChargeID])
			END
		,[prcSurchargeOrder] = CASE 
			WHEN (@isFormView = 1)
				THEN @prcSurchargeOrder
			WHEN (
					(@isFormView = 0)
					AND (@prcSurchargeOrder = - 100)
					)
				THEN NULL
			ELSE ISNULL(@prcSurchargeOrder, [prcSurchargeOrder])
			END
		,[prcSurchargePercent] = CASE 
			WHEN (@isFormView = 1)
				THEN CASE 
						WHEN ISNULL(@prcSurchargePercent, 0) > 0
							THEN CAST(@prcSurchargePercent AS FLOAT)
						ELSE NULL
						END
			WHEN (
					(@isFormView = 0)
					AND (@prcSurchargePercent = - 100)
					)
				THEN NULL
			ELSE CASE 
					WHEN ISNULL(@prcSurchargePercent, 0) > 0
						THEN CAST(@prcSurchargePercent AS FLOAT)
					ELSE prcSurchargePercent
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
		,[prcNumberUsed] = CASE 
			WHEN (@isFormView = 1)
				THEN @prcNumberUsed
			WHEN (
					(@isFormView = 0)
					AND (@prcNumberUsed = - 100)
					)
				THEN NULL
			ELSE ISNULL(@prcNumberUsed, [prcNumberUsed])
			END
		,[prcDuration] = CASE 
			WHEN (@isFormView = 1)
				THEN CASE 
						WHEN ISNULL(@prcDuration, 0) > 0
							THEN CAST(@prcDuration AS DECIMAL(18, 2))
						ELSE NULL
						END
			WHEN (
					(@isFormView = 0)
					AND (@prcDuration = - 100)
					)
				THEN NULL
			ELSE CASE 
					WHEN ISNULL(@prcDuration, 0) > 0
						THEN CAST(@prcDuration AS DECIMAL(18, 2))
					ELSE prcDuration
					END
			END
		,[prcQuantity] = CASE 
			WHEN (@isFormView = 1)
				THEN CASE 
						WHEN ISNULL(@prcQuantity, 0) > 0
							THEN CAST(@prcQuantity AS DECIMAL(18, 2))
						ELSE NULL
						END
			WHEN (
					(@isFormView = 0)
					AND (@prcQuantity = - 100)
					)
				THEN NULL
			ELSE CASE 
					WHEN ISNULL(@prcQuantity, 0) > 0
						THEN CAST(@prcQuantity AS DECIMAL(18, 2))
					ELSE prcQuantity
					END
			END
		,[prcUnitId] = CASE 
			WHEN (@isFormView = 1)
				THEN @costUnitId
			WHEN (
					(@isFormView = 0)
					AND (@costUnitId = - 100)
					)
				THEN NULL
			ELSE ISNULL(@costUnitId, [prcUnitId])
			END
		,[prcRate] = CASE 
			WHEN (@isFormView = 1)
				THEN CASE 
						WHEN ISNULL(@prcCostRate, 0) > 0
							THEN CAST(@prcCostRate AS DECIMAL(18, 2))
						ELSE NULL
						END
			WHEN (
					(@isFormView = 0)
					AND (@prcCostRate = - 100)
					)
				THEN NULL
			ELSE CASE 
					WHEN ISNULL(@prcCostRate, 0) > 0
						THEN CAST(@prcCostRate AS DECIMAL(18, 2))
					ELSE prcRate
					END
			END
		,[prcAmount] = CASE 
			WHEN (@isFormView = 1)
				THEN CASE 
						WHEN ISNULL(@prcCost, 0) > 0
							THEN CAST(@prcCost AS DECIMAL(18, 2))
						ELSE NULL
						END
			WHEN (
					(@isFormView = 0)
					AND (@prcCost = - 100)
					)
				THEN NULL
			ELSE CASE 
					WHEN ISNULL(@prcCost, 0) > 0
						THEN CAST(@prcCost AS DECIMAL(18, 2))
					ELSE prcAmount
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
		,[prcMarkupPercent] = CASE 
			WHEN (@isFormView = 1)
				THEN CASE 
						WHEN ISNULL(@prcMarkupPercent, 0) > 0
							THEN CAST(@prcMarkupPercent AS FLOAT)
						ELSE NULL
						END
			WHEN (
					(@isFormView = 0)
					AND (@prcMarkupPercent = - 100)
					)
				THEN NULL
			ELSE CASE 
					WHEN ISNULL(@prcMarkupPercent, 0) > 0
						THEN CAST(@prcMarkupPercent AS FLOAT)
					ELSE prcMarkupPercent
					END
			END
		,[ChangedBy] = @changedBy
		,[DateChanged] = @dateChanged
	WHERE [Id] = @id;

	EXEC [dbo].[GetJobBillableSheet] @userId
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

