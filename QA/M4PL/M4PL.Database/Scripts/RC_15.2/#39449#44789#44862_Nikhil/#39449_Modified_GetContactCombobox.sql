/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Janardana Behara        
-- Create date:               05/29/2018      
-- Description:               Get selected records by table  
-- Execution:                 EXEC [dbo].[GetContactCombobox]   
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)    
-- Modified Desc:  
-- Modified on:				  07/08/2019( Nikhil - Introduced roleId to support security)    
-- Modified Desc:             Added Condition to filter analyst contacts 
-- =============================================                            
Alter PROCEDURE [dbo].[GetContactCombobox] 
 @langCode NVARCHAR(10),  
 @orgId BIGINT,  
 @entity NVARCHAR(100),  
 @fields NVARCHAR(2000),  
 @pageNo INT,  
 @pageSize INT,  
 @orderBy NVARCHAR(500),  
 @like NVARCHAR(500) = NULL,  
 @where NVARCHAR(500) = null,
 @primaryKeyValue NVARCHAR(100) = null,
 @primaryKeyName NVARCHAR(50) = null,  
 @parentId BIGINT = null,
 @entityFor NVARCHAR(50) = null,
 @parentEntity NVARCHAR(50) = null
AS                  
BEGIN TRY                  
SET NOCOUNT ON;    
 DECLARE @sqlCommand NVARCHAR(MAX); 
 DECLARE @newPgNo INT

 SET @sqlCommand = '';

 IF( @entityFor = 'PPPRespGateway' OR  @entityFor = 'PPPAnalystGateway'  OR @entityFor = 'PPPJobRespContact' OR @entityFor = 'PPPJobAnalystContact' OR @entityFor = 'PPPRoleCodeContact')
 BEGIN
  EXEC [dbo].[GetPPPGatewayContactCombobox]  @langCode,@orgId,@entity,@fields,@pageNo,@pageSize,@orderBy,@like,@where,@primaryKeyValue,@primaryKeyName,@parentId,@entityFor
 END
 ELSE
 BEGIN

	 IF(ISNULL(@primaryKeyValue, '') <> '')
	 BEGIN
		SET @sqlCommand += ' SELECT @newPgNo = Item FROM (SELECT ROW_NUMBER() OVER(ORDER BY ' + @entity + '.' + @primaryKeyName+') as Item  ,' +@entity + '.' + @primaryKeyName + 
						   ' From [dbo].[CONTC000Master] (NOLOCK)  ' + @entity;
	
		SET @sqlCommand = @sqlCommand + ' WHERE '+  @entity +'.ConOrgId ='+  CAST(@orgId AS NVARCHAR(100)) +  ' AND (ISNULL('+ @entity +'.StatusId, 1) In (1,2)  OR ' + @primaryKeyName + '=' + @primaryKeyValue + ')';
	    
	
		SET @sqlCommand += ' ) t WHERE t.' + @primaryKeyName + '=' + @primaryKeyValue;
		print @sqlCommand
		EXEC sp_executesql @sqlCommand, N' @newPgNo int output',@newPgNo output                                    
		SET @newPgNo =  @newPgNo/@pageSize + 1; 
		SET @pageSize = @newPgNo * @pageSize;
		SET @sqlCommand=''
	 END
	 
	 SET @sqlCommand += 'SELECT '+ @fields +' From [dbo].[CONTC000Master] (NOLOCK) '+  @entity + ' WHERE 1=1 '  + ' AND '+ @entity +'.ConOrgId ='+  CAST(@orgId AS NVARCHAR(100))
	
     IF(ISNULL(@primaryKeyValue, '') <> '')
	 BEGIN
          SET @sqlCommand = @sqlCommand + ' AND (ISNULL('+ @entity +'.StatusId, 1) In (1,2)  OR  '+ @entity +'.' + @primaryKeyName + '=' + @primaryKeyValue + ')';
	 END
	 ELSE
	 BEGIN
	     SET @sqlCommand = @sqlCommand + ' AND ISNULL('+ @entity +'.StatusId, 1) In (1,2)';
	 END

	 IF(ISNULL(@like, '') != '')  
	  BEGIN  
	  SET @sqlCommand = @sqlCommand + ' AND ('  
	   DECLARE @likeStmt NVARCHAR(MAX)  
  
	  SELECT @likeStmt = COALESCE(@likeStmt + ' OR ','') + Item + ' LIKE ''%' + @like + '%' + '''' FROM [dbo].[fnSplitString](@fields, ',')    
	  SET @sqlCommand = @sqlCommand + @likeStmt + ') '  
	  END  
	 IF(ISNULL(@where, '') != '')  
	  BEGIN  
		 SET @sqlCommand = @sqlCommand + @where   
	 END  

	 IF(@entityFor='CustTabsContactInfo' AND @parentId > 0 AND ISNULL(@parentEntity,'') = 'CustContact')
	 BEGIN  
		 SET @sqlCommand = @sqlCommand + ' AND '+ @entity +'.ConCompanyName IN (SELECT CustTitle FROM [dbo].[CUST000Master] (NOLOCK) WHERE Id = @parentId)'   
	 END
	 ELSE  IF(@entityFor='VendTabsContactInfo' AND @parentId > 0 AND ISNULL(@parentEntity,'') = 'VendContact')
	 BEGIN  
		 SET @sqlCommand = @sqlCommand + ' AND '+ @entity +'.ConCompanyName IN (SELECT VendTitle FROM [dbo].[Vend000Master] (NOLOCK) WHERE Id = @parentId)'   
	 END
	 ELSE  IF(@entityFor='CustTabsContactInfo' AND @parentId > 0 AND ISNULL(@parentEntity,'') = 'CustDcLocation')
	 BEGIN  
		 SET @sqlCommand = @sqlCommand + ' AND '+ @entity +'.Id IN (SELECT ContactMSTRID FROM CONTC010Bridge CB (NOLOCK) WHERE ConPrimaryRecordId = @parentId AND CB.ConTableName=''CustContact'')'   
	 END
	 ELSE  IF(@entityFor='VendTabsContactInfo' AND @parentId > 0 AND ISNULL(@parentEntity,'') = 'VendDcLocation')
	 BEGIN  
		 SET @sqlCommand = @sqlCommand + ' AND '+ @entity +'.Id IN (SELECT ContactMSTRID FROM CONTC010Bridge CB (NOLOCK) WHERE ConPrimaryRecordId = @parentId AND CB.ConTableName=''VendContact'')'   
	 END
  
	SET @sqlCommand = @sqlCommand + ' ORDER BY '+ @fields +' OFFSET @pageSize * (@pageNo - 1) ROWS FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);'   
 print @sqlCommand
	EXEC sp_executesql @sqlCommand, N'@pageNo INT, @pageSize INT, @where NVARCHAR(100), @parentId BIGINT' ,  
		 @pageNo = @pageNo,   
		 @pageSize = @pageSize,  
		 @where = @where,
		 @parentId = @parentId

END
END TRY                  
BEGIN CATCH                  
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                  
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                  
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                  
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                  
END CATCH
GO

