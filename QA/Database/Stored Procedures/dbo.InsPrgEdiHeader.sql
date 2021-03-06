SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               09/16/2018      
-- Description:               Ins a  Program Edi header
-- Execution:                 EXEC [dbo].[InsPrgEdiHeader]
-- Modified on:               05/10/2018
-- Modified Desc:             Added OrderType and SetPurpose fields
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.) 
-- ============================================= 

CREATE PROCEDURE  [dbo].[InsPrgEdiHeader]
	(@userId BIGINT
	,@roleId BIGINT 
	,@entity NVARCHAR(100)
	,@pehProgramId bigint
	,@pehItemNumber int
	,@pehEdiCode nvarchar(20)
	,@pehEdiTitle nvarchar(50)
	,@pehTradingPartner nvarchar(20)
	,@pehEdiDocument nvarchar(20)
	,@pehEdiVersion nvarchar(20)
	,@pehSCACCode nvarchar(20)
	,@pehSndRcv bit
	,@pehInsertCode   nvarchar(20)
	,@pehUpdateCode   nvarchar(20)
	,@pehCancelCode   nvarchar(20)
	,@pehHoldCode     nvarchar(20)
	,@pehOriginalCode nvarchar(20)
	,@pehReturnCode	  nvarchar(20)
	,@uDF01 nvarchar(20)
	,@uDF02 nvarchar(20)
	,@uDF03 nvarchar(20)
	,@uDF04 nvarchar(20)
	,@uDF05 nvarchar(20)
	,@uDF06 nvarchar(20)
	,@uDF07 nvarchar(20)
	,@uDF08 nvarchar(20)
	,@uDF09 nvarchar(20)
	,@uDF10 nvarchar(20)           
	,@pehAttachments int
	,@statusId int
	,@pehDateStart datetime2(7)
	,@pehDateEnd datetime2(7)			
	,@enteredBy nvarchar(50)
	,@dateEntered datetime2(7)
	,@pehParentEDI bit
	,@PehInOutFolder VARCHAR(255)
	,@PehArchiveFolder VARCHAR(255)
	,@PehProcessFolder VARCHAR(255)
	,@PehFtpServerUrl nvarchar(255)
	,@PehFtpUsername  nvarchar(50)
	,@PehFtpPassword  nvarchar(50)
	,@PehFtpPort  nvarchar(10)
	,@IsSFTPUsed BIT = 0)
AS
BEGIN TRY                
 SET NOCOUNT ON; 
  DECLARE @updatedItemNumber INT      
 EXEC [dbo].[ResetItemNumber] @userId, 0, @pehProgramId, @entity, @pehItemNumber, @statusId, NULL, NULL,  @updatedItemNumber OUTPUT
   
 DECLARE @currentId BIGINT;
 INSERT INTO [dbo].[PRGRM070EdiHeader]
           ([PehParentEDI]    
		    ,[PehProgramID]
			,[PehItemNumber]
			,[PehEdiCode]
			,[PehEdiTitle]
			,[PehTradingPartner]
			,[PehEdiDocument]
			,[PehEdiVersion]
			,[PehSCACCode]
			,[PehInsertCode]  
			,[PehUpdateCode]   
			,[PehCancelCode]   
			,[PehHoldCode]    
			,[PehOriginalCode] 
			,[PehReturnCode]
			,[UDF01]
            ,[UDF02]
            ,[UDF03]
            ,[UDF04]
			,[UDF05]
			,[UDF06]
			,[UDF07]
			,[UDF08]
			,[UDF09]
			,[UDF10]
			,[PehAttachments]
			,[StatusId]
			,[PehDateStart]
			,[PehDateEnd]
			,[PehSndRcv]
			,[EnteredBy]
			,[DateEntered]
			,[PehInOutFolder]
			,[PehArchiveFolder]
			,[PehProcessFolder]
			,[PehFtpServerUrl]
			,[PehFtpUsername]
			,[PehFtpPassword]
			,[PehFtpPort]
			,[IsSFTPUsed])
     VALUES
           (@pehParentEDI
		    , @pehProgramId
		   	,@updatedItemNumber
		   	,@pehEdiCode
		   	,@pehEdiTitle
		   	,@pehTradingPartner
		   	,@pehEdiDocument
		   	,@pehEdiVersion
		   	,@pehSCACCode
			,@pehInsertCode   
            ,@pehUpdateCode   
            ,@pehCancelCode   
            ,@pehHoldCode     
            ,@pehOriginalCode 
            ,@pehReturnCode	  
			,@uDF01
            ,@uDF02
            ,@uDF03
            ,@uDF04
			,@uDF05
			,@uDF06
			,@uDF07
			,@uDF08
			,@uDF09
			,@uDF10
		   	,@pehAttachments
		   	,@statusId
		   	,@pehDateStart
		   	,@pehDateEnd
			,@pehSndRcv
		   	,@enteredBy
		   	,@dateEntered
			,@PehInOutFolder
			,@PehArchiveFolder
			,@PehProcessFolder
			,@PehFtpServerUrl
			,@PehFtpUsername
			,@PehFtpPassword
			,@PehFtpPort
			,@IsSFTPUsed)
			SET @currentId = SCOPE_IDENTITY();
	SELECT * FROM [dbo].[PRGRM070EdiHeader] WHERE Id = @currentId;	
END TRY              
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH


GO
