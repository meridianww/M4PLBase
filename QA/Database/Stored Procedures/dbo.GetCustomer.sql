SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               08/16/2018      
-- Description:               Get a customer
-- Execution:                 EXEC [dbo].[GetCustomer]
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)    
-- Modified Desc:  
-- ============================================= 
CREATE PROCEDURE  [dbo].[GetCustomer]
    @userId BIGINT,
    @roleId BIGINT,
	@orgId BIGINT,
    @id BIGINT
AS
BEGIN TRY                
 SET NOCOUNT ON;   
  SELECT cust.[Id]
        ,cust.[CustERPID]
        ,cust.[CustOrgId]
        ,cust.[CustItemNumber]
        ,cust.[CustCode]
        ,cust.[CustTitle]
        ,cust.[CustWorkAddressId]
        ,cust.[CustBusinessAddressId]
        ,cust.[CustCorporateAddressId]
        ,cust.[CustContacts]
        ,cust.[CustLogo]
        ,cust.[CustTypeId]
        ,cust.[CustWebPage]
        ,cust.[StatusId]
        ,cust.[EnteredBy]
        ,cust.[DateEntered]
        ,cust.[ChangedBy]
        ,cust.[DateChanged]
		,org.OrgCode as 'RoleCode'
  FROM [dbo].[CUST000Master] cust
  INNER JOIN [dbo].[ORGAN000Master] org ON cust.CustOrgId = org.Id
 WHERE cust.[Id] = @id
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
