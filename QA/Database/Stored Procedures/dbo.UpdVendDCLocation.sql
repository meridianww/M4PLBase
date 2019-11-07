
GO
/****** Object:  StoredProcedure [dbo].[UpdVendDCLocation]    Script Date: 11/4/2019 11:27:07 AM ******/
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
-- Modified on:				  2nd May 2019
-- Modified Desc:			  Implemented contact bridge related item by Parthiban M    
-- Modified on:				  10th Jun 2019 (Parthiban) 
-- Modified Desc:			  Remove '#M4PL' while updating
-- ============================================= 
CREATE PROCEDURE  [dbo].[UpdVendDCLocation]		  
	@userId BIGINT
	,@roleId BIGINT  
	,@entity NVARCHAR(100)
	,@conOrgId BIGINT
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
 BEGIN TRAN
  /*Update Mapped Vendor DC for  Billable locations */
 -- UPDATE PBL
	--SET
	-- PBL.PblLocationCode =  ISNULL(@vdcLocationCode, PBL.PblLocationCode)
	----,PBL.PblLocationTitle = ISNULL(@vdcLocationTitle,PBL.PblLocationTitle)
	--From [dbo].[PRGRM042ProgramBillableLocations] PBL
	--INNER JOIN [VEND040DCLocations] VDC ON  VDC.VdcVendorID =  PBL.PblVendorID  AND VDC.VdcLocationCode = PBL.PblLocationCode AND VDC.VdcLocationTitle = PBL.PblLocationTitle
	--INNER JOIN [dbo].[fnGetUserStatuses](@userId) PBL_fgus ON ISNULL(PBL.[StatusId], 1) = PBL_fgus.[StatusId] 
	--INNER JOIN [dbo].[fnGetUserStatuses](@userId) VDC_fgus ON ISNULL(VDC.[StatusId], 1) = VDC_fgus.[StatusId] 
	--Where VDC.VdcVendorID = @vdcVendorId AND VDC.Id = @id 

 --   /*Update Mapped Vendor DC for  Cost locations */
 --  UPDATE PCL
	--SET 
	-- PCL.PclLocationCode = ISNULL(@vdcLocationCode, PCL.PclLocationCode)
	----,PCL.PclLocationTitle = ISNULL(@vdcLocationCode,PCL.PclLocationTitle)
	--From [dbo].[PRGRM043ProgramCostLocations] PCL
	--INNER JOIN [VEND040DCLocations] VDC ON  VDC.VdcVendorID =  PCL.PclVendorID  AND VDC.VdcLocationCode = PCL.PclLocationCode AND VDC.VdcLocationTitle = PCL.PclLocationTitle
	--INNER JOIN [dbo].[fnGetUserStatuses](@userId) PBL_fgus ON ISNULL(PCL.[StatusId], 1) = PBL_fgus.[StatusId] 
	--INNER JOIN [dbo].[fnGetUserStatuses](@userId) VDC_fgus ON ISNULL(VDC.[StatusId], 1) = VDC_fgus.[StatusId]  
	--Where  VDC.VdcVendorID = @vdcVendorId  AND VDC.Id = @id 

	 --/*Below to update Program Vendor Location*/
	 --UPDATE PVL SET 
	 -- PVL.[PvlLocationCode] =  ISNULL(@vdcLocationCode, PVL.PvlLocationCode)
	 --,PVL.[PvlLocationTitle] = ISNULL(@vdcLocationTitle,PVL.[PvlLocationTitle])
	 --,PVL.[PvlContactMSTRID] =  ISNULL(@vdcContactMSTRId, PVL.[PvlContactMSTRID])
	 --FROM [dbo].[PRGRM051VendorLocations]  PVL
	 --INNER JOIN  [VEND040DCLocations]   VDC ON VDC.VdcVendorID = PVL.PvlVendorID   AND  VDC.VdcLocationCode = PVL.PvlLocationCode AND PVL.PvlLocationTitle = VDC.VdcLocationTitle
	 --WHERE VDC.[VdcVendorID] = @vdcVendorId AND VDC.Id = @id 

 DECLARE @updatedItemNumber INT, @oldLocationCode NVARCHAR(20) = null, @newLocationCode NVARCHAR(20) = null, @newVdcLocationTitle NVARCHAR(50) = null, @newVdcContactMSTRId BIGINT = NULL;      
 EXEC [dbo].[ResetItemNumber] @userId, @id, @vdcVendorId, @entity, @vdcItemNumber, @statusId, NULL, NULL,  @updatedItemNumber OUTPUT

   UPDATE [dbo].[VEND040DCLocations]
    SET     VdcVendorId 		= ISNULL(@vdcVendorId, VdcVendorId)
           ,VdcItemNumber 		= ISNULL(@updatedItemNumber, VdcItemNumber)
           ,VdcLocationCode 	= ISNULL(@vdcLocationCode, VdcLocationCode) 
		   ,VdcCustomerCode 	= ISNULL(@vdcCustomerCode,VdcCustomerCode) 
           ,VdcLocationTitle 	= @vdcLocationTitle
           ,StatusId 			= ISNULL(@statusId, StatusId)
           ,ChangedBy 			= @changedBy 
           ,DateChanged   		= @dateChanged 
      WHERE Id = @id 	
	If NOT EXISTS (Select 1 from [CONTC010Bridge]  where ConPrimaryRecordId = @id AND ContactMSTRID =  @vdcContactMSTRId  And  ConTableName = 'VendDcLocation' And ConOrgId = @conOrgId) AND  @vdcContactMSTRId IS NOT NULL 
	BEGIN
	 UPDATE [CONTC010Bridge] set [ContactMSTRID] = @vdcContactMSTRId where  ConPrimaryRecordId = @id   And  ConTableName = 'VendDcLocation' And ConOrgId = @conOrgId
	 END
   
   COMMIT
	 EXEC [dbo].[GetVendDCLocation] @userId, @roleId, 1 ,@id 
END TRY    
BEGIN CATCH   
ROLLBACK             
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
