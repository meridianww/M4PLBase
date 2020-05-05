

GO
PRINT N'Altering [dbo].[GetPrgEdiConditionByEdiHeader]...';


GO
/* Copyright (2019) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Nikhil Chauhan         
-- Create date:               10/22/2018      
-- Description:               Get PrgEdiCondition By EdiHeader
-- Execution:                 EXEC [dbo].[GetPrgEdiConditionByEdiHeader]   
-- =============================================  
ALTER PROCEDURE  [dbo].[GetPrgEdiConditionByEdiHeader]
    @userId BIGINT,
    @roleId BIGINT,
	@id BIGINT
AS
BEGIN TRY                
 SET NOCOUNT ON;   
  SELECT ediCon.[Id]
		,ediCon.[PecProgramId]
		,ediCon.[PecParentProgramId]
		,ediCon.[PecJobField]
		,ediCon.[PecCondition]
		,ediCon.[PerLogical]
		,ediCon.[PecJobField2]
		,ediCon.[PecCondition2]
		,ediCon.[DateEntered]
		,ediCon.[EnteredBy]
	   FROM [dbo].[PRGRM072EdiConditions] ediCon
 WHERE [Id] = @id
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
PRINT N'Altering [dbo].[InsPrgEdiCondition]...';


GO
/* Copyright (2019) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Nikhil Chauhan         
-- Create date:               08/21/2019      
-- Description:               Ins a Program Edi Condition 
-- Execution:                 EXEC [dbo].[InsPrgEdiCondition]
-- =============================================  
  
ALTER PROCEDURE  [dbo].[InsPrgEdiCondition]  
	(@userId BIGINT  
	,@roleId BIGINT 
	,@entity NVARCHAR(100)  
	,@pecParentProgramId BIGINT =NULL
	,@pecProgramId BIGINT
	,@pecJobField nvarchar(50)   
	,@pecCondition nvarchar(50)   
	,@perLogical nvarchar(50)     
	,@pecJobField2 nvarchar(50)  
	,@pecCondition2 nvarchar(50)  
	,@dateEntered datetime2(7)  
	,@enteredBy nvarchar(50)  
)  
AS  
BEGIN TRY                  
 SET NOCOUNT ON;     
 DECLARE @currentId BIGINT;  

 INSERT INTO [dbo].[PRGRM072EdiConditions]
           (
		    [PecParentProgramId]
           ,[PecProgramId]
           ,[PecJobField]
           ,[PecCondition]
           ,[PerLogical]
           ,[PecJobField2]
           ,[PecCondition2]
           ,[EnteredBy]
           ,[DateEntered]
		   --,[PecParentProgramId]
           ,[ChangedBy]
		   ,[DateChanged])
     VALUES
           (
			@pecParentProgramId
           ,@pecProgramId
           ,@pecJobField
           ,@pecCondition
           ,@perLogical
           ,@pecJobField2
           ,@pecCondition2
           ,@enteredBy
           ,@dateEntered
		   --,NULL
           ,NULL
           ,NULL) 
   SET @currentId = SCOPE_IDENTITY(); 
   
   EXECUTE  [GetPrgEdiConditionByEdiHeader] @userId,@roleId,@currentId;
 
END TRY                
BEGIN CATCH                  
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                  
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                  
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                  
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                  
END CATCH
GO
PRINT N'Altering [dbo].[GetPrgEdiConditionView]...';


GO
/* Copyright (2019) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Nikhil Chauhan         
-- Create date:               08/21/2019     
-- Description:               Get all Edi Condition by Parent ID  
-- Execution:                 EXEC [dbo].[GetPrgEdiConditionView]   
-- =============================================       
ALTER PROCEDURE [dbo].[GetPrgEdiConditionView]    
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
    
SET @TCountQuery = 'SELECT @TotalCount = COUNT(Id) FROM [dbo].[PRGRM072EdiConditions] (NOLOCK) '+ @entity +' WHERE PecProgramId =@parentId ' + ISNULL(@where, '')    
EXEC sp_executesql @TCountQuery, N'@parentId BIGINT,@TotalCount INT OUTPUT',@parentId , @TotalCount  OUTPUT;    
    
IF(@recordId = 0)    
 BEGIN    
  SET @sqlCommand = 'SELECT ' + [dbo].[fnGetBaseQueryByUserId](@entity, @userId)     
  --SET @sqlCommand = @sqlCommand + ' , rol.OrgRoleCode as OrgRefRoleIdName '    
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
    
SET @sqlCommand = @sqlCommand + ' FROM [dbo].[PRGRM072EdiConditions] (NOLOCK) '+ @entity    
    
--Below to get BIGINT reference key name by Id if NOT NULL    
SET @sqlCommand = @sqlCommand + ' INNER JOIN [dbo].[PRGRM070EdiHeader] (NOLOCK) head ON ' + @entity + '.[PecProgramId] = head.[Id] '  

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

SET @sqlCommand = @sqlCommand + ' WHERE '+@entity+'.PecProgramId =@parentId' + ISNULL(@where, '')    
    
IF((@recordId > 0) AND (((@isNext = 0) AND (@isEnd = 0)) OR ((@isNext = 1) AND (@isEnd = 0))))    
 BEGIN    
  IF((@isNext = 0) AND (@isEnd = 0))  
   BEGIN  
	IF(ISNULL(@orderBy, '') <> '')
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' <= (SELECT ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' FROM [dbo].[PRGRM072EdiConditions] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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
		SET @sqlCommand = @sqlCommand + ' AND ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' >= (SELECT ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' FROM [dbo].[PRGRM072EdiConditions] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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
   
EXEC sp_executesql @sqlCommand, N'@pageNo INT, @pageSize INT,@orderBy NVARCHAR(500), @where NVARCHAR(MAX), @entity NVARCHAR(100) ,@parentId BIGINT' ,    
  @entity= @entity,    
     @pageNo= @pageNo,     
     @pageSize= @pageSize,    
     @orderBy = @orderBy,    
     @where = @where,    
  @parentId = @parentId    
END TRY                    
BEGIN CATCH                    
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                    
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                    
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                    
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                    
END CATCH
GO
PRINT N'Altering [dbo].[GetPrgEdiHeader]...';


GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               09/14/2018      
-- Description:               Get a  Program header
-- Execution:                 EXEC [dbo].[GetPrgEdiHeader]
-- Modified on:               05/10/2018
-- Modified Desc:             Added OrderType and SetPurpose fields
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)  
-- =============================================
ALTER PROCEDURE  [dbo].[GetPrgEdiHeader]
    @userId BIGINT,
    @roleId BIGINT,
	@orgId BIGINT,
    @id BIGINT
AS
BEGIN TRY                
 SET NOCOUNT ON;   
  SELECT prg.[Id]
		,prg.[PehParentEDI]
		,prg.[PehProgramID]
		,prg.[PehItemNumber]
		,prg.[PehEdiCode]
		,prg.[PehEdiTitle]
		,prg.[PehTradingPartner]
		,prg.[PehEdiDocument]
		,prg.[PehEdiVersion]
		,prg.[PehSCACCode]
		,prg.[PehSndRcv]
		,prg.[PehInsertCode]   
        ,prg.[PehUpdateCode]   
        ,prg.[PehCancelCode]   
        ,prg.[PehHoldCode]     
        ,prg.[PehOriginalCode] 
        ,prg.[PehReturnCode] 
		,prg.[UDF01]
        ,prg.[UDF02]
        ,prg.[UDF03]
        ,prg.[UDF04]
		,prg.[UDF05]
        ,prg.[UDF06]
        ,prg.[UDF07]
        ,prg.[UDF08]
		,prg.[UDF09]
        ,prg.[UDF10]        
		,prg.[PehAttachments]
		,prg.[StatusId]
		,prg.[PehDateStart]
		,prg.[PehDateEnd]		
		,prg.[EnteredBy]
		,prg.[DateEntered]
		,prg.[ChangedBy]
		,prg.[DateChanged]
  FROM   [dbo].[PRGRM070EdiHeader] prg
 WHERE   [Id] = @id
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
PRINT N'Altering [dbo].[InsPrgEdiHeader]...';


GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               09/16/2018      
-- Description:               Ins a  Program Edi header
-- Execution:                 EXEC [dbo].[InsPrgEdiHeader]
-- Modified on:               05/10/2018
-- Modified Desc:             Added OrderType and SetPurpose fields
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.) 
-- ============================================= 

ALTER PROCEDURE  [dbo].[InsPrgEdiHeader]
	(@userId BIGINT
	,@roleId BIGINT 
	,@entity NVARCHAR(100)
	,@pehProgramId bigint
	,@pehItemNumber int
	,@pehEdiCode nvarchar(20)
	,@pehEdiTitle nvarchar(50)
	,@pehTradingPartner nvarchar(20)
	,@pehEdiDocument nvarchar(20)
	,@pehEdiVersion nvarchar(20)
	,@pehSCACCode nvarchar(20)
	,@pehSndRcv bit
	,@pehInsertCode   nvarchar(20)
	,@pehUpdateCode   nvarchar(20)
	,@pehCancelCode   nvarchar(20)
	,@pehHoldCode     nvarchar(20)
	,@pehOriginalCode nvarchar(20)
	,@pehReturnCode	  nvarchar(20)
	,@uDF01 nvarchar(20)
	,@uDF02 nvarchar(20)
	,@uDF03 nvarchar(20)
	,@uDF04 nvarchar(20)
	,@uDF05 nvarchar(20)
	,@uDF06 nvarchar(20)
	,@uDF07 nvarchar(20)
	,@uDF08 nvarchar(20)
	,@uDF09 nvarchar(20)
	,@uDF10 nvarchar(20)           
	,@pehAttachments int
	,@statusId int
	,@pehDateStart datetime2(7)
	,@pehDateEnd datetime2(7)			
	,@enteredBy nvarchar(50)
	,@dateEntered datetime2(7)
	,@pehParentEDI bit)
AS
BEGIN TRY                
 SET NOCOUNT ON; 
  DECLARE @updatedItemNumber INT      
 EXEC [dbo].[ResetItemNumber] @userId, 0, @pehProgramId, @entity, @pehItemNumber, @statusId, NULL, NULL,  @updatedItemNumber OUTPUT
   
 DECLARE @currentId BIGINT;
 INSERT INTO [dbo].[PRGRM070EdiHeader]
           ([PehParentEDI]    
		    ,[PehProgramID]
			,[PehItemNumber]
			,[PehEdiCode]
			,[PehEdiTitle]
			,[PehTradingPartner]
			,[PehEdiDocument]
			,[PehEdiVersion]
			,[PehSCACCode]
			,[PehInsertCode]  
			,[PehUpdateCode]   
			,[PehCancelCode]   
			,[PehHoldCode]    
			,[PehOriginalCode] 
			,[PehReturnCode]
			,[UDF01]
            ,[UDF02]
            ,[UDF03]
            ,[UDF04]
			,[UDF05]
			,[UDF06]
			,[UDF07]
			,[UDF08]
			,[UDF09]
			,[UDF10]
			,[PehAttachments]
			,[StatusId]
			,[PehDateStart]
			,[PehDateEnd]
			,[PehSndRcv]
			,[EnteredBy]
			,[DateEntered])
     VALUES
           (@pehParentEDI
		    , @pehProgramId
		   	,@updatedItemNumber
		   	,@pehEdiCode
		   	,@pehEdiTitle
		   	,@pehTradingPartner
		   	,@pehEdiDocument
		   	,@pehEdiVersion
		   	,@pehSCACCode
			,@pehInsertCode   
            ,@pehUpdateCode   
            ,@pehCancelCode   
            ,@pehHoldCode     
            ,@pehOriginalCode 
            ,@pehReturnCode	  
			,@uDF01
            ,@uDF02
            ,@uDF03
            ,@uDF04
			,@uDF05
			,@uDF06
			,@uDF07
			,@uDF08
			,@uDF09
			,@uDF10
		   	,@pehAttachments
		   	,@statusId
		   	,@pehDateStart
		   	,@pehDateEnd
			,@pehSndRcv
		   	,@enteredBy
		   	,@dateEntered)
			SET @currentId = SCOPE_IDENTITY();
	SELECT * FROM [dbo].[PRGRM070EdiHeader] WHERE Id = @currentId;	
END TRY              
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
PRINT N'Altering [dbo].[UpdPrgEdiHeader]...';


GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               08/16/2018      
-- Description:               Upd a Program EDI header
-- Execution:                 EXEC [dbo].[UpdPrgEdiHeader]
-- Modified Desc:             Added OrderType and SetPurpose fields
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)               05/10/2018
-- =============================================
ALTER PROCEDURE  [dbo].[UpdPrgEdiHeader]
	(@userId BIGINT
	,@roleId BIGINT  
	,@entity NVARCHAR(100)
	,@id bigint
	,@pehParentEDI bit
	,@pehProgramId bigint = NULL
	,@pehItemNumber int = NULL
	,@pehEdiCode nvarchar(20) = NULL
	,@pehEdiTitle nvarchar(50) = NULL
	,@pehTradingPartner nvarchar(20) = NULL
	,@pehEdiDocument nvarchar(20) = NULL
	,@pehEdiVersion nvarchar(20) = NULL
	,@pehSCACCode nvarchar(20) = NULL
	,@pehInsertCode   nvarchar(20)
	,@pehUpdateCode   nvarchar(20)
	,@pehCancelCode   nvarchar(20)
	,@pehHoldCode     nvarchar(20)
	,@pehOriginalCode nvarchar(20)
	,@pehReturnCode	  nvarchar(20)
	,@uDF01 nvarchar(20)
	,@uDF02 nvarchar(20)
	,@uDF03 nvarchar(20)
	,@uDF04 nvarchar(20)
	,@uDF05 nvarchar(20)
	,@uDF06 nvarchar(20)
	,@uDF07 nvarchar(20)
	,@uDF08 nvarchar(20)
	,@uDF09 nvarchar(20)
	,@uDF10 nvarchar(20)           
	,@pehAttachments int = NULL
	,@statusId int = NULL
	,@pehDateStart datetime2(7) = NULL
	,@pehDateEnd datetime2(7) = NULL
	,@pehSndRcv bit =NULL
	,@changedBy nvarchar(50) = NULL
	,@dateChanged datetime2(7) = NULL
	,@isFormView BIT = 0) 
AS
BEGIN TRY                
 SET NOCOUNT ON;   
  DECLARE @updatedItemNumber INT      
  EXEC [dbo].[ResetItemNumber] @userId, @id, @pehProgramId, @entity, @pehItemNumber, @statusId, NULL, NULL,  @updatedItemNumber OUTPUT

 UPDATE [dbo].[PRGRM070EdiHeader]	
		SET  [PehParentEDI]           =  CASE WHEN (@isFormView = 1) THEN @pehParentEDI WHEN ((@isFormView = 0) AND (@pehParentEDI=-100)) THEN NULL ELSE ISNULL(@pehParentEDI, PehParentEDI) END
		    ,[PehProgramID]          =  CASE WHEN (@isFormView = 1) THEN @pehProgramId WHEN ((@isFormView = 0) AND (@pehProgramId=-100)) THEN NULL ELSE ISNULL(@pehProgramId, PehProgramID) END
			,[PehItemNumber]         =  CASE WHEN (@isFormView = 1) THEN @updatedItemNumber WHEN ((@isFormView = 0) AND (@updatedItemNumber=-100)) THEN NULL ELSE ISNULL(@updatedItemNumber, PehItemNumber) END
			,[PehEdiCode]            =  CASE WHEN (@isFormView = 1) THEN @pehEdiCode WHEN ((@isFormView = 0) AND (@pehEdiCode='#M4PL#')) THEN NULL ELSE ISNULL(@pehEdiCode, PehEdiCode) END
			,[PehEdiTitle]           =  CASE WHEN (@isFormView = 1) THEN @pehEdiTitle WHEN ((@isFormView = 0) AND (@pehEdiTitle='#M4PL#')) THEN NULL ELSE ISNULL(@pehEdiTitle, PehEdiTitle) END
			,[PehTradingPartner]     =  CASE WHEN (@isFormView = 1) THEN @pehTradingPartner WHEN ((@isFormView = 0) AND (@pehTradingPartner='#M4PL#')) THEN NULL ELSE ISNULL(@pehTradingPartner, PehTradingPartner) END
			,[PehEdiDocument]        =  CASE WHEN (@isFormView = 1) THEN @pehEdiDocument WHEN ((@isFormView = 0) AND (@pehEdiDocument='#M4PL#')) THEN NULL ELSE ISNULL(@pehEdiDocument, PehEdiDocument) END
			,[PehEdiVersion]         =  CASE WHEN (@isFormView = 1) THEN @pehEdiVersion WHEN ((@isFormView = 0) AND (@pehEdiVersion='#M4PL#')) THEN NULL ELSE ISNULL(@pehEdiVersion, PehEdiVersion) END
			,[PehSCACCode]           =  CASE WHEN (@isFormView = 1) THEN @pehSCACCode WHEN ((@isFormView = 0) AND (@pehSCACCode='#M4PL#')) THEN NULL ELSE ISNULL(@pehSCACCode, PehSCACCode) END
			,[PehInsertCode]         =  CASE WHEN (@isFormView = 1) THEN @pehInsertCode WHEN ((@isFormView = 0) AND (@pehInsertCode='#M4PL#')) THEN NULL ELSE ISNULL(@pehInsertCode, PehInsertCode) END
			,[PehUpdateCode]         =  CASE WHEN (@isFormView = 1) THEN @pehUpdateCode WHEN ((@isFormView = 0) AND (@pehUpdateCode='#M4PL#')) THEN NULL ELSE ISNULL(@pehUpdateCode, PehUpdateCode) END
			,[PehCancelCode]         =  CASE WHEN (@isFormView = 1) THEN @pehCancelCode WHEN ((@isFormView = 0) AND (@pehCancelCode='#M4PL#')) THEN NULL ELSE ISNULL(@pehCancelCode, PehCancelCode) END
			,[PehHoldCode]           =  CASE WHEN (@isFormView = 1) THEN @pehHoldCode WHEN ((@isFormView = 0) AND (@pehHoldCode='#M4PL#')) THEN NULL ELSE ISNULL(@pehHoldCode, PehHoldCode) END
			,[PehOriginalCode]       =  CASE WHEN (@isFormView = 1) THEN @pehOriginalCode WHEN ((@isFormView = 0) AND (@pehOriginalCode='#M4PL#')) THEN NULL ELSE ISNULL(@pehOriginalCode, PehOriginalCode) END
			,[PehReturnCode]         =  CASE WHEN (@isFormView = 1) THEN @pehReturnCode WHEN ((@isFormView = 0) AND (@pehReturnCode='#M4PL#')) THEN NULL ELSE ISNULL(@pehReturnCode, PehReturnCode) END
			,[UDF01]         =  CASE WHEN (@isFormView = 1) THEN @uDF01 WHEN ((@isFormView = 0) AND (@uDF01='#M4PL#')) THEN NULL ELSE ISNULL(@uDF01, UDF01) END
			,[UDF02]         =  CASE WHEN (@isFormView = 1) THEN @uDF02 WHEN ((@isFormView = 0) AND (@uDF02='#M4PL#')) THEN NULL ELSE ISNULL(@uDF02, UDF02) END
			,[UDF03]         =  CASE WHEN (@isFormView = 1) THEN @uDF03 WHEN ((@isFormView = 0) AND (@uDF03='#M4PL#')) THEN NULL ELSE ISNULL(@uDF03, UDF03) END
			,[UDF04]         =  CASE WHEN (@isFormView = 1) THEN @uDF04 WHEN ((@isFormView = 0) AND (@uDF04='#M4PL#')) THEN NULL ELSE ISNULL(@uDF04, UDF04) END
			,[UDF05]         =  CASE WHEN (@isFormView = 1) THEN @uDF05 WHEN ((@isFormView = 0) AND (@uDF05='#M4PL#')) THEN NULL ELSE ISNULL(@uDF05, UDF05) END
			,[UDF06]         =  CASE WHEN (@isFormView = 1) THEN @uDF06 WHEN ((@isFormView = 0) AND (@uDF06='#M4PL#')) THEN NULL ELSE ISNULL(@uDF06, UDF06) END
			,[UDF07]         =  CASE WHEN (@isFormView = 1) THEN @uDF07 WHEN ((@isFormView = 0) AND (@uDF07='#M4PL#')) THEN NULL ELSE ISNULL(@uDF07, UDF07) END
			,[UDF08]         =  CASE WHEN (@isFormView = 1) THEN @uDF08 WHEN ((@isFormView = 0) AND (@uDF08='#M4PL#')) THEN NULL ELSE ISNULL(@uDF08, UDF08) END
			,[UDF09]         =  CASE WHEN (@isFormView = 1) THEN @uDF09 WHEN ((@isFormView = 0) AND (@uDF09='#M4PL#')) THEN NULL ELSE ISNULL(@uDF09, UDF09) END
			,[UDF10]         =  CASE WHEN (@isFormView = 1) THEN @uDF10 WHEN ((@isFormView = 0) AND (@uDF10='#M4PL#')) THEN NULL ELSE ISNULL(@uDF10, UDF10) END
			

			--,[PehAttachments]        =  CASE WHEN (@isFormView = 1) THEN @pehAttachments WHEN ((@isFormView = 0) AND (@pehAttachments=-100)) THEN NULL ELSE ISNULL(@pehAttachments, PehAttachments) END
			,[StatusId]              =  CASE WHEN (@isFormView = 1) THEN @statusId WHEN ((@isFormView = 0) AND (@statusId=-100)) THEN NULL ELSE ISNULL(@statusId, StatusId) END
			,[PehDateStart]          =  CASE WHEN (@isFormView = 1) THEN @pehDateStart WHEN ((@isFormView = 0) AND (CONVERT(CHAR(10), @pehDateStart, 103)='01/01/1753')) THEN NULL ELSE ISNULL(@pehDateStart, PehDateStart) END
			,[PehDateEnd]            =  CASE WHEN (@isFormView = 1) THEN @pehDateEnd WHEN ((@isFormView = 0) AND (CONVERT(CHAR(10), @pehDateEnd, 103)='01/01/1753')) THEN NULL ELSE ISNULL(@pehDateEnd, PehDateEnd) END
			,[PehSndRcv]            =  ISNULL(@pehSndRcv, PehSndRcv)  
			,[ChangedBy]             =  @changedBy
			,[DateChanged]           =  @dateChanged
	 WHERE   [Id] = @id
	SELECT prg.[Id]
	    ,prg.[PehParentEDI] 
		,prg.[PehProgramID]
		,prg.[PehItemNumber]
		,prg.[PehEdiCode]
		,prg.[PehEdiTitle]
		,prg.[PehTradingPartner]
		,prg.[PehEdiDocument]
		,prg.[PehEdiVersion]
		,prg.[PehSCACCode]
		,prg.[UDF01]  
		,prg.[UDF02]  
		,prg.[UDF03]  
		,prg.[UDF04]
		,prg.[PehAttachments]
		,prg.[StatusId]
		,prg.[PehDateStart]
		,prg.[PehDateEnd]
		,prg.[PehSndRcv]
		,prg.[EnteredBy]
		,prg.[DateEntered]
		,prg.[ChangedBy]
		,prg.[DateChanged]
  FROM   [dbo].[PRGRM070EdiHeader] prg
 WHERE   [Id] = @id
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH

GO
PRINT N'Creating [dbo].[UpdPrgEdiCondition]...';


GO
	/* Copyright (2019) Meridian Worldwide Transportation Group
		All Rights Reserved Worldwide */
	-- =============================================        
	-- Author:                    Nikhil Chauhan  
	-- Create date:               08/30/2019      
	-- Description:               Upd a security by role 
	-- Execution:                 EXEC [dbo].[UpdPrgEdiCondition]
	-- ============================================= 
	CREATE  PROCEDURE  [dbo].[UpdPrgEdiCondition]
		(@userId BIGINT
		,@roleId BIGINT  
		,@entity NVARCHAR(100)
		,@id bigint
		,@orgId bigint = NULL
		,@pecParentProgramId bigint 
		,@pecJobField nvarchar(50)
		,@pecCondition nvarchar(50)
		,@perLogical nvarchar(20)
		,@pecJobField2 nvarchar(50)
		,@pecCondition2  nvarchar(50)
		,@dateChanged datetime2(7) = NULL
		,@changedBy nvarchar(50) = NULL
		,@isFormView bit) 
	AS
	BEGIN TRY                
		SET NOCOUNT ON;   

		UPDATE [dbo].[PRGRM072EdiConditions]
		SET
			[PecParentProgramId] = @pecParentProgramId
			,[PecJobField] = @PecJobField
			,[PecCondition] = @pecCondition
			,[PerLogical] = @perLogical 
			,[PecJobField2] = @pecJobField2
			,[PecCondition2] = @pecCondition2
			,[ChangedBy] = @changedBy
			,[DateChanged] = @dateChanged
			WHERE	 [Id] = @id

		EXECUTE  [GetPrgEdiConditionByEdiHeader] @userId,@roleId,@id;
	
	END TRY                
	BEGIN CATCH                
		DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
		,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
		,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
		EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
	END CATCH
GO
PRINT N'Update complete.';


GO
