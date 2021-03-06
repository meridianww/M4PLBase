SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               08/16/2018      
-- Description:               Ins a Vend Doc Ref
-- Execution:                 EXEC [dbo].[InsVendDocReference]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================
CREATE PROCEDURE  [dbo].[InsVendDocReference]
	@userId BIGINT
	,@roleId BIGINT 
	,@entity NVARCHAR(100)
	,@vdrOrgId BIGINT = NULL
	,@vdrVendorId BIGINT  = NULL
	,@vdrItemNumber INT  = NULL
	,@vdrCode NVARCHAR(20)  = NULL
	,@vdrTitle NVARCHAR(50)  = NULL
	,@docRefTypeId INT  = NULL
	,@docCategoryTypeId INT = NULL 
	,@vdrAttachment INT  = NULL
	,@vdrDateStart DATETIME2(7) = NULL 
	,@vdrDateEnd DATETIME2(7)  = NULL
	,@vdrRenewal BIT  = NULL
	,@statusId INT = NULL 
	,@enteredBy NVARCHAR(50) = NULL 
	,@dateEntered DATETIME2(7)   = NULL
AS
BEGIN TRY                
 SET NOCOUNT ON;  
    DECLARE @updatedItemNumber INT      
   EXEC [dbo].[ResetItemNumber] @userId, 0, @vdrVendorId, @entity, @vdrItemNumber, @statusId, NULL, NULL,  @updatedItemNumber OUTPUT
 DECLARE @currentId BIGINT;
   INSERT INTO [dbo].[VEND030DocumentReference]
           ([VdrOrgId]
           ,[VdrVendorId]
           ,[VdrItemNumber]
           ,[VdrCode]
           ,[VdrTitle]
           ,[DocRefTypeId]
           ,[DocCategoryTypeId]
           ,[VdrAttachment]
           ,[VdrDateStart]
           ,[VdrDateEnd]
           ,[VdrRenewal]
           ,[StatusId]
           ,[EnteredBy]
           ,[DateEntered] )  
      VALUES
		   (@vdrOrgId  
           ,@vdrVendorId   
           ,@updatedItemNumber   
           ,@vdrCode  
           ,@vdrTitle   
           ,@docRefTypeId 
           ,@docCategoryTypeId   
           ,@vdrAttachment  
           ,@vdrDateStart  
           ,@vdrDateEnd  
           ,@vdrRenewal  
		   ,@statusId
           ,@enteredBy   
           ,@dateEntered  ) 
		   SET @currentId = SCOPE_IDENTITY();
		EXEC [dbo].[GetVendDocReference] @userId, @roleId, @vdrOrgId ,@currentId 
END TRY    
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH



/***** Object:  StoredProcedure [dbo].[UpdVendDocRef]    Script Date: 8/16/2017 1:30:20 PM *****/
SET ANSI_NULLS ON
GO
