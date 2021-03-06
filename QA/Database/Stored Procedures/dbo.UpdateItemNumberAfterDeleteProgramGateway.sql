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
CREATE PROCEDURE [dbo].[UpdateItemNumberAfterDeleteProgramGateway] --'PrgRefGatewayDefault' ,'10028,10030' ,'PgdGatewaySortOrder' ,' AND PgdProgramId=56'
@entity NVARCHAR(100),          
@ids NVARCHAR(MAX),          
@itemFieldName NVARCHAR(100),          
@where NVARCHAR(MAX) = NULL          
AS          
BEGIN TRY                          
 SET NOCOUNT ON;             
      
--DECLARE 	  @entity NVARCHAR(100) ='PrgRefGatewayDefault'          
--DECLARE @ids NVARCHAR(MAX) = '10028,10030'     
--DECLARE @itemFieldName NVARCHAR(100)='PgdGatewaySortOrder'        
--DECLARE @where NVARCHAR(MAX) = ' AND PgdProgramId=56'    


	   DECLARE @tableName NVARCHAR(100),          
           @leastId BIGINT,           
     @nextId BIGINT ,          
     @sqlCommand NVARCHAR(MAX),          
     @statues NVARCHAR(100),    
     @itemNo INT         
	       
   SELECT   @statues = SysStatusesIn  FROM SYSTM000Ref_Settings          
   SELECT @tableName = TblTableName from [dbo].[SYSTM000Ref_Table] WHERE SysRefName = @entity;   
   DECLARE @gatewayIds TABLE(Id BIGINT , ItemN Int) ;
   INSERT INTO @gatewayIds(Id,ItemN)
   SELECT Item,ROW_NUMBER() OVER(ORDER By Item)  FROM [dbo].[fnSplitString](@ids, ',');
   
   DECLARE @leastIdRowNo INT  = 1
   DECLARE @InsideWhere NVARCHAR(MAX) 
  
   WHILE EXISTS( SELECT * FROM  @gatewayIds WHERE  ItemN = @leastIdRowNo)
   BEGIN
    
	 DECLARE @gatewayType INT
	 DECLARE @orderType NVARCHAR(20)
	 DECLARE @shipmentType  NVARCHAR(20)
	 
     SET @InsideWhere= @where;


	 SELECT @gatewayType =gatewayTypeID,  @orderType = [PgdOrderType], @shipmentType =  [PgdShipmentType]FROM [dbo].[PRGRM010Ref_GatewayDefaults]
	 WHERE Id =( SELECT Id FROM  @gatewayIds WHERE  ItemN = @leastIdRowNo)
	 
	 SET @InsideWhere =  @InsideWhere + ' AND [GatewayTypeId]='+ CAST(@gatewayType as VARCHAR)
	 SET @InsideWhere =  @InsideWhere + ' AND PgdOrderType='''+@orderType+''''
	 SET @InsideWhere =  @InsideWhere + ' AND PgdShipmentType='''+@shipmentType+''''
	

	 CREATE TABLE #tempTable1(Id BIGINT,ItemNumber INT) ;    
   SET @sqlCommand ='Insert Into  #tempTable1 (Id,ItemNumber)    
   SELECT  '+@entity+'.Id ,ROW_NUMBER() OVER(ORDER BY '+@entity+'.'+@itemFieldName+')     
   FROM ' + @tableName +  ' ' + @entity +    
   ' JOIN [dbo].[fnSplitString](''' + @statues + ''', '','') sts ON  ISNULL(' + @entity + '.StatusId,1) = sts.Item    
   WHERE 1=1 ' + ISNULL(@InsideWhere,'') +'  Order By '+@entity+'.'+@itemFieldName;    
 
   
     
   EXEC sp_executesql @sqlCommand;    
    
   SET @sqlCommand='MERGE INTO '+@tableName+' c1    
   USING #temptable1 c2    
   ON c1.Id=c2.Id    
   WHEN MATCHED THEN    
   UPDATE SET c1.'+@itemFieldName+' = c2.ItemNumber;';    
  
   EXEC sp_executesql @sqlCommand;    
    DROP TABLE #tempTable1;



	 
	
	set @leastIdRowNo = @leastIdRowNo+1;

   END



         
END TRY                          
BEGIN CATCH                          
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                          
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                          
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                          
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                          
END CATCH
GO
