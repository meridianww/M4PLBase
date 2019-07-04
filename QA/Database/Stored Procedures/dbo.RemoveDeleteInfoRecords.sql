SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group    
   All Rights Reserved Worldwide */    
-- =============================================            
-- Author:                    Janardana Behara             
-- Create date:               07/04/2018          
-- Description:               update records to archieve on delete info
-- Execution:                 EXEC [dbo].[RemoveDeleteInfoRecords]    
-- Modified on:      
-- Modified Desc:      
-- =============================================     
    
CREATE PROCEDURE [dbo].[RemoveDeleteInfoRecords]    
 @userId BIGINT,    
 @roleId BIGINT,    
 @orgId BIGINT,    
 @entity NVARCHAR(100),    
 @parentEntity NVARCHAR(100),    
 @contains NVARCHAR(100) ,
 @parentFieldName NVARCHAR(100)= NULL,
 @itemNumberField NVARCHAR(100)  = NULL
AS    
BEGIN TRY                    
 SET NOCOUNT ON;      
     
--DECLARE @entity NVARCHAR(50)='CustDcLocation'    
--DECLARE @parentEntity NVARCHAR(100) = 'Contact'   
--DECLARE @contains BIGINT = 242    
    
  DECLARE @tableName NVARCHAR(100)  
  
  SELECT @tableName = TblTableName FROM [dbo].[SYSTM000Ref_Table] WHERE SysRefName = @entity  
  
  
  
DECLARE @ReferenceTable Table(    
PrimaryId INT IDENTITY(1,1) primary key clustered,    
ReferenceEntity NVARCHAR(50),    
ParentEntity NVARCHAR(50),    
ReferenceTableName NVARCHAR(100),    
ReferenceColumnName  NVARCHAR(100)    
);    
    
INSERT INTO @ReferenceTable(referenceEntity,parentEntity,referenceTableName,ReferenceColumnName)    
SELECT     
(SELECT TOP 1 SysRefName FROM [dbo].[SYSTM000Ref_Table] WHERE TblTableName = sys.sysobjects.name) as [Entity],    
  
@tableName,  
  
sys.sysobjects.name AS TableName,    
    
(SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE WHERE CONSTRAINT_NAME = sys.foreign_keys.name) AS ColumnName    
FROM     
sys.foreign_keys     
inner join sys.sysobjects on    
sys.foreign_keys.parent_object_id = sys.sysobjects.id    
INNER JOIN  [dbo].[SYSTM000Ref_Table] refTable  ON OBJECT_ID(refTable.TblTableName) = referenced_object_id    
--INNER JOIN INFORMATION_SCHEMA.KEY_COLUMN_USAGE AS FK  ON FK.CONSTRAINT_NAME = sys.sysobjects.name    
WHERE refTable.SysRefName = @parentEntity   
    AND   sys.sysobjects.name = @tableName;  
    
DECLARE @query NVARCHAR(MAX)  
DECLARE @whereQuery NVARCHAR(MAX) 
  
SELECT @query = COALESCE(@query+' OR ' ,'') + ReferenceColumnName + ' in ('+CAST(@contains as VARCHAR)+')'  FROM @ReferenceTable  Order by ReferenceEntity    
 SET @whereQuery = @query;
SET  @query = 'UPDATE  ' + @tableName+'  Set StatusId = 3  WHERE ' + @query  
 
EXEC sp_executesql @query   ;

IF LEN(ISNULL(@itemNumberField,'')) > 0
BEGIN


CREATE TABLE #T1(    
PrimaryId INT IDENTITY(1,1) primary key clustered,    
ParentId BIGINT 
);  
 
set @whereQuery = ' INSERT INTO  #T1 (ParentId) select DISTINCT ' + @parentFieldName + ' from  ' + @tableName + ' WHERE ' + @whereQuery
select @whereQuery
EXEC sp_executesql @whereQuery   


   DECLARE @leastIdRowNo INT  = 1
   DECLARE @InsideWhere NVARCHAR(MAX) 
  
   WHILE EXISTS( SELECT * FROM  #T1 WHERE  PrimaryId = @leastIdRowNo)
   BEGIN
    
	 DECLARE @parId BIGINT;
	 SELECT  @parId = ParentId FROM  #T1 WHERE  PrimaryId = @leastIdRowNo
	 
     SET @InsideWhere=  ' AND ' + @parentFieldName + ' = ' +CAST(@parId As VARCHAR);

	 EXEC UpdateItemNumberAfterDelete @entity,@contains,@itemNumberField,@InsideWhere
	
	 set @leastIdRowNo = @leastIdRowNo+1;

   END
   DROP TABLE #T1
END
    
END TRY                    
BEGIN CATCH                    
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                    
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                    
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                    
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                    
END CATCH
GO
