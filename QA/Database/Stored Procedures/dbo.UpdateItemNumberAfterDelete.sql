SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group    
   All Rights Reserved Worldwide */    
-- =============================================            
-- Author:                    Janardana B     
-- Create date:               01/04/2018          
-- Description:               Update Item Number after delete     
-- Execution:                 EXEC [dbo].[UpdateItemNumberAfterDelete]    
-- Modified on:      
-- Modified Desc:      
-- =============================================         
CREATE PROCEDURE [dbo].[UpdateItemNumberAfterDelete]    
@entity NVARCHAR(100),          
@ids NVARCHAR(MAX),          
@itemFieldName NVARCHAR(100),          
@where NVARCHAR(MAX) = NULL, 
@recordId BIGINT=  NULL      
AS          
BEGIN TRY                          
 SET NOCOUNT ON;            
           
   DECLARE @tableName NVARCHAR(100),          
           @leastId BIGINT,           
     @nextId BIGINT ,          
     @sqlCommand NVARCHAR(MAX),          
     @statues NVARCHAR(100),          
     @itemNo INT          
   SELECT   @statues = SysStatusesIn  FROM SYSTM000Ref_Settings          
   SELECT @tableName = TblTableName from [dbo].[SYSTM000Ref_Table] WHERE SysRefName = @entity;   
   
   IF @entity = 'PrgRefGatewayDefault'
   BEGIN
    EXEC UpdateItemNumberAfterDeleteProgramGateway @entity,@ids,@itemFieldName,@where
   END
   ELSE IF @entity = 'JobDocReference'
   BEGIN
    EXEC UpdateItemNumberAfterDeleteJobDocRef @entity,@ids,@itemFieldName,@where
   END
    --ADDING THIS FOR UPDATING JOB GATEWAY ITEM NUMBER
   --ELSE IF @entity='JobGateway'
   --BEGIN 
   --EXEC UpdateItemNumberAfterDeleteJobGateway @entity,@ids,@itemFieldName,@where
   --END
   ELSE
   BEGIN
    
    DECLARE @primaryKeyName NVARCHAR(50);                                          
	SET  @primaryKeyName = CASE @entity 
	WHEN 'ScrOsdList' THEN 'OSDID' 
	WHEN 'ScrOsdReasonList' THEN 'ReasonID' 
	WHEN 'ScrRequirementList' THEN 'RequirementID'
	WHEN 'ScrReturnReasonList' THEN 'ReturnReasonID'
	WHEN 'ScrServiceList' THEN 'ServiceID'
	ELSE 'Id' END;
	    
  CREATE TABLE #tempTable(Id BIGINT,ItemNumber INT) ;    
   SET @sqlCommand ='Insert Into  #tempTable (Id,ItemNumber)    
   SELECT  '+@entity+'.'+@primaryKeyName+' ,ROW_NUMBER() OVER(ORDER BY '+@entity+'.'+@itemFieldName+') as ItemNumber   
   FROM ' + @tableName +  ' ' + @entity +    
   ' JOIN [dbo].[fnSplitString](''' + @statues + ''', '','') sts ON  ISNULL(' + @entity + '.StatusId,1) = sts.Item    
   WHERE 1=1 AND '
   + @entity+'.'+@primaryKeyName +'<> CAST( '+ CAST( @recordId AS  VARCHAR ) +' AS BIGINT) ' 
   + ISNULL(@where,'') +'  Order By '+@entity+'.'+@itemFieldName;            
   EXEC sp_executesql @sqlCommand;    
    
   SET @sqlCommand='MERGE INTO '+@tableName+' c1    
   USING #temptable c2    
   ON c1.'+@primaryKeyName+'=c2.Id    
   WHEN MATCHED THEN    
   UPDATE SET c1.'+@itemFieldName+' = c2.ItemNumber;';    
  
   EXEC sp_executesql @sqlCommand;    
            DROP TABLE #tempTable;    
END
    
         
END TRY                          
BEGIN CATCH                          
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                          
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                          
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                          
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                          
END CATCH
GO
