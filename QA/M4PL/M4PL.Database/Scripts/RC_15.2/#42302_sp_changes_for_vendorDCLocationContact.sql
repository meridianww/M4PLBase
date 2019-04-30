
GO
PRINT N'Altering [dbo].[GetColumnAliasesByTableName]...';


GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               04/14/2018      
-- Description:               Get all ColumnAliases By Table Name
-- Execution:                 EXEC [dbo].[GetColumnAliasesByTableName]   
-- Modified on:  
-- Modified Desc:  
-- =============================================     
ALTER PROCEDURE [dbo].[GetColumnAliasesByTableName] 
	@langCode NVARCHAR(10),    
	@tableName NVARCHAR(100)    
AS                    
BEGIN TRY                    
 SET NOCOUNT ON;  

     
  DECLARE @columnAliasTable TABLE(    
  [Id] [bigint],    
 [LangCode] [nvarchar](10),    
 [ColTableName] [nvarchar](100),    
 [ColColumnName] [nvarchar](50),    
 [ColAliasName] [nvarchar](50),    
 [ColCaption] [nvarchar](50),    
 [ColLookupId] int,    
 [ColLookupCode] [nvarchar](100),    
 [ColDescription] [nvarchar](255),    
 [ColSortOrder] [int],    
 [ColIsReadOnly] [bit],    
 [ColIsVisible] [bit],    
 [ColIsDefault] [bit],    
 [ColIsFreezed] [bit],    
 [ColIsGroupBy] [bit],    
 [DataType] [nvarchar](50),    
 [MaxLength] [int],    
 [IsRequired] [bit],    
 [RequiredMessage] [nvarchar](255),    
 [IsUnique] [bit],    
 [UniqueMessage] [nvarchar](255),    
 [HasValidation] [bit],    
 [GridLayout] [nvarchar](max),    
 [RelationalEntity] [nvarchar](100),   
 [DefaultLookup] int,  
 [DefaultLookupName] NVARCHAR(100),  
 [ColDisplayFormat] NVARCHAR(200) ,  
 [GlobalIsVisible]    BIT, 
 [ColAllowNegativeValue] BIT,
 --Added by Sanyogita
 [ColMask] [nvarchar](50)
  )    
  
  DECLARE @associatedTableName NVARCHAR(100)= @tableName;
   IF EXISTS(select 1 from CONTC010Bridge where ConTableName = @tableName) 
  --IF(@tableName = 'OrgPocContact')
	  BEGIN
	    SET @associatedTableName= 'ContactBridge'; -- To get relation entity and type of it as NAME
	  END
      
 INSERT INTO @columnAliasTable SELECT cal.[Id]    
    ,cal.[LangCode]    
    ,cal.ColTableName     
    ,CASE WHEN ISNULL(c.name, '') = ''  THEN  cal.ColColumnName ELSE c.name END as ColColumnName    
    ,CASE WHEN ISNULL(cal.[ColAliasName], '') = ''  THEN  c.name ELSE cal.[ColAliasName] END as ColAliasName    
    ,CASE WHEN ISNULL(cal.[ColCaption], '') = ''  THEN  c.name ELSE cal.[ColCaption] END as ColCaption    
    ,cal.[ColLookupId]    
    ,cal.[ColLookupCode]    
    ,CASE WHEN ISNULL(cal.[ColDescription], '') = ''  THEN  c.name ELSE cal.[ColDescription] END as ColDescription    
    ,cal.[ColSortOrder]    
    ,cal.[ColIsReadOnly]    
    ,cal.[ColIsVisible]    
    ,cal.[ColIsDefault]    
    ,0    
    ,cal.[ColIsGroupBy]    
    ,CASE WHEN cal.ColColumnName IN (SELECT ColumnName FROM dbo.fnGetRefOptionsFK(@associatedTableName)) THEN 'dropdown' WHEN cal.ColColumnName IN (SELECT ColumnName FROM dbo.fnGetModuleFK(@associatedTableName)) THEN 'name' ELSE CASE WHEN ISNULL(t.Name, '') = '' THEN 'nvarchar' ELSE t.Name END END  as 'DataType'    
    ,CASE  WHEN  c.max_length < 2  THEN c.system_type_id  WHEN (c.system_type_id=231) THEN (c.max_length)/2   ELSE CASE WHEN (t.name = 'ntext') THEN (c.max_length * 2729) ELSE CASE WHEN ISNULL(c.max_length, '') = '' THEN '1000' ELSE (c.max_length) END END END as MaxLength  
    ,0    
    ,''    
    ,0    
    ,''    
    ,0    
    ,'' as GridLayout    
    ,fgmk.RelationalEntity  
 ,ref.Id as DefaultLookup  
 ,ref.SysOptionName as DefaultLookupName  
 ,cal.[ColDisplayFormat]  
 ,cal.[ColIsVisible]  as GlobalIsVisible  
 ,cal.[ColAllowNegativeValue]  as ColAllowNegativeValue 
 --Added by Sanyogita
 ,cal.[ColMask] as ColMask  
  FROM [dbo].[SYSTM000ColumnsAlias] (NOLOCK) cal    
  INNER JOIN [dbo].[SYSTM000Ref_Table] (NOLOCK) tbl ON tbl.SysRefName = cal.ColTableName    
  LEFT JOIN  sys.columns c ON  c.name = cal.ColColumnName AND c.object_id = OBJECT_ID(tbl.TblTableName)  
  LEFT JOIN  sys.types t ON c.user_type_id = t.user_type_id    
  LEFT JOIN dbo.fnGetModuleFK(@associatedTableName) fgmk ON cal.ColColumnName = fgmk.ColumnName  
  LEFT JOIN [dbo].[SYSTM000Ref_Options] (NOLOCK) ref ON ref.SysLookupId =  cal.[ColLookupId] AND ref.SysDefault = 1  AND ref.StatusId < 3  
  WHERE cal.[LangCode]= @langCode AND    
  cal.ColTableName = @tableName
  AND ISNULL(cal.StatusId,1) = 1
  ORDER BY cal.ColSortOrder; 
  
 UPDATE cal        
 SET IsRequired = ISNULL(val.[ValRequired],0),    
 RequiredMessage = ISNULL(val.[ValRequiredMessage],'') ,    
 IsUnique = ISNULL(val.[ValUnique], 0),    
 UniqueMessage = ISNULL(val.[ValUniqueMessage],''),    
 HasValidation = 1    
 FROM  @columnAliasTable cal    
 INNER JOIN [dbo].[SYSTM000Validation] (NOLOCK) val ON val.[ValFieldName] = cal.[ColColumnName] AND cal.ColTableName = val.ValTableName    
 WHERE  ISNULL(val.[StatusId],1) =1  
 --update DisplayFormat from SysSettings  
  
 UPDATE cal  
 SET [ColDisplayFormat] = (select value FROM [dbo].[fnGetUserSettings] (0, 0 , 'System', 'SysDateFormat'))  
 FROM  @columnAliasTable cal  WHERE cal.DataType='datetime2' AND cal.[ColDisplayFormat] IS NULL  
  
    
 SELECT * FROM @columnAliasTable    ORDER BY ColSortOrder    
END TRY                    
BEGIN CATCH                    
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                    
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                    
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                    
     
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                    
END CATCH
GO
PRINT N'Altering [dbo].[GetOrgPocContactView]...';


GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               09/04/2018      
-- Description:               Get all organization poc contact  
-- Execution:                 EXEC [dbo].[GetOrgPocContactView]
-- Modified on:				  04/15/2019(Nikhil)   
-- Modified Desc:             Modified to get Contacts Details from new contact bridge table instead of POC Contact table.
-- ============================================= 
ALTER PROCEDURE [dbo].[GetOrgPocContactView]
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

SET @TCountQuery = 'SELECT @TotalCount = COUNT(Id) FROM [dbo].[CONTC010Bridge] (NOLOCK) '+ @entity 

--Below for getting user specific 'Statuses'
SET @TCountQuery = @TCountQuery + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) fgus ON ' + @entity + '.[StatusId] = fgus.[StatusId] '

SET @TCountQuery = @TCountQuery + ' WHERE [ConPrimaryRecordId] = @parentId ' + ISNULL(@where, '')
SET @TCountQuery = @TCountQuery + ' AND '+@entity+'.[ConTableName] = '''+ @entity + ''' '
EXEC sp_executesql @TCountQuery, N'@parentId BIGINT, @userId BIGINT, @TotalCount INT OUTPUT', @parentId, @userId, @TotalCount  OUTPUT;

IF(@recordId = 0)
	BEGIN

		SET @sqlCommand = 'SELECT ' + [dbo].[fnGetBaseQueryByUserId](@entity, @userId) 
		SET @sqlCommand = @sqlCommand + ' ,OrgPocContact.ConCode, OrgPocContact.ConIsDefault, OrgPocContact.ConItemNumber, OrgPocContact.ConOrgId, OrgPocContact.ContactMSTRID, OrgPocContact.ConTitle, OrgPocContact.ConTableTypeId'
		SET @sqlCommand = @sqlCommand + ' ,org.[OrgCode] AS ConOrgIdName, cont.[ConFullName] AS ContactMSTRIDName'

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

SET @sqlCommand = @sqlCommand + ' FROM [dbo].[CONTC010Bridge] (NOLOCK) '+ @entity

--Below to get BIGINT reference key name by Id if NOT NULL
SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[ORGAN000Master] (NOLOCK) org ON ' + @entity + '.[ConOrgId]=org.[Id] '
SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[CONTC000Master] (NOLOCK) cont ON ' + @entity + '.[ContactMSTRID]=cont.[Id] '

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

SET @sqlCommand = @sqlCommand + ' WHERE '+@entity+'.[ConOrgId] = @parentId '+ ISNULL(@where, '')
SET @sqlCommand = @sqlCommand + ' AND '+@entity+'.[ConTableName] = '''+ @entity + ''' '

IF((@recordId > 0) AND (((@isNext = 0) AND (@isEnd = 0)) OR ((@isNext = 1) AND (@isEnd = 0))))
	BEGIN
		IF((@isNext = 0) AND (@isEnd = 0))  
   BEGIN  
	IF(ISNULL(@orderBy, '') <> '')
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' <= (SELECT ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' FROM [dbo].[CONTC010Bridge] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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
		SET @sqlCommand = @sqlCommand + ' AND ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' >= (SELECT ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' FROM [dbo].[CONTC010Bridge] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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
		SET @sqlCommand = @sqlCommand + ' OFFSET @pageSize * (@pageNo - 1) ROWS FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);'      
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

EXEC sp_executesql @sqlCommand, N'@pageNo INT, @pageSize INT, @orderBy NVARCHAR(500), @where NVARCHAR(MAX), @parentId BIGINT, @entity NVARCHAR(100),@userId BIGINT' ,
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
PRINT N'Altering [dbo].[GetVendDcLocationContact]...';


GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               09/25/2018      
-- Description:               Get a Vend DCLocation Contact
-- Execution:                 EXEC [dbo].[GetVendDcLocationContact]
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)   
-- Modified Desc:  
-- =============================================
ALTER PROCEDURE  [dbo].[GetVendDcLocationContact]
    @userId BIGINT,
    @roleId BIGINT,
	@orgId BIGINT,
    @id BIGINT,
	@parentId BIGINT = null
AS
BEGIN TRY                
 SET NOCOUNT ON;   
 IF(@id = 0 AND (@parentId IS NOT NULL))
 BEGIN
	SELECT 
	VdcLocationCode AS VlcContactCode 
	,cont.ConBusinessPhone
	,cont.ConBusinessPhoneExt
	,org.OrgTitle as ConCompany
	,cont.ConBusinessAddress1
	,cont.ConBusinessAddress2
	,cont.ConBusinessCity
	,cont.ConBusinessStateId
	,cont.ConBusinessZipPostal
	,cont.ConBusinessCountryId
	FROM [dbo].[VEND040DCLocations]  vdc
	JOIN [dbo].[CONTC000Master] cont ON vdc.VdcContactMSTRID = cont.Id
	INNER JOIN [dbo].[ORGAN000Master] org On org.Id = cont.ConOrgId
	WHERE vdc.Id = @parentId
 END
 ELSE
 BEGIN
 --SELECT vend.[Id] AS 'VlcContactMSTRID'
	--	,vend.[VlcVendDcLocationId]
	--	,vend.[VlcItemNumber]
	--	,vend.[VlcContactCode]
	--	,vend.[VlcContactTitle]
	--	,vend.[VlcContactMSTRID] AS 'Id'
	--	,vend.[VlcAssignment]
	--	,vend.[VlcGateway]
	--	,vend.[StatusId]
	--	--,vend.[EnteredBy]
	--	--,vend.[DateEntered]
	--	--,vend.[ChangedBy]
	--	--,vend.[DateChanged]
	--	,ve.Id AS ParentId
		
	--	,cont.ConTitleId
	--	,cont.ConFirstName
	--	,cont.ConMiddleName
	--	,cont.ConLastName
	--	,cont.ConJobTitle
	--	,org.OrgTitle as ConCompany
	--	,cont.ConTypeId
	--	,cont.ConUDF01
	--	,cont.ConBusinessPhone
	--	,cont.ConBusinessPhoneExt
	--	,cont.ConMobilePhone
	--	,cont.ConEmailAddress
	--	,cont.ConEmailAddress2
	--	,cont.ConBusinessAddress1
	--	,cont.ConBusinessAddress2
	--	,cont.ConBusinessCity
	--	,cont.ConBusinessStateId
	--	,cont.ConBusinessZipPostal
	--	,cont.ConBusinessCountryId
	--	,cont.[EnteredBy]
	--	,cont.[DateEntered]
	--	,cont.[ChangedBy]
	--	,cont.[DateChanged]
 -- FROM [dbo].[VEND041DCLocationContacts] vend
 -- JOIN [dbo].[VEND040DCLocations] cdc ON vend.VlcVendDcLocationId = cdc.Id
 -- JOIN [dbo].[VEND000Master] ve ON cdc.VdcVendorID = ve.Id
 -- JOIN [dbo].[CONTC000Master] cont ON vend.VlcContactMSTRID = cont.Id
 -- INNER JOIN [dbo].[ORGAN000Master] org On org.Id = cont.ConOrgId
 -- WHERE vend.[Id]=@id

  SELECT vend.[Id] 
		,vend.[ConPrimaryRecordId] 
		,vend.[ConItemNumber]
		,vend.[ConCode]
		,vend.[ConTitle]
		,vend.[ContactMSTRID]
		--,vend.[ConAssignment] ,
		--,vend.[ConGateway]
		,'Assignment'
		,'Gateway'
		,vend.[StatusId]
		,vend.[EnteredBy]
		,vend.[DateEntered]
		--,vend.[ChangedBy]
		--,vend.[DateChanged]
		,ve.Id AS ParentId
		
		,cont.ConTitleId
		,cont.ConFirstName
		,cont.ConMiddleName
		,cont.ConLastName
		,cont.ConJobTitle
		,org.OrgTitle as ConCompany
		,cont.ConTypeId
		,cont.ConUDF01
		,cont.ConBusinessPhone
		,cont.ConBusinessPhoneExt
		,cont.ConMobilePhone
		,cont.ConEmailAddress
		,cont.ConEmailAddress2
		,cont.ConBusinessAddress1
		,cont.ConBusinessAddress2
		,cont.ConBusinessCity
		,cont.ConBusinessStateId
		,cont.ConBusinessZipPostal
		,cont.ConBusinessCountryId
		,cont.[EnteredBy]
		,cont.[DateEntered]
		,cont.[ChangedBy]
		,cont.[DateChanged]
  FROM [dbo].[CONTC010Bridge] vend
  JOIN [dbo].[VEND040DCLocations] cdc ON vend.ConPrimaryRecordId = cdc.Id
  JOIN [dbo].[VEND000Master] ve ON cdc.VdcVendorID = ve.Id
  JOIN [dbo].[CONTC000Master] cont ON vend.ContactMSTRID = cont.Id
  INNER JOIN [dbo].[ORGAN000Master] org On org.Id = vend.ConOrgId
  WHERE vend.[Id]=@id
 END
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
PRINT N'Altering [dbo].[InsVendDcLocationContact]...';


GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               09/25/2018     
-- Description:               Ins a vend dc location Contact
-- Execution:                 EXEC [dbo].[InsVendDcLocationContact]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId   and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================  
ALTER PROCEDURE  [dbo].[InsVendDcLocationContact]		  
	@userId BIGINT
	,@roleId BIGINT 
	,@entity NVARCHAR(100)
	,@vlcVendDcLocationId BIGINT  = NULL
	,@vlcItemNumber INT = NULL
	,@vlcContactCode NVARCHAR(20)  = NULL
	,@vlcContactTitle NVARCHAR(50)  = NULL
	,@vlcContactMSTRID BIGINT = NULL
	,@vlcAssignment NVARCHAR(20)  = NULL
	,@vlcGateway NVARCHAR(20)  = NULL
	,@statusId INT  = NULL
	,@conTitleId INT = NULL
	,@conLastName NVARCHAR(25) = NULL
	,@conFirstName NVARCHAR(25) = NULL
	,@conMiddleName NVARCHAR(25) = NULL
	,@conJobTitle NVARCHAR(50) = NULL
	,@conOrgId BIGINT = NULL
	,@conTypeId INT = NULL
	,@conUDF01 INT = NULL
	,@conBusinessPhone NVARCHAR(25) = NULL
	,@conBusinessPhoneExt NVARCHAR(15) = NULL
	,@conMobilePhone NVARCHAR(25) = NULL
	,@conEmailAddress NVARCHAR(100) = NULL
	,@conEmailAddress2 NVARCHAR(100) = NULL
	,@conBusinessAddress1 NVARCHAR(255) = NULL
	,@conBusinessAddress2 NVARCHAR(150) = NULL
	,@conBusinessCity NVARCHAR(25) = NULL
	,@conBusinessStateId INT = NULL
	,@conBusinessZipPostal NVARCHAR(20) = NULL
	,@conBusinessCountryId INT = NULL
	,@enteredBy NVARCHAR(50)  = NULL
	,@dateEntered DATETIME2(7) 	 = NULL	  
AS
BEGIN TRY                
 SET NOCOUNT ON;   
   DECLARE @updatedItemNumber INT      
  EXEC [dbo].[ResetItemNumber] @userId, 0, @vlcVendDcLocationId, @entity, @vlcItemNumber, @statusId, NULL, NULL,  @updatedItemNumber OUTPUT
 DECLARE @currentId BIGINT;

 -- First insert into ContactMaster table
 INSERT INTO [dbo].[CONTC000Master]
        ([ConOrgId]
        ,[ConTitleId]
        ,[ConLastName]
        ,[ConFirstName]
        ,[ConMiddleName]
        ,[ConEmailAddress]
        ,[ConEmailAddress2]
        ,[ConJobTitle]
        ,[ConBusinessPhone]
        ,[ConBusinessPhoneExt]
        ,[ConMobilePhone]
        ,[ConBusinessAddress1]
        ,[ConBusinessAddress2]
        ,[ConBusinessCity]
        ,[ConBusinessStateId]
        ,[ConBusinessZipPostal]
        ,[ConBusinessCountryId]
		,[ConUDF01]
        ,[StatusId]
        ,[ConTypeId]
        ,[DateEntered]
        ,[EnteredBy] )
     VALUES
		(@conOrgId
		,@conTitleId
		,@conLastName
		,@conFirstName
		,@conMiddleName
		,@conEmailAddress
		,@conEmailAddress2
		,@conJobTitle
		,@conBusinessPhone
		,@conBusinessPhoneExt
		,@conMobilePhone
		,@conBusinessAddress1
		,@conBusinessAddress2
		,@conBusinessCity
		,@conBusinessStateId
		,@conBusinessZipPostal
		,@conBusinessCountryId
		,@conUDF01
		,@statusId
		,@conTypeId
		,@dateEntered
		,@enteredBy)
	
	SET @currentId = SCOPE_IDENTITY();

IF(ISNULL(@currentId,0) <>0)
BEGIN
 --  -- Then Insert into VendDcLocationContact
 --  INSERT INTO [dbo].[VEND041DCLocationContacts]
 --          ([VlcVendDcLocationId]
	--	   	,[VlcItemNumber]
	--	   	,[VlcContactCode]
	--	   	,[VlcContactTitle]
	--	   	,[VlcContactMSTRID]
	--	   	,[VlcAssignment]
	--	   	,[VlcGateway]
	--	   	,[StatusId]
	--	   	,[EnteredBy]
	--	   	,[DateEntered])
 --    VALUES
	--	   (@vlcVendDcLocationId 
 --          ,@updatedItemNumber  
 --          ,@vlcContactCode   
--			 ,@vlcContactTitle
 --          ,@currentId   
 --          ,@vlcAssignment  
 --          ,@vlcGateway  
 --          ,@statusId 
 --          ,@enteredBy 
 --          ,@dateEntered)
 --  -- Then Insert into VendDcLocationContact
   INSERT INTO [dbo].[CONTC010Bridge]
          (  [ContactMSTRID]
			,[ConOrgId]
			,[ConTableName]
			,[ConPrimaryRecordId]
			,[ConItemNumber]
			,[ConCode]
			,[ConTitle]
			,[ConTypeId]
			,[StatusId]
			,[ConTableTypeId]       
			,[EnteredBy]
			,[DateEntered]
			)
     VALUES
				(@currentId
				,@conOrgId
				,@entity
				,@vlcVendDcLocationId
				,@updatedItemNumber 
				,@vlcContactCode
				,@vlcContactTitle
				,@conTypeId
				,@statusId  
				,@conUDF01 
				,@enteredBy 
				,@dateEntered)
 END 	
	SET @currentId = SCOPE_IDENTITY();
	EXEC [dbo].[GetVendDcLocationContact] @userId, @roleId, @conOrgId ,@currentId 
	
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
PRINT N'Altering [dbo].[UpdVendDcLocationContact]...';


GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               09/25/2018      
-- Description:               Upd a vend DCLocation Contact
-- Execution:                 EXEC [dbo].[UpdVendDcLocationContact]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================
ALTER PROCEDURE  [dbo].[UpdVendDcLocationContact]		  
	 @userId BIGINT
	,@roleId BIGINT  
	,@entity NVARCHAR(100)
	,@conOrgId BIGINT
	,@id BIGINT
	,@vlcVendDcLocationId BIGINT = NULL
	,@vlcItemNumber INT = NULL
	,@vlcContactCode NVARCHAR(50)  = NULL
	,@vlcContactTitle NVARCHAR(50)  = NULL
	,@vlcContactMSTRID BIGINT   = NULL
	,@vlcAssignment NVARCHAR(50)  = NULL
	,@vlcGateway NVARCHAR(50)  = NULL
	,@statusId INT = NULL
	,@conTitleId INT = NULL
	,@conLastName NVARCHAR(25) = NULL
	,@conFirstName NVARCHAR(25) = NULL
	,@conMiddleName NVARCHAR(25) = NULL
	,@conJobTitle NVARCHAR(50) = NULL
	,@conCompany NVARCHAR(100) = NULL
	,@conTypeId INT = NULL
	,@conUDF01 INT = NULL
	,@conBusinessPhone NVARCHAR(25) = NULL
	,@conBusinessPhoneExt NVARCHAR(15) = NULL
	,@conMobilePhone NVARCHAR(25) = NULL
	,@conEmailAddress NVARCHAR(100) = NULL
	,@conEmailAddress2 NVARCHAR(100) = NULL
	,@conBusinessAddress1 NVARCHAR(255) = NULL
	,@conBusinessAddress2 NVARCHAR(150) = NULL
	,@conBusinessCity NVARCHAR(25) = NULL
	,@conBusinessStateId INT = NULL
	,@conBusinessZipPostal NVARCHAR(20) = NULL
	,@conBusinessCountryId INT = NULL
	,@changedBy NVARCHAR(50)  = NULL
	,@dateChanged DATETIME2(7)  = NULL		  
	,@isFormView BIT = 0
AS
BEGIN TRY                
 SET NOCOUNT ON;   
  DECLARE @updatedItemNumber INT      
 EXEC [dbo].[ResetItemNumber] @userId, @id, @vlcVendDcLocationId, @entity, @vlcItemNumber, @statusId, NULL, NULL,  @updatedItemNumber OUTPUT
  --First Update Contact
  IF((ISNULL(@vlcContactMSTRID, 0) <> 0) AND (@isFormView = 1))
  BEGIN
	UPDATE  [dbo].[CONTC000Master]
	  SET  --ConCompany					= CASE WHEN (@isFormView = 1) THEN @conCompany WHEN ((@isFormView = 0) AND (@conCompany='#M4PL#')) THEN NULL ELSE ISNULL(@conCompany,ConCompany) END
			 ConTitleId					= ISNULL(@conTitleId,ConTitleId)
			,ConLastName				= CASE WHEN (@isFormView = 1) THEN @conLastName WHEN ((@isFormView = 0) AND (@conLastName='#M4PL#')) THEN NULL ELSE ISNULL(@conLastName,ConLastName) END
			,ConFirstName				= CASE WHEN (@isFormView = 1) THEN @conFirstName WHEN ((@isFormView = 0) AND (@conFirstName='#M4PL#')) THEN NULL ELSE ISNULL(@conFirstName,ConFirstName) END
			,ConMiddleName				= CASE WHEN (@isFormView = 1) THEN @conMiddleName WHEN ((@isFormView = 0) AND (@conMiddleName='#M4PL#')) THEN NULL ELSE ISNULL(@conMiddleName,ConMiddleName) END
			,ConEmailAddress			= CASE WHEN (@isFormView = 1) THEN @conEmailAddress WHEN ((@isFormView = 0) AND (@conEmailAddress='#M4PL#')) THEN NULL ELSE ISNULL(@conEmailAddress,ConEmailAddress) END
			,ConEmailAddress2			= CASE WHEN (@isFormView = 1) THEN @conEmailAddress2 WHEN ((@isFormView = 0) AND (@conEmailAddress2='#M4PL#')) THEN NULL ELSE ISNULL(@conEmailAddress2,ConEmailAddress2) END
			,ConJobTitle				= CASE WHEN (@isFormView = 1) THEN @conJobTitle WHEN ((@isFormView = 0) AND (@conJobTitle='#M4PL#')) THEN NULL ELSE ISNULL(@conJobTitle,ConJobTitle) END
			,ConBusinessPhone			= CASE WHEN (@isFormView = 1) THEN @conBusinessPhone WHEN ((@isFormView = 0) AND (@conBusinessPhone='#M4PL#')) THEN NULL ELSE ISNULL(@conBusinessPhone,ConBusinessPhone) END
			,ConBusinessPhoneExt		= CASE WHEN (@isFormView = 1) THEN @conBusinessPhoneExt WHEN ((@isFormView = 0) AND (@conBusinessPhoneExt='#M4PL#')) THEN NULL ELSE ISNULL(@conBusinessPhoneExt,ConBusinessPhoneExt) END
			,ConMobilePhone				= CASE WHEN (@isFormView = 1) THEN @conMobilePhone WHEN ((@isFormView = 0) AND (@conMobilePhone='#M4PL#')) THEN NULL ELSE ISNULL(@conMobilePhone,ConMobilePhone) END
			,ConBusinessAddress1		= CASE WHEN (@isFormView = 1) THEN @conBusinessAddress1 WHEN ((@isFormView = 0) AND (@conBusinessAddress1='#M4PL#')) THEN NULL ELSE ISNULL(@conBusinessAddress1,ConBusinessAddress1) END
			,ConBusinessAddress2		= CASE WHEN (@isFormView = 1) THEN @conBusinessAddress2 WHEN ((@isFormView = 0) AND (@conBusinessAddress2='#M4PL#')) THEN NULL ELSE ISNULL(@conBusinessAddress2,ConBusinessAddress2) END
			,ConBusinessCity			= CASE WHEN (@isFormView = 1) THEN @conBusinessCity WHEN ((@isFormView = 0) AND (@conBusinessCity='#M4PL#')) THEN NULL ELSE ISNULL(@conBusinessCity,ConBusinessCity) END
			,ConBusinessStateId			= ISNULL(@conBusinessStateId,ConBusinessStateId)
			,ConBusinessZipPostal		= CASE WHEN (@isFormView = 1) THEN @conBusinessZipPostal WHEN ((@isFormView = 0) AND (@conBusinessZipPostal='#M4PL#')) THEN NULL ELSE ISNULL(@conBusinessZipPostal,ConBusinessZipPostal) END
			,ConBusinessCountryId		= ISNULL(@conBusinessCountryId,ConBusinessCountryId)
			,ConUDF01					= ISNULL(@conUDF01,ConUDF01)
			,StatusId					= ISNULL(@statusId ,StatusId)
			,ConTypeId					= ISNULL(@conTypeId,ConTypeId)
			,DateChanged				= @dateChanged 
			,ChangedBy					= @changedBy  
	WHERE  Id = @vlcContactMSTRID
  END

  --Then Update Vend Dc Location
    UPDATE  [dbo].[CONTC010Bridge]
       SET  [ConPrimaryRecordId]		= CASE WHEN (@isFormView = 1) THEN @vlcVendDcLocationId WHEN ((@isFormView = 0) AND (@vlcVendDcLocationId=-100)) THEN NULL ELSE ISNULL(@vlcVendDcLocationId, ConPrimaryRecordId) END
			,[ConItemNumber]			= @updatedItemNumber
			,[ConCode]			= CASE WHEN (@isFormView = 1) THEN @vlcContactCode WHEN ((@isFormView = 0) AND (@vlcContactCode='#M4PL#')) THEN NULL ELSE ISNULL(@vlcContactCode, ConCode) END 
			,[ConTitle]			= CASE WHEN (@isFormView = 1) THEN @vlcContactTitle WHEN ((@isFormView = 0) AND (@vlcContactTitle='#M4PL#')) THEN NULL ELSE ISNULL(@vlcContactTitle, ConTitle) END  
			,[ContactMSTRID]			= CASE WHEN (@isFormView = 1) THEN @vlcContactMSTRID WHEN ((@isFormView = 0) AND (@vlcContactMSTRID=-100)) THEN NULL ELSE ISNULL(@vlcContactMSTRID,ContactMSTRID) END
			--,[VlcAssignment]			= CASE WHEN (@isFormView = 1) THEN @vlcAssignment WHEN ((@isFormView = 0) AND (@vlcAssignment='#M4PL#')) THEN NULL ELSE ISNULL(@vlcAssignment, VlcAssignment) END 
			--,[VlcGateway]				= CASE WHEN (@isFormView = 1) THEN @vlcGateway WHEN ((@isFormView = 0) AND (@vlcGateway='#M4PL#')) THEN NULL ELSE ISNULL(@vlcGateway, VlcGateway) END 
			,[StatusId]					= CASE WHEN (@isFormView = 1) THEN @statusId WHEN ((@isFormView = 0) AND (@statusId=-100)) THEN NULL ELSE ISNULL(@statusId, StatusId) END
            ,[ChangedBy]				= @changedBy   
            ,[DateChanged]				= @dateChanged 
	  WHERE  [Id] = @id 
                  
	EXEC [dbo].[GetVendDcLocationContact] @userId, @roleId, @conOrgId ,@id 
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
PRINT N'Altering [dbo].[GetVendDcLocationContactView]...';


GO

/* Copyright (2018) Meridian Worldwide Transportation Group  
   All Rights Reserved Worldwide */  
-- =============================================          
-- Author:                    Akhil Chauhan           
-- Create date:               09/25/2018        
-- Description:               Get all Vendor DC Location Contact 
-- Execution:                 EXEC [dbo].[GetVendDcLocationContactView]  
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)               
-- Modified Desc:           
-- =============================================  
ALTER PROCEDURE [dbo].[GetVendDcLocationContactView]  
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
  
SET @TCountQuery = 'SELECT @TotalCount = COUNT('+@entity+'.Id) FROM [dbo].[CONTC010Bridge] (NOLOCK) '+ @entity   
  
--Below for getting user specific 'Statuses'  
  SET @TCountQuery = @TCountQuery + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) fgus ON ' + @entity + '.[StatusId] = fgus.[StatusId] '  
  --Below to get BIGINT reference key name by Id if NOT NULL  
  SET @TCountQuery = @TCountQuery + ' LEFT JOIN [dbo].[CONTC000Master] (NOLOCK) cont ON ' + @entity + '.[ContactMSTRID]=cont.[Id] '  
  SET @TCountQuery = @TCountQuery + ' LEFT JOIN [dbo].[SYSTM000Ref_Options] (NOLOCK) refOp ON cont.ConUDF01=refOp.[Id] ' 
  
SET @TCountQuery = @TCountQuery + ' WHERE [ConPrimaryRecordId] = @parentId ' + ISNULL(@where, '')  
  SET @TCountQuery = @TCountQuery + ' AND '+@entity+'.[ConTableName] = '''+ @entity + ''' '
  
EXEC sp_executesql @TCountQuery, N' @orgId BIGINT, @parentId BIGINT, @userId BIGINT, @TotalCount INT OUTPUT',  @orgId, @parentId, @userId, @TotalCount  OUTPUT;  
  
IF(@recordId = 0)  
 BEGIN  
  SET @sqlCommand = 'SELECT ' + [dbo].[fnGetBaseQueryByUserId](@entity, @userId)   
  SET @sqlCommand = @sqlCommand + ' ,org.OrgCode As ConOrgIdName, cont.[ConFullName] AS ContactMSTRIDName, refOp.SysOptionName AS ConTableTypeIdName, cont.ConBusinessPhone AS ConBusinessPhone, cont.ConBusinessPhoneExt AS ConBusinessPhoneExt, cont.ConMobilePhone AS ConMobilePhone, cont.ConBusinessPhone, cont.ConBusinessPhoneExt, cont.ConMobilePhone '  
 SET @sqlCommand = @sqlCommand + ' , VendDcLocationContact.ConItemNumber, VendDcLocationContact.ConTableTypeId, VendDcLocationContact.ContactMSTRID, VendDcLocationContact.ConTitle '
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
  
 SET @sqlCommand = @sqlCommand + ' FROM [dbo].[CONTC010Bridge] (NOLOCK) '+ @entity  
  
--Below to get BIGINT reference key name by Id if NOT NULL  
SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[CONTC000Master] (NOLOCK) cont ON ' + @entity + '.[ContactMSTRID]=cont.[Id] '  
SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[SYSTM000Ref_Options] (NOLOCK) refOp ON cont.ConUDF01=refOp.[Id] '  
SET @sqlCommand = @sqlCommand +' LEFT JOIN [dbo].[ORGAN000Master] org ON org.Id= ' +  @entity + '.[ConOrgId] '
  
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
  
SET @sqlCommand = @sqlCommand + ' WHERE '+ @entity + '.[ConPrimaryRecordId]=@parentId ' + ISNULL(@where, '')  
  SET @sqlCommand = @sqlCommand + ' AND '+@entity+'.[ConTableName] = '''+ @entity + ''' '
  
IF((@recordId > 0) AND (((@isNext = 0) AND (@isEnd = 0)) OR ((@isNext = 1) AND (@isEnd = 0))))  
 BEGIN  
  IF((@isNext = 0) AND (@isEnd = 0))  
   BEGIN  
	IF(ISNULL(@orderBy, '') <> '')
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' <= (SELECT ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' FROM [dbo].[CONTC010Bridge] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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
		SET @sqlCommand = @sqlCommand + ' AND ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' >= (SELECT ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' FROM [dbo].[CONTC010Bridge] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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
  SET @sqlCommand = @sqlCommand + ' OFFSET @pageSize * (@pageNo - 1) ROWS FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);'         
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
EXEC sp_executesql @sqlCommand, N'@pageNo INT, @pageSize INT, @entity NVARCHAR(100), @orderBy NVARCHAR(500), @where NVARCHAR(MAX), @orgId BIGINT, @parentId BIGINT,@userId BIGINT' ,  
    
  @entity= @entity,  
  @pageNo= @pageNo,   
  @pageSize= @pageSize,  
  @orderBy = @orderBy,  
  @where = @where,  
  @orgId = @orgId,  
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
PRINT N'Altering [dbo].[UpdOrgPocContact]...';


GO

/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               08/16/2018      
-- Description:               Upd a org POC contact
-- Execution:                 EXEC [dbo].[UpdOrgPocContact]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================
ALTER PROCEDURE  [dbo].[UpdOrgPocContact] 	  
	@userId BIGINT
	,@roleId BIGINT  
	,@entity NVARCHAR(100)
	,@id BIGINT 
	,@orgId BIGINT = NULL
	,@contactId BIGINT = NULL
	,@pocCode NVARCHAR(20) = NULL
	,@pocTitle NVARCHAR(50) = NULL
	,@pocTypeId INT = NULL
	,@pocDefault BIT = NULL
	,@statusId INT = NULL
	,@dateChanged DATETIME2(7) = NULL
	,@changedBy NVARCHAR(50) = NULL
	,@pocSortOrder INT = NULL
	,@isFormView BIT = 0
AS
BEGIN TRY                
 SET NOCOUNT ON;   
  DECLARE @updatedItemNumber INT      
  EXEC [dbo].[ResetItemNumber] @userId, @id, @orgId, @entity, @pocSortOrder, @statusId, NULL, NULL,  @updatedItemNumber OUTPUT
  If (ISNULL(@id,0)!=0)
  BEGIN
  --UPDATE  [dbo].[ORGAN001POC_Contacts]
  --    SET  OrgId 		    = CASE WHEN (@isFormView = 1) THEN @orgId WHEN ((@isFormView = 0) AND (@orgId=-100)) THEN NULL ELSE ISNULL(@orgId, OrgId) END
  --        ,ContactID 		= CASE WHEN (@isFormView = 1) THEN @contactId WHEN ((@isFormView = 0) AND (@contactId=-100)) THEN NULL ELSE ISNULL(@contactId, ContactID) END
  --        ,PocCode 		    = CASE WHEN (@isFormView = 1) THEN @pocCode WHEN ((@isFormView = 0) AND (@pocCode='#M4PL#')) THEN NULL ELSE ISNULL(@pocCode, PocCode) END
  --        ,PocTitle 	    = CASE WHEN (@isFormView = 1) THEN @pocTitle WHEN ((@isFormView = 0) AND (@pocTitle='#M4PL#')) THEN NULL ELSE ISNULL(@pocTitle, PocTitle) END
  --        ,PocTypeId 		= CASE WHEN (@isFormView = 1) THEN @pocTypeId WHEN ((@isFormView = 0) AND (@pocTypeId=-100)) THEN NULL ELSE ISNULL(@pocTypeId, PocTypeId) END
  --        ,PocDefault 	    = ISNULL(@pocDefault, PocDefault)
  --        ,PocSortOrder 	= CASE WHEN (@isFormView = 1) THEN @updatedItemNumber WHEN ((@isFormView = 0) AND (@updatedItemNumber=-100)) THEN NULL ELSE ISNULL(@updatedItemNumber, PocSortOrder) END
  --        ,StatusId		 	= CASE WHEN (@isFormView = 1) THEN @statusId WHEN ((@isFormView = 0) AND (@statusId=-100)) THEN NULL ELSE ISNULL(@statusId, StatusId) END
  --        ,DateChanged		= @dateChanged  
  --        ,ChangedBy		= @changedBy  
	 --WHERE Id = @id
     UPDATE [dbo].[CONTC010Bridge]
			SET  ConPrimaryRecordId    = CASE WHEN (@isFormView = 1) THEN @orgId WHEN ((@isFormView = 0) AND (@orgId=-100)) THEN NULL ELSE ISNULL(@orgId, ConPrimaryRecordId) END
				,ConOrgId 		    = CASE WHEN (@isFormView = 1) THEN @orgId WHEN ((@isFormView = 0) AND (@orgId=-100)) THEN NULL ELSE ISNULL(@orgId, ConOrgId) END
				,ConItemNumber	  = CASE WHEN (@isFormView = 1) THEN @updatedItemNumber WHEN ((@isFormView = 0) AND (@updatedItemNumber=-100)) THEN NULL ELSE ISNULL(@updatedItemNumber, ConItemNumber) END
				,ConCode	  = CASE WHEN (@isFormView = 1) THEN @pocCode WHEN ((@isFormView = 0) AND (@pocCode='#M4PL#')) THEN NULL ELSE ISNULL(@pocCode, ConCode) END
				,ConTitle  = CASE WHEN (@isFormView = 1) THEN @pocTitle WHEN ((@isFormView = 0) AND (@pocTitle='#M4PL#')) THEN NULL ELSE ISNULL(@pocTitle, ConTitle) END
				,ContactMSTRID = CASE WHEN (@isFormView = 1) THEN @contactId WHEN ((@isFormView = 0) AND (@contactId=-100)) THEN NULL ELSE ISNULL(@contactId, ContactMSTRID) END
				,ConTableTypeId = CASE WHEN (@isFormView = 1) THEN @pocTypeId WHEN ((@isFormView = 0) AND (@pocTypeId=-100)) THEN NULL ELSE ISNULL(@pocTypeId, @pocTypeId) END
				,StatusId		  = CASE WHEN (@isFormView = 1) THEN @statusId WHEN ((@isFormView = 0) AND (@statusId=-100)) THEN NULL ELSE ISNULL(@statusId, StatusId) END
				,ChangedBy		  = @changedBy 
				,DateChanged		  = @dateChanged 	
      WHERE Id = @id
	  END
   EXEC [dbo].[GetOrgPocContact] @userId, @roleId, @orgId, @id
   --EXEC [dbo].[GetEntityContact]  @userId, @roleId, @orgId, @id

	END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
PRINT N'Refreshing [dbo].[InsColumnAliasesByTableName]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[InsColumnAliasesByTableName]';


GO
PRINT N'Update complete.';


GO
