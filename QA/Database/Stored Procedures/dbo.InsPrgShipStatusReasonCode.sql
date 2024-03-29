SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               09/14/2018      
-- Description:               Ins a  Program Ship Status Reason Code
-- Execution:                 EXEC [dbo].[InsPrgShipStatusReasonCode]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================  

CREATE PROCEDURE  [dbo].[InsPrgShipStatusReasonCode]
	(@userId BIGINT
	,@roleId BIGINT 
	,@entity NVARCHAR(100)
	,@pscOrgId bigint
	,@pscProgramId bigint
	,@pscShipItem int
	,@pscShipReasonCode nvarchar(20)
	,@pscShipLength int
	,@pscShipInternalCode nvarchar(20)
	,@pscShipPriorityCode nvarchar(20)
	,@pscShipTitle nvarchar(50)
	,@pscShipCategoryCode nvarchar(20)
	,@pscShipUser01Code nvarchar(20)
	,@pscShipUser02Code nvarchar(20)
	,@pscShipUser03Code nvarchar(20)
	,@pscShipUser04Code nvarchar(20)
	,@pscShipUser05Code nvarchar(20)
	,@statusId int
	,@dateEntered datetime2(7)
	,@enteredBy nvarchar(50))
AS
BEGIN TRY                
 SET NOCOUNT ON; 
  DECLARE @updatedItemNumber INT      
 EXEC [dbo].[ResetItemNumber] @userId, 0, @pscProgramId, @entity, @pscShipItem, @statusId, NULL, NULL,  @updatedItemNumber OUTPUT
   
 DECLARE @currentId BIGINT;
 INSERT INTO [dbo].[PRGRM030ShipStatusReasonCodes]
           ([PscOrgID]
			,[PscProgramID]
			,[PscShipItem]
			,[PscShipReasonCode]
			,[PscShipLength]
			,[PscShipInternalCode]
			,[PscShipPriorityCode]
			,[PscShipTitle]
			,[PscShipCategoryCode]
			,[PscShipUser01Code]
			,[PscShipUser02Code]
			,[PscShipUser03Code]
			,[PscShipUser04Code]
			,[PscShipUser05Code]
			,[StatusId]
			,[DateEntered]
			,[EnteredBy])
     VALUES
           (@pscOrgID
		   	,@pscProgramID 
		   	,@updatedItemNumber
		   	,@pscShipReasonCode
		   	,@pscShipLength
		   	,@pscShipInternalCode
		   	,@pscShipPriorityCode
		   	,@pscShipTitle
		   	,@pscShipCategoryCode
		   	,@pscShipUser01Code
		   	,@pscShipUser02Code
		   	,@pscShipUser03Code
		   	,@pscShipUser04Code
		   	,@pscShipUser05Code
		   	,@statusId
		   	,@dateEntered
		   	,@enteredBy)
			SET @currentId = SCOPE_IDENTITY();
	SELECT * FROM [dbo].[PRGRM030ShipStatusReasonCodes] WHERE Id = @currentId;
END TRY              
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
