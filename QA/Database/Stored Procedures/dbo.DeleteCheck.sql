SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               10/31/2018      
-- Description:               Check record before delete  
-- Execution:                 EXEC [dbo].[DeleteCheck]   
-- Modified on:  
-- Modified Desc:  
-- =============================================
CREATE PROCEDURE  [dbo].[DeleteCheck]
    @userId BIGINT,
	@roleCode NVARCHAR(25),
	@orgId BIGINT,
	@id BIGINT,
	@tableName NVARCHAR(100)
AS
BEGIN TRY                
 SET NOCOUNT ON;   
		SELECT 
		sys.sysobjects.name,
		@id as ContactId,
		(SELECT TOP 1 LangCode FROM [dbo].[SYSTM000Ref_Table] WHERE TblTableName = sys.sysobjects.name) as [Name],
		-- object_name(sys.foreign_keys.object_id),
		sys.foreign_keys.*
		
	FROM 
	sys.foreign_keys 
	inner join sys.sysobjects on
		sys.foreign_keys.parent_object_id = sys.sysobjects.id
	INNER JOIN  [dbo].[SYSTM000Ref_Table] refTable  ON OBJECT_ID(refTable.TblTableName) = referenced_object_id
	WHERE refTable.SysRefName = @tableName
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
