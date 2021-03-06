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
