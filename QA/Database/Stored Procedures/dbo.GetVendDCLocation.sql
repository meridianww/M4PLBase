SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               08/16/2018      
-- Description:               Get a vend dc Loc
-- Execution:                 EXEC [dbo].[GetVendDCLocation]
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)   
-- Modified Desc:  
-- =============================================
CREATE PROCEDURE  [dbo].[GetVendDCLocation]
    @userId BIGINT,
    @roleId BIGINT,
	@orgId BIGINT,
    @id BIGINT
AS
BEGIN TRY                
 SET NOCOUNT ON;   
SELECT vend.[Id]
      ,vend.[VdcVendorID]
      ,vend.[VdcItemNumber]
      ,vend.[VdcLocationCode]
	  --,ISNULL(vend.[VdcCustomerCode],vend.[VdcLocationCode]) AS VdcCustomerCode
		,vend.[VdcCustomerCode]
      ,vend.[VdcLocationTitle]
      ,cb.[ContactMSTRID] as VdcContactMSTRID 
      ,vend.[StatusId]
      ,vend.[EnteredBy]
      ,vend.[DateEntered]
      ,vend.[ChangedBy]
      ,vend.[DateChanged]
	  ,COMP.Id CompanyId
  FROM [dbo].[VEND040DCLocations] vend
  INNER JOIN dbo.COMP000Master COMP ON COMP.CompPrimaryRecordId = vend.VdcVendorID AND COMP.CompTableName = 'Vendor'  Left JOIN [CONTC010Bridge] CB ON cb.ConPrimaryRecordId = vend.Id  AND  (cb.ConTableName='VendDcLocation' OR   (cb.ConTableName='VendContact' AND cb.ConTitle='Vendor_default'))
 WHERE vend.[Id]=@id
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH

GO
