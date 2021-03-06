SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               08/16/2018      
-- Description:               Get a cust business term 
-- Execution:                 EXEC [dbo].[GetCustBusinessTerm]
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)    
-- Modified Desc:  
-- =============================================
CREATE PROCEDURE  [dbo].[GetCustBusinessTerm]
    @userId BIGINT,
    @roleId BIGINT,
	@orgId BIGINT,
    @langCode NVARCHAR(10),
    @id BIGINT
AS
BEGIN TRY                
 SET NOCOUNT ON;   
 SELECT cust.[Id]
	   ,cust.[LangCode]
	   ,cust.[CbtOrgID]
	   ,cust.[CbtCustomerId]
	   ,cust.[CbtItemNumber]
	   ,cust.[CbtCode]
	   ,cust.[CbtTitle]
	   ,cust.[BusinessTermTypeId]
	   ,cust.[CbtActiveDate]
	   ,cust.[CbtValue]
	   ,cust.[CbtHiThreshold]
	   ,cust.[CbtLoThreshold]
	   ,cust.[CbtAttachment]
	   ,cust.[StatusId]
	   ,cust.[EnteredBy]
	   ,cust.[DateEntered]
	   ,cust.[ChangedBy]
	   ,cust.[DateChanged]
   FROM [dbo].[CUST020BusinessTerms] cust
  WHERE [Id]=@id 
  --AND cust.[LangCode]= @langCode
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
