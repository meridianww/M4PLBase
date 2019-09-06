
GO
PRINT N'Creating [dbo].[GetProgramCodesById]...';


GO
/* Copyright (2019) Meridian Worldwide Transportation Group  
   All Rights Reserved Worldwide */  
-- =============================================          
-- Author:                    Nikhi Chauhan           
-- Create date:               27/08/2019        
-- Description:               Get Program Descendants by Id    
-- Execution:                 EXEC [dbo].[GetProgramDescendants]     
-- =============================================                              
CREATE PROCEDURE [dbo].[GetProgramCodesById]
 @langCode NVARCHAR(10),    
 @orgId BIGINT,    
 @entity NVARCHAR(100),    
 @userId BIGINT=null,
 @recordId BIGINT=null
AS                    
BEGIN TRY                    
SET NOCOUNT ON;      
 DECLARE @sqlCommand NVARCHAR(MAX);    
 DECLARE @tableName NVARCHAR(100)    
 DECLARE @newPgNo INT  
 DECLARE @customerid BIGINT = 0 
  DECLARE @level INT = 0 
    SELECT @tableName = [TblTableName] FROM [dbo].[SYSTM000Ref_Table] Where SysRefName = @entity  

 	SET @sqlCommand = ';WITH CTE AS
		(
		SELECT '+  @entity + '.prgCustID  AS CUST_ID, '+  @entity + '.PrgHierarchyLevel  as PRGLevel FROM '+ @tableName + ' '+ @entity  
		SET @sqlCommand+= ' WHERE 1=1 AND '+  @entity + '.Id = ' + 'CAST('+ CAST(@recordId AS VARCHAR) + 'AS BIGINT)' + ') SELECT @customerid = CUST_ID ,@level= PRGLevel FROM CTE'
		EXEC sp_executesql @sqlCommand, N'@customerid BIGINT OUTPUT ,@level INT OUTPUT',@customerid =  @customerid OUTPUT, @level =  @level OUTPUT 

   

	SET @sqlCommand = '';  

	SET @sqlCommand = 'SELECT Id,
	(CASE WHEN PrgHierarchyLevel = 1 THEN PrgProgramCode
	WHEN PrgHierarchyLevel = 2 THEN PrgProjectCode
	WHEN PrgHierarchyLevel = 3 THEN PrgPhaseCode
	ELSE PrgProgramTitle END) AS PrgProgramCode
	FROM PRGRM000Master '+ @entity+' INNER JOIN  [dbo].[fnGetUserStatuses]( CAST('+ CAST( @userId AS  VARCHAR ) +' AS BIGINT)) fgus ON ISNULL('+  @entity + '.StatusId,1)  = fgus.StatusId WHERE PrgHierarchyLevel =' +'CAST('+ CAST( (@level + 1) AS  VARCHAR ) +' AS INT)' 
	+' AND PrgCustID= '+ 'CAST('+ CAST(@customerid AS VARCHAR) + ' AS BIGINT)'
	EXEC sp_executesql @sqlCommand
  

END TRY                    
BEGIN CATCH                    
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                    
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                    
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                    
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                    
END CATCH