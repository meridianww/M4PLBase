/****** Object:  StoredProcedure [dbo].[UpdVendDCLocation]    Script Date: 2/27/2019 4:54:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan    
-- Create date:               08/16/2018      
-- Description:               Upd a vend dc loc
-- Execution:                 EXEC [dbo].[UpdVendDCLocation]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- ============================================= 
ALTER PROCEDURE  [dbo].[UpdVendDCLocation]		  
	@userId BIGINT
	,@roleId BIGINT  
	,@entity NVARCHAR(100)
	,@id BIGINT
	,@vdcVendorId BIGINT = NULL
	,@vdcItemNumber INT  = NULL
	,@vdcLocationCode NVARCHAR(20)  = NULL
	,@vdcCustomerCode NVARCHAR(20) = NULL 
	,@vdcLocationTitle NVARCHAR(50)  = NULL
	,@vdcContactMSTRId BIGINT  = NULL
	,@statusId INT  = NULL
	,@changedBy NVARCHAR(50)  = NULL
	,@dateChanged DATETIME2(7)   = NULL
	,@isFormView BIT = 0
AS
BEGIN TRY                
 SET NOCOUNT ON; 
  DECLARE @updatedItemNumber INT, @oldLocationCode NVARCHAR(20) = null, @newLocationCode NVARCHAR(20) = null, @newVdcLocationTitle NVARCHAR(50) = null, @newVdcContactMSTRId BIGINT = NULL;      
 EXEC [dbo].[ResetItemNumber] @userId, @id, @vdcVendorId, @entity, @vdcItemNumber, @statusId, NULL, NULL,  @updatedItemNumber OUTPUT
   
   SELECT @oldLocationCode = VdcLocationCode FROM [dbo].[VEND040DCLocations] WHERE Id = @id;

   UPDATE [dbo].[VEND040DCLocations]
    SET     VdcVendorId 		= CASE WHEN (@isFormView = 1) THEN @vdcVendorId WHEN ((@isFormView = 0) AND (@vdcVendorId=-100)) THEN NULL ELSE ISNULL(@vdcVendorId, VdcVendorId) END
           ,VdcItemNumber 		= CASE WHEN (@isFormView = 1) THEN @updatedItemNumber WHEN ((@isFormView = 0) AND (@updatedItemNumber=-100)) THEN NULL ELSE ISNULL(@updatedItemNumber, VdcItemNumber) END
           ,VdcLocationCode 	= CASE WHEN (@isFormView = 1) THEN @vdcLocationCode WHEN ((@isFormView = 0) AND (@vdcLocationCode='#M4PL#')) THEN NULL ELSE ISNULL(@vdcLocationCode, VdcLocationCode)  END
		   ,VdcCustomerCode 	= CASE WHEN (@isFormView = 1) THEN ISNULL(@vdcCustomerCode,@vdcLocationCode) WHEN ((@isFormView = 0) AND (@vdcCustomerCode='#M4PL#')) THEN @vdcLocationCode ELSE ISNULL(@vdcCustomerCode,VdcCustomerCode)  END
           ,VdcLocationTitle 	= CASE WHEN (@isFormView = 1) THEN @vdcLocationTitle WHEN ((@isFormView = 0) AND (@vdcLocationTitle='#M4PL#')) THEN NULL ELSE ISNULL(@vdcLocationTitle, VdcLocationTitle)  END
           ,VdcContactMSTRId 	= CASE WHEN (@isFormView = 1) THEN @vdcContactMSTRId WHEN ((@isFormView = 0) AND (@vdcContactMSTRId=-100)) THEN NULL ELSE ISNULL(@vdcContactMSTRId, VdcContactMSTRId)  END
           ,StatusId 			= CASE WHEN (@isFormView = 1) THEN @statusId WHEN ((@isFormView = 0) AND (@statusId=-100)) THEN NULL ELSE ISNULL(@statusId, StatusId) END
           ,ChangedBy 			= @changedBy 
           ,DateChanged   		= @dateChanged 
      WHERE Id = @id 	
	
	SELECT @newLocationCode = VdcLocationCode, @newVdcLocationTitle=VdcLocationTitle, @newVdcContactMSTRId = VdcContactMSTRID FROM [dbo].[VEND040DCLocations] WHERE Id = @id;
	  
	  /*Below to update DcLocationContact Code*/
	 UPDATE vdcContact SET vdcContact.VlcContactCode = vdc.VdcLocationCode 
	 FROM [dbo].[VEND041DCLocationContacts] vdcContact
	 INNER JOIN [dbo].[VEND040DCLocations] vdc ON vdcContact.VlcVendDcLocationId = vdc.Id
	 
	 /*Below to update Program Vendor Location*/
	 UPDATE [dbo].[PRGRM051VendorLocations] SET 
	 [PvlLocationCode] = @newLocationCode,
	 [PvlLocationTitle] = @newVdcLocationTitle,
	 [PvlContactMSTRID] = @newVdcContactMSTRId
	 WHERE [PvlVendorID] = @vdcVendorId AND [PvlLocationCode] = @oldLocationCode
	  	  
	 EXEC [dbo].[GetVendDCLocation] @userId, @roleId, 1 ,@id 
END TRY    
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH


/****** Object:  StoredProcedure [dbo].[GetAssignUnassignProgram]    Script Date: 2/27/2019 4:20:45 PM ******/
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
ALTER PROCEDURE [dbo].[GetAssignUnassignProgram]   
 @orgId BIGINT,        
 @isAssignedPrgVendor BIT,                       
 @parentId BIGINT = NULL,  
 @programId BIGINT,        
 @isChild BIT                    
AS                              
BEGIN TRY                   
    SET NOCOUNT ON;                 
           
--assigned Program vendor locations      
IF @isAssignedPrgVendor = 1        
BEGIN        
   IF @isChild = 0        
   BEGIN        
         SELECT  vm.Id  AS Id        
          ,NULL  AS ParentId        
    --,vm.VendCode  AS Name       
 ,'0_'+CAST(vm.Id AS VARCHAR) As Name     
    ,vm.VendCode + COALESCE( '('+VendTitle+')', '')  as [Text]        
    ,vm.VendCode + COALESCE( '('+VendTitle+')', '')  as [ToolTip]        
         
  FROM VEND000Master (NOLOCK) vm    
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
  INNER JOIN VEND000Master (NOLOCK) vm ON pvl.PvlVendorID = vm.Id         
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
     FROM  VEND000Master (NOLOCK) vm         
  LEFT Join [VEND040DCLocations] (NOLOCK) vdc   ON vdc.VdcVendorID = vm.Id AND vdc.StatusId  =1                
  WHERE vm.StatusId  IN( 1,2)  AND  vm.VendOrgId = @orgId 
   --AND NOT EXISTS (SELECT PvlVendorID  FROM [dbo].[PRGRM051VendorLocations] t2               
   --       WHERE t2.PvlProgramID = @programId  AND t2.StatusId IN (1,2) AND PvlVendorID=VM.ID)         
       AND NOT EXISTS             
           (SELECT PvlVendorID,PvlLocationCode  FROM [dbo].[PRGRM051VendorLocations] t2               
            WHERE t2.PvlProgramID = @programId  AND t2.StatusId IN (1,2)                 
                AND  vdc.VdcVendorID=t2.PvlVendorID              
                AND  vdc.VdcLocationCode = t2.PvlLocationCode ) 
	       
   
   END        
   ELSE        
   BEGIN        
       SELECT  vdc.Id  AS Id        
          ,vm.Id AS ParentId        
    --,vdc.VdcLocationCode  AS Name        
 ,CAST(vm.Id AS VARCHAR) + '_'+CAST(vdc.Id AS VARCHAR) As Name     
    ,vdc.VdcLocationCode + COALESCE( '('+VdcLocationTitle+')', '')  as [Text]        
    ,vdc.VdcLocationCode + COALESCE( '('+VdcLocationTitle+')', '')  as [ToolTip]       
 ,CAST(1 AS BIT) As IsLeaf     
  ,CAST(1 AS BIT) As [Enabled]   
    --,CASE WHEN (vm.[VendCorporateAddressId] IS NULL AND vm.[VendBusinessAddressId] IS NULL AND vm.[VendWorkAddressId] IS NULL) THEN CAST(0 AS BIT)        
    --          ELSE CAST(0 AS BIT) END AS [Enabled]          
     FROM  VEND000Master (NOLOCK) vm         
  Left Join [VEND040DCLocations] (NOLOCK) vdc ON vdc.VdcVendorID = vm.Id AND vdc.StatusId =1         
  WHERE vm.StatusId  IN( 1,2) AND vdc.VdcVendorID = @parentId         
      AND NOT EXISTS             
           (SELECT PvlVendorID,PvlLocationCode  FROM [dbo].[PRGRM051VendorLocations] t2               
            WHERE t2.PvlProgramID = @programId   
       AND  t2.PvlVendorID = @parentId  
       AND t2.StatusId IN (1,2)                 
                AND  vdc.VdcVendorID=t2.PvlVendorID              
                AND  vdc.VdcLocationCode = t2.PvlLocationCode )  
	   --AND NOT EXISTS (SELECT PvlVendorID  FROM [dbo].[PRGRM051VendorLocations] t2               
    --      WHERE t2.PvlProgramID = @programId  AND t2.StatusId IN (1,2) AND PvlVendorID=VM.ID)    
     
   ORDER BY  vdc.VdcLocationCode      
   END        
END        
                
END TRY                              
BEGIN CATCH                              
                              
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                  
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                  
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                  
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                  
                              
END CATCH
