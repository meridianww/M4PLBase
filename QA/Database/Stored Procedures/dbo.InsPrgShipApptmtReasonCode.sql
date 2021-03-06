SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               09/14/2018      
-- Description:               Ins a  Program Ship Apptmt Reason Code
-- Execution:                 EXEC [dbo].[InsPrgShipApptmtReasonCode]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- ============================================= 

CREATE PROCEDURE  [dbo].[InsPrgShipApptmtReasonCode]
	(@userId BIGINT
	,@roleId BIGINT 
	,@entity NVARCHAR(100)
	,@pacOrgId bigint
	,@pacProgramId bigint
	,@pacApptItem int
	,@pacApptReasonCode nvarchar(20)
	,@pacApptLength int
	,@pacApptInternalCode nvarchar(20)
	,@pacApptPriorityCode nvarchar(20)
	,@pacApptTitle nvarchar(50)
	,@pacApptCategoryCodeId int = null
	,@pacApptUser01Code nvarchar(20)
	,@pacApptUser02Code nvarchar(20)
	,@pacApptUser03Code nvarchar(20)
	,@pacApptUser04Code nvarchar(20)
	,@pacApptUser05Code nvarchar(20)
	,@statusId int
	,@dateEntered datetime2(7)
	,@enteredBy nvarchar(50))
AS
BEGIN TRY                
 SET NOCOUNT ON;  
  DECLARE @updatedItemNumber INT      
EXEC [dbo].[ResetItemNumber] @userId, 0, @pacProgramId, @entity, @pacApptItem, @statusId, NULL, NULL,  @updatedItemNumber OUTPUT 
  
 DECLARE @currentId BIGINT;
 INSERT INTO [dbo].[PRGRM031ShipApptmtReasonCodes]
           ([PacOrgID]
			,[PacProgramID]
			,[PacApptItem]
			,[PacApptReasonCode]
			,[PacApptLength]
			,[PacApptInternalCode]
			,[PacApptPriorityCode]
			,[PacApptTitle]
			,[PacApptCategoryCodeId]
			,[PacApptUser01Code]
			,[PacApptUser02Code]
			,[PacApptUser03Code]
			,[PacApptUser04Code]
			,[PacApptUser05Code]
			,[StatusId]
			,[DateEntered]
			,[EnteredBy])
     VALUES
           (@pacOrgId
		   	,@pacProgramId
		   	,@updatedItemNumber
		   	,@pacApptReasonCode
		   	,@pacApptLength
		   	,@pacApptInternalCode
		   	,@pacApptPriorityCode
		   	,@pacApptTitle
		   	,@pacApptCategoryCodeId
		   	,@pacApptUser01Code
		   	,@pacApptUser02Code
		   	,@pacApptUser03Code
		   	,@pacApptUser04Code
		   	,@pacApptUser05Code
		   	,@statusId
		   	,@dateEntered
		   	,@enteredBy)
			SET @currentId = SCOPE_IDENTITY();
	SELECT * FROM [dbo].[PRGRM031ShipApptmtReasonCodes] WHERE Id = @currentId;
END TRY              
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
