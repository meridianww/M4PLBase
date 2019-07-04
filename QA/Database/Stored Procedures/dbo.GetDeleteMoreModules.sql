SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Janardana Behara         
-- Create date:               05/25/2018      
-- Description:               Get all referenced modules  by id
-- Execution:                 EXEC [dbo].[GetDeleteMoreModules]
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)   
-- Modified Desc:  
-- ============================================= 

CREATE PROCEDURE [dbo].[GetDeleteMoreModules]
 @userId BIGINT,
 @roleId BIGINT,
 @orgId BIGINT,
 @entity NVARCHAR(100),
 @recordId BIGINT
AS
BEGIN TRY                
 SET NOCOUNT ON;  
 
-- DECLARE @entity NVARCHAR(50)='Contact'
--DECLARE @recordId BIGINT = 1



DECLARE @ReferenceTable Table(
PrimaryId INT IDENTITY(1,1) primary key clustered,
ReferenceEntity NVARCHAR(50),
ParentEntity NVARCHAR(50),
ReferenceTableName NVARCHAR(100),
RefernceColumnName  NVARCHAR(100)
);

INSERT INTO @ReferenceTable(referenceEntity,parentEntity,referenceTableName,refernceColumnName)
SELECT 
(SELECT TOP 1 SysRefName FROM [dbo].[SYSTM000Ref_Table] WHERE TblTableName = sys.sysobjects.name) as [Entity],
sys.sysobjects.name AS TableName,
@entity As ParentTableName ,

(SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE WHERE CONSTRAINT_NAME = sys.foreign_keys.name) AS ColumnName
FROM 
sys.foreign_keys 
inner join sys.sysobjects on
sys.foreign_keys.parent_object_id = sys.sysobjects.id
INNER JOIN  [dbo].[SYSTM000Ref_Table] refTable  ON OBJECT_ID(refTable.TblTableName) = referenced_object_id
--INNER JOIN INFORMATION_SCHEMA.KEY_COLUMN_USAGE AS FK  ON FK.CONSTRAINT_NAME = sys.sysobjects.name
WHERE refTable.SysRefName = @entity

SELECT * FROM @ReferenceTable Order by ReferenceEntity


END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
