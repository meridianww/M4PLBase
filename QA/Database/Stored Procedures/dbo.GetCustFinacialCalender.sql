SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               08/16/2018      
-- Description:               Get a cust finacial cal
-- Execution:                 EXEC [dbo].[GetCustFinacialCalender]
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)    
-- Modified Desc:  
-- =============================================
CREATE PROCEDURE  [dbo].[GetCustFinacialCalender]
    @userId BIGINT,
    @roleId BIGINT,
	@orgId BIGINT,
    @id BIGINT
AS
BEGIN TRY                
 SET NOCOUNT ON;   
 SELECT cust.[Id]
       ,cust.[OrgID]
       ,cust.[CustID]
       ,cust.[FclPeriod]
       ,cust.[FclPeriodCode]
       ,cust.[FclPeriodStart]
       ,cust.[FclPeriodEnd]
       ,cust.[FclPeriodTitle]
       ,cust.[FclAutoShortCode]
       ,cust.[FclWorkDays]
       ,cust.[FinCalendarTypeId]
       ,cust.[StatusId]
       ,cust.[DateEntered]
       ,cust.[EnteredBy]
       ,cust.[DateChanged]
       ,cust.[ChangedBy]
  FROM [dbo].[CUST050Finacial_Cal] cust
 WHERE [Id]=@id
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
