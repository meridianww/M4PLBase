SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               04/14/2018      
-- Description:               Get all ColumnAliases By Table Name
-- Execution:                 EXEC [dbo].[GetColumnAliasesByUserAndTbl]   
-- Modified on:  
-- Modified Desc:  
-- ============================================= 
CREATE PROCEDURE [dbo].[GetColumnAliasesByUserAndTbl]
  @userId INT,
  @tableName NVARCHAR(100)
AS                
BEGIN TRY                
 SET NOCOUNT ON;   
   
   DECLARE @OriginalUserId BIGINT = @userId
   IF NOT EXISTS (SELECT 1 FROM [dbo].[SYSTM000ColumnSettingsByUser] cal WHERE cal.ColUserId= @userId AND cal.[ColTableName] = @tableName)
   BEGIN
    SELECT @userId = -1
   END

	  SELECT  cal.[ColTableName]
			 ,cal.[ColSortOrder]
			 ,cal.[ColNotVisible]
			 ,cal.[ColIsFreezed]
			 ,cal.[ColIsDefault]
			 ,cal.[ColGroupBy]
			 ,cal.[ColGridLayout]
			 ,@OriginalUserId AS ColUserId
	 FROM [dbo].[SYSTM000ColumnSettingsByUser] (NOLOCK) cal
	 WHERE cal.ColUserId= @userId AND cal.[ColTableName] = @tableName 
END TRY                
BEGIN CATCH                
	DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
			,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
			,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 
	EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH

GO
