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
CREATE PROCEDURE  [dbo].[GetVendors]
    @userId BIGINT,
    @roleId BIGINT,
	@orgId BIGINT
AS
BEGIN TRY                
 SET NOCOUNT ON;   
SELECT vend.[Id]
      ,vend.[VendERPID]
      ,vend.[VendOrgID]
      ,vend.[VendItemNumber]
      ,vend.[VendCode]
      ,vend.[VendTitle]
      ,vend.[VendWorkAddressId]
      ,vend.[VendBusinessAddressId]
      ,vend.[VendCorporateAddressId]
      ,vend.[VendContacts]
      ,vend.[VendLogo]
      ,vend.[VendTypeId]
      ,vend.[VendWebPage]
      ,vend.[StatusId]
      ,vend.[EnteredBy]
      ,vend.[DateEntered]
      ,vend.[ChangedBy]
      ,vend.[DateChanged]
	  ,org.OrgCode as 'RoleCode'
  FROM [dbo].[VEND000Master] vend
  INNER JOIN [dbo].[ORGAN000Master] org ON vend.VendOrgID = org.Id
 Where vend.[StatusId] = 1 AND vend.[VendOrgID] = 1
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
