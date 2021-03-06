SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Janardana B         
-- Create date:               03/28/2018      
-- Description:               GET TABLE ASSOCIATIONS  
-- Execution:                 EXEC [dbo].[GetTableAssociations]   
-- Modified on:  
-- Modified Desc:  
-- =============================================

CREATE PROCEDURE [dbo].[GetTableAssociations]
(
 @tableName NVARCHAR(100)=NULL,
 @id NVARCHAR(1000) = NULL
)
AS
BEGIN TRY
 SET NOCOUNT ON;

DECLARE @ReferenceTable Table(
primaryId INT IDENTITY(1,1) primary key clustered,
referenceEntity NVARCHAR(50),
parentEntity NVARCHAR(50),
referenceTableName NVARCHAR(100),
referenceColumnName  NVARCHAR(100)
);

INSERT INTO @ReferenceTable(referenceEntity,parentEntity,referenceTableName,referenceColumnName)
SELECT 
(SELECT TOP 1 SysRefName FROM [dbo].[SYSTM000Ref_Table] WHERE TblTableName = sys.sysobjects.name) as [Entity],
@tableName As ParentTableName ,
sys.sysobjects.name AS TableName,

(SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE WHERE CONSTRAINT_NAME = sys.foreign_keys.name) AS ColumnName
FROM 
sys.foreign_keys 
inner join sys.sysobjects on
sys.foreign_keys.parent_object_id = sys.sysobjects.id
INNER JOIN  [dbo].[SYSTM000Ref_Table] refTable  ON OBJECT_ID(refTable.TblTableName) = referenced_object_id
WHERE refTable.SysRefName = @tableName;



CREATE TABLE #DataReferenceTable(
Id BIGINT,
ParentId BIGINT NULL,
Entity NVARCHAR(100),
ParentEntity NVARCHAR(100),
Name  NVARCHAR(250)
);



   Declare @minId INT,@maxId INT
   SELECT @minId = Min(primaryId),@maxId = Count(primaryId)  FROM @ReferenceTable
	WHILE(@minId <= @maxId)
	BEGIN
	   DECLARE @sqlCommand NVARCHAR(MAX);
	   DECLARE @refTableName NVARCHAR(100),@refTableColName NVARCHAR(100),@refEntity NVARCHAR(100),@parentEntity NVARCHAR(100)
   
	   SELECT  @refTableName = referenceTableName
			  ,@refTableColName = referenceColumnName
			  ,@refEntity = referenceEntity
			  ,@parentEntity = parentEntity
   
		FROM @ReferenceTable Where primaryId = @minId;
	

	   SET  @sqlCommand = 'INSERT INTO #DataReferenceTable(Id,ParentId,Entity,ParentEntity,Name) 
				 SELECT Id, '+@refTableColName+',@refEntity,@parentEntity,Id FROM  '+@refTableName+' WHERE '+@refTableColName+' IN (@id)';
	   EXEC sp_executesql @sqlCommand,N'@refEntity NVARCHAR(100),@parentEntity NVARCHAR(100),@id NVARCHAR(1000)',@refEntity,@parentEntity ,@id   ; 
	   SET @minId = @minId + 1;
	END

  SELECT * FROM #DataReferenceTable;
 
  DROP TABLE #DataReferenceTable;

END TRY                      
BEGIN CATCH                      
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                      
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                      
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                      
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                      
END CATCH
GO
