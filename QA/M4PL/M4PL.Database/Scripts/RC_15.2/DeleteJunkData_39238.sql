USE [M4PL_Dev]
GO

/****** Object:  StoredProcedure [dbo].[DeleteJunkData]    Script Date: 12/4/2018 7:59:51 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Nikhil Chauhan         
-- Create date:               12/04/2018      
-- Description:               To Delete Junk Data
-- =============================================
CREATE PROCEDURE  [dbo].[DeleteJunkData]		  
	 @userId BIGINT =null
	,@roleId BIGINT =null 
	,@entity NVARCHAR(100)
	,@childLevel INT =1
	,@joins NVARCHAR(MAX) = null
	,@where NVARCHAR(MAX) 
AS
	SET NOCOUNT ON; 
    BEGIN TRANSACTION
		BEGIN TRY   
		 Declare @deleteCommands  NVARCHAR(MAX);            
		  SELECT  @deleteCommands =dbo.[fnGetDelSqlCmdByLvlAndEntity](@entity,@childLevel,@joins,@where )
		  PRINT @deleteCommands
		EXEC sp_executesql @deleteCommands
		END TRY                
		BEGIN CATCH                
					DECLARE
					@ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
					,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
					,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
					EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity    
					IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
					return;            
		END CATCH

--If error in any part, rollback all transactions.
IF @@TRANCOUNT > 0 
BEGIN
    COMMIT TRANSACTION;
END


GO

