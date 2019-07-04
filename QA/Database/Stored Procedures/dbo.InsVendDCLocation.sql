SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               08/16/2018      
-- Description:               Ins a Vend dc loc
-- Execution:                 EXEC [dbo].[InsVendDCLocation]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================
CREATE PROCEDURE  [dbo].[InsVendDCLocation]
	@userId BIGINT
	,@roleId BIGINT 
	,@entity NVARCHAR(100)
	,@vdcVendorId BIGINT = NULL
	,@vdcItemNumber INT = NULL
	,@vdcLocationCode NVARCHAR(20) = NULL 
	,@vdcCustomerCode NVARCHAR(20) = NULL 
	,@vdcLocationTitle NVARCHAR(50) = NULL 
	,@vdcContactMSTRId BIGINT = NULL 
	,@statusId INT = NULL 
	,@enteredBy NVARCHAR(50) = NULL 
	,@dateEntered DATETIME2(7) = NULL 
AS
BEGIN TRY                
 SET NOCOUNT ON; 
   DECLARE @updatedItemNumber INT      
 EXEC [dbo].[ResetItemNumber] @userId, 0, @vdcVendorId, @entity, @vdcItemNumber, @statusId, NULL, NULL,  @updatedItemNumber OUTPUT
 
   
 DECLARE @currentId BIGINT;
   INSERT INTO [dbo].[VEND040DCLocations]
           ([VdcVendorId]
           ,[VdcItemNumber]
           ,[VdcLocationCode]
		   ,[VdcCustomerCode]
           ,[VdcLocationTitle]
           ,[VdcContactMSTRId]
           ,[StatusId]
           ,[EnteredBy]
           ,[DateEntered] )  
      VALUES
		   (@vdcVendorId  
           ,@updatedItemNumber  
           ,@vdcLocationCode  
		   ,ISNULL(@vdcCustomerCode,@vdcLocationCode)
           ,@vdcLocationTitle  
           ,@vdcContactMSTRId  
           ,@statusId 
           ,@enteredBy
           ,@dateEntered ) 
		   SET @currentId = SCOPE_IDENTITY();
		EXEC [dbo].[GetVendDCLocation] @userId, @roleId, 1 ,@currentId 
END TRY    
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH



/***** Object:  StoredProcedure [dbo].[UpdVendDcLoc]    Script Date: 8/16/2017 1:30:20 PM *****/
SET ANSI_NULLS ON
GO
