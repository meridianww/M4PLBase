


GO
PRINT N'Altering [dbo].[GetContactCombobox]...';


GO
 
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Janardana Behara        
-- Create date:               05/29/2018      
-- Description:               Get selected records by table  
-- Execution:                 [dbo].[GetContactCombobox]  'EN',1,'Contact','Contact.Id,Contact.ConFullName,Contact.ConJobTitle,Contact.ConFileAs',1,30,null,null,null,null,null,10003,'VendTabsContactInfo','VendContact',7,null  
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)    
-- Modified on:				  07/23/2019( Kirty - Added condition to get driver contact for JobDriverContactInfo)    
-- Modified on:				  08/12/2019(Nikhil Chauhan)   
-- Modified Desc:             Updated to get the Driver Contacts based on vendor DC location passed.
-- =============================================                            
ALTER PROCEDURE [dbo].[GetContactCombobox]  
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
 @parentEntity NVARCHAR(50) = null,
 @companyId BIGINT = NULL,
 @jobSiteCode NVARCHAR(50) = NULL
AS                  
BEGIN TRY                  
SET NOCOUNT ON;    
 DECLARE @sqlCommand NVARCHAR(MAX); 
 DECLARE @newPgNo INT

 SET @sqlCommand = '';

 IF( @entityFor = 'PPPRespGateway' OR @entityFor = 'PPPJobRespContact' OR @entityFor = 'PPPJobAnalystContact' OR @entityFor = 'PPPRoleCodeContact' OR @entityFor = 'PPPAnalystGateway')
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
	 SET @sqlCommand += 'SELECT '+ @fields +' From [dbo].[CONTC000Master] (NOLOCK) '+  @entity + ' LEFT JOIN [dbo].[SYSTM000Ref_Options] refOpt ON refOpt.Id = ' + @entity + '.ConTypeId' 
	 IF (@parentEntity ='Job' AND @entityFor=N'JobDriverContactInfo' )
	 BEGIN
	   SET @sqlCommand += ' LEFT JOIN  CONTC010Bridge cb on cb.ContactMSTRID = contact.Id 
						    LEFT JOIN ORGAN010Ref_Roles refrole on refrole.Id = cb.ConCodeId 
							LEFT JOIN VEND040DCLocations vdcl on vdcl.Id = cb.ConPrimaryRecordId 
							LEFT JOIN SYSTM000Ref_Options refoptRole ON refoptRole.Id = refrole.RoleTypeId '
	 END
	 	 
	SET @sqlCommand +=  ' WHERE 1=1 '  + ' AND '+ @entity +'.ConOrgId ='+  CAST(@orgId AS NVARCHAR(100))


	 IF(ISNULL(@CompanyId, 0) <> 0)
	 BEGIN
	  SET @sqlCommand +=  ' AND '+ @entity +'.ConCompanyId ='+ CAST(@companyId AS NVARCHAR(100))
	 END
	  IF (@parentEntity ='Job' AND @entityFor=N'JobDriverContactInfo' )
	 BEGIN
	   SET @sqlCommand += ' AND refoptRole.SysOptionName = ''Vendor'' and refrole.OrgRoleCode = ''Driver'' and  refopt.SysOptionName = ''Vendor'' and cb.ConTableName = ''VendDcLocationContact''   and  cb.statusid IN (1,2) and vdcl.VdcLocationCode = '''+ @jobSiteCode +''''
	 END

	   IF (@parentEntity ='OrgPocContact')
	 BEGIN
	   SET @sqlCommand += ' AND '+ @entity +'.ConCompanyId = ( select id  from  [COMP000Master] where CompPrimaryRecordId = ' +  CAST(@orgId AS NVARCHAR(100)) + ')'
	 END

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
	
	SET @sqlCommand = @sqlCommand + ' ORDER BY '+ @fields +' OFFSET @pageSize * (@pageNo - 1) ROWS FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);'   


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
PRINT N'Altering [dbo].[GetCustDcLocation]...';


GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               08/16/2018      
-- Description:               Get a cust DCLocation
-- Execution:                 EXEC [dbo].[GetCustDcLocation]
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)   
-- Modified Desc:  
-- =============================================
ALTER PROCEDURE  [dbo].[GetCustDcLocation]
    @userId BIGINT,
    @roleId BIGINT,
	@orgId BIGINT,
    @id BIGINT
AS
BEGIN TRY                
 SET NOCOUNT ON;   
 SELECT cust.[Id]
      ,cust.[CdcCustomerID]
      ,cust.[CdcItemNumber]
      ,cust.[CdcLocationCode]
	  ,ISNULL(cust.[CdcCustomerCode],cust.[CdcLocationCode]) AS  CdcCustomerCode
      ,cust.[CdcLocationTitle]
      ,cb.[ContactMSTRID] as CdcContactMSTRID
      ,cust.[StatusId]
      ,cust.[EnteredBy]
      ,cust.[DateEntered]
      ,cust.[ChangedBy]
      ,cust.[DateChanged] 
	  ,COMP.Id CompanyId
  FROM [dbo].[CUST040DCLocations] cust
  INNER JOIN dbo.COMP000Master COMP ON COMP.CompPrimaryRecordId = cust.CdcCustomerID AND COMP.CompTableName = 'Customer' INNER JOIN [CONTC010Bridge] cb on cb.ConPrimaryRecordId = cust.Id AND cb.ConTableName='CustDcLocation'
 WHERE CUST.[Id]=@id
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
PRINT N'Altering [dbo].[InsCustDcLocation]...';


GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               08/16/2018      
-- Description:               Ins a cust dc locations
-- Execution:                 EXEC [dbo].[InsCustDcLocation]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================  
ALTER PROCEDURE  [dbo].[InsCustDcLocation]		  
	@userId BIGINT
	,@roleId BIGINT 
	,@entity NVARCHAR(100)
	,@cdcCustomerId BIGINT 
	,@conOrgId INT
	,@cdcItemNumber INT 
	,@cdcLocationCode NVARCHAR(20)
	,@cdcCustomerCode NVARCHAR(20)
	,@cdcLocationTitle NVARCHAR(50) 
	,@cdcContactMSTRId BIGINT 
	,@statusId INT 
	,@enteredBy NVARCHAR(50) 
	,@dateEntered DATETIME2(7) 		  
AS
BEGIN TRY                
 SET NOCOUNT ON;   
   DECLARE @updatedItemNumber INT      
  EXEC [dbo].[ResetItemNumber] @userId, 0, @cdcCustomerId, @entity, @cdcItemNumber, @statusId, NULL, NULL,  @updatedItemNumber OUTPUT  
   BEGIN TRANSACTION
 DECLARE @currentId BIGINT;
   INSERT INTO [dbo].[CUST040DCLocations]
           ([CdcCustomerId]
           ,[CdcItemNumber]
           ,[CdcLocationCode]
		   ,[CdcCustomerCode]
           ,[CdcLocationTitle]
           ,[StatusId]
           ,[EnteredBy]
           ,[DateEntered])
     VALUES
		   (@cdcCustomerId 
           ,@updatedItemNumber  
           ,@cdcLocationCode   
		   ,ISNULL(@cdcCustomerCode,@cdcLocationCode)
           ,@cdcLocationTitle   
           ,@statusId 
           ,@enteredBy 
           ,@dateEntered) 	
		   SET @currentId = SCOPE_IDENTITY();

		   
   INSERT INTO [dbo].[CONTC010Bridge] (
		[ConOrgId]
		,[ContactMSTRID]
		,[ConTableName]
		,[ConPrimaryRecordId]
		,[ConTypeId] 
		,[ConItemNumber]
		,[ConTitle]
		,[StatusId]
		,[EnteredBy]
		,[DateEntered]
		)
	VALUES (
		@conOrgId
		,@cdcContactMSTRId  
		,@entity
		,@currentId
		,(select ConTypeId  from CONTC000Master where id = @cdcContactMSTRId)
		,@updatedItemNumber
		 ,(select ConJobTitle  from CONTC000Master where id = @cdcContactMSTRId)
		,@statusId
		,@enteredBy
		,@dateEntered
		)
			COMMIT
	EXEC [dbo].[GetCustDcLocation] @userId, @roleId, 1 ,@currentId
END TRY                
BEGIN CATCH 
 ROLLBACK              
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
PRINT N'Altering [dbo].[UpdCustDcLocation]...';


GO

/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               08/16/2018      
-- Description:               Upd a cust DCLocations
-- Execution:                 EXEC [dbo].[UpdCustDcLocation]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- Modified on:				  2nd May 2019
-- Modified Desc:			  Implemented contact bridge related item by Parthiban M    
-- =============================================
ALTER PROCEDURE  [dbo].[UpdCustDcLocation]		  
	@userId BIGINT
	,@roleId BIGINT  
	,@entity NVARCHAR(100)
	,@id BIGINT
	,@conOrgId BIGINT
	,@cdcCustomerId BIGINT = NULL
	,@cdcItemNumber INT  = NULL
	,@cdcLocationCode NVARCHAR(20)  = NULL
	,@cdcCustomerCode NVARCHAR(20) =NULL
	,@cdcLocationTitle NVARCHAR(50)  = NULL
	,@cdcContactMSTRId BIGINT  = NULL
	,@statusId INT   = NULL
	,@changedBy NVARCHAR(50)  = NULL
	,@dateChanged DATETIME2(7)  = NULL		  
	,@isFormView BIT = 0
AS
BEGIN TRY                
 SET NOCOUNT ON;   
  DECLARE @updatedItemNumber INT      
 EXEC [dbo].[ResetItemNumber] @userId, @id, @cdcCustomerId, @entity, @cdcItemNumber, @statusId, NULL, NULL,  @updatedItemNumber OUTPUT 

    UPDATE  [dbo].[CUST040DCLocations]
       SET   CdcCustomerId	  =  ISNULL(@cdcCustomerId, CdcCustomerId) 
            ,CdcItemNumber	  =  ISNULL(@updatedItemNumber, CdcItemNumber) 
            ,CdcLocationCode  =  ISNULL(@cdcLocationCode, CdcLocationCode)  
			,CdcCustomerCode  =  ISNULL(@cdcCustomerCode,CdcCustomerCode)  
            ,CdcLocationTitle =  ISNULL(@cdcLocationTitle, CdcLocationTitle)   
            ,StatusId		  =  ISNULL(@statusId, StatusId) 
            ,ChangedBy		  =  ISNULL(@changedBy,ChangedBy)
            ,DateChanged	  =  ISNULL(@dateChanged, DateChanged)
	  WHERE  Id = @id 
	      
	If NOT EXISTS (Select 1 from [CONTC010Bridge]  where ConPrimaryRecordId = @id AND ContactMSTRID =  @cdcContactMSTRId  And  ConTableName = 'CustDcLocation' And ConOrgId = @conOrgId)	  
	Begin
	 UPDATE [CONTC010Bridge] set [ContactMSTRID] = @cdcContactMSTRId where  ConPrimaryRecordId = @id   And  ConTableName = 'CustDcLocation' And ConOrgId = @conOrgId

	END
		         


	EXEC [dbo].[GetCustDcLocation] @userId, @roleId, 1 ,@id 
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
PRINT N'Altering [dbo].[GetCustDcLocationView]...';


GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               09/04/2018      
-- Description:               Get all customer dc location
-- Execution:                 EXEC [dbo].[GetCustDcLocationView]
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)    
-- Modified Desc:  
-- =============================================
ALTER PROCEDURE [dbo].[GetCustDcLocationView]
 @userId BIGINT,
 @roleId BIGINT,
 @orgId BIGINT,
 @entity NVARCHAR(100),
 @pageNo INT,
 @pageSize INT,
 @orderBy NVARCHAR(500),
 @groupBy NVARCHAR(500), 
 @groupByWhere NVARCHAR(500), 
 @where NVARCHAR(MAX),
 @parentId BIGINT,
 @isNext BIT,
 @isEnd BIT,
 @recordId BIGINT,
 @TotalCount INT OUTPUT
AS
BEGIN TRY                
 SET NOCOUNT ON;  
 DECLARE @sqlCommand NVARCHAR(MAX);
 DECLARE @TCountQuery NVARCHAR(MAX);

SET @TCountQuery = 'SELECT @TotalCount = COUNT(' + @entity + '.Id) FROM [dbo].[CUST040DCLocations] (NOLOCK) '+ @entity 

--Below for getting user specific 'Statuses'
SET @TCountQuery = @TCountQuery + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) fgus ON ' + @entity + '.[StatusId] = fgus.[StatusId] '
--Below to get BIGINT reference key name by Id if NOT NULL
SET @TCountQuery = @TCountQuery + ' LEFT JOIN [dbo].[CUST000Master] (NOLOCK) cust ON ' + @entity + '.[CdcCustomerID]=cust.[Id] '
SET @TCountQuery = @TCountQuery + ' LEFT JOIN [dbo].[CONTC000Master] (NOLOCK) cont ON ' + @entity + '.[CdcContactMSTRID]=cont.[Id] '
SET @TCountQuery = @TCountQuery + ' LEFT JOIN [dbo].[SYSTM000Ref_States] (NOLOCK) sts ON cont.[ConBusinessStateId]=sts.[Id] '
SET @TCountQuery = @TCountQuery + ' LEFT JOIN [dbo].[SYSTM000Ref_Options] (NOLOCK) sysRef ON cont.[ConBusinessCountryId]=sysRef.[Id] '

SET @TCountQuery = @TCountQuery + ' WHERE [CdcCustomerID] = @parentId ' + ISNULL(@where, '')

EXEC sp_executesql @TCountQuery, N'@parentId BIGINT, @userId BIGINT, @TotalCount INT OUTPUT', @parentId, @userId, @TotalCount  OUTPUT;

IF((ISNULL(@groupBy, '') = '') OR (@recordId > 0))
BEGIN

	IF(@recordId = 0)
	BEGIN 
		SET @sqlCommand = 'SELECT ' + [dbo].[fnGetBaseQueryByUserId](@entity, @userId) 
		SET @sqlCommand = @sqlCommand + ' , cust.[CustCode] AS CdcCustomerIDName, cont.[ConFullName] AS CdcContactMSTRIDName '
		SET @sqlCommand = @sqlCommand + ' , cont.[ConJobTitle] AS ConJobTitle, cont.[ConEmailAddress] AS ConEmailAddress '
		SET @sqlCommand = @sqlCommand + ' , cont.[ConMobilePhone] AS ConMobilePhone, cont.[ConBusinessPhone] AS ConBusinessPhone '
		SET @sqlCommand = @sqlCommand + ' , cont.[ConBusinessAddress1] AS ConBusinessAddress1, cont.[ConBusinessAddress2] AS ConBusinessAddress2 '
		SET @sqlCommand = @sqlCommand + ' , cont.[ConBusinessCity] AS ConBusinessCity, cont.[ConBusinessZipPostal] AS ConBusinessZipPostal '
		SET @sqlCommand = @sqlCommand + ' , sts.[StateAbbr] AS ConBusinessStateIdName, sysRef.[SysOptionName] AS ConBusinessCountryIdName '
		SET @sqlCommand = @sqlCommand + ' , ( coalesce(cont.[ConBusinessAddress1], '''') + coalesce(CHAR(13) + cont.[ConBusinessAddress2], '''') + coalesce(CHAR(13) + cont.[ConBusinessCity], '''') + CASE WHEN ((coalesce(cont.[ConBusinessAddress1], '''') <> '''') OR (coalesce(cont.[ConBusinessAddress2], '''') <> '''') OR (coalesce(cont.[ConBusinessCity], '''') <> '''')) THEN coalesce('', '' + sts.[StateAbbr], '''') ELSE coalesce('''' + sts.[StateAbbr], '''') END + coalesce('', '' + cont.[ConBusinessZipPostal], '''') + coalesce(CHAR(13) + sysRef.[SysOptionName], '''') ) AS ConBusinessFullAddress '
	END
ELSE
	BEGIN
		IF((@isNext = 0) AND (@isEnd = 0))
			BEGIN
				 SET @sqlCommand = 'SELECT TOP 1 ISNULL(LAG(' + @entity + '.Id) OVER (ORDER BY ' + ISNULL(@orderBy, @entity + '.Id') + '), 0) AS Id '
			END
		ELSE IF((@isNext = 1) AND (@isEnd = 0))
			BEGIN
				 SET @sqlCommand = 'SELECT TOP 1 ISNULL(LEAD(' + @entity + '.Id) OVER (ORDER BY ' + ISNULL(@orderBy, @entity + '.Id') + '), 0) AS Id ' 
			END
		ELSE
			BEGIN
				SET @sqlCommand = 'SELECT TOP 1 ' + @entity + '.Id '
			END
	END
	
	SET @sqlCommand = @sqlCommand +' FROM [dbo].[CUST040DCLocations] (NOLOCK) '+ @entity
	
	--Below to get BIGINT reference key name by Id if NOT NULL
	SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[CUST000Master] (NOLOCK) cust ON ' + @entity + '.[CdcCustomerID]=cust.[Id] '
		SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[CONTC010Bridge] (NOLOCK) CB ON CB.[ConPrimaryRecordId]=CustDcLocation.[Id] AND CB.ConTableName = ''CustDcLocation'''
      SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[CONTC000Master] (NOLOCK) cont ON CB.ContactMSTRID=cont.[Id] ' 
    SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[SYSTM000Ref_States] (NOLOCK) sts ON cont.[ConBusinessStateId]=sts.[Id] '
    SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[SYSTM000Ref_Options] (NOLOCK) sysRef ON cont.[ConBusinessCountryId]=sysRef.[Id] '



	--Below for getting user specific 'Statuses'
	SET @sqlCommand = @sqlCommand + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) hfk ON ISNULL(' + @entity + '.[StatusId], 1) = hfk.[StatusId] '
	
	--Below to update order by clause if related to Ref_Options
	IF(ISNULL(@orderBy, '') <> '')
	BEGIN
		DECLARE @orderByJoinClause NVARCHAR(500);
		SELECT @orderBy = OrderClause, @orderByJoinClause=JoinClause FROM [dbo].[fnUpdateOrderByClause](@entity, @orderBy);
		IF(ISNULL(@orderByJoinClause, '') <> '')
		BEGIN
			SET @sqlCommand = @sqlCommand + @orderByJoinClause
		END
	END

	--Special case: Updating GroupByWhere if having ConBusinessFullAddress in this condition.
	SET @groupByWhere = REPLACE(@groupByWhere, @entity+'.ConBusinessFullAddress', '( coalesce(cont.[ConBusinessAddress1], '''') + coalesce(CHAR(13) + cont.[ConBusinessAddress2], '''') + coalesce(CHAR(13) + cont.[ConBusinessCity], '''') + CASE WHEN ((coalesce(cont.[ConBusinessAddress1], '''') <> '''') OR (coalesce(cont.[ConBusinessAddress2], '''') <> '''') OR (coalesce(cont.[ConBusinessCity], '''') <> '''')) THEN coalesce('', '' + sts.[StateAbbr], '''') ELSE coalesce('''' + sts.[StateAbbr], '''') END + coalesce('', '' + cont.[ConBusinessZipPostal], '''') + coalesce(CHAR(13) + sysRef.[SysOptionName], '''') )')

	SET @sqlCommand = @sqlCommand + ' WHERE 1=1 AND '+@entity+'.[CdcCustomerID]=@parentId ' + ISNULL(@groupByWhere, '')  
	
	IF((@recordId > 0) AND (((@isNext = 0) AND (@isEnd = 0)) OR ((@isNext = 1) AND (@isEnd = 0))))
	BEGIN
		IF((@isNext = 0) AND (@isEnd = 0))  
   BEGIN  
	IF(ISNULL(@orderBy, '') <> '')
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' <= (SELECT ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' FROM [dbo].[CUST040DCLocations] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
	 END
	ELSE
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND '+@entity+'.Id <= '+ CAST(@recordId AS NVARCHAR(50))  
	 END
   END  
  ELSE IF((@isNext = 1) AND (@isEnd = 0))  
   BEGIN  
    IF(ISNULL(@orderBy, '') <> '')
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' >= (SELECT ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' FROM [dbo].[CUST040DCLocations] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
	 END
	ELSE
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND '+@entity+'.Id >= '+ CAST(@recordId AS NVARCHAR(50))  
	 END
   END   
	END
	
	SET @sqlCommand = @sqlCommand + ISNULL(@where, '') + ' ORDER BY '+ ISNULL(@orderBy, @entity+'.Id') 
	
	IF(@recordId = 0)
	BEGIN
			IF(ISNULL(@groupByWhere, '') <> '')
			   BEGIN
				  SET @sqlCommand = @sqlCommand + ' OFFSET @pageNo ROWS FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);'      
			   END
			ELSE
			   BEGIN
				  SET @sqlCommand = @sqlCommand + ' OFFSET @pageSize * (@pageNo - 1) ROWS FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);'      
			   END     
		END
ELSE
	BEGIN
		IF(@orderBy IS NULL)
			BEGIN
				IF(((@isNext = 1) AND (@isEnd = 1)) OR ((@isNext = 0) AND (@isEnd = 0)))
					BEGIN
						SET @sqlCommand = @sqlCommand + ' DESC' 
					END
			END
		ELSE
			BEGIN
				IF(((@isNext = 1) AND (@isEnd = 1)) OR ((@isNext = 0) AND (@isEnd = 0)))
					BEGIN
						SET @sqlCommand = @sqlCommand + ' DESC' 
					END
			END
	END

END
ELSE
BEGIN
	
	DECLARE @SelectClauseToAdd NVARCHAR(500) = '';

	IF(@groupBy = (@entity + '.CdcCustomerIDName'))
	 BEGIN
		SET @groupBy = ' cust.[CustCode] ';
		SET @SelectClauseToAdd = @SelectClauseToAdd + ' , cust.[CustCode] AS CdcCustomerIDName ';
	 END
	ELSE IF(@groupBy = (@entity + '.CdcContactMSTRIDName'))
	 BEGIN
		SET @groupBy = ' cont.[ConFullName] ';
		SET @SelectClauseToAdd = @SelectClauseToAdd + ' , cont.[ConFullName] AS CdcContactMSTRIDName ';
	 END
	 ELSE IF(@groupBy = (@entity + '.ConJobTitle'))
	 BEGIN
		SET @SelectClauseToAdd = @SelectClauseToAdd + ' , cont.[ConJobTitle] AS ConJobTitle '
	 END
	ELSE IF(@groupBy = (@entity + '.ConEmailAddress'))
	 BEGIN
		SET @SelectClauseToAdd = @SelectClauseToAdd + ' , cont.[ConEmailAddress] AS ConEmailAddress '
	 END
	 ELSE IF(@groupBy = (@entity + '.ConMobilePhone'))
	 BEGIN
		SET @SelectClauseToAdd = @SelectClauseToAdd + ' , cont.[ConMobilePhone] AS ConMobilePhone '
	 END
	ELSE IF(@groupBy = (@entity + '.ConBusinessPhone'))
	 BEGIN
		SET @SelectClauseToAdd = @SelectClauseToAdd + ' , cont.[ConBusinessPhone] AS ConBusinessPhone '
	 END
	ELSE IF(@groupBy = (@entity + '.ConBusinessAddress1'))
	 BEGIN
		SET @SelectClauseToAdd = @SelectClauseToAdd + ' , cont.[ConBusinessAddress1] AS ConBusinessAddress1 '
	 END
	ELSE IF(@groupBy = (@entity + '.ConBusinessAddress2'))
	 BEGIN
		SET @SelectClauseToAdd = @SelectClauseToAdd + ' , cont.[ConBusinessAddress2] AS ConBusinessAddress2 '
	 END
	ELSE IF(@groupBy = (@entity + '.ConBusinessCity'))
	 BEGIN
		SET @SelectClauseToAdd = @SelectClauseToAdd + ' , cont.[ConBusinessCity] AS ConBusinessCity '
	 END
	ELSE IF(@groupBy = (@entity + '.ConBusinessZipPostal'))
	 BEGIN
		SET @SelectClauseToAdd = @SelectClauseToAdd + ' , cont.[ConBusinessZipPostal] AS ConBusinessZipPostal '
	 END
	ELSE IF(@groupBy = (@entity + '.ConBusinessStateIdName'))
	 BEGIN
		SET @groupBy = ' sts.[StateAbbr] ';
		SET @SelectClauseToAdd = @SelectClauseToAdd + ' , sts.[StateAbbr] AS ConBusinessStateIdName '
	 END
	ELSE IF(@groupBy = (@entity + '.ConBusinessCountryIdName'))
	 BEGIN
		SET @groupBy = ' sysRef.[SysOptionName] ';
		SET @SelectClauseToAdd = @SelectClauseToAdd + ' , sysRef.[SysOptionName] AS ConBusinessCountryIdName '
	 END
	ELSE IF(@groupBy = (@entity + '.ConBusinessFullAddress'))
	 BEGIN
		SET @groupBy = ' ( coalesce(cont.[ConBusinessAddress1], '''') + coalesce(CHAR(13) + cont.[ConBusinessAddress2], '''') + coalesce(CHAR(13) + cont.[ConBusinessCity], '''') + CASE WHEN ((coalesce(cont.[ConBusinessAddress1], '''') <> '''') OR (coalesce(cont.[ConBusinessAddress2], '''') <> '''') OR (coalesce(cont.[ConBusinessCity], '''') <> '''')) THEN coalesce('', '' + sts.[StateAbbr], '''') ELSE coalesce('''' + sts.[StateAbbr], '''') END + coalesce('', '' + cont.[ConBusinessZipPostal], '''') + coalesce(CHAR(13) + sysRef.[SysOptionName], '''') ) ';
		SET @SelectClauseToAdd = @SelectClauseToAdd + ' , ( coalesce(cont.[ConBusinessAddress1], '''') + coalesce(CHAR(13) + cont.[ConBusinessAddress2], '''') + coalesce(CHAR(13) + cont.[ConBusinessCity], '''') + CASE WHEN ((coalesce(cont.[ConBusinessAddress1], '''') <> '''') OR (coalesce(cont.[ConBusinessAddress2], '''') <> '''') OR (coalesce(cont.[ConBusinessCity], '''') <> '''')) THEN coalesce('', '' + sts.[StateAbbr], '''') ELSE coalesce('''' + sts.[StateAbbr], '''') END + coalesce('', '' + cont.[ConBusinessZipPostal], '''') + coalesce(CHAR(13) + sysRef.[SysOptionName], '''') ) AS ConBusinessFullAddress ';
		SET @orderBy = REPLACE(@orderBy, @entity+'.ConBusinessFullAddress', '( coalesce(cont.[ConBusinessAddress1], '''') + coalesce(CHAR(13) + cont.[ConBusinessAddress2], '''') + coalesce(CHAR(13) + cont.[ConBusinessCity], '''') + CASE WHEN ((coalesce(cont.[ConBusinessAddress1], '''') <> '''') OR (coalesce(cont.[ConBusinessAddress2], '''') <> '''') OR (coalesce(cont.[ConBusinessCity], '''') <> '''')) THEN coalesce('', '' + sts.[StateAbbr], '''') ELSE coalesce('''' + sts.[StateAbbr], '''') END + coalesce('', '' + cont.[ConBusinessZipPostal], '''') + coalesce(CHAR(13) + sysRef.[SysOptionName], '''') )');
	 END


	SET @sqlCommand = 'SELECT ' + @groupBy + ' AS KeyValue, Count(' + @entity + '.Id) AS DataCount '
	SET @sqlCommand = @sqlCommand + @SelectClauseToAdd
	SET @sqlCommand = @sqlCommand +' FROM [dbo].[CUST040DCLocations] (NOLOCK) '+ @entity
	SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[CUST000Master] (NOLOCK) cust ON ' + @entity + '.[CdcCustomerID]=cust.[Id] '
	SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[CONTC000Master] (NOLOCK) cont ON ' + @entity + '.[CdcContactMSTRID]=cont.[Id] '
	SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[SYSTM000Ref_States] (NOLOCK) sts ON cont.[ConBusinessStateId]=sts.[Id] '
	SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[SYSTM000Ref_Options] (NOLOCK) sysRef ON cont.[ConBusinessCountryId]=sysRef.[Id] '
	
	--Below for getting user specific 'Statuses'
	IF((ISNULL(@where, '') = '') OR (@where NOT LIKE '%'+@entity+'.StatusId%'))
		BEGIN
			SET @sqlCommand = @sqlCommand + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) hfk ON ISNULL(' + @entity + '.[StatusId], 1) = hfk.[StatusId] '
		END
	
	--Special case: Updating GroupByWhere if having ConBusinessFullAddress in this condition.
	SET @groupByWhere = REPLACE(@groupByWhere, @entity+'.ConBusinessFullAddress', '( coalesce(cont.[ConBusinessAddress1], '''') + coalesce(CHAR(13) + cont.[ConBusinessAddress2], '''') + coalesce(CHAR(13) + cont.[ConBusinessCity], '''') + coalesce('', '' + sts.[StateAbbr], '''') + coalesce('', '' + cont.[ConBusinessZipPostal], '''') + coalesce(CHAR(13) + sysRef.[SysOptionName], '''') )')
	
	SET @sqlCommand = @sqlCommand + ' WHERE 1=1 AND '+@entity+'.[CdcCustomerID]=@parentId ' + ISNULL(@groupByWhere, '')  
	SET @sqlCommand = @sqlCommand + ' GROUP BY ' + @groupBy 
	IF(ISNULL(@orderBy, '') <> '')
	 BEGIN
	 	SET @sqlCommand = @sqlCommand + ' ORDER BY '+ @orderBy
	 END

END

	--To replace EntityName from custom column names
	 SET @sqlCommand = REPLACE(@sqlCommand, @entity+'.CdcCustomerIDName', 'cust.[CustCode]')
	 SET @sqlCommand = REPLACE(@sqlCommand, @entity+'.CdcContactMSTRIDName', 'cont.[ConFullName]')
	 SET @sqlCommand = REPLACE(@sqlCommand, @entity+'.CdcContactMSTRID', 'cont.[Id] AS CdcContactMSTRID')
	 SET @sqlCommand = REPLACE(@sqlCommand, @entity+'.ConJobTitle', 'ConJobTitle')
	 SET @sqlCommand = REPLACE(@sqlCommand, @entity+'.ConEmailAddress', 'ConEmailAddress')
	 SET @sqlCommand = REPLACE(@sqlCommand, @entity+'.ConMobilePhone', 'ConMobilePhone')
	 SET @sqlCommand = REPLACE(@sqlCommand, @entity+'.ConBusinessPhone', 'ConBusinessPhone')
	 SET @sqlCommand = REPLACE(@sqlCommand, @entity+'.ConBusinessAddress1', 'ConBusinessAddress1')
	 SET @sqlCommand = REPLACE(@sqlCommand, @entity+'.ConBusinessAddress2', 'ConBusinessAddress2')
	 SET @sqlCommand = REPLACE(@sqlCommand, @entity+'.ConBusinessCity', 'ConBusinessCity')
	 SET @sqlCommand = REPLACE(@sqlCommand, @entity+'.ConBusinessZipPostal', 'ConBusinessZipPostal')
	 SET @sqlCommand = REPLACE(@sqlCommand, @entity+'.ConBusinessStateIdName', 'sts.[StateAbbr]')
	 SET @sqlCommand = REPLACE(@sqlCommand, @entity+'.ConBusinessCountryIdName', 'sysRef.[SysOptionName]')
	 SET @sqlCommand = REPLACE(@sqlCommand, @entity+'.ConBusinessFullAddress', 'ConBusinessFullAddress')

EXEC sp_executesql @sqlCommand, N'@pageNo INT, @pageSize INT, @orderBy NVARCHAR(500), @where NVARCHAR(MAX), @entity NVARCHAR(100), @parentId BIGINT,@userId BIGINT' ,
	 @entity= @entity,
     @pageNo= @pageNo, 
     @pageSize= @pageSize,
     @orderBy = @orderBy,
     @where = @where,
	 @parentId = @parentId,
	 @userId = @userId
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
PRINT N'Altering [dbo].[GetVendDCLocation]...';


GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               08/16/2018      
-- Description:               Get a vend dc Loc
-- Execution:                 EXEC [dbo].[GetVendDCLocation]
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)   
-- Modified Desc:  
-- =============================================
ALTER PROCEDURE  [dbo].[GetVendDCLocation]
    @userId BIGINT,
    @roleId BIGINT,
	@orgId BIGINT,
    @id BIGINT
AS
BEGIN TRY                
 SET NOCOUNT ON;   
SELECT vend.[Id]
      ,vend.[VdcVendorID]
      ,vend.[VdcItemNumber]
      ,vend.[VdcLocationCode]
	    ,ISNULL(vend.[VdcCustomerCode],vend.[VdcLocationCode]) AS VdcCustomerCode
      ,vend.[VdcLocationTitle]
      ,cb.[ContactMSTRID] as  VdcContactMSTRID
      ,vend.[StatusId]
      ,vend.[EnteredBy]
      ,vend.[DateEntered]
      ,vend.[ChangedBy]
      ,vend.[DateChanged]
	  ,COMP.Id CompanyId
  FROM [dbo].[VEND040DCLocations] vend
  INNER JOIN dbo.COMP000Master COMP ON COMP.CompPrimaryRecordId = vend.VdcVendorID AND COMP.CompTableName = 'Vendor'  INNER JOIN [CONTC010Bridge] CB ON cb.ConPrimaryRecordId = vend.Id  AND  cb.ConTableName='VendDcLocation'
 WHERE vend.[Id]=@id
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
PRINT N'Altering [dbo].[UpdVendDCLocation]...';


GO

/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan    
-- Create date:               08/16/2018      
-- Description:               Upd a vend dc loc
-- Execution:                 EXEC [dbo].[UpdVendDCLocation]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- Modified on:				  2nd May 2019
-- Modified Desc:			  Implemented contact bridge related item by Parthiban M    
-- Modified on:				  10th Jun 2019 (Parthiban) 
-- Modified Desc:			  Remove '#M4PL' while updating
-- ============================================= 
ALTER PROCEDURE  [dbo].[UpdVendDCLocation]		  
	@userId BIGINT
	,@roleId BIGINT  
	,@entity NVARCHAR(100)
	,@conOrgId BIGINT
	,@id BIGINT
	,@vdcVendorId BIGINT = NULL
	,@vdcItemNumber INT  = NULL
	,@vdcLocationCode NVARCHAR(20)  = NULL
	,@vdcCustomerCode NVARCHAR(20) = NULL 
	,@vdcLocationTitle NVARCHAR(50)  = NULL
	,@vdcContactMSTRId BIGINT  = NULL
	,@statusId INT  = NULL
	,@changedBy NVARCHAR(50)  = NULL
	,@dateChanged DATETIME2(7)   = NULL
	,@isFormView BIT = 0
AS
BEGIN TRY                
 SET NOCOUNT ON; 
  DECLARE @updatedItemNumber INT, @oldLocationCode NVARCHAR(20) = null, @newLocationCode NVARCHAR(20) = null, @newVdcLocationTitle NVARCHAR(50) = null, @newVdcContactMSTRId BIGINT = NULL;      
 EXEC [dbo].[ResetItemNumber] @userId, @id, @vdcVendorId, @entity, @vdcItemNumber, @statusId, NULL, NULL,  @updatedItemNumber OUTPUT
   
   SELECT @oldLocationCode = VdcLocationCode FROM [dbo].[VEND040DCLocations] WHERE Id = @id;

   UPDATE [dbo].[VEND040DCLocations]
    SET     VdcVendorId 		= ISNULL(@vdcVendorId, VdcVendorId)
           ,VdcItemNumber 		= ISNULL(@updatedItemNumber, VdcItemNumber)
           ,VdcLocationCode 	= ISNULL(@vdcLocationCode, VdcLocationCode) 
		   ,VdcCustomerCode 	= ISNULL(@vdcCustomerCode,VdcCustomerCode) 
           ,VdcLocationTitle 	= @vdcLocationTitle
           ,StatusId 			= ISNULL(@statusId, StatusId)
           ,ChangedBy 			= @changedBy 
           ,DateChanged   		= @dateChanged 
      WHERE Id = @id 	
	If NOT EXISTS (Select 1 from [CONTC010Bridge]  where ConPrimaryRecordId = @id AND ContactMSTRID =  @vdcContactMSTRId  And  ConTableName = 'VendDcLocation' And ConOrgId = @conOrgId)	  
	Begin
	 UPDATE [CONTC010Bridge] set [ContactMSTRID] = @vdcCustomerCode where  ConPrimaryRecordId = @id   And  ConTableName = 'VendDcLocation' And ConOrgId = @conOrgId

	END
		    



	SELECT @newLocationCode = vdc.VdcLocationCode, @newVdcLocationTitle=vdc.VdcLocationTitle, @newVdcContactMSTRId = cb.ContactMSTRID FROM [dbo].[VEND040DCLocations] vdc INNER JOIN [CONTC010Bridge]
	CB ON Cb.ConPrimaryRecordId = vdc.id  WHERE vdc.Id = @id And  Cb.ConTableName = 'VendDcLocation' And Cb.ConOrgId = @conOrgId;
	  
	 
	 /*Below to update Program Vendor Location*/
	 UPDATE [dbo].[PRGRM051VendorLocations] SET 
	 [PvlLocationCode] = @newLocationCode,
	 [PvlLocationTitle] = @newVdcLocationTitle,
	 [PvlContactMSTRID] = @newVdcContactMSTRId
	 WHERE [PvlVendorID] = @vdcVendorId AND [PvlLocationCode] = @oldLocationCode
	  	  
	 EXEC [dbo].[GetVendDCLocation] @userId, @roleId, 1 ,@id 
END TRY    
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
PRINT N'Altering [dbo].[GetVendDCLocationView]...';


GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               09/04/2018      
-- Description:               Get all vendor dc location
-- Execution:                 EXEC [dbo].[GetVendDCLocationView]
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)   
-- Modified Desc:  
-- =============================================
ALTER PROCEDURE [dbo].[GetVendDCLocationView]
 @userId BIGINT,
 @roleId BIGINT,
 @orgId BIGINT,
 @entity NVARCHAR(100),
 @pageNo INT,
 @pageSize INT,
 @orderBy NVARCHAR(500),
 @groupBy NVARCHAR(500), 
 @groupByWhere NVARCHAR(500), 
 @where NVARCHAR(MAX),
 @parentId BIGINT,
 @isNext BIT,
 @isEnd BIT,
 @recordId BIGINT,
 @TotalCount INT OUTPUT
AS
BEGIN TRY                
 SET NOCOUNT ON;  
 DECLARE @sqlCommand NVARCHAR(MAX);
 DECLARE @TCountQuery NVARCHAR(MAX);

SET @TCountQuery = 'SELECT @TotalCount = COUNT(' + @entity + '.Id) FROM [dbo].[VEND040DCLocations] (NOLOCK) '+ @entity 

--Below for getting user specific 'Statuses'
SET @TCountQuery = @TCountQuery + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) fgus ON ' + @entity + '.[StatusId] = fgus.[StatusId] '
--Below to get BIGINT reference key name by Id if NOT NULL
SET @TCountQuery = @TCountQuery + ' LEFT JOIN [dbo].[VEND000Master] (NOLOCK) vend ON ' + @entity + '.[VdcVendorID]=vend.[Id] '
SET @TCountQuery = @TCountQuery + ' LEFT JOIN [dbo].[CONTC000Master] (NOLOCK) cont ON ' + @entity + '.[VdcContactMSTRID]=cont.[Id] '
SET @TCountQuery = @TCountQuery + ' LEFT JOIN [dbo].[SYSTM000Ref_States] (NOLOCK) sts ON cont.[ConBusinessStateId]=sts.[Id] '
SET @TCountQuery = @TCountQuery + ' LEFT JOIN [dbo].[SYSTM000Ref_Options] (NOLOCK) sysRef ON cont.[ConBusinessCountryId]=sysRef.[Id] '

SET @TCountQuery = @TCountQuery + ' WHERE [VdcVendorID] = @parentId ' + ISNULL(@where, '')
EXEC sp_executesql @TCountQuery, N'@parentId BIGINT, @userId BIGINT, @TotalCount INT OUTPUT', @parentId, @userId, @TotalCount  OUTPUT;

IF((ISNULL(@groupBy, '') = '') OR (@recordId > 0))
BEGIN

IF(@recordId = 0)
	BEGIN
		SET @sqlCommand = 'SELECT ' + [dbo].[fnGetBaseQueryByUserId](@entity, @userId) 
		SET @sqlCommand = @sqlCommand + ' , vend.[VendCode] AS VdcVendorIDName, cont.[ConFullName] AS VdcContactMSTRIDName '
		SET @sqlCommand = @sqlCommand + ' , cont.[ConJobTitle] AS ConJobTitle, cont.[ConEmailAddress] AS ConEmailAddress '
		SET @sqlCommand = @sqlCommand + ' , cont.[ConCompanyId] AS ConCompanyId '
		SET @sqlCommand = @sqlCommand + ' , cont.[ConMobilePhone] AS ConMobilePhone, cont.[ConBusinessPhone] AS ConBusinessPhone '
		SET @sqlCommand = @sqlCommand + ' , cont.[ConBusinessAddress1] AS ConBusinessAddress1, cont.[ConBusinessAddress2] AS ConBusinessAddress2 '
		SET @sqlCommand = @sqlCommand + ' , cont.[ConBusinessCity] AS ConBusinessCity, cont.[ConBusinessZipPostal] AS ConBusinessZipPostal '
		SET @sqlCommand = @sqlCommand + ' , sts.[StateAbbr] AS ConBusinessStateIdName, sysRef.[SysOptionName] AS ConBusinessCountryIdName '
		SET @sqlCommand = @sqlCommand + ' , ( coalesce(cont.[ConBusinessAddress1], '''') + coalesce(CHAR(13) + cont.[ConBusinessAddress2], '''') + coalesce(CHAR(13) + cont.[ConBusinessCity], '''') + CASE WHEN ((coalesce(cont.[ConBusinessAddress1], '''') <> '''') OR (coalesce(cont.[ConBusinessAddress2], '''') <> '''') OR (coalesce(cont.[ConBusinessCity], '''') <> '''')) THEN coalesce('', '' + sts.[StateAbbr], '''') ELSE coalesce('''' + sts.[StateAbbr], '''') END + coalesce('', '' + cont.[ConBusinessZipPostal], '''') + coalesce(CHAR(13) + sysRef.[SysOptionName], '''') ) AS ConBusinessFullAddress '
	END
ELSE
	BEGIN
		IF((@isNext = 0) AND (@isEnd = 0))
			BEGIN
				 SET @sqlCommand = 'SELECT TOP 1 ISNULL(LAG(' + @entity + '.Id) OVER (ORDER BY ' + ISNULL(@orderBy, @entity + '.Id') + '), 0) AS Id '
			END
		ELSE IF((@isNext = 1) AND (@isEnd = 0))
			BEGIN
				 SET @sqlCommand = 'SELECT TOP 1 ISNULL(LEAD(' + @entity + '.Id) OVER (ORDER BY ' + ISNULL(@orderBy, @entity + '.Id') + '), 0) AS Id ' 
			END
		ELSE
			BEGIN
				SET @sqlCommand = 'SELECT TOP 1 ' + @entity + '.Id '
			END
	END

SET @sqlCommand = @sqlCommand + ' FROM [dbo].[VEND040DCLocations] (NOLOCK) '+ @entity

--Below to get BIGINT reference key name by Id if NOT NULL
SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[VEND000Master] (NOLOCK) vend ON ' + @entity + '.[VdcVendorID]=vend.[Id] '
SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[CONTC010Bridge] (NOLOCK) CB ON CB.[ConPrimaryRecordId]=VendDcLocation.[Id] AND CB.ConTableName = ''VendDcLocation'''
SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[CONTC000Master] (NOLOCK) cont ON CB.ContactMSTRID=cont.[Id] ' 
SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[SYSTM000Ref_States] (NOLOCK) sts ON cont.[ConBusinessStateId]=sts.[Id] '
SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[SYSTM000Ref_Options] (NOLOCK) sysRef ON cont.[ConBusinessCountryId]=sysRef.[Id] '


--Below for getting user specific 'Statuses'
SET @sqlCommand = @sqlCommand + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) hfk ON ISNULL(' + @entity + '.[StatusId], 1) = hfk.[StatusId] '

--Below to update order by clause if related to Ref_Options
	IF(ISNULL(@orderBy, '') <> '')
	BEGIN
		DECLARE @orderByJoinClause NVARCHAR(500);
		SELECT @orderBy = OrderClause, @orderByJoinClause=JoinClause FROM [dbo].[fnUpdateOrderByClause](@entity, @orderBy);
		IF(ISNULL(@orderByJoinClause, '') <> '')
		BEGIN
			SET @sqlCommand = @sqlCommand + @orderByJoinClause
		END
	END

--Special case: Updating GroupByWhere if having ConBusinessFullAddress in this condition.
SET @groupByWhere = REPLACE(@groupByWhere, @entity+'.ConBusinessFullAddress', '( coalesce(cont.[ConBusinessAddress1], '''') + coalesce(CHAR(13) + cont.[ConBusinessAddress2], '''') + coalesce(CHAR(13) + cont.[ConBusinessCity], '''') + CASE WHEN ((coalesce(cont.[ConBusinessAddress1], '''') <> '''') OR (coalesce(cont.[ConBusinessAddress2], '''') <> '''') OR (coalesce(cont.[ConBusinessCity], '''') <> '''')) THEN coalesce('', '' + sts.[StateAbbr], '''') ELSE coalesce('''' + sts.[StateAbbr], '''') END + coalesce('', '' + cont.[ConBusinessZipPostal], '''') + coalesce(CHAR(13) + sysRef.[SysOptionName], '''') )')


SET @sqlCommand = @sqlCommand + ' WHERE 1=1 AND '+ @entity + '.[VdcVendorID]=@parentId '+ ISNULL(@where, '') + ISNULL(@groupByWhere, '')  

IF((@recordId > 0) AND (((@isNext = 0) AND (@isEnd = 0)) OR ((@isNext = 1) AND (@isEnd = 0))))
	BEGIN
		IF((@isNext = 0) AND (@isEnd = 0))  
   BEGIN  
	IF(ISNULL(@orderBy, '') <> '')
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' <= (SELECT ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' FROM [dbo].[VEND040DCLocations] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
	 END
	ELSE
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND '+@entity+'.Id <= '+ CAST(@recordId AS NVARCHAR(50))  
	 END
   END  
  ELSE IF((@isNext = 1) AND (@isEnd = 0))  
   BEGIN  
    IF(ISNULL(@orderBy, '') <> '')
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' >= (SELECT ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' FROM [dbo].[VEND040DCLocations] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
	 END
	ELSE
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND '+@entity+'.Id >= '+ CAST(@recordId AS NVARCHAR(50))  
	 END
   END   
	END

SET @sqlCommand = @sqlCommand + ' ORDER BY '+ ISNULL(@orderBy, @entity+'.Id')

IF(@recordId = 0)
	BEGIN
		IF(ISNULL(@groupByWhere, '') <> '')
			BEGIN
				  SET @sqlCommand = @sqlCommand + ' OFFSET @pageNo ROWS FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);'      
			   END
			ELSE
			   BEGIN
				  SET @sqlCommand = @sqlCommand + ' OFFSET @pageSize * (@pageNo - 1) ROWS FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);'      
			   END       
	END
ELSE
	BEGIN
		IF(@orderBy IS NULL)
			BEGIN
				IF(((@isNext = 1) AND (@isEnd = 1)) OR ((@isNext = 0) AND (@isEnd = 0)))
					BEGIN
						SET @sqlCommand = @sqlCommand + ' DESC' 
					END
			END
		ELSE
			BEGIN
				IF(((@isNext = 1) AND (@isEnd = 1)) OR ((@isNext = 0) AND (@isEnd = 0)))
					BEGIN
						SET @sqlCommand = @sqlCommand + ' DESC' 
					END
			END
	END

END
ELSE
BEGIN
	
	DECLARE @SelectClauseToAdd NVARCHAR(500) = '';

	IF(@groupBy = (@entity + '.VdcVendorIDName'))
	 BEGIN
		SET @groupBy = ' vend.[VendCode] ';
		SET @SelectClauseToAdd = @SelectClauseToAdd + ' , vend.[VendCode] AS VdcVendorIDName ';
	 END
	ELSE IF(@groupBy = (@entity + '.VdcContactMSTRIDName'))
	 BEGIN
		SET @groupBy = ' cont.[ConFullName] ';
		SET @SelectClauseToAdd = @SelectClauseToAdd + ' , cont.[ConFullName] AS VdcContactMSTRIDName ';
	 END
	 ELSE IF(@groupBy = (@entity + '.ConJobTitle'))
	 BEGIN
		SET @SelectClauseToAdd = @SelectClauseToAdd + ' , cont.[ConJobTitle] AS ConJobTitle '
	 END
	ELSE IF(@groupBy = (@entity + '.ConEmailAddress'))
	 BEGIN
		SET @SelectClauseToAdd = @SelectClauseToAdd + ' , cont.[ConEmailAddress] AS ConEmailAddress '
	 END
	 ELSE IF(@groupBy = (@entity + '.ConMobilePhone'))
	 BEGIN
		SET @SelectClauseToAdd = @SelectClauseToAdd + ' , cont.[ConMobilePhone] AS ConMobilePhone '
	 END
	ELSE IF(@groupBy = (@entity + '.ConBusinessPhone'))
	 BEGIN
		SET @SelectClauseToAdd = @SelectClauseToAdd + ' , cont.[ConBusinessPhone] AS ConBusinessPhone '
	 END
	ELSE IF(@groupBy = (@entity + '.ConBusinessAddress1'))
	 BEGIN
		SET @SelectClauseToAdd = @SelectClauseToAdd + ' , cont.[ConBusinessAddress1] AS ConBusinessAddress1 '
	 END
	ELSE IF(@groupBy = (@entity + '.ConBusinessAddress2'))
	 BEGIN
		SET @SelectClauseToAdd = @SelectClauseToAdd + ' , cont.[ConBusinessAddress2] AS ConBusinessAddress2 '
	 END
	ELSE IF(@groupBy = (@entity + '.ConBusinessCity'))
	 BEGIN
		SET @SelectClauseToAdd = @SelectClauseToAdd + ' , cont.[ConBusinessCity] AS ConBusinessCity '
	 END
	ELSE IF(@groupBy = (@entity + '.ConBusinessZipPostal'))
	 BEGIN
		SET @SelectClauseToAdd = @SelectClauseToAdd + ' , cont.[ConBusinessZipPostal] AS ConBusinessZipPostal '
	 END
	ELSE IF(@groupBy = (@entity + '.ConBusinessStateIdName'))
	 BEGIN
		SET @groupBy = ' sts.[StateAbbr] ';
		SET @SelectClauseToAdd = @SelectClauseToAdd + ' , sts.[StateAbbr] AS ConBusinessStateIdName '
	 END
	ELSE IF(@groupBy = (@entity + '.ConBusinessCountryIdName'))
	 BEGIN
		SET @groupBy = ' sysRef.[SysOptionName] ';
		SET @SelectClauseToAdd = @SelectClauseToAdd + ' , sysRef.[SysOptionName] AS ConBusinessCountryIdName '
	 END
	ELSE IF(@groupBy = (@entity + '.ConBusinessFullAddress'))
	 BEGIN
		SET @groupBy = ' ( coalesce(cont.[ConBusinessAddress1], '''') + coalesce(CHAR(13) + cont.[ConBusinessAddress2], '''') + coalesce(CHAR(13) + cont.[ConBusinessCity], '''') + CASE WHEN ((coalesce(cont.[ConBusinessAddress1], '''') <> '''') OR (coalesce(cont.[ConBusinessAddress2], '''') <> '''') OR (coalesce(cont.[ConBusinessCity], '''') <> '''')) THEN coalesce('', '' + sts.[StateAbbr], '''') ELSE coalesce('''' + sts.[StateAbbr], '''') END + coalesce('', '' + cont.[ConBusinessZipPostal], '''') + coalesce(CHAR(13) + sysRef.[SysOptionName], '''') ) ';
		SET @SelectClauseToAdd = @SelectClauseToAdd + ' , ( coalesce(cont.[ConBusinessAddress1], '''') + coalesce(CHAR(13) + cont.[ConBusinessAddress2], '''') + coalesce(CHAR(13) + cont.[ConBusinessCity], '''') + CASE WHEN ((coalesce(cont.[ConBusinessAddress1], '''') <> '''') OR (coalesce(cont.[ConBusinessAddress2], '''') <> '''') OR (coalesce(cont.[ConBusinessCity], '''') <> '''')) THEN coalesce('', '' + sts.[StateAbbr], '''') ELSE coalesce('''' + sts.[StateAbbr], '''') END + coalesce('', '' + cont.[ConBusinessZipPostal], '''') + coalesce(CHAR(13) + sysRef.[SysOptionName], '''') ) AS ConBusinessFullAddress ';
		SET @orderBy = REPLACE(@orderBy, @entity+'.ConBusinessFullAddress', '( coalesce(cont.[ConBusinessAddress1], '''') + coalesce(CHAR(13) + cont.[ConBusinessAddress2], '''') + coalesce(CHAR(13) + cont.[ConBusinessCity], '''') + CASE WHEN ((coalesce(cont.[ConBusinessAddress1], '''') <> '''') OR (coalesce(cont.[ConBusinessAddress2], '''') <> '''') OR (coalesce(cont.[ConBusinessCity], '''') <> '''')) THEN coalesce('', '' + sts.[StateAbbr], '''') ELSE coalesce('''' + sts.[StateAbbr], '''') END + coalesce('', '' + cont.[ConBusinessZipPostal], '''') + coalesce(CHAR(13) + sysRef.[SysOptionName], '''') )');
	 END


	SET @sqlCommand = 'SELECT ' + @groupBy + ' AS KeyValue, Count(' + @entity + '.Id) AS DataCount '
	SET @sqlCommand = @sqlCommand + @SelectClauseToAdd
	SET @sqlCommand = @sqlCommand +' FROM [dbo].[VEND040DCLocations] (NOLOCK) '+ @entity
	SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[VEND000Master] (NOLOCK) vend ON ' + @entity + '.[VdcVendorID]=vend.[Id] '
	SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[CONTC000Master] (NOLOCK) cont ON ' + @entity + '.[VdcContactMSTRID]=cont.[Id] '
	SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[SYSTM000Ref_States] (NOLOCK) sts ON cont.[ConBusinessStateId]=sts.[Id] '
	SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[SYSTM000Ref_Options] (NOLOCK) sysRef ON cont.[ConBusinessCountryId]=sysRef.[Id] '
	
	--Below for getting user specific 'Statuses'
	IF((ISNULL(@where, '') = '') OR (@where NOT LIKE '%'+@entity+'.StatusId%'))
		BEGIN
			SET @sqlCommand = @sqlCommand + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) hfk ON ISNULL(' + @entity + '.[StatusId], 1) = hfk.[StatusId] '
		END
	
	--Special case: Updating GroupByWhere if having ConBusinessFullAddress in this condition.
	SET @groupByWhere = REPLACE(@groupByWhere, @entity+'.ConBusinessFullAddress', '( coalesce(cont.[ConBusinessAddress1], '''') + coalesce(CHAR(13) + cont.[ConBusinessAddress2], '''') + coalesce(CHAR(13) + cont.[ConBusinessCity], '''') + coalesce('', '' + sts.[StateAbbr], '''') + coalesce('', '' + cont.[ConBusinessZipPostal], '''') + coalesce(CHAR(13) + sysRef.[SysOptionName], '''') )')
	
	SET @sqlCommand = @sqlCommand + ' WHERE 1=1 AND '+@entity+'.[VdcVendorID]=@parentId ' + ISNULL(@groupByWhere, '')  
	SET @sqlCommand = @sqlCommand + ' GROUP BY ' + @groupBy 
	IF(ISNULL(@orderBy, '') <> '')
	 BEGIN
	 	SET @sqlCommand = @sqlCommand + ' ORDER BY '+ @orderBy
	 END

END

	--To replace EntityName from custom column names
	 SET @sqlCommand = REPLACE(@sqlCommand, @entity+'.VdcVendorIDName', 'vend.[VendCode]')
	 SET @sqlCommand = REPLACE(@sqlCommand, @entity+'.VdcContactMSTRIDName', 'cont.[ConFullName]')
	  SET @sqlCommand = REPLACE(@sqlCommand, @entity+'.VdcContactMSTRID', 'cont.[Id] AS VdcContactMSTRID')
	 SET @sqlCommand = REPLACE(@sqlCommand, @entity+'.ConJobTitle', 'ConJobTitle')
	 SET @sqlCommand = REPLACE(@sqlCommand, @entity+'.ConEmailAddress', 'ConEmailAddress')
	 SET @sqlCommand = REPLACE(@sqlCommand, @entity+'.ConMobilePhone', 'ConMobilePhone')
	 SET @sqlCommand = REPLACE(@sqlCommand, @entity+'.ConBusinessPhone', 'ConBusinessPhone')
	 SET @sqlCommand = REPLACE(@sqlCommand, @entity+'.ConBusinessAddress1', 'ConBusinessAddress1')
	 SET @sqlCommand = REPLACE(@sqlCommand, @entity+'.ConBusinessAddress2', 'ConBusinessAddress2')
	 SET @sqlCommand = REPLACE(@sqlCommand, @entity+'.ConBusinessCity', 'ConBusinessCity')
	 SET @sqlCommand = REPLACE(@sqlCommand, @entity+'.ConBusinessZipPostal', 'ConBusinessZipPostal')
	 SET @sqlCommand = REPLACE(@sqlCommand, @entity+'.ConBusinessStateIdName', 'sts.[StateAbbr]')
	 SET @sqlCommand = REPLACE(@sqlCommand, @entity+'.ConBusinessCountryIdName', 'sysRef.[SysOptionName]')
	 SET @sqlCommand = REPLACE(@sqlCommand, @entity+'.ConBusinessFullAddress', 'ConBusinessFullAddress')

EXEC sp_executesql @sqlCommand, N'@pageNo INT, @pageSize INT, @orderBy NVARCHAR(500), @where NVARCHAR(MAX), @entity NVARCHAR(100), @parentId BIGINT,@userId BIGINT' ,
	 @entity= @entity,
     @pageNo= @pageNo, 
     @pageSize= @pageSize,
     @orderBy = @orderBy,
     @where = @where,
	 @parentId = @parentId,
	 @userId = @userId

END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
PRINT N'Altering [dbo].[InsAssignUnassignProgram]...';


GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Janardana         
-- Create date:               12/01/2018      
-- Description:               Map vendor Locations
-- Execution:                 EXEC [dbo].[InsAssignUnassignProgram]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- =============================================  
ALTER PROCEDURE [dbo].[InsAssignUnassignProgram] @userId BIGINT
	,@parentId BIGINT
	,@assign BIT
	,@locationIds VARCHAR(MAX)
	,@vendorIds VARCHAR(MAX) = NULL
	,@enteredBy NVARCHAR(50) = NULL
	,@assignedOn DATETIME2(7) = NULL
AS
BEGIN TRY
	BEGIN TRANSACTION

	DECLARE @success BIT = 0

	IF @assign = 1
	BEGIN
		DECLARE @MaxItemNumber INT

		SELECT @MaxItemNumber = PvlItemNumber
		FROM [dbo].[PRGRM051VendorLocations]
		WHERE PvlProgramID = @parentId
			AND StatusId IN (
				1
				,2
				)

		IF LEN(ISNULL(@locationIds, '')) > 0
		BEGIN
			-- map vendor locations by location Ids            
			INSERT INTO [dbo].[PRGRM051VendorLocations] (
				PvlProgramID
				,PvlVendorID
				,PvlItemNumber
				,PvlLocationCode
				,PvlLocationTitle
				,PvlContactMSTRID
				,StatusId
				,EnteredBy
				,DateEntered
				)
			SELECT @parentId
				,VD.VdcVendorID
				,ISNULL(@MaxItemNumber, 0) + Row_Number() OVER (
					ORDER BY TM.Item
					)
				,VD.VdcLocationCode
				,VD.VdcLocationTitle
				,CB.ContactMSTRID
				,1
				,@enteredBy
				,ISNULL(@assignedOn, GETUTCDATE())
			FROM VEND040DCLocations VD
			INNER JOIN dbo.fnSplitString(@locationIds, ',') TM ON TM.Item = VD.Id
			INNER JOIN CONTC010Bridge CB ON  CB.ConPrimaryRecordId = VD.Id AND cb.ConTableName ='VendDcLocation'

			SET @success = 1
		END

		-- map vendor locations by vendor Ids            
		IF LEN(ISNULL(@vendorIds, '')) > 0
		BEGIN
			SELECT @MaxItemNumber = PvlItemNumber
			FROM [dbo].[PRGRM051VendorLocations]
			WHERE PvlProgramID = @parentId
				AND StatusId IN (
					1
					,2
					)

			DECLARE @conTypeId INT

			SELECT @conTypeId = Id
			FROM [dbo].[SYSTM000Ref_Options]
			WHERE SysLookupCode = 'ContactType'
				AND SysOptionName = 'Vendor'
				AND StatusId = 1

			DECLARE @conTableTypeId INT

			SELECT @conTableTypeId = Id
			FROM [dbo].[SYSTM000Ref_Options]
			WHERE SysLookupCode = 'ContactType'
				AND SysOptionName = 'Consultant'
				AND StatusId = 1

			SELECT VD.Id VendorId
				,VendCode
				,VendTitle
				,1 ConOrgId
				,CASE 
					WHEN ISNULL(VD.VendWorkAddressId, '') <> ''
						AND VD.VendWorkAddressId > 0
						THEN VD.VendWorkAddressId
					WHEN ISNULL(VD.VendCorporateAddressId, '') <> ''
						AND VD.VendCorporateAddressId > 0
						THEN VD.VendCorporateAddressId
					WHEN ISNULL(VD.VendBusinessAddressId, '') <> ''
						AND VD.VendBusinessAddressId > 0
						THEN VD.VendBusinessAddressId
					ELSE NULL
					END ContactMSTRID
				,'VendContact' ConTableName
				,TM.Item ConPrimaryRecordId
				,@conTableTypeId ConTableTypeId
				,@conTypeId ConTypeId
				,1 ConItemNumber
				,NULL ConCodeId
				,'Vendor_default' ConTitle
				,1 StatusId
				,@enteredBy EnteredBy
				,ISNULL(@assignedOn, GETUTCDATE()) DateEntered
			INTO #BridgeTemp
			FROM VEND000Master VD
			INNER JOIN dbo.fnSplitString(@vendorIds, ',') TM ON TM.Item = VD.Id
			WHERE ITEM NOT IN (
					SELECT VdcVendorID
					FROM VEND040DCLocations
					WHERE vdcvendorId IN (
							SELECT Item
							FROM dbo.fnSplitString(@vendorIds, ',')
							)
						AND StatusId = 1
					);

			INSERT INTO [dbo].[PRGRM051VendorLocations] (
				PvlProgramID
				,PvlVendorID
				,PvlItemNumber
				,PvlLocationCode
				,PvlLocationTitle
				,PvlContactMSTRID
				,StatusId
				,EnteredBy
				,DateEntered
				)
			SELECT @parentId
				,VdcVendorID
				,ISNULL(@MaxItemNumber, 0) + Row_Number() OVER (
					ORDER BY VD.Id
					)
				,VdcLocationCode
				,VdcLocationTitle
				,CB.ContactMSTRID
				,1
				,@enteredBy
				,ISNULL(@assignedOn, GETUTCDATE())
			FROM VEND040DCLocations VD
			INNER JOIN CONTC010Bridge CB ON  CB.ConPrimaryRecordId = VD.Id AND CB.ConTableName ='VendDcLocation'
			WHERE VD.VdcVendorID IN (
					SELECT Item
					FROM dbo.fnSplitString(@vendorIds, ',')
					)
				AND VD.StatusId = 1
				AND VD.VdcLocationCode NOT IN (
					SELECT PvlLocationCode
					FROM PRGRM051VendorLocations
					WHERE PvlProgramID = @parentId
						AND StatusId IN (
							1
							,2
							)
						AND PvlVendorID IN (
							SELECT Item
							FROM dbo.fnSplitString(@vendorIds, ',')
							)
					);

			INSERT INTO [dbo].[PRGRM051VendorLocations] (
				PvlProgramID
				,PvlVendorID
				,PvlItemNumber
				,PvlLocationCode
				,PvlLocationTitle
				,PvlContactMSTRID
				,StatusId
				,EnteredBy
				,DateEntered
				)
			SELECT @parentId
				,VendorId
				,ISNULL(@MaxItemNumber, 0) + Row_Number() OVER (
					ORDER BY VendorId
					)
				,VendCode
				,VendTitle
				,ContactMSTRID
				,1
				,@enteredBy
				,ISNULL(@assignedOn, GETUTCDATE())
			FROM #BridgeTemp

			-- Create Vendor Contact end here
			INSERT INTO [dbo].[CONTC010Bridge] (
				[ConOrgId]
				,[ContactMSTRID]
				,[ConTableName]
				,[ConPrimaryRecordId]
				,[ConTableTypeId]
				,[ConTypeId]
				,[ConItemNumber]
				,[ConCodeId]
				,[ConTitle]
				,[StatusId]
				,[EnteredBy]
				,[DateEntered]
				)
			SELECT [ConOrgId]
				,[ContactMSTRID]
				,[ConTableName]
				,[ConPrimaryRecordId]
				,[ConTableTypeId]
				,[ConTypeId]
				,[ConItemNumber]
				,[ConCodeId]
				,[ConTitle]
				,[StatusId]
				,[EnteredBy]
				,[DateEntered]
			FROM #BridgeTemp

			-- Create DC Locations for the vendor When location is not exits        
			INSERT INTO VEND040DCLocations (
				VdcVendorID
				,VdcItemNumber
				,VdcLocationCode
				,VdcCustomerCode
				,VdcLocationTitle
				,StatusId
				,EnteredBy
				,DateEntered
				)
			SELECT VendorId
				,1
				,VendCode
				,VendCode
				,VendTitle
				,1
				,@enteredBy
				,ISNULL(@assignedOn, GETUTCDATE())
			FROM #BridgeTemp
		

		  
    
			INSERT INTO [dbo].[CONTC010Bridge] (
				[ConOrgId]
				,[ContactMSTRID]
				,[ConTableName]
				,[ConPrimaryRecordId]
				,[ConTableTypeId]
				,[ConTypeId]
				,[ConItemNumber]
				,[ConCodeId]
				,[ConTitle]
				,[StatusId]
				,[EnteredBy]
				,[DateEntered]
				)
			 
			SELECT CB.[ConOrgId]
				,CB.[ContactMSTRID]
				,CB.[ConTableName]
				,VDC.Id
				,CB.[ConTableTypeId]
				,CB.[ConTypeId]
				,CB.[ConItemNumber]
				,CB.[ConCodeId]
				,CB.[ConTitle]
				,CB.[StatusId]
				,CB.[EnteredBy]
				,CB.[DateEntered]
			FROM   #BridgeTemp CB Inner Join VEND040DCLocations  VDC ON CB.VendorId = VDC.VdcVendorID
			WHERE CB.VendorId=VDC.VdcVendorID;

			--Update vendor contact count
			UPDATE VM
			SET VM.VendContacts = VM.VendContacts + 1
			FROM VEND000Master VM
			INNER JOIN #BridgeTemp TM ON TM.VendorId = VM.Id

			DROP TABLE #BridgeTemp

			SET @success = 1
		END
	END
	ELSE
	BEGIN
		IF LEN(ISNULL(@locationIds, '')) > 0
		BEGIN
			UPDATE [dbo].[PRGRM051VendorLocations]
			SET StatusId = 3
				,DateChanged = ISNULL(@assignedOn, GETUTCDATE())
				,ChangedBy = @enteredBy
			WHERE Id IN (
					SELECT Item
					FROM dbo.fnSplitString(@LocationIds, ',')
					)
				AND PvlProgramID = @parentId;
		END

		IF LEN(ISNULL(@vendorIds, '')) > 0
		BEGIN
			UPDATE [dbo].[PRGRM051VendorLocations]
			SET StatusId = 3
				,DateChanged = ISNULL(@assignedOn, GETUTCDATE())
				,ChangedBy = @enteredBy
			WHERE Id IN (
					SELECT Id
					FROM PRGRM051VendorLocations
					WHERE PvlVendorID IN (
							SELECT Item
							FROM dbo.fnSplitString(@vendorIds, ',')
							)
						AND StatusId IN (
							1
							,2
							)
					)
				AND PvlProgramID = @parentId;
		END

		--Update Item No after delete           
		CREATE TABLE #temptable (
			Id BIGINT
			,PvlItemNumber INT
			)

		INSERT INTO #temptable (
			Id
			,PvlItemNumber
			)
		SELECT Id
			,ROW_NUMBER() OVER (
				ORDER BY PvlItemNumber
				)
		FROM PRGRM051VendorLocations
		WHERE PvlProgramID = @parentId
			AND StatusId IN (
				1
				,2
				)
		ORDER BY Id

		MERGE INTO PRGRM051VendorLocations c1
		USING #temptable c2
			ON c1.Id = c2.Id
		WHEN MATCHED
			THEN
				UPDATE
				SET c1.PvlItemNumber = c2.PvlItemNumber;

		SET @success = 1
	END

	COMMIT TRANSACTION

	SELECT @success
END TRY

BEGIN CATCH
	ROLLBACK TRANSACTION

	DECLARE @ErrorMessage VARCHAR(MAX) = (
			SELECT ERROR_MESSAGE()
			)
		,@ErrorSeverity VARCHAR(MAX) = (
			SELECT ERROR_SEVERITY()
			)
		,@RelatedTo VARCHAR(100) = (
			SELECT OBJECT_NAME(@@PROCID)
			)

	EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo
		,NULL
		,@ErrorMessage
		,NULL
		,NULL
		,@ErrorSeverity
END CATCH
GO
PRINT N'Update complete.';


GO
