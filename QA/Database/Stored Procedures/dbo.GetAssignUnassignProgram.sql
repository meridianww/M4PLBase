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
-- Execution:                 EXEC [dbo].[GetAssignUnassignProgram]   
-- Modified on:  
-- Modified Desc:  
-- =============================================                           
CREATE PROCEDURE [dbo].[GetAssignUnassignProgram]   
 @orgId BIGINT,        
 @isAssignedPrgVendor BIT,                       
 @parentId BIGINT = NULL,  
 @programId BIGINT,        
 @isChild BIT,
 @userId BIGINT,
 @roleId BIGINT                  
AS                              
BEGIN TRY                   
    SET NOCOUNT ON;                 
    
 DECLARE @VendorCount BIGINT,@IsVendorAdmin BIT = 0
 IF OBJECT_ID('tempdb..#EntityIdTemp') IS NOT NULL
BEGIN
DROP TABLE #EntityIdTemp
END
 CREATE TABLE #EntityIdTemp
(
EntityId BIGINT
)



IF OBJECT_ID('tempdb..#VendMaster') IS NOT NULL
BEGIN
DROP TABLE #VendMaster
END

CREATE TABLE #VendMaster(
	[Id] [bigint],
	[VendCode] [nvarchar](20),
	[VendTitle] [nvarchar](50),
	[VendWorkAddressId] [bigint],
	[VendBusinessAddressId] [bigint],
	[VendCorporateAddressId] [bigint],
	[StatusId] [int],
	[VendOrgId] BIGINT)

INSERT INTO #EntityIdTemp
EXEC [dbo].[GetCustomEntityIdByEntityName] @userId, @roleId,@orgId,'Vendor'

SELECT @VendorCount = Count(ISNULL(EntityId, 0))
FROM #EntityIdTemp
WHERE ISNULL(EntityId, 0) = -1

IF (@VendorCount = 1)
BEGIN
SET @IsVendorAdmin = 1
END

IF (ISNULL(@IsVendorAdmin,0) = 0)
BEGIN
INSERT INTO #VendMaster (Id, [VendCode],
VendTitle,
VendWorkAddressId,
VendBusinessAddressId,
VendCorporateAddressId,
[VendOrgId],
StatusId)
SELECT Id, [VendCode],
[VendTitle],
[VendWorkAddressId],
[VendBusinessAddressId],
[VendCorporateAddressId],[VendOrgId],
[StatusId] FROM dbo.VEND000Master VM
INNER JOIN #EntityIdTemp tmp ON tmp.EntityId = VM.Id
END	 
ELSE
BEGIN
INSERT INTO #VendMaster (Id, [VendCode],
VendTitle,
VendWorkAddressId,
VendBusinessAddressId,
VendCorporateAddressId,
[VendOrgId],
StatusId)
SELECT Id, [VendCode],
[VendTitle],
[VendWorkAddressId],
[VendBusinessAddressId],
[VendCorporateAddressId],[VendOrgId],
[StatusId] FROM dbo.VEND000Master
END      
--assigned Program vendor locations      
IF @isAssignedPrgVendor = 1        
BEGIN        
   IF @isChild = 0        
   BEGIN       
         SELECT  vm.Id  AS Id        
          ,NULL  AS ParentId              
 ,'0_'+CAST(vm.Id AS VARCHAR) As Name     
    ,vm.VendCode + COALESCE( '('+VendTitle+')', '')  as [Text]        
    ,vm.VendCode + COALESCE( '('+VendTitle+')', '')  as [ToolTip]            
  FROM #VendMaster vm    
  WHERE vm.StatusId  IN( 1,2)    
       AND  vm.Id In (select PvlVendorID from PRGRM051VendorLocations pvl WHERE PvlProgramID = @programId AND pvl.StatusId  IN( 1,2)  )  
	   AND  vm.VendOrgId = @orgId  
    ORDER BY  vm.VendCode      
            
   END        
   ELSE        
   BEGIN        
       SELECT  pvl.Id  AS Id        
          ,pvl.PvlProgramID  AS ParentId        
    --,pvl.PvlLocationCode  AS Name        
 ,CAST(pvl.PvlProgramID AS VARCHAR) + '_'+CAST(pvl.Id AS VARCHAR) As Name     
    ,pvl.PvlLocationCode + COALESCE( '('+PvlLocationTitle+')', '')  as [Text]        
    ,pvl.PvlLocationCode + COALESCE( '('+PvlLocationTitle+')', '')  as [ToolTip]    
 ,CAST(1 AS BIT) As IsLeaf        
     FROM PRGRM051VendorLocations (NOLOCK) pvl        
  INNER JOIN #VendMaster vm ON pvl.PvlVendorID = vm.Id         
  WHERE vm.StatusId  IN( 1,2)          
       AND  pvl.StatusId  IN( 1,2)          
        AND pvl.PvlVendorID = @parentId 
		AND pvl.PvlProgramID = @programId             
    ORDER BY  pvl.PvlLocationCode  
        
   END         
END        
ELSE  -- --Unassigned Program vendor locations       
BEGIN        
IF @isChild = 0        
   BEGIN        
         SELECT DISTINCT vm.Id  AS Id        
          ,NULL  AS ParentId        
      
 ,'0_'+CAST(vm.Id AS VARCHAR) As Name    
    ,vm.VendCode + COALESCE( '('+VendTitle+')', '')  as [Text]        
    ,vm.VendCode + COALESCE( '('+VendTitle+')', '')  as [ToolTip]       
 ,CASE WHEN vdc.Id IS NULL THEN CAST(1 AS BIT)     
  ELSE CAST(0 AS BIT) END AS IsLeaf    
 ,CASE WHEN ISNULL(vdc.Id,0) > 0 THEN  CAST(1 AS BIT)
       WHEN (vm.[VendCorporateAddressId] IS NULL AND vm.[VendBusinessAddressId] IS NULL AND vm.[VendWorkAddressId] IS NULL) THEN CAST(0 AS BIT)         
       ELSE CAST(1 AS BIT)  END AS [Enabled]          
     FROM  #VendMaster vm         
  LEFT Join [VEND040DCLocations] (NOLOCK) vdc   ON vdc.VdcVendorID = vm.Id AND vdc.StatusId  =1                
  WHERE vm.StatusId  IN( 1,2)  AND  vm.VendOrgId = @orgId         
       AND NOT EXISTS             
           (SELECT VendDCLocationId  FROM [dbo].[PRGRM051VendorLocations] t2               
            WHERE t2.PvlProgramID = @programId  AND t2.StatusId IN (1,2)                 
                AND  vdc.ID=t2.VendDCLocationId) 
	       
   
   END        
   ELSE        
   BEGIN        
       SELECT  vdc.Id  AS Id        
          ,vm.Id AS ParentId               
 ,CAST(vm.Id AS VARCHAR) + '_'+CAST(vdc.Id AS VARCHAR) As Name     
    ,vdc.VdcLocationCode + COALESCE( '('+VdcLocationTitle+')', '')  as [Text]        
    ,vdc.VdcLocationCode + COALESCE( '('+VdcLocationTitle+')', '')  as [ToolTip]       
 ,CAST(1 AS BIT) As IsLeaf     
  ,CAST(1 AS BIT) As [Enabled]   
     FROM  #VendMaster vm         
  Left Join [VEND040DCLocations] (NOLOCK) vdc ON vdc.VdcVendorID = vm.Id AND vdc.StatusId =1         
  WHERE vm.StatusId  IN( 1,2) AND vdc.VdcVendorID = @parentId         
      AND NOT EXISTS             
           (SELECT VendDCLocationId  FROM [dbo].[PRGRM051VendorLocations] t2               
            WHERE t2.PvlProgramID = @programId   
       AND  t2.PvlVendorID = @parentId  
       AND t2.StatusId IN (1,2)                 
                AND  vdc.Id=t2.VendDCLocationId )  
   ORDER BY  vdc.VdcLocationCode      
   END        
END        
  
DROP TABLE #VendMaster
DROP TABLE  #EntityIdTemp               
END TRY                              
BEGIN CATCH                              
                              
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                  
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                  
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                  
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                  
                              
END CATCH

GO
