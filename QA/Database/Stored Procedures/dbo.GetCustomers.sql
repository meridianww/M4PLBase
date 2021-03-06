SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
--==================================================================================    
-- Author        : Prashant Aggarwal  
-- Date          : 26 June 2019     
-- Description   : Stored Procedure to Get all the Vendors which are active in the system and Belongs to Maridian
--=================================================================================  
CREATE PROCEDURE  [dbo].[GetCustomers]
    @userId BIGINT,
    @roleId BIGINT,
	@orgId BIGINT
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
		,cust.CustDivisonCode
  FROM [dbo].[CUST000Master] cust
  INNER JOIN [dbo].[ORGAN000Master] org ON cust.CustOrgId = org.Id
  Where cust.[StatusId] = 1 AND cust.CustOrgId = 1
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
