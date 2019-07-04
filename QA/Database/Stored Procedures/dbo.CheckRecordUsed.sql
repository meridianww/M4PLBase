SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Janardana         
-- Create date:               11/21/2018      
-- Description:               Get Association with the modules  
-- Execution:                 EXEC [dbo].[CheckRecordUsed]   
-- Modified on:  
-- Modified Desc:  
-- =============================================    

CREATE PROCEDURE  [dbo].[CheckRecordUsed] 
@Id NVARCHAR(500),
@TableName NVARCHAR(100)
AS

BEGIN TRY
  SET NOCOUNT ON;
 -- declaring variables for hold looped record values
 DECLARE @TabName VARCHAR(100)
        ,@ColName VARCHAR(100)

--declaring variable to hold the value that table contains StatusId column or not
DECLARE @isStatusIdColumnAvailable BIT



 -- no records are found based on id sent from input parameter
 DECLARE @noOfRecordsFound INT = 0;  
 

      --DECLARE AND SET COUNTER.
      DECLARE @Counter INT
      SET @Counter = 1
 
      --DECLARE THE CURSOR FOR A QUERY.
      DECLARE TableCols CURSOR READ_ONLY
      FOR
       SELECT 
       sys.sysobjects.name AS TableName,
       (SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE WHERE CONSTRAINT_NAME = sys.foreign_keys.name) AS ColumnName
		FROM 
		sys.foreign_keys 
		inner join sys.sysobjects on
		sys.foreign_keys.parent_object_id = sys.sysobjects.id
		INNER JOIN  [dbo].[SYSTM000Ref_Table] refTable  ON OBJECT_ID(refTable.TblTableName) = referenced_object_id
		WHERE refTable.SysRefName = @TableName

 
      --OPEN CURSOR.
      OPEN TableCols
 
      --FETCH THE RECORD INTO THE VARIABLES.
      FETCH NEXT FROM TableCols INTO
      @TabName, @ColName
 
      --LOOP UNTIL RECORDS ARE AVAILABLE. AND CHECK IF NO OF RECORDS FOUND ON Each LOOP If Found exit from LOOP
      WHILE @@FETCH_STATUS = 0 AND @noOfRecordsFound = 0
      BEGIN
             
			 DECLARE @query NVARCHAR(MAX)
			 
			 SET @query = 'SELECT @noOfRecordsFound = COUNT(*) FROM  ' + @TabName +   ' table1 JOIN [dbo].[fnSplitString](''' + @Id + ''', '','') allIds ON table1.' + @ColName + ' = allIds.Item ' +
						  ' WHERE ISNULL(table1.StatusId, 1) < 3 ';

			--EXECUTE QUERY AND CHECK NO OF RECORDS FOUND
			 EXEC sp_executesql @query, N' @noOfRecordsFound int output', @noOfRecordsFound output                 
             
             --INCREMENT COUNTER.
             SET @Counter = @Counter + 1
 
             --FETCH THE NEXT RECORD INTO THE VARIABLES.
             FETCH NEXT FROM TableCols INTO
             @TabName, @ColName
      END
 
      --CLOSE THE CURSOR.
      CLOSE TableCols
      DEALLOCATE TableCols

	  IF @noOfRecordsFound = 0
	  BEGIN
	       SELECT CAST(0 AS BIT) -- NOT FOUND RETURNS FASLE
	  END
	  ELSE 
	  BEGIN
	      SELECT CAST(1 AS BIT) -- NOT FOUND RETURNS TRUE
	  END 
END TRY
BEGIN CATCH                
DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
  ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
  ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
