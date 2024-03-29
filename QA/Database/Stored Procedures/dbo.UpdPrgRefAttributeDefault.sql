SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               08/16/2018      
-- Description:               Upd a Program Ref Attributes
-- Execution:                 EXEC [dbo].[UpdPrgRefAttributeDefault]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================
CREATE PROCEDURE  [dbo].[UpdPrgRefAttributeDefault]
	(@userId BIGINT
	,@roleId BIGINT  
	,@entity NVARCHAR(100)
	,@id bigint
	,@programId bigint = NULL
	,@attItemNumber int = NULL
	,@attCode nvarchar(20) = NULL
	,@attTitle nvarchar(50) = NULL
	,@attQuantity int = NULL
	,@unitTypeId int = NULL
	,@statusId int = NULL
	,@attDefault bit = NULL
	,@dateChanged datetime2(7) = NULL
	,@changedBy nvarchar(50) = NULL
	,@isFormView BIT = 0) 
AS
BEGIN TRY                
 SET NOCOUNT ON;   
 DECLARE @updatedItemNumber INT      
 EXEC [dbo].[ResetItemNumber] @userId, @id, @programId, @entity, @attItemNumber, @statusId, NULL, NULL,  @updatedItemNumber OUTPUT
 UPDATE [dbo].[PRGRM020Ref_AttributesDefault]
		SET  [ProgramID]         = CASE WHEN (@isFormView = 1) THEN @programId WHEN ((@isFormView = 0) AND (@programId=-100)) THEN NULL ELSE ISNULL(@programId, ProgramID) END
			,[AttItemNumber]     = CASE WHEN (@isFormView = 1) THEN @updatedItemNumber WHEN ((@isFormView = 0) AND (@updatedItemNumber=-100)) THEN NULL ELSE ISNULL(@updatedItemNumber, AttItemNumber) END
			,[AttCode]           = CASE WHEN (@isFormView = 1) THEN @attCode WHEN ((@isFormView = 0) AND (@attCode='#M4PL#')) THEN NULL ELSE ISNULL(@attCode, AttCode) END
			,[AttTitle]          = CASE WHEN (@isFormView = 1) THEN @attTitle WHEN ((@isFormView = 0) AND (@attTitle='#M4PL#')) THEN NULL ELSE ISNULL(@attTitle, AttTitle) END
			,[AttQuantity]       = CASE WHEN (@isFormView = 1) THEN @attQuantity WHEN ((@isFormView = 0) AND (@attQuantity=-100)) THEN NULL ELSE ISNULL(@attQuantity, AttQuantity) END
			,[UnitTypeId]        = CASE WHEN (@isFormView = 1) THEN @unitTypeId WHEN ((@isFormView = 0) AND (@unitTypeId=-100)) THEN NULL ELSE ISNULL(@unitTypeId, UnitTypeId) END
			,[AttDefault]        = ISNULL(@attDefault, AttDefault)
			,[StatusId]          = CASE WHEN (@isFormView = 1) THEN @statusId WHEN ((@isFormView = 0) AND (@statusId=-100)) THEN NULL ELSE ISNULL(@statusId, StatusId) END
			,[DateChanged]       = @dateChanged
			,[ChangedBy]         = @changedBy
	 WHERE   [Id] = @id
	SELECT prg.[Id]
		,prg.[ProgramID]
		,prg.[AttItemNumber]
		,prg.[AttCode]
		,prg.[AttTitle]
		,prg.[AttQuantity]
		,prg.[UnitTypeId]
		,prg.[AttDefault]
		,prg.[DateEntered]
		,prg.[EnteredBy]
		,prg.[DateChanged]
		,prg.[ChangedBy]
  FROM   [dbo].[PRGRM020Ref_AttributesDefault] prg
 WHERE   [Id] = @id
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
