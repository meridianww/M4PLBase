SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               08/16/2018      
-- Description:               Get a Cust Contact
-- Execution:                 EXEC [dbo].[GetCustContact]
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)    
-- Modified Desc:  
-- Modified on:				  26th Apr 2019 (Parthiban M)
-- Modified Desc:			  Changes done for related to contact bridge implementation
-- =============================================
CREATE PROCEDURE  [dbo].[GetCustContact]
    @userId BIGINT,
    @roleId BIGINT,
	@orgId BIGINT,
    @id BIGINT
AS
BEGIN TRY                
 SET NOCOUNT ON;   
  SELECT cust.[Id]
      ,cust.[ConPrimaryRecordId]
      ,cust.[ConItemNumber]
      ,cust.[ConCodeId]
      ,cust.[ConTitle]
      ,cust.[ContactMSTRID]
      ,cust.[StatusId]
      ,cust.[EnteredBy]
      ,cust.[DateEntered]
      ,cust.[ChangedBy]
      ,cust.[DateChanged]
	  ,COMP.Id CompanyId
  FROM [dbo].[CONTC010Bridge] cust WITH(NOLOCK)
  INNER JOIN dbo.COMP000Master COMP ON COMP.CompPrimaryRecordId = cust.ConPrimaryRecordId AND COMP.CompTableName = 'Customer'
 WHERE cust.[Id]=@id
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
