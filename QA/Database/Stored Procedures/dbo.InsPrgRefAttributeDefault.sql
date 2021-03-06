SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               09/14/2018      
-- Description:               Ins a  Program Ref Attributes
-- Execution:                 EXEC [dbo].[InsPrgRefAttributeDefault]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================

CREATE PROCEDURE  [dbo].[InsPrgRefAttributeDefault]
	(@userId BIGINT
	,@roleId BIGINT 
	,@entity NVARCHAR(100)
	,@programId bigint
	,@attItemNumber int
	,@attCode nvarchar(20)
	,@attTitle nvarchar(50)
	,@attQuantity int
	,@unitTypeId int
	,@statusId int
	,@attDefault bit
	,@dateEntered datetime2(7)
	,@enteredBy nvarchar(50))
AS
BEGIN TRY                
 SET NOCOUNT ON;  
  DECLARE @updatedItemNumber INT      
  EXEC [dbo].[ResetItemNumber] @userId, 0, @programId, @entity, @attItemNumber, @statusId, NULL, NULL,  @updatedItemNumber OUTPUT
 DECLARE @currentId BIGINT;
 INSERT INTO [dbo].[PRGRM020Ref_AttributesDefault]
           ([ProgramID]
			,[AttItemNumber]
			,[AttCode]
			,[AttTitle]
			,[AttQuantity]
			,[UnitTypeId]
			,[StatusId]
			,[AttDefault]
			,[DateEntered]
			,[EnteredBy])
     VALUES
           (@programId
		   	,@updatedItemNumber
		   	,@attCode
		   	,@attTitle
		   	,@attQuantity
		   	,@unitTypeId
			,@statusId
		   	,@attDefault
		   	,@dateEntered
		   	,@enteredBy)
			SET @currentId = SCOPE_IDENTITY();
	SELECT * FROM [dbo].[PRGRM020Ref_AttributesDefault] WHERE Id = @currentId;	
END TRY              
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
