SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               08/16/2018      
-- Description:               Get a cust document reference
-- Execution:                 EXEC [dbo].[GetCustDocReference]
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)    
-- Modified Desc:  
-- ============================================= 
CREATE PROCEDURE  [dbo].[GetCustDocReference]
    @userId BIGINT,
    @roleId BIGINT,
	@orgId BIGINT,
    @id BIGINT
AS
BEGIN TRY                
 SET NOCOUNT ON;   
 SELECT cust.[Id]
       ,cust.[CdrOrgID]
       ,cust.[CdrCustomerID]
       ,cust.[CdrItemNumber]
       ,cust.[CdrCode]
       ,cust.[CdrTitle]
       ,cust.[DocRefTypeId]
       ,cust.[DocCategoryTypeId]
       ,cust.[CdrAttachment]
       ,cust.[CdrDateStart]
       ,cust.[CdrDateEnd]
       ,cust.[CdrRenewal]
       ,cust.[StatusId]
       ,cust.[EnteredBy]
       ,cust.[DateEntered]
       ,cust.[ChangedBy]
       ,cust.[DateChanged]
  FROM [dbo].[CUST030DocumentReference] cust
 WHERE [Id]=@id
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
