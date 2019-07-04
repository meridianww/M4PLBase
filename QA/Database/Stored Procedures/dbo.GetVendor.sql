SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               08/16/2018      
-- Description:               Get a Vender
-- Execution:                 EXEC [dbo].[GetVendor]
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)    
-- Modified Desc:  
-- ============================================= 
CREATE PROCEDURE  [dbo].[GetVendor]
    @userId BIGINT,
    @roleId BIGINT,
	@orgId BIGINT,
    @id BIGINT
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
 WHERE vend.[Id]=@id 
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
