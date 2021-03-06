SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
	/* Copyright (2019) Meridian Worldwide Transportation Group
		All Rights Reserved Worldwide */
	-- =============================================        
	-- Author:                    Nikhil Chauhan  
	-- Create date:               08/30/2019      
	-- Description:               Upd a security by role 
	-- Execution:                 EXEC [dbo].[UpdPrgEdiCondition]
	-- ============================================= 
	CREATE  PROCEDURE  [dbo].[UpdPrgEdiCondition]
		(@userId BIGINT
		,@roleId BIGINT  
		,@entity NVARCHAR(100)
		,@id bigint
		,@orgId bigint = NULL
		,@pecProgramId bigint 
		,@pecParentProgramId bigint
		,@pecJobField nvarchar(50)
		,@pecCondition nvarchar(50)
		,@perLogical nvarchar(20)
		,@pecJobField2 nvarchar(50)
		,@pecCondition2  nvarchar(50)
		,@dateChanged datetime2(7) = NULL
		,@changedBy nvarchar(50) = NULL
		,@isFormView bit) 
	AS
	BEGIN TRY                
		SET NOCOUNT ON;   

		UPDATE [dbo].[PRGRM072EdiConditions]
		SET
			 [PecProgramId] = @pecProgramId
			,[PecJobField] = @PecJobField
			,[PecCondition] = @pecCondition
			,[PerLogical] = @perLogical 
			,[PecJobField2] = @pecJobField2
			,[PecCondition2] = @pecCondition2
			,[ChangedBy] = @changedBy
			,[DateChanged] = @dateChanged
			WHERE	 [Id] = @id

		EXECUTE  [GetPrgEdiConditionByEdiHeader] @userId,@roleId,@id;
	
	END TRY                
	BEGIN CATCH                
		DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
		,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
		,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
		EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
	END CATCH
GO
