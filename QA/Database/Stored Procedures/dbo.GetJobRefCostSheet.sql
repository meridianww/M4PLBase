SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               09/14/2018      
-- Description:               Get a Job Ref Cost Sheet
-- Execution:                 EXEC [dbo].[GetJobRefCostSheet] 
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)   
-- Modified Desc:  
-- =============================================
CREATE PROCEDURE  [dbo].[GetJobRefCostSheet]
    @userId BIGINT,
    @roleId BIGINT,
	@orgId BIGINT,
    @id BIGINT
AS
BEGIN TRY                
 SET NOCOUNT ON;   
  SELECT job.[Id]
		,job.[JobID]
		,job.[CstLineItem]
		,job.[CstChargeID]
		,job.[CstChargeCode]
		,job.[CstTitle]
		,job.[CstSurchargeOrder]
		,job.[CstSurchargePercent]
		,job.[ChargeTypeId]
		,job.[CstNumberUsed]
		,job.[CstDuration]
		,job.[CstQuantity]
		,job.[CostUnitId]
		,job.[CstCostRate]
		,job.[CstCost]
		,job.[CstMarkupPercent]
		,job.[CstRevenueRate]
		,job.[CstRevDuration]
		,job.[CstRevQuantity]
		,job.[CstRevBillable]
		,job.[StatusId]
		,job.[EnteredBy]
		,job.[DateEntered]
		,job.[ChangedBy]
		,job.[DateChanged]
  FROM   [dbo].[JOBDL060Ref_CostSheetJob] job
 WHERE   [Id] = @id
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
