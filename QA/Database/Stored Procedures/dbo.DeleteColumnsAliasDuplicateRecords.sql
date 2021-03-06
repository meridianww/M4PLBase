SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2019) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Nikhil Chauhan         
-- Create date:               09/16/2019      
-- Description:               Delete Columnalias duplicate row entry
-- Execution:                 EXEC [dbo].[DeleteColumnsAliasDuplicateRecords]
    
-- =============================================
CREATE PROCEDURE  [dbo].[DeleteColumnsAliasDuplicateRecords]
	(
	@ColTableName  nvarchar(100)
	) 
AS
BEGIN TRY                
 
 DELETE a
FROM SYSTM000ColumnsAlias a
INNER JOIN
(SELECT ID, RANK() OVER (PARTITION BY ColColumnName ORDER BY ID DESC) AS rnk FROM SYSTM000ColumnsAlias ) b 
ON a.ID=b.ID 
WHERE b.rnk>1 and a.ColTableName = @ColTableName

END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
