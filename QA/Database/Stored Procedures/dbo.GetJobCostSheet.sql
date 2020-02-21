SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/* Copyright (2018) Meridian Worldwide Transportation Group  
   All Rights Reserved Worldwide */
-- =============================================          
-- Author:                    Prashant Aggarwal           
-- Create date:               10/30/2019       
-- Description:               Get Data For Job Cost Sheet    
-- =============================================        
CREATE PROCEDURE [dbo].[GetJobCostSheet] @userId BIGINT
	,@roleId BIGINT
	,@orgId BIGINT
	,@id BIGINT
AS
BEGIN TRY
	SET NOCOUNT ON;

	SELECT Id
		,JobID
		,CstLineItem
		,CstChargeID
		,CstChargeCode
		,CstTitle
		,CstSurchargeOrder
		,CstSurchargePercent
		,ChargeTypeId
		,CstNumberUsed
		,CstDuration
		,CstQuantity
		,CstUnitId
		,CstRate
		,CstAmount
		,CstMarkupPercent
		,CstElectronicBilling
		,DateEntered
		,EnteredBy
		,DateChanged
		,ChangedBy
	FROM [dbo].[JOBDL062CostSheet]
	WHERE Id = @id
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

