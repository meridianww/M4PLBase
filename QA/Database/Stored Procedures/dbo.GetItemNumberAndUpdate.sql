SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group    
   All Rights Reserved Worldwide */    
-- =============================================            
-- Author:                    Janardana             
-- Create date:               02/01/2018          
-- Description:               Get current sort number from the table name    
-- Execution:                 EXEC [dbo].[GetItemNumberAndUpdate]    
-- Modified on:      
-- Modified Desc:     
-- Execution:      EXEC [dbo].[GetItemNumberAndUpdate](0,'Customer','CustItemNumber',0,' AND CustOrgId = 2',0)     
-- =============================================                                          
                                       
                                        
CREATE PROCEDURE [dbo].[GetItemNumberAndUpdate]                                        
(             
 @id BIGINT,                                   
 @tableName NVARCHAR(100),                                        
 @sortColumn NVARCHAR(100),           
 @itemNumber INT,
 @statusId INT,                             
 @where NVARCHAR(MAX),                   
 @updatedItem INT OUTPUT                                      
)                                        
AS                                        
BEGIN             
   --Params        
        
--DECLARE @id BIGINT = 0                                
--DECLARE @entity NVARCHAR(100) = 'Customer'                                   
--DECLARE @sortColumn NVARCHAR(100) = 'CustItemNumber'        
--DECLARE @itemNumber INT = 2        
--DECLARE @where NVARCHAR(MAX)  = ' AND CustOrgId = 2';        
--DECLARE @updatedItem INT         
   --END        
          
                  
   DECLARE @updateCount INT = 0                                        
   SET @updatedItem  = 0;                                          
   DECLARE @updateQuery NVARCHAR(MAX)         
      
    
  --Update Item Number based on the order RowNumber and Order by existing Order    
  --Fix Given if any item Number is having 0 it will set to 1 and Then Update the remaining item number.    
   DECLARE @entity NVARCHAR(100);        
   SELECT @entity = SysRefName from [dbo].[SYSTM000Ref_Table] WHERE  TblTableName = @tableName;    
   EXEC UpdateItemNumberAfterDelete @entity,'',@sortColumn,@where, @id;                      
      
                                   
 IF(ISNULL(@statusId,0) <> 3) --OR @entity='JobGateway'
 BEGIN                                     
	IF @id = 0                                        
	BEGIN         
      
	IF  @itemNumber !=0    
	 BEGIN    
   SET @updateQuery = 'UPDATE '+ @tableName +   ' SET ' + @sortColumn + ' = CAST(' + @sortColumn +  '+ 1  AS INT )          
   WHERE  ' + @sortColumn + ' >=  CAST( '+ CAST( @itemNumber AS  VARCHAR ) +' AS INT)  ' + ISNULL(@where,'');       
    
   IF @entity NOT IN('JobGateway', 'DeliveryStatus')     
   BEGIN    
      SET @updateQuery = @updateQuery+ ' AND ISNULL(StatusId,1) IN(1) ';    
   END    
    
        EXEC sp_executesql @updateQuery;                          
    SET @updateCount  = @@ROWCOUNT;      
  END    
     
                                        
    IF (@updateCount > 0)                                             
 BEGIN                                         
  SET @updatedItem = @itemNumber;     
                                            
 END                                            
 ELSE                                                  
 BEGIN                                         
        DECLARE @maxItemNumber NVARCHAR(MAX)                        
        SET @maxItemNumber  =  'SELECT @updatedItem = ISNULL( MAX(CAST(' + @sortColumn+ ' AS INT)) , 0) FROM  '+ @tableName  +' WHERE 1 = 1 '+ ISNULL(@where,'');      
      
   IF @entity NOT IN('JobGateway', 'DeliveryStatus')    
   BEGIN    
      SET @maxItemNumber = @maxItemNumber+ ' AND ISNULL(StatusId,1) IN (1,2) ';    
   END    
    
        EXEC sp_executesql @maxItemNumber, N' @updatedItem int output',@updatedItem output                                        
        SET @updatedItem = @updatedItem+1;           
                                    
    END                                  
END                                        
  ELSE                                        
  BEGIN                                        
    DECLARE @oldItemNumber INT = 0, @primaryKeyName NVARCHAR(50);                                          
     
	SET  @primaryKeyName = CASE @entity 
	WHEN 'ScrOsdList' THEN 'OSDID' 
	WHEN 'ScrOsdReasonList' THEN 'ReasonID' 
	WHEN 'ScrRequirementList' THEN 'RequirementID'
	WHEN 'ScrReturnReasonList' THEN 'ReturnReasonID'
	WHEN 'ScrServiceList' THEN 'ServiceID'
	ELSE 'Id' END;
	                                   
    SET @updateQuery = 'SELECT @oldItemNumber = CAST(' + @sortColumn + ' AS INT) FROM ' + @tableName+ ' WHERE '+ @primaryKeyName +' = '+CAST(@id AS VARCHAR);   
	
    EXEC sp_executesql @updateQuery, N' @oldItemNumber int output',@oldItemNumber output                                          
                                               
    DECLARE @noOfRecords INT = 0;        
         
    SET @updateQuery = 'SELECT @noOfRecords = COUNT(*) FROM ' + @tableName+ ' (NOLOCK) WHERE ' + @sortColumn+ ' = '+ CAST(@itemNumber AS VARCHAR) +  ' '+ ISNULL(@where,'');        
        
	  IF @entity NOT IN('JobGateway', 'DeliveryStatus')    
	  BEGIN    
		  SET @updateQuery = @updateQuery+ ' AND ISNULL(StatusId,1) IN (1,2) ';    
	  END    
                              
    EXEC sp_executesql @updateQuery, N' @noOfRecords int output',@noOfRecords output                                          
                                            
    IF @noOfRecords > 0                                        
    BEGIN          
        SET @updateQuery = 'UPDATE '+ @tableName +  ' SET ' + @sortColumn + ' = CAST(' + CAST(@oldItemNumber AS VARCHAR) +  ' AS INT )  WHERE ' + @sortColumn + ' =  CAST( '+ CAST( @itemNumber AS VARCHAR(10)) +' AS INT) '  + ISNULL(@where,'');        
         IF @entity NOT IN('JobGateway', 'DeliveryStatus')    
		 BEGIN    
			SET @updateQuery = @updateQuery+ ' AND ISNULL(StatusId,1) IN (1,2) ';    
		 END    
                                   
        EXEC sp_executesql @updateQuery, N' @noOfRecords int output',@noOfRecords output                  
        SET @updatedItem = @itemNumber;                                  
    END                                          
    ELSE                                          
    BEGIN                                          
         SET  @updatedItem = @oldItemNumber;   
		 
		  IF @entity  = 'JobDocReference' AND @id > 0 AND  @noOfRecords = 0
		  BEGIN    
			  SET  @updatedItem = 1;  
			  
			  --Update item number 
			  Declare @oldDocType Int
			  Declare @jobId BIGINT
			  Declare @InsideWhere NVARCHAR(1000)
			  Declare @jobDocQuery NVARCHAR(MAX)
			  SELECT @oldDocType = DocTypeId,@jobId = jobId FROM JOBDL040DocumentReference WHERE id = @id;        
			  
			  SET @InsideWhere =  ' AND jobId = '+ CAST(@jobId as VARCHAR) + 'AND [DocTypeId]='+ CAST(@oldDocType as VARCHAR)
	

				CREATE TABLE #tempTable1(Id BIGINT,ItemNumber INT) ;    
				   SET @jobDocQuery ='Insert Into  #tempTable1 (Id,ItemNumber)    
				     SELECT  '+@entity+'.Id ,ROW_NUMBER() OVER(ORDER BY '+@entity+'.'+@sortColumn+')     
				     FROM ' + @tableName +  ' ' + @entity +    
				   ' WHERE 1=1 ' + ISNULL(@InsideWhere,'') + ' AND ISNULL(StatusId,1) IN (1,2)  Order By '+@entity+'.'+@sortColumn;    
 
   
     
				   EXEC sp_executesql @jobDocQuery;    
    
				   SET @jobDocQuery='MERGE INTO '+@tableName+' c1    
				   USING #temptable1 c2    
				   ON c1.Id=c2.Id    
				   WHEN MATCHED THEN    
				   UPDATE SET c1.'+@sortColumn+' = c2.ItemNumber;';    
  
				   EXEC sp_executesql @jobDocQuery;    
					DROP TABLE #tempTable1;
			    
		  END    
		                                           
    END                                        
  END                                 
    RETURN @updatedItem;                              
    END
END
GO
