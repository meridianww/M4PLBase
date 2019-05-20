/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Janardana B   
-- Create date:               03/27/2018      
-- Description:               Update Item Number after delete for SecurityByRole   
-- Execution:                 EXEC [dbo].[UpdSecByRoleItemNumberAfterDelete]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================   
ALTER PROCEDURE [dbo].[UpdSecByRoleItemNumberAfterDelete]
	@entity NVARCHAR(100),      
	@ids NVARCHAR(MAX),      
	@itemFieldName NVARCHAR(100),      
	@where NVARCHAR(MAX) = NULL,
	@parentId BIGINT = 0      
AS      
BEGIN TRY                      
 SET NOCOUNT ON;        
       
   DECLARE @leastId BIGINT,       
		   @nextId BIGINT ,      
		   @sqlCommand NVARCHAR(MAX),      
		   @statues NVARCHAR(100),      
		   @itemNo INT      
   SELECT  @statues = SysStatusesIn  FROM SYSTM000Ref_Settings         
   
   SET @where = ' AND [OrgRefRoleId] = ' + CAST(@parentId AS NVARCHAR(50))
    
   CREATE TABLE #tempTable(Id BIGINT,ItemNumber INT) ;
			SET @sqlCommand ='Insert Into  #tempTable (Id,ItemNumber)
			SELECT  '+@entity+'.Id ,ROW_NUMBER() OVER(ORDER BY '+@entity+'.'+@itemFieldName+') 
			FROM [dbo].[SYSTM000SecurityByRole] ' + @entity +
			' JOIN [dbo].[fnSplitString](''' + @statues + ''', '','') sts ON ' + @entity + '.StatusId = sts.Item
			WHERE 1=1 ' + ISNULL(@where,'') +'  Order By '+@entity+'.'+@itemFieldName;
				
			EXEC sp_executesql @sqlCommand;

			SET @sqlCommand='MERGE INTO [dbo].[SYSTM000SecurityByRole] c1
			USING #temptable c2
			ON c1.Id=c2.Id
			WHEN MATCHED THEN
			UPDATE SET c1.'+@itemFieldName+' = c2.ItemNumber;';

			EXEC sp_executesql @sqlCommand;
            DROP TABLE #tempTable;
	END TRY                      
BEGIN CATCH                      
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                      
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                      
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                      
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                      
END CATCH
GO

