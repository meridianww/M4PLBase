SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Janardana         
-- Create date:               09/15/2018      
-- Description:               Get all Cost rates under the specified program 
-- Execution:                 EXEC [dbo].[GetAssignUnassignVendorLocationsProgram]   
-- Modified on:  
-- Modified Desc:  
-- =============================================                             
CREATE PROCEDURE [dbo].[GetAssignUnassignVendorLocationsProgram] 
 @orgId BIGINT,      
 @parentId BIGINT = NULL,  
 @programId BIGINT,        
 @isChild BIT                    
AS                              
BEGIN TRY                   
    SET NOCOUNT ON;                 
  
  IF @isChild = 0
  BEGIN
      SELECT vm.Id  AS Id        
       ,NULL  AS ParentId        
       ,'0_'+CAST(vm.Id AS VARCHAR) As Name     
       ,vm.VendCode + COALESCE( '('+VendTitle+')', '')  as [Text]        
       ,vm.VendCode + COALESCE( '('+VendTitle+')', '')  as [ToolTip]  
	   ,CASE WHEN (vm.[VendCorporateAddressId] IS NULL AND vm.[VendBusinessAddressId] IS NULL AND vm.[VendWorkAddressId] IS NULL) THEN CAST(0 AS BIT)        
            ELSE CAST(1 AS BIT) END AS [Enabled]  
	   --,CASE  WHEN  vm.Id = PvlVendorID THEN CAST(1 AS BIT) ELSE CAST(0 AS BIT) END As Assigned
	    ,CASE WHEN  vdc.VdcLocationCode = pvl.PvlLocationCode THEN CAST(1 AS BIT) ELSE CAST(0 AS BIT) END As Assigned 
         
  FROM VEND000Master (NOLOCK) vm    
  LEFT JOIN PRGRM051VendorLocations pvl ON vm.Id = pvl.PvlVendorID AND pvl.PvlProgramID = @programId AND pvl.StatusId  IN( 1,2) 
  LEFT JOIN [VEND040DCLocations] vdc ON vdc.vdcvendorId = vm.id
  WHERE vm.StatusId  IN( 1,2)    AND vm.VendOrgId =  @orgId
  ORDER BY  vm.VendCode

  END
  ELSE
  BEGIN
     SELECT vdc.Id  AS Id        
           ,vdc.VdcVendorID AS ParentId 
           ,CAST(vdc.VdcVendorID AS VARCHAR) + '_'+CAST(vdc.Id AS VARCHAR) As Name     
           ,vdc.VdcLocationCode + COALESCE( '('+VdcLocationTitle+')', '')  as [Text]        
           ,vdc.VdcLocationCode + COALESCE( '('+VdcLocationTitle+')', '')  as [ToolTip]       
           ,CAST(1 AS BIT) As IsLeaf     
          ,CASE WHEN (vm.[VendCorporateAddressId] IS NULL AND vm.[VendBusinessAddressId] IS NULL AND vm.[VendWorkAddressId] IS NULL) THEN CAST(0 AS BIT)        
            ELSE CAST(1 AS BIT) END AS [Enabled]    
			
        ,CASE WHEN  vdc.VdcLocationCode = pvl.PvlLocationCode THEN CAST(1 AS BIT) ELSE CAST(0 AS BIT) END As Assigned 
     FROM  [VEND040DCLocations] (NOLOCK) vdc       
  Join  VEND000Master (NOLOCK) vm     ON vdc.VdcVendorID = vm.Id   
  LEFT JOIN [PRGRM051VendorLocations] (NOLOCK) pvl ON vdc.VdcLocationCode =   pvl.PvlLocationCode    AND pvl.StatusId in(1,2)AND pvl.PvlProgramID = @programId  
  
                
  WHERE vm.StatusId  IN( 1,2) AND vdc.VdcVendorID = @parentId   


  END
                
END TRY                              
BEGIN CATCH                              
                              
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                  
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                  
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                  
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                  
                              
END CATCH
GO
