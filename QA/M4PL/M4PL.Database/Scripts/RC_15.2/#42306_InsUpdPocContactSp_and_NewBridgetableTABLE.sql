
CREATE TABLE [dbo].[CONTC010Bridge] (
    [Id]                 BIGINT         IDENTITY (1, 1) NOT NULL,
    [ConOrgId]           BIGINT         NOT NULL,
    [ContactMSTRID]      BIGINT         NOT NULL,
    [ConTableName]       NVARCHAR (100) NULL,
    [ConPrimaryRecordId] BIGINT         NULL,
    [ConItemNumber]      INT            NULL,
    [ConCode]            NVARCHAR (20)  NULL,
    [ConTitle]           NVARCHAR (50)  NULL,
    [ConTypeId]          INT            NULL,
    [StatusId]           INT            NULL,
    [ConIsDefault]       BIT            NULL,
    [ConTableTypeId]     INT            NOT NULL,
    [EnteredBy]          NVARCHAR (50)  NULL,
    [DateEntered]        DATETIME2 (7)  NULL,
    [ChangedBy]          NVARCHAR (50)  NULL,
    [DateChanged]        DATETIME2 (7)  NULL,
    CONSTRAINT [PK_CONTC010Bridge] PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
PRINT N'Creating [dbo].[FK_CONTC010Bridge_ConTableTypeId_SYSTM000Ref_Options]...';


GO
ALTER TABLE [dbo].[CONTC010Bridge] WITH NOCHECK
    ADD CONSTRAINT [FK_CONTC010Bridge_ConTableTypeId_SYSTM000Ref_Options] FOREIGN KEY ([ConTableTypeId]) REFERENCES [dbo].[SYSTM000Ref_Options] ([Id]);


GO
PRINT N'Creating [dbo].[FK_CONTC010Bridge_ConTypeId_SYSTM000Ref_Options]...';


GO
ALTER TABLE [dbo].[CONTC010Bridge] WITH NOCHECK
    ADD CONSTRAINT [FK_CONTC010Bridge_ConTypeId_SYSTM000Ref_Options] FOREIGN KEY ([ConTypeId]) REFERENCES [dbo].[SYSTM000Ref_Options] ([Id]);


GO
PRINT N'Creating [dbo].[FK_CONTC010Bridge_ORGAN000Master]...';


GO
ALTER TABLE [dbo].[CONTC010Bridge] WITH NOCHECK
    ADD CONSTRAINT [FK_CONTC010Bridge_ORGAN000Master] FOREIGN KEY ([ConOrgId]) REFERENCES [dbo].[ORGAN000Master] ([Id]);


GO
PRINT N'Creating [dbo].[FK_CONTC010Bridge_StatusId_SYSTM000Ref_Options]...';


GO
ALTER TABLE [dbo].[CONTC010Bridge] WITH NOCHECK
    ADD CONSTRAINT [FK_CONTC010Bridge_StatusId_SYSTM000Ref_Options] FOREIGN KEY ([StatusId]) REFERENCES [dbo].[SYSTM000Ref_Options] ([Id]);


GO
PRINT N'Creating [dbo].[FK_CONTC010Bridge_SYSTM000Ref_Table]...';


GO
ALTER TABLE [dbo].[CONTC010Bridge] WITH NOCHECK
    ADD CONSTRAINT [FK_CONTC010Bridge_SYSTM000Ref_Table] FOREIGN KEY ([ConTableName]) REFERENCES [dbo].[SYSTM000Ref_Table] ([SysRefName]);


GO
PRINT N'Creating [dbo].[FK_CONTC010Bridge_CONTC000Master]...';


GO
ALTER TABLE [dbo].[CONTC010Bridge] WITH NOCHECK
    ADD CONSTRAINT [FK_CONTC010Bridge_CONTC000Master] FOREIGN KEY ([ContactMSTRID]) REFERENCES [dbo].[CONTC000Master] ([Id]);



GO
  
-- =============================================      
-- Author       : Akhil       
-- Create date  : 05 Dec 2017    
-- Description  : To get Module ref FK list    
-- Modified Date:      
-- Modified By  :      
-- Modified Desc:      
-- =============================================     
    
ALTER FUNCTION [dbo].[fnGetModuleFK]    
(        
      @tableName NVARCHAR(100)    
)    
RETURNS @Output TABLE (    
      ColumnName NVARCHAR(100),    
   RelationalEntity NVARCHAR(100)    
)   
AS    
BEGIN    
  DECLARE @HkWithoutSpace NVARCHAR(500) ='CONTC000Master,ORGAN000Master,VEND000Master,CUST000Master,PRGRM000Master,MVOC000Program,JOBDL000Master,JOBDL010Cargo,SYSTM000Ref_States,ORGAN010Ref_Roles,PRGRM020_Roles,SYSTM000ColumnsAlias,CONTC010Bridge';    
  INSERT INTO @Output    
   SELECT COL_NAME(fc.parent_object_id,fc.parent_column_id) ColName, ref_tbl.SysRefName RelationalEntity    
  FROM sys.foreign_keys AS f    
  INNER JOIN     
   sys.foreign_key_columns AS fc     
    ON f.OBJECT_ID = fc.constraint_object_id    
  INNER JOIN [dbo].[SYSTM000Ref_Table] (NOLOCK) tbl ON tbl.TblTableName = OBJECT_NAME(f.parent_object_id)    
  INNER JOIN dbo.fnSplitString(@HkWithoutSpace, ',') hfk ON hfk.Item = OBJECT_NAME (f.referenced_object_id)     
  INNER JOIN [dbo].[SYSTM000Ref_Table] (NOLOCK) ref_tbl ON OBJECT_NAME (f.referenced_object_id) = ref_tbl.[TblTableName]    
  WHERE tbl.SysRefName = @tableName    
 RETURN    
END
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
  IF(@tableName = 'OrgPocContact')
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
PRINT N'Altering [dbo].[GetOrgPocContact]...';


GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               08/16/2018      
-- Description:               Get a org POC contact   
-- Execution:                 EXEC [dbo].[GetOrgPocContact]
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)    
-- Modified Desc:  
-- =============================================
ALTER PROCEDURE  [dbo].[GetOrgPocContact]
    @userId BIGINT,
    @roleId BIGINT,
	@orgId BIGINT,
    @id BIGINT
AS
BEGIN TRY                
 SET NOCOUNT ON;   
 --SELECT org.[Id]
 --     ,org.[OrgID]
 --     ,org.[ContactID]
 --     ,org.[PocCode]
 --     ,org.[PocTitle]
 --     ,org.[PocTypeId]
 --     ,org.[PocDefault]
 --     ,org.[StatusId]
 --     ,org.[DateEntered]
 --     ,org.[EnteredBy]
 --     ,org.[DateChanged]
 --     ,org.[ChangedBy]
 --     ,org.[PocSortOrder]
 -- FROM [dbo].[ORGAN001POC_Contacts] org
 --WHERE [Id]=@id
 SELECT conBridge.[Id]
      ,conBridge.[ConOrgId]
      ,conBridge.[ContactMSTRID]
      ,conBridge.[ConCode]
      ,conBridge.[ConTitle]
      ,conBridge.[ConTypeId]
      ,conBridge.[ConIsDefault]
      ,conBridge.[StatusId]
      ,conBridge.[DateEntered]
      ,conBridge.[EnteredBy]
      ,conBridge.[DateChanged]
      ,conBridge.[ChangedBy]
      ,conBridge.[ConItemNumber]
   FROM [dbo].[CONTC010Bridge] conBridge 
   INNER JOIN [SYSTM000Ref_Table] entity  on entity.SysRefName = conBridge.ConTableName
   INNER JOIN [dbo].[CONTC000Master] con ON conBridge.ContactMSTRID = con.Id
   INNER JOIN [dbo].[SYSTM000Ref_Options]  opt ON opt.Id  = conBridge.ConTypeId
   INNER JOIN [dbo].[fnGetUserStatuses](@userId) fgus ON conBridge.[StatusId] = fgus.[StatusId]
   --INNER JOIN [dbo].[SYSTM000Ref_Lookup]  lkup ON lkup.Id  = ISNULL(conBridge.ConTableTypeId,lkup.id)
   WHERE conBridge.Id = @id AND conBridge.ConOrgId = @orgId
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
PRINT N'Altering [dbo].[InsOrgPocContact]...';


GO

/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               08/16/2018      
-- Description:               Ins a org POC contact
-- Execution:                 EXEC [dbo].[InsOrgPocContact]
-- Modified on:               4/10/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- ============================================= 
ALTER PROCEDURE  [dbo].[InsOrgPocContact]		  
	@userId BIGINT
	,@roleId BIGINT 
	,@entity NVARCHAR(100)
	,@orgId BIGINT = NULL
	,@contactId BIGINT = NULL
	,@pocCode NVARCHAR(20) = NULL
	,@pocTitle NVARCHAR(50) = NULL
	,@pocTypeId INT = NULL
	,@pocDefault BIT = NULL
	,@statusId INT = NULL
	,@dateEntered DATETIME2(7) = NULL
	,@enteredBy NVARCHAR(50) = NULL
	,@pocSortOrder INT = NULL
AS
BEGIN TRY                
 SET NOCOUNT ON;   
  DECLARE @updatedItemNumber INT      
EXEC [dbo].[ResetItemNumber] @userId, 0, @orgId, @entity, @pocSortOrder, @statusId, NULL, NULL,  @updatedItemNumber OUTPUT


 DECLARE @id BIGINT;
  --INSERT INTO [dbo].[ORGAN001POC_Contacts]
  --         ([OrgId]
  --         ,[ContactID]
  --         ,[PocCode]
  --         ,[PocTitle]
  --         ,[PocTypeId]
  --         ,[PocDefault]
		--   ,[StatusId]
  --         ,[DateEntered]
  --         ,[EnteredBy]
  --         ,[PocSortOrder])
  --   VALUES
		--  ( @orgId  
  --         ,@contactId  
  --         ,@pocCode 
  --         ,@pocTitle 
  --         ,@pocTypeId 
  --         ,@pocDefault 
		--   ,@statusId
  --         ,@dateEntered  
  --         ,@enteredBy 
  --         ,@updatedItemNumber)	
  INSERT INTO [dbo].[CONTC010Bridge]
			([ContactMSTRID]
			,[ConOrgId]
			,[ConTableName]
			,[ConPrimaryRecordId]
			,[ConItemNumber]
			,[ConCode]
			,[ConTitle]
			,[ConTypeId]
			,[StatusId]
			,[ConIsDefault]
			,[ConTableTypeId]       
			,[EnteredBy]
			,[DateEntered]
         )
     VALUES
           (@contactId
		    ,@orgId
           ,@entity
           ,@orgId
           ,@updatedItemNumber
           ,@pocCode
		   ,@pocTitle 
		   ,62
		   ,@statusId
		   ,@pocDefault 
           ,@pocTypeId
		   ,@enteredBy 
           ,@dateEntered
			)
		   SET @id = SCOPE_IDENTITY();
		     EXEC [dbo].[GetOrgPocContact] @userId, @roleId, @orgId, @id
	 --EXEC [dbo].[GetEntityContact] @userId, @roleId, @orgId, @id
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
				,ConTypeId = CASE WHEN (@isFormView = 1) THEN @pocTypeId WHEN ((@isFormView = 0) AND (@pocTypeId=-100)) THEN NULL ELSE ISNULL(@pocTypeId, @pocTypeId) END
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
PRINT N'Altering [dbo].[GetOrgPocContactView]...';


GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               09/04/2018      
-- Description:               Get all organization poc contact  
-- Execution:                 EXEC [dbo].[GetOrgPocContactView]
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)   
-- Modified Desc:  
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

SET @TCountQuery = @TCountQuery + ' WHERE [ConOrgId] = @parentId ' + ISNULL(@where, '')

EXEC sp_executesql @TCountQuery, N'@parentId BIGINT, @userId BIGINT, @TotalCount INT OUTPUT', @parentId, @userId, @TotalCount  OUTPUT;

IF(@recordId = 0)
	BEGIN
		SET @sqlCommand = 'SELECT ' + [dbo].[fnGetBaseQueryByUserId](@entity, @userId) 
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
PRINT N'Altering [dbo].[UpdateEntityField]...';


GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan 
-- Create date:               11/16/2018      
-- Description:               Update Status By EntityName For given comma separated ids
-- Execution:                 EXEC [dbo].[UpdateEntityField]
-- Modified on:  
-- Modified Desc:  
-- =============================================
ALTER PROCEDURE [dbo].[UpdateEntityField]
@userId BIGINT,
@roleId BIGINT,
@orgId BIGINT,
@entity NVARCHAR(100),
@ids NVARCHAR(MAX),
@separator CHAR(1),
@statusId INT,
@fieldName NVARCHAR(100)
AS
BEGIN TRY                
 SET NOCOUNT ON;  
 
 DECLARE @sqlCommand NVARCHAR(MAX);
 DECLARE @tableName NVARCHAR(100)
  DECLARE @contactContext NVARCHAR(100) 
  SET  @contactContext =@entity
   IF EXISTS(select 1 from CONTC010Bridge where ConTableName = @entity) 
   BEGIN
   SET  @entity  = 'ContactBridge'    -- this has been added to change entity type to Contactbridge if there is contact mapping.
   END 
 SELECT @tableName = TblTableName from [dbo].[SYSTM000Ref_Table] WHERE SysRefName = @entity

 DECLARE @primaryKeyName NVARCHAR(50);                                          
     	select @primaryKeyName =  TblPrimaryKeyName from [SYSTM000Ref_Table] where SysRefName = @entity
	--SET  @primaryKeyName = CASE @entity 
	--WHEN 'ScrOsdList' THEN 'OSDID' 
	--WHEN 'ScrOsdReasonList' THEN 'ReasonID' 
	--WHEN 'ScrRequirementList' THEN 'RequirementID'
	--WHEN 'ScrReturnReasonList' THEN 'ReturnReasonID'
	--WHEN 'ScrServiceList' THEN 'ServiceID'
	--ELSE 'Id' END;

 SET @sqlCommand = ' UPDATE ' + @entity + ' SET '+ @entity + '.' + @fieldName + ' = '+ CAST(@statusId as varchar(100)) + ' FROM ' + @tableName + ' ' + @entity +
				   ' JOIN [dbo].[fnSplitString](''' + @ids + ''', ''' + @separator + ''') allIds ON ' + @entity + '.'+@primaryKeyName+' = allIds.Item '
 
 EXEC sp_executesql @sqlCommand
 IF((@contactContext = 'CustContact') AND (@fieldName = 'StatusId'))
 BEGIN
	DECLARE @currentCustContact NVARCHAR(100)
	SELECT TOP 1 @currentCustContact= Item FROM [dbo].[fnSplitString](@ids, @separator)
	IF((SELECT COUNT(Id) FROM [dbo].[CUST010Contacts] WHERE Id = @currentCustContact) > 0)
	BEGIN
		DECLARE @currentCustomerId BIGINT
		DECLARE @currentCustCountToUpdate INT
		SELECT @currentCustomerId = CustCustomerID FROM [dbo].[CUST010Contacts] WHERE Id = @currentCustContact
		SELECT @currentCustCountToUpdate = (0-COUNT(Item)) FROM [dbo].[fnSplitString](@ids, @separator) 
		EXEC [dbo].[UpdateColumnCount] @tableName = 'CUST000Master', @columnName = 'CustContacts',  @rowId = @currentCustomerId, @countToChange = @currentCustCountToUpdate
	END
 END
 IF((@contactContext = 'VendContact') AND (@fieldName = 'StatusId'))
 BEGIN
	DECLARE @currentVendContact NVARCHAR(100)
	SELECT TOP 1 @currentVendContact= Item FROM [dbo].[fnSplitString](@ids, @separator)
	IF((SELECT COUNT(Id) FROM [dbo].[VEND010Contacts] WHERE Id = @currentVendContact) > 0)
	BEGIN
		DECLARE @currentVendorId BIGINT
		DECLARE @currentVendCountToUpdate INT
		SELECT @currentVendorId = VendVendorID FROM [dbo].[VEND010Contacts] WHERE Id = @currentVendContact
		SELECT @currentVendCountToUpdate = (0-COUNT(Item)) FROM [dbo].[fnSplitString](@ids, @separator) 
		EXEC [dbo].[UpdateColumnCount] @tableName = 'VEND000Master', @columnName = 'VendContacts',  @rowId = @currentVendorId, @countToChange = @currentVendCountToUpdate
	END
 END
  SET @sqlCommand = ' SELECT ' + @entity + '.' + @fieldName + ' AS SysRefId, 0 as IsDefault, NULL as SysRefName, NULL as LangName, 0 as ParentId'+
				   ' FROM ' + @tableName + ' ' + @entity +  
				   ' JOIN [dbo].[fnSplitString](''' + @ids + ''', ''' + @separator + ''') allIds ON ' + @entity + '.'+@primaryKeyName+' = allIds.Item ' +
				   ' WHERE ' + @entity + '.' + @fieldName + ' != ' + CAST(@statusId as varchar(100))
 
 EXEC sp_executesql @sqlCommand

END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH




GO
ALTER TABLE [dbo].[CONTC010Bridge] WITH CHECK CHECK CONSTRAINT [FK_CONTC010Bridge_ConTableTypeId_SYSTM000Ref_Options];

ALTER TABLE [dbo].[CONTC010Bridge] WITH CHECK CHECK CONSTRAINT [FK_CONTC010Bridge_ConTypeId_SYSTM000Ref_Options];

ALTER TABLE [dbo].[CONTC010Bridge] WITH CHECK CHECK CONSTRAINT [FK_CONTC010Bridge_ORGAN000Master];

ALTER TABLE [dbo].[CONTC010Bridge] WITH CHECK CHECK CONSTRAINT [FK_CONTC010Bridge_StatusId_SYSTM000Ref_Options];

ALTER TABLE [dbo].[CONTC010Bridge] WITH CHECK CHECK CONSTRAINT [FK_CONTC010Bridge_SYSTM000Ref_Table];

ALTER TABLE [dbo].[CONTC010Bridge] WITH CHECK CHECK CONSTRAINT [FK_CONTC010Bridge_CONTC000Master];

