SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               08/16/2018      
-- Description:               Get a vend Fin Cal
-- Execution:                 EXEC [dbo].[GetVendFinancialCalender]
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)   
-- Modified Desc:  
-- ============================================= 
CREATE PROCEDURE  [dbo].[GetVendFinancialCalender]
    @userId BIGINT,
    @roleId BIGINT,
	@orgId BIGINT,
    @id BIGINT
AS
BEGIN TRY                
 SET NOCOUNT ON;   
SELECT vend.[Id]
      ,vend.[OrgID]
      ,vend.[VendID]
      ,vend.[FclPeriod]
      ,vend.[FclPeriodCode]
      ,vend.[FclPeriodStart]
      ,vend.[FclPeriodEnd]
      ,vend.[FclPeriodTitle]
      ,vend.[FclAutoShortCode]
      ,vend.[FclWorkDays]
      ,vend.[FinCalendarTypeId]
      ,vend.[StatusId]
      ,vend.[DateEntered]
      ,vend.[EnteredBy]
      ,vend.[DateChanged]
      ,vend.[ChangedBy]
  FROM [dbo].[VEND050Finacial_Cal] vend
 WHERE [Id]=@id
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
