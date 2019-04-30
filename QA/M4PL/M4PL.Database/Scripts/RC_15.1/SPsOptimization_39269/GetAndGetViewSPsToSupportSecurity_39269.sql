USE [M4PL_3030_Azure]
GO
/****** Object:  StoredProcedure [dbo].[GetActrolesByProgramId]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================                          
/* Copyright (2018) Meridian Worldwide Transportation Group  
   All Rights Reserved Worldwide */  
-- =============================================          
-- Author:                    Janardana           
-- Create date:               07/06/2018        
-- Description:               Get Organization Actroles based on organization   
-- Execution:                 EXEC [dbo].[GetActrolesByProgramId]     
-- Modified on:    
-- Modified Desc:    
-- =============================================                         
ALTER PROCEDURE [dbo].[GetActrolesByProgramId]                
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
	 @programId BIGINT =NULL
AS                          
BEGIN TRY                          

  DECLARE @ProgramLevel INT          
  SELECT  @ProgramLevel = PrgHierarchyLevel  from [dbo].[PRGRM000Master] (NOLOCK) WHERE  Id= @programId AND PrgOrgID = @orgId;          
  
  IF @ProgramLevel = 1          
  BEGIN        
     SELECT rol.Id,rol.OrgRoleCode,rol.OrgRoleTitle FROM [dbo].[ORGAN010Ref_Roles] (NOLOCK)  rol  
  INNER JOIN ORGAN020Act_Roles (NOLOCK)  act ON rol.Id= act.[OrgRefRoleId]  
  WHERE  act.PrgLogical = 1 AND act.OrgID = @orgId
  
  ORDER BY  rol.Id,rol.OrgRoleCode,rol.OrgRoleTitle 
  OFFSET @pageSize * (@pageNo - 1) ROWS FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);   
     
  END          
  ELSE IF @ProgramLevel=2          
  BEGIN          
        SELECT rol.Id,rol.OrgRoleCode,rol.OrgRoleTitle FROM [dbo].[ORGAN010Ref_Roles] (NOLOCK)  rol  
  INNER JOIN ORGAN020Act_Roles (NOLOCK)  act ON rol.Id= act.[OrgRefRoleId]  
  WHERE  act.PrjLogical = 1 AND act.OrgID = @OrgId    
  ORDER BY  rol.Id,rol.OrgRoleCode,rol.OrgRoleTitle 
  OFFSET @pageSize * (@pageNo - 1) ROWS FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);      
  END          
  ELSE IF  @ProgramLevel=3          
  BEGIN          
      SELECT rol.Id,rol.OrgRoleCode,rol.OrgRoleTitle FROM [dbo].[ORGAN010Ref_Roles] (NOLOCK)  rol  
  INNER JOIN ORGAN020Act_Roles (NOLOCK)  act ON rol.Id= act.[OrgRefRoleId]  
  WHERE  act.PhsLogical = 1 AND act.OrgID = @OrgId
   ORDER BY  rol.Id,rol.OrgRoleCode,rol.OrgRoleTitle 
  OFFSET @pageSize * (@pageNo - 1) ROWS FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);              
  END           
                   
END TRY                          
BEGIN CATCH                          
                           
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                    
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                    
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                    
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                          
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetAppDashboardDropdown]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil         
-- Create date:               04/06/2018      
-- Description:               Get AppDashboard Dropdown 
-- Execution:                 EXEC [dbo].[GetAppDashboardDropdown]   
-- Modified on:  
-- Modified Desc:  
-- =============================================                          
ALTER PROCEDURE [dbo].[GetAppDashboardDropdown]
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
	 @primaryKeyName NVARCHAR(50) = null   
AS                  
BEGIN TRY                  
SET NOCOUNT ON;    
 DECLARE @sqlCommand NVARCHAR(MAX);  
 DECLARE @newPgNo INT
 SET @sqlCommand = '';

IF(ISNULL(@primaryKeyValue, '') > '')
 BEGIN
	SET @sqlCommand += ' SELECT @newPgNo = Item FROM (SELECT ROW_NUMBER() OVER(ORDER BY ' + @entity + '.' + @primaryKeyName+') as Item  ,' +@entity + '.' + @primaryKeyName + 
					   ' From [dbo].[SYSTM000Ref_Dashboard] (NOLOCK) ' + @entity + ' WHERE  ' + @entity + '.StatusId In (1,2)' +
					   ' ) t WHERE t.' + @primaryKeyName + '=' + @primaryKeyValue;
	EXEC sp_executesql @sqlCommand, N' @newPgNo int output',@newPgNo output                                    
    SET @newPgNo =  @newPgNo/@pageSize + 1; 
	SET @pageSize = @newPgNo * @pageSize;
	SET @sqlCommand='';
 END

 SET @sqlCommand = 'SELECT '+ @fields +' FROM [dbo].[SYSTM000Ref_Dashboard] (NOLOCK) '+  @entity + ' WHERE 1=1 AND StatusId In (1,2) AND ' + @entity + '.OrganizationId = ' + CAST(@orgId AS nvarchar(50)) + ' '   
 IF(ISNULL(@like, '') != '')  
  BEGIN  
  SET @sqlCommand = @sqlCommand + 'AND ('  
   DECLARE @likeStmt NVARCHAR(MAX)  
  SELECT @likeStmt = COALESCE(@likeStmt + ' OR ','') + Item + ' LIKE ''%' + @like + '%' + '''' FROM [dbo].[fnSplitString](@fields, ',')  
  SET @sqlCommand = @sqlCommand + @likeStmt + ') '  
  END  
 IF(ISNULL(@where, '') != '')  
  BEGIN  
     SET @sqlCommand = @sqlCommand + @where   
 END  
  
SET @sqlCommand = @sqlCommand + ' ORDER BY '+ @fields +' OFFSET @pageSize * (@pageNo - 1) ROWS FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);'   
  
EXEC sp_executesql @sqlCommand, N'@pageNo INT, @pageSize INT, @where NVARCHAR(100)' ,  
     @pageNo = @pageNo,   
     @pageSize = @pageSize,  
     @where = @where  
END TRY                  
BEGIN CATCH                  
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                  
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                  
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                  
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                  
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetAssignUnassignProgram]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Janardana         
-- Create date:               09/15/2018      
-- Description:               Get all Cost rates under the specified program 
-- Execution:                 EXEC [dbo].[GetAssignUnassignProgram]   
-- Modified on:  
-- Modified Desc:  
-- =============================================                           
ALTER PROCEDURE [dbo].[GetAssignUnassignProgram]   
	 @orgId BIGINT,        
	 @isAssignedPrgVendor BIT,                       
	 @parentId BIGINT = NULL,  
	 @programId BIGINT,        
	 @isChild BIT                    
AS                              
BEGIN TRY                   
    SET NOCOUNT ON;                 
           
--assigned Program vendor locations      
IF @isAssignedPrgVendor = 1        
BEGIN        
   IF @isChild = 0        
   BEGIN        
         SELECT  vm.Id  AS Id        
          ,NULL  AS ParentId        
    --,vm.VendCode  AS Name       
 ,'0_'+CAST(vm.Id AS VARCHAR) As Name     
    ,vm.VendCode + COALESCE( '('+VendTitle+')', '')  as [Text]        
    ,vm.VendCode + COALESCE( '('+VendTitle+')', '')  as [ToolTip]        
         
  FROM VEND000Master (NOLOCK) vm    
  WHERE vm.StatusId  IN( 1,2)    
       AND  vm.Id In (select PvlVendorID from PRGRM051VendorLocations pvl WHERE PvlProgramID = @programId AND pvl.StatusId  IN( 1,2)  )  
	   AND  vm.VendOrgId = @orgId  
    ORDER BY  vm.VendCode      
            
   END        
   ELSE        
   BEGIN        
       SELECT  pvl.Id  AS Id        
          ,pvl.PvlProgramID  AS ParentId        
    --,pvl.PvlLocationCode  AS Name        
 ,CAST(pvl.PvlProgramID AS VARCHAR) + '_'+CAST(pvl.Id AS VARCHAR) As Name     
    ,pvl.PvlLocationCode + COALESCE( '('+PvlLocationTitle+')', '')  as [Text]        
    ,pvl.PvlLocationCode + COALESCE( '('+PvlLocationTitle+')', '')  as [ToolTip]    
 ,CAST(1 AS BIT) As IsLeaf        
     FROM PRGRM051VendorLocations (NOLOCK) pvl        
  INNER JOIN VEND000Master (NOLOCK) vm ON pvl.PvlVendorID = vm.Id         
  WHERE vm.StatusId  IN( 1,2)          
       AND  pvl.StatusId  IN( 1,2)          
        AND pvl.PvlVendorID = @parentId 
		AND pvl.PvlProgramID = @programId             
    ORDER BY  pvl.PvlLocationCode  
        
   END         
END        
ELSE  -- --Unassigned Program vendor locations       
BEGIN        
IF @isChild = 0        
   BEGIN        
         SELECT DISTINCT vm.Id  AS Id        
          ,NULL  AS ParentId        
      
 ,'0_'+CAST(vm.Id AS VARCHAR) As Name    
    ,vm.VendCode + COALESCE( '('+VendTitle+')', '')  as [Text]        
    ,vm.VendCode + COALESCE( '('+VendTitle+')', '')  as [ToolTip]       
 ,CASE WHEN vdc.Id IS NULL THEN CAST(1 AS BIT)     
  ELSE CAST(0 AS BIT) END AS IsLeaf    
 ,CASE WHEN ISNULL(vdc.Id,0) > 0 THEN  CAST(1 AS BIT)
       WHEN (vm.[VendCorporateAddressId] IS NULL AND vm.[VendBusinessAddressId] IS NULL AND vm.[VendWorkAddressId] IS NULL) THEN CAST(0 AS BIT)         
       ELSE CAST(1 AS BIT)  END AS [Enabled]          
     FROM  VEND000Master (NOLOCK) vm         
  LEFT Join [VEND040DCLocations] (NOLOCK) vdc   ON vdc.VdcVendorID = vm.Id AND vdc.StatusId  IN( 1,2)                  
  WHERE vm.StatusId  IN( 1,2)  AND  vm.VendOrgId = @orgId         
       AND NOT EXISTS             
           (SELECT PvlVendorID,PvlLocationCode  FROM [dbo].[PRGRM051VendorLocations] t2               
            WHERE t2.PvlProgramID = @programId  AND t2.StatusId IN (1,2)                 
                AND  vdc.VdcVendorID=t2.PvlVendorID              
                AND  vdc.VdcLocationCode = t2.PvlLocationCode )     
   
   END        
   ELSE        
   BEGIN        
       SELECT  vdc.Id  AS Id        
          ,vm.Id AS ParentId        
    --,vdc.VdcLocationCode  AS Name        
 ,CAST(vm.Id AS VARCHAR) + '_'+CAST(vdc.Id AS VARCHAR) As Name     
    ,vdc.VdcLocationCode + COALESCE( '('+VdcLocationTitle+')', '')  as [Text]        
    ,vdc.VdcLocationCode + COALESCE( '('+VdcLocationTitle+')', '')  as [ToolTip]       
 ,CAST(1 AS BIT) As IsLeaf     
  ,CAST(1 AS BIT) As [Enabled]   
    --,CASE WHEN (vm.[VendCorporateAddressId] IS NULL AND vm.[VendBusinessAddressId] IS NULL AND vm.[VendWorkAddressId] IS NULL) THEN CAST(0 AS BIT)        
    --          ELSE CAST(0 AS BIT) END AS [Enabled]          
     FROM  VEND000Master (NOLOCK) vm         
  Left Join [VEND040DCLocations] (NOLOCK) vdc ON vdc.VdcVendorID = vm.Id AND vdc.StatusId IN( 1,2)              
  WHERE vm.StatusId  IN( 1,2) AND vdc.VdcVendorID = @parentId         
      AND NOT EXISTS             
           (SELECT PvlVendorID,PvlLocationCode  FROM [dbo].[PRGRM051VendorLocations] t2               
            WHERE t2.PvlProgramID = @programId   
       AND  t2.PvlVendorID = @parentId  
       AND t2.StatusId IN (1,2)                 
                AND  vdc.VdcVendorID=t2.PvlVendorID              
                AND  vdc.VdcLocationCode = t2.PvlLocationCode )    
   ORDER BY  vdc.VdcLocationCode      
   END        
END        
                
END TRY                              
BEGIN CATCH                              
                              
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                  
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                  
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                  
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                  
                              
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetAssignUnassignVendorLocationsProgram]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Janardana         
-- Create date:               09/15/2018      
-- Description:               Get all Cost rates under the specified program 
-- Execution:                 EXEC [dbo].[GetAssignUnassignVendorLocationsProgram]   
-- Modified on:  
-- Modified Desc:  
-- =============================================                             
ALTER PROCEDURE [dbo].[GetAssignUnassignVendorLocationsProgram] 
	 @orgId BIGINT,      
	 @parentId BIGINT = NULL,  
	 @programId BIGINT,        
	 @isChild BIT                    
AS                              
BEGIN TRY                   
    SET NOCOUNT ON;                 
  
  IF @isChild = 0
  BEGIN
      SELECT vm.Id  AS Id        
       ,NULL  AS ParentId        
       ,'0_'+CAST(vm.Id AS VARCHAR) As Name     
       ,vm.VendCode + COALESCE( '('+VendTitle+')', '')  as [Text]        
       ,vm.VendCode + COALESCE( '('+VendTitle+')', '')  as [ToolTip]  
	   ,CASE WHEN (vm.[VendCorporateAddressId] IS NULL AND vm.[VendBusinessAddressId] IS NULL AND vm.[VendWorkAddressId] IS NULL) THEN CAST(0 AS BIT)        
            ELSE CAST(1 AS BIT) END AS [Enabled]  
	   --,CASE  WHEN  vm.Id = PvlVendorID THEN CAST(1 AS BIT) ELSE CAST(0 AS BIT) END As Assigned
	    ,CASE WHEN  vdc.VdcLocationCode = pvl.PvlLocationCode THEN CAST(1 AS BIT) ELSE CAST(0 AS BIT) END As Assigned 
         
  FROM VEND000Master (NOLOCK) vm    
  LEFT JOIN PRGRM051VendorLocations pvl ON vm.Id = pvl.PvlVendorID AND pvl.PvlProgramID = @programId AND pvl.StatusId  IN( 1,2) 
  LEFT JOIN [VEND040DCLocations] vdc ON vdc.vdcvendorId = vm.id
  WHERE vm.StatusId  IN( 1,2)    AND vm.VendOrgId =  @orgId
  ORDER BY  vm.VendCode

  END
  ELSE
  BEGIN
     SELECT vdc.Id  AS Id        
           ,vdc.VdcVendorID AS ParentId 
           ,CAST(vdc.VdcVendorID AS VARCHAR) + '_'+CAST(vdc.Id AS VARCHAR) As Name     
           ,vdc.VdcLocationCode + COALESCE( '('+VdcLocationTitle+')', '')  as [Text]        
           ,vdc.VdcLocationCode + COALESCE( '('+VdcLocationTitle+')', '')  as [ToolTip]       
           ,CAST(1 AS BIT) As IsLeaf     
          ,CASE WHEN (vm.[VendCorporateAddressId] IS NULL AND vm.[VendBusinessAddressId] IS NULL AND vm.[VendWorkAddressId] IS NULL) THEN CAST(0 AS BIT)        
            ELSE CAST(1 AS BIT) END AS [Enabled]    
			
        ,CASE WHEN  vdc.VdcLocationCode = pvl.PvlLocationCode THEN CAST(1 AS BIT) ELSE CAST(0 AS BIT) END As Assigned 
     FROM  [VEND040DCLocations] (NOLOCK) vdc       
  Join  VEND000Master (NOLOCK) vm     ON vdc.VdcVendorID = vm.Id   
  LEFT JOIN [PRGRM051VendorLocations] (NOLOCK) pvl ON vdc.VdcLocationCode =   pvl.PvlLocationCode    AND pvl.StatusId in(1,2)AND pvl.PvlProgramID = @programId  
  
                
  WHERE vm.StatusId  IN( 1,2) AND vdc.VdcVendorID = @parentId   


  END
                
END TRY                              
BEGIN CATCH                              
                              
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                  
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                  
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                  
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                  
                              
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetAttachment]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Janardana         
-- Create date:               11/11/2018      
-- Description:               Get a Attachment
-- Execution:                 EXEC [dbo].[GetAttachment]   
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)   
-- Modified Desc:  
-- ============================================= 
ALTER PROCEDURE  [dbo].[GetAttachment]
    @userId BIGINT,
    @roleId BIGINT,
	@orgId BIGINT,
    @id BIGINT
AS
BEGIN TRY                
 SET NOCOUNT ON;   
  SELECT att.[Id]
        ,att.[AttTableName]
        ,att.[AttPrimaryRecordID]
        ,att.[AttItemNumber]
        ,att.[AttTitle]
        ,att.[AttTypeId]
        ,att.[AttFileName]
        ,att.[AttData]
        ,att.[DateEntered]
        ,att.[EnteredBy]
        ,att.[DateChanged]
        ,att.[ChangedBy]
        ,att.[AttDownloadDate]
        ,att.[AttDownloadedDate]
        ,att.[AttDownloadedBy]
        
  FROM [dbo].[SYSTM020Ref_Attachments] att
 WHERE [Id] = @id
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetAttachmentView]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Janardana         
-- Create date:               11/10/2018      
-- Description:               Get all attachemnets for particular module and record
-- Execution:                 EXEC [dbo].[GetAttachmentView]   
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)   
-- Modified Desc:  
-- ============================================= 
ALTER PROCEDURE [dbo].[GetAttachmentView]
	 @userId BIGINT,
	 @roleId BIGINT,
	 @orgId BIGINT,
	 @entity NVARCHAR(100),
	 @pageNo INT,
	 @pageSize INT,
	 @orderBy NVARCHAR(500),
	 @groupBy NVARCHAR(500), 
	 @groupByWhere NVARCHAR(500), 
	 @where NVARCHAR(500),
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
 SET @TCountQuery = 'SELECT @TotalCount = COUNT(Id) FROM [dbo].[SYSTM020Ref_Attachments] (NOLOCK) '+ @entity +' WHERE '+ @entity +'.AttPrimaryRecordID= @parentId AND ISNULL(StatusId,1) IN (1,2)  ' + ISNULL(@where, '') ;
  
 EXEC sp_executesql @TCountQuery, N'@parentId BIGINT,  @TotalCount INT OUTPUT', @parentId,  @TotalCount  OUTPUT;

SET @sqlCommand = 'SELECT ' + [dbo].[fnGetBaseQueryByUserId](@entity, @userId) 

SET @sqlCommand = @sqlCommand + ' FROM [dbo].[SYSTM020Ref_Attachments] (NOLOCK) '+ @entity

SET @sqlCommand = @sqlCommand + ' WHERE '+@entity+'.[AttPrimaryRecordID] = @parentId AND  ISNULL(StatusId,1) IN (1,2)'+ ISNULL(@where, '') + 
	' ORDER BY '+ ISNULL(@orderBy, @entity+'.AttItemNumber') + 
	' OFFSET @pageSize * (@pageNo - 1) ROWS FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);' 

EXEC sp_executesql @sqlCommand, N'@pageNo INT, @pageSize INT, @orderBy NVARCHAR(500), @where NVARCHAR(500), @parentId BIGINT, @entity NVARCHAR(100)' ,
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
/****** Object:  StoredProcedure [dbo].[GetByteArrayByIdAndEntity]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group  
   All Rights Reserved Worldwide */  
-- =============================================          
-- Author:                    Akhil           
-- Create date:               12/16/2018        
-- Description:               Get selected records by table  
-- Execution:                 EXEC [dbo].[GetByteArrayByIdAndEntity]     
-- Modified on:    
-- Modified Desc:    
-- =============================================                          
ALTER PROCEDURE [dbo].[GetByteArrayByIdAndEntity]  
	 @recordId BIGINT,  
	 @entity NVARCHAR(100),  
	 @fields NVARCHAR(2000)  
AS                  
BEGIN TRY                  
SET NOCOUNT ON;    
 DECLARE @sqlCommand NVARCHAR(MAX);  
DECLARE @tableName NVARCHAR(100)  
SELECT @tableName = [TblTableName] FROM [dbo].[SYSTM000Ref_Table] Where SysRefName = @entity  

DECLARE @primaryKeyName NVARCHAR(50);                                          
	SET  @primaryKeyName = CASE @entity 
	WHEN 'ScrOsdList' THEN 'OSDID' 
	WHEN 'ScrOsdReasonList' THEN 'ReasonID' 
	WHEN 'ScrRequirementList' THEN 'RequirementID'
	WHEN 'ScrReturnReasonList' THEN 'ReturnReasonID'
	WHEN 'ScrServiceList' THEN 'ServiceID'
	ELSE 'Id' END;

SET @sqlCommand = 'SELECT '+ @fields +' FROM '+ @tableName + ' (NOLOCK) '+  @entity + ' WHERE '+ @entity +'.'+@primaryKeyName+' = @recordId'  

EXEC sp_executesql @sqlCommand, N'@recordId BIGINT',  
  @recordId = @recordId  
END TRY                  
BEGIN CATCH                  
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                  
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                  
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                  
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                  
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetColumnAlias]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               08/16/2018      
-- Description:               Get a Sys Column alias
-- Execution:                 EXEC [dbo].[GetColumnAlias]   
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)   
-- Modified Desc:  
-- ============================================= 
ALTER PROCEDURE  [dbo].[GetColumnAlias]
    @userId BIGINT,
    @roleId BIGINT,
	@orgId BIGINT,
    @langCode NVARCHAR(10),
    @id BIGINT
AS
BEGIN TRY                
 SET NOCOUNT ON; 
 
 SELECT cal.[Id]
      ,cal.[LangCode]
      ,cal.[ColTableName]
      ,cal.[ColColumnName]
      ,cal.[ColAliasName]
      ,cal.[ColCaption]
      ,cal.[ColDescription]
      ,cal.[ColSortOrder]
      ,cal.[ColIsReadOnly]
      ,cal.[ColIsVisible]
      ,cal.[ColIsDefault]
	  ,cal.[StatusId]
  FROM [dbo].[SYSTM000ColumnsAlias] cal
 WHERE cal.[Id]=@id  AND cal.LangCode=@langCode
 
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetColumnAliasesByTableName]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
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
    ,CASE WHEN c.name IN (SELECT ColumnName FROM dbo.fnGetRefOptionsFK(@tableName)) THEN 'dropdown' WHEN c.name IN (SELECT ColumnName FROM dbo.fnGetModuleFK(@tableName)) THEN 'name' ELSE CASE WHEN ISNULL(t.Name, '') = '' THEN 'nvarchar' ELSE t.Name END END  as 'DataType'    
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
  LEFT JOIN dbo.fnGetModuleFK(@tableName) fgmk ON cal.ColColumnName = fgmk.ColumnName  
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
 SET [ColDisplayFormat] = (SELECT [SysDateFormat] From dbo.SYSTM000Ref_Settings)  
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
/****** Object:  StoredProcedure [dbo].[GetColumnAliasesByUserAndTbl]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               04/14/2018      
-- Description:               Get all ColumnAliases By Table Name
-- Execution:                 EXEC [dbo].[GetColumnAliasesByUserAndTbl]   
-- Modified on:  
-- Modified Desc:  
-- ============================================= 
ALTER PROCEDURE [dbo].[GetColumnAliasesByUserAndTbl]
	@userId INT,
	@tableName NVARCHAR(100)
AS                
BEGIN TRY                
 SET NOCOUNT ON;   
	  SELECT  cal.[ColTableName]
			 ,cal.[ColSortOrder]
			 ,cal.[ColNotVisible]
			 ,cal.[ColIsFreezed]
			 ,cal.[ColIsDefault]
			 ,cal.[ColGroupBy]
			 ,cal.[ColGridLayout]
	 FROM [dbo].[SYSTM000ColumnSettingsByUser] (NOLOCK) cal
	 WHERE cal.ColUserId= @userId AND cal.[ColTableName] = @tableName 
END TRY                
BEGIN CATCH                
	DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
			,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
			,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 
	EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetColumnAliasesDropDown]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group      
   All Rights Reserved Worldwide */      
-- =============================================              
-- Author:                    Akhil Chauhan               
-- Create date:               12/29/2018            
-- Description:               Get Column Aliases Drop down      
-- Execution:                 EXEC [dbo].[GetColumnAliasesDropDown]        
-- Modified on:        
-- Modified Desc:        
-- =============================================         
ALTER PROCEDURE  [dbo].[GetColumnAliasesDropDown]  
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
	 @primaryKeyName NVARCHAR(50) = null          
AS        
BEGIN TRY                        
SET NOCOUNT ON;          
  

--DECLARE  @langCode NVARCHAR(10) = 'EN'
--DECLARE  @orgId BIGINT = 1  ;      
--DECLARE  @entity NVARCHAR(100) = 'ColumnAlias'       
--DECLARE  @fields NVARCHAR(2000)=''      
--DECLARE  @pageNo INT =1    
--DECLARE  @pageSize INT =10       
--DECLARE  @orderBy NVARCHAR(500)=   'ColumnAlias.ColSortOrder'       
--DECLARE  @like NVARCHAR(500) = 'ConB'       
--DECLARE  @where NVARCHAR(500) = 'Contact'    
--DECLARE  @primaryKeyValue NVARCHAR(100) = null     
--DECLARE  @primaryKeyName NVARCHAR(50) = null     

  
  
DECLARE @colAliasTable TABLE  
(  
 Id BIGINT,  
 ColColumnName NVARCHAR(100),  
 ColAliasName NVARCHAR(100),  
 ColCaption NVARCHAR(100),  
 ColLookupId INT,  
 ColLookupCode NVARCHAR(100),  
 DataType NVARCHAR(100),  
 [MaxLength] INT  
)  
  
  
INSERT INTO @colAliasTable  
select DISTINCT ISNULL(ColumnAlias.Id,0) as Id,  
ISNULL(ColumnAlias.ColColumnName,cols.COLUMN_NAME) as ColColumnName,  
ISNULL(ColumnAlias.ColAliasName,cols.COLUMN_NAME) as ColAliasName,  
ISNULL(ColumnAlias.ColCaption,cols.COLUMN_NAME) as ColCaption ,  
ColumnAlias.ColLookupId,  
ColumnAlias.ColLookupCode,  
cols.Data_Type as DataType,  
CASE WHEN c.precision >  c.max_length THEN c.precision WHEN  c.max_length>200 THEN (c.max_length)/10  ELSE (c.max_length)/2 END as [MaxLength]   
  
from INFORMATION_SCHEMA.TABLES tabs  
INNER JOIN INFORMATION_SCHEMA.COLUMNS cols On tabs.TABLE_NAME = cols.TABLE_NAME  
INNER JOIN [dbo].[SYSTM000Ref_Table] (NOLOCK) tbl ON tabs.TABLE_NAME = tbl.TblTableName   
LEFT JOIN SYSTM000ColumnsAlias (NOLOCK) ColumnAlias ON  cols.COLUMN_NAME = ColumnAlias.ColColumnName AND tbl.SysRefName = ColumnAlias.ColTableName  AND ColumnAlias.[LangCode] = @langCode AND ColumnAlias.StatusId=1   
INNER JOIN sys.types t ON cols.DATA_TYPE = t.name  
INNER JOIN sys.columns c ON  c.name  = cols.COLUMN_NAME  AND c.user_type_id = t.user_type_id   
WHERE   tbl.SysRefName = @where  

  
INSERT INTO @colAliasTable  
  
  
SELECT colAlias.Id,colAlias.ColColumnName,colAlias.ColAliasName,colAlias.ColCaption,colAlias.ColLookupId,colAlias.ColLookupCode ,  
'nvarchar',  
999   
FROM SYSTM000ColumnsAlias colAlias  
  
WHERE ColTablename=@where AND colAlias.StatusId =1 AND  colAlias.ColColumnName NOT IN (SELECT ColColumnName FROM @colAliasTable);  
  
SELECT * FROM @colAliasTable   

WHERE ColColumnName Like '%'+@like+'%'
     OR ColColumnName Like '%'+@like+'%' 
     OR ColAliasName Like '%'+@like+'%' 
     OR ColCaption Like '%'+@like+'%' 
     --OR ColLookupId Like '%'+@like+'%' 
     OR ColLookupCode Like '%'+@like+'%' 
     OR DataType Like '%'+@like+'%' 
     OR [MaxLength] Like '%'+@like+'%' 


ORDER BY Id OFFSET @pageSize * (@pageNo - 1) ROWS FETCH NEXT @pageSize ROWS ONLY OPTION (RECOMPILE);  
   
  
       
END TRY                        
BEGIN CATCH                        
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                        
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                        
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                        
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                        
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetColumnAliasView]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               04/14/2018      
-- Description:               Get all Column Aliases
-- Execution:                 EXEC [dbo].[GetColumnAliasView]  
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)   
-- Modified Desc:  
-- =============================================     
ALTER PROCEDURE [dbo].[GetColumnAliasView]    
	@userId INT,    
	@roleId BIGINT,    
	@orgId BIGINT,    
	@langCode NVARCHAR(10),    
	@entity NVARCHAR(100),    
	@pageNo INT,    
	@pageSize INT,    
	@orderBy NVARCHAR(500), 
	@groupBy NVARCHAR(500), 
	@groupByWhere NVARCHAR(500),    
	@where NVARCHAR(500),    
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
    
 SET @TCountQuery = 'SELECT @TotalCount = COUNT('+ @entity + '.Id) FROM [dbo].[SYSTM000ColumnsAlias] '+ @entity + ' WHERE '+ @entity + '.LangCode = @langCode ' + ISNULL(@where, '') ;
 
 EXEC sp_executesql @TCountQuery, N'@langCode NVARCHAR(10), @TotalCount INT OUTPUT',@langCode ,@TotalCount  OUTPUT;    
     
 IF(@recordId = 0)    
  BEGIN    
   SET @sqlCommand = 'SELECT ' + [dbo].[fnGetBaseQueryByUserId](@entity, @userId)     
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
    
 SET @sqlCommand = @sqlCommand + ' FROM [dbo].[SYSTM000ColumnsAlias] (NOLOCK) '+ @entity    
 SET @sqlCommand = @sqlCommand + ' WHERE '+@entity+'.[LangCode] = @langCode '+ ISNULL(@where, '')    
    
 IF((@recordId > 0) AND (((@isNext = 0) AND (@isEnd = 0)) OR ((@isNext = 1) AND (@isEnd = 0))))    
 BEGIN    
  IF((@isNext = 0) AND (@isEnd = 0))  
   BEGIN  
	IF(ISNULL(@orderBy, '') <> '')
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND ' + @orderBy + ' <= (SELECT ' + @orderBy + ' FROM [dbo].[SYSTM000ColumnsAlias] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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
		SET @sqlCommand = @sqlCommand + ' AND ' + @orderBy + ' >= (SELECT ' + @orderBy + ' FROM [dbo].[SYSTM000ColumnsAlias] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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
    
 EXEC sp_executesql @sqlCommand, N'@pageNo INT, @pageSize INT, @langCode NVARCHAR(10), @entity NVARCHAR(100), @orderBy NVARCHAR(500), @where NVARCHAR(500),@userId BIGINT' ,    
     @langCode= @langCode,    
     @entity= @entity,    
     @pageNo= @pageNo,     
     @pageSize= @pageSize,    
     @orderBy = @orderBy,    
     @where = @where,    
     @userId = @userId    
     
END TRY                    
BEGIN CATCH                    
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                    
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                    
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                    
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                    
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetComboBoxContacts]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               10/15/2018      
-- Description:               Get Contacts by Owner
-- Execution:                 EXEC [dbo].[GetComboBoxContacts]  
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)   
-- Modified Desc:  
-- ============================================= 
ALTER PROCEDURE [dbo].[GetComboBoxContacts]
	@userId BIGINT,
	@roleId BIGINT,
	@orgId BIGINT,
	@entity NVARCHAR(100),
	@pageNo INT=1,
	@pageSize INT=10,
	@orderBy NVARCHAR(500),
	@where NVARCHAR(500),
	@parentId BIGINT,
	@custId BIGINT,
	@vendId BIGINT,
	@progId BIGINT,
	@jobId BIGINT,
	@contactId BIGINT,
	@TotalCount INT OUTPUT
AS
BEGIN TRY                
 SET NOCOUNT ON;  
 DECLARE @sqlCommand NVARCHAR(MAX);
 
SELECT @TotalCount = COUNT(Id) FROM [dbo].[CONTC000Master]
SET @sqlCommand = 'SELECT ' + [dbo].[fnGetBaseQueryByUserId](@entity, @userId) 
SET @sqlCommand = @sqlCommand + ' FROM [dbo].[CONTC000Master] (NOLOCK) '+ @entity
SET @sqlCommand = @sqlCommand + ' WHERE '+ ISNULL(@where, '1=1') + 
	' ORDER BY '+ ISNULL(@orderBy, @entity+'.Id') + 
	' OFFSET @pageSize * (@pageNo - 1) ROWS FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);'  

EXEC sp_executesql @sqlCommand, N'@pageNo INT, @pageSize INT,@orderBy NVARCHAR(500), @where NVARCHAR(500), @orgId BIGINT, @entity NVARCHAR(100)' ,
	 @entity= @entity,
     @pageNo= @pageNo, 
     @pageSize= @pageSize,
     @orderBy = @orderBy,
     @where = @where,
	 @orgId = @orgId
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetContact]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               08/16/2018      
-- Description:               Get a contact
-- Execution:                 EXEC [dbo].[GetContact] 
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)    
-- Modified Desc:  
-- ============================================= 
ALTER PROCEDURE  [dbo].[GetContact]
    @userId BIGINT,
    @roleId BIGINT,
	@orgId BIGINT,
    @id BIGINT
AS
BEGIN TRY                
 SET NOCOUNT ON;   
  SELECT con.[Id]
      ,con.[ConERPId]
      ,con.[ConCompany]
      ,con.[ConTitleId]
      ,con.[ConLastName]
      ,con.[ConFirstName]
      ,con.[ConMiddleName]
      ,con.[ConEmailAddress]
      ,con.[ConEmailAddress2]
      ,con.[ConImage]
      ,con.[ConJobTitle]
      ,con.[ConBusinessPhone]
      ,con.[ConBusinessPhoneExt]
      ,con.[ConHomePhone]
      ,con.[ConMobilePhone]
      ,con.[ConFaxNumber]
      ,con.[ConBusinessAddress1]
      ,con.[ConBusinessAddress2]
      ,con.[ConBusinessCity]
      ,con.[ConBusinessStateId]
      ,con.[ConBusinessZipPostal]
      ,con.[ConBusinessCountryId]
      ,con.[ConHomeAddress1]
      ,con.[ConHomeAddress2]
      ,con.[ConHomeCity]
      ,con.[ConHomeStateId]
      ,con.[ConHomeZipPostal]
      ,con.[ConHomeCountryId]
      ,con.[ConAttachments]
      ,con.[ConWebPage]
      ,con.[ConNotes]
      ,con.[StatusId]
      ,con.[ConTypeId]
      ,con.[ConFullName]
      ,con.[ConFileAs]
      ,con.[ConOutlookId]
	  ,con.[ConUDF01]
	  ,states.StateAbbr as [ConBusinessStateIdName]
	  ,country.SysOptionName as [ConBusinessCountryIdName]
      ,con.[DateEntered]
      ,con.[EnteredBy]
      ,con.[DateChanged]
      ,con.[ChangedBy]
   FROM [dbo].[CONTC000Master] con
   LEFT JOIN [dbo].[SYSTM000Ref_Options] country ON con.ConBusinessCountryId = country.Id
   LEFT JOIN [dbo].[SYSTM000Ref_States] states ON con.ConBusinessStateId = states.Id
   WHERE con.[Id] = @id
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetContactByOwner]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               09/15/2018      
-- Description:               Get Contacts by Owner
-- Execution:                 EXEC [dbo].[GetContactByOwner] 
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)    
-- Modified Desc:  
-- ============================================= 
ALTER PROCEDURE [dbo].[GetContactByOwner]
 @userId BIGINT,
 @roleId BIGINT,
 @orgId BIGINT,
 @custId BIGINT,
 @vendId BIGINT,
 @progId BIGINT,
 @jobId BIGINT,
 @contactId BIGINT
AS
BEGIN TRY                
 SET NOCOUNT ON;  
 DECLARE @sqlCommand NVARCHAR(MAX);
 
SELECT TOP 1 * FROM [dbo].[CONTC000Master] (NOLOCK) WHERE Id = @contactId 

END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetContactCombobox]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Janardana Behara        
-- Create date:               05/29/2018      
-- Description:               Get selected records by table  
-- Execution:                 EXEC [dbo].[GetContactCombobox]   
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)    
-- Modified Desc:  
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
 @entityFor NVARCHAR(50) = null
AS                  
BEGIN TRY                  
SET NOCOUNT ON;    
 DECLARE @sqlCommand NVARCHAR(MAX); 
 DECLARE @newPgNo INT

 SET @sqlCommand = '';

 IF( @entityFor = 'PPPRespGateway' OR @entityFor = 'PPPJobRespContact' OR @entityFor = 'PPPJobAnalystContact' OR @entityFor = 'PPPRoleCodeContact')
 BEGIN
  EXEC [dbo].[GetPPPGatewayContactCombobox]  @langCode,@orgId,@entity,@fields,@pageNo,@pageSize,@orderBy,@like,@where,@primaryKeyValue,@primaryKeyName,@parentId,@entityFor
 END
 ELSE
 BEGIN

	 IF(ISNULL(@primaryKeyValue, '') <> '')
	 BEGIN
		SET @sqlCommand += ' SELECT @newPgNo = Item FROM (SELECT ROW_NUMBER() OVER(ORDER BY ' + @entity + '.' + @primaryKeyName+') as Item  ,' +@entity + '.' + @primaryKeyName + 
						   ' From [dbo].[CONTC000Master] (NOLOCK)  ' + @entity;
	
		SET @sqlCommand = @sqlCommand + ' WHERE (ISNULL('+ @entity +'.StatusId, 1) In (1,2)  OR ' + @primaryKeyName + '=' + @primaryKeyValue + ')';
	    
	
		SET @sqlCommand += ' ) t WHERE t.' + @primaryKeyName + '=' + @primaryKeyValue;
		
		EXEC sp_executesql @sqlCommand, N' @newPgNo int output',@newPgNo output                                    
		SET @newPgNo =  @newPgNo/@pageSize + 1; 
		SET @pageSize = @newPgNo * @pageSize;
		SET @sqlCommand=''
	 END

	 SET @sqlCommand += 'SELECT '+ @fields +' From [dbo].[CONTC000Master] (NOLOCK) '+  @entity + ' WHERE 1=1 '  
	 
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
	  SET @sqlCommand = @sqlCommand + 'AND ('  
	   DECLARE @likeStmt NVARCHAR(MAX)  
  
	  SELECT @likeStmt = COALESCE(@likeStmt + ' OR ','') + Item + ' LIKE ''%' + @like + '%' + '''' FROM [dbo].[fnSplitString](@fields, ',')    
	  SET @sqlCommand = @sqlCommand + @likeStmt + ') '  
	  END  
	 IF(ISNULL(@where, '') != '')  
	  BEGIN  
		 SET @sqlCommand = @sqlCommand + @where   
	 END  
  
	SET @sqlCommand = @sqlCommand + ' ORDER BY '+ @fields +' OFFSET @pageSize * (@pageNo - 1) ROWS FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);'   
 
	EXEC sp_executesql @sqlCommand, N'@pageNo INT, @pageSize INT, @where NVARCHAR(100)' ,  
		 @pageNo = @pageNo,   
		 @pageSize = @pageSize,  
		 @where = @where

END
END TRY                  
BEGIN CATCH                  
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                  
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                  
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                  
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                  
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetContactView]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               09/04/2018      
-- Description:               Get all contact view
-- Execution:                 EXEC [dbo].[GetContactView]
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)   
-- Modified Desc:  
-- ============================================= 
ALTER PROCEDURE [dbo].[GetContactView]
 @userId BIGINT,
 @roleId BIGINT,
 @orgId BIGINT,
 @entity NVARCHAR(100),
 @pageNo INT,
 @pageSize INT,
 @orderBy NVARCHAR(500),
 @groupBy NVARCHAR(500), 
 @groupByWhere NVARCHAR(500), 
 @where NVARCHAR(500),
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

SET @TCountQuery = 'SELECT @TotalCount = COUNT(Id) FROM [dbo].[CONTC000Master] (NOLOCK) '+ @entity

--Below for getting user specific 'Statuses'
IF((ISNULL(@where, '') = '') OR (@where NOT LIKE '%'+@entity+'.StatusId%'))
	BEGIN
		SET @TCountQuery = @TCountQuery + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) fgus ON ISNULL(' + @entity + '.[StatusId], 1) = fgus.[StatusId] '
	END

SET @TCountQuery = @TCountQuery +' WHERE 1=1 ' + ISNULL(@where, '')

EXEC sp_executesql @TCountQuery, N'@userId BIGINT, @TotalCount INT OUTPUT', @userId , @TotalCount  OUTPUT;

IF(@recordId = 0)
	BEGIN
		SET @sqlCommand = 'SELECT ' + [dbo].[fnGetBaseQueryByUserId](@entity, @userId) 
		SET @sqlCommand = @sqlCommand + ' , sts1.[StateAbbr] AS ConBusinessStateIdName, sts2.[StateAbbr] AS ConHomeStateIdName '
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

SET @sqlCommand = @sqlCommand + ' FROM [dbo].[CONTC000Master] (NOLOCK) '+ @entity

--Below to get State reference key name by Id if NOT NULL
SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[SYSTM000Ref_States] (NOLOCK) sts1 ON ' + @entity + '.[ConBusinessStateId]=sts1.[Id] '
SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[SYSTM000Ref_States] (NOLOCK) sts2 ON ' + @entity + '.[ConHomeStateId]=sts2.[Id] '

--Below for getting user specific 'Statuses'
IF((ISNULL(@where, '') = '') OR (@where NOT LIKE '%'+@entity+'.StatusId%'))
	BEGIN
		SET @sqlCommand = @sqlCommand + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) hfk ON ISNULL(' + @entity + '.[StatusId], 1) = hfk.[StatusId] '
	END

SET @sqlCommand = @sqlCommand + ' WHERE 1=1 '+ ISNULL(@where, '')

IF((@recordId > 0) AND (((@isNext = 0) AND (@isEnd = 0)) OR ((@isNext = 1) AND (@isEnd = 0))))
	BEGIN
		IF((@isNext = 0) AND (@isEnd = 0))  
	    BEGIN  
	 	IF(ISNULL(@orderBy, '') <> '')
	 	 BEGIN
	 		SET @sqlCommand = @sqlCommand + ' AND ' + @orderBy + ' <= (SELECT ' + @orderBy + ' FROM [dbo].[CONTC000Master] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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
	 		SET @sqlCommand = @sqlCommand + ' AND ' + @orderBy + ' >= (SELECT ' + @orderBy + ' FROM [dbo].[CONTC000Master] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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

EXEC sp_executesql @sqlCommand, N'@pageNo INT, @pageSize INT,@orderBy NVARCHAR(500), @where NVARCHAR(500), @entity NVARCHAR(100),@userId BIGINT' ,
	 @entity= @entity,
     @pageNo= @pageNo, 
     @pageSize= @pageSize,
     @orderBy = @orderBy,
     @where = @where,
	 @userId = @userId
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetCustBusinessTerm]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               08/16/2018      
-- Description:               Get a cust business term 
-- Execution:                 EXEC [dbo].[GetCustBusinessTerm]
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)    
-- Modified Desc:  
-- =============================================
ALTER PROCEDURE  [dbo].[GetCustBusinessTerm]
    @userId BIGINT,
    @roleId BIGINT,
	@orgId BIGINT,
    @langCode NVARCHAR(10),
    @id BIGINT
AS
BEGIN TRY                
 SET NOCOUNT ON;   
 SELECT cust.[Id]
	   ,cust.[LangCode]
	   ,cust.[CbtOrgID]
	   ,cust.[CbtCustomerId]
	   ,cust.[CbtItemNumber]
	   ,cust.[CbtCode]
	   ,cust.[CbtTitle]
	   ,cust.[BusinessTermTypeId]
	   ,cust.[CbtActiveDate]
	   ,cust.[CbtValue]
	   ,cust.[CbtHiThreshold]
	   ,cust.[CbtLoThreshold]
	   ,cust.[CbtAttachment]
	   ,cust.[StatusId]
	   ,cust.[EnteredBy]
	   ,cust.[DateEntered]
	   ,cust.[ChangedBy]
	   ,cust.[DateChanged]
   FROM [dbo].[CUST020BusinessTerms] cust
  WHERE [Id]=@id 
  --AND cust.[LangCode]= @langCode
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetCustBusinessTermView]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group  
   All Rights Reserved Worldwide */  
-- =============================================          
-- Author:                    Akhil Chauhan           
-- Create date:               04/14/2018        
-- Description:               Get all customer business term  
-- Execution:                 EXEC [dbo].[GetCustBusinessTermView]  
-- Modified on:              04/25/2018
-- Modified Desc:           Removed langCode Filter 
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)  
-- =============================================  
ALTER PROCEDURE [dbo].[GetCustBusinessTermView]  
 @userId BIGINT,  
 @roleId BIGINT,  
 @orgId BIGINT,  
 @langCode NVARCHAR(10),  
 @entity NVARCHAR(100),  
 @pageNo INT,  
 @pageSize INT,  
 @orderBy NVARCHAR(500), 
 @groupBy NVARCHAR(500), 
 @groupByWhere NVARCHAR(500),  
 @where NVARCHAR(500),  
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
  
SET @TCountQuery = 'SELECT @TotalCount = COUNT(Id) FROM [dbo].[CUST020BusinessTerms] (NOLOCK) '+ @entity   
  
--Below for getting user specific 'Statuses'  
IF((ISNULL(@where, '') = '') OR (@where NOT LIKE '%'+@entity+'.StatusId%'))  
 BEGIN  
  SET @TCountQuery = @TCountQuery + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) fgus ON ' + @entity + '.[StatusId] = fgus.[StatusId] '  
 END  
  
SET @TCountQuery = @TCountQuery + ' WHERE [CbtOrgId] = @orgId AND [CbtCustomerId] = @parentId ' + ISNULL(@where, '')  
  
EXEC sp_executesql @TCountQuery, N' @orgId BIGINT, @parentId BIGINT, @userId BIGINT, @TotalCount INT OUTPUT',  @orgId, @parentId, @userId, @TotalCount  OUTPUT;  
  
IF(@recordId = 0)  
 BEGIN  
  SET @sqlCommand = 'SELECT ' + [dbo].[fnGetBaseQueryByUserId](@entity, @userId)   
  SET @sqlCommand = @sqlCommand + ' ,org.[OrgCode] AS CbtOrgIDName, cust.[CustCode] AS CbtCustomerIdName '  
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
  
 SET @sqlCommand = @sqlCommand + ' FROM [dbo].[CUST020BusinessTerms] (NOLOCK) '+ @entity  
  
--Below to get BIGINT reference key name by Id if NOT NULL  
SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[ORGAN000Master] (NOLOCK) org ON ' + @entity + '.[CbtOrgID]=org.[Id] '  
SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[CUST000Master] (NOLOCK) cust ON ' + @entity + '.[CbtCustomerId]=cust.[Id] '  
  
--Below for getting user specific 'Statuses'  
IF((ISNULL(@where, '') = '') OR (@where NOT LIKE '%'+@entity+'.StatusId%'))  
 BEGIN  
  SET @sqlCommand = @sqlCommand + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) hfk ON ISNULL(' + @entity + '.[StatusId], 1) = hfk.[StatusId] '  
 END  
  
SET @sqlCommand = @sqlCommand + ' WHERE '+ @entity + '.[CbtCustomerId]=@parentId AND '  
SET @sqlCommand = @sqlCommand + @entity +'.[CbtOrgId] = @orgId '+ ISNULL(@where, '')  
  
  
IF((@recordId > 0) AND (((@isNext = 0) AND (@isEnd = 0)) OR ((@isNext = 1) AND (@isEnd = 0))))  
 BEGIN  
  IF((@isNext = 0) AND (@isEnd = 0))  
   BEGIN  
	IF(ISNULL(@orderBy, '') <> '')
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND ' + @orderBy + ' <= (SELECT ' + @orderBy + ' FROM [dbo].[CUST020BusinessTerms] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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
		SET @sqlCommand = @sqlCommand + ' AND ' + @orderBy + ' >= (SELECT ' + @orderBy + ' FROM [dbo].[CUST020BusinessTerms] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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
EXEC sp_executesql @sqlCommand, N'@pageNo INT, @pageSize INT, @entity NVARCHAR(100), @orderBy NVARCHAR(500), @where NVARCHAR(500), @orgId BIGINT, @parentId BIGINT,@userId BIGINT' ,  
    
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
/****** Object:  StoredProcedure [dbo].[GetCustContact]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               08/16/2018      
-- Description:               Get a Cust Contact
-- Execution:                 EXEC [dbo].[GetCustContact]
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)    
-- Modified Desc:  
-- =============================================
ALTER PROCEDURE  [dbo].[GetCustContact]
    @userId BIGINT,
    @roleId BIGINT,
	@orgId BIGINT,
    @id BIGINT
AS
BEGIN TRY                
 SET NOCOUNT ON;   
  SELECT cust.[Id]
      ,cust.[CustCustomerID]
      ,cust.[CustItemNumber]
      ,cust.[CustContactCode]
      ,cust.[CustContactTitle]
      ,cust.[CustContactMSTRID]
      ,cust.[StatusId]
      ,cust.[EnteredBy]
      ,cust.[DateEntered]
      ,cust.[ChangedBy]
      ,cust.[DateChanged]
  FROM [dbo].[CUST010Contacts] cust
 WHERE [Id]=@id
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetCustContactView]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               09/04/2018      
-- Description:               Get all customer contact
-- Execution:                 EXEC [dbo].[GetCustContactView]
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)   
-- Modified Desc:  
-- =============================================
ALTER PROCEDURE [dbo].[GetCustContactView]
 @userId BIGINT,
 @roleId BIGINT,
 @orgId BIGINT,
 @entity NVARCHAR(100),
 @pageNo INT,
 @pageSize INT,
 @orderBy NVARCHAR(500),
 @groupBy NVARCHAR(500), 
 @groupByWhere NVARCHAR(500), 
 @where NVARCHAR(500),
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

SET @TCountQuery = 'SELECT @TotalCount = COUNT(Id) FROM [dbo].[CUST010Contacts] (NOLOCK) '+ @entity 

--Below for getting user specific 'Statuses'
IF((ISNULL(@where, '') = '') OR (@where NOT LIKE '%'+@entity+'.StatusId%'))
	BEGIN
		SET @TCountQuery = @TCountQuery + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) fgus ON ' + @entity + '.[StatusId] = fgus.[StatusId] '
	END

SET @TCountQuery = @TCountQuery + ' WHERE [CustCustomerID] = @parentId ' + ISNULL(@where, '')

EXEC sp_executesql @TCountQuery, N'@parentId BIGINT, @userId BIGINT, @TotalCount INT OUTPUT', @parentId, @userId, @TotalCount  OUTPUT;

IF((ISNULL(@groupBy, '') = '') OR (@recordId > 0))
 BEGIN

	IF(@recordId = 0)
		BEGIN
			SET @sqlCommand = 'SELECT ' + [dbo].[fnGetBaseQueryByUserId](@entity, @userId) 
			SET @sqlCommand = @sqlCommand + ' , cust.[CustCode] AS CustCustomerIDName, cont.[ConFullName] AS CustContactMSTRIDName '
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
	
	SET @sqlCommand = @sqlCommand + ' FROM [dbo].[CUST010Contacts] (NOLOCK) '+ @entity
	
	--Below to get BIGINT reference key name by Id if NOT NULL
	SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[CUST000Master] (NOLOCK) cust ON ' + @entity + '.[CustCustomerID]=cust.[Id] '
	SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[CONTC000Master] (NOLOCK) cont ON ' + @entity + '.[CustContactMSTRID]=cont.[Id] '
	SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[SYSTM000Ref_States] (NOLOCK) sts ON cont.[ConBusinessStateId]=sts.[Id] '
	SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[SYSTM000Ref_Options] (NOLOCK) sysRef ON cont.[ConBusinessCountryId]=sysRef.[Id] '
	
	--Below for getting user specific 'Statuses'
	IF((ISNULL(@where, '') = '') OR (@where NOT LIKE '%'+@entity+'.StatusId%'))
		BEGIN
			SET @sqlCommand = @sqlCommand + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) fgus ON ISNULL(' + @entity + '.[StatusId], 1) = fgus.[StatusId] '
		END
	
	--Special case: Updating GroupByWhere if having ConBusinessFullAddress in this condition.
	SET @groupByWhere = REPLACE(@groupByWhere, @entity+'.ConBusinessFullAddress', '( coalesce(cont.[ConBusinessAddress1], '''') + coalesce(CHAR(13) + cont.[ConBusinessAddress2], '''') + coalesce(CHAR(13) + cont.[ConBusinessCity], '''') + CASE WHEN ((coalesce(cont.[ConBusinessAddress1], '''') <> '''') OR (coalesce(cont.[ConBusinessAddress2], '''') <> '''') OR (coalesce(cont.[ConBusinessCity], '''') <> '''')) THEN coalesce('', '' + sts.[StateAbbr], '''') ELSE coalesce('''' + sts.[StateAbbr], '''') END + coalesce('', '' + cont.[ConBusinessZipPostal], '''') + coalesce(CHAR(13) + sysRef.[SysOptionName], '''') )')

	SET @sqlCommand = @sqlCommand + ' WHERE 1=1 AND '+@entity+'.[CustCustomerID] = @parentId ' + ISNULL(@groupByWhere, '')  
	
	IF((@recordId > 0) AND (((@isNext = 0) AND (@isEnd = 0)) OR ((@isNext = 1) AND (@isEnd = 0))))
		BEGIN
			IF((@isNext = 0) AND (@isEnd = 0))  
	   BEGIN  
		IF(ISNULL(@orderBy, '') <> '')
		 BEGIN
			SET @sqlCommand = @sqlCommand + ' AND ' + @orderBy + ' <= (SELECT ' + @orderBy + ' FROM [dbo].[CUST010Contacts] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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
			SET @sqlCommand = @sqlCommand + ' AND ' + @orderBy + ' >= (SELECT ' + @orderBy + ' FROM [dbo].[CUST010Contacts] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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

	IF(@groupBy = (@entity + '.CustCustomerIDName'))
	 BEGIN
		SET @groupBy = ' cust.[CustCode] ';
		SET @SelectClauseToAdd = @SelectClauseToAdd + ' , cust.[CustCode] AS CustCustomerIDName ';
	 END
	ELSE IF(@groupBy = (@entity + '.CustContactMSTRIDName'))
	 BEGIN
		SET @groupBy = ' cont.[ConFullName] ';
		SET @SelectClauseToAdd = @SelectClauseToAdd + ' , cont.[ConFullName] AS CustContactMSTRIDName ';
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
	SET @sqlCommand = @sqlCommand + ' FROM [dbo].[CUST010Contacts] (NOLOCK) '+ @entity 
	SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[CUST000Master] (NOLOCK) cust ON ' + @entity + '.[CustCustomerID]=cust.[Id] '
	SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[CONTC000Master] (NOLOCK) cont ON ' + @entity + '.[CustContactMSTRID]=cont.[Id] '
	SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[SYSTM000Ref_States] (NOLOCK) sts ON cont.[ConBusinessStateId]=sts.[Id] '
	SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[SYSTM000Ref_Options] (NOLOCK) sysRef ON cont.[ConBusinessCountryId]=sysRef.[Id] '
	
	--Below for getting user specific 'Statuses'
	IF((ISNULL(@where, '') = '') OR (@where NOT LIKE '%'+@entity+'.StatusId%'))
		BEGIN
			SET @sqlCommand = @sqlCommand + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) fgus ON ISNULL(' + @entity + '.[StatusId], 1) = fgus.[StatusId] '
		END
	
	--Special case: Updating GroupByWhere if having ConBusinessFullAddress in this condition.
	SET @groupByWhere = REPLACE(@groupByWhere, @entity+'.ConBusinessFullAddress', '( coalesce(cont.[ConBusinessAddress1], '''') + coalesce(CHAR(13) + cont.[ConBusinessAddress2], '''') + coalesce(CHAR(13) + cont.[ConBusinessCity], '''') + coalesce('', '' + sts.[StateAbbr], '''') + coalesce('', '' + cont.[ConBusinessZipPostal], '''') + coalesce(CHAR(13) + sysRef.[SysOptionName], '''') )')

	SET @sqlCommand = @sqlCommand + ' WHERE 1=1 AND '+@entity+'.[CustCustomerID] = @parentId ' + ISNULL(@groupByWhere, '')  
	SET @sqlCommand = @sqlCommand + ' GROUP BY ' + @groupBy 
	IF(ISNULL(@orderBy, '') <> '')
	 BEGIN
	 	SET @sqlCommand = @sqlCommand + ' ORDER BY '+ @orderBy
	 END
 END
 
 --To replace EntityName from custom column names
	 SET @sqlCommand = REPLACE(@sqlCommand, @entity+'.CustCustomerIDName', 'cust.[CustCode]')
	 SET @sqlCommand = REPLACE(@sqlCommand, @entity+'.CustContactMSTRIDName', 'cont.[ConFullName]')
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

EXEC sp_executesql @sqlCommand, N'@pageNo INT, @pageSize INT, @orderBy NVARCHAR(500), @where NVARCHAR(500), @entity NVARCHAR(100), @parentId BIGINT,@userId BIGINT' ,
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
/****** Object:  StoredProcedure [dbo].[GetCustDcLocation]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
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
      ,cust.[CdcContactMSTRID]
      ,cust.[StatusId]
      ,cust.[EnteredBy]
      ,cust.[DateEntered]
      ,cust.[ChangedBy]
      ,cust.[DateChanged] 
  FROM [dbo].[CUST040DCLocations] cust
 WHERE [Id]=@id
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetCustDcLocationContact]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               09/25/2018      
-- Description:               Get a cust DC Location Contact
-- Execution:                 EXEC [dbo].[GetCustDcLocationContact]
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)  
-- Modified Desc:  
-- =============================================
ALTER PROCEDURE  [dbo].[GetCustDcLocationContact]
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
	CdcLocationCode AS ClcContactCode 
	,cont.ConBusinessPhone
	,cont.ConBusinessPhoneExt
	,cont.ConCompany
	,cont.ConBusinessAddress1
	,cont.ConBusinessAddress2
	,cont.ConBusinessCity
	,cont.ConBusinessStateId
	,cont.ConBusinessZipPostal
	,cont.ConBusinessCountryId
	FROM [dbo].[CUST040DCLocations] cdc
	JOIN [dbo].[CONTC000Master] cont ON cdc.CdcContactMSTRID = cont.Id
	WHERE cdc.Id = @parentId
 END
 ELSE
 BEGIN
 SELECT cust.[Id] AS 'ClcContactMSTRID'
		,cust.[ClcCustDcLocationId]
		,cust.[ClcItemNumber]
		,cust.[ClcContactCode]
		,cust.[ClcContactTitle]
		,cust.[ClcContactMSTRID] AS 'Id'
		,cust.[ClcAssignment]
		,cust.[ClcGateway]
		,cust.[StatusId]
		--,cust.[EnteredBy]
		--,cust.[DateEntered]
		--,cust.[ChangedBy]
		--,cust.[DateChanged]
		,cu.Id AS ParentId 

		,cont.ConTitleId
		,cont.ConFirstName
		,cont.ConMiddleName
		,cont.ConLastName
		,cont.ConJobTitle
		,cont.ConCompany
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
  FROM [dbo].[CUST041DCLocationContacts] cust
  JOIN [dbo].[CUST040DCLocations] cdc ON cust.ClcCustDcLocationId = cdc.Id
  JOIN [dbo].[CUST000Master] cu ON cdc.CdcCustomerID = cu.Id
  JOIN [dbo].[CONTC000Master] cont ON cust.ClcContactMSTRID = cont.Id
 WHERE cust.[Id]=@id
 END
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetCustDcLocationContactView]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group  
   All Rights Reserved Worldwide */  
-- =============================================          
-- Author:                    Akhil Chauhan           
-- Create date:               09/25/2018        
-- Description:               Get all Customer DC Location Contact 
-- Execution:                 EXEC [dbo].[GetCustDcLocationContactView]  
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)               
-- Modified Desc:           
-- =============================================  
ALTER PROCEDURE [dbo].[GetCustDcLocationContactView]  
 @userId BIGINT,  
 @roleId BIGINT,  
 @orgId BIGINT,  
 @entity NVARCHAR(100),  
 @pageNo INT,  
 @pageSize INT,  
 @orderBy NVARCHAR(500), 
 @groupBy NVARCHAR(500), 
 @groupByWhere NVARCHAR(500),  
 @where NVARCHAR(500),  
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
  
SET @TCountQuery = 'SELECT @TotalCount = COUNT(Id) FROM [dbo].[CUST041DCLocationContacts] (NOLOCK) '+ @entity   
  
--Below for getting user specific 'Statuses'  
IF((ISNULL(@where, '') = '') OR (@where NOT LIKE '%'+@entity+'.StatusId%'))  
 BEGIN  
  SET @TCountQuery = @TCountQuery + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) fgus ON ' + @entity + '.[StatusId] = fgus.[StatusId] '  
 END  
  
SET @TCountQuery = @TCountQuery + ' WHERE [ClcCustDcLocationId] = @parentId ' + ISNULL(@where, '')  
  
EXEC sp_executesql @TCountQuery, N' @orgId BIGINT, @parentId BIGINT, @userId BIGINT, @TotalCount INT OUTPUT',  @orgId, @parentId, @userId, @TotalCount  OUTPUT;  
  
IF(@recordId = 0)  
 BEGIN  
  SET @sqlCommand = 'SELECT ' + [dbo].[fnGetBaseQueryByUserId](@entity, @userId)   
  SET @sqlCommand = @sqlCommand + ' , cont.[ConFullName] AS ClcContactMSTRIDName, refOp.SysOptionName AS CustomerType, cont.ConBusinessPhone AS ConBusinessPhone, cont.ConBusinessPhoneExt AS ConBusinessPhoneExt, cont.ConMobilePhone AS ConMobilePhone '  
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
  
 SET @sqlCommand = @sqlCommand + ' FROM [dbo].[CUST041DCLocationContacts] (NOLOCK) '+ @entity  
  
--Below to get BIGINT reference key name by Id if NOT NULL  
SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[CONTC000Master] (NOLOCK) cont ON ' + @entity + '.[ClcContactMSTRID]=cont.[Id] '  
SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[SYSTM000Ref_Options] (NOLOCK) refOp ON cont.ConUDF01=refOp.[Id] '  
  
--Below for getting user specific 'Statuses'  
IF((ISNULL(@where, '') = '') OR (@where NOT LIKE '%'+@entity+'.StatusId%'))  
 BEGIN  
  SET @sqlCommand = @sqlCommand + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) hfk ON ISNULL(' + @entity + '.[StatusId], 1) = hfk.[StatusId] '  
 END  
  
SET @sqlCommand = @sqlCommand + ' WHERE '+ @entity + '.[ClcCustDcLocationId]=@parentId ' + ISNULL(@where, '')  
  
  
IF((@recordId > 0) AND (((@isNext = 0) AND (@isEnd = 0)) OR ((@isNext = 1) AND (@isEnd = 0))))  
 BEGIN  
  IF((@isNext = 0) AND (@isEnd = 0))  
   BEGIN  
	IF(ISNULL(@orderBy, '') <> '')
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND ' + @orderBy + ' <= (SELECT ' + @orderBy + ' FROM [dbo].[CUST041DCLocationContacts] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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
		SET @sqlCommand = @sqlCommand + ' AND ' + @orderBy + ' >= (SELECT ' + @orderBy + ' FROM [dbo].[CUST041DCLocationContacts] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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
EXEC sp_executesql @sqlCommand, N'@pageNo INT, @pageSize INT, @entity NVARCHAR(100), @orderBy NVARCHAR(500), @where NVARCHAR(500), @orgId BIGINT, @parentId BIGINT,@userId BIGINT' ,  
    
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
/****** Object:  StoredProcedure [dbo].[GetCustDcLocationView]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
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
 @where NVARCHAR(500),
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

SET @TCountQuery = 'SELECT @TotalCount = COUNT(Id) FROM [dbo].[CUST040DCLocations] (NOLOCK) '+ @entity 

--Below for getting user specific 'Statuses'
IF((ISNULL(@where, '') = '') OR (@where NOT LIKE '%'+@entity+'.StatusId%'))
	BEGIN
		SET @TCountQuery = @TCountQuery + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) fgus ON ' + @entity + '.[StatusId] = fgus.[StatusId] '
	END

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
	SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[CONTC000Master] (NOLOCK) cont ON ' + @entity + '.[CdcContactMSTRID]=cont.[Id] '
	SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[SYSTM000Ref_States] (NOLOCK) sts ON cont.[ConBusinessStateId]=sts.[Id] '
	SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[SYSTM000Ref_Options] (NOLOCK) sysRef ON cont.[ConBusinessCountryId]=sysRef.[Id] '
	
	--Below for getting user specific 'Statuses'
	IF((ISNULL(@where, '') = '') OR (@where NOT LIKE '%'+@entity+'.StatusId%'))
		BEGIN
			SET @sqlCommand = @sqlCommand + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) hfk ON ISNULL(' + @entity + '.[StatusId], 1) = hfk.[StatusId] '
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
		SET @sqlCommand = @sqlCommand + ' AND ' + @orderBy + ' <= (SELECT ' + @orderBy + ' FROM [dbo].[CUST040DCLocations] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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
		SET @sqlCommand = @sqlCommand + ' AND ' + @orderBy + ' >= (SELECT ' + @orderBy + ' FROM [dbo].[CUST040DCLocations] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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

print @sqlCommand

EXEC sp_executesql @sqlCommand, N'@pageNo INT, @pageSize INT, @orderBy NVARCHAR(500), @where NVARCHAR(500), @entity NVARCHAR(100), @parentId BIGINT,@userId BIGINT' ,
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
/****** Object:  StoredProcedure [dbo].[GetCustDocReference]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               08/16/2018      
-- Description:               Get a cust document reference
-- Execution:                 EXEC [dbo].[GetCustDocReference]
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)    
-- Modified Desc:  
-- ============================================= 
ALTER PROCEDURE  [dbo].[GetCustDocReference]
    @userId BIGINT,
    @roleId BIGINT,
	@orgId BIGINT,
    @id BIGINT
AS
BEGIN TRY                
 SET NOCOUNT ON;   
 SELECT cust.[Id]
       ,cust.[CdrOrgID]
       ,cust.[CdrCustomerID]
       ,cust.[CdrItemNumber]
       ,cust.[CdrCode]
       ,cust.[CdrTitle]
       ,cust.[DocRefTypeId]
       ,cust.[DocCategoryTypeId]
       ,cust.[CdrAttachment]
       ,cust.[CdrDateStart]
       ,cust.[CdrDateEnd]
       ,cust.[CdrRenewal]
       ,cust.[StatusId]
       ,cust.[EnteredBy]
       ,cust.[DateEntered]
       ,cust.[ChangedBy]
       ,cust.[DateChanged]
  FROM [dbo].[CUST030DocumentReference] cust
 WHERE [Id]=@id
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetCustDocReferenceView]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               09/04/2018      
-- Description:               Get all customer document reference 
-- Execution:                 EXEC [dbo].[GetCustDocReferenceView]
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)    
-- Modified Desc:  
-- ============================================= 
ALTER PROCEDURE [dbo].[GetCustDocReferenceView]
 @userId BIGINT,
 @roleId BIGINT,
 @orgId BIGINT,
 @entity NVARCHAR(100),
 @pageNo INT,
 @pageSize INT,
 @orderBy NVARCHAR(500),
 @groupBy NVARCHAR(500), 
 @groupByWhere NVARCHAR(500), 
 @where NVARCHAR(500),
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

SET @TCountQuery = 'SELECT @TotalCount = COUNT(Id) FROM [dbo].[CUST030DocumentReference] (NOLOCK) '+ @entity 

--Below for getting user specific 'Statuses'
IF((ISNULL(@where, '') = '') OR (@where NOT LIKE '%'+@entity+'.StatusId%'))
	BEGIN
		SET @TCountQuery = @TCountQuery + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) fgus ON ' + @entity + '.[StatusId] = fgus.[StatusId] '
	END

SET @TCountQuery = @TCountQuery + ' WHERE [CdrCustomerID] = @parentId AND [CdrOrgId] = @orgId ' + ISNULL(@where, '')

EXEC sp_executesql @TCountQuery, N'@parentId BIGINT, @orgId BIGINT, @userId BIGINT, @TotalCount INT OUTPUT', @parentId, @orgId, @userId, @TotalCount  OUTPUT;
 
IF(@recordId = 0)
	BEGIN
		SET @sqlCommand = 'SELECT ' + [dbo].[fnGetBaseQueryByUserId](@entity, @userId) 
		SET @sqlCommand = @sqlCommand + ' ,org.[OrgCode] AS CdrOrgIDName, cust.[CustCode] AS CdrCustomerIDName '
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

SET @sqlCommand = @sqlCommand +' FROM [dbo].[CUST030DocumentReference] (NOLOCK) '+ @entity

--Below to get BIGINT reference key name by Id if NOT NULL
SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[ORGAN000Master] (NOLOCK) org ON ' + @entity + '.[CdrOrgID]=org.[Id] '
SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[CUST000Master] (NOLOCK) cust ON ' + @entity + '.[CdrCustomerID]=cust.[Id] '

--Below for getting user specific 'Statuses'
IF((ISNULL(@where, '') = '') OR (@where NOT LIKE '%'+@entity+'.StatusId%'))
	BEGIN
		SET @sqlCommand = @sqlCommand + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) hfk ON ISNULL(' + @entity + '.[StatusId], 1) = hfk.[StatusId] '
	END

SET @sqlCommand = @sqlCommand + ' WHERE '+@entity+'.[CdrOrgId] = @orgId AND '+@entity+'.[CdrCustomerID] = @parentId '

IF((@recordId > 0) AND (((@isNext = 0) AND (@isEnd = 0)) OR ((@isNext = 1) AND (@isEnd = 0))))
	BEGIN
		IF((@isNext = 0) AND (@isEnd = 0))  
   BEGIN  
	IF(ISNULL(@orderBy, '') <> '')
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND ' + @orderBy + ' <= (SELECT ' + @orderBy + ' FROM [dbo].[CUST030DocumentReference] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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
		SET @sqlCommand = @sqlCommand + ' AND ' + @orderBy + ' >= (SELECT ' + @orderBy + ' FROM [dbo].[CUST030DocumentReference] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
	 END
	ELSE
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND '+@entity+'.Id >= '+ CAST(@recordId AS NVARCHAR(50))  
	 END
   END   
	END

SET @sqlCommand = @sqlCommand+ ISNULL(@where, '') + ' ORDER BY '+ ISNULL(@orderBy, @entity+'.Id') 

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

EXEC sp_executesql @sqlCommand, N'@pageNo INT, @pageSize INT,@orderBy NVARCHAR(500), @where NVARCHAR(500), @orgId BIGINT, @entity NVARCHAR(100), @parentId BIGINT,@userId BIGINT' ,
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
/****** Object:  StoredProcedure [dbo].[GetCustFinacialCalender]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               08/16/2018      
-- Description:               Get a cust finacial cal
-- Execution:                 EXEC [dbo].[GetCustFinacialCalender]
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)    
-- Modified Desc:  
-- =============================================
ALTER PROCEDURE  [dbo].[GetCustFinacialCalender]
    @userId BIGINT,
    @roleId BIGINT,
	@orgId BIGINT,
    @id BIGINT
AS
BEGIN TRY                
 SET NOCOUNT ON;   
 SELECT cust.[Id]
       ,cust.[OrgID]
       ,cust.[CustID]
       ,cust.[FclPeriod]
       ,cust.[FclPeriodCode]
       ,cust.[FclPeriodStart]
       ,cust.[FclPeriodEnd]
       ,cust.[FclPeriodTitle]
       ,cust.[FclAutoShortCode]
       ,cust.[FclWorkDays]
       ,cust.[FinCalendarTypeId]
       ,cust.[StatusId]
       ,cust.[DateEntered]
       ,cust.[EnteredBy]
       ,cust.[DateChanged]
       ,cust.[ChangedBy]
  FROM [dbo].[CUST050Finacial_Cal] cust
 WHERE [Id]=@id
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetCustFinacialCalenderView]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               09/04/2018      
-- Description:               Get all customer financial calander
-- Execution:                 EXEC [dbo].[GetCustFinacialCalenderView]
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)    
-- Modified Desc:  
-- =============================================
ALTER PROCEDURE [dbo].[GetCustFinacialCalenderView]
 @userId BIGINT,
 @roleId BIGINT,
 @orgId BIGINT,
 @entity NVARCHAR(100),
 @pageNo INT,
 @pageSize INT,
 @orderBy NVARCHAR(500),
 @groupBy NVARCHAR(500), 
 @groupByWhere NVARCHAR(500), 
 @where NVARCHAR(500),
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

SET @TCountQuery = 'SELECT @TotalCount = COUNT(Id) FROM [dbo].[CUST050Finacial_Cal] (NOLOCK) '+ @entity 

--Below for getting user specific 'Statuses'
IF((ISNULL(@where, '') = '') OR (@where NOT LIKE '%'+@entity+'.StatusId%'))
	BEGIN
		SET @TCountQuery = @TCountQuery + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) fgus ON ' + @entity + '.[StatusId] = fgus.[StatusId] '
	END

SET @TCountQuery = @TCountQuery + ' WHERE [CustID] = @parentId AND [OrgId] = @orgId ' + ISNULL(@where, '')

EXEC sp_executesql @TCountQuery, N'@parentId BIGINT, @orgId BIGINT, @userId BIGINT, @TotalCount INT OUTPUT', @parentId, @orgId, @userId, @TotalCount  OUTPUT;

IF(@recordId = 0)
	BEGIN
		SET @sqlCommand = 'SELECT ' + [dbo].[fnGetBaseQueryByUserId](@entity, @userId) 
		SET @sqlCommand = @sqlCommand + ' ,org.[OrgCode] AS OrgIDName, cust.[CustCode] AS CustIDName '
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

SET @sqlCommand = @sqlCommand + ' FROM [dbo].[CUST050Finacial_Cal] (NOLOCK) '+ @entity

--Below to get BIGINT reference key name by Id if NOT NULL
SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[ORGAN000Master] (NOLOCK) org ON ' + @entity + '.[OrgID]=org.[Id] '
SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[CUST000Master] (NOLOCK) cust ON ' + @entity + '.[CustID]=cust.[Id] '

--Below for getting user specific 'Statuses'
IF((ISNULL(@where, '') = '') OR (@where NOT LIKE '%'+@entity+'.StatusId%'))
	BEGIN
		SET @sqlCommand = @sqlCommand + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) hfk ON ISNULL(' + @entity + '.[StatusId], 1) = hfk.[StatusId] '
	END

SET @sqlCommand = @sqlCommand + ' WHERE '+@entity+'.[OrgId] = @orgId AND '+@entity+'.[CustID] = @parentId '

IF((@recordId > 0) AND (((@isNext = 0) AND (@isEnd = 0)) OR ((@isNext = 1) AND (@isEnd = 0))))
	BEGIN
		IF((@isNext = 0) AND (@isEnd = 0))  
   BEGIN  
	IF(ISNULL(@orderBy, '') <> '')
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND ' + @orderBy + ' <= (SELECT ' + @orderBy + ' FROM [dbo].[CUST050Finacial_Cal] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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
		SET @sqlCommand = @sqlCommand + ' AND ' + @orderBy + ' >= (SELECT ' + @orderBy + ' FROM [dbo].[CUST050Finacial_Cal] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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

EXEC sp_executesql @sqlCommand, N'@pageNo INT, @pageSize INT, @orderBy NVARCHAR(500), @where NVARCHAR(500), @orgId BIGINT, @entity NVARCHAR(100), @parentId BIGINT,@userId BIGINT' ,
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
/****** Object:  StoredProcedure [dbo].[GetCustomer]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               08/16/2018      
-- Description:               Get a customer
-- Execution:                 EXEC [dbo].[GetCustomer]
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)    
-- Modified Desc:  
-- ============================================= 
ALTER PROCEDURE  [dbo].[GetCustomer]
    @userId BIGINT,
    @roleId BIGINT,
	@orgId BIGINT,
    @id BIGINT
AS
BEGIN TRY                
 SET NOCOUNT ON;   
  SELECT cust.[Id]
        ,cust.[CustERPID]
        ,cust.[CustOrgId]
        ,cust.[CustItemNumber]
        ,cust.[CustCode]
        ,cust.[CustTitle]
        ,cust.[CustWorkAddressId]
        ,cust.[CustBusinessAddressId]
        ,cust.[CustCorporateAddressId]
        ,cust.[CustContacts]
        ,cust.[CustLogo]
        ,cust.[CustTypeId]
        ,cust.[CustWebPage]
        ,cust.[StatusId]
        ,cust.[EnteredBy]
        ,cust.[DateEntered]
        ,cust.[ChangedBy]
        ,cust.[DateChanged]
		,org.OrgCode as 'RoleCode'
  FROM [dbo].[CUST000Master] cust
  INNER JOIN [dbo].[ORGAN000Master] org ON cust.CustOrgId = org.Id
 WHERE cust.[Id] = @id
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetCustomerView]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               04/14/2018      
-- Description:               Get all customer
-- Execution:                 EXEC [dbo].[GetCustomerView]
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)    
-- Modified Desc:  
-- =============================================   
ALTER PROCEDURE [dbo].[GetCustomerView]  
 @userId BIGINT,  
 @roleId BIGINT,  
 @orgId BIGINT,  
 @entity NVARCHAR(100),  
 @pageNo INT,  
 @pageSize INT,  
 @orderBy NVARCHAR(500),  
 @groupBy NVARCHAR(500), 
 @groupByWhere NVARCHAR(500), 
 @where NVARCHAR(500),  
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
 
 SET @TCountQuery = 'SELECT @TotalCount = COUNT(Id) FROM [dbo].[CUST000Master] (NOLOCK) '+ @entity   
   
 --Below for getting user specific 'Statuses'  
 IF((ISNULL(@where, '') = '') OR (@where NOT LIKE '%'+@entity+'.StatusId%'))  
  BEGIN  
   SET @TCountQuery = @TCountQuery + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) fgus ON ' + @entity + '.[StatusId] = fgus.[StatusId] '  
  END  
   
 SET @TCountQuery = @TCountQuery + ' WHERE [CustOrgId] = @orgId ' + ISNULL(@where, '')
   
 EXEC sp_executesql @TCountQuery, N'@orgId BIGINT, @userId BIGINT, @TotalCount INT OUTPUT', @orgId, @userId, @TotalCount  OUTPUT;  

 IF((ISNULL(@groupBy, '') = '') OR (@recordId > 0))
  BEGIN
	  
	IF(@recordId = 0)  
	 BEGIN  
	  SET @sqlCommand = 'SELECT ' + [dbo].[fnGetBaseQueryByUserId](@entity, @userId)   
	  SET @sqlCommand = @sqlCommand + ' ,org.[OrgCode] AS CustOrgIdName, contWA.[ConFullName] AS CustWorkAddressIdName, ' +   
	        ' contBA.[ConFullName] AS CustBusinessAddressIdName, contCA.[ConFullName] AS CustCorporateAddressIdName '  ;
			  
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
	  
	SET @sqlCommand = @sqlCommand + ' FROM [dbo].[CUST000Master] (NOLOCK) '+ @entity  
	--Below to get BIGINT reference key name by Id if NOT NULL  
	SET @sqlCommand = @sqlCommand + ' INNER JOIN [dbo].[ORGAN000Master] (NOLOCK) org ON ' + @entity + '.[CustOrgId] = org.[Id] '  
	SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[CONTC000Master] (NOLOCK) contWA ON ' + @entity + '.[CustWorkAddressId] = contWA.[Id] '  
	SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[CONTC000Master] (NOLOCK) contBA ON ' + @entity + '.[CustBusinessAddressId] = contBA.[Id] '  
	SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[CONTC000Master] (NOLOCK) contCA ON ' + @entity + '.[CustCorporateAddressId] = contCA.[Id] ' ; 
	
	--Below for getting user specific 'Statuses'  
	IF((ISNULL(@where, '') = '') OR (@where NOT LIKE '%'+@entity+'.StatusId%'))  
	 BEGIN  
	  SET @sqlCommand = @sqlCommand + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) hfk ON ' + @entity + '.[StatusId] = hfk.[StatusId] '  
	 END  
	
	SET @sqlCommand = @sqlCommand + ' WHERE '+@entity+'.[CustOrgId] = @orgId '+ ISNULL(@where, '') + ISNULL(@groupByWhere, '')  
	  
	IF((@recordId > 0) AND (((@isNext = 0) AND (@isEnd = 0)) OR ((@isNext = 1) AND (@isEnd = 0))))  
	 BEGIN  
	  IF((@isNext = 0) AND (@isEnd = 0))  
	   BEGIN  
		IF(ISNULL(@orderBy, '') <> '')
		 BEGIN
			SET @sqlCommand = @sqlCommand + ' AND ' + @orderBy + ' <= (SELECT ' + @orderBy + ' FROM [dbo].[CUST000Master] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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
			SET @sqlCommand = @sqlCommand + ' AND ' + @orderBy + ' >= (SELECT ' + @orderBy + ' FROM [dbo].[CUST000Master] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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
	
	SET @sqlCommand = 'SELECT ' + @groupBy + ' AS KeyValue, Count(' + @entity + '.Id) AS DataCount FROM [dbo].[CUST000Master] (NOLOCK) '+ @entity  
	SET @sqlCommand = @sqlCommand + ' INNER JOIN [dbo].[ORGAN000Master] (NOLOCK) org ON ' + @entity + '.[CustOrgId] = org.[Id] '  
	SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[CONTC000Master] (NOLOCK) contWA ON ' + @entity + '.[CustWorkAddressId] = contWA.[Id] '  
	SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[CONTC000Master] (NOLOCK) contBA ON ' + @entity + '.[CustBusinessAddressId] = contBA.[Id] '  
	SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[CONTC000Master] (NOLOCK) contCA ON ' + @entity + '.[CustCorporateAddressId] = contCA.[Id] ' ; 
	
	--Below for getting user specific 'Statuses'  
	IF((ISNULL(@where, '') = '') OR (@where NOT LIKE '%'+@entity+'.StatusId%'))  
	 BEGIN  
	  SET @sqlCommand = @sqlCommand + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) hfk ON ' + @entity + '.[StatusId] = hfk.[StatusId] '  
	 END  

	SET @sqlCommand = @sqlCommand + ' WHERE '+@entity+'.[CustOrgId] = @orgId '+ ISNULL(@where, '') + ISNULL(@groupByWhere, '')  
	SET @sqlCommand = @sqlCommand + ' GROUP BY ' + @groupBy 
	IF(ISNULL(@orderBy, '') <> '')
	 BEGIN
	 	SET @sqlCommand = @sqlCommand + ' ORDER BY '+ @orderBy
	 END
  END

  print @sqlCommand

EXEC sp_executesql @sqlCommand, N'@pageNo INT, @pageSize INT,@orderBy NVARCHAR(500), @where NVARCHAR(500), @orgId BIGINT, @entity NVARCHAR(100),@userId BIGINT,@groupBy NVARCHAR(500)' ,  
  @entity= @entity,  
     @pageNo= @pageNo,   
     @pageSize= @pageSize,  
     @orderBy = @orderBy,  
     @where = @where,  
  @orgId = @orgId,  
  @userId = @userId,
  @groupBy = @groupBy  
  
END TRY                  
BEGIN CATCH                  
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                  
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                  
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                  
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                  
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetCustPPPTree]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               01/19/2018      
-- Description:               Get all PPP list for Customers
-- Execution:                 EXEC [dbo].[GetCustPPPTree]
-- Modified on:  
-- Modified Desc:  
-- =============================================                           
ALTER PROCEDURE [dbo].[GetCustPPPTree]  
 @orgId BIGINT = 0,        
 @custId BIGINT = NULL,        
 @parentId BIGINT= NULL          
AS                            
BEGIN TRY                            
                             
 SET NOCOUNT ON;                    
            
    DECLARE @treeList TABLE(          
 [Id] [bigint],          
 [CustomerId] [bigint],        
 [ParentId] [bigint],         
 [Text] NVARCHAR(50),        
 [ToolTip] NVARCHAR(1000),        
 [Enabled] BIT,        
 [HierarchyLevel] INT,        
 [HierarchyText] NVARCHAR(50), 
 [IconCss] NVARCHAR(50)     
)           
INSERT INTO @treeList SELECT cust.Id, cust.Id, NULL, cust.CustCode as [Text],cust.CustTitle as [ToolTip], 0 as [Enabled], 0, '','mail_contact_16x16'       
FROM  [dbo].[CUST000Master] (NOLOCK) cust         
WHERE  cust.CustOrgId= @orgId   AND cust.StatusId =1     
        
IF(@parentId IS NOT NULL)        
 BEGIN        
   DECLARE @hierarchyLevel INT 
   DECLARE @hierarchyIdText NVARCHAR(100)   
   SELECT @hierarchyLevel = PrgHierarchyLevel, @hierarchyIdText = [PrgHierarchyID].ToString() FROM [PRGRM000Master] WHERE Id = @parentId AND PrgOrgID= @orgId AND StatusId =1 ;    
        
  INSERT INTO @treeList        
  SELECT prg.Id, prg.PrgCustID, prg.Id, CASE WHEN @hierarchyLevel = 1 THEN  prg.PrgProjectCode ELSE prg.PrgPhaseCode END  as [Text], prg.PrgProgramTitle as [ToolTip], 0 as [Enabled],  prg.PrgHierarchyLevel, Prg.[PrgHierarchyID].ToString(),
  CASE WHEN @hierarchyLevel = 1 THEN  'functionlibrary_statistical_16x16' ELSE 'functionlibrary_recentlyuse_16x16' END  as [IconCss]        
  FROM @treeList prgTree         
  INNER JOIN [dbo].[PRGRM000Master] (NOLOCK)  prg ON Prg.PrgCustId=prgTree.Id -- directly take program under customer that why parent id = customer id        
  WHERE prg.PrgOrgID= @orgId AND prg.StatusId =1 AND prg.PrgHierarchyLevel = @hierarchyLevel + 1   AND Prg.[PrgHierarchyID].ToString() like @hierarchyIdText +'%'      
  AND prg.PrgCustID = (CASE WHEN @custId IS NULL THEN prg.PrgCustID ELSE @custId END)  ;    
    
  Select * from @treeList where ParentId IS NOT  NULL --= (CASE WHEN @parentId IS NULL THEN ParentId ELSE @parentId END)        
 END     
ELSE IF (@parentId IS NULL AND @custId IS NOT NULL )    
 BEGIN    
      INSERT INTO @treeList        
   SELECT prg.Id, prg.PrgCustID, prg.Id, prg.PrgProgramCode as [Text], prg.PrgProgramTitle as [ToolTip], 0 as [Enabled],  prg.PrgHierarchyLevel, Prg.[PrgHierarchyID].ToString(),'functionlibrary_morefunctions_16x16'  as [IconCss]       
   FROM @treeList prgTree         
   INNER JOIN [dbo].[PRGRM000Master] (NOLOCK)  prg ON Prg.PrgCustId=prgTree.Id -- directly take program under customer that why parent id = customer id        
   WHERE prg.PrgOrgID= @orgId AND prg.PrgHierarchyLevel =1  AND prg.StatusId =1       
   AND prg.PrgCustID = (CASE WHEN @custId IS NULL THEN prg.PrgCustID ELSE @custId END) ;    
    Select * from @treeList where ParentId= (CASE WHEN @parentId IS NULL THEN ParentId ELSE @parentId END)      
 END       
ELSE        
 BEGIN        
  UPDATE @treeList SET [Enabled] = 1        
  FROM @treeList prgTree        
  INNER JOIN [dbo].[PRGRM000Master] prg ON prg.PrgCustId=prgTree.Id        
  WHERE prg.PrgOrgID= @orgId AND prg.PrgHierarchyLevel =1        
  Select * from @treeList        
 END         
        
END TRY                        
BEGIN CATCH                        
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                        
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                        
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                        
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                        
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetDashboard]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               01/10/2018      
-- Description:               Get a Dashboard By Id
-- Execution:                 EXEC [dbo].[GetDashboard]
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)    
-- Modified Desc:  
-- =============================================   
ALTER PROCEDURE [dbo].[GetDashboard]  
 @userId BIGINT,  
 @roleId BIGINT,  
 @orgId BIGINT,  
 @langCode NVARCHAR(10),  
 @id BIGINT  
AS  
BEGIN TRY                  
 SET NOCOUNT ON;     
 SELECT rep.[Id]
      ,rep.[OrganizationId]
      ,rep.[DshMainModuleId]
      ,rep.[DshName]
      ,rep.[DshIsDefault]
      ,rep.[StatusId]
      ,rep.[DateEntered]
      ,rep.[EnteredBy]
      ,rep.[DateChanged]
      ,rep.[ChangedBy] 
 FROM [dbo].[SYSTM000Ref_Dashboard] (NOLOCK) rep  
 WHERE rep.[OrganizationId] = @orgId   
 AND rep.Id=@id  
END TRY                  
BEGIN CATCH                  
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                  
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                  
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                  
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                  
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetDashboardView]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               12/01/2018      
-- Description:               Get all Dashboards
-- Execution:                 EXEC [dbo].[GetDashboardView]
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)   
-- Modified Desc:  
-- =============================================
ALTER PROCEDURE [dbo].[GetDashboardView]
	@userId INT,
	@roleId BIGINT,
	@orgId BIGINT,
  	@langCode NVARCHAR(10),
	@entity NVARCHAR(100),
	@pageNo INT,
	@pageSize INT,
	@orderBy NVARCHAR(500),
	@groupBy NVARCHAR(500), 
	@groupByWhere NVARCHAR(500), 
	@where NVARCHAR(500),
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

	SET @TCountQuery = 'SELECT @TotalCount = COUNT(Id) FROM [dbo].[SYSTM000Ref_Dashboard] (NOLOCK) '+ @entity +' WHERE [OrganizationId] = @orgId ' + ISNULL(@where, '')
	EXEC sp_executesql @TCountQuery, N'@orgId BIGINT, @TotalCount INT OUTPUT',@orgId ,@TotalCount  OUTPUT;
	
	IF(@recordId = 0)
	BEGIN
		SET @sqlCommand = 'SELECT ' + [dbo].[fnGetBaseQueryByUserId](@entity, @userId) 
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

	SET @sqlCommand = @sqlCommand + ' FROM [dbo].[SYSTM000Ref_Dashboard] (NOLOCK) '+ @entity

	SET @sqlCommand = @sqlCommand + ' WHERE '+@entity+'.[OrganizationId] = @orgId '+ ISNULL(@where, '')
	
	IF((@recordId > 0) AND (((@isNext = 0) AND (@isEnd = 0)) OR ((@isNext = 1) AND (@isEnd = 0))))
	BEGIN
		IF((@isNext = 0) AND (@isEnd = 0))  
   BEGIN  
	IF(ISNULL(@orderBy, '') <> '')
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND ' + @orderBy + ' <= (SELECT ' + @orderBy + ' FROM [dbo].[SYSTM000Ref_Dashboard] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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
		SET @sqlCommand = @sqlCommand + ' AND ' + @orderBy + ' >= (SELECT ' + @orderBy + ' FROM [dbo].[SYSTM000Ref_Dashboard] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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

	EXEC sp_executesql @sqlCommand, N'@pageNo INT, @pageSize INT, @orgId BIGINT, @entity NVARCHAR(100), @orderBy NVARCHAR(500), @where NVARCHAR(500)' ,
					@orgId= @orgId,
					@entity= @entity,
					@pageNo= @pageNo, 
					@pageSize= @pageSize,
					@orderBy = @orderBy,
					@where = @where
	
END TRY                
BEGIN CATCH                
	DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
			,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
			,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
	EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetDeletedRecordLookUpIds]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Janardana Behara        
-- Create date:               01/17/2018      
-- Description:               Get Lookup ids for deleted system reference recordsIds for update the cache
-- Execution:                 EXEC [dbo].[GetDeletedRecordLookUpIds]
-- Modified on:  
-- Modified Desc:  
-- =============================================                         
ALTER PROCEDURE [dbo].[GetDeletedRecordLookUpIds] 
@ids NVARCHAR(MAX)
AS                
BEGIN TRY                
 SET NOCOUNT ON; 

   SELECT DISTINCT ref.SysLookupId as SysRefId FROM dbo.SYSTM000Ref_Options(NOLOCK) ref
   INNER JOIN dbo.fnSplitString(@ids,',') rec ON ref.Id = rec.Item
	
END TRY                
BEGIN CATCH                
	DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
			,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
			,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 
	EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetDeleteInfoModules]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Janardana Behara         
-- Create date:               05/25/2018      
-- Description:               Get all referenced modules  by id
-- Execution:                 EXEC [dbo].[GetDeleteMoreModules]
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)    
-- Modified Desc:  
-- ============================================= 

ALTER PROCEDURE [dbo].[GetDeleteInfoModules]
 @userId BIGINT,
 @roleId BIGINT,
 @orgId BIGINT,
 @entity NVARCHAR(100),
 @recordId BIGINT
AS
BEGIN TRY                
 SET NOCOUNT ON;  
 
--DECLARE @entity NVARCHAR(50)='Contact'
--DECLARE @recordId BIGINT = 1



DECLARE @ReferenceTable Table(
PrimaryId INT IDENTITY(1,1) primary key clustered,
ReferenceEntity NVARCHAR(50),
ParentEntity NVARCHAR(50),
ReferenceTableName NVARCHAR(100),
ReferenceColumnName  NVARCHAR(100)
);

INSERT INTO @ReferenceTable(referenceEntity,parentEntity,referenceTableName,ReferenceColumnName)
SELECT 
(SELECT TOP 1 SysRefName FROM [dbo].[SYSTM000Ref_Table] WHERE TblTableName = sys.sysobjects.name) as [Entity],
sys.sysobjects.name AS TableName,
@entity As ParentTableName ,

(SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE WHERE CONSTRAINT_NAME = sys.foreign_keys.name) AS ColumnName
FROM 
sys.foreign_keys 
inner join sys.sysobjects on
sys.foreign_keys.parent_object_id = sys.sysobjects.id
INNER JOIN  [dbo].[SYSTM000Ref_Table] refTable  ON OBJECT_ID(refTable.TblTableName) = referenced_object_id
--INNER JOIN INFORMATION_SCHEMA.KEY_COLUMN_USAGE AS FK  ON FK.CONSTRAINT_NAME = sys.sysobjects.name
WHERE refTable.SysRefName = @entity

SELECT DISTINCT ReferenceEntity as SysRefName FROM @ReferenceTable Order by ReferenceEntity


END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetDeleteInfoRecords]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group    
   All Rights Reserved Worldwide */    
-- =============================================            
-- Author:                    Janardana Behara             
-- Create date:               05/25/2018          
-- Description:               Get all referenced modules  by id    
-- Execution:                 EXEC [dbo].[GetDeleteMoreModules]    
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)        
-- Modified Desc:      
-- =============================================     
    
ALTER PROCEDURE [dbo].[GetDeleteInfoRecords]    
 @userId BIGINT,    
 @roleId BIGINT,    
 @orgId BIGINT,    
 @entity NVARCHAR(100),    
 @parentEntity NVARCHAR(100),    
 @contains NVARCHAR(100)    
AS    
BEGIN TRY                    
 SET NOCOUNT ON;      
     
--DECLARE @entity NVARCHAR(50)='Customer'    
--DECLARE @parentEntity NVARCHAR(100) = 'Contact'   
--DECLARE @contains BIGINT = 242    
    
  DECLARE @tableName NVARCHAR(100)  
  
  SELECT @tableName = TblTableName FROM [dbo].[SYSTM000Ref_Table] WHERE SysRefName = @entity  
  
  
  
DECLARE @ReferenceTable Table(    
PrimaryId INT IDENTITY(1,1) primary key clustered,    
ReferenceEntity NVARCHAR(50),    
ParentEntity NVARCHAR(50),    
ReferenceTableName NVARCHAR(100),    
ReferenceColumnName  NVARCHAR(100)    
);    
    
INSERT INTO @ReferenceTable(referenceEntity,parentEntity,referenceTableName,ReferenceColumnName)    
SELECT     
(SELECT TOP 1 SysRefName FROM [dbo].[SYSTM000Ref_Table] WHERE TblTableName = sys.sysobjects.name) as [Entity],    
  
@tableName,  
  
sys.sysobjects.name AS TableName,    
    
(SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE WHERE CONSTRAINT_NAME = sys.foreign_keys.name) AS ColumnName    
FROM     
sys.foreign_keys     
inner join sys.sysobjects on    
sys.foreign_keys.parent_object_id = sys.sysobjects.id    
INNER JOIN  [dbo].[SYSTM000Ref_Table] refTable  ON OBJECT_ID(refTable.TblTableName) = referenced_object_id    
--INNER JOIN INFORMATION_SCHEMA.KEY_COLUMN_USAGE AS FK  ON FK.CONSTRAINT_NAME = sys.sysobjects.name    
WHERE refTable.SysRefName = @parentEntity   
    AND   sys.sysobjects.name = @tableName;  
    
DECLARE @query NVARCHAR(MAX)  
  
SELECT @query = COALESCE(@query+' OR ' ,'') + ReferenceColumnName + ' in ('+CAST(@contains as VARCHAR)+')'  FROM @ReferenceTable  Order by ReferenceEntity    
  
IF(@entity = 'Program')
	BEGIN
		SET  @query = 'SELECT 
			 [Id]      
			,[PrgOrgID]      
			,[PrgCustID]      
			,[PrgItemNumber]      
			,[PrgProgramCode]      
			,[PrgProjectCode]      
			,[PrgPhaseCode]      
			,[PrgProgramTitle]      
			,[PrgAccountCode] 
			,[DelEarliest] 
			,[DelLatest] 
			,CASE WHEN [DelEarliest] IS NULL AND [DelLatest] IS NULL  THEN CAST(1 AS BIT) ELSE [DelDay] END AS DelDay
			,[PckEarliest] 
			,[PckLatest]
			,CASE WHEN [PckEarliest] IS NULL AND [PckLatest] IS NULL  THEN CAST(1 AS BIT) ELSE [PckDay] END AS PckDay
			,[StatusId]      
			,[PrgDateStart]      
			,[PrgDateEnd]      
			,[PrgDeliveryTimeDefault]      
			,[PrgPickUpTimeDefault]      
			,[PrgHierarchyID].ToString() As PrgHierarchyID       
			,[PrgHierarchyLevel]      
			,[DateEntered]      
			,[EnteredBy]      
			,[DateChanged]      
			,[ChangedBy]  FROM  ' + @tableName+'    WHERE StatusId in(1,2) AND (' + @query  +')'; 
	END
ELSE
	BEGIN
		SET  @query = 'SELECT * FROM  ' + @tableName+'    WHERE StatusId in(1,2) AND (' + @query  +')'; 
	END

EXEC sp_executesql @query   
    
END TRY                    
BEGIN CATCH                    
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                    
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                    
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                    
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                    
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetDeleteMoreModules]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Janardana Behara         
-- Create date:               05/25/2018      
-- Description:               Get all referenced modules  by id
-- Execution:                 EXEC [dbo].[GetDeleteMoreModules]
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)   
-- Modified Desc:  
-- ============================================= 

ALTER PROCEDURE [dbo].[GetDeleteMoreModules]
 @userId BIGINT,
 @roleId BIGINT,
 @orgId BIGINT,
 @entity NVARCHAR(100),
 @recordId BIGINT
AS
BEGIN TRY                
 SET NOCOUNT ON;  
 
-- DECLARE @entity NVARCHAR(50)='Contact'
--DECLARE @recordId BIGINT = 1



DECLARE @ReferenceTable Table(
PrimaryId INT IDENTITY(1,1) primary key clustered,
ReferenceEntity NVARCHAR(50),
ParentEntity NVARCHAR(50),
ReferenceTableName NVARCHAR(100),
RefernceColumnName  NVARCHAR(100)
);

INSERT INTO @ReferenceTable(referenceEntity,parentEntity,referenceTableName,refernceColumnName)
SELECT 
(SELECT TOP 1 SysRefName FROM [dbo].[SYSTM000Ref_Table] WHERE TblTableName = sys.sysobjects.name) as [Entity],
sys.sysobjects.name AS TableName,
@entity As ParentTableName ,

(SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE WHERE CONSTRAINT_NAME = sys.foreign_keys.name) AS ColumnName
FROM 
sys.foreign_keys 
inner join sys.sysobjects on
sys.foreign_keys.parent_object_id = sys.sysobjects.id
INNER JOIN  [dbo].[SYSTM000Ref_Table] refTable  ON OBJECT_ID(refTable.TblTableName) = referenced_object_id
--INNER JOIN INFORMATION_SCHEMA.KEY_COLUMN_USAGE AS FK  ON FK.CONSTRAINT_NAME = sys.sysobjects.name
WHERE refTable.SysRefName = @entity

SELECT * FROM @ReferenceTable Order by ReferenceEntity


END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetDeliveryStatus]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil         
-- Create date:               06/16/2018      
-- Description:               Get a DeliveryStatus
-- Execution:                 EXEC [dbo].[GetDeliveryStatus]
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)    
-- Modified Desc:  
-- ============================================= 
ALTER PROCEDURE  [dbo].[GetDeliveryStatus] 
    @userId BIGINT,
    @roleId BIGINT,
	@orgId BIGINT,
    @id BIGINT
AS
BEGIN TRY                
 SET NOCOUNT ON;   

 SELECT  delStatus.[Id]
	    ,delStatus.[OrganizationId]
        ,delStatus.[DeliveryStatusCode]
        ,delStatus.[DeliveryStatusTitle]
        ,delStatus.[SeverityId]
		,delStatus.[ItemNumber]
        ,delStatus.[StatusId]
        ,delStatus.[DateEntered]
        ,delStatus.[EnteredBy]
        ,delStatus.[DateChanged]
        ,delStatus.[ChangedBy]
   FROM [dbo].[SYSTM000Delivery_Status] delStatus
  WHERE [Id]=@id
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetDeliveryStatusView]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil         
-- Create date:               06/06/2018      
-- Description:               Get all DeliveryStatus 
-- Execution:                 EXEC [dbo].[GetDeliveryStatusView]
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)    
-- Modified Desc:  
-- =============================================
ALTER PROCEDURE [dbo].[GetDeliveryStatusView]
 @userId BIGINT,
 @roleId BIGINT,
 @orgId BIGINT,
 @entity NVARCHAR(100),
 @pageNo INT,
 @pageSize INT,
 @orderBy NVARCHAR(500),
 @groupBy NVARCHAR(500), 
 @groupByWhere NVARCHAR(500), 
 @where NVARCHAR(500),
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
 DECLARE @isSysAdmin BIT;

SELECT @isSysAdmin = [IsSysAdmin] FROM [dbo].[SYSTM000OpnSezMe] WHERE [Id] = @userId

SET @TCountQuery = 'SELECT @TotalCount = COUNT(Id) FROM [dbo].[SYSTM000Delivery_Status] (NOLOCK) '+ @entity 

IF(@isSysAdmin = 0)
	BEGIN
		SET @TCountQuery = @TCountQuery +' WHERE ' + @entity + '.OrganizationId=@orgId ' + ISNULL(@where, '')
	END
ELSE
	BEGIN
		SET @TCountQuery = @TCountQuery +' WHERE 1=1' + ISNULL(@where, '')
	END

EXEC sp_executesql @TCountQuery, N'@userId BIGINT, @orgId BIGINT, @TotalCount INT OUTPUT', @userId, @orgId, @TotalCount  OUTPUT;

IF(@recordId = 0)
	BEGIN
		SET @sqlCommand = 'SELECT ' + [dbo].[fnGetBaseQueryByUserId](@entity, @userId) 
		 SET @sqlCommand = @sqlCommand + ' ,org.[OrgCode] AS OrganizationIdName ' 
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
		
SET @sqlCommand = @sqlCommand +' FROM [dbo].[SYSTM000Delivery_Status] (NOLOCK) '+ @entity
--Below to get BIGINT reference key name by Id if NOT NULL  
SET @sqlCommand = @sqlCommand + ' INNER JOIN [dbo].[ORGAN000Master] (NOLOCK) org ON ' + @entity + '.[OrganizationId] = org.[Id] '  

IF(@isSysAdmin = 0)
	BEGIN
		SET @sqlCommand = @sqlCommand + ' WHERE ' + @entity + '.OrganizationId= @orgId ' + ISNULL(@where, '');
		SET @sqlCommand  = REPLACE(@sqlCommand,@entity + '.ItemNumber','1 as ItemNumber');
	END
ELSE
	BEGIN
		SET @sqlCommand = @sqlCommand + ' WHERE 1=1 ' + ISNULL(@where, '')
	END

IF((@recordId > 0) AND (((@isNext = 0) AND (@isEnd = 0)) OR ((@isNext = 1) AND (@isEnd = 0))))
	BEGIN
		IF((@isNext = 0) AND (@isEnd = 0))
			BEGIN
				SET @sqlCommand = @sqlCommand + ' AND '+@entity+'.Id <= '+ CAST(@recordId AS NVARCHAR(50))
			END
		ELSE IF((@isNext = 1) AND (@isEnd = 0))
			BEGIN
				SET @sqlCommand = @sqlCommand + ' AND '+@entity+'.Id >= '+ CAST(@recordId AS NVARCHAR(50))
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

EXEC sp_executesql @sqlCommand, N'@pageNo INT, @pageSize INT, @orderBy NVARCHAR(500), @where NVARCHAR(500), @entity NVARCHAR(100),@userId BIGINT, @orgId BIGINT' ,
	 @entity= @entity,
     @pageNo= @pageNo, 
     @pageSize= @pageSize,
     @orderBy = @orderBy,
     @where = @where,
	 @userId = @userId,
	 @orgId= @orgId
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetDisplayMessagesByCode]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil        
-- Create date:               05/17/2018      
-- Description:               Get Display Message for cache
-- Execution:                 EXEC [dbo].[GetDisplayMessagesByCode]
-- Modified on:  
-- Modified Desc:  
-- =============================================                          
ALTER PROCEDURE [dbo].[GetDisplayMessagesByCode]     
@langCode NVARCHAR(10),  
@msgCode NVARCHAR(25)                  
AS                  
BEGIN TRY                  
  SET NOCOUNT ON;  
   
    SELECT  sysMsg.LangCode  
   ,refOp.SysOptionName as MessageType  
   ,sysMsg.SysMessageCode as Code  
   ,sysMsg.SysMessageScreenTitle as ScreenTitle  
   ,sysMsg.SysMessageTitle as Title  
   ,sysMsg.SysMessageDescription as [Description]  
   ,sysMsg.SysMessageInstruction as Instruction  
   ,sysMsg.SysMessageButtonSelection as MessageOperation  
   ,msgType.SysMsgTypeHeaderIcon as HeaderIcon  
   ,msgType.SysMsgTypeIcon as MessageTypeIcon 
  FROM [dbo].[SYSTM000Master] sysMsg (NOLOCK)  
  INNER JOIN [dbo].[SYSMS010Ref_MessageTypes] msgType (NOLOCK) ON  sysMsg.SysRefId = msgType.SysRefId  
  INNER JOIN [dbo].[SYSTM000Ref_Options] refOp (NOLOCK) ON refOp.Id = msgType.SysRefId    
  WHERE sysMsg.LangCode = @langCode AND sysMsg.SysMessageCode = @msgCode   
     
END TRY                  
BEGIN CATCH                  
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                  
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                  
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                  
   
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                  
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetEntitySubView]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil        
-- Create date:               11/11/2018      
-- Description:               Get Display Message for cache
-- Execution:                 EXEC [dbo].[GetEntitySubView]
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)   
-- Modified Desc:  
-- =============================================
ALTER PROCEDURE [dbo].[GetEntitySubView]
	@userId BIGINT,
	@roleId BIGINT,
	@langCode NVARCHAR(10),
	@orgId BIGINT,
	@entity NVARCHAR(100),
	@fields NVARCHAR(MAX),
	@pageNo INT = 1,
	@pageSize INT = 10,
	@orderBy NVARCHAR(100) = null,
	@like NVARCHAR(MAX) = null,
	@where NVARCHAR(MAX) = null,
	@parentId BIGINT = null

AS
BEGIN TRY                
 SET NOCOUNT ON; 


 DECLARE @sqlCommand NVARCHAR(MAX);
 SET @where = ISNULL(@where, '')

IF(@entity = 'Contact')  
	BEGIN
		SET @sqlCommand = 'SELECT '+@entity+'.Id, '+@entity+'.ConFullName, '+@entity+'.ConJobTitle  FROM [dbo].[CONTC000Master] (NOLOCK) '+ @entity
		IF(@where != '')
			BEGIN
				SET @sqlCommand = @sqlCommand + ' WHERE ' + @entity + '.Id LIKE ''%' + @where + '%'''
				SET @sqlCommand = @sqlCommand + ' OR ' + @entity + '.ConFullName LIKE ''%' + @where + '%'''
				SET @sqlCommand = @sqlCommand + ' OR ' + @entity + '.ConJobTitle LIKE ''%' + @where + '%'''
			END
		ELSE
			BEGIN
				SET @sqlCommand = @sqlCommand + ' WHERE 1=1 '
			END
	END
ELSE IF(@entity = 'Organization')
	BEGIN
		SET @sqlCommand = 'SELECT '+@entity+'.Id, '+@entity+'.OrgCode, '+@entity+'.OrgTitle  FROM [dbo].[ORGAN000Master] (NOLOCK) '+ @entity
		SET @sqlCommand = @sqlCommand + '  '
		IF(@where != '')
			BEGIN
				SET @sqlCommand = @sqlCommand + ' WHERE ' + @entity + '.Id LIKE ''%' + @where + '%'''
				SET @sqlCommand = @sqlCommand + ' OR ' + @entity + '.OrgCode LIKE ''%' + @where + '%'''
				SET @sqlCommand = @sqlCommand + ' OR ' + @entity + '.OrgTitle LIKE ''%' + @where + '%'''
			END
		ELSE
			BEGIN
				SET @sqlCommand = @sqlCommand + ' WHERE 1=1 '
			END
	END
ELSE IF(@entity = 'Customer')
	BEGIN
		SET @sqlCommand = 'SELECT '+@entity+'.Id, '+@entity+'.CustCode, '+@entity+'.CustTitle  FROM [dbo].[CUST000Master] (NOLOCK) '+ @entity
		SET @sqlCommand = @sqlCommand + ' JOIN  [dbo].[ORGAN000Master] org ON ' + @entity + '.CustOrgId=org.Id'
		SET @sqlCommand = @sqlCommand + ' WHERE org.Id=@orgId'
		IF(@where != '')
			BEGIN
				SET @sqlCommand = @sqlCommand + ' AND ' + @entity + '.Id LIKE ''%' + @where + '%'''
				SET @sqlCommand = @sqlCommand + ' OR ' + @entity + '.CustCode LIKE ''%' + @where + '%'''
				SET @sqlCommand = @sqlCommand + ' OR ' + @entity + '.CustTitle LIKE ''%' + @where + '%'''
			END
		ELSE
			BEGIN
				SET @sqlCommand = @sqlCommand + ' AND 1=1 '
			END
	END
ELSE IF(@entity = 'SecurityByRole')
	BEGIN
		SET @sqlCommand = 'SELECT '+@entity+'.Id, '+@entity+'.RoleCode, '+@entity+'.SecLineOrder  FROM [dbo].[SYSTM000SecurityByRole] (NOLOCK) '+ @entity
		SET @sqlCommand = @sqlCommand + ' JOIN  [dbo].[ORGAN000Master] org ON ' + @entity + '.OrgId=org.Id'
		SET @sqlCommand = @sqlCommand + ' WHERE org.Id=@orgId'
		IF(@where != '')
			BEGIN
				SET @sqlCommand = @sqlCommand + ' AND ' + @entity + '.Id LIKE ''%' + @where + '%'''
				SET @sqlCommand = @sqlCommand + ' OR ' + @entity + '.RoleCode LIKE ''%' + @where + '%'''
				SET @sqlCommand = @sqlCommand + ' OR ' + @entity + '.SecLineOrder LIKE ''%' + @where + '%'''
			END
		ELSE
			BEGIN
				SET @sqlCommand = @sqlCommand + ' AND 1=1 '
			END
	END
ELSE IF(@entity = 'Program')
	BEGIN
		SET @sqlCommand = 'SELECT '+@entity+'.Id, '+@entity+'.PrgItemNumber, '+@entity+'.PrgProgramCode  FROM [dbo].[PRGRM000Master] (NOLOCK) '+ @entity
		SET @sqlCommand = @sqlCommand + ' JOIN  [dbo].[ORGAN000Master] org ON ' + @entity + '.PrgOrgID=org.Id'
		SET @sqlCommand = @sqlCommand + ' WHERE org.Id=@orgId'
		IF(@where != '')
			BEGIN
				SET @sqlCommand = @sqlCommand + ' AND ' + @entity + '.Id LIKE ''%' + @where + '%'''
				SET @sqlCommand = @sqlCommand + ' OR ' + @entity + '.PrgItemNumber LIKE ''%' + @where + '%'''
				SET @sqlCommand = @sqlCommand + ' OR ' + @entity + '.PrgProgramCode LIKE ''%' + @where + '%'''
			END
		ELSE
			BEGIN
				SET @sqlCommand = @sqlCommand + ' AND 1=1 '
			END
	END
ELSE IF(@entity = 'Job')
	BEGIN
		SET @sqlCommand = 'SELECT '+@entity+'.Id, '+@entity+'.JobSiteCode, '+@entity+'.JobConsigneeCode  FROM [dbo].[JOBDL000Master] (NOLOCK) '+ @entity
		SET @sqlCommand = @sqlCommand + ' JOIN  [dbo].[PRGRM000Master] prg ON ' + @entity + '.ProgramID=prg.Id'
		SET @sqlCommand = @sqlCommand + ' JOIN  [dbo].[ORGAN000Master] org ON prg.PrgOrgID=org.Id'
		SET @sqlCommand = @sqlCommand + ' WHERE org.Id=@orgId'
		IF(@where != '')
			BEGIN
				SET @sqlCommand = @sqlCommand + ' AND ' + @entity + '.Id LIKE ''%' + @where + '%'''
				SET @sqlCommand = @sqlCommand + ' OR ' + @entity + '.JobSiteCode LIKE ''%' + @where + '%'''
				SET @sqlCommand = @sqlCommand + ' OR ' + @entity + '.JobConsigneeCode LIKE ''%' + @where + '%'''
			END
		ELSE
			BEGIN
				SET @sqlCommand = @sqlCommand + ' AND 1=1 '
			END
	END
ELSE IF(@entity = 'VendDcLocation')
	BEGIN
		SET @sqlCommand = 'SELECT '+@entity+'.Id, '+@entity+'.VdcItemNumber, '+@entity+'.VdcLocationCode  FROM [dbo].[VEND040DCLocations] (NOLOCK) '+ @entity
		SET @sqlCommand = @sqlCommand + ' JOIN  [dbo].[VEND000Master] vend ON ' + @entity + '.VdcVendorID=vend.Id'
		SET @sqlCommand = @sqlCommand + ' JOIN  [dbo].[ORGAN000Master] org ON vend.VendOrgID=org.Id'
		SET @sqlCommand = @sqlCommand + ' WHERE org.Id=@orgId'
		IF(@where != '')
			BEGIN
				SET @sqlCommand = @sqlCommand + ' AND ' + @entity + '.Id LIKE ''%' + @where + '%'''
				SET @sqlCommand = @sqlCommand + ' OR ' + @entity + '.VdcItemNumber LIKE ''%' + @where + '%'''
				SET @sqlCommand = @sqlCommand + ' OR ' + @entity + '.VdcLocationCode LIKE ''%' + @where + '%'''
			END
		ELSE
			BEGIN
				SET @sqlCommand = @sqlCommand + ' AND 1=1 '
			END
	END
ELSE IF(@entity = 'Vendor')
	BEGIN
		SET @sqlCommand = 'SELECT '+@entity+'.Id, '+@entity+'.VendItemNumber, '+@entity+'.VendCode  FROM [dbo].[VEND000Master] (NOLOCK) '+ @entity
		SET @sqlCommand = @sqlCommand + ' JOIN  [dbo].[ORGAN000Master] org ON ' + @entity + '.VendOrgID=org.Id'
		SET @sqlCommand = @sqlCommand + ' WHERE org.Id=@orgId'
		IF(@where != '')
			BEGIN
				SET @sqlCommand = @sqlCommand + ' WHERE ' + @entity + '.Id LIKE ''%' + @where + '%'''
				SET @sqlCommand = @sqlCommand + ' OR ' + @entity + '.VendItemNumber LIKE ''%' + @where + '%'''
				SET @sqlCommand = @sqlCommand + ' OR ' + @entity + '.VendCode LIKE ''%' + @where + '%'''
			END
		ELSE
			BEGIN
				SET @sqlCommand = @sqlCommand + ' AND 1=1 '
			END
	END
ELSE IF(@entity = 'Table')  
	BEGIN
		SET @sqlCommand = 'SELECT ['+@entity+'].SysRefName AS RefName  FROM [dbo].[SYSTM000Ref_Table] (NOLOCK) ['+ @entity+']'
		IF(ISNULL(@where,'') != '')
			BEGIN
				SET @sqlCommand = @sqlCommand + ' WHERE [' + @entity + '].SysRefName LIKE ''%' + @where + '%'''
				
			END		
	END

	

IF(@entity = 'Table') 
BEGIN
     SET @sqlCommand = @sqlCommand + ' ORDER BY ['+@entity+'] .SysRefName OFFSET @pageSize * (@pageNo - 1) ROWS FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);' 
END
ELSE
BEGIN

SET @sqlCommand = @sqlCommand + ' ORDER BY '+@entity+' .Id OFFSET @pageSize * (@pageNo - 1) ROWS FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);' 
END
EXEC sp_executesql @sqlCommand, N'@pageNo INT, @pageSize INT, @where NVARCHAR(100), @orgId BIGINT' ,
	 @orgId = @orgId,
     @pageNo = @pageNo, 
     @pageSize = @pageSize,
     @where = @where
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetEntitySubViewById]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan        
-- Create date:               11/13/2018      
-- Description:               Get Entity Sub View
-- Execution:                 EXEC [dbo].[GetEntitySubViewById]
-- Modified on:  
-- Modified Desc:  
-- =============================================   
ALTER PROCEDURE [dbo].[GetEntitySubViewById]     
 @userId BIGINT,    
 @entity NVARCHAR(100),    
 @id BIGINT    
AS    
BEGIN TRY                    
 SET NOCOUNT ON;     
 DECLARE @sqlCommand NVARCHAR(MAX);    
    
IF(@entity = 'Contact')      
 BEGIN    
  SET @sqlCommand = 'SELECT '+@entity+'.Id, '+@entity+'.ConFullName, '+@entity+'.ConJobTitle  FROM [dbo].[CONTC000Master] (NOLOCK) '+ @entity    
 END    
ELSE IF(@entity = 'Organization')    
 BEGIN    
  SET @sqlCommand = 'SELECT '+@entity+'.Id, '+@entity+'.OrgCode, '+@entity+'.OrgTitle  FROM [dbo].[ORGAN000Master] (NOLOCK) '+ @entity    
 END    
ELSE IF(@entity = 'Customer')    
 BEGIN    
  SET @sqlCommand = 'SELECT '+@entity+'.Id, '+@entity+'.CustCode, '+@entity+'.CustTitle  FROM [dbo].[CUST000Master] (NOLOCK) '+ @entity    
 END    
ELSE IF(@entity = 'SecurityByRole')    
 BEGIN    
  SET @sqlCommand = 'SELECT '+@entity+'.Id, '+@entity+'.RoleCode, '+@entity+'.SecLineOrder  FROM [dbo].[SYSTM000SecurityByRole] (NOLOCK) '+ @entity    
 END    
ELSE IF(@entity = 'Program')    
 BEGIN    
  SET @sqlCommand = 'SELECT '+@entity+'.Id, '+@entity+'.PrgItemNumber, '+@entity+'.PrgProgramCode  FROM [dbo].[PRGRM000Master] (NOLOCK) '+ @entity    
 END    
ELSE IF(@entity = 'Job')    
 BEGIN    
  SET @sqlCommand = 'SELECT '+@entity+'.Id, '+@entity+'.JobSiteCode, '+@entity+'.JobConsigneeCode  FROM [dbo].[JOBDL000Master] (NOLOCK) '+ @entity    
 END    
ELSE IF(@entity = 'VendDcLocation')    
 BEGIN    
  SET @sqlCommand = 'SELECT '+@entity+'.Id, '+@entity+'.VdcItemNumber, '+@entity+'.VdcLocationCode  FROM [dbo].[VEND040DCLocations] (NOLOCK) '+ @entity    
 END    
ELSE IF(@entity = 'Vendor')    
 BEGIN    
  SET @sqlCommand = 'SELECT '+@entity+'.Id, '+@entity+'.VendItemNumber, '+@entity+'.VendCode  FROM [dbo].[VEND000Master] (NOLOCK) '+ @entity    
 END    
    
ELSE IF(@entity = 'TableReference')    
 BEGIN    
  SET @sqlCommand = 'SELECT TOP 1 ['+@entity+'].SysRefName As RefName  FROM [dbo].[SYSTM000Ref_Table] (NOLOCK) ['+ @entity +']'   
 END    
--Filtering Condition    
IF(@entity != 'TableReference')    
     
 BEGIN    
SET @sqlCommand = @sqlCommand + ' WHERE '+@entity+'.Id=@id'    
END    
    
EXEC sp_executesql @sqlCommand, N'@id BIGINT' ,    
     @id= @id    
END TRY                    
BEGIN CATCH                    
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                    
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                    
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                    
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                    
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetIdRefLangNames]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan        
-- Create date:               05/17/2018      
-- Description:               Get Id Ref and Lang Names for cache
-- Execution:                 EXEC [dbo].[GetIdRefLangNames]
-- Modified on:  
-- Modified Desc:  
-- =============================================                        
ALTER PROCEDURE [dbo].[GetIdRefLangNames] 
@langCode NVARCHAR(10),
@lookupId INT
AS                
BEGIN TRY                
 SET NOCOUNT ON;   
	IF(@langCode='EN')
		BEGIN
			SELECT refOp.Id as SysRefId
				,refOp.[SysOptionName] as SysRefName
				,refOp.[SysOptionName] as LangName
				,refOp.[SysDefault] as IsDefault
			FROM [dbo].[SYSTM000Ref_Options] refOp (NOLOCK)  
			INNER JOIN [dbo].[SYSTM000Ref_Lookup] lkup (NOLOCK) ON lkup.Id = refOp.SysLookupId
			INNER JOIN dbo.fnGetUserStatuses(0) st	ON refOp.StatusId = st.StatusId
			WHERE lkup.Id= @lookupId  
			ORDER BY refOp.SysSortOrder ASC 
		END
	ELSE
		BEGIN
			SELECT refOp.Id as SysRefId
				,refOp.[SysOptionName] as SysRefName
				,lngRef.[SysOptionName] as LangName
				,refOp.[SysDefault] as IsDefault
			FROM [dbo].[SYSTM000Ref_Options] refOp (NOLOCK)  
			INNER JOIN [dbo].[SYSTM010Ref_Options] lngRef  (NOLOCK) ON lngRef.SysRefId =refOp.Id 
			INNER JOIN [dbo].[SYSTM000Ref_Lookup] lkup (NOLOCK) ON lkup.Id = refOp.SysLookupId
			INNER JOIN dbo.fnGetUserStatuses(0) st	ON refOp.StatusId = st.StatusId
			WHERE lkup.Id= @lookupId AND lngRef.[LangCode] = @langCode
			ORDER BY refOp.SysSortOrder ASC 
		END
END TRY                
BEGIN CATCH                
	DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
			,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
			,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 
	EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetIdRefLangNamesFromTable]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil         
-- Create date:               05/17/2018      
-- Description:               Get Id Ref and Lang Names for cache
-- Execution:                 EXEC [dbo].[GetIdRefLangNamesFromTable]
-- Modified on:  
-- Modified Desc:  
-- =============================================                        
ALTER PROCEDURE [dbo].[GetIdRefLangNamesFromTable]
@langCode NVARCHAR(10),
@lookupId INT
AS                
BEGIN TRY                
 SET NOCOUNT ON; 
 DECLARE @sqlQuery NVARCHAR(MAX) =  'SELECT refOp.[SysOptionName] as SysRefName
									,refOp.[SysDefault] as IsDefault
									,tbl.*
									FROM ' + [dbo].[fnGetTblNameByLkupId](@lookupId) +' (NOLOCK) tbl
									INNER JOIN [dbo].[SYSTM000Ref_Options] refOp (NOLOCK) ON refOp.Id = tbl.SysRefId
									WHERE refOp.LookupId = '''+ CAST(@lookupId as nvarchar(10)) + ''' AND tbl.LangCode = '''+ @langCode +
								    ''' ORDER BY refOp.[SysSortOrder] ASC'


 EXEC(@sqlQuery)
END TRY                
BEGIN CATCH                
	DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
			,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
			,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 
	EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetIsFieldUnique]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               10/25/2018      
-- Description:               Get unique message if exist
-- Execution:                 EXEC [dbo].[GetIsFieldUnique]
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)   
-- Modified Desc:  
-- =============================================       
ALTER PROCEDURE [dbo].[GetIsFieldUnique]      
@userId BIGINT,      
@roleId BIGINT,      
@orgId BIGINT,      
@langCode NVARCHAR(10),      
@tableName NVARCHAR(100),      
@recordId BIGINT,      
@fieldName NVARCHAR(50),      
@fieldValue NVARCHAR(MAX),
@parentFilter NVARCHAR(MAX),
@parentId BIGINT = null
AS                      
BEGIN TRY                      
SET NOCOUNT ON;      

 DECLARE @exist BIT; 
        DECLARE @actualTableName NVARCHAR(100)
   SELECT @actualTableName = tbl.TblTableName FROM  [dbo].[SYSTM000Ref_Table] (NOLOCK) tbl where tbl.SysRefName= @tableName  

   DECLARE @primaryKeyName NVARCHAR(50), @statusQuery NVARCHAR(200);                                          
	SET  @primaryKeyName = CASE @tableName 
	WHEN 'ScrOsdList' THEN 'OSDID' 
	WHEN 'ScrOsdReasonList' THEN 'ReasonID' 
	WHEN 'ScrRequirementList' THEN 'RequirementID'
	WHEN 'ScrReturnReasonList' THEN 'ReturnReasonID'
	WHEN 'ScrServiceList' THEN 'ServiceID'
	ELSE 'Id' END;
   


   SET @statusQuery = CASE @tableName WHEN 'SystemAccount' THEN '' 
									  WHEN 'OrgActSubSecurityByRole' THEN ' AND ISNULL(StatusId, 1) < 3 AND OrgSecurityByRoleId='+CAST(@parentId AS VARCHAR(10))
									ELSE ' AND ISNULL(StatusId, 1) < 3' END;
    
   DECLARE @sqlCommand NVARCHAR(MAX)    
   SET @sqlCommand =  'IF NOT EXISTS (SELECT 1 FROM ' + @actualTableName +' WHERE '+@primaryKeyName+' <> @recordId ' + @statusQuery + ' AND '+ @fieldName + ' = @fieldValue '+ ISNULL(@parentFilter, '') +') BEGIN SET @exist = 1 END ELSE BEGIN SET @exist = 0 END'; 

   EXEC sp_executesql @sqlCommand, N'@recordId BIGINT, @fieldValue NVARCHAR(MAX), @exist BIT OUTPUT',       
				  @recordId= @recordId,      
				  @fieldValue=@fieldValue,  
				  @exist= @exist OUTPUT
--SELECT @sqlCommand    
Select @exist      
END TRY                      
BEGIN CATCH                      
DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                      
,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                      
,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                      
      
EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                      
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetIsJobCompleted]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Janardana         
-- Create date:               04/16/2018      
-- Description:               Check Job is Completed or Not 
-- Execution:                 EXEC [dbo].[GetIsJobCompleted] 
-- Modified on:  
-- Modified Desc:  
-- =============================================    

ALTER PROCEDURE  [dbo].[GetIsJobCompleted] 
@jobId BIGINT
AS

BEGIN TRY
  SET NOCOUNT ON;
  SELECT JobCompleted FROM JOBDL000Master WHERE Id=  @jobId;


END TRY
BEGIN CATCH                
DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
  ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
  ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetItemNumberAndUpdate]    Script Date: 11/26/2018 8:31:23 PM ******/
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
                                       
                                        
ALTER PROCEDURE [dbo].[GetItemNumberAndUpdate]                                        
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
/****** Object:  StoredProcedure [dbo].[GetJob]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/* Copyright (2018) Meridian Worldwide Transportation Group  
   All Rights Reserved Worldwide */  
-- =============================================          
-- Author:                    Akhil Chauhan           
-- Create date:               09/14/2018        
-- Description:               Get a Job   
-- Execution:                 EXEC [dbo].[GetJob]     
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)     
-- Modified Desc:    
-- =============================================        
ALTER PROCEDURE [dbo].[GetJob]
    @userId BIGINT,      
    @roleId BIGINT,      
    @orgId BIGINT,      
    @id BIGINT,  
 @parentId BIGINT      
AS      
BEGIN TRY                      
 SET NOCOUNT ON;      
   
 IF @id = 0   
 BEGIN  
      DECLARE @pickupTime TIME,@deliveryTime TIME  ,@programCode NVARCHAR(50)

   SELECT @pickupTime = CAST(PrgPickUpTimeDefault AS TIME)  
      ,@deliveryTime =CAST(PrgDeliveryTimeDefault AS TIME) 
	 ,@programCode =  CASE WHEN PrgHierarchyLevel = 1 THEN     [PrgProgramCode]
		                  WHEN PrgHierarchyLevel = 2 THEN     [PrgProjectCode]
		                  WHEN PrgHierarchyLevel = 3 THEN     PrgPhaseCode
		                  ELSE [PrgProgramTitle] END 
	   
   FROM PRGRM000MASTER 
   
   WHERE Id = @parentId;  
  
   SELECT @parentId AS ProgramID  
         ,@programCode AS ProgramIDName
         ,CAST(CAST(GETUTCDATE() as DATE) AS DATETIME) + CAST(@deliveryTime AS datetime) AS JobDeliveryDateTimePlanned  
         ,CAST(CAST(GETUTCDATE() as DATE) AS DATETIME) + CAST(@deliveryTime AS datetime) AS JobDeliveryDateTimeActual  
         ,CAST(CAST(GETUTCDATE() as DATE) AS DATETIME) + CAST(@deliveryTime AS datetime) AS JobDeliveryDateTimeBaseline  
         ,CAST(CAST(GETUTCDATE() as DATE) AS DATETIME) + CAST(@pickupTime AS datetime) AS JobOriginDateTimePlanned  
         ,CAST(CAST(GETUTCDATE() as DATE) AS DATETIME) + CAST(@pickupTime AS datetime) AS JobOriginDateTimeActual  
         ,CAST(CAST(GETUTCDATE() as DATE) AS DATETIME) + CAST(@pickupTime AS datetime) AS JobOriginDateTimeBaseline  
  
 END  
 ELSE  
 BEGIN  
  SELECT job.[Id]      
  ,job.[JobMITJobID]      
  ,job.[ProgramID] 
  ,CASE WHEN prg.PrgHierarchyLevel = 1 THEN     prg.[PrgProgramCode]
		 WHEN prg.PrgHierarchyLevel = 2 THEN     prg.[PrgProjectCode]
		  WHEN prg.PrgHierarchyLevel = 3 THEN     prg.PrgPhaseCode
		  ELSE prg.[PrgProgramTitle] END AS ProgramIDName
  
       
  ,job.[JobSiteCode]      
  ,job.[JobConsigneeCode]      
  ,job.[JobCustomerSalesOrder]      
  ,job.[JobBOL]      
  ,job.[JobBOLMaster]      
  ,job.[JobBOLChild]      
  ,job.[JobCustomerPurchaseOrder]      
  ,job.[JobCarrierContract]     
  ,job.[JobManifestNo]   
  ,job.[JobGatewayStatus]      
  ,job.[StatusId]      
  ,job.[JobStatusedDate]      
  ,job.[JobCompleted]      
  ,job.[JobType]    
  ,job.[ShipmentType]  
  ,job.[JobDeliveryAnalystContactID]     
  ,job.[JobDeliveryResponsibleContactID]      
  ,job.[JobDeliverySitePOC]      
  ,job.[JobDeliverySitePOCPhone]      
  ,job.[JobDeliverySitePOCEmail]      
  ,job.[JobDeliverySiteName]      
  ,job.[JobDeliveryStreetAddress]      
  ,job.[JobDeliveryStreetAddress2]      
  ,job.[JobDeliveryCity]      
  ,job.[JobDeliveryState]      
  ,job.[JobDeliveryPostalCode]      
  ,job.[JobDeliveryCountry]      
  ,job.[JobDeliveryTimeZone]   
  ,job.[JobDeliveryDateTimePlanned]
  ,job.[JobDeliveryDateTimeActual]
  ,job.[JobDeliveryDateTimeBaseline] 
  ,job.[JobDeliveryRecipientPhone]      
  ,job.[JobDeliveryRecipientEmail]      
  ,job.[JobLatitude]      
  ,job.[JobLongitude]      
  ,job.[JobOriginResponsibleContactID]      
  ,job.[JobOriginSitePOC]      
  ,job.[JobOriginSitePOCPhone]      
  ,job.[JobOriginSitePOCEmail]      
  ,job.[JobOriginSiteName]      
  ,job.[JobOriginStreetAddress]      
  ,job.[JobOriginStreetAddress2]      
  ,job.[JobOriginCity]      
  ,job.[JobOriginState]      
  ,job.[JobOriginPostalCode]      
  ,job.[JobOriginCountry]      
  ,job.[JobOriginTimeZone]      
  ,job.[JobOriginDateTimePlanned] 
  ,job.[JobOriginDateTimeActual] 
  ,job.[JobOriginDateTimeBaseline] 
  ,job.[JobProcessingFlags]      
  ,job.[JobDeliverySitePOC2]           
  ,job.[JobDeliverySitePOCPhone2]      
  ,job.[JobDeliverySitePOCEmail2]      
  ,job.[JobOriginSitePOC2]             
  ,job.[JobOriginSitePOCPhone2]        
  ,job.[JobOriginSitePOCEmail2]        
  ,job.JobSellerCode      
  ,job.JobSellerSitePOC      
  ,job.JobSellerSitePOCPhone      
  ,job.JobSellerSitePOCEmail      
  ,job.JobSellerSitePOC2      
  ,job.JobSellerSitePOCPhone2      
  ,job.JobSellerSitePOCEmail2      
  ,job.JobSellerSiteName      
  ,job.JobSellerStreetAddress      
  ,job.JobSellerStreetAddress2      
  ,job.JobSellerCity      
  ,job.JobSellerState      
  ,job.JobSellerPostalCode      
  ,job.JobSellerCountry      
  ,job.[JobUser01]        
  ,job.[JobUser02]        
  ,job.[JobUser03]        
  ,job.[JobUser04]        
  ,job.[JobUser05]        
  ,job.[JobStatusFlags]      
  ,job.[JobScannerFlags] 
       
  ,job.[PlantIDCode]      
  ,job.[CarrierID]      
  ,job.[JobDriverId]      
  ,job.[WindowDelStartTime]      
  ,job.[WindowDelEndTime]      
  ,job.[WindowPckStartTime]       
  ,job.[WindowPckEndTime]      
  ,job.[JobRouteId]      
  ,job.[JobStop]       
  ,job.[JobSignText]      
  ,job.[JobSignLatitude]     
  ,job.[JobSignLongitude] 
       
  ,job.[EnteredBy]      
  ,job.[DateEntered]      
  ,job.[ChangedBy]      
  ,job.[DateChanged]      
  FROM [dbo].[JOBDL000Master] job   
  INNER JOIN  PRGRM000MASTER prg On job.ProgramID = prg.Id
     
 WHERE job.[Id] = @id      
  END  
END TRY                      
BEGIN CATCH                      
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                      
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                      
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                      
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                      
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetJob2ndPoc]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               01/31/2018      
-- Description:               Get a Job2ndPoc 
-- Execution:                 EXEC [dbo].[GetJob2ndPoc]   
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)   
-- Modified Desc:  
-- =============================================    
ALTER PROCEDURE  [dbo].[GetJob2ndPoc]  
	@userId BIGINT,  
	@roleId BIGINT,  
	@orgId BIGINT,  
	@id BIGINT, 
	@parentId  BIGINT
AS  
BEGIN TRY                  
 SET NOCOUNT ON;     
  IF @id = 0 
 BEGIN
      DECLARE @pickupTime TIME,@deliveryTime TIME
		 SELECT @pickupTime = CAST(PrgPickUpTimeDefault AS TIME)
			   ,@deliveryTime =CAST(PrgDeliveryTimeDefault AS TIME)
		 FROM PRGRM000MASTER WHERE Id = @parentId;

		 SELECT @parentId AS ProgramID
		        ,CAST(CAST(GETUTCDATE() as DATE) AS DATETIME) + CAST(@deliveryTime AS datetime) AS JobDeliveryDateTimePlanned
				,CAST(CAST(GETUTCDATE() as DATE) AS DATETIME) + CAST(@deliveryTime AS datetime) AS JobDeliveryDateTimeActual
				,CAST(CAST(GETUTCDATE() as DATE) AS DATETIME) + CAST(@deliveryTime AS datetime) AS JobDeliveryDateTimeBaseline
				,CAST(CAST(GETUTCDATE() as DATE) AS DATETIME) + CAST(@pickupTime AS datetime) AS JobOriginDateTimePlanned
				,CAST(CAST(GETUTCDATE() as DATE) AS DATETIME) + CAST(@pickupTime AS datetime) AS JobOriginDateTimeActual
				,CAST(CAST(GETUTCDATE() as DATE) AS DATETIME) + CAST(@pickupTime AS datetime) AS JobOriginDateTimeBaseline

 END
 ELSE
 BEGIN
  
  SELECT     job.Id  
            ,job.[StatusId]  
   ,job.[JobDeliverySitePOC2]         
   ,job.[JobDeliverySitePOCPhone2]    
   ,job.[JobDeliverySitePOCEmail2]      
   ,job.[JobDeliverySiteName]  
   ,job.[JobDeliveryStreetAddress]  
   ,job.[JobDeliveryStreetAddress2]  
   ,job.[JobDeliveryCity]  
   ,job.[JobDeliveryState]  
   ,job.[JobDeliveryPostalCode]  
   ,job.[JobDeliveryCountry]  
   ,job.[JobDeliveryTimeZone]  
   ,job.[JobDeliveryDateTimePlanned]  
   
   ,job.[JobDeliveryDateTimeActual]  
   
   ,job.[JobDeliveryDateTimeBaseline]  
   
   ,job.[JobOriginSitePOC2]  
   ,job.[JobOriginSitePOCPhone2]  
   ,job.[JobOriginSitePOCEmail2]  
   ,job.[JobOriginSiteName]  
   ,job.[JobOriginStreetAddress]  
   ,job.[JobOriginStreetAddress2]  
   ,job.[JobOriginCity]  
   ,job.[JobOriginState]  
   ,job.[JobOriginPostalCode]  
   ,job.[JobOriginCountry]  
   ,job.[JobOriginTimeZone]  
   ,job.[JobOriginDateTimePlanned]  
   
   ,job.[JobOriginDateTimeActual]  
   
   ,job.[JobOriginDateTimeBaseline]  
   ,job.[JobCompleted]
   ,job.[DateEntered]  
   ,job.[EnteredBy]  
 FROM [dbo].[JOBDL000Master] job  
 WHERE [Id] = @id  

 END



END TRY                  
BEGIN CATCH                  
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                  
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                  
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                  
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                  
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetJobActions]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               10/25/2018      
-- Description:               Get all job Actions
-- Execution:                 EXEC [dbo].[GetJobActions]
-- Modified on:  
-- Modified Desc:  
-- =============================================
ALTER PROCEDURE  [dbo].[GetJobActions]
	     @jobId BIGINT
AS
BEGIN TRY                
 SET NOCOUNT ON;  
		SELECT DISTINCT
		shipApptCode.PacApptReasonCode,
		shipApptCode.PacApptTitle,
		shipReasonCode.PscShipReasonCode,
		shipReasonCode.PscShipTitle,
		prgGateway.PgdGatewayCode,
		prgGateway.PgdGatewayTitle,
		prgGateway.PgdGatewaySortOrder
		FROM [dbo].[JOBDL000Master] job
		JOIN [dbo].[PRGRM000Master] prg ON job.[ProgramID] = prg.Id
		JOIN [dbo].[PRGRM010Ref_GatewayDefaults] prgGateway ON prg.Id = prgGateway.[PgdProgramID] AND prgGateway.GatewayTypeId = 86 AND prgGateway.[StatusId] = 1 AND prgGateway.PgdGatewayTitle IS NOT NULL AND prgGateway.[PgdShipApptmtReasonCode] IS NOT NULL AND prgGateway.[PgdShipStatusReasonCode] IS NOT NULL
		JOIN [dbo].[PRGRM030ShipStatusReasonCodes] shipReasonCode ON prgGateway.[PgdShipStatusReasonCode] = shipReasonCode.PscShipReasonCode AND prg.Id = shipReasonCode.PscProgramID AND shipReasonCode.[StatusId] = 1 
		JOIN [dbo].[PRGRM031ShipApptmtReasonCodes] shipApptCode ON prgGateway.[PgdShipApptmtReasonCode] = shipApptCode.[PacApptReasonCode] AND prg.Id = shipApptCode.[PacProgramID] AND shipApptCode.[StatusId] = 1
		WHERE job.Id = @jobId ORDER BY prgGateway.PgdGatewaySortOrder ASC
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetJobAnalystComboboxContacts]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
  
/* Copyright (2018) Meridian Worldwide Transportation Group    
   All Rights Reserved Worldwide */    
-- =============================================            
-- Author:                    Janardana                 
-- Create date:               02/17/2018          
-- Description:               Get Program Contacts based on organization      
-- Execution:                 EXEC [dbo].[GetJobAnalystComboboxContacts]     
-- Modified on:      
-- Modified Desc:      
-- =============================================                              
ALTER PROCEDURE [dbo].[GetJobAnalystComboboxContacts]                      
 @orgId BIGINT = 0 ,                    
 @programId BIGINT                      
AS                              
BEGIN TRY                              
                
  SET NOCOUNT ON;      
      
  SELECT cont.Id,      
   cont.ConFullName,      
         cont.ConJobTitle,      
   cont.ConCompany,      
   cont.ConFileAs        
  FROM  CONTC000MASTER cont      
  INNER JOIN [dbo].[PRGRM010Ref_GatewayDefaults] pr      
  ON cont.Id = pr.[PgdGatewayAnalyst]   
  WHERE pr.PgdProgramID = @programId      
  AND  cont.StatusId In(1,2)  

   UNION  

SELECT contact.Id,contact.ConFullName,contact.ConJobTitle,contact.ConCompany ,contact.ConFileAs 
FROM  [dbo].CONTC000Master contact  
INNER JOIN  [dbo].[PRGRM020Program_Role] prgRole ON contact.Id = prgRole.[PrgRoleContactID] AND   prgRole.ProgramID = @programId AND prgRole.PrxJobDefaultAnalyst =1
WHERE  contact.StatusId In(1,2)  
AND prgRole.StatusId In(1,2) 


END TRY                              
BEGIN CATCH                              
                               
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                        
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                        
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                        
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                              
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetJobAttribute]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               09/14/2018      
-- Description:               Get a Job Attribute 
-- Execution:                 EXEC [dbo].[GetJobAttribute]  
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)   
-- Modified Desc:  
-- =============================================  
ALTER PROCEDURE  [dbo].[GetJobAttribute]
    @userId BIGINT,
    @roleId BIGINT,
	@orgId BIGINT,
    @id BIGINT
AS
BEGIN TRY                
 SET NOCOUNT ON;   
  SELECT job.[Id]
		,job.[JobID]
		,job.[AjbLineOrder]
		,job.[AjbAttributeCode]
		,job.[AjbAttributeTitle]
		,job.[AjbAttributeQty]
		,job.[AjbUnitTypeId]
		,job.[AjbDefault]
		,job.[DateEntered]
		,job.[StatusId]
		,job.[EnteredBy]
		,job.[DateChanged]
		,job.[ChangedBy]
  FROM   [dbo].[JOBDL030Attributes] job
 WHERE   [Id] = @id
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetJobAttributeView]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               09/14/2018      
-- Description:               Get all Job Attribute 
-- Execution:                 EXEC [dbo].[GetJobAttributeView]  
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)   
-- Modified Desc:  
-- ============================================= 
ALTER PROCEDURE [dbo].[GetJobAttributeView]  
	@userId BIGINT,  
	@roleId BIGINT,  
	@orgId BIGINT,  
	@entity NVARCHAR(100),  
	@pageNo INT,  
	@pageSize INT,  
	@orderBy NVARCHAR(500), 
	@groupBy NVARCHAR(500), 
	@groupByWhere NVARCHAR(500),  
	@where NVARCHAR(500),  
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

 IF @parentId = 0
 BEGIN
     
     DECLARE @prgAttTable TABLE(
	[Id]                      BIGINT          IDENTITY (1, 1) NOT NULL,
    [JobID]                   BIGINT          NULL,
    [AjbLineOrder]            INT             NULL,
    [AjbAttributeCode]        NVARCHAR (20)   NULL,
    [AjbAttributeTitle]       NVARCHAR (50)   NULL,
    [AjbAttributeQty]         DECIMAL (18, 2) NULL,
    [AjbUnitTypeId]           INT             NULL,
    [AjbDefault]              BIT             NULL,
    [StatusId]                INT             NULL
     )

	 --INSERT INTO @prgAttTable(JobID,AjbLineOrder,AjbAttributeCode,AjbAttributeTitle,AjbAttributeQty,AjbUnitTypeId,AjbDefault,StatusId)
	 --SELECT 0,prgm.AttItemNumber,prgm.AttCode,prgm.AttTitle,prgm.AttQuantity,prgm.UnitTypeId,prgm.AttDefault,prgm.StatusId 
	 --FROM [dbo].[PRGRM020Ref_AttributesDefault] prgm
	 --INNER JOIN  [dbo].[fnGetUserStatuses](@userId) fgus ON prgm.StatusId = fgus.StatusId
	 --WHERE AttDefault = 1;

	 --SELECT @TotalCount = COUNT(Id) FROM @prgAttTable
	 
	 --SELECT * FROM @prgAttTable prgAtt
	 --ORDER BY prgAtt.Id
	 --OFFSET @pageSize * (@pageNo - 1) ROWS FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE)

 END
 ELSE
 BEGIN


  
SET @TCountQuery = 'SELECT @TotalCount = COUNT(Id) FROM [dbo].[JOBDL030Attributes] (NOLOCK) '+ @entity   
  
--Below for getting user specific 'Statuses'  
IF((ISNULL(@where, '') = '') OR (@where NOT LIKE '%'+@entity+'.StatusId%'))  
 BEGIN  
  SET @TCountQuery = @TCountQuery + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) fgus ON ' + @entity + '.[StatusId] = fgus.[StatusId] '  
 END  
  
SET @TCountQuery = @TCountQuery + ' WHERE [JobID] = @parentId ' + ISNULL(@where, '')  
  
EXEC sp_executesql @TCountQuery, N'@parentId BIGINT, @userId BIGINT, @TotalCount INT OUTPUT', @parentId, @userId, @TotalCount  OUTPUT;  
  
IF(@recordId = 0)  
 BEGIN  
  SET @sqlCommand = 'SELECT ' + [dbo].[fnGetBaseQueryByUserId](@entity, @userId)   
  SET @sqlCommand = @sqlCommand + ' , job.[JobSiteCode] AS JobIDName, job.[JobCompleted] AS JobCompleted '  
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
  
SET @sqlCommand = @sqlCommand + ' FROM [dbo].[JOBDL030Attributes] (NOLOCK) '+ @entity  
  
--Below to get BIGINT reference key name by Id if NOT NULL  
SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[JOBDL000Master] (NOLOCK) job ON ' + @entity + '.[JobID]=job.[Id] '  
  
--Below for getting user specific 'Statuses'  
IF((ISNULL(@where, '') = '') OR (@where NOT LIKE '%'+@entity+'.StatusId%'))  
 BEGIN  
  SET @sqlCommand = @sqlCommand + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) hfk ON ISNULL(' + @entity + '.[StatusId], 1) = hfk.[StatusId] '  
 END  
  
SET @sqlCommand = @sqlCommand + ' WHERE '+@entity+'.[JobID]=@parentId '+ ISNULL(@where, '')  
  
IF((@recordId > 0) AND (((@isNext = 0) AND (@isEnd = 0)) OR ((@isNext = 1) AND (@isEnd = 0))))  
 BEGIN  
  IF((@isNext = 0) AND (@isEnd = 0))  
   BEGIN  
	IF(ISNULL(@orderBy, '') <> '')
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND ' + @orderBy + ' <= (SELECT ' + @orderBy + ' FROM [dbo].[JOBDL030Attributes] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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
		SET @sqlCommand = @sqlCommand + ' AND ' + @orderBy + ' >= (SELECT ' + @orderBy + ' FROM [dbo].[JOBDL030Attributes] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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
  
EXEC sp_executesql @sqlCommand, N'@pageNo INT, @pageSize INT,@orderBy NVARCHAR(500), @where NVARCHAR(500), @parentId BIGINT, @entity NVARCHAR(100),@userId BIGINT' ,  
  @entity= @entity,  
     @pageNo= @pageNo,   
     @pageSize= @pageSize,  
     @orderBy = @orderBy,  
     @where = @where,  
  @parentId = @parentId,  
  @userId = @userId  
END
END TRY                
BEGIN CATCH                  
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                  
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                  
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                  
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                  
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetJobCargo]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               09/14/2018      
-- Description:               Get a Job Cargo 
-- Execution:                 EXEC [dbo].[GetJobCargo]  
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)    
-- Modified Desc:  
-- =============================================  
ALTER PROCEDURE  [dbo].[GetJobCargo]
    @userId BIGINT,
    @roleId BIGINT,
	@orgId BIGINT,
    @id BIGINT
AS
BEGIN TRY                
 SET NOCOUNT ON;   
  SELECT job.Id
      ,job.[JobID]
      ,job.[CgoLineItem]
      ,job.[CgoPartNumCode]
      ,job.[CgoTitle]
      ,job.[CgoSerialNumber]
      ,job.[CgoPackagingType]
      ,job.[CgoMasterCartonLabel]
      ,job.[CgoWeight]
      ,job.[CgoWeightUnits]
      ,job.[CgoLength]
      ,job.[CgoWidth]
      ,job.[CgoHeight]
      ,job.[CgoVolumeUnits]
      ,job.[CgoCubes]
      ,job.[CgoNotes]
      ,job.[CgoQtyExpected]
      ,job.[CgoQtyOnHand]
      ,job.[CgoQtyDamaged]
      ,job.[CgoQtyOnHold]
	  ,job.[CgoQtyShortOver]
      ,job.[CgoQtyUnits]
      ,job.[CgoReasonCodeOSD]
      ,job.[CgoReasonCodeHold]
      ,job.[CgoSeverityCode]
      ,job.[CgoLatitude]
      ,job.[CgoLongitude]
      ,job.[StatusId]
      --,job.[CgoProcessingFlags]
      ,job.[EnteredBy]
      ,job.[DateEntered]
      ,job.[ChangedBy]
      ,job.[DateChanged]
  FROM   [dbo].[JOBDL010Cargo] job
 WHERE   [Id] = @id
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetJobCargoView]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               09/14/2018      
-- Description:               Get all Job Cargo  
-- Execution:                 EXEC [dbo].[GetJobCargoView]  
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)    
-- Modified Desc:  
-- =============================================   
ALTER PROCEDURE [dbo].[GetJobCargoView]  
	@userId BIGINT,  
	@roleId BIGINT,  
	@orgId BIGINT,  
	@entity NVARCHAR(100),  
	@pageNo INT,  
	@pageSize INT,  
	@orderBy NVARCHAR(500),  
	@groupBy NVARCHAR(500), 
	@groupByWhere NVARCHAR(500), 
	@where NVARCHAR(500),  
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
  
SET @TCountQuery = 'SELECT @TotalCount = COUNT(Id) FROM [dbo].[JOBDL010Cargo] (NOLOCK) '+ @entity   
  
--Below for getting user specific 'Statuses'  
IF((ISNULL(@where, '') = '') OR (@where NOT LIKE '%'+@entity+'.StatusId%'))  
 BEGIN  
  SET @TCountQuery = @TCountQuery + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) fgus ON ' + @entity + '.[StatusId] = fgus.[StatusId] '  
 END  
  
SET @TCountQuery = @TCountQuery + ' WHERE '+ @entity +'.JobID = @parentId ' + ISNULL(@where, '')  

EXEC sp_executesql @TCountQuery, N'@parentId BIGINT, @userId BIGINT, @TotalCount INT OUTPUT', @parentId, @userId, @TotalCount OUTPUT;  
   
IF(@recordId = 0)  
 BEGIN  
  SET @sqlCommand = 'SELECT ' + [dbo].[fnGetBaseQueryByUserId](@entity, @userId)   
  SET @sqlCommand = @sqlCommand + ' , job.[JobSiteCode] AS JobIDName , job.[JobCompleted] AS JobCompleted'  
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
  
SET @sqlCommand = @sqlCommand + ' FROM [dbo].[JOBDL010Cargo] (NOLOCK) '+ @entity  
  
--Below to get BIGINT reference key name by Id if NOT NULL  
SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[JOBDL000Master] (NOLOCK) job ON ' + @entity + '.[JobID]=job.[Id] '  
  
--Below for getting user specific 'Statuses'  
IF((ISNULL(@where, '') = '') OR (@where NOT LIKE '%'+@entity+'.StatusId%'))  
 BEGIN  
  SET @sqlCommand = @sqlCommand + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) hfk ON ISNULL(' + @entity + '.[StatusId], 1) = hfk.[StatusId] '  
 END  
  
SET @sqlCommand = @sqlCommand + ' WHERE '+@entity+'.[JobID]=@parentId '+ ISNULL(@where, '')  
  
IF((@recordId > 0) AND (((@isNext = 0) AND (@isEnd = 0)) OR ((@isNext = 1) AND (@isEnd = 0))))  
 BEGIN  
  IF((@isNext = 0) AND (@isEnd = 0))  
   BEGIN  
	IF(ISNULL(@orderBy, '') <> '')
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND ' + @orderBy + ' <= (SELECT ' + @orderBy + ' FROM [dbo].[JOBDL010Cargo] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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
		SET @sqlCommand = @sqlCommand + ' AND ' + @orderBy + ' >= (SELECT ' + @orderBy + ' FROM [dbo].[JOBDL010Cargo] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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
  
EXEC sp_executesql @sqlCommand, N'@pageNo INT, @pageSize INT,@orderBy NVARCHAR(500), @where NVARCHAR(500), @parentId BIGINT, @entity NVARCHAR(100),@userId BIGINT' ,  
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
/****** Object:  StoredProcedure [dbo].[GetJobDestination]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               01/31/2018      
-- Description:               Get a JobDestination  
-- Execution:                 EXEC [dbo].[GetJobDestination]  
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)  
-- Modified Desc:  
-- =============================================   
ALTER PROCEDURE [dbo].[GetJobDestination] --  1,'SYSAMIN',1,0,55
    @userId BIGINT,  
    @roleId BIGINT,  
    @orgId BIGINT,  
    @id BIGINT,
	@parentId BIGINT  
AS  
BEGIN TRY                  
 SET NOCOUNT ON; 
  IF @id = 0 
 BEGIN
      DECLARE @pickupTime TIME,@deliveryTime TIME
	  DECLARE @pckEarliest DECIMAL(18,2)
	  DECLARE @pckLatest DECIMAL(18,2)
	  DECLARE @pckDay BIT
	  DECLARE @delEarliest DECIMAL(18,2)
	  DECLARE @delLatest DECIMAL(18,2)
	  DECLARE @delDay BIT
	  DECLARE @prgPickUpTimeDefault DATETIME2(7)
     DECLARE @prgDeliveryTimeDefault DATETIME2(7)
	 DECLARE @startDateTime DATETIME2(7)
	 DECLARE @endDateTime DATETIME2(7)
		 SELECT @pickupTime = CAST(PrgPickUpTimeDefault AS TIME)
			   ,@deliveryTime =CAST(PrgDeliveryTimeDefault AS TIME)
			   ,@pckEarliest = PckEarliest
			   ,@pckLatest  = PckLatest
			   ,@pckDay  = PckDay
			   ,@delEarliest  = DelEarliest
			   ,@delLatest = DelLatest
			   ,@delDay = DelDay
			   ,@prgPickUpTimeDefault = PrgPickUpTimeDefault 
               ,@prgDeliveryTimeDefault =PrgDeliveryTimeDefault 
			   ,@startDateTime=PrgDateStart
			   ,@endDateTime=PrgDateEnd

		 FROM PRGRM000MASTER WHERE Id = @parentId;

		 SELECT @parentId AS ProgramID
		        ,CAST(CAST(GETUTCDATE() as DATE) AS DATETIME) + CAST(@deliveryTime AS datetime) AS JobDeliveryDateTimePlanned
				,CAST(CAST(GETUTCDATE() as DATE) AS DATETIME) + CAST(@deliveryTime AS datetime) AS JobDeliveryDateTimeActual
				--modified for datetime issue
				--,CAST(CAST(GETUTCDATE() as DATE) AS DATETIME) + CAST(@deliveryTime AS datetime) AS JobDeliveryDateTimeBaseline
				,CAST(CAST(ISNULL(@endDateTime,GETUTCDATE()) AS DATE) AS DATETIME)+ CAST(@deliveryTime AS datetime) AS JobDeliveryDateTimeBaseline
				,CAST(CAST(GETUTCDATE() as DATE) AS DATETIME) + CAST(@pickupTime AS datetime) AS JobOriginDateTimePlanned
				,CAST(CAST(GETUTCDATE() as DATE) AS DATETIME) + CAST(@pickupTime AS datetime) AS JobOriginDateTimeActual
				--,CAST(CAST(GETUTCDATE() as DATE) AS DATETIME) + CAST(@pickupTime AS datetime) AS JobOriginDateTimeBaseline
				,CAST(CAST(ISNULL(@startDateTime,GETUTCDATE()) AS DATE) AS DATETIME)+ CAST(@pickupTime AS datetime) AS JobOriginDateTimeBaseline
			   ,@pckEarliest AS PckEarliest
			   ,@pckLatest  As PckLatest
			   ,@pckDay  AS PckDay
			   ,@delEarliest  AS DelEarliest
			   ,@delLatest AS DelLatest
			   ,@delDay AS DelDay

			   ,@prgPickUpTimeDefault  AS ProgramPickupDefault
               ,@prgDeliveryTimeDefault AS ProgramDeliveryDefault



 END
 ELSE
 BEGIN
 
 
     
  SELECT job.[Id]  
  ,job.[StatusId]  
  ,job.[JobDeliverySitePOC]  
  ,job.[JobDeliverySitePOCPhone]  
  ,job.[JobDeliverySitePOCEmail]  
  ,job.[JobDeliverySiteName]  
  ,job.[JobDeliveryStreetAddress]  
  ,job.[JobDeliveryStreetAddress2]  
  ,job.[JobDeliveryCity]  
  ,job.[JobDeliveryState]  
  ,job.[JobDeliveryPostalCode]  
  ,job.[JobDeliveryCountry]  
  ,job.[JobDeliveryTimeZone]  
  ,job.[JobDeliveryDateTimePlanned]  
  
  ,job.[JobDeliveryDateTimeActual]  
   
  ,job.[JobDeliveryDateTimeBaseline]  
  
  ,job.[JobOriginSitePOC]  
  ,job.[JobOriginSitePOCPhone]  
  ,job.[JobOriginSitePOCEmail]  
  ,job.[JobOriginSiteName]  
  ,job.[JobOriginStreetAddress]  
  ,job.[JobOriginStreetAddress2]  
  ,job.[JobOriginCity]  
  ,job.[JobOriginState]  
  ,job.[JobOriginPostalCode]  
  ,job.[JobOriginCountry]  
  ,job.[JobOriginTimeZone]  
  ,job.[JobOriginDateTimePlanned]  
  
  ,job.[JobOriginDateTimeActual]  
    
  ,job.[JobOriginDateTimeBaseline]  
  ,job.[JobCompleted]  
  ,job.[EnteredBy]    
  ,job.[DateEntered]    
  ,job.[ChangedBy]    
  ,job.[DateChanged]    

  ,job.WindowDelStartTime
  ,job.WindowDelEndTime
  ,job.WindowPckStartTime
  ,job.WindowPckEndTime

  ,job.JobSignText
  ,job.JobSignLatitude
  ,job.JobSIgnLongitude

               , pgm.PckEarliest
			   , pgm.PckLatest
			   , pgm.PckDay
			   , pgm.DelEarliest
			   , pgm.DelLatest
			   , pgm.DelDay
			   ,pgm.PrgPickUpTimeDefault AS ProgramPickupDefault
               ,pgm.PrgDeliveryTimeDefault AS ProgramDeliveryDefault



  FROM [dbo].[JOBDL000Master] job 
  INNER JOIN PRGRM000Master pgm ON job.ProgramID = pgm.Id 
 WHERE job.[Id] = @id  
 END
END TRY                  
BEGIN CATCH                  
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                  
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                  
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                  
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                  
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetJobDocReference]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               09/14/2018      
-- Description:               Get a Job Doc Reference  
-- Execution:                 EXEC [dbo].[GetJobDocReference]  
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)   
-- Modified Desc:  
-- =============================================
ALTER PROCEDURE  [dbo].[GetJobDocReference]  
	@userId BIGINT,  
	@roleId BIGINT,  
	@orgId BIGINT,  
	@id BIGINT  
AS  
BEGIN TRY                  
 SET NOCOUNT ON;     
  SELECT job.[Id]  
  ,job.[JobID]
  ,job.[JdrItemNumber]  
  ,job.[JdrCode]  
  ,job.[JdrTitle]  
  ,job.[DocTypeId]  
  ,job.[JdrAttachment]  
  ,job.[JdrDateStart]  
  ,job.[JdrDateEnd]  
  ,job.[JdrRenewal]  
  ,job.[EnteredBy]  
  ,job.[DateEntered]  
  ,job.[ChangedBy]  
  ,job.[DateChanged]  
  FROM   [dbo].[JOBDL040DocumentReference] job  
 WHERE   [Id] = @id  
END TRY                  
BEGIN CATCH                  
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                  
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                  
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                  
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                  
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetJobDocReferenceView]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               09/14/2018      
-- Description:               Get all Job Attribute
-- Execution:                 EXEC [dbo].[GetJobDocReferenceView]  
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)    
-- Modified Desc:  
-- =============================================
ALTER PROCEDURE [dbo].[GetJobDocReferenceView]
 @userId BIGINT,
 @roleId BIGINT,
 @orgId BIGINT,
 @entity NVARCHAR(100),
 @pageNo INT,
 @pageSize INT,
 @orderBy NVARCHAR(500),
 @groupBy NVARCHAR(500), 
 @groupByWhere NVARCHAR(500), 
 @where NVARCHAR(500),
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

SET @TCountQuery = 'SELECT @TotalCount = COUNT(Id) FROM [dbo].[JOBDL040DocumentReference] (NOLOCK) '+ @entity 

--Below for getting user specific 'Statuses'
IF((ISNULL(@where, '') = '') OR (@where NOT LIKE '%'+@entity+'.StatusId%'))
	BEGIN
		SET @TCountQuery = @TCountQuery + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) fgus ON ' + @entity + '.[StatusId] = fgus.[StatusId] '
	END

SET @TCountQuery = @TCountQuery + ' WHERE [JobID] = @parentId ' + ISNULL(@where, '')

EXEC sp_executesql @TCountQuery, N'@parentId BIGINT, @userId BIGINT, @TotalCount INT OUTPUT', @parentId, @userId, @TotalCount  OUTPUT;

IF(@recordId = 0)
	BEGIN
		SET @sqlCommand = 'SELECT ' + [dbo].[fnGetBaseQueryByUserId](@entity, @userId) 
		SET @sqlCommand = @sqlCommand + ' , job.[JobSiteCode] AS JobIDName , job.[JobCompleted] AS JobCompleted'
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

SET @sqlCommand = @sqlCommand + ' FROM [dbo].[JOBDL040DocumentReference] (NOLOCK) '+ @entity

--Below to get BIGINT reference key name by Id if NOT NULL
SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[JOBDL000Master] (NOLOCK) job ON ' + @entity + '.[JobID]=job.[Id] '

--Below for getting user specific 'Statuses'
IF((ISNULL(@where, '') = '') OR (@where NOT LIKE '%'+@entity+'.StatusId%'))
	BEGIN
		SET @sqlCommand = @sqlCommand + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) hfk ON ISNULL(' + @entity + '.[StatusId], 1) = hfk.[StatusId] '
	END

SET @sqlCommand = @sqlCommand + ' WHERE '+@entity+'.[JobID]=@parentId '+ ISNULL(@where, '')

IF((@recordId > 0) AND (((@isNext = 0) AND (@isEnd = 0)) OR ((@isNext = 1) AND (@isEnd = 0))))
	BEGIN
		IF((@isNext = 0) AND (@isEnd = 0))  
   BEGIN  
	IF(ISNULL(@orderBy, '') <> '')
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND ' + @orderBy + ' <= (SELECT ' + @orderBy + ' FROM [dbo].[JOBDL040DocumentReference] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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
		SET @sqlCommand = @sqlCommand + ' AND ' + @orderBy + ' >= (SELECT ' + @orderBy + ' FROM [dbo].[JOBDL040DocumentReference] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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

EXEC sp_executesql @sqlCommand, N'@pageNo INT, @pageSize INT,@orderBy NVARCHAR(500), @where NVARCHAR(500), @parentId BIGINT, @entity NVARCHAR(100),@userId BIGINT' ,
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
/****** Object:  StoredProcedure [dbo].[GetJobGateway]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group  
   All Rights Reserved Worldwide */  
-- =============================================          
-- Author:                    Akhil Chauhan           
-- Create date:               09/14/2018        
-- Description:               Get a Job Gateway  
-- Execution:                 EXEC [dbo].[GetJobGateway]    
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)     
-- Modified Desc:    
-- =============================================  
ALTER PROCEDURE  [dbo].[GetJobGateway]   
    @userId BIGINT,  
    @roleId BIGINT,  
	@orgId BIGINT,  
    @id BIGINT,  
 @parentId BIGINT  
AS  
BEGIN TRY                  
 SET NOCOUNT ON;    
     
  DECLARE   @pickupBaselineDate DATETIME2(7)  
			,@pickupPlannedDate DATETIME2(7)  
			,@pickupActualDate DATETIME2(7)  
			,@deliveryBaselineDate DATETIME2(7)  
			,@deliveryPlannedDate DATETIME2(7)  
			,@deliveryActualDate DATETIME2(7)  
			,@deliverySitePOC NVARCHAR(75)
			,@deliverySitePOCPhone NVARCHAR(50)
			,@deliverySitePOCEmail NVARCHAR(50)
			,@jobCompleted BIT  
			,@programId BIGINT
       
 SELECT  @pickupBaselineDate    = [JobOriginDateTimeBaseline]  
        ,@pickupPlannedDate     = [JobOriginDateTimePlanned]  
		,@pickupActualDate      = [JobOriginDateTimeActual]  
		,@deliveryBaselineDate  = [JobDeliveryDateTimeBaseline]  
        ,@deliveryPlannedDate   = [JobDeliveryDateTimePlanned]  
		,@deliveryActualDate    = [JobDeliveryDateTimeActual]  
		,@jobCompleted          = [JobCompleted]  
		,@deliverySitePOC		= [JobDeliverySitePOC]
		,@deliverySitePOCPhone	= [JobDeliverySitePOCPhone]
		,@deliverySitePOCEmail	= [JobDeliverySitePOCEmail]
		,@programId  = ProgramID
  FROM JOBDL000Master (NOLOCK) WHERE Id= @parentId   
  
  
  IF @id = 0  
  BEGIN  
         
 SELECT  @parentId AS JobID  
        ,@pickupBaselineDate    AS [JobOriginDateTimeBaseline]  
        ,@pickupPlannedDate     AS [JobOriginDateTimePlanned]  
		,@pickupActualDate      AS [JobOriginDateTimeActual]  
		,@deliveryBaselineDate  AS [JobDeliveryDateTimeBaseline]  
        ,@deliveryPlannedDate   AS [JobDeliveryDateTimePlanned]  
		,@deliveryActualDate    AS [JobDeliveryDateTimeActual]  
		,@programId AS ProgramID
  
  END  
  ELSE  
  BEGIN  
    SELECT job.[Id]  
  ,job.[JobID]  
  ,job.[ProgramID]  
  ,job.[GwyGatewaySortOrder]  
  ,job.[GwyGatewayCode]  
  ,job.[GwyGatewayTitle]  
  ,job.[GwyGatewayDuration]  
  ,job.[GwyGatewayDefault]  
  ,job.[GatewayTypeId]  
  ,job.[GwyGatewayAnalyst]  
  ,job.[GwyGatewayResponsible]  
  ,job.[GwyGatewayPCD]  
  ,job.[GwyGatewayECD]  
  ,job.[GwyGatewayACD]  
  ,job.[GwyCompleted]  
  ,job.[GatewayUnitId]  
  ,job.[GwyAttachments]  
  ,job.[GwyProcessingFlags]  
  ,job.[GwyDateRefTypeId]  
  ,job.[Scanner]  
  ,job.GwyShipApptmtReasonCode  
  ,job.GwyShipStatusReasonCode  
  ,job.GwyOrderType  
  ,job.GwyShipmentType  
  ,job.[StatusId]  
  ,job.[GwyUpdatedById]  
  ,job.[GwyClosedOn]  
  ,job.[GwyClosedBy]  
  --,CASE WHEN (cont.Id > 0 OR job.GwyUpdatedById IS NULL) THEN CAST(1 AS BIT) ELSE CAST(0 AS BIT) END  AS ClosedByContactExist  
  ,CASE WHEN (cont.Id > 0 OR job.GwyClosedBy IS NULL) THEN CAST(1 AS BIT) ELSE CAST(0 AS BIT) END  AS ClosedByContactExist  
  
  ,ISNULL(job.GwyPerson, @deliverySitePOC) AS [GwyPerson]
  ,ISNULL(job.GwyPhone, @deliverySitePOCPhone) AS [GwyPhone]
  ,ISNULL(job.GwyEmail, @deliverySitePOCEmail) AS [GwyEmail]
  ,job.GwyTitle
  ,ISNULL(job.GwyDDPCurrent, @deliveryPlannedDate) AS [GwyDDPCurrent]
  ,job.GwyDDPNew
  ,job.GwyUprWindow
  ,job.GwyLwrWindow
  ,job.GwyUprDate
  ,job.GwyLwrDate
  ,CASE WHEN job.GwyPerson IS NULL THEN CAST(0 AS BIT) ELSE CAST(1 AS BIT) END AS 'isScheduled'

  ,job.[DateEntered]  
  ,job.[EnteredBy]  
  ,job.[DateChanged]  
  ,job.[ChangedBy]  
  ,@pickupBaselineDate    AS [JobOriginDateTimeBaseline]  
  ,@pickupPlannedDate     AS [JobOriginDateTimePlanned]  
  ,@pickupActualDate      AS [JobOriginDateTimeActual]  
  ,@deliveryBaselineDate  AS [JobDeliveryDateTimeBaseline]  
  ,@deliveryPlannedDate   AS [JobDeliveryDateTimePlanned]  
  ,@deliveryActualDate    AS [JobDeliveryDateTimeActual]  
  ,@jobCompleted          AS [JobCompleted]  
  FROM   [dbo].[JOBDL020Gateways] job  
  LEFT JOIN CONTC000Master cont ON job.GwyClosedBy = cont.ConFullName AND cont.StatusId =1 -- In(1,2)  
  WHERE   job.[Id] = @id  
  
  
  END  
    
   
END TRY                  
BEGIN CATCH                  
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                  
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                  
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                  
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                  
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetJobGatewayComplete]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group  
   All Rights Reserved Worldwide */  
-- =============================================          
-- Author:                    Akhil Chauhan           
-- Create date:               09/14/2018        
-- Description:               Get a Job Gateway  
-- Execution:                 EXEC [dbo].[GetJobGateway]    
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)      
-- Modified Desc:    
-- =============================================  
ALTER PROCEDURE  [dbo].[GetJobGatewayComplete]   
    @userId BIGINT,  
    @roleId BIGINT,  
    @orgId BIGINT,  
    @id BIGINT,  
    @parentId BIGINT  
AS  
BEGIN TRY                  
 SET NOCOUNT ON;    
     
   SELECT job.[Id]  
  ,job.[JobID]  
  ,job.[ProgramID]
  ,job.[GwyGatewayCode]  
  ,job.[GwyGatewayTitle]
  ,job.GwyShipApptmtReasonCode  
  ,job.GwyShipStatusReasonCode  
 
  
  FROM   [dbo].[JOBDL020Gateways] job  
  
 WHERE   job.[Id] = @id  
   
   
    
   
END TRY                  
BEGIN CATCH                  
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                  
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                  
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                  
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                  
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetJobGatewayView]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               09/14/2018      
-- Description:               Get all Job Gateway
-- Execution:                 EXEC [dbo].[GetJobGatewayView]  
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)   
-- Modified Desc:  
-- =============================================
ALTER PROCEDURE [dbo].[GetJobGatewayView]
 @userId BIGINT,
 @roleId BIGINT,
 @orgId BIGINT,
 @entity NVARCHAR(100),
 @pageNo INT,
 @pageSize INT,
 @orderBy NVARCHAR(500),
 @groupBy NVARCHAR(500), 
 @groupByWhere NVARCHAR(500), 
 @where NVARCHAR(500),
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

 IF @parentId = 0
 BEGIN
     
     DECLARE @prgGatewayTable TABLE(
	     [Id]                    BIGINT          IDENTITY (1, 1) NOT NULL,
    [JobID]                 BIGINT          NULL,
    [ProgramID]             BIGINT          NULL,
    [GwyGatewaySortOrder]   INT             NULL,
    [GwyGatewayCode]        NVARCHAR (20)   NULL,
    [GwyGatewayTitle]       NVARCHAR (50)   NULL,    
    [GwyGatewayDuration]    DECIMAL (18, 2) NULL,
	[GatewayUnitId]         INT             NULL,
	[GwyGatewayDefault]     BIT             NULL,
	[GatewayTypeId]         INT             NULL,  
    [GwyDateRefTypeId]      INT             NULL,
    [StatusId]              INT             NULL
     )

	-- INSERT INTO @prgGatewayTable(JobID,ProgramID,GwyGatewaySortOrder,GwyGatewayCode,GwyGatewayTitle,GwyGatewayDuration,GatewayUnitId,GwyGatewayDefault,GatewayTypeId,GwyDateRefTypeId,StatusId)
	--SELECT   
	-- 0
 --   ,prgm.[PgdProgramID]          
 --   ,prgm.[PgdGatewaySortOrder]   
 --   ,prgm.[PgdGatewayCode]        
 --   ,prgm.[PgdGatewayTitle] 
 --   ,prgm.[PgdGatewayDuration]    
 --   ,prgm.[UnitTypeId]            
 --   ,prgm.[PgdGatewayDefault]     
 --   ,prgm.[GatewayTypeId]         
 --   ,prgm.[GatewayDateRefTypeId]  
 --   ,prgm.[StatusId]   
	-- FROM [dbo].[PRGRM010Ref_GatewayDefaults] prgm
	-- INNER JOIN  [dbo].[fnGetUserStatuses](@userId) fgus ON prgm.StatusId = fgus.StatusId
	-- WHERE PgdGatewayDefault = 1;

	-- SELECT @TotalCount = COUNT(Id) FROM @prgGatewayTable
	 
	-- SELECT * FROM @prgGatewayTable 
	-- ORDER BY Id
	-- OFFSET @pageSize * (@pageNo - 1) ROWS FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE)

 END
 ELSE
 BEGIN


SET @TCountQuery = 'SELECT @TotalCount = COUNT(Id) FROM [dbo].[JOBDL020Gateways] (NOLOCK) '+ @entity 

--Below for getting user specific 'Statuses'
--IF((ISNULL(@where, '') = '') OR (@where NOT LIKE '%'+@entity+'.StatusId%'))
--	BEGIN
--		SET @TCountQuery = @TCountQuery + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) fgus ON ' + @entity + '.[StatusId] = fgus.[StatusId] '
--	END

SET @TCountQuery = @TCountQuery + ' WHERE [JobID] = @parentId ' + ISNULL(@where, '')

EXEC sp_executesql @TCountQuery, N'@parentId BIGINT, @userId BIGINT, @TotalCount INT OUTPUT', @parentId, @userId, @TotalCount  OUTPUT;

IF(@recordId = 0)
	BEGIN
		SET @sqlCommand = 'SELECT ' + [dbo].[fnGetBaseQueryByUserId](@entity, @userId) 
		SET @sqlCommand = @sqlCommand + ' , job.[JobSiteCode] AS JobIDName, prg.[PrgProgramTitle] AS ProgramIDName , CASE WHEN cont.Id > 0 OR ' + @entity + '.GwyClosedBy IS NULL THEN CAST(1 AS BIT) ELSE CAST(0 AS BIT) END  AS ClosedByContactExist, job.[JobCompleted] AS JobCompleted'
		SET @sqlCommand = @sqlCommand + '  , respContact.[ConFullName] AS GwyGatewayResponsibleName ,  anaContact.[ConFullName] AS GwyGatewayAnalystName '
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

SET @sqlCommand = @sqlCommand + ' FROM [dbo].[JOBDL020Gateways] (NOLOCK) '+ @entity

--Below to get BIGINT reference key name by Id if NOT NULL
SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[JOBDL000Master] (NOLOCK) job ON ' + @entity + '.[JobID]=job.[Id] '
SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[PRGRM000Master] (NOLOCK) prg ON ' + @entity + '.[ProgramID]=prg.[Id] ';
SET @sqlCommand = @sqlCommand + ' LEFT JOIN CONTC000Master cont ON ' + @entity + '.GwyClosedBy = cont.ConFullName AND cont.StatusId  =1 '
SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[CONTC000Master] (NOLOCK) respContact ON ' + @entity + '.[GwyGatewayResponsible]=respContact.[Id] '
SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[CONTC000Master] (NOLOCK) anaContact ON ' + @entity + '.[GwyGatewayAnalyst]=anaContact.[Id] '

--Below for getting user specific 'Statuses'
--IF((ISNULL(@where, '') = '') OR (@where NOT LIKE '%'+@entity+'.StatusId%'))
--	BEGIN
--		SET @sqlCommand = @sqlCommand + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) hfk ON ISNULL(' + @entity + '.[StatusId], 1) = hfk.[StatusId] '
--	END

SET @sqlCommand = @sqlCommand + ' WHERE '+@entity+'.[JobID]=@parentId '+ ISNULL(@where, '')

IF((@recordId > 0) AND (((@isNext = 0) AND (@isEnd = 0)) OR ((@isNext = 1) AND (@isEnd = 0))))
	BEGIN
		IF((@isNext = 0) AND (@isEnd = 0))  
   BEGIN  
	IF(ISNULL(@orderBy, '') <> '')
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND ' + @orderBy + ' <= (SELECT ' + @orderBy + ' FROM [dbo].[JOBDL020Gateways] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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
		SET @sqlCommand = @sqlCommand + ' AND ' + @orderBy + ' >= (SELECT ' + @orderBy + ' FROM [dbo].[JOBDL020Gateways] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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

EXEC sp_executesql @sqlCommand, N'@pageNo INT, @pageSize INT,@orderBy NVARCHAR(500), @where NVARCHAR(500), @parentId BIGINT, @entity NVARCHAR(100),@userId BIGINT' ,
	 @entity= @entity,
     @pageNo= @pageNo, 
     @pageSize= @pageSize,
     @orderBy = @orderBy,
     @where = @where,
	 @parentId = @parentId,
	 @userId = @userId
END
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetJobMapRoute]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               01/31/2018      
-- Description:               Get a JobMapRoute
-- Execution:                 EXEC [dbo].[GetJobMapRoute]  
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)   
-- Modified Desc:  
-- =============================================   
ALTER PROCEDURE [dbo].[GetJobMapRoute]  
	@userId BIGINT,  
	@roleId BIGINT,  
	@orgId BIGINT,  
	@id BIGINT  
AS  
BEGIN TRY                  
 SET NOCOUNT ON;     
  SELECT job.[Id]  
  ,job.[StatusId]  
  ,job.[JobLatitude]  
  ,job.[JobLongitude]  
  ,job.[EnteredBy]  
  ,job.[DateEntered]  
  ,job.[ChangedBy]  
  ,job.[DateChanged]  
  FROM [dbo].[JOBDL000Master] job  
 WHERE [Id] = @id  
END TRY                  
BEGIN CATCH                  
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                  
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                  
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                  
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                  
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetJobRefCostSheet]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               09/14/2018      
-- Description:               Get a Job Ref Cost Sheet
-- Execution:                 EXEC [dbo].[GetJobRefCostSheet] 
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)   
-- Modified Desc:  
-- =============================================
ALTER PROCEDURE  [dbo].[GetJobRefCostSheet]
    @userId BIGINT,
    @roleId BIGINT,
	@orgId BIGINT,
    @id BIGINT
AS
BEGIN TRY                
 SET NOCOUNT ON;   
  SELECT job.[Id]
		,job.[JobID]
		,job.[CstLineItem]
		,job.[CstChargeID]
		,job.[CstChargeCode]
		,job.[CstTitle]
		,job.[CstSurchargeOrder]
		,job.[CstSurchargePercent]
		,job.[ChargeTypeId]
		,job.[CstNumberUsed]
		,job.[CstDuration]
		,job.[CstQuantity]
		,job.[CostUnitId]
		,job.[CstCostRate]
		,job.[CstCost]
		,job.[CstMarkupPercent]
		,job.[CstRevenueRate]
		,job.[CstRevDuration]
		,job.[CstRevQuantity]
		,job.[CstRevBillable]
		,job.[StatusId]
		,job.[EnteredBy]
		,job.[DateEntered]
		,job.[ChangedBy]
		,job.[DateChanged]
  FROM   [dbo].[JOBDL060Ref_CostSheetJob] job
 WHERE   [Id] = @id
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetJobRefCostSheetView]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               09/14/2018      
-- Description:               Get all Job Ref Cost Sheet
-- Execution:                 EXEC [dbo].[GetJobRefCostSheetView] 
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)   
-- Modified Desc:  
-- ============================================= 
ALTER PROCEDURE [dbo].[GetJobRefCostSheetView]
 @userId BIGINT,
 @roleId BIGINT,
 @orgId BIGINT,
 @entity NVARCHAR(100),
 @pageNo INT,
 @pageSize INT,
 @orderBy NVARCHAR(500),
 @groupBy NVARCHAR(500), 
 @groupByWhere NVARCHAR(500), 
 @where NVARCHAR(500),
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

SET @TCountQuery = 'SELECT @TotalCount = COUNT(Id) FROM [dbo].[JOBDL060Ref_CostSheetJob] (NOLOCK) '+ @entity 

--Below for getting user specific 'Statuses'
IF((ISNULL(@where, '') = '') OR (@where NOT LIKE '%'+@entity+'.StatusId%'))
	BEGIN
		SET @TCountQuery = @TCountQuery + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) fgus ON ' + @entity + '.[StatusId] = fgus.[StatusId] '
	END

SET @TCountQuery = @TCountQuery + ' WHERE [JobID] = @parentId ' + ISNULL(@where, '')

EXEC sp_executesql @TCountQuery, N'@parentId BIGINT,@userId BIGINT, @TotalCount INT OUTPUT', @parentId, @userId, @TotalCount  OUTPUT;

IF(@recordId = 0)
	BEGIN
		SET @sqlCommand = 'SELECT ' + [dbo].[fnGetBaseQueryByUserId](@entity, @userId) 
		SET @sqlCommand = @sqlCommand + ' , job.[JobSiteCode] AS JobIDName '
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

SET @sqlCommand = @sqlCommand + ' FROM [dbo].[JOBDL060Ref_CostSheetJob] (NOLOCK) '+ @entity

--Below to get BIGINT reference key name by Id if NOT NULL
SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[JOBDL000Master] (NOLOCK) job ON ' + @entity + '.[JobID]=job.[Id] '

--Below for getting user specific 'Statuses'
IF((ISNULL(@where, '') = '') OR (@where NOT LIKE '%'+@entity+'.StatusId%'))
	BEGIN
		SET @sqlCommand = @sqlCommand + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) hfk ON ISNULL(' + @entity + '.[StatusId], 1) = hfk.[StatusId] '
	END

SET @sqlCommand = @sqlCommand + ' WHERE '+@entity+'.[JobID]=@parentId '+ ISNULL(@where, '')

IF((@recordId > 0) AND (((@isNext = 0) AND (@isEnd = 0)) OR ((@isNext = 1) AND (@isEnd = 0))))
	BEGIN
		IF((@isNext = 0) AND (@isEnd = 0))  
   BEGIN  
	IF(ISNULL(@orderBy, '') <> '')
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND ' + @orderBy + ' <= (SELECT ' + @orderBy + ' FROM [dbo].[JOBDL060Ref_CostSheetJob] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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
		SET @sqlCommand = @sqlCommand + ' AND ' + @orderBy + ' >= (SELECT ' + @orderBy + ' FROM [dbo].[JOBDL060Ref_CostSheetJob] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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

EXEC sp_executesql @sqlCommand, N'@pageNo INT, @pageSize INT,@orderBy NVARCHAR(500), @where NVARCHAR(500), @parentId BIGINT, @entity NVARCHAR(100),@userId BIGINT' ,
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
/****** Object:  StoredProcedure [dbo].[GetJobRefStatus]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               09/14/2018      
-- Description:               Get a Job Ref Status
-- Execution:                 EXEC [dbo].[GetJobRefStatus] 
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)    
-- Modified Desc:  
-- =============================================
ALTER PROCEDURE  [dbo].[GetJobRefStatus]
    @userId BIGINT,
    @roleId BIGINT,
	@orgId BIGINT,
    @id BIGINT
AS
BEGIN TRY                
 SET NOCOUNT ON;   
  SELECT job.[Id]
		,job.[JobID]
		,job.[JbsOutlineCode]
		,job.[JbsStatusCode]
		,job.[JbsTitle]
		,job.[StatusId]
		,job.[SeverityId]
		,job.[EnteredBy]
		,job.[DateEntered]
		,job.[ChangedBy]
		,job.[DateChanged]
  FROM   [dbo].[JOBDL050Ref_Status] job
 WHERE   [Id] = @id
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetJobRefStatusView]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               09/14/2018      
-- Description:               Get all Job Ref Status
-- Execution:                 EXEC [dbo].[GetJobRefStatusView] 
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)   
-- Modified Desc:  
-- ============================================= 
ALTER PROCEDURE [dbo].[GetJobRefStatusView]
 @userId BIGINT,
 @roleId BIGINT,
 @orgId BIGINT,
 @entity NVARCHAR(100),
 @pageNo INT,
 @pageSize INT,
 @orderBy NVARCHAR(500),
 @groupBy NVARCHAR(500), 
 @groupByWhere NVARCHAR(500), 
 @where NVARCHAR(500),
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

SET @TCountQuery = 'SELECT @TotalCount = COUNT(Id) FROM [dbo].[JOBDL050Ref_Status] (NOLOCK) '+ @entity 

--Below for getting user specific 'Statuses'
IF((ISNULL(@where, '') = '') OR (@where NOT LIKE '%'+@entity+'.StatusId%'))
	BEGIN
		SET @TCountQuery = @TCountQuery + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) fgus ON ' + @entity + '.[StatusId] = fgus.[StatusId] '
	END

SET @TCountQuery = @TCountQuery + ' WHERE [JobID] = @parentId ' + ISNULL(@where, '')

EXEC sp_executesql @TCountQuery, N'@parentId BIGINT, @userId BIGINT, @TotalCount INT OUTPUT', @parentId, @userId, @TotalCount  OUTPUT;

IF(@recordId = 0)
	BEGIN
		SET @sqlCommand = 'SELECT ' + [dbo].[fnGetBaseQueryByUserId](@entity, @userId) 
		SET @sqlCommand = @sqlCommand + ' , job.[JobSiteCode] AS JobIDName '
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

SET @sqlCommand = @sqlCommand + ' FROM [dbo].[JOBDL050Ref_Status] (NOLOCK) '+ @entity

--Below to get BIGINT reference key name by Id if NOT NULL
SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[JOBDL000Master] (NOLOCK) job ON ' + @entity + '.[JobID]=job.[Id] '

--Below for getting user specific 'Statuses'
IF((ISNULL(@where, '') = '') OR (@where NOT LIKE '%'+@entity+'.StatusId%'))
	BEGIN
		SET @sqlCommand = @sqlCommand + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) hfk ON ISNULL(' + @entity + '.[StatusId], 1) = hfk.[StatusId] '
	END

SET @sqlCommand = @sqlCommand + ' WHERE '+@entity+'.[JobID]=@parentId '+ ISNULL(@where, '')

IF((@recordId > 0) AND (((@isNext = 0) AND (@isEnd = 0)) OR ((@isNext = 1) AND (@isEnd = 0))))
	BEGIN
		IF((@isNext = 0) AND (@isEnd = 0))  
   BEGIN  
	IF(ISNULL(@orderBy, '') <> '')
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND ' + @orderBy + ' <= (SELECT ' + @orderBy + ' FROM [dbo].[JOBDL050Ref_Status] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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
		SET @sqlCommand = @sqlCommand + ' AND ' + @orderBy + ' >= (SELECT ' + @orderBy + ' FROM [dbo].[JOBDL050Ref_Status] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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

EXEC sp_executesql @sqlCommand, N'@pageNo INT, @pageSize INT,@orderBy NVARCHAR(500), @where NVARCHAR(500), @parentId BIGINT, @entity NVARCHAR(100),@userId BIGINT' ,
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
/****** Object:  StoredProcedure [dbo].[GetJobResponsibleComboboxContacts]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
  
/* Copyright (2018) Meridian Worldwide Transportation Group    
   All Rights Reserved Worldwide */    
-- =============================================            
-- Author:                    Janardana                 
-- Create date:               02/17/2018          
-- Description:               Get Program Gateway Responsible based on organization      
-- Execution:                 EXEC [dbo].[GetJobResponsibleComboboxContacts] 1,2    
-- Modified on:      
-- Modified Desc:      
-- =============================================                              
ALTER PROCEDURE [dbo].[GetJobResponsibleComboboxContacts]                 
 @orgId BIGINT = 0 ,                    
 @programId BIGINT                      
AS                              
BEGIN TRY                              
                
  SET NOCOUNT ON;      
      
  SELECT DISTINCT cont.Id,      
   cont.ConFullName,      
         cont.ConJobTitle,      
   cont.ConCompany,      
   cont.ConFileAs        
  FROM  CONTC000MASTER cont      
  INNER JOIN [dbo].[PRGRM010Ref_GatewayDefaults] pr      
  ON cont.Id = pr.[PgdGatewayResponsible]   
  WHERE pr.PgdProgramID = @programId      
  AND  cont.StatusId In(1,2)  

  UNION  

SELECT contact.Id,contact.ConFullName,contact.ConJobTitle,contact.ConCompany ,contact.ConFileAs 
FROM  [dbo].CONTC000Master contact  
INNER JOIN  [dbo].[PRGRM020Program_Role] prgRole ON contact.Id = prgRole.[PrgRoleContactID] AND   prgRole.ProgramID = @programId AND prgRole.PrxJobDefaultResponsible =1
WHERE  contact.StatusId In(1,2)  
AND prgRole.StatusId In(1,2) 

  --AND pr.OrgID=1      
                       
END TRY                              
BEGIN CATCH                              
                               
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                        
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                        
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                        
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                              
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetJobSeller]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               01/31/2018      
-- Description:               Get a JobSeller 
-- Execution:                 EXEC [dbo].[GetJobSeller]
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)    
-- Modified Desc:  
-- =============================================  
ALTER PROCEDURE [dbo].[GetJobSeller]  
	@userId BIGINT,  
	@roleId BIGINT,  
	@orgId BIGINT,  
	@id BIGINT ,
	@parentId BIGINT 
AS  
BEGIN TRY                  
 SET NOCOUNT ON;     
  IF @id = 0 
 BEGIN
      DECLARE @pickupTime TIME,@deliveryTime TIME
		 SELECT @pickupTime = CAST(PrgPickUpTimeDefault AS TIME)
			   ,@deliveryTime =CAST(PrgDeliveryTimeDefault AS TIME)
		 FROM PRGRM000MASTER WHERE Id = @parentId;

		 SELECT @parentId AS ProgramID
		        ,CAST(CAST(GETUTCDATE() as DATE) AS DATETIME) + CAST(@deliveryTime AS datetime) AS JobDeliveryDateTimePlanned
				,CAST(CAST(GETUTCDATE() as DATE) AS DATETIME) + CAST(@deliveryTime AS datetime) AS JobDeliveryDateTimeActual
				,CAST(CAST(GETUTCDATE() as DATE) AS DATETIME) + CAST(@deliveryTime AS datetime) AS JobDeliveryDateTimeBaseline
				,CAST(CAST(GETUTCDATE() as DATE) AS DATETIME) + CAST(@pickupTime AS datetime) AS JobOriginDateTimePlanned
				,CAST(CAST(GETUTCDATE() as DATE) AS DATETIME) + CAST(@pickupTime AS datetime) AS JobOriginDateTimeActual
				,CAST(CAST(GETUTCDATE() as DATE) AS DATETIME) + CAST(@pickupTime AS datetime) AS JobOriginDateTimeBaseline

 END
 ELSE
 BEGIN
 
  
 SELECT  job.Id  
   ,job.StatusId  
   ,job.JobSellerCode          
   ,job.JobSellerSitePOC          
   ,job.JobSellerSitePOCPhone     
   ,job.JobSellerSitePOCEmail     
   ,job.JobSellerSitePOC2         
   ,job.JobSellerSitePOCPhone2    
   ,job.JobSellerSitePOCEmail2    
   ,job.JobSellerSiteName         
   ,job.JobSellerStreetAddress    
   ,job.JobSellerStreetAddress2   
   ,job.JobSellerCity          
   ,job.JobSellerState          
   ,job.JobSellerPostalCode       
   ,job.JobSellerCountry        
   ,job.JobDeliverySitePOC         
   ,job.JobDeliverySitePOCPhone   
   ,job.JobDeliverySitePOCEmail   
   ,job.JobDeliverySiteName     
   ,job.JobDeliveryStreetAddress  
   ,job.JobDeliveryStreetAddress2  
   ,job.JobDeliveryCity      
   ,job.JobDeliveryState     
   ,job.JobDeliveryPostalCode    
   ,job.JobDeliveryCountry   
   ,job.JobDeliveryTimeZone     
   ,job.JobDeliveryDateTimePlanned    
     
   ,job.JobDeliveryDateTimeActual    
   
   ,job.JobDeliveryDateTimeBaseline    
     ,job.[JobCompleted]
  ,job.[EnteredBy]  
  ,job.[DateEntered]  
  ,job.[ChangedBy]  
  ,job.[DateChanged]  
  FROM [dbo].[JOBDL000Master] job  
 WHERE [Id] = @id  
 END
END TRY                  
BEGIN CATCH                  
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                  
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                  
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                  
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                  
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetJobTreeViewData]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Janardana        
-- Create date:               11/02/2018      
-- Description:               Get all Customer Job treeview Data under the specified Organization 
-- Execution:                 EXEC [dbo].[GetJobSeller]
-- Modified on:  
-- Modified Desc:  
-- =============================================                   
ALTER PROCEDURE [dbo].[GetJobTreeViewData]                     
 @orgId BIGINT = 0,
 @parentId BIGINT,  
 @model NVARCHAR(100)       
AS                    
BEGIN TRY                    
                     
 SET NOCOUNT ON;            
    
  IF @parentId IS NULL -- AND @model = 'Customer'  
  BEGIN  
  SELECT DISTINCT c.Id As Id   
          , NULL  As ParentId  
          ,c.CustCode As [Name]    
             ,c.CustCode As [Text]    
             ,c.CustTitle As ToolTip    
			 ,'Customer'  As Model        
          FROM  [dbo].[PRGRM000Master] prg  
    INNER JOIN [dbo].[CUST000Master] (NOLOCK) c    
    ON c.Id = prg.PrgCustID  
   WHERE c.CustOrgID = @orgId  AND c.StatusId = 1 AND prg.StatusId =1;    
  END  
  
  ELSE IF @parentId IS NOT  NULL AND @model = 'Customer'  
  BEGIN  
  
    SELECT prg.Id As Id   
           ,cst.Id as ParentId  
        ,prg.[PrgProgramCode] AS Name    
        ,prg.[PrgProgramCode]  AS [Text]    
        ,prg.[PrgProgramTitle]  AS  ToolTip   
       ,'Program'  As Model  
   FROM [dbo].[PRGRM000Master](NOLOCK) prg      
     INNER JOIN CUST000Master cst ON prg.PrgCustID = cst.Id    
   WHERE prg.StatusId = 1 AND prg.[PrgHierarchyLevel] = 1 AND PrgCustID= @parentId; 
  END  
  ELSE   
  BEGIN  
     DECLARE @HierarchyID NVARCHAR(100),@HierarchyLevel INT  
  SELECT @HierarchyID = PrgHierarchyID.ToString(),  
         @HierarchyLevel = PrgHierarchyLevel  
   FROM [PRGRM000Master] WHERE Id = @parentId;  
     
     
    SELECT prg.Id As Id   
           ,@parentId as ParentId  
        ,prg.[PrgProgramCode] AS Name    
    ,prg.[PrgProgramCode]  AS [Text]    
    ,prg.[PrgProgramTitle]  AS  ToolTip   
    ,'Program'  As Model   
        
   FROM [dbo].[PRGRM000Master](NOLOCK) prg      
     INNER JOIN CUST000Master cst ON prg.PrgCustID = cst.Id    
   WHERE prg.StatusId = 1    
        AND prg.PrgHierarchyID.ToString() LIKE @HierarchyID+'%'   
     AND prg.PrgHierarchyLevel = (PrgHierarchyLevel + 1);    
    
  END  
END TRY                    
BEGIN CATCH                    
                    
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                    
                    
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetJobView]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               09/14/2018      
-- Description:               Get all Job 
-- Execution:                 EXEC [dbo].[GetJobView]
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)   
-- Modified Desc:  
-- =============================================    
ALTER PROCEDURE [dbo].[GetJobView]      
 @userId BIGINT,      
 @roleId BIGINT,      
 @orgId BIGINT,      
 @entity NVARCHAR(100),      
 @pageNo INT,      
 @pageSize INT,      
 @orderBy NVARCHAR(500), 
 @groupBy NVARCHAR(500), 
 @groupByWhere NVARCHAR(500),      
 @where NVARCHAR(500),      
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

      
SET @TCountQuery = 'SELECT @TotalCount = COUNT(Id) FROM [dbo].[JOBDL000Master] (NOLOCK) '+ @entity     
    
--Below for getting user specific 'Statuses'    
IF((ISNULL(@where, '') = '') OR (@where NOT LIKE '%'+@entity+'.StatusId%'))    
 BEGIN    
  SET @TCountQuery = @TCountQuery + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) fgus ON ' + @entity + '.[StatusId] = fgus.[StatusId] '    
 END    
     
SET @TCountQuery =  @TCountQuery + ' WHERE 1=1 AND ProgramID = ISNULL(@parentId,ProgramID) ' + ISNULL(@where, '')     
    
EXEC sp_executesql @TCountQuery, N'@TotalCount INT OUTPUT, @userId BIGINT,@parentId BIGINT', @TotalCount  OUTPUT, @userId, @parentId = @parentId;      
      
IF(@recordId = 0)    
 BEGIN       
  SET @sqlCommand = 'SELECT ' + [dbo].[fnGetBaseQueryByUserId](@entity, @userId) 
  
  SET @sqlCommand = @sqlCommand + ' , CASE WHEN prg.PrgHierarchyLevel = 1 THEN prg.PrgProgramCode
                                  WHEN prg.PrgHierarchyLevel = 2 THEN prg.PrgProjectCode
							 WHEN prg.PrgHierarchyLevel = 3 THEN prg.PrgPhaseCode
							 ELSE prg.PrgProgramTitle END  AS ProgramIDName '
  
        
  SET @sqlCommand = @sqlCommand + ' , cont.[ConFullName] AS JobDeliveryResponsibleContactIDName, anaCont.[ConFullName] AS JobDeliveryAnalystContactIDName,driverCont.[ConFullName] AS JobDriverIdName'    
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
    
SET @sqlCommand = @sqlCommand + ' FROM [dbo].[JOBDL000Master] (NOLOCK) '+ @entity      
    
--Below to get BIGINT reference key name by Id if NOT NULL    
SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[PRGRM000Master] (NOLOCK) prg ON ' + @entity + '.[ProgramID]=prg.[Id] '    
SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[CONTC000Master] (NOLOCK) cont ON ' + @entity + '.[JobDeliveryResponsibleContactID]=cont.[Id] '
SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[CONTC000Master] (NOLOCK) anaCont ON ' + @entity + '.[JobDeliveryAnalystContactID]=anaCont.[Id] '    
SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[CONTC000Master] (NOLOCK) driverCont ON ' + @entity + '.[JobDriverId]=driverCont.[Id] '    

    
--Below for getting user specific 'Statuses'    
IF((ISNULL(@where, '') = '') OR (@where NOT LIKE '%'+@entity+'.StatusId%'))    
 BEGIN    
  SET @sqlCommand = @sqlCommand + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) hfk ON ISNULL(' + @entity + '.[StatusId], 1) = hfk.[StatusId] '    
 END    
    
SET @sqlCommand = @sqlCommand + ' WHERE 1=1 AND '+@entity+'.ProgramID = ISNULL(@parentId,'+@entity+'.ProgramID)'+ ISNULL(@where, '')      
      
IF((@recordId > 0) AND (((@isNext = 0) AND (@isEnd = 0)) OR ((@isNext = 1) AND (@isEnd = 0))))    
 BEGIN    
  IF((@isNext = 0) AND (@isEnd = 0))  
   BEGIN  
	IF(ISNULL(@orderBy, '') <> '')
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND ' + @orderBy + ' <= (SELECT ' + @orderBy + ' FROM [dbo].[JOBDL000Master] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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
		SET @sqlCommand = @sqlCommand + ' AND ' + @orderBy + ' >= (SELECT ' + @orderBy + ' FROM [dbo].[JOBDL000Master] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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
      
EXEC sp_executesql @sqlCommand, N'@pageNo INT, @pageSize INT,@orderBy NVARCHAR(500), @where NVARCHAR(500), @orgId BIGINT, @entity NVARCHAR(100),@parentId BIGINT,@userId BIGINT' ,      
  @entity= @entity,      
 @pageNo= @pageNo,       
     @pageSize= @pageSize,      
     @orderBy = @orderBy,      
     @where = @where,      
  @orgId = @orgId,    
  @parentId = @parentId ,    
  @userId = @userId    
END TRY                      
BEGIN CATCH                      
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                      
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                      
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                      
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                      
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetLastItemNumber]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


 /* Copyright (2018) Meridian Worldwide Transportation Group  
   All Rights Reserved Worldwide */  
-- =============================================          
-- Author:                    Janardana Behara           
-- Create date:               01/02/2018        
-- Description:               Get Last Item Number   
-- Execution:                 EXEC [dbo].[GetLastItemNumber]  
-- Modified on:    
-- Modified Desc:    
-- =============================================         
ALTER PROCEDURE [dbo].[GetLastItemNumber]        
 @entity NVARCHAR(100),      
 @fieldName NVARCHAR(100),      
 @where NVARCHAR(500)=''    
AS        
BEGIN TRY                        
 SET NOCOUNT ON;  
  
 DECLARE @tableName NVARCHAR(MAX);        
 SELECT @tableName =TblTableName FROM [dbo].[SYSTM000Ref_Table] WHERE SysRefName = @entity      
 DECLARE @sqlCommand NVARCHAR(MAX);        
      
 SET @sqlCommand = 'SELECT ISNULL(Max(' + @entity + '.' + @fieldName + '),0) FROM ' + @tableName + ' (NOLOCK) ' + @entity + ' WHERE 1=1' ;
 IF @entity <> 'JobGateway'
 BEGIN
     SET @sqlCommand = @sqlCommand + ' AND ISNULL(StatusId,1) In(1,2) '+ ISNULL(@where,'')     ; 
 END
 SET @sqlCommand = @sqlCommand +  ISNULL(@where,'')     ; 

  
 EXEC(@sqlCommand)      
      
END TRY                        
BEGIN CATCH                        
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                        
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                        
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                        
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                        
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetLoginErrorMessage]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Janardana Behara         
-- Create date:               12/18/2018      
-- Description:               Get  Login error Message
-- Execution:                 EXEC [dbo].[GetLoginErrorMessage]
-- Modified on:  
-- Modified Desc:  
-- ============================================= 
ALTER PROCEDURE  [dbo].[GetLoginErrorMessage]  
    @sysmessageCode NVARCHAR(25),  
	@sysRefId INT  
AS  
BEGIN TRY                  
 SET NOCOUNT ON;    
  SELECT SysMessageDescription FROM [dbo].[SYSTM000Master] WHERE SysMessageCode = @sysmessageCode and  SysRefId = @sysRefId
  
END TRY                  
BEGIN CATCH                  
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                  
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                  
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                  
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                  
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetLookupDropDown]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Janardana Behara         
-- Create date:               01/09/2018      
-- Description:               Get Lookups from  system reference
-- Execution:                 EXEC [dbo].[GetLookupDropDown]
-- Modified on:  
-- Modified Desc:  
-- =============================================                          
ALTER PROCEDURE [dbo].[GetLookupDropDown]    
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
 @primaryKeyName NVARCHAR(50) = null    
AS                    
BEGIN TRY                    
SET NOCOUNT ON;      
DECLARE @sqlCommand NVARCHAR(MAX);    
DECLARE @newPgNo INT
SET @sqlCommand = '';  
SET @primaryKeyName = 'SysLookupId';

IF(ISNULL(@primaryKeyValue, '') > '')
 BEGIN
	IF(@langCode='EN')
		BEGIN
			SET @sqlCommand += ' SELECT @newPgNo = Item FROM (SELECT ROW_NUMBER() OVER(ORDER BY ' + @entity + '.' + @primaryKeyName+') as Item  ,' +@entity + '.' + @primaryKeyName + 
							   ' From [dbo].[SYSTM000Ref_Options] (NOLOCK) ' + @entity + ' WHERE '+ @entity +'.StatusId In (1,2)' +
							   ' ) t WHERE t.' + @primaryKeyName + '=' + @primaryKeyValue;
			EXEC sp_executesql @sqlCommand, N' @newPgNo int output',@newPgNo output                                    
			SET @newPgNo =  @newPgNo/@pageSize + 1; 
			SET @pageSize = @newPgNo * @pageSize;
			SET @sqlCommand=''
		END
	ELSE
		BEGIN
			SET @sqlCommand += ' SELECT @newPgNo = Item FROM (SELECT ROW_NUMBER() OVER(ORDER BY ' + @entity + '.' + @primaryKeyName+') as Item  ,' +@entity + '.' + @primaryKeyName + 
						   ' From [dbo].[SYSTM010Ref_Options] (NOLOCK) refOpLang INNER JOIN [dbo].[SYSTM000Ref_Options] (NOLOCK) ' + @entity + 
						   ' ON '+ @entity +'.Id = refOpLang.SysRefId WHERE '+ @entity +'.StatusId In (1,2)' +
						   ' ) t WHERE t.' + @primaryKeyName + '=' + @primaryKeyValue;
			EXEC sp_executesql @sqlCommand, N' @newPgNo int output',@newPgNo output                                    
			SET @newPgNo =  @newPgNo/@pageSize + 1; 
			SET @pageSize = @newPgNo * @pageSize;
			SET @sqlCommand=''
		END
 END



IF(@langCode='EN')    
 BEGIN    
  SET @sqlCommand = 'SELECT DISTINCT '+@entity+'.SysLookupId as SysRefId, '+@entity+'.SysLookupCode as SysRefName,'+@entity+'.SysLookupCode as LangName FROM [dbo].[SYSTM000Ref_Options] '+ @entity +' (NOLOCK) WHERE '+ @entity +'.StatusId In (1,2)' 
 END    
ELSE    
 BEGIN    
  SET @sqlCommand = 'SELECT DISTINCT refOp.SysLookupId as SysRefId, refOp.SysLookupCode as SysRefName,refOpLang.LookupName as LangName FROM [dbo].[SYSTM010Ref_Options] (NOLOCK)  refOpLang'    
  SET @sqlCommand = @sqlCommand + ' INNER JOIN [dbo].[SYSTM000Ref_Options] (NOLOCK) refOp ON refOp.Id = refOpLang.SysRefId WHERE '+ @entity +'.StatusId In (1,2)'     
 END    
   
    
IF(ISNULL(@like, '') != '')    
  BEGIN    
  SET @sqlCommand = @sqlCommand + 'AND ('    
   DECLARE @likeStmt NVARCHAR(MAX)    
  SELECT @likeStmt = COALESCE(@likeStmt + ' OR ','') + Item + ' LIKE ''%' + @like + '%' + '''' FROM [dbo].[fnSplitString](@fields, ',')    
  SET @sqlCommand = @sqlCommand + @likeStmt + ')'    
  END    
IF(ISNULL(@where, '') != '')    
 BEGIN    
  IF(ISNULL(@like, '') != '')    
   BEGIN    
    SET @sqlCommand = @sqlCommand + ' AND (' + @where +')'    
   END    
  ELSE    
   BEGIN    
    SET @sqlCommand = @sqlCommand + @where     
   END    
END    
    
SET @sqlCommand = @sqlCommand + ' ORDER BY SysRefId,SysRefName,LangName OFFSET @pageSize * (@pageNo - 1) ROWS FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);'     

EXEC sp_executesql @sqlCommand, N'@pageNo INT, @pageSize INT, @where NVARCHAR(100)' ,    
     @pageNo = @pageNo,     
     @pageSize = @pageSize,    
     @where = @where    
END TRY                    
BEGIN CATCH                    
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                    
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                    
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                    
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                    
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetMasterTableObject]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               10/25/2018      
-- Description:               Get Master object data from Column Alias
-- Execution:                 EXEC [dbo].[GetMasterTableObject]
-- Modified on:  
-- Modified Desc:  
-- =============================================
ALTER PROCEDURE [dbo].[GetMasterTableObject]
  @langCode NVARCHAR(10),
  @tableName NVARCHAR(100)
AS                
BEGIN TRY                
 SET NOCOUNT ON;   
	 SELECT cal.ColColumnName
		  ,cal.ColAliasName
		  ,cal.ColCaption
		  ,cal.ColDescription
	 FROM [dbo].[SYSTM000ColumnsAlias] (NOLOCK) cal
	 INNER JOIN [dbo].[SYSTM000Ref_Table] (NOLOCK) tbl ON tbl.SysRefName = cal.ColTableName
	 WHERE cal.[LangCode]= @langCode AND cal.ColTableName = @tableName 
END TRY                
BEGIN CATCH                
	DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
			,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
			,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 
	EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetMenuAccessLevel]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               09/22/2018      
-- Description:               Get a Sys menu access level
-- Execution:                 EXEC [dbo].[GetMenuAccessLevel]
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)   
-- Modified Desc:  
-- =============================================
ALTER PROCEDURE  [dbo].[GetMenuAccessLevel]
    @userId BIGINT,
    @roleId BIGINT,
	@orgId BIGINT,
    @langCode NVARCHAR(10),
    @id BIGINT
AS
BEGIN TRY                
 SET NOCOUNT ON;   
IF(@langCode='EN')
 BEGIN
SELECT syst.[Id]
      ,syst.[LangCode]
      ,syst.[SysRefId]
      ,syst.[MalOrder]
      ,syst.[MalTitle]
      ,syst.[DateEntered]
      ,syst.[EnteredBy]
      ,syst.[DateChanged]
      ,syst.[ChangedBy]
  FROM [dbo].[SYSTM010MenuAccessLevel] syst
 WHERE [Id]=@id 
END
ELSE
 BEGIN
SELECT syst.[Id]
      ,syst.[LangCode]
      ,syst.[SysRefId]
      ,syst.[MalOrder]
      ,syst.[MalTitle]
      ,syst.[DateEntered]
      ,syst.[EnteredBy]
      ,syst.[DateChanged]
      ,syst.[ChangedBy]
  FROM [dbo].[SYSTM010MenuAccessLevel] syst
 WHERE [Id]=@id  
 END
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetMenuAccessLevelView]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               09/22/2018      
-- Description:               Get all menu access level 
-- Execution:                 EXEC [dbo].[GetMenuAccessLevelView]
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)   
-- Modified Desc:  
-- ============================================= 
ALTER PROCEDURE [dbo].[GetMenuAccessLevelView]
 @userId BIGINT,
 @roleId BIGINT,
 @orgId BIGINT,
 @langCode NVARCHAR(10),
 @entity NVARCHAR(100),
 @pageNo INT,
 @pageSize INT,
 @orderBy NVARCHAR(500),
 @groupBy NVARCHAR(500), 
 @groupByWhere NVARCHAR(500), 
 @where NVARCHAR(500),
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

SET @TCountQuery = 'SELECT @TotalCount = COUNT(Id) FROM [dbo].[SYSTM010MenuAccessLevel] (NOLOCK) '+ @entity +' WHERE [LangCode] = @langCode ' + ISNULL(@where, '')
EXEC sp_executesql @TCountQuery, N'@langCode NVARCHAR(10), @TotalCount INT OUTPUT', @langCode, @TotalCount  OUTPUT;

IF(@recordId = 0)
	BEGIN 
		SET @sqlCommand = 'SELECT ' + [dbo].[fnGetBaseQueryByUserId](@entity, @userId) 
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

SET @sqlCommand = @sqlCommand + ' FROM [dbo].[SYSTM010MenuAccessLevel] (NOLOCK) '+ @entity

SET @sqlCommand = @sqlCommand + ' WHERE '+@entity+'.[LangCode] = @langCode '+ ISNULL(@where, '')

IF((@recordId > 0) AND (((@isNext = 0) AND (@isEnd = 0)) OR ((@isNext = 1) AND (@isEnd = 0))))
	BEGIN
		IF((@isNext = 0) AND (@isEnd = 0))  
   BEGIN  
	IF(ISNULL(@orderBy, '') <> '')
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND ' + @orderBy + ' <= (SELECT ' + @orderBy + ' FROM [dbo].[SYSTM010MenuAccessLevel] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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
		SET @sqlCommand = @sqlCommand + ' AND ' + @orderBy + ' >= (SELECT ' + @orderBy + ' FROM [dbo].[SYSTM010MenuAccessLevel] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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

EXEC sp_executesql @sqlCommand, N'@pageNo INT, @pageSize INT,@orderBy NVARCHAR(500), @where NVARCHAR(500), @orgId BIGINT, @langCode NVARCHAR(10), @entity NVARCHAR(100),@userId BIGINT' ,
     @langCode= @langCode,
	 @entity= @entity,
     @pageNo= @pageNo, 
     @pageSize= @pageSize,
     @orderBy = @orderBy,
     @where = @where,
	 @orgId = @orgId,
	 @userId = @userId
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetMenuDriver]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               04/14/2018      
-- Description:               Get all menu driver  
-- Execution:                 EXEC [dbo].[GetMenuDriver]
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)    
-- Modified Desc:  
-- =============================================
ALTER PROCEDURE [dbo].[GetMenuDriver]
	@userId BIGINT,
    @roleId BIGINT,
	@orgId BIGINT,
    @langCode NVARCHAR(10),
    @id BIGINT
AS
BEGIN TRY                
 SET NOCOUNT ON;   
	SELECT mnu.[Id]
		,mnu.[LangCode] 
		,mnu.[MnuModuleId]
		,mnu.[MnuTableName]
		,mnu.[MnuBreakDownStructure]
		,mnu.[MnuTitle]
		,mnu.[MnuTabOver]
		,mnu.[MnuMenuItem]
		,mnu.[MnuRibbon]
		,mnu.[MnuRibbonTabName]
		,mnu.[MnuIconVerySmall]
		,mnu.[MnuIconSmall]
		,mnu.[MnuIconMedium]
		,mnu.[MnuIconLarge]
		,mnu.[MnuExecuteProgram]
		,mnu.[MnuClassificationId]
		,mnu.[MnuProgramTypeId]
		,mnu.[MnuOptionLevelId]
		,mnu.[MnuAccessLevelId]
		,mnu.[MnuHelpFile]
		,mnu.[MnuHelpBookMark]
		,mnu.[MnuHelpPageNumber]
		,mnu.[StatusId]
		,mnu.[DateEntered]
		,mnu.[DateChanged]
		,mnu.[EnteredBy]
		,mnu.[ChangedBy]
	FROM [dbo].[SYSTM000MenuDriver] (NOLOCK) mnu
	WHERE mnu.[LangCode] = @langCode 
	AND mnu.Id=@id
END TRY                
BEGIN CATCH                
	DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
			,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
			,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
	EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetMenuDriverView]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               04/14/2018      
-- Description:               Get all menu driver  
-- Execution:                 EXEC [dbo].[GetMenuDriverView]
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)   
-- Modified Desc:  
-- =============================================
ALTER PROCEDURE [dbo].[GetMenuDriverView]
 @userId BIGINT,
 @roleId BIGINT,
 @orgId BIGINT,
 @langCode NVARCHAR(10),
 @entity NVARCHAR(100),
 @pageNo INT,
 @pageSize INT,
 @orderBy NVARCHAR(500),
 @groupBy NVARCHAR(500), 
 @groupByWhere NVARCHAR(500), 
 @where NVARCHAR(500),
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

SET @TCountQuery = 'SELECT @TotalCount = COUNT(Id) FROM [dbo].[SYSTM000MenuDriver] (NOLOCK) '+ @entity +' WHERE [LangCode] = @langCode ' + ISNULL(@where, '')
EXEC sp_executesql @TCountQuery, N'@langCode NVARCHAR(10), @TotalCount INT OUTPUT', @langCode, @TotalCount  OUTPUT;

IF(@recordId = 0)
	BEGIN
		SET @sqlCommand = 'SELECT ' + [dbo].[fnGetBaseQueryByUserId](@entity, @userId) 
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

SET @sqlCommand = @sqlCommand + ' FROM [dbo].[SYSTM000MenuDriver] (NOLOCK) '+ @entity
 
SET @sqlCommand = @sqlCommand + ' WHERE '+@entity+'.[LangCode] = @langCode '+ ISNULL(@where, '')

IF((@recordId > 0) AND (((@isNext = 0) AND (@isEnd = 0)) OR ((@isNext = 1) AND (@isEnd = 0))))
	BEGIN
		IF((@isNext = 0) AND (@isEnd = 0))  
   BEGIN  
	IF(ISNULL(@orderBy, '') <> '')
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND ' + @orderBy + ' <= (SELECT ' + @orderBy + ' FROM [dbo].[SYSTM000MenuDriver] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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
		SET @sqlCommand = @sqlCommand + ' AND ' + @orderBy + ' >= (SELECT ' + @orderBy + ' FROM [dbo].[SYSTM000MenuDriver] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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

EXEC sp_executesql @sqlCommand, N'@pageNo INT, @pageSize INT, @langCode NVARCHAR(10), @entity NVARCHAR(100), @orderBy NVARCHAR(500), @where NVARCHAR(500)' ,
    @entity = @entity,
    @langCode= @langCode,
    @pageNo= @pageNo, 
    @pageSize= @pageSize,
    @orderBy = @orderBy,
	@where = @where
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetMenuModuleDropdown]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Janardana         
-- Create date:               01/06/2018      
-- Description:               Get Menu driver Module Id  
-- Execution:                 EXEC [dbo].[GetMenuModuleDropdown]
-- Modified on:  
-- Modified Desc:  
-- =============================================                            
ALTER PROCEDURE [dbo].[GetMenuModuleDropdown]    
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
 @primaryKeyName NVARCHAR(50) = null      
AS                    
BEGIN TRY                    
SET NOCOUNT ON;      
 DECLARE @sqlCommand NVARCHAR(MAX);    
  
SET @sqlCommand   = 'SELECT t.*,'   
                   +'(SELECT rbn.MnuBreakdownStructure  
      from SYSTM000MenuDriver  rbn  
      LEFT JOIN SYSTM000Ref_Options refrbn On rbn.MnuModuleId = refrbn.Id   
      WHERE rbn.MnuTableName IS  NULL AND LEN(rbn.MnuBreakdownStructure) =5 AND rbn.MnuBreakdownStructure like ''01.__'' AND  rbn.MnuModuleId=t.Id ) AS RbnBreakdownStructure'  
  
     +' FROM'  
     +'( select ref.Id as Id,ref.SysOptionName as MnuTitle,mnu.MnuBreakDownStructure from SYSTM000Ref_Options  ref  
      LEFT JOIN SYSTM000MenuDriver mnu On mnu.MnuModuleId = ref.Id   
      WHERE LEN(MnuBreakdownStructure) =5  AND MnuBreakdownStructure like ''02.__''  
      ) as t'  
  
  
 IF(ISNULL(@like, '') != '')    
  BEGIN    
  SET @sqlCommand = @sqlCommand + 'AND ('    
   DECLARE @likeStmt NVARCHAR(MAX)    
  SELECT @likeStmt = COALESCE(@likeStmt + ' OR ','') + Item + ' LIKE ''%' + @like + '%' + '''' FROM [dbo].[fnSplitString](@fields, ',')    
  SET @sqlCommand = @sqlCommand + @likeStmt + ')'    
  END    
    
SET @sqlCommand = @sqlCommand + ' ORDER BY Id ';
  
EXEC sp_executesql @sqlCommand, N'@pageNo INT, @pageSize INT, @where NVARCHAR(100)' ,    
     @pageNo = @pageNo,     
     @pageSize = @pageSize,    
     @where = @where    
END TRY                    
BEGIN CATCH                    
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                    
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                    
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                    
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                    
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetMenuOptionLevel]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               08/16/2018      
-- Description:               Get a Sys menu Option level  
-- Execution:                 EXEC [dbo].[GetMenuOptionLevel]
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)    
-- Modified Desc:  
-- =============================================
ALTER PROCEDURE  [dbo].[GetMenuOptionLevel]
    @userId BIGINT,
    @roleId BIGINT,
	@orgId BIGINT,
    @langCode NVARCHAR(10),
    @id BIGINT
AS
BEGIN TRY                
 SET NOCOUNT ON;   
IF(@langCode='EN')
 BEGIN
SELECT syst.[Id]
      ,syst.[LangCode]
      ,syst.[SysRefId]
      ,syst.[MolOrder]
      ,syst.[MolMenuLevelTitle]
      ,syst.[MolMenuAccessDefault]
      ,syst.[MolMenuAccessOnly]
      ,syst.[DateEntered]
      ,syst.[EnteredBy]
      ,syst.[DateChanged]
      ,syst.[ChangedBy]
  FROM [dbo].[SYSTM010MenuOptionLevel] syst
 WHERE [Id]=@id 
END
ELSE
 BEGIN
SELECT syst.[Id]
      ,syst.[LangCode]
      ,syst.[SysRefId]
      ,syst.[MolOrder]
      ,syst.[MolMenuLevelTitle]
      ,syst.[MolMenuAccessDefault]
      ,syst.[MolMenuAccessOnly]
      ,syst.[DateEntered]
      ,syst.[EnteredBy]
      ,syst.[DateChanged]
      ,syst.[ChangedBy]
  FROM [dbo].[SYSTM010MenuOptionLevel] syst
 WHERE [Id]=@id 
 END
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetMenuOptionLevelView]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group  
   All Rights Reserved Worldwide */  
-- =============================================          
-- Author:                    Akhil Chauhan           
-- Create date:               09/22/2018        
-- Description:               Get all menu option level     
-- Execution:                 EXEC [dbo].[GetMenuOptionLevelView]  
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)      
-- Modified Desc:    
-- =============================================   
ALTER PROCEDURE [dbo].[GetMenuOptionLevelView]  
 @userId BIGINT,  
 @roleId BIGINT,  
 @orgId BIGINT,  
 @langCode NVARCHAR(10),  
 @entity NVARCHAR(100),  
 @pageNo INT,  
 @pageSize INT,  
 @orderBy NVARCHAR(500), 
 @groupBy NVARCHAR(500), 
 @groupByWhere NVARCHAR(500),  
 @where NVARCHAR(500),  
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
  
SET @TCountQuery = 'SELECT @TotalCount = COUNT(Id) FROM [dbo].[SYSTM010MenuOptionLevel] (NOLOCK) '+ @entity +' WHERE [LangCode] = @langCode ' + ISNULL(@where, '')  
EXEC sp_executesql @TCountQuery, N'@langCode NVARCHAR(10), @TotalCount INT OUTPUT', @langCode, @TotalCount  OUTPUT;  
  
IF(@recordId = 0)  
 BEGIN  
  SET @sqlCommand = 'SELECT ' + [dbo].[fnGetBaseQueryByUserId](@entity, @userId)  + ' ,acc.MalTitle as MolMenuAccessDefaultName'  
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
  
SET @sqlCommand = @sqlCommand + ' FROM [dbo].[SYSTM010MenuOptionLevel] (NOLOCK) '+ @entity  
SET @sqlCommand = @sqlCommand + ' INNER JOIN SYSTM010MenuAccessLevel (NOLOCK) acc ON '+ @entity+'.MolMenuAccessDefault = acc.MalOrder '       

  
SET @sqlCommand = @sqlCommand + ' WHERE '+@entity+'.[LangCode] = @langCode '+ ISNULL(@where, '')  
  
IF((@recordId > 0) AND (((@isNext = 0) AND (@isEnd = 0)) OR ((@isNext = 1) AND (@isEnd = 0))))  
 BEGIN  
  IF((@isNext = 0) AND (@isEnd = 0))  
   BEGIN  
	IF(ISNULL(@orderBy, '') <> '')
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND ' + @orderBy + ' <= (SELECT ' + @orderBy + ' FROM [dbo].[SYSTM010MenuOptionLevel] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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
		SET @sqlCommand = @sqlCommand + ' AND ' + @orderBy + ' >= (SELECT ' + @orderBy + ' FROM [dbo].[SYSTM010MenuOptionLevel] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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
  
EXEC sp_executesql @sqlCommand, N'@pageNo INT, @pageSize INT,@orderBy NVARCHAR(500), @where NVARCHAR(500), @orgId BIGINT, @langCode NVARCHAR(10), @entity NVARCHAR(100)' ,  
     @langCode= @langCode,  
  @entity= @entity,  
     @pageNo= @pageNo,   
     @pageSize= @pageSize,  
     @orderBy = @orderBy,  
     @where = @where,  
  @orgId = @orgId  
END TRY                  
BEGIN CATCH                  
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                  
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                  
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                  
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                  
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetMessageType]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               09/22/2018      
-- Description:               Get a message type 
-- Execution:                 EXEC [dbo].[GetMessageType]
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)    
-- Modified Desc:  
-- =============================================
ALTER PROCEDURE  [dbo].[GetMessageType]
    @userId BIGINT,
    @roleId BIGINT,
	@orgId BIGINT,
	@langCode NVARCHAR(10),
    @id BIGINT
AS
BEGIN TRY                
 SET NOCOUNT ON;   
  SELECT syst.[Id]
		,syst.[LangCode]
		,syst.[SysRefId]
		,syst.[SysMsgtypeTitle]
		,syst.[SysMsgTypeHeaderIcon]
		,syst.[SysMsgTypeIcon]
		,syst.[DateEntered]
		,syst.[EnteredBy]
		,syst.[DateChanged]
		,syst.[ChangedBy]
  FROM [dbo].[SYSMS010Ref_MessageTypes] syst
 WHERE [Id] = @id
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetMessageTypeView]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               09/22/2018      
-- Description:               Get all message type   
-- Execution:                 EXEC [dbo].[GetMessageTypeView]
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)    
-- Modified Desc:  
-- =============================================     
ALTER PROCEDURE [dbo].[GetMessageTypeView]      
 @userId BIGINT,      
 @roleId BIGINT,      
 @orgId BIGINT,      
 @langCode NVARCHAR(10),      
 @entity NVARCHAR(100),      
 @pageNo INT,      
 @pageSize INT,      
 @orderBy NVARCHAR(500),  
 @groupBy NVARCHAR(500), 
 @groupByWhere NVARCHAR(500),     
 @where NVARCHAR(500),      
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
      
SET @TCountQuery = 'SELECT @TotalCount = COUNT('+@entity+'.Id) FROM [dbo].[SYSMS010Ref_MessageTypes] '+@entity+' INNER JOIN SYSTM000Ref_Options ref ON '+@entity+'.SysRefId = ref.Id  WHERE '+@entity+'.LangCode = @langCode AND ref.SysLookupId=27 ' + ISNULL(@where, '')      
  
    
EXEC sp_executesql @TCountQuery, N'@langCode NVARCHAR(10), @TotalCount INT OUTPUT', @langCode, @TotalCount  OUTPUT;      
      
IF(@recordId = 0)      
 BEGIN      
  SET @sqlCommand = 'SELECT ' + [dbo].[fnGetBaseQueryByUserId](@entity, @userId)       
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
      
SET @sqlCommand = @sqlCommand + ' FROM [dbo].[SYSMS010Ref_MessageTypes] (NOLOCK) '+ @entity      
SET @sqlCommand = @sqlCommand + ' INNER JOIN SYSTM000Ref_Options (NOLOCK) ref ON '+ @entity+'.SysRefId = ref.Id '       
SET @sqlCommand = @sqlCommand + ' WHERE '+@entity+'.[LangCode] = @langCode  AND ref.SysLookupId=27 '+ ISNULL(@where, '')      
  
    
      
IF((@recordId > 0) AND (((@isNext = 0) AND (@isEnd = 0)) OR ((@isNext = 1) AND (@isEnd = 0))))      
 BEGIN      
  IF((@isNext = 0) AND (@isEnd = 0))  
   BEGIN  
	IF(ISNULL(@orderBy, '') <> '')
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND ' + @orderBy + ' <= (SELECT ' + @orderBy + ' FROM [dbo].[SYSMS010Ref_MessageTypes] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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
		SET @sqlCommand = @sqlCommand + ' AND ' + @orderBy + ' >= (SELECT ' + @orderBy + ' FROM [dbo].[SYSMS010Ref_MessageTypes] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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
      
EXEC sp_executesql @sqlCommand, N'@pageNo INT, @pageSize INT,@orderBy NVARCHAR(500), @where NVARCHAR(500), @orgId BIGINT,@langCode NVARCHAR(10), @entity NVARCHAR(100)' ,      
  @langCode= @langCode,      
  @entity= @entity,      
     @pageNo= @pageNo,       
     @pageSize= @pageSize,      
     @orderBy = @orderBy,      
     @where = @where,      
  @orgId = @orgId      
END TRY                      
BEGIN CATCH                      
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                      
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                      
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                      
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                      
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetModuleMenus]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               12/23/2018      
-- Description:               Get left and ribbon main module menus 
-- Execution:                 EXEC [dbo].[GetModuleMenus]
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)   
-- Modified Desc:  
-- =============================================        
ALTER PROCEDURE [dbo].[GetModuleMenus]     
 @orgId BIGINT,    
 @roleId BIGINT,    
 @langCode NVARCHAR(10)     
AS      
BEGIN TRY        
 SET NOCOUNT ON;       
  SELECT mnu.Id      
  ,mnu.[MnuModuleId]     
  ,mnu.[MnuTableName]     
  ,mnu.[MnuTitle]    
  ,mnu.MnuBreakDownStructure    
  ,mnu.[MnuTabOver]    
  ,mnu.[MnuIconVerySmall]     
  ,mnu.[MnuIconSmall]    
  ,mnu.[MnuIconMedium]    
  ,mnu.[MnuExecuteProgram]     
  ,mnu.[MnuOptionLevelId]    
  ,mnu.[MnuAccessLevelId]    
  ,mnu.[MnuProgramTypeId]    
  ,mnu.[MnuHelpBookMark]    
  ,mnu.[MnuHelpPageNumber]    
  ,mnu.[StatusId]    
 FROM [dbo].[SYSTM000MenuDriver] (NOLOCK) mnu      
 --INNER JOIN [dbo].[ORGAN040_SecurityByRole] sec ON sec.SecMainModuleId = mnu.MnuModuleId    
 --INNER JOIN [dbo].[ORGAN020Act_Roles] rol ON rol.Id = sec.OrgActRoleId    
 WHERE mnu.[LangCode] = @langCode AND (ISNULL(mnu.StatusId, 1) < 3) -- AND  sec.OrgId = @orgId AND rol.Id= @roleId AND ISNULL(sec.StatusId, 1) = 1  
 ORDER BY mnu.[MnuBreakDownStructure]       
END TRY                      
BEGIN CATCH                      
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                      
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                      
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                      
       
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                      
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetNextModuleBDS]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Janardana         
-- Create date:               04/06/2018      
-- Description:               Get Next Module Breakdown Strusture 
-- Execution:                 EXEC [dbo].[GetNextModuleBDS]
-- Modified on:  
-- Modified Desc:  
-- =============================================    
ALTER PROCEDURE [dbo].[GetNextModuleBDS] 
 @langCode NVARCHAR(10),
 @mnuRibbon BIT  
AS      
BEGIN TRY        
 SET NOCOUNT ON;       
  SELECT TOP 1 CAST(PARSENAME(MnuBreakDownStructure,2) AS VARCHAR) +'.' + FORMAT((PARSENAME(MnuBreakDownStructure,1) +1) ,'00') from SYSTM000MenuDriver
  WHERE MnuRibbon = @mnuRibbon 
    AND Len(MnuBreakDownStructure) = 5
	AND LangCode = @langCode
  Order By MnuBreakDownStructure DESC     
END TRY                      
BEGIN CATCH                      
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                      
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                      
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                      
       
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                      
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetOperations]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil         
-- Create date:               05/17/2018      
-- Description:               Get Operation for cache
-- Execution:                 EXEC [dbo].[GetOperations]
-- Modified on:  
-- Modified Desc:  
-- =============================================                       
ALTER PROCEDURE [dbo].[GetOperations]   
@langCode NVARCHAR(10),
@lookupId INT                
AS                
BEGIN TRY                
  SET NOCOUNT ON;   
	 SELECT  msgType.LangCode
			,refOp.SysOptionName as SysRefName
			,msgType.[SysMsgtypeTitle] as LangName
			,msgType.[SysMsgTypeHeaderIcon] as Icon
		FROM [dbo].[SYSMS010Ref_MessageTypes] msgType (NOLOCK)  
		INNER JOIN [dbo].[SYSTM000Ref_Options] refOp (NOLOCK) ON  msgType.SysRefId= refOp.Id
		WHERE msgType.LangCode = @langCode AND refOp.SysLookupId=  @lookupId
		ORDER BY refOp.SysSortOrder ASC
END TRY                
BEGIN CATCH                
	DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
			,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
			,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 
	EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetOrgActRole]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil         
-- Create date:               08/16/2018      
-- Description:               Get a org act role
-- Execution:                 EXEC [dbo].[GetOrgActRole]
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)    
-- Modified Desc:  
-- =============================================     
ALTER PROCEDURE  [dbo].[GetOrgActRole]  
	@userId BIGINT,  
	@roleId BIGINT,  
	@orgId BIGINT,  
	@id BIGINT  
AS  
BEGIN TRY                  
 SET NOCOUNT ON;     
 SELECT org.[Id]  
       ,org.[OrgID]  
       ,org.[OrgRoleSortOrder]  
       ,org.[OrgRefRoleId]  
       ,org.[OrgRoleDefault]  
       ,org.[OrgRoleTitle]  
       ,org.[OrgRoleContactID]  
       ,org.[RoleTypeId]  
       ,org.[OrgLogical]  
       ,org.[PrgLogical]  
       ,org.[PrjLogical]  
       ,org.[PhsLogical]  
       ,org.[JobLogical]  
       ,org.[PrxContactDefault]  
       ,org.[PrxJobDefaultAnalyst]  
	   ,org.[PrxJobDefaultResponsible]  
       ,org.[PrxJobGWDefaultAnalyst]  
       ,org.[PrxJobGWDefaultResponsible]  
	   ,org.[StatusId]  
       ,org.[DateEntered]  
       ,org.[EnteredBy]  
       ,org.[DateChanged]  
       ,org.[ChangedBy]  
	   ,orgRole.[OrgRoleCode] AS 'RoleCode'
	   ,con.[ConFullName] as  'OrgRoleContactIDName'
  FROM [dbo].[ORGAN020Act_Roles] org 
  INNER JOIN [dbo].[ORGAN010Ref_Roles] orgRole ON org.OrgRefRoleId = orgRole.Id 
  LEFT JOIN [dbo].[CONTC000Master] con ON org.OrgRoleContactID = con.Id 
 WHERE org.[Id]=@id   
END TRY                  
BEGIN CATCH                  
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                  
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                  
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                  
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                  
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetOrgActRoleView]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               08/16/2018      
-- Description:               Get all organization act role
-- Execution:                 EXEC [dbo].[GetOrgActRoleView]
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)   
-- Modified Desc:  
-- ============================================= 
    
ALTER PROCEDURE [dbo].[GetOrgActRoleView]  
 @userId BIGINT,  
 @roleId BIGINT,  
 @orgId BIGINT,  
 @entity NVARCHAR(100),  
 @pageNo INT,  
 @pageSize INT,  
 @orderBy NVARCHAR(500), 
 @groupBy NVARCHAR(500), 
 @groupByWhere NVARCHAR(500),  
 @where NVARCHAR(500),  
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
  
SET @TCountQuery = 'SELECT @TotalCount = COUNT(Id) FROM [dbo].[ORGAN020Act_Roles] (NOLOCK) '+ @entity   
  
--Below for getting user specific 'Statuses'  
IF((ISNULL(@where, '') = '') OR (@where NOT LIKE '%'+@entity+'.StatusId%'))  
 BEGIN  
  SET @TCountQuery = @TCountQuery + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) fgus ON ISNULL(' + @entity + '.[StatusId], 1) = fgus.[StatusId] '  
 END  
  
IF(@parentId > 0)  
 BEGIN  
  SET @TCountQuery = @TCountQuery + ' WHERE [OrgID] = @parentId ' + ISNULL(@where, '')  
 END  
ELSE  
 BEGIN  
  SET @TCountQuery = @TCountQuery + ' WHERE [OrgID] = @orgId ' + ISNULL(@where, '')  
 END  
  
EXEC sp_executesql @TCountQuery, N'@orgId BIGINT, @parentId BIGINT, @userId BIGINT, @TotalCount INT OUTPUT', @orgId, @parentId, @userId, @TotalCount  OUTPUT;  
  
IF(@recordId = 0)  
 BEGIN  
  SET @sqlCommand = 'SELECT ' + [dbo].[fnGetBaseQueryByUserId](@entity, @userId)  ;
 
  --IF(CHARINDEX(@entity+'.OrgRoleTitle',@sqlCommand) > 0)
  --BEGIN
  --   SET  @sqlCommand = REPLACE(@sqlCommand, @entity+'.OrgRoleTitle', 'rol.OrgRoleTitle');
  --END
   
  SET @sqlCommand = @sqlCommand + ' ,org.[OrgCode] AS OrgIDName, org.Id AS OrganizationId, cont.[ConFullName] AS OrgRoleContactIDName, rol.OrgRoleCode as OrgRefRoleIdName, ' + @entity + '.StatusId as PreviousStatusId '  
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
  
SET @sqlCommand = @sqlCommand + ' FROM [dbo].[ORGAN020Act_Roles] (NOLOCK) '+ @entity  
  
--Below to get BIGINT reference key name by Id if NOT NULL  
SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[ORGAN000Master] (NOLOCK) org ON ' + @entity + '.[OrgID]=org.[Id] '  
SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[ORGAN010Ref_Roles] (NOLOCK) rol ON ' + @entity + '.[OrgRefRoleId] = rol.[Id] '      
SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[CONTC000Master] (NOLOCK) cont ON ' + @entity + '.[OrgRoleContactID]=cont.[Id] '  
  
--Below for getting user specific 'Statuses'  
IF((ISNULL(@where, '') = '') OR (@where NOT LIKE '%'+@entity+'.StatusId%'))  
 BEGIN  
  SET @sqlCommand = @sqlCommand + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) hfk ON ISNULL(' + @entity + '.[StatusId], 1) = hfk.[StatusId] '  
 END  
  
IF(@parentId > 0)  
 BEGIN  
  SET @sqlCommand = @sqlCommand + ' WHERE '+@entity+'.[OrgID] = @parentId '+ ISNULL(@where, '')  
 END  
ELSE  
 BEGIN  
  SET @sqlCommand = @sqlCommand + ' WHERE '+@entity+'.[OrgID] = @orgId '+ ISNULL(@where, '')  
 END  
  
IF((@recordId > 0) AND (((@isNext = 0) AND (@isEnd = 0)) OR ((@isNext = 1) AND (@isEnd = 0))))  
 BEGIN  
  IF((@isNext = 0) AND (@isEnd = 0))  
   BEGIN  
	IF(ISNULL(@orderBy, '') <> '')
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND ' + @orderBy + ' <= (SELECT ' + @orderBy + ' FROM [dbo].[ORGAN020Act_Roles] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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
		SET @sqlCommand = @sqlCommand + ' AND ' + @orderBy + ' >= (SELECT ' + @orderBy + ' FROM [dbo].[ORGAN020Act_Roles] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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
  
EXEC sp_executesql @sqlCommand, N'@pageNo INT, @pageSize INT, @orderBy NVARCHAR(500), @where NVARCHAR(500), @orgId BIGINT, @entity NVARCHAR(100),@userId BIGINT, @parentId BIGINT' ,  
  @entity= @entity,  
     @pageNo= @pageNo,   
     @pageSize= @pageSize,  
     @orderBy = @orderBy,  
     @where = @where,  
  @orgId = @orgId,  
  @userId = @userId,  
  @parentId = @parentId  
END TRY                  
BEGIN CATCH                  
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                  
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                  
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                  
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                  
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetOrgActSecurityByRole]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil         
-- Create date:               05/17/2018      
-- Description:               Get a org act security by role
-- Execution:                 EXEC [dbo].[GetOrgActSecurityByRole]
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)    
-- Modified Desc:  
-- =============================================    

ALTER PROCEDURE  [dbo].[GetOrgActSecurityByRole]
    @userId BIGINT,
    @roleId BIGINT,
	@orgId BIGINT,
    @id BIGINT
AS
BEGIN TRY                
 SET NOCOUNT ON;   
  SELECT syst.[Id]
		,syst.[OrgId]
		,syst.[OrgActRoleId]
		,syst.[SecLineOrder]
		,syst.[SecMainModuleId]
		,syst.[SecMenuOptionLevelId]
		,syst.[SecMenuAccessLevelId]
		,syst.[DateEntered]
		,syst.[EnteredBy]
		,syst.[DateChanged]
		,syst.[ChangedBy]
  FROM [dbo].[ORGAN021Act_SecurityByRole] syst
 WHERE [Id] = @id
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetOrgActSecurityByRoleView]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil         
-- Create date:               05/17/2018      
-- Description:               Get all org act security by role
-- Execution:                 EXEC [dbo].[GetOrgActSecurityByRoleView]
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)   
-- Modified Desc:  
-- =============================================      
ALTER PROCEDURE [dbo].[GetOrgActSecurityByRoleView]    
 @userId BIGINT,    
 @roleId BIGINT,    
 @orgId BIGINT,    
 @entity NVARCHAR(100),    
 @pageNo INT,    
 @pageSize INT,    
 @orderBy NVARCHAR(500),   
 @groupBy NVARCHAR(500), 
 @groupByWhere NVARCHAR(500),  
 @where NVARCHAR(500),    
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
    
SET @TCountQuery = 'SELECT @TotalCount = COUNT(Id) FROM [dbo].[ORGAN021Act_SecurityByRole] (NOLOCK) '+ @entity +' WHERE [OrgId] = @orgId AND [OrgActRoleId] =@parentId AND ISNULL('+@entity+'.StatusId, 1) < 3 ' + ISNULL(@where, '')    
EXEC sp_executesql @TCountQuery, N'@orgId BIGINT, @parentId BIGINT,@TotalCount INT OUTPUT', @orgId, @parentId, @TotalCount  OUTPUT;    
    
IF(@recordId = 0)    
 BEGIN    
  SET @sqlCommand = 'SELECT ' + [dbo].[fnGetBaseQueryByUserId](@entity, @userId)     
  SET @sqlCommand = @sqlCommand + ' ,org.[OrgCode] AS OrgIdName, actRole.[OrgRoleTitle] as OrgActRoleIdName, cont.[ConFullName] as ContactIdName '    
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
    
SET @sqlCommand = @sqlCommand + ' FROM [dbo].[ORGAN021Act_SecurityByRole] (NOLOCK) '+ @entity    
    
--Below to get BIGINT reference key name by Id if NOT NULL    
SET @sqlCommand = @sqlCommand + ' INNER JOIN [dbo].[ORGAN020Act_Roles] (NOLOCK) actRole ON ' + @entity + '.[OrgActRoleId]=actRole.[Id] '   
SET @sqlCommand = @sqlCommand + ' INNER JOIN [dbo].[CONTC000Master] (NOLOCK) cont ON ' + @entity + '.[ContactId]=cont.[Id] '   
SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[ORGAN000Master] (NOLOCK) org ON ' + @entity + '.[OrgId]=org.[Id] '   
SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[ORGAN010Ref_Roles] (NOLOCK) rol ON actRole.[OrgRefRoleId] = rol.[Id] '  
SET @sqlCommand = @sqlCommand + ' WHERE '+@entity+'.[OrgId] = @orgId AND '+@entity+'.OrgActRoleId =@parentId AND ISNULL('+@entity+'.StatusId, 1) < 3 ' + ISNULL(@where, '')    
    
IF((@recordId > 0) AND (((@isNext = 0) AND (@isEnd = 0)) OR ((@isNext = 1) AND (@isEnd = 0))))    
 BEGIN    
  IF((@isNext = 0) AND (@isEnd = 0))  
   BEGIN  
	IF(ISNULL(@orderBy, '') <> '')
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND ' + @orderBy + ' <= (SELECT ' + @orderBy + ' FROM [dbo].[ORGAN021Act_SecurityByRole] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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
		SET @sqlCommand = @sqlCommand + ' AND ' + @orderBy + ' >= (SELECT ' + @orderBy + ' FROM [dbo].[ORGAN021Act_SecurityByRole] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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
 
EXEC sp_executesql @sqlCommand, N'@pageNo INT, @pageSize INT,@orderBy NVARCHAR(500), @where NVARCHAR(500), @orgId BIGINT, @entity NVARCHAR(100) ,@parentId BIGINT' ,    
  @entity= @entity,    
     @pageNo= @pageNo,     
     @pageSize= @pageSize,    
     @orderBy = @orderBy,    
     @where = @where,    
  @orgId = @orgId,  
  @parentId = @parentId    
END TRY                    
BEGIN CATCH                    
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                    
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                    
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                    
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                    
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetOrgActSubSecurityByRole]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil         
-- Create date:               05/17/2018      
-- Description:               Get a org act subsecurity by role
-- Execution:                 EXEC [dbo].[GetOrgActSubSecurityByRole]
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)    
-- Modified Desc:  
-- =============================================  
ALTER PROCEDURE  [dbo].[GetOrgActSubSecurityByRole]
    @userId BIGINT,
    @roleId BIGINT,
	@orgId BIGINT,
    @id BIGINT
AS
BEGIN TRY                
 SET NOCOUNT ON;   
  SELECT syst.[Id]
		 ,syst.[OrgSecurityByRoleId]  
		  ,syst.[RefTableName]
		  ,syst.[SubsMenuOptionLevelId]  
		  ,syst.[SubsMenuAccessLevelId]  
		  ,syst.[StatusId]  
		  ,syst.[DateEntered]  
		  ,syst.[EnteredBy]  
		  ,syst.[DateChanged]  
		  ,syst.[ChangedBy]  
  FROM [dbo].[ORGAN022Act_SubSecurityByRole] syst  
 WHERE syst.[Id] = @id
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetOrgActSubSecurityByRoleView]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil         
-- Create date:               05/17/2018      
-- Description:               Get all org act subsecurity by role
-- Execution:                 EXEC [dbo].[GetOrgActSubSecurityByRoleView]
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)    
-- Modified Desc:  
-- =============================================   
ALTER PROCEDURE [dbo].[GetOrgActSubSecurityByRoleView]
 @userId BIGINT,
 @roleId BIGINT,
 @orgId BIGINT,
 @entity NVARCHAR(100),
 @pageNo INT,
 @pageSize INT,
 @orderBy NVARCHAR(500),
 @groupBy NVARCHAR(500), 
 @groupByWhere NVARCHAR(500), 
 @where NVARCHAR(500),
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

SET @TCountQuery = 'SELECT @TotalCount = COUNT('+@entity+'.Id) FROM [dbo].[ORGAN022Act_SubSecurityByRole] (NOLOCK) '+ @entity 
				   + ' INNER JOIN [dbo].[ORGAN021Act_SecurityByRole] sr ON '+@entity+'.[OrgSecurityByRoleId]=sr.[Id]'
				   + ' WHERE sr.[OrgId] = @orgId AND sr.Id=@parentId AND ISNULL('+@entity+'.StatusId, 1)<3 ' + ISNULL(@where, '')

EXEC sp_executesql @TCountQuery, N'@orgId BIGINT, @parentId BIGINT, @TotalCount INT OUTPUT', @orgId, @parentId, @TotalCount  OUTPUT;

IF(@recordId = 0)
	BEGIN
		SET @sqlCommand = 'SELECT ' + [dbo].[fnGetBaseQueryByUserId](@entity, @userId) 
		SET @sqlCommand = @sqlCommand + ' ,org.[OrgCode] AS SubSecOrgIdName, orgRoles.OrgRoleCode AS SecByRoleIdName '
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

SET @sqlCommand = @sqlCommand + ' FROM [dbo].[ORGAN022Act_SubSecurityByRole] (NOLOCK) '+ @entity

--Below to get BIGINT reference key name by Id if NOT NULL
SET @sqlCommand = @sqlCommand + ' INNER JOIN [dbo].[ORGAN021Act_SecurityByRole] (NOLOCK) sec ON ' + @entity + '.[OrgSecurityByRoleId]=sec.[Id] '
SET @sqlCommand = @sqlCommand + ' INNER JOIN [dbo].[ORGAN020Act_Roles] (NOLOCK) actRole ON sec.[OrgActRoleId]=actRole.[Id] '   
SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[ORGAN010Ref_Roles] (NOLOCK) orgRoles ON actRole.[OrgRefRoleId] = orgRoles.Id '
SET @sqlCommand = @sqlCommand + ' INNER JOIN [dbo].[ORGAN000Master] (NOLOCK) org ON sec.[OrgId]=org.[Id] '

SET @sqlCommand = @sqlCommand + ' WHERE sec.Id=@parentId AND org.Id=@orgId AND ISNULL(' + @entity + '.StatusId, 1)<3 '+ ISNULL(@where, '')

IF((@recordId > 0) AND (((@isNext = 0) AND (@isEnd = 0)) OR ((@isNext = 1) AND (@isEnd = 0))))
	BEGIN
		IF((@isNext = 0) AND (@isEnd = 0))  
   BEGIN  
	IF(ISNULL(@orderBy, '') <> '')
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND ' + @orderBy + ' <= (SELECT ' + @orderBy + ' FROM [dbo].[ORGAN022Act_SubSecurityByRole] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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
		SET @sqlCommand = @sqlCommand + ' AND ' + @orderBy + ' >= (SELECT ' + @orderBy + ' FROM [dbo].[ORGAN022Act_SubSecurityByRole] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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

EXEC sp_executesql @sqlCommand, N'@pageNo INT, @pageSize INT,@orderBy NVARCHAR(500), @where NVARCHAR(500), @orgId BIGINT, @entity NVARCHAR(100), @parentId BIGINT' ,
	 @entity= @entity,
     @pageNo= @pageNo, 
     @pageSize= @pageSize,
     @orderBy = @orderBy,
     @where = @where,
	 @orgId = @orgId,
	 @parentId = @parentId
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetOrganization]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil         
-- Create date:               08/16/2018      
-- Description:               Get a Organization
-- Execution:                 EXEC [dbo].[GetOrganization]
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)   
-- Modified Desc:  
-- ============================================= 
ALTER PROCEDURE  [dbo].[GetOrganization] 
    @userId BIGINT,
    @roleId BIGINT,
	@orgId BIGINT,
    @id BIGINT
AS
BEGIN TRY                
 SET NOCOUNT ON;   

 SELECT  org.[Id]
        ,org.[OrgCode]
        ,org.[OrgTitle]
        ,org.[OrgGroupId]
        ,CASE WHEN EXISTS(SELECT Id FROM SYSTM000OpnSezMe WHERE id=@userId and IsSysAdmin =1) THEN  org.[OrgSortOrder] ELSE 1 END AS OrgSortOrder
		--,org.[OrgSortOrder]
        ,org.[StatusId]
        ,org.[DateEntered]
        ,org.[EnteredBy]
        ,org.[DateChanged]
        ,org.[ChangedBy]
        ,org.[OrgContactId]
        ,org.[OrgImage]
   FROM [dbo].[ORGAN000Master] org
  WHERE [Id]=@id
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetOrganizationImages]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Janardana Behara         
-- Create date:               04/24/2018      
-- Description:               
-- Execution:                 EXEC [dbo].[GetOrganizationImages] 1
-- Modified on:  
-- Modified Desc:  
-- =============================================
ALTER PROCEDURE[dbo].[GetOrganizationImages]
(
@userId BIGINT
)
AS
BEGIN

    DECLARE  @userIcon varbinary(max)  =NULL ,@contactId  BIGINT;

	
	SELECT
		@contactId = con.[Id] 
		,@userIcon =con.ConImage 
	FROM [dbo].[SYSTM000OpnSezMe] AS sez
	INNER JOIN [dbo].[CONTC000Master] AS con ON sez.[SysUserContactId] = con.Id
	INNER JOIN [Security].[AUTH050_UserPassword] AS up ON sez.Id = up.UserId
	WHERE sez.[Id] = @userId --AND sez.[StatusId] =1

	--SELECT @contactId as Id, @userIcon As Icon,NULL as ParentId
	
	IF EXISTS (SELECT Id FROM [SYSTM000OpnSezMe] WHERE Id=@userId AND IsSysAdmin =1)
	BEGIN
			SELECT  Id as OrganizationId
			   ,OrgCode as OrganizationCode
			  ,OrgImage as OrganizationImage
		FROM [dbo].[ORGAN000Master] 
	END
	ELSE
	BEGIN
	  SELECT act.OrgId as OrganizationId
		  ,org.OrgImage as OrganizationImage
		  ,OrgCode as OrganizationCode
	FROM [dbo].[ORGAN020Act_Roles] act
	INNER JOIN [dbo].[ORGAN000Master] org ON org.Id = act.OrgId
	INNER JOIN [dbo].[ORGAN010Ref_Roles] rol ON act.[OrgRefRoleId] = rol.Id
	
	WHERE act.[OrgRoleContactId] = @contactId

	END

	

END;
GO
/****** Object:  StoredProcedure [dbo].[GetOrganizationView]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil         
-- Create date:               09/04/2018      
-- Description:               Get all organization 
-- Execution:                 EXEC [dbo].[GetOrganizationView]
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)    
-- Modified Desc:  
-- =============================================
ALTER PROCEDURE [dbo].[GetOrganizationView]
 @userId BIGINT,
 @roleId BIGINT,
 @orgId BIGINT,
 @entity NVARCHAR(100),
 @pageNo INT,
 @pageSize INT,
 @orderBy NVARCHAR(500),
 @groupBy NVARCHAR(500), 
 @groupByWhere NVARCHAR(500), 
 @where NVARCHAR(500),
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
 DECLARE @isSysAdmin BIT;

SELECT @isSysAdmin = [IsSysAdmin] FROM [dbo].[SYSTM000OpnSezMe] WHERE [Id] = @userId

SET @TCountQuery = 'SELECT @TotalCount = COUNT(Id) FROM [dbo].[ORGAN000Master] (NOLOCK) '+ @entity 

--Below for getting user specific 'Statuses'
IF((ISNULL(@where, '') = '') OR (@where NOT LIKE '%'+@entity+'.StatusId%'))
	BEGIN
		SET @TCountQuery = @TCountQuery + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) fgus ON ' + @entity + '.[StatusId] = fgus.[StatusId] '
	END

IF(@isSysAdmin = 0)
	BEGIN
		SET @TCountQuery = @TCountQuery +' WHERE ' + @entity + '.Id=@orgId ' + ISNULL(@where, '')
	END
ELSE
	BEGIN
		SET @TCountQuery = @TCountQuery +' WHERE 1=1' + ISNULL(@where, '')
	END

EXEC sp_executesql @TCountQuery, N'@userId BIGINT, @orgId BIGINT, @TotalCount INT OUTPUT', @userId, @orgId, @TotalCount  OUTPUT;

IF(@recordId = 0)
	BEGIN
		SET @sqlCommand = 'SELECT ' + [dbo].[fnGetBaseQueryByUserId](@entity, @userId) 
		SET @sqlCommand = @sqlCommand + ' , cont.[ConFullName] AS OrgContactIdName '
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
		
SET @sqlCommand = @sqlCommand +' FROM [dbo].[ORGAN000Master] (NOLOCK) '+ @entity

--Below to get BIGINT reference key name by Id if NOT NULL
SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[CONTC000Master] (NOLOCK) cont ON ' + @entity + '.[OrgContactId]=cont.[Id] '

--Below for getting user specific 'Statuses'
IF((ISNULL(@where, '') = '') OR (@where NOT LIKE '%'+@entity+'.StatusId%'))
	BEGIN
		SET @sqlCommand = @sqlCommand + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) fgus ON ' + @entity + '.[StatusId] = fgus.[StatusId] '
	END

IF(@isSysAdmin = 0)
	BEGIN
		SET @sqlCommand = @sqlCommand + ' WHERE ' + @entity + '.Id=@orgId ' + ISNULL(@where, '');
		SET @sqlCommand  = REPLACE(@sqlCommand,@entity + '.OrgSortOrder','1 as OrgSortOrder');
	END
ELSE
	BEGIN
		SET @sqlCommand = @sqlCommand + ' WHERE 1=1 ' + ISNULL(@where, '')
	END

IF((@recordId > 0) AND (((@isNext = 0) AND (@isEnd = 0)) OR ((@isNext = 1) AND (@isEnd = 0))))
	BEGIN
		IF((@isNext = 0) AND (@isEnd = 0))  
   BEGIN  
	IF(ISNULL(@orderBy, '') <> '')
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND ' + @orderBy + ' <= (SELECT ' + @orderBy + ' FROM [dbo].[ORGAN000Master] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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
		SET @sqlCommand = @sqlCommand + ' AND ' + @orderBy + ' >= (SELECT ' + @orderBy + ' FROM [dbo].[ORGAN000Master] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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

EXEC sp_executesql @sqlCommand, N'@pageNo INT, @pageSize INT, @orderBy NVARCHAR(500), @where NVARCHAR(500), @entity NVARCHAR(100),@userId BIGINT, @orgId BIGINT' ,
	 @entity= @entity,
     @pageNo= @pageNo, 
     @pageSize= @pageSize,
     @orderBy = @orderBy,
     @where = @where,
	 @userId = @userId,
	 @orgId= @orgId
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetOrgCredential]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil         
-- Create date:               08/16/2018      
-- Description:               Get a org credential 
-- Execution:                 EXEC [dbo].[GetOrgCredential]
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)    
-- Modified Desc:  
-- =============================================
ALTER PROCEDURE  [dbo].[GetOrgCredential]
    @userId BIGINT,
    @roleId BIGINT,
	@orgId BIGINT,
    @id BIGINT
AS
BEGIN TRY                
 SET NOCOUNT ON;   
 DECLARE @entityName NVARCHAR(100), @attachmentCount INT
 SELECT @entityName=SysRefName FROM [dbo].[SYSTM000Ref_Table] WHERE TblTableName = 'ORGAN030Credentials';
 SELECT @attachmentCount=COUNT(Id) FROM [dbo].[SYSTM020Ref_Attachments] WHERE AttPrimaryRecordID = @id AND AttTableName = @entityName AND StatusId =1
 SELECT org.[Id]
       ,org.[OrgID]
       ,org.[CreItemNumber]
       ,org.[CreCode]
       ,org.[CreTitle]
       ,org.[CreExpDate]
	   ,org.[StatusId]
       ,org.[DateEntered]
       ,org.[EnteredBy]
       ,org.[DateChanged]
       ,org.[ChangedBy]
	   ,@attachmentCount AS AttachmentCount
   FROM [dbo].[ORGAN030Credentials] org
   WHERE org.[Id]=@id 
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH

GO
/****** Object:  StoredProcedure [dbo].[GetOrgCredentialView]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               09/04/2018      
-- Description:               Get all organization credential    
-- Execution:                 EXEC [dbo].[GetOrgCredentialView]
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)   
-- Modified Desc:  
-- =============================================   
ALTER PROCEDURE [dbo].[GetOrgCredentialView]  
 @userId BIGINT,  
 @roleId BIGINT,  
 @orgId BIGINT,  
 @entity NVARCHAR(100),  
 @pageNo INT,  
 @pageSize INT,  
 @orderBy NVARCHAR(500), 
 @groupBy NVARCHAR(500), 
 @groupByWhere NVARCHAR(500),  
 @where NVARCHAR(500),  
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
  
SET @TCountQuery = 'SELECT @TotalCount = COUNT(Id) FROM [dbo].[ORGAN030Credentials] (NOLOCK) '+ @entity   
  
--Below for getting user specific 'Statuses'  
IF((ISNULL(@where, '') = '') OR (@where NOT LIKE '%'+@entity+'.StatusId%'))  
 BEGIN  
  SET @TCountQuery = @TCountQuery + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) fgus ON ISNULL(' + @entity + '.[StatusId],1) = fgus.[StatusId] '  
 END  
  
SET @TCountQuery = @TCountQuery+' WHERE [OrgID] = @parentId ' + ISNULL(@where, '')  
EXEC sp_executesql @TCountQuery, N'@parentId BIGINT, @userId BIGINT, @TotalCount INT OUTPUT', @parentId, @userId, @TotalCount  OUTPUT;  
  
IF(@recordId = 0)  
 BEGIN  
  SET @sqlCommand = 'SELECT ' + [dbo].[fnGetBaseQueryByUserId](@entity, @userId)   
  SET @sqlCommand = @sqlCommand + ' ,org.[OrgCode] AS OrgIDName , ([dbo].[fnGetAttachmentTableRowCount]('''+@entity+''', '+@entity+'.Id )) As AttachmentCount'  
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
  
SET @sqlCommand = @sqlCommand + ' FROM [dbo].[ORGAN030Credentials] (NOLOCK) '+ @entity  

--Below to get BIGINT reference key name by Id if NOT NULL  
SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[ORGAN000Master] (NOLOCK) org ON ' + @entity + '.[OrgID]=org.[Id] '  
  
--Below for getting user specific 'Statuses'  
IF((ISNULL(@where, '') = '') OR (@where NOT LIKE '%'+@entity+'.StatusId%'))  
 BEGIN  
  SET @sqlCommand = @sqlCommand + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) hfk ON ISNULL(' + @entity + '.[StatusId], 1) = hfk.[StatusId] '  
 END  
  
SET @sqlCommand = @sqlCommand + ' WHERE '+@entity+'.[OrgID] = @parentId '+ ISNULL(@where, '')  
  
IF((@recordId > 0) AND (((@isNext = 0) AND (@isEnd = 0)) OR ((@isNext = 1) AND (@isEnd = 0))))  
 BEGIN  
  IF((@isNext = 0) AND (@isEnd = 0))  
   BEGIN  
	IF(ISNULL(@orderBy, '') <> '')
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND ' + @orderBy + ' <= (SELECT ' + @orderBy + ' FROM [dbo].[ORGAN030Credentials] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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
		SET @sqlCommand = @sqlCommand + ' AND ' + @orderBy + ' >= (SELECT ' + @orderBy + ' FROM [dbo].[ORGAN030Credentials] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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
    PRINT @sqlCommand;
EXEC sp_executesql @sqlCommand, N'@pageNo INT, @pageSize INT, @orderBy NVARCHAR(500), @where NVARCHAR(500), @parentId BIGINT, @entity NVARCHAR(100),@userId BIGINT' ,  
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
/****** Object:  StoredProcedure [dbo].[GetOrgFinacialCalender]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               08/16/2018      
-- Description:               Get a org finacial cal    
-- Execution:                 EXEC [dbo].[GetOrgFinacialCalender]
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)    
-- Modified Desc:  
-- =============================================
ALTER PROCEDURE  [dbo].[GetOrgFinacialCalender]
    @userId BIGINT,
    @roleId BIGINT,
	@orgId BIGINT,
    @id BIGINT
AS
BEGIN TRY                
 SET NOCOUNT ON;   
SELECT org.[Id]
      ,org.[OrgID]
      ,org.[FclPeriod]
      ,org.[FclPeriodCode]
      ,org.[FclPeriodStart]
      ,org.[FclPeriodEnd]
      ,org.[FclPeriodTitle]
      ,org.[FclAutoShortCode]
      ,org.[FclWorkDays]
      ,org.[FinCalendarTypeId]
      ,org.[DateEntered]
      ,org.[EnteredBy]
      ,org.[DateChanged]
      ,org.[ChangedBy]
  FROM [dbo].[ORGAN020Financial_Cal] org
 WHERE [Id]=@id 
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetOrgFinacialCalenderView]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               09/04/2018      
-- Description:               Get all organization financial calander    
-- Execution:                 EXEC [dbo].[GetOrgFinacialCalenderView]
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)    
-- Modified Desc:  
-- =============================================
ALTER PROCEDURE [dbo].[GetOrgFinacialCalenderView]
 @userId BIGINT,
 @roleId BIGINT,
 @orgId BIGINT,
 @entity NVARCHAR(100),
 @pageNo INT,
 @pageSize INT,
 @orderBy NVARCHAR(500),
 @groupBy NVARCHAR(500), 
 @groupByWhere NVARCHAR(500), 
 @where NVARCHAR(500),
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

SET @TCountQuery = 'SELECT @TotalCount = COUNT(Id) FROM [dbo].[ORGAN020Financial_Cal] (NOLOCK) '+ @entity 

--Below for getting user specific 'Statuses'
IF((ISNULL(@where, '') = '') OR (@where NOT LIKE '%'+@entity+'.StatusId%'))
	BEGIN
		SET @TCountQuery = @TCountQuery + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) fgus ON ' + @entity + '.[StatusId] = fgus.[StatusId] '
	END

SET @TCountQuery = @TCountQuery + ' WHERE [OrgID] = @parentId ' + ISNULL(@where, '')

EXEC sp_executesql @TCountQuery, N'@parentId BIGINT, @userId BIGINT, @TotalCount INT OUTPUT', @parentId, @userId, @TotalCount  OUTPUT;

IF(@recordId = 0)
	BEGIN
		SET @sqlCommand = 'SELECT ' + [dbo].[fnGetBaseQueryByUserId](@entity, @userId) 
		SET @sqlCommand = @sqlCommand + ' ,org.[OrgCode] AS OrgIDName '
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

SET @sqlCommand = @sqlCommand + ' FROM [dbo].[ORGAN020Financial_Cal] (NOLOCK) '+ @entity

--Below to get BIGINT reference key name by Id if NOT NULL
SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[ORGAN000Master] (NOLOCK) org ON ' + @entity + '.[OrgID]=org.[Id] '

--Below for getting user specific 'Statuses'
IF((ISNULL(@where, '') = '') OR (@where NOT LIKE '%'+@entity+'.StatusId%'))
	BEGIN
		SET @sqlCommand = @sqlCommand + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) hfk ON ISNULL(' + @entity + '.[StatusId], 1) = hfk.[StatusId] '
	END

SET @sqlCommand = @sqlCommand + ' WHERE '+@entity+'.[OrgID] = @parentId '+ ISNULL(@where, '')

IF((@recordId > 0) AND (((@isNext = 0) AND (@isEnd = 0)) OR ((@isNext = 1) AND (@isEnd = 0))))
	BEGIN
		IF((@isNext = 0) AND (@isEnd = 0))  
   BEGIN  
	IF(ISNULL(@orderBy, '') <> '')
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND ' + @orderBy + ' <= (SELECT ' + @orderBy + ' FROM [dbo].[ORGAN020Financial_Cal] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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
		SET @sqlCommand = @sqlCommand + ' AND ' + @orderBy + ' >= (SELECT ' + @orderBy + ' FROM [dbo].[ORGAN020Financial_Cal] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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

EXEC sp_executesql @sqlCommand, N'@pageNo INT, @pageSize INT, @orderBy NVARCHAR(500), @where NVARCHAR(500), @parentId BIGINT, @entity NVARCHAR(100),@userId BIGINT' ,
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
/****** Object:  StoredProcedure [dbo].[GetOrgMarketSupport]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               08/16/2018      
-- Description:               Get a Org MRKT Org Support    
-- Execution:                 EXEC [dbo].[GetOrgMarketSupport]
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)    
-- Modified Desc:  
-- =============================================
ALTER PROCEDURE  [dbo].[GetOrgMarketSupport]
    @userId BIGINT,
    @roleId BIGINT,
	@orgId BIGINT,
    @id BIGINT
AS
BEGIN TRY                
 SET NOCOUNT ON;   
 SELECT org.[Id]
       ,org.[OrgID]
       ,org.[MrkOrder]
       ,org.[MrkCode]
       ,org.[MrkTitle]
       ,org.[DateEntered]
       ,org.[EnteredBy]
       ,org.[DateChanged]
       ,org.[ChangedBy]
   FROM [dbo].[ORGAN002MRKT_OrgSupport] org
  WHERE [Id]=@id 
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetOrgMarketSupportView]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               09/04/2018      
-- Description:               Get a Org MRKT Org Support    
-- Execution:                 EXEC [dbo].[GetOrgMarketSupport]
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)   
-- Modified Desc:  
-- ============================================= 
ALTER PROCEDURE [dbo].[GetOrgMarketSupportView]
 @userId BIGINT,
 @roleId BIGINT,
 @orgId BIGINT,
 @entity NVARCHAR(100),
 @pageNo INT,
 @pageSize INT,
 @orderBy NVARCHAR(500),
 @groupBy NVARCHAR(500), 
 @groupByWhere NVARCHAR(500), 
 @where NVARCHAR(500),
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

SET @TCountQuery = 'SELECT @TotalCount = COUNT(Id) FROM [dbo].[ORGAN002MRKT_OrgSupport] (NOLOCK) '+ @entity +' WHERE [OrgID] = @parentId ' + ISNULL(@where, '')
EXEC sp_executesql @TCountQuery, N'@parentId BIGINT, @TotalCount INT OUTPUT', @parentId, @TotalCount  OUTPUT;

IF(@recordId = 0)
	BEGIN
		SET @sqlCommand = 'SELECT ' + [dbo].[fnGetBaseQueryByUserId](@entity, @userId) 
		SET @sqlCommand = @sqlCommand + ' ,org.[OrgCode] AS OrgIDName '
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

SET @sqlCommand = @sqlCommand + ' FROM [dbo].[ORGAN002MRKT_OrgSupport] (NOLOCK) '+ @entity

--Below to get BIGINT reference key name by Id if NOT NULL
SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[ORGAN000Master] (NOLOCK) org ON ' + @entity + '.[OrgID]=org.[Id] '

SET @sqlCommand = @sqlCommand + ' WHERE '+@entity+'.[OrgID] = @parentId '+ ISNULL(@where, '')

IF((@recordId > 0) AND (((@isNext = 0) AND (@isEnd = 0)) OR ((@isNext = 1) AND (@isEnd = 0))))
	BEGIN
		IF((@isNext = 0) AND (@isEnd = 0))  
   BEGIN  
	IF(ISNULL(@orderBy, '') <> '')
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND ' + @orderBy + ' <= (SELECT ' + @orderBy + ' FROM [dbo].[ORGAN002MRKT_OrgSupport] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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
		SET @sqlCommand = @sqlCommand + ' AND ' + @orderBy + ' >= (SELECT ' + @orderBy + ' FROM [dbo].[ORGAN002MRKT_OrgSupport] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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

EXEC sp_executesql @sqlCommand, N'@pageNo INT, @pageSize INT, @orderBy NVARCHAR(500), @where NVARCHAR(500), @parentId BIGINT, @entity NVARCHAR(100)' ,
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
/****** Object:  StoredProcedure [dbo].[GetOrgPocContact]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
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
 SELECT org.[Id]
      ,org.[OrgID]
      ,org.[ContactID]
      ,org.[PocCode]
      ,org.[PocTitle]
      ,org.[PocTypeId]
      ,org.[PocDefault]
      ,org.[StatusId]
      ,org.[DateEntered]
      ,org.[EnteredBy]
      ,org.[DateChanged]
      ,org.[ChangedBy]
      ,org.[PocSortOrder]
  FROM [dbo].[ORGAN001POC_Contacts] org
 WHERE [Id]=@id
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetOrgPocContactView]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
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
 @where NVARCHAR(500),
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

SET @TCountQuery = 'SELECT @TotalCount = COUNT(Id) FROM [dbo].[ORGAN001POC_Contacts] (NOLOCK) '+ @entity 

--Below for getting user specific 'Statuses'
IF((ISNULL(@where, '') = '') OR (@where NOT LIKE '%'+@entity+'.StatusId%'))
	BEGIN
		SET @TCountQuery = @TCountQuery + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) fgus ON ' + @entity + '.[StatusId] = fgus.[StatusId] '
	END

SET @TCountQuery = @TCountQuery + ' WHERE [OrgID] = @parentId ' + ISNULL(@where, '')

EXEC sp_executesql @TCountQuery, N'@parentId BIGINT, @userId BIGINT, @TotalCount INT OUTPUT', @parentId, @userId, @TotalCount  OUTPUT;

IF(@recordId = 0)
	BEGIN
		SET @sqlCommand = 'SELECT ' + [dbo].[fnGetBaseQueryByUserId](@entity, @userId) 
		SET @sqlCommand = @sqlCommand + ' ,org.[OrgCode] AS OrgIDName, cont.[ConFullName] AS ContactIDName '
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

SET @sqlCommand = @sqlCommand + ' FROM [dbo].[ORGAN001POC_Contacts] (NOLOCK) '+ @entity

--Below to get BIGINT reference key name by Id if NOT NULL
SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[ORGAN000Master] (NOLOCK) org ON ' + @entity + '.[OrgID]=org.[Id] '
SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[CONTC000Master] (NOLOCK) cont ON ' + @entity + '.[ContactID]=cont.[Id] '

--Below for getting user specific 'Statuses'
IF((ISNULL(@where, '') = '') OR (@where NOT LIKE '%'+@entity+'.StatusId%'))
	BEGIN
		SET @sqlCommand = @sqlCommand + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) hfk ON ISNULL(' + @entity + '.[StatusId], 1) = hfk.[StatusId] '
	END

SET @sqlCommand = @sqlCommand + ' WHERE '+@entity+'.[OrgID] = @parentId '+ ISNULL(@where, '')

IF((@recordId > 0) AND (((@isNext = 0) AND (@isEnd = 0)) OR ((@isNext = 1) AND (@isEnd = 0))))
	BEGIN
		IF((@isNext = 0) AND (@isEnd = 0))  
   BEGIN  
	IF(ISNULL(@orderBy, '') <> '')
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND ' + @orderBy + ' <= (SELECT ' + @orderBy + ' FROM [dbo].[ORGAN001POC_Contacts] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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
		SET @sqlCommand = @sqlCommand + ' AND ' + @orderBy + ' >= (SELECT ' + @orderBy + ' FROM [dbo].[ORGAN001POC_Contacts] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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

EXEC sp_executesql @sqlCommand, N'@pageNo INT, @pageSize INT, @orderBy NVARCHAR(500), @where NVARCHAR(500), @parentId BIGINT, @entity NVARCHAR(100),@userId BIGINT' ,
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
/****** Object:  StoredProcedure [dbo].[GetOrgRefRole]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               08/16/2018      
-- Description:               Get a org Org ref role 
-- Execution:                 EXEC [dbo].[GetOrgRefRole]
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)   
-- Modified Desc:  
-- =============================================
ALTER PROCEDURE  [dbo].[GetOrgRefRole]
    @userId BIGINT,
    @roleId BIGINT,
	@orgId BIGINT,
    @id BIGINT
AS
BEGIN TRY                
 SET NOCOUNT ON;   
 SELECT org.[Id]
       ,org.[OrgId]
       ,org.[OrgRoleSortOrder]
       ,org.[OrgRoleCode]
       ,org.[OrgRoleDefault]
       ,org.[OrgRoleTitle]
       ,org.[OrgRoleContactID]
       ,org.[RoleTypeId]
       ,org.[OrgLogical]
       ,org.[PrgLogical]
       ,org.[PrjLogical]
       ,org.[JobLogical]
       ,org.[PrxContactDefault]
       ,org.[PrxJobDefaultAnalyst]
	   ,org.[PrxJobDefaultResponsible]
       ,org.[PrxJobGWDefaultAnalyst]
       ,org.[PrxJobGWDefaultResponsible]
	   ,org.[StatusId]
       ,org.[DateEntered]
       ,org.[EnteredBy]
       ,org.[DateChanged]
       ,org.[ChangedBy]
       ,org.[PhsLogical]
  FROM [dbo].[ORGAN010Ref_Roles] org
 WHERE [Id]=@id
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetOrgRefRoleView]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               09/04/2018      
-- Description:               Get all organization reference role 
-- Execution:                 EXEC [dbo].[GetOrgRefRoleView]
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)   
-- Modified Desc:  
-- =============================================
ALTER PROCEDURE [dbo].[GetOrgRefRoleView]
 @userId BIGINT,
 @roleId BIGINT,
 @orgId BIGINT,
 @entity NVARCHAR(100),
 @pageNo INT,
 @pageSize INT,
 @orderBy NVARCHAR(500),
 @groupBy NVARCHAR(500), 
 @groupByWhere NVARCHAR(500), 
 @where NVARCHAR(500),
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

SET @TCountQuery = 'SELECT @TotalCount = COUNT(Id) FROM [dbo].[ORGAN010Ref_Roles] (NOLOCK) '+ @entity

--Below for getting user specific 'Statuses'
IF((ISNULL(@where, '') = '') OR (@where NOT LIKE '%'+@entity+'.StatusId%'))
	BEGIN
		SET @TCountQuery += ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) fgus ON ISNULL(' + @entity + '.[StatusId], 1) = fgus.[StatusId] '
	END

SET @TCountQuery += ' WHERE 1=1 ' + ISNULL(@where, '')

EXEC sp_executesql @TCountQuery, N'@userId BIGINT, @TotalCount INT OUTPUT', @userId, @TotalCount  OUTPUT;


IF(@recordId = 0)
	BEGIN
		SET @sqlCommand = 'SELECT ' + [dbo].[fnGetBaseQueryByUserId](@entity, @userId) 
		SET @sqlCommand = @sqlCommand + ' ,org.[OrgCode] AS OrgIDName, cont.[ConFullName] AS OrgRoleContactIDName '
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

SET @sqlCommand = @sqlCommand + ' FROM [dbo].[ORGAN010Ref_Roles] (NOLOCK) '+ @entity

--Below to get BIGINT reference key name by Id if NOT NULL
SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[ORGAN000Master] (NOLOCK) org ON ' + @entity + '.[OrgID]=org.[Id] '
SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[CONTC000Master] (NOLOCK) cont ON ' + @entity + '.[OrgRoleContactID]=cont.[Id] '

--Below for getting user specific 'Statuses'
IF((ISNULL(@where, '') = '') OR (@where NOT LIKE '%'+@entity+'.StatusId%'))
	BEGIN
		SET @sqlCommand = @sqlCommand + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) hfk ON ISNULL(' + @entity + '.[StatusId], 1) = hfk.[StatusId] '
	END

SET @sqlCommand = @sqlCommand + ' WHERE 1=1 '+ ISNULL(@where, '')

IF((@recordId > 0) AND (((@isNext = 0) AND (@isEnd = 0)) OR ((@isNext = 1) AND (@isEnd = 0))))
	BEGIN
		IF((@isNext = 0) AND (@isEnd = 0))  
   BEGIN  
	IF(ISNULL(@orderBy, '') <> '')
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND ' + @orderBy + ' <= (SELECT ' + @orderBy + ' FROM [dbo].[ORGAN010Ref_Roles] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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
		SET @sqlCommand = @sqlCommand + ' AND ' + @orderBy + ' >= (SELECT ' + @orderBy + ' FROM [dbo].[ORGAN010Ref_Roles] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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

EXEC sp_executesql @sqlCommand, N'@pageNo INT, @pageSize INT, @orderBy NVARCHAR(500), @where NVARCHAR(500), @entity NVARCHAR(100),@userId BIGINT' ,
	 @entity= @entity,
     @pageNo= @pageNo, 
     @pageSize= @pageSize,
     @orderBy = @orderBy,
     @where = @where,
	 @userId = @userId
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetOrInsErrorLog]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               02/20/2018      
-- Description:               Add or get error details into database 
-- Execution:                 EXEC [dbo].[GetOrInsErrorLog]
-- Modified on:  
-- Modified Desc:  
-- =============================================
ALTER PROCEDURE [dbo].[GetOrInsErrorLog]
-- Add the parameters for the stored procedure here
@id bigint, 
@relatedTo varchar(100), 
@innerException nvarchar(1024),
@message nvarchar(MAX),
@source nvarchar(64),
@stackTrace nvarchar(MAX),
@additionalMessage nvarchar(4000)
AS
BEGIN TRY 
SET NOCOUNT ON;
IF( @id < 1 )
BEGIN
INSERT INTO dbo.SYSTM000ErrorLog
(
ErrRelatedTo, 
ErrInnerException,
ErrMessage,
ErrSource,
ErrStackTrace,
ErrAdditionalMessage,
ErrDateStamp
)
VALUES
(
@RelatedTo, 
@InnerException,
@Message,
@Source,
@StackTrace,
@AdditionalMessage,
GETUTCDATE()
)
SET @id = SCOPE_IDENTITY();
END
SELECT err.[Id]
,err.[ErrRelatedTo]
,err.[ErrInnerException]
,err.[ErrMessage]
,err.[ErrSource]
,err.[ErrStackTrace]
,err.[ErrAdditionalMessage]
,err.[ErrDateStamp] FROM dbo.SYSTM000ErrorLog err WHERE err.Id = @id
END TRY                
BEGIN CATCH                
DECLARE  @errErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
  ,@errErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
  ,@errRelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
EXEC [dbo].[ErrorLog_InsDetails] @errRelatedTo, NULL, @errErrorMessage, NULL, NULL, @errErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetPageAndTabNames]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               08/16/2018      
-- Description:               Get page and tab names 
-- Execution:                 EXEC [dbo].[GetPageAndTabNames]
-- Modified on:  
-- Modified Desc:  
-- ============================================= 
ALTER PROCEDURE  [dbo].[GetPageAndTabNames]
    @tableName NVARCHAR(100),
    @langCode NVARCHAR(10)
AS
BEGIN TRY                
 SET NOCOUNT ON;   
SELECT refTpn.[Id]
      ,refTpn.[LangCode]
      ,refTpn.[RefTableName]
      ,refTpn.[TabSortOrder]
      ,refTpn.[TabTableName]
      ,refTpn.[TabPageTitle]
      ,refTpn.[TabExecuteProgram]
      ,refTpn.[TabPageIcon]
      ,refTpn.[StatusId]
  FROM [dbo].[SYSTM030Ref_TabPageName] refTpn
  WHERE refTpn.LangCode=@langCode AND refTpn.RefTableName = @tableName AND (ISNULL(refTpn.StatusId, 1) = 1)
  ORDER BY [TabSortOrder] ASC
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetPPPGatewayContactCombobox]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Janardana Behara        
-- Create date:               05/29/2018      
-- Description:               Get selected records by table  
-- Execution:                 [dbo].[GetPPPGatewayContactCombobox]  'EN',1,'Contact','Contact.id,Contact.ConFullName',1,10,NULL,NULL,NULL,1,'Id',2,NULL
-- Modified on:  
-- Modified Desc:  
-- =============================================   

ALTER PROCEDURE [dbo].[GetPPPGatewayContactCombobox] 
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
 @entityFor NVARCHAR(50) = null
AS 


BEGIN TRY 
IF OBJECT_ID ('tempdb.dbo.#contactComboTable') IS NOT NULL
   DROP TABLE #contactComboTable

CREATE TABLE #contactComboTable(    
  Id BIGINT
 ,ConFullName NVARCHAR(100) 
 ,ConJobTitle NVARCHAR(100)
 ,ConCompany NVARCHAR(100)
 ,ConFileAs NVARCHAR(100)
  )   



IF @entityFor = 'PPPRespGateway' OR  @entityFor = 'PPPRoleCodeContact'
   BEGIN
-- Program Role Contacts
 INSERT INTO #contactComboTable(Id,ConFullName,ConJobTitle,ConCompany,ConFileAs)  

(select contact.Id,contact.ConFullName,contact.ConJobTitle,contact.ConCompany ,contact.ConFileAs from CONTC000Master contact

INNER JOIN  [dbo].[PRGRM020Program_Role] pgContact ON pgContact.[PrgRoleContactID] = contact.Id  
INNER JOIN PRGRM000Master pgm  ON pgm.Id  =  pgContact.ProgramID 
WHERE pgContact.ProgramID = @parentId AND contact.StatusId In(1,2)
UNION

-- Customer Contacts
SELECT contact.Id,contact.ConFullName,contact.ConJobTitle,contact.ConCompany ,contact.ConFileAs FROM  [dbo].CONTC000Master contact
INNER JOIN    [dbo].[CUST010Contacts] custContact ON  contact.Id = custContact.[CustContactMSTRID]
INNER JOIN   CUST000Master cust ON custContact.[CustCustomerID] = cust.Id
INNER JOIN PRGRM000Master pgm  ON pgm.PrgCustID  =  cust.Id 
WHERE pgm.Id = @parentId
AND custContact.StatusId In(1,2) 
AND contact.StatusId In(1,2)

UNION
--Vendor Contacts
SELECT contact.Id,contact.ConFullName,contact.ConJobTitle,contact.ConCompany ,contact.ConFileAs FROM  [dbo].CONTC000Master contact
INNER JOIN  [dbo].[VEND010Contacts] vendContact ON contact.Id = vendContact.[VendContactMSTRID]
INNER JOIN   VEND000Master vend ON vendContact.[VendVendorID] = vend.Id
WHERE vendContact.[VendVendorID] IN (SELECT DISTINCT PvlVendorID FROM

 [dbo].[PRGRM051VendorLocations] pvl WHERE pvl.PvlProgramID = @parentId )
 AND contact.StatusId In(1,2)
 AND vendContact.StatusId In(1,2) 
 )
  END

ELSE IF @entityFor = 'PPPJobRespContact'
   BEGIN
     INSERT INTO #contactComboTable(Id,ConFullName,ConJobTitle,ConCompany,ConFileAs)  
	EXEC [dbo].[GetJobResponsibleComboboxContacts] @orgId,@parentId 
	 
   END
ELSE IF @entityFor = 'PPPJobAnalystContact'
   BEGIN
     INSERT INTO #contactComboTable(Id,ConFullName,ConJobTitle,ConCompany,ConFileAs)  
	EXEC [dbo].[GetJobAnalystComboboxContacts]  @orgId,@parentId 
END
 
  --find new page no
    IF(ISNULL(@primaryKeyValue, '') <> '')
	 BEGIN
    
	IF NOT EXISTS(SELECT Id FROM #contactComboTable Where Id = @primaryKeyValue)
	BEGIN
	    INSERT INTO #contactComboTable(Id,ConFullName,ConJobTitle,ConCompany,ConFileAs)  
	    SELECT contact.Id,contact.ConFullName,contact.ConJobTitle,contact.ConCompany ,contact.ConFileAs FROM  [dbo].CONTC000Master contact 
	    WHERE contact.Id = @primaryKeyValue;
	END


	   DECLARE @newPgNo INT
	   SELECT @newPgNo = Item FROM (SELECT ROW_NUMBER() OVER(ORDER BY Contact.Id) as Item  ,Contact.Id From #contactComboTable  Contact) t WHERE t.Id= @primaryKeyValue
	   IF @newPgNo IS NOT NULL
	   BEGIN
		   SET @newPgNo =  @newPgNo/@pageSize + 1; 
		   SET @pageSize = @newPgNo * @pageSize;
	   END
	END
	
	DECLARE @sqlCommand NVARCHAR(MAX) ='SELECT  * FROM  #contactComboTable '+  @entity + ' WHERE 1=1 '  
	
	--Apply Like Statement
	IF(ISNULL(@like, '') != '')  
	  BEGIN  
	  SET @sqlCommand = @sqlCommand + ' AND ('  
	   DECLARE @likeStmt NVARCHAR(MAX)  
  
	  SELECT @likeStmt = COALESCE(@likeStmt + ' OR ','') + Item + ' LIKE ''%' + @like + '%' + '''' FROM [dbo].[fnSplitString](@fields, ',')    
	  SET @sqlCommand = @sqlCommand + @likeStmt + ') '  
	  END  
	 -- Apply Where condition
	 IF(ISNULL(@where, '') != '')  
	  BEGIN  
		 SET @sqlCommand = @sqlCommand + @where   
	 END  
	
	--Apply Ordering AND paged Data
	SET @sqlCommand = @sqlCommand + ' ORDER BY '+ @fields +' OFFSET @pageSize * (@pageNo - 1) ROWS FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);'   

	EXEC sp_executesql @sqlCommand, N'@pageNo INT, @pageSize INT, @where NVARCHAR(100)' ,  
		 @pageNo = @pageNo,   
		 @pageSize = @pageSize,  
		 @where = @where
		 

 





 END TRY                  
BEGIN CATCH                  
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                  
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                  
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                  
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                  
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetPrgEdiHeader]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
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
/****** Object:  StoredProcedure [dbo].[GetPrgEdiHeaderView]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               09/14/2018      
-- Description:               Get all  Program EDI header
-- Execution:                 EXEC [dbo].[GetPrgEdiHeaderView]
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)   
-- Modified Desc:  
-- ============================================= 
ALTER PROCEDURE [dbo].[GetPrgEdiHeaderView]
 @userId BIGINT,
 @roleId BIGINT,
 @orgId BIGINT,
 @entity NVARCHAR(100),
 @pageNo INT,
 @pageSize INT,
 @orderBy NVARCHAR(500),
 @groupBy NVARCHAR(500), 
 @groupByWhere NVARCHAR(500), 
 @where NVARCHAR(500),
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

SET @TCountQuery = 'SELECT @TotalCount = COUNT(Id) FROM [dbo].[PRGRM070EdiHeader] (NOLOCK) '+ @entity 

--Below for getting user specific 'Statuses'
IF((ISNULL(@where, '') = '') OR (@where NOT LIKE '%'+@entity+'.StatusId%'))
	BEGIN
		SET @TCountQuery = @TCountQuery + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) fgus ON ' + @entity + '.[StatusId] = fgus.[StatusId] '
	END

SET @TCountQuery = @TCountQuery + ' WHERE [PehProgramID] = @parentId ' + ISNULL(@where, '')

EXEC sp_executesql @TCountQuery, N'@parentId BIGINT, @userId BIGINT, @TotalCount INT OUTPUT', @parentId, @userId, @TotalCount  OUTPUT;

IF(@recordId = 0)
	BEGIN
		SET @sqlCommand = 'SELECT ' + [dbo].[fnGetBaseQueryByUserId](@entity, @userId) 
		SET @sqlCommand = @sqlCommand + ' , prg.[PrgProgramTitle] AS PehProgramIDName '
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

SET @sqlCommand = @sqlCommand + ' FROM [dbo].[PRGRM070EdiHeader] (NOLOCK) '+ @entity

--Below to get BIGINT reference key name by Id if NOT NULL
SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[PRGRM000Master] (NOLOCK) prg ON ' + @entity + '.[PehProgramID]=prg.[Id] '

--Below for getting user specific 'Statuses'
IF((ISNULL(@where, '') = '') OR (@where NOT LIKE '%'+@entity+'.StatusId%'))
	BEGIN
		SET @sqlCommand = @sqlCommand + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) hfk ON ISNULL(' + @entity + '.[StatusId], 1) = hfk.[StatusId] '
	END

SET @sqlCommand = @sqlCommand + ' WHERE '+@entity+'.[PehProgramID]=@parentId '+ ISNULL(@where, '')

IF((@recordId > 0) AND (((@isNext = 0) AND (@isEnd = 0)) OR ((@isNext = 1) AND (@isEnd = 0))))
	BEGIN
		IF((@isNext = 0) AND (@isEnd = 0))  
   BEGIN  
	IF(ISNULL(@orderBy, '') <> '')
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND ' + @orderBy + ' <= (SELECT ' + @orderBy + ' FROM [dbo].[PRGRM070EdiHeader] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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
		SET @sqlCommand = @sqlCommand + ' AND ' + @orderBy + ' >= (SELECT ' + @orderBy + ' FROM [dbo].[PRGRM070EdiHeader] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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

EXEC sp_executesql @sqlCommand, N'@pageNo INT, @pageSize INT,@orderBy NVARCHAR(500), @where NVARCHAR(500), @parentId BIGINT, @entity NVARCHAR(100),@userId BIGINT' ,
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
/****** Object:  StoredProcedure [dbo].[GetPrgEdiMapping]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               09/14/2018      
-- Description:               Get a  Program Role
-- Execution:                 EXEC [dbo].[GetPrgEdiMapping]
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)   
-- Modified Desc:  
-- =============================================
ALTER PROCEDURE  [dbo].[GetPrgEdiMapping]
    @userId BIGINT,
    @roleId BIGINT,
	@orgId BIGINT,
    @id BIGINT
AS
BEGIN TRY                
 SET NOCOUNT ON;   
  SELECT  prg.[Id]
		 ,prg.[PemHeaderID]
         ,prg.[PemEdiTableName]
         ,prg.[PemEdiFieldName]
         ,prg.[PemEdiFieldDataType]
         ,prg.[PemSysTableName]
         ,prg.[PemSysFieldName]
         ,prg.[PemSysFieldDataType]
         ,prg.[StatusId]
         ,prg.[PemInsertUpdate]
         ,prg.[PemDateStart]
         ,prg.[PemDateEnd]
         ,prg.[EnteredBy]
         ,prg.[DateEntered]
         ,prg.[ChangedBy]
         ,prg.[DateChanged]
  FROM   [dbo].[PRGRM071EdiMapping] prg
 WHERE   [Id] = @id
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetPrgEdiMappingView]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               09/14/2018      
-- Description:               Get all  Program EDI mapping
-- Execution:                 EXEC [dbo].[GetPrgEdiMappingView]
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)    
-- Modified Desc:  
-- =============================================   
ALTER PROCEDURE [dbo].[GetPrgEdiMappingView]  
 @userId BIGINT,  
 @roleId BIGINT,  
 @orgId BIGINT,  
 @entity NVARCHAR(100),  
 @pageNo INT,  
 @pageSize INT,  
 @orderBy NVARCHAR(500), 
 @groupBy NVARCHAR(500), 
 @groupByWhere NVARCHAR(500),  
 @where NVARCHAR(500),  
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
  
SET @TCountQuery = 'SELECT @TotalCount = COUNT(Id) FROM [dbo].[PRGRM071EdiMapping] (NOLOCK) '+ @entity   
  
--Below for getting user specific 'Statuses'  
IF((ISNULL(@where, '') = '') OR (@where NOT LIKE '%'+@entity+'.StatusId%'))  
 BEGIN  
  SET @TCountQuery = @TCountQuery + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) fgus ON ' + @entity + '.[StatusId] = fgus.[StatusId] '  
 END  
  
SET @TCountQuery = @TCountQuery + '  WHERE [PemHeaderID] = @parentId  ' + ISNULL(@where, '')  
  
EXEC sp_executesql @TCountQuery, N'@parentId BIGINT,@userId BIGINT, @TotalCount INT OUTPUT',@parentId,@userId , @TotalCount  OUTPUT;  
  
IF(@recordId = 0)  
 BEGIN  
  SET @sqlCommand = 'SELECT ' + [dbo].[fnGetBaseQueryByUserId](@entity, @userId)   
  SET @sqlCommand = @sqlCommand + ' , ediHeader.[PehEdiTitle] AS PemHeaderIDName '  
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
  
SET @sqlCommand = @sqlCommand + ' FROM [dbo].[PRGRM071EdiMapping] (NOLOCK) '+ @entity  
  
--Below to get BIGINT reference key name by Id if NOT NULL  
SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[PRGRM070EdiHeader] (NOLOCK) ediHeader ON ' + @entity + '.[PemHeaderID]=ediHeader.[Id] '  
--SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[SYSTM000ColumnsAlias] (NOLOCK) colAlias ON ' + @entity + '.[PemEdiFieldId]=colAlias.[Id] '  
--SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[SYSTM000ColumnsAlias] (NOLOCK) colAlias2 ON ' + @entity + '.[PemSysFieldId]=colAlias2.[Id] '  
  
--Below for getting user specific 'Statuses'  
IF((ISNULL(@where, '') = '') OR (@where NOT LIKE '%'+@entity+'.StatusId%'))  
 BEGIN  
  SET @sqlCommand = @sqlCommand + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) hfk ON ISNULL(' + @entity + '.[StatusId], 1) = hfk.[StatusId] '  
 END  
  
SET @sqlCommand = @sqlCommand + ' WHERE ' + @entity + '.[PemHeaderID] = @parentId '+ ISNULL(@where, '')  
  
IF((@recordId > 0) AND (((@isNext = 0) AND (@isEnd = 0)) OR ((@isNext = 1) AND (@isEnd = 0))))  
 BEGIN  
  IF((@isNext = 0) AND (@isEnd = 0))  
   BEGIN  
	IF(ISNULL(@orderBy, '') <> '')
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND ' + @orderBy + ' <= (SELECT ' + @orderBy + ' FROM [dbo].[PRGRM071EdiMapping] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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
		SET @sqlCommand = @sqlCommand + ' AND ' + @orderBy + ' >= (SELECT ' + @orderBy + ' FROM [dbo].[PRGRM071EdiMapping] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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
  
EXEC sp_executesql @sqlCommand, N'@pageNo INT, @pageSize INT,@orderBy NVARCHAR(500), @where NVARCHAR(500), @orgId BIGINT, @entity NVARCHAR(100),@userId BIGINT,@parentId BIGINT' ,  
  @entity= @entity,  
     @pageNo= @pageNo,   
     @pageSize= @pageSize,  
     @orderBy = @orderBy,  
     @where = @where,  
  @orgId = @orgId,  
  @userId = @userId  ,
   @parentId = @parentId
END TRY                  
BEGIN CATCH                  
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                  
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                  
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                  
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                  
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetPrgMvoc]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               09/26/2018      
-- Description:               Get a  Program MVOC
-- Execution:                 EXEC [dbo].[GetPrgMvoc]
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)   
-- Modified Desc:  
-- =============================================
ALTER PROCEDURE  [dbo].[GetPrgMvoc]
    @userId BIGINT,
    @roleId BIGINT,
	@orgId BIGINT,
    @id BIGINT
AS
BEGIN TRY                
 SET NOCOUNT ON;   
  SELECT prg.Id
		,prg.VocOrgID
		,prg.VocProgramID
		,prg.VocSurveyCode
		,prg.VocSurveyTitle
		,prg.StatusId
		,prg.VocDateOpen
		,prg.VocDateClose
		,prg.DateEntered
		,prg.EnteredBy
		,prg.DateChanged
		,prg.ChangedBy
  FROM   [dbo].[MVOC000Program] prg
 WHERE   [Id] = @id
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetPrgMvocRefQuestion]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               09/26/2018      
-- Description:               Get a  MVOC ref question
-- Execution:                 EXEC [dbo].[GetPrgMvocRefQuestion]
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)   
-- Modified Desc:  
-- ============================================= 
ALTER PROCEDURE  [dbo].[GetPrgMvocRefQuestion]
    @userId BIGINT,
    @roleId BIGINT,
	@orgId BIGINT,
    @id BIGINT
AS
BEGIN TRY                
 SET NOCOUNT ON;   
  SELECT prg.Id
		,prg.MVOCID
		,prg.QueQuestionNumber
		,prg.QueCode
		,prg.QueTitle
		,prg.QuesTypeId
		,prg.QueType_YNAnswer
		,prg.QueType_YNDefault
		,prg.QueType_RangeLo
		,prg.QueType_RangeHi
		,prg.QueType_RangeAnswer
		,prg.QueType_RangeDefault
		,prg.StatusId
		,prg.DateEntered
		,prg.EnteredBy
		,prg.DateChanged
		,prg.ChangedBy
		,(SELECT pg.Id FROM [dbo].[PRGRM000Master] pg INNER JOIN [dbo].[MVOC000Program] pgm ON pgm.VocProgramID = pg.Id WHERE pgm.Id = prg.MVOCID) AS ParentId
  FROM   [dbo].[MVOC010Ref_Questions] prg
 WHERE   [Id] = @id
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetPrgMvocRefQuestionView]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               09/26/2018      
-- Description:               Get all mvoc ref question 
-- Execution:                 EXEC [dbo].[GetPrgMvocRefQuestionView]
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)   
-- Modified Desc:  
-- =============================================    
ALTER PROCEDURE [dbo].[GetPrgMvocRefQuestionView]    
 @userId BIGINT,    
 @roleId BIGINT,    
 @orgId BIGINT,    
 @entity NVARCHAR(100),    
 @pageNo INT,    
 @pageSize INT,    
 @orderBy NVARCHAR(500),  
 @groupBy NVARCHAR(500), 
 @groupByWhere NVARCHAR(500),   
 @where NVARCHAR(500),    
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
    
SET @TCountQuery = 'SELECT @TotalCount = COUNT(Id) FROM [dbo].[MVOC010Ref_Questions] (NOLOCK) '+ @entity     
    
--Below for getting user specific 'Statuses'    
IF((ISNULL(@where, '') = '') OR (@where NOT LIKE '%'+@entity+'.StatusId%'))    
 BEGIN    
  SET @TCountQuery = @TCountQuery + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) fgus ON ' + @entity + '.[StatusId] = fgus.[StatusId] '    
 END    
    
SET @TCountQuery = @TCountQuery + ' WHERE [MVOCID] = @parentId ' + ISNULL(@where, '')    
    
	PRINT @TCountQuery;
EXEC sp_executesql @TCountQuery, N'@parentId BIGINT ,@userId BIGINT, @TotalCount INT OUTPUT',@parentId,@userId , @TotalCount  OUTPUT;    
    
IF(@recordId = 0)    
 BEGIN    
  SET @sqlCommand = 'SELECT ' + [dbo].[fnGetBaseQueryByUserId](@entity, @userId)     
  SET @sqlCommand = @sqlCommand + ' , prgMvoc.[VocSurveyCode] AS MVOCIDName '    
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
    
SET @sqlCommand = @sqlCommand + ' FROM [dbo].[MVOC010Ref_Questions] (NOLOCK) '+ @entity    
    
--Below to get BIGINT reference key name by Id if NOT NULL    
SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[MVOC000Program] (NOLOCK) prgMvoc ON ' + @entity + '.[MVOCID]=prgMvoc.[Id] '    
    
--Below for getting user specific 'Statuses'    
IF((ISNULL(@where, '') = '') OR (@where NOT LIKE '%'+@entity+'.StatusId%'))    
 BEGIN    
  SET @sqlCommand = @sqlCommand + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) hfk ON ISNULL(' + @entity + '.[StatusId], 1) = hfk.[StatusId] '    
 END    
    
SET @sqlCommand = @sqlCommand + ' WHERE [MVOCID] = @parentId '+ ISNULL(@where, '')    
    
IF((@recordId > 0) AND (((@isNext = 0) AND (@isEnd = 0)) OR ((@isNext = 1) AND (@isEnd = 0))))    
 BEGIN    
  IF((@isNext = 0) AND (@isEnd = 0))  
   BEGIN  
	IF(ISNULL(@orderBy, '') <> '')
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND ' + @orderBy + ' <= (SELECT ' + @orderBy + ' FROM [dbo].[MVOC010Ref_Questions] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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
		SET @sqlCommand = @sqlCommand + ' AND ' + @orderBy + ' >= (SELECT ' + @orderBy + ' FROM [dbo].[MVOC010Ref_Questions] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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
    
EXEC sp_executesql @sqlCommand, N'@pageNo INT, @pageSize INT,@orderBy NVARCHAR(500), @where NVARCHAR(500), @orgId BIGINT, @entity NVARCHAR(100),@parentId BIGINT,@userId BIGINT' ,    
  @entity= @entity,    
     @pageNo= @pageNo,     
     @pageSize= @pageSize,    
     @orderBy = @orderBy,    
     @where = @where,    
  @orgId = @orgId,    
  @parentId =@parentId,  
  @userId = @userId    
END TRY                    
BEGIN CATCH                   DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                    
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                    
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                    
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                    
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetPrgMvocView]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               09/26/2018      
-- Description:               Get all program mvoc 
-- Execution:                 EXEC [dbo].[GetPrgMvocView]
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)    
-- Modified Desc:  
-- =============================================
ALTER PROCEDURE [dbo].[GetPrgMvocView]
 @userId BIGINT,
 @roleId BIGINT,
 @orgId BIGINT,
 @entity NVARCHAR(100),
 @pageNo INT,
 @pageSize INT,
 @orderBy NVARCHAR(500),
 @groupBy NVARCHAR(500), 
 @groupByWhere NVARCHAR(500), 
 @where NVARCHAR(500),
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

SET @TCountQuery = 'SELECT @TotalCount = COUNT(Id) FROM [dbo].[MVOC000Program] (NOLOCK) '+ @entity 

--Below for getting user specific 'Statuses'
IF((ISNULL(@where, '') = '') OR (@where NOT LIKE '%'+@entity+'.StatusId%'))
	BEGIN
		SET @TCountQuery = @TCountQuery + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) fgus ON ' + @entity + '.[StatusId] = fgus.[StatusId] '
	END

SET @TCountQuery = @TCountQuery + ' WHERE [VocOrgID] = @orgId AND [VocProgramID] = @parentId ' + ISNULL(@where, '')

EXEC sp_executesql @TCountQuery, N'@orgId BIGINT, @parentId BIGINT, @userId BIGINT, @TotalCount INT OUTPUT', @orgId, @parentId, @userId, @TotalCount  OUTPUT;

IF(@recordId = 0)
	BEGIN
		SET @sqlCommand = 'SELECT ' + [dbo].[fnGetBaseQueryByUserId](@entity, @userId) 
		SET @sqlCommand = @sqlCommand + ' ,org.[OrgTitle] AS VocOrgIDName, prg.[PrgProgramTitle] AS VocProgramIDName '
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

SET @sqlCommand = @sqlCommand + ' FROM [dbo].[MVOC000Program] (NOLOCK) '+ @entity

--Below to get BIGINT reference key name by Id if NOT NULL
SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[ORGAN000Master] (NOLOCK) org ON ' + @entity + '.[VocOrgID]=org.[Id] '
SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[PRGRM000Master] (NOLOCK) prg ON ' + @entity + '.[VocProgramID]=prg.[Id] '

--Below for getting user specific 'Statuses'
IF((ISNULL(@where, '') = '') OR (@where NOT LIKE '%'+@entity+'.StatusId%'))
	BEGIN
		SET @sqlCommand = @sqlCommand + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) hfk ON ISNULL(' + @entity + '.[StatusId], 1) = hfk.[StatusId] '
	END

SET @sqlCommand = @sqlCommand + ' WHERE '+@entity+'.[VocOrgID] = @orgId AND '+@entity+'.[VocProgramID] = @parentId '+ ISNULL(@where, '')

IF((@recordId > 0) AND (((@isNext = 0) AND (@isEnd = 0)) OR ((@isNext = 1) AND (@isEnd = 0))))
	BEGIN
		IF((@isNext = 0) AND (@isEnd = 0))  
   BEGIN  
	IF(ISNULL(@orderBy, '') <> '')
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND ' + @orderBy + ' <= (SELECT ' + @orderBy + ' FROM [dbo].[MVOC000Program] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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
		SET @sqlCommand = @sqlCommand + ' AND ' + @orderBy + ' >= (SELECT ' + @orderBy + ' FROM [dbo].[MVOC000Program] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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

EXEC sp_executesql @sqlCommand, N'@pageNo INT, @pageSize INT,@orderBy NVARCHAR(500), @where NVARCHAR(500), @orgId BIGINT, @parentId BIGINT, @entity NVARCHAR(100),@userId BIGINT' ,
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
/****** Object:  StoredProcedure [dbo].[GetPrgRefAttributeDefault]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               09/14/2018      
-- Description:               Get a  Program Ref Attributes
-- Execution:                 EXEC [dbo].[GetPrgRefAttributeDefault]
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)  
-- Modified Desc:  
-- ============================================= 
ALTER PROCEDURE  [dbo].[GetPrgRefAttributeDefault]
    @userId BIGINT,
    @roleId BIGINT,
	@orgId BIGINT,
    @id BIGINT
AS
BEGIN TRY                
 SET NOCOUNT ON;   
  SELECT prg.[Id]
		,prg.[ProgramID]
		,prg.[AttItemNumber]
		,prg.[AttCode]
		,prg.[AttTitle]
		,prg.[AttQuantity]
		,prg.[UnitTypeId]
		,prg.[AttDefault]
		,prg.[StatusId]  
		,prg.[DateEntered]
		,prg.[EnteredBy]
		,prg.[DateChanged]
		,prg.[ChangedBy]
  FROM   [dbo].[PRGRM020Ref_AttributesDefault] prg
 WHERE   [Id] = @id
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetPrgRefAttributeDefaultView]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               09/14/2018      
-- Description:               Get all  Program Ref Attributes
-- Execution:                 EXEC [dbo].[GetPrgRefAttributeDefaultView]
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)   
-- Modified Desc:  
-- ============================================= 
ALTER PROCEDURE [dbo].[GetPrgRefAttributeDefaultView]
 @userId BIGINT,
 @roleId BIGINT,
 @orgId BIGINT,
 @entity NVARCHAR(100),
 @pageNo INT,
 @pageSize INT,
 @orderBy NVARCHAR(500),
 @groupBy NVARCHAR(500), 
 @groupByWhere NVARCHAR(500), 
 @where NVARCHAR(500),
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

SET @TCountQuery = 'SELECT @TotalCount = COUNT(Id) FROM [dbo].[PRGRM020Ref_AttributesDefault] (NOLOCK) '+ @entity 

--Below for getting user specific 'Statuses'
IF((ISNULL(@where, '') = '') OR (@where NOT LIKE '%'+@entity+'.StatusId%'))
	BEGIN
		SET @TCountQuery = @TCountQuery + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) fgus ON ' + @entity + '.[StatusId] = fgus.[StatusId] '
	END

SET @TCountQuery = @TCountQuery + ' WHERE [ProgramID] = @parentId ' + ISNULL(@where, '')

EXEC sp_executesql @TCountQuery, N'@parentId BIGINT, @userId BIGINT, @TotalCount INT OUTPUT', @parentId, @userId, @TotalCount  OUTPUT;

IF(@recordId = 0)
	BEGIN
		SET @sqlCommand = 'SELECT ' + [dbo].[fnGetBaseQueryByUserId](@entity, @userId) 
		SET @sqlCommand = @sqlCommand + ' , prg.[PrgProgramTitle] AS ProgramIDName '
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

SET @sqlCommand = @sqlCommand + ' FROM [dbo].[PRGRM020Ref_AttributesDefault] (NOLOCK) '+ @entity

--Below to get BIGINT reference key name by Id if NOT NULL
SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[PRGRM000Master] (NOLOCK) prg ON ' + @entity + '.[ProgramID]=prg.[Id] '

--Below for getting user specific 'Statuses'
IF((ISNULL(@where, '') = '') OR (@where NOT LIKE '%'+@entity+'.StatusId%'))
	BEGIN
		SET @sqlCommand = @sqlCommand + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) hfk ON ISNULL(' + @entity + '.[StatusId], 1) = hfk.[StatusId] '
	END

SET @sqlCommand = @sqlCommand + ' WHERE '+@entity+'.[ProgramID]=@parentId '+ ISNULL(@where, '')

IF((@recordId > 0) AND (((@isNext = 0) AND (@isEnd = 0)) OR ((@isNext = 1) AND (@isEnd = 0))))
	BEGIN
		IF((@isNext = 0) AND (@isEnd = 0))  
   BEGIN  
	IF(ISNULL(@orderBy, '') <> '')
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND ' + @orderBy + ' <= (SELECT ' + @orderBy + ' FROM [dbo].[PRGRM020Ref_AttributesDefault] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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
		SET @sqlCommand = @sqlCommand + ' AND ' + @orderBy + ' >= (SELECT ' + @orderBy + ' FROM [dbo].[PRGRM020Ref_AttributesDefault] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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

EXEC sp_executesql @sqlCommand, N'@pageNo INT, @pageSize INT,@orderBy NVARCHAR(500), @where NVARCHAR(500), @parentId BIGINT, @entity NVARCHAR(100),@userId BIGINT' ,
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
/****** Object:  StoredProcedure [dbo].[GetPrgRefGatewayDefault]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               09/14/2018      
-- Description:               Get a  Program Ref Gateway Default
-- Execution:                 EXEC [dbo].[GetPrgRefGatewayDefault]
-- Modified on:               04/27/2018
-- Modified Desc:             Added Scanner Field
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)  
-- =============================================
ALTER PROCEDURE  [dbo].[GetPrgRefGatewayDefault]
    @userId BIGINT,
    @roleId BIGINT,
	@orgId BIGINT,
    @id BIGINT
AS
BEGIN TRY                
 SET NOCOUNT ON;   
  SELECT prg.[Id]
		,prg.[PgdProgramID]
		,prg.[PgdGatewaySortOrder]
		,prg.[PgdGatewayCode]
		,prg.[PgdGatewayTitle]
		,prg.[PgdGatewayDuration]
		,prg.[UnitTypeId]
		,prg.[PgdGatewayDefault]
		,prg.[GatewayTypeId]
		,prg.[GatewayDateRefTypeId]
		,prg.[Scanner]
		,prg.[PgdShipApptmtReasonCode]
		,prg.[PgdShipStatusReasonCode]
		,prg.[PgdOrderType]
		,prg.[PgdShipmentType]
		,prg.[PgdGatewayResponsible]
		,prg.[PgdGatewayAnalyst]
		,prg.[StatusId]
		,prg.[DateEntered]
		,prg.[EnteredBy]
		,prg.[DateChanged]
		,prg.[ChangedBy]
  FROM   [dbo].[PRGRM010Ref_GatewayDefaults] prg
 WHERE   [Id] = @id
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetPrgRefGatewayDefaultView]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               09/14/2018      
-- Description:               Get all  Program Ref Gateway Default
-- Execution:                 EXEC [dbo].[GetPrgRefGatewayDefaultView]
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)    
-- Modified Desc:  
-- =============================================
ALTER PROCEDURE [dbo].[GetPrgRefGatewayDefaultView]
 @userId BIGINT,
 @roleId BIGINT,
 @orgId BIGINT,
 @entity NVARCHAR(100),
 @pageNo INT,
 @pageSize INT,
 @orderBy NVARCHAR(500),
 @groupBy NVARCHAR(500), 
 @groupByWhere NVARCHAR(500), 
 @where NVARCHAR(500),
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

SET @TCountQuery = 'SELECT @TotalCount = COUNT(Id) FROM [dbo].[PRGRM010Ref_GatewayDefaults] (NOLOCK) '+ @entity 

--Below for getting user specific 'Statuses'
IF((ISNULL(@where, '') = '') OR (@where NOT LIKE '%'+@entity+'.StatusId%'))
	BEGIN
		SET @TCountQuery = @TCountQuery + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) fgus ON ' + @entity + '.[StatusId] = fgus.[StatusId] '
	END

SET @TCountQuery = @TCountQuery + ' WHERE [PgdProgramID] = @parentId ' + ISNULL(@where, '')

EXEC sp_executesql @TCountQuery, N'@parentId BIGINT, @userId BIGINT, @TotalCount INT OUTPUT', @parentId, @userId, @TotalCount  OUTPUT;

IF(@recordId = 0)
	BEGIN
		SET @sqlCommand = 'SELECT ' + [dbo].[fnGetBaseQueryByUserId](@entity, @userId) 
		SET @sqlCommand = @sqlCommand + ' , prg.[PrgProgramTitle] AS PgdProgramIDName , respContact.[ConFullName] AS PgdGatewayResponsibleName ,  anaContact.[ConFullName] AS PgdGatewayAnalystName  '
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

SET @sqlCommand = @sqlCommand + ' FROM [dbo].[PRGRM010Ref_GatewayDefaults] (NOLOCK) '+ @entity

--Below to get BIGINT reference key name by Id if NOT NULL
SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[PRGRM000Master] (NOLOCK) prg ON ' + @entity + '.[PgdProgramID]=prg.[Id] '
SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[CONTC000Master] (NOLOCK) respContact ON ' + @entity + '.[PgdGatewayResponsible]=respContact.[Id] '
SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[CONTC000Master] (NOLOCK) anaContact ON ' + @entity + '.[PgdGatewayAnalyst]=anaContact.[Id] '

--Below for getting user specific 'Statuses'
IF((ISNULL(@where, '') = '') OR (@where NOT LIKE '%'+@entity+'.StatusId%'))
	BEGIN
		SET @sqlCommand = @sqlCommand + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) hfk ON ISNULL(' + @entity + '.[StatusId], 1) = hfk.[StatusId] '
	END

SET @sqlCommand = @sqlCommand + ' WHERE '+@entity+'.[PgdProgramID]=@parentId '+ ISNULL(@where, '')

IF((@recordId > 0) AND (((@isNext = 0) AND (@isEnd = 0)) OR ((@isNext = 1) AND (@isEnd = 0))))
	BEGIN
		IF((@isNext = 0) AND (@isEnd = 0))  
   BEGIN  
	IF(ISNULL(@orderBy, '') <> '')
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND ' + @orderBy + ' <= (SELECT ' + @orderBy + ' FROM [dbo].[PRGRM010Ref_GatewayDefaults] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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
		SET @sqlCommand = @sqlCommand + ' AND ' + @orderBy + ' >= (SELECT ' + @orderBy + ' FROM [dbo].[PRGRM010Ref_GatewayDefaults] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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

EXEC sp_executesql @sqlCommand, N'@pageNo INT, @pageSize INT,@orderBy NVARCHAR(500), @where NVARCHAR(500), @parentId BIGINT, @entity NVARCHAR(100),@userId BIGINT' ,
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
/****** Object:  StoredProcedure [dbo].[GetPrgShipApptmtReasonCode]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               09/14/2018      
-- Description:               Get a  Program Ship Apptmt Reason Code
-- Execution:                 EXEC [dbo].[GetPrgShipApptmtReasonCode]
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)   
-- Modified Desc:  
-- =============================================
ALTER PROCEDURE  [dbo].[GetPrgShipApptmtReasonCode]
    @userId BIGINT,
    @roleId BIGINT,
	@orgId BIGINT,
    @id BIGINT
AS
BEGIN TRY                
 SET NOCOUNT ON;   
  SELECT prg.[Id]
		,prg.[PacOrgID]
		,prg.[PacProgramID]
		,prg.[PacApptItem]
		,prg.[PacApptReasonCode]
		,prg.[PacApptLength]
		,prg.[PacApptInternalCode]
		,prg.[PacApptPriorityCode]
		,prg.[PacApptTitle]
		,prg.[PacApptCategoryCode]
		,prg.[PacApptUser01Code]
		,prg.[PacApptUser02Code]
		,prg.[PacApptUser03Code]
		,prg.[PacApptUser04Code]
		,prg.[PacApptUser05Code]
		,prg.[StatusId]
		,prg.[DateEntered]
		,prg.[EnteredBy]
		,prg.[DateChanged]
		,prg.[ChangedBy]
  FROM   [dbo].[PRGRM031ShipApptmtReasonCodes] prg
 WHERE   [Id] = @id
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetPrgShipApptmtReasonCodeView]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               09/14/2018      
-- Description:               Get all  Program Ship Apptmt Reason Code
-- Execution:                 EXEC [dbo].[GetPrgShipApptmtReasonCodeView]
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)   
-- Modified Desc:  
-- =============================================  
ALTER PROCEDURE [dbo].[GetPrgShipApptmtReasonCodeView]  
 @userId BIGINT,  
 @roleId BIGINT,  
 @orgId BIGINT,  
 @entity NVARCHAR(100),  
 @pageNo INT,  
 @pageSize INT,  
 @orderBy NVARCHAR(500),  
 @groupBy NVARCHAR(500), 
 @groupByWhere NVARCHAR(500), 
 @where NVARCHAR(500),  
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
  
SET @TCountQuery = 'SELECT @TotalCount = COUNT(Id) FROM [dbo].[PRGRM031ShipApptmtReasonCodes] (NOLOCK) '+ @entity 

--Below for getting user specific 'Statuses'
IF((ISNULL(@where, '') = '') OR (@where NOT LIKE '%'+@entity+'.StatusId%'))
	BEGIN
		SET @TCountQuery = @TCountQuery + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) fgus ON ' + @entity + '.[StatusId] = fgus.[StatusId] '
	END
  
SET @TCountQuery = @TCountQuery + ' WHERE [PacOrgID] = @orgId AND [PacProgramID] = @parentId ' + ISNULL(@where, '')

EXEC sp_executesql @TCountQuery, N'@orgId BIGINT, @parentId BIGINT, @userId BIGINT, @TotalCount INT OUTPUT', @orgId, @parentId, @userId, @TotalCount  OUTPUT;  
 
IF(@recordId = 0)
	BEGIN  
		SET @sqlCommand = 'SELECT ' + [dbo].[fnGetBaseQueryByUserId](@entity, @userId)   
		SET @sqlCommand = @sqlCommand + ' ,org.[OrgTitle] AS PacOrgIDName, prg.[PrgProgramTitle] AS PacProgramIDName '
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

SET @sqlCommand = @sqlCommand + ' FROM [dbo].[PRGRM031ShipApptmtReasonCodes] (NOLOCK) '+ @entity  
  
--Below to get BIGINT reference key name by Id if NOT NULL  
SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[ORGAN000Master] (NOLOCK) org ON ' + @entity + '.[PacOrgID]=org.[Id] '  
SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[PRGRM000Master] (NOLOCK) prg ON ' + @entity + '.[PacProgramID]=prg.[Id] '  

--Below for getting user specific 'Statuses'
IF((ISNULL(@where, '') = '') OR (@where NOT LIKE '%'+@entity+'.StatusId%'))
	BEGIN
		SET @sqlCommand = @sqlCommand + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) hfk ON ISNULL(' + @entity + '.[StatusId], 1) = hfk.[StatusId] '
	END
  
SET @sqlCommand = @sqlCommand + ' WHERE '+@entity+'.[PacOrgID] = @orgId AND '+@entity+'.[PacProgramID]=@parentId '+ ISNULL(@where, '')  
  
IF((@recordId > 0) AND (((@isNext = 0) AND (@isEnd = 0)) OR ((@isNext = 1) AND (@isEnd = 0))))
	BEGIN
		IF((@isNext = 0) AND (@isEnd = 0))  
   BEGIN  
	IF(ISNULL(@orderBy, '') <> '')
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND ' + @orderBy + ' <= (SELECT ' + @orderBy + ' FROM [dbo].[PRGRM031ShipApptmtReasonCodes] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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
		SET @sqlCommand = @sqlCommand + ' AND ' + @orderBy + ' >= (SELECT ' + @orderBy + ' FROM [dbo].[PRGRM031ShipApptmtReasonCodes] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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
  
EXEC sp_executesql @sqlCommand, N'@pageNo INT, @pageSize INT,@orderBy NVARCHAR(500), @where NVARCHAR(500), @orgId BIGINT, @parentId BIGINT, @entity NVARCHAR(100),@userId BIGINT' ,  
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
/****** Object:  StoredProcedure [dbo].[GetPrgShipStatusReasonCode]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               09/14/2018      
-- Description:               Get a  Program Ship Status Reason Code
-- Execution:                 EXEC [dbo].[GetPrgShipStatusReasonCode]
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)    
-- Modified Desc:  
-- =============================================
ALTER PROCEDURE  [dbo].[GetPrgShipStatusReasonCode]
    @userId BIGINT,
    @roleId BIGINT,
	@orgId BIGINT,
    @id BIGINT
AS
BEGIN TRY                
 SET NOCOUNT ON;   
  SELECT prg.[Id]
		,prg.[PscOrgID]
		,prg.[PscProgramID]
		,prg.[PscShipItem]
		,prg.[PscShipReasonCode]
		,prg.[PscShipLength]
		,prg.[PscShipInternalCode]
		,prg.[PscShipPriorityCode]
		,prg.[PscShipTitle]
		,prg.[PscShipCategoryCode]
		,prg.[PscShipUser01Code]
		,prg.[PscShipUser02Code]
		,prg.[PscShipUser03Code]
		,prg.[PscShipUser04Code]
		,prg.[PscShipUser05Code]
		,prg.[StatusId]
		,prg.[DateEntered]
		,prg.[EnteredBy]
		,prg.[DateChanged]
		,prg.[ChangedBy]
  FROM   [dbo].[PRGRM030ShipStatusReasonCodes] prg
 WHERE   [Id] = @id
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetPrgShipStatusReasonCodeView]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               09/14/2018      
-- Description:               Get all  Program Ship Status Reason Code
-- Execution:                 EXEC [dbo].[GetPrgShipStatusReasonCodeView]
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)   
-- Modified Desc:  
-- ============================================= 
ALTER PROCEDURE [dbo].[GetPrgShipStatusReasonCodeView]
 @userId BIGINT,
 @roleId BIGINT,
 @orgId BIGINT,
 @entity NVARCHAR(100),
 @pageNo INT,
 @pageSize INT,
 @orderBy NVARCHAR(500),
 @groupBy NVARCHAR(500), 
 @groupByWhere NVARCHAR(500), 
 @where NVARCHAR(500),
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

SET @TCountQuery = 'SELECT @TotalCount = COUNT(Id) FROM [dbo].[PRGRM030ShipStatusReasonCodes] (NOLOCK) '+ @entity 

--Below for getting user specific 'Statuses'
IF((ISNULL(@where, '') = '') OR (@where NOT LIKE '%'+@entity+'.StatusId%'))
	BEGIN
		SET @TCountQuery = @TCountQuery + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) fgus ON ' + @entity + '.[StatusId] = fgus.[StatusId] '
	END

SET @TCountQuery =  @TCountQuery + ' WHERE [PscOrgID] = @orgId AND [PscProgramID] = @parentId ' + ISNULL(@where, '')
EXEC sp_executesql @TCountQuery, N'@orgId BIGINT, @parentId BIGINT, @userId BIGINT, @TotalCount INT OUTPUT', @orgId, @parentId, @userId, @TotalCount  OUTPUT;

IF(@recordId = 0)
	BEGIN
		SET @sqlCommand = 'SELECT ' + [dbo].[fnGetBaseQueryByUserId](@entity, @userId) 
		SET @sqlCommand = @sqlCommand + ' ,org.[OrgTitle] AS PscOrgIDName, prg.[PrgProgramTitle] AS PscProgramIDName '
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

SET @sqlCommand = @sqlCommand + ' FROM [dbo].[PRGRM030ShipStatusReasonCodes] (NOLOCK) '+ @entity

--Below to get BIGINT reference key name by Id if NOT NULL
SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[ORGAN000Master] (NOLOCK) org ON ' + @entity + '.[PscOrgID]=org.[Id] '
SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[PRGRM000Master] (NOLOCK) prg ON ' + @entity + '.[PscProgramID]=prg.[Id] '

--Below for getting user specific 'Statuses'
IF((ISNULL(@where, '') = '') OR (@where NOT LIKE '%'+@entity+'.StatusId%'))
	BEGIN
		SET @sqlCommand = @sqlCommand + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) hfk ON ISNULL(' + @entity + '.[StatusId], 1) = hfk.[StatusId] '
	END

SET @sqlCommand = @sqlCommand + ' WHERE '+@entity+'.[PscOrgID] = @orgId AND '+@entity+'.[PscProgramID]=@parentId '+ ISNULL(@where, '')

IF((@recordId > 0) AND (((@isNext = 0) AND (@isEnd = 0)) OR ((@isNext = 1) AND (@isEnd = 0))))
	BEGIN
		IF((@isNext = 0) AND (@isEnd = 0))  
   BEGIN  
	IF(ISNULL(@orderBy, '') <> '')
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND ' + @orderBy + ' <= (SELECT ' + @orderBy + ' FROM [dbo].[PRGRM030ShipStatusReasonCodes] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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
		SET @sqlCommand = @sqlCommand + ' AND ' + @orderBy + ' >= (SELECT ' + @orderBy + ' FROM [dbo].[PRGRM030ShipStatusReasonCodes] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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

EXEC sp_executesql @sqlCommand, N'@pageNo INT, @pageSize INT,@orderBy NVARCHAR(500), @where NVARCHAR(500), @orgId BIGINT, @parentId BIGINT, @entity NVARCHAR(100),@userId BIGINT' ,
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
/****** Object:  StoredProcedure [dbo].[GetPrgVendLocation]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               09/14/2018      
-- Description:               Get a  Program vendor location
-- Execution:                 EXEC [dbo].[GetPrgVendLocation]
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)   
-- Modified Desc:  
-- ============================================= 
ALTER PROCEDURE  [dbo].[GetPrgVendLocation]
    @userId BIGINT,
    @roleId BIGINT,
	@orgId BIGINT,
    @id BIGINT
AS
BEGIN TRY                
 SET NOCOUNT ON;   
  SELECT prg.[Id]
		,prg.[PvlProgramID]
		,prg.[PvlVendorID]
		,prg.[PvlItemNumber]
		,prg.[PvlLocationCode]
		,prg.[PvlLocationCodeCustomer]
		,prg.[PvlLocationTitle]
		,prg.[PvlContactMSTRID]
		,prg.[StatusId]
		,prg.[PvlDateStart]
		,prg.[PvlDateEnd]
		,prg.[PvlUserCode1]
	    ,prg.[PvlUserCode2]
	    ,prg.[PvlUserCode3]
	    ,prg.[PvlUserCode4]
	    ,prg.[PvlUserCode5]
		,prg.[EnteredBy]
		,prg.[DateEntered]
		,prg.[ChangedBy]
		,prg.[DateChanged]
		,vend.VendCode AS VendorCode
  FROM   [dbo].[PRGRM051VendorLocations] prg
  INNER JOIN VEND000Master vend ON prg.PvlVendorID  = vend.Id
 WHERE   prg.[Id] = @id
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetPrgVendLocationView]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               09/14/2018      
-- Description:               Get all  Program vendor location
-- Execution:                 EXEC [dbo].[GetPrgVendLocationView]
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)   
-- Modified Desc:  
-- ============================================= 
ALTER PROCEDURE [dbo].[GetPrgVendLocationView]
 @userId BIGINT,
 @roleId BIGINT,
 @orgId BIGINT,
 @entity NVARCHAR(100),
 @pageNo INT,
 @pageSize INT,
 @orderBy NVARCHAR(500),
 @groupBy NVARCHAR(500), 
 @groupByWhere NVARCHAR(500), 
 @where NVARCHAR(500),
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

SET @TCountQuery = 'SELECT @TotalCount = COUNT(Id) FROM [dbo].[PRGRM051VendorLocations] (NOLOCK) '+ @entity 

--Below for getting user specific 'Statuses'
IF((ISNULL(@where, '') = '') OR (@where NOT LIKE '%'+@entity+'.StatusId%'))
	BEGIN
		SET @TCountQuery = @TCountQuery + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) fgus ON ' + @entity + '.[StatusId] = fgus.[StatusId] '
	END

SET @TCountQuery = @TCountQuery + ' WHERE [PvlProgramID] = @parentId ' + ISNULL(@where, '')
EXEC sp_executesql @TCountQuery, N'@parentId BIGINT, @userId BIGINT, @TotalCount INT OUTPUT', @parentId, @userId, @TotalCount  OUTPUT;

IF(@recordId = 0)
	BEGIN 
		SET @sqlCommand = 'SELECT ' + [dbo].[fnGetBaseQueryByUserId](@entity, @userId) 
		SET @sqlCommand = @sqlCommand + ' ,vend.[VendCode] AS PvlVendorIDName, cont.[ConFullName] AS PvlContactMSTRIDName '

		SET @sqlCommand = @sqlCommand + ' , CASE WHEN prg.PrgHierarchyLevel = 1 THEN     prg.[PrgProgramCode]
		 WHEN prg.PrgHierarchyLevel = 2 THEN     prg.[PrgProjectCode]
		  WHEN prg.PrgHierarchyLevel = 3 THEN     prg.PrgPhaseCode
		  ELSE prg.[PrgProgramTitle] END AS PvlProgramIDName';

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

SET @sqlCommand = @sqlCommand + ' FROM [dbo].[PRGRM051VendorLocations] (NOLOCK) '+ @entity

--Below to get BIGINT reference key name by Id if NOT NULL
SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[PRGRM000Master] (NOLOCK) prg ON ' + @entity + '.[PvlProgramID]=prg.[Id] '
SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[VEND000Master] (NOLOCK) vend ON ' + @entity + '.[PvlVendorID]=vend.[Id] '
SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[CONTC000Master] (NOLOCK) cont ON ' + @entity + '.[PvlContactMSTRID]=cont.[Id] '

--Below for getting user specific 'Statuses'
IF((ISNULL(@where, '') = '') OR (@where NOT LIKE '%'+@entity+'.StatusId%'))
	BEGIN
		SET @sqlCommand = @sqlCommand + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) hfk ON ISNULL(' + @entity + '.[StatusId], 1) = hfk.[StatusId] '
	END

SET @sqlCommand = @sqlCommand + ' WHERE '+@entity+'.[PvlProgramID]=@parentId '+ ISNULL(@where, '')

IF((@recordId > 0) AND (((@isNext = 0) AND (@isEnd = 0)) OR ((@isNext = 1) AND (@isEnd = 0))))
	BEGIN
		IF((@isNext = 0) AND (@isEnd = 0))  
   BEGIN  
	IF(ISNULL(@orderBy, '') <> '')
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND ' + @orderBy + ' <= (SELECT ' + @orderBy + ' FROM [dbo].[PRGRM051VendorLocations] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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
		SET @sqlCommand = @sqlCommand + ' AND ' + @orderBy + ' >= (SELECT ' + @orderBy + ' FROM [dbo].[PRGRM051VendorLocations] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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

EXEC sp_executesql @sqlCommand, N'@pageNo INT, @pageSize INT,@orderBy NVARCHAR(500), @where NVARCHAR(500), @parentId BIGINT, @entity NVARCHAR(100),@userId BIGINT' ,
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
/****** Object:  StoredProcedure [dbo].[GetProgram]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               09/14/2018      
-- Description:               Get a  Program 
-- Execution:                 EXEC [dbo].[GetProgram]
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)    
-- Modified Desc:  
-- =============================================      
ALTER PROCEDURE  [dbo].[GetProgram]      
    @userId BIGINT,      
    @roleId BIGINT,      
    @orgId BIGINT,      
    @id BIGINT,
	@parentId BIGINT =NULL
AS      
BEGIN TRY                      
 SET NOCOUNT ON; 
 
  IF @id = 0
  BEGIN
    SELECT @id As Id
	       ,CAST(ISNULL((SELECT  PrgHierarchyLevel FROM PRGRM000Master WHERE Id = @parentId),0) + 1 AS smallint)  AS PrgHierarchyLevel
		   ,(SELECT  PrgProgramCode FROM PRGRM000Master WHERE Id = @parentId)   AS PrgProgramCode
		   ,(SELECT  PrgProjectCode FROM PRGRM000Master WHERE Id = @parentId)   AS PrgProjectCode
		   ,(SELECT  PrgCustID FROM PRGRM000Master WHERE Id = @parentId)   AS PrgCustID
		   ,@parentId   AS ParentId
		   ,CAST(1 AS BIT) AS DelDay
		   ,CAST(1 AS BIT) AS PckDay
           
  END
  ELSE 
  BEGIN
  SELECT prg.[Id]      
  ,prg.[PrgOrgID]      
  ,prg.[PrgCustID]      
  ,prg.[PrgItemNumber]      
  ,prg.[PrgProgramCode]      
  ,prg.[PrgProjectCode]      
  ,prg.[PrgPhaseCode]      
  ,prg.[PrgProgramTitle]      
  ,prg.[PrgAccountCode] 
  ,prg.[DelEarliest] 
  ,prg.[DelLatest] 
  --,prg.[DelDay] 
   , CASE WHEN prg.[DelEarliest] IS NULL AND prg.[DelLatest] IS NULL  THEN CAST(1 AS BIT)
     ELSE  prg.[DelDay] END AS DelDay


  ,prg.[PckEarliest] 
  ,prg.[PckLatest] 
  , CASE WHEN prg.[PckEarliest] IS NULL AND prg.[PckLatest] IS NULL  THEN CAST(1 AS BIT)
     ELSE  prg.[PckDay] END AS PckDay
  ,prg.[StatusId]      
  ,prg.[PrgDateStart]      
  ,prg.[PrgDateEnd]      
  ,prg.[PrgDeliveryTimeDefault]      
  ,prg.[PrgPickUpTimeDefault]      
  ,prg.[PrgHierarchyID].ToString() As PrgHierarchyID       
  ,prg.[PrgHierarchyLevel]      
  ,prg.[DateEntered]      
  ,prg.[EnteredBy]      
  ,prg.[DateChanged]      
  ,prg.[ChangedBy]      
  FROM   [dbo].[PRGRM000Master] prg      
 WHERE   [Id] = @id   
 
  END   
END TRY                      
BEGIN CATCH                      
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                      
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                      
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                      
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                      
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetProgramBillableRate]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan             
-- Create date:               09/14/2018      
-- Description:               Get a  Program Billable Rate 
-- Execution:                 EXEC [dbo].[GetProgramBillableRate]   
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)    
-- Modified Desc:  
-- =============================================  
ALTER PROCEDURE  [dbo].[GetProgramBillableRate]
    @userId BIGINT,
    @roleId BIGINT,
	@orgId BIGINT,
    @id BIGINT
AS
BEGIN TRY                
 SET NOCOUNT ON;   
  SELECT prg.[Id]
		,prg.[PbrPrgrmID]
		,prg.[PbrCode]
		,prg.[PbrCustomerCode]
		,prg.[PbrEffectiveDate]
		,prg.[PbrTitle]
		,prg.[RateCategoryTypeId]
		,prg.[RateTypeId]
		,prg.[PbrBillablePrice]
		,prg.[RateUnitTypeId]
		,prg.[PbrFormat]
		,prg.[PbrExpression01]
		,prg.[PbrLogic01]
		,prg.[PbrExpression02]
		,prg.[PbrLogic02]
		,prg.[PbrExpression03]
		,prg.[PbrLogic03]
		,prg.[PbrExpression04]
		,prg.[PbrLogic04]
		,prg.[PbrExpression05]
		,prg.[PbrLogic05]
		,prg.[StatusId]
		,prg.[PbrVendLocationID]
		,prg.[EnteredBy]
		,prg.[DateEntered]
		,prg.[ChangedBy]
		,prg.[DateChanged]
  FROM   [dbo].[PRGRM040ProgramBillableRate] prg
 WHERE   [Id] = @id
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetProgramBillableRateView]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan             
-- Create date:               09/14/2018      
-- Description:               Get all  Program Billable Rate View
-- Execution:                 EXEC [dbo].[GetProgramBillableRateView]   
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)    
-- Modified Desc:  
-- ============================================= 
ALTER PROCEDURE [dbo].[GetProgramBillableRateView]
 @userId BIGINT,
 @roleId BIGINT,
 @orgId BIGINT,
 @entity NVARCHAR(100),
 @pageNo INT,
 @pageSize INT,
 @orderBy NVARCHAR(500),
 @groupBy NVARCHAR(500), 
 @groupByWhere NVARCHAR(500), 
 @where NVARCHAR(500),
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

SET @TCountQuery = 'SELECT @TotalCount = COUNT(Id) FROM [dbo].[PRGRM040ProgramBillableRate] (NOLOCK) '+ @entity 

--Below for getting user specific 'Statuses'
IF((ISNULL(@where, '') = '') OR (@where NOT LIKE '%'+@entity+'.StatusId%'))
	BEGIN
		SET @TCountQuery = @TCountQuery + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) fgus ON ' + @entity + '.[StatusId] = fgus.[StatusId] '
	END

SET @TCountQuery = @TCountQuery + ' WHERE [PbrPrgrmID] = @parentId ' + ISNULL(@where, '')
EXEC sp_executesql @TCountQuery, N'@parentId BIGINT, @userId BIGINT, @TotalCount INT OUTPUT', @parentId, @userId, @TotalCount  OUTPUT;

IF(@recordId = 0)
	BEGIN
		SET @sqlCommand = 'SELECT ' + [dbo].[fnGetBaseQueryByUserId](@entity, @userId) 
		SET @sqlCommand = @sqlCommand + ' , prg.[PrgProgramTitle] AS PbrPrgrmIDName, vendDcLoc.[VdcLocationTitle] AS PbrVendLocationIDName '
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

SET @sqlCommand = @sqlCommand + ' FROM [dbo].[PRGRM040ProgramBillableRate] (NOLOCK) '+ @entity

--Below to get BIGINT reference key name by Id if NOT NULL
SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[PRGRM000Master] (NOLOCK) prg ON ' + @entity + '.[PbrPrgrmID]=prg.[Id] '
SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[VEND040DCLocations] (NOLOCK) vendDcLoc ON ' + @entity + '.[PbrVendLocationID]=vendDcLoc.[Id] '

--Below for getting user specific 'Statuses'
IF((ISNULL(@where, '') = '') OR (@where NOT LIKE '%'+@entity+'.StatusId%'))
	BEGIN
		SET @sqlCommand = @sqlCommand + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) hfk ON ISNULL(' + @entity + '.[StatusId], 1) = hfk.[StatusId] '
	END

SET @sqlCommand = @sqlCommand + ' WHERE '+@entity+'.[PbrPrgrmID]=@parentId '+ ISNULL(@where, '')

IF((@recordId > 0) AND (((@isNext = 0) AND (@isEnd = 0)) OR ((@isNext = 1) AND (@isEnd = 0))))
	BEGIN
		IF((@isNext = 0) AND (@isEnd = 0))  
   BEGIN  
	IF(ISNULL(@orderBy, '') <> '')
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND ' + @orderBy + ' <= (SELECT ' + @orderBy + ' FROM [dbo].[PRGRM040ProgramBillableRate] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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
		SET @sqlCommand = @sqlCommand + ' AND ' + @orderBy + ' >= (SELECT ' + @orderBy + ' FROM [dbo].[PRGRM040ProgramBillableRate] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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

EXEC sp_executesql @sqlCommand, N'@pageNo INT, @pageSize INT,@orderBy NVARCHAR(500), @where NVARCHAR(500), @parentId BIGINT, @entity NVARCHAR(100),@userId BIGINT' ,
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
/****** Object:  StoredProcedure [dbo].[GetProgramContactsByProgramId]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Janardana             
-- Create date:               02/17/2018      
-- Description:               Get Program Contacts based on organization  
-- Execution:                 EXEC [dbo].[GetProgramContactsByProgramId] 
-- Modified on:  
-- Modified Desc:  
-- =============================================                          
ALTER PROCEDURE [dbo].[GetProgramContactsByProgramId]                  
 @orgId BIGINT = 0 ,                
 @programId BIGINT                  
AS                          
BEGIN TRY                          
            
  SET NOCOUNT ON;  
  
  SELECT cont.Id,  
   cont.ConFullName,  
         cont.ConJobTitle,  
   cont.ConCompany,  
   cont.ConFileAs    
  FROM  CONTC000MASTER cont  
  INNER JOIN PRGRM020Program_Role pr  
  ON cont.Id = pr.[PrgRoleContactID]  
  WHERE pr.ProgramID = @programId  
       AND pr.OrgID=@orgId  
                   
END TRY                          
BEGIN CATCH                          
                           
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                    
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                    
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                    
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                          
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetProgramCopyTreeViewData]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group          
   All Rights Reserved Worldwide */          
-- =============================================                  
-- Author:                    Janardana                       
-- Create date:               14/08/2018                
-- Description:               Get all Customer Program treeview Data under the specified Organization     for copy feature     
-- Execution:                 EXEC [dbo].[GetProgramCopyTreeViewData]          
-- Modified on:            
-- Modified Desc:            
-- =============================================                               
ALTER PROCEDURE[dbo].[GetProgramCopyTreeViewData] --1,0,60,1,2, 1,'Program'  
 @userId BIGINT ,                    
 @isSource BIT = 0,      
 @programId BIGINT = 0,            
 @orgId BIGINT = 0,       
 @parentId BIGINT,            
 @isCustNode BIT = 0 ,       
 @entity NVARCHAR(100) = NULL        
AS                                
BEGIN TRY                                
    
                              
 SET NOCOUNT ON;            
         
  DECLARE @HierarchyID NVARCHAR(100),@HierarchyLevel INT            
      
           
   --GET CUSTOMERS   WHERE ParentId is null            
  IF @parentId IS NULL             
  BEGIN         
  SELECT @HierarchyID = PrgHierarchyID.ToString(),            
         @HierarchyLevel = PrgHierarchyLevel            
   FROM [PRGRM000Master] WHERE Id = @programId;    
         
    SELECT Distinct  c.Id As Id               
      , NULL  As ParentId              
      ,CAST(0 AS VARCHAR)+ '_' +  CAST(c.Id AS VARCHAR) As [Name]                
      ,c.CustCode  As [Text]                
      ,c.CustTitle As ToolTip          
      ,'mail_contact_16x16' As IconCss          
      ,CASE WHEN (@HierarchyLevel = 1 AND @isSource = 0)  THEN CAST(1 AS BIT)     
        ELSE CAST(0 AS BIT) END  As IsLeaf          
     FROM [dbo].[CUST000Master] c            
     LEFT Join PRGRM000Master pm ON c.Id = pm.PrgCustID             
     WHERE c.CustOrgID = @orgId  AND c.StatusId = 1        
     AND pm.Id = CASE @isSource        
                            WHEN 1 THEN @programId        
                            ELSE pm.Id        
                 END         
          
 ;              
  END            
            
  ELSE IF @parentId IS NOT  NULL AND @isCustNode = 1          
  BEGIN            
   
  
  Declare @parentProgramID BIGINT    
  Declare @ance1 NVARCHAR(10)    
  Declare @ance2 NVARCHAR(10)    
    Declare @hLevel INT   
  select @ance1 =  PrgHierarchyID.GetAncestor(1).ToString() , @ance2 = PrgHierarchyID.GetAncestor(2).ToString()
        ,@hLevel = PrgHierarchyLevel
  from PRGRM000Master Where Id = @programId 
              
  IF @ance1 = '/'    
  BEGIN    
      SET @parentProgramID  = @programId    
  END    
  ELSE IF @ance2 = '/'    
  BEGIN    
    SELECT  @parentProgramID  = Id FROM  PRGRM000Master Where PrgHierarchyID.ToString() = @ance1    
  END    
  ELSE    
  BEGIN    
    SELECT  @parentProgramID  = Id FROM  PRGRM000Master Where PrgHierarchyID.ToString() = @ance2    
  END    
    
       SELECT @HierarchyID = PrgHierarchyID.ToString(),            
         @HierarchyLevel = PrgHierarchyLevel            
   FROM [PRGRM000Master] WHERE Id = @parentProgramID;   
  
  
  
    SELECT prg.Id As Id             
           ,cst.Id as ParentId            
           ,CAST(cst.Id AS VARCHAR)+ '_'  +CAST(prg.Id AS VARCHAR)  AS Name              
           ,prg.[PrgProgramCode]  AS [Text]              
     ,prg.[PrgProgramTitle]  AS  ToolTip             
     ,'functionlibrary_morefunctions_16x16' As IconCss        
     --,CASE WHEN  prg.[PrgHierarchyLevel]  <  @hLevel AND  @isSource =0  THEN CAST(1 AS BIT)
	 ,CASE WHEN   @hLevel = 2 AND  @isSource =0  THEN CAST(1 AS BIT)
	  ELSE CAST(0 AS BIT) END  As IsLeaf    
   FROM [dbo].[PRGRM000Master](NOLOCK) prg                
     INNER JOIN CUST000Master cst ON prg.PrgCustID = cst.Id              
   WHERE prg.StatusId = 1 AND prg.[PrgHierarchyLevel] = 1 AND PrgCustID= @parentId        
     AND prg.Id = CASE @isSource        
                            WHEN  1 THEN @parentProgramID        
                            ELSE prg.Id        
                  END       
   ;              
                
            
  END            
  ELSE             
  BEGIN            
   SELECT @HierarchyID = PrgHierarchyID.ToString(),            
         @HierarchyLevel = PrgHierarchyLevel            
   FROM [PRGRM000Master] WHERE Id = @parentId;     
     
   DECLARE @currentHierarchyLevel INT  
   SELECT @currentHierarchyLevel = PrgHierarchyLevel            
   FROM [PRGRM000Master] WHERE Id = @programId;           
     
  
   IF @currentHierarchyLevel > 1  AND @isSource = 1 --AND @programId <> @parentId  
   BEGIN  
        SELECT  @HierarchyID = PrgHierarchyID.GetAncestor(1).ToString() +'%'  FROM [PRGRM000Master] WHERE Id = @programId;  
    
   END    
   ELSE  
   BEGIN  
     SET @HierarchyID =  @HierarchyID+'%' ;  
    
   END   
     
   DECLARE @TreeTable Table  
   (  
      Id BIGINT,  
   ParentId BIGINT NULL,  
   Name NVARCHAR(200) ,  
   [Text] NVARCHAR(200),  
   ToolTip NVARCHAR(200),  
   IconCss NVARCHAR(50),  
   IsLeaf BIT     
   );  
  
  
     
  IF(@isSource = 1 AND @currentHierarchyLevel <= @HierarchyLevel )  
   BEGIN  
     INSERT INTO @TreeTable( Id,ParentId,Name,[Text],ToolTip,IconCss,IsLeaf)  
  
     SELECT Id      
            ,@parentId as ParentId     
            ,'Tab'+ CAST(@parentId AS VARCHAR) +'_'+ CAST(TabTableName AS VARCHAR) AS Name          
            ,TabPageTitle AS [Text]      
            ,TabPageTitle  AS  ToolTip     
            ,NULL AS IconCss           
           ,CAST(1 AS BIT)  As IsLeaf       
    FROM [dbo].[SYSTM030Ref_TabPageName] Where RefTablename = @entity And TabTableName <> @entity   
  
  AND TabTableName NOT IN (    
  select RefTableName from [dbo].[ORGAN021Act_SecurityByRole] Sbr     
    INNER JOIN  [dbo].[ORGAN022Act_SubSecurityByRole] subSbr    
    ON sbr.Id  = subSbr.OrgSecurityByRoleId    
    Where sbr.ContactId =@userId     
    AND sbr.OrgId = @OrgId     
    AND sbr.StatusID =1     
    AND sbr.SecMainModuleId = 12    
    AND subSbr.StatusId =1    
    )  ; 



  
   END       


  
   INSERT INTO @TreeTable( Id,ParentId,Name,[Text],ToolTip,IconCss,IsLeaf)  
     
   SELECT prg.Id As Id             
           ,@parentId as ParentId  
     ,CAST(@parentId AS VARCHAR) + '_' + CAST(prg.Id AS VARCHAR) AS Name               
           ,CASE WHEN @HierarchyLevel  = 1 THEN prg.[PrgProjectCode]           
                 WHEN @HierarchyLevel  = 2 THEN prg.[PrgPhaseCode]  END AS [Text]   
           ,prg.[PrgProgramTitle]  AS  ToolTip             
           ,CASE WHEN @HierarchyLevel  = 1 THEN 'functionlibrary_statistical_16x16'          
                 WHEN @HierarchyLevel  = 2 THEN 'functionlibrary_recentlyuse_16x16'  END AS IconCss   
     --,CASE WHEN @HierarchyLevel = prg.PrgHierarchyLevel AND @isSource =0  THEN CAST(1 AS BIT) 
	 ,CASE WHEN @currentHierarchyLevel > prg.PrgHierarchyLevel AND @isSource =0  THEN CAST(1 AS BIT)         
     ELSE CAST(0 AS BIT) END As IsLeaf      
   FROM [dbo].[PRGRM000Master](NOLOCK) prg                
   INNER JOIN CUST000Master cst ON prg.PrgCustID = cst.Id              
   WHERE prg.StatusId = 1              
        AND prg.PrgHierarchyID.ToString() LIKE @HierarchyID            
        AND prg.PrgHierarchyLevel = (@HierarchyLevel + 1);    
    
  
   
  
   
    
  
   IF EXISTS (SELECT Id FROM @TreeTable WHERE Id = @programId)
   BEGIN
      SELECT Id,ParentId,Name,[Text],ToolTip,IconCss,IsLeaf FROM @TreeTable WHERE Id = @programId  
   END 
   ELSE
   BEGIN
      SELECT Id,ParentId,Name,[Text],ToolTip,IconCss,IsLeaf FROM @TreeTable  
   END
       
              
          
             
              
  END            
              
END TRY                                
BEGIN CATCH                                
                                
  DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                          
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                          
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                          
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                             
                                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetProgramCostRate]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan             
-- Create date:               09/14/2018      
-- Description:               Get a  Program Cost Rate  
-- Execution:                 EXEC [dbo].[GetProgramCostRate] 
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)  
-- Modified Desc:  
-- =============================================
ALTER PROCEDURE  [dbo].[GetProgramCostRate]
    @userId BIGINT,
    @roleId BIGINT,
	@orgId BIGINT,
    @id BIGINT
AS
BEGIN TRY                
 SET NOCOUNT ON;   
  SELECT prg.[Id]
		,prg.[PcrPrgrmID]
		,prg.[PcrCode]
		,prg.[PcrVendorCode]
		,prg.[PcrEffectiveDate]
		,prg.[PcrTitle]
		,prg.[RateCategoryTypeId]
		,prg.[RateTypeId]
		,prg.[PcrCostRate]
		,prg.[RateUnitTypeId]
		,prg.[PcrFormat]
		,prg.[PcrExpression01]
		,prg.[PcrLogic01]
		,prg.[PcrExpression02]
		,prg.[PcrLogic02]
		,prg.[PcrExpression03]
		,prg.[PcrLogic03]
		,prg.[PcrExpression04]
		,prg.[PcrLogic04]
		,prg.[PcrExpression05]
		,prg.[PcrLogic05]
		,prg.[StatusId]
		,prg.[PcrCustomerID]
		,prg.[EnteredBy]
		,prg.[DateEntered]
		,prg.[ChangedBy]
		,prg.[DateChanged]
  FROM   [dbo].[PRGRM041ProgramCostRate] prg
 WHERE   [Id] = @id
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetProgramCostRateView]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan             
-- Create date:               09/14/2018      
-- Description:               Get all  Program Cost Rate View  
-- Execution:                 EXEC [dbo].[GetProgramCostRateView]
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)  
-- Modified Desc:  
-- =============================================
ALTER PROCEDURE [dbo].[GetProgramCostRateView]
 @userId BIGINT,
 @roleId BIGINT,
 @orgId BIGINT,
 @entity NVARCHAR(100),
 @pageNo INT,
 @pageSize INT,
 @orderBy NVARCHAR(500),
 @groupBy NVARCHAR(500), 
 @groupByWhere NVARCHAR(500), 
 @where NVARCHAR(500),
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

SET @TCountQuery = 'SELECT @TotalCount = COUNT(Id) FROM [dbo].[PRGRM041ProgramCostRate] (NOLOCK) '+ @entity 

--Below for getting user specific 'Statuses'
IF((ISNULL(@where, '') = '') OR (@where NOT LIKE '%'+@entity+'.StatusId%'))
	BEGIN
		SET @TCountQuery = @TCountQuery + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) fgus ON ' + @entity + '.[StatusId] = fgus.[StatusId] '
	END

SET @TCountQuery = @TCountQuery + ' WHERE [PcrPrgrmID] = @parentId ' + ISNULL(@where, '')
EXEC sp_executesql @TCountQuery, N'@parentId BIGINT, @userId BIGINT, @TotalCount INT OUTPUT', @parentId, @userId, @TotalCount  OUTPUT;

IF(@recordId = 0)
	BEGIN
		SET @sqlCommand = 'SELECT ' + [dbo].[fnGetBaseQueryByUserId](@entity, @userId) 
		SET @sqlCommand = @sqlCommand + ' , prg.[PrgProgramTitle] AS PcrPrgrmIDName, cust.[CustTitle] AS PcrCustomerIDName '
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

SET @sqlCommand = @sqlCommand + ' FROM [dbo].[PRGRM041ProgramCostRate] (NOLOCK) '+ @entity

--Below to get BIGINT reference key name by Id if NOT NULL
SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[PRGRM000Master] (NOLOCK) prg ON ' + @entity + '.[PcrPrgrmID]=prg.[Id] '
SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[CUST000Master] (NOLOCK) cust ON ' + @entity + '.[PcrCustomerID]=cust.[Id] '

--Below for getting user specific 'Statuses'
IF((ISNULL(@where, '') = '') OR (@where NOT LIKE '%'+@entity+'.StatusId%'))
	BEGIN
		SET @sqlCommand = @sqlCommand + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) hfk ON ISNULL(' + @entity + '.[StatusId], 1) = hfk.[StatusId] '
	END

SET @sqlCommand = @sqlCommand + ' WHERE '+@entity+'.[PcrPrgrmID]=@parentId '+ ISNULL(@where, '') 

IF((@recordId > 0) AND (((@isNext = 0) AND (@isEnd = 0)) OR ((@isNext = 1) AND (@isEnd = 0))))
	BEGIN
		IF((@isNext = 0) AND (@isEnd = 0))  
   BEGIN  
	IF(ISNULL(@orderBy, '') <> '')
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND ' + @orderBy + ' <= (SELECT ' + @orderBy + ' FROM [dbo].[PRGRM041ProgramCostRate] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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
		SET @sqlCommand = @sqlCommand + ' AND ' + @orderBy + ' >= (SELECT ' + @orderBy + ' FROM [dbo].[PRGRM041ProgramCostRate] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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

EXEC sp_executesql @sqlCommand, N'@pageNo INT, @pageSize INT,@orderBy NVARCHAR(500), @where NVARCHAR(500), @parentId BIGINT, @entity NVARCHAR(100),@userId BIGINT' ,
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
/****** Object:  StoredProcedure [dbo].[GetProgramRole]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan             
-- Create date:               09/14/2018      
-- Description:               Get a  Program Role  
-- Execution:                 EXEC [dbo].[GetProgramRole]
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)   
-- Modified Desc:  
-- =============================================
ALTER PROCEDURE  [dbo].[GetProgramRole]
    @userId BIGINT,
    @roleId BIGINT,
	@orgId BIGINT,
    @id BIGINT
AS
BEGIN TRY                
 SET NOCOUNT ON;   
  SELECT prg.[Id]
		,prg.[OrgID]
		,prg.[ProgramID]
		,prg.[PrgRoleSortOrder]
		,prg.[OrgRefRoleId]
		,prg.[PrgRoleId]
		,prg.[PrgRoleTitle]
		,prg.[PrgRoleContactID]
		,prg.[RoleTypeId]
		,prg.[PrgLogical]
		,prg.[JobLogical]
		,prg.[PrxJobDefaultAnalyst]
		,prg.[PrxJobDefaultResponsible]
		,prg.[PrxJobGWDefaultAnalyst]
		,prg.[PrxJobGWDefaultResponsible]
		,prg.[DateEntered]
		,prg.[EnteredBy]
		,prg.[DateChanged]
		,prg.[ChangedBy]
  FROM   [dbo].[PRGRM020Program_Role] prg
 WHERE   [Id] = @id
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetProgramRolesByProgramId]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group    
   All Rights Reserved Worldwide */    
-- =============================================            
-- Author:                    Janardana                 
-- Create date:               01/26/2018          
-- Description:               Get Program Roles by Program Id     
-- Execution:                 EXEC [dbo].[GetProgramRolesByProgramId]    
-- Modified on:      
-- Modified Desc:      
-- =============================================                           
ALTER PROCEDURE [dbo].[GetProgramRolesByProgramId]                            
 --@OrgId BIGINT = 0 ,                  
 --@ProgramId BIGINT      
   
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
 @programId BIGINT =NULL    
                 
AS                            
BEGIN TRY                            

 -- SELECT Id,PrgRoleCode,PrgRoleTitle FROM PRGRM020_Roles (NOLOCK)  WHERE OrgID=1 AND ProgramID = 49          
    
  DECLARE @sqlCommand NVARCHAR(MAX) = ''    
  DECLARE @newPgNo INT    
  IF(ISNULL(@primaryKeyValue, '') <> '')    
  BEGIN   
    SET @sqlCommand += ' SELECT @newPgNo = Item FROM (SELECT ROW_NUMBER() OVER(ORDER BY ' + @entity + '.' + @primaryKeyName+') as Item  ,' +@entity + '.' + @primaryKeyName +     
        ' From PRGRM020_Roles (NOLOCK) ' + @entity + ' WHERE ' + @entity + '.OrgID=  '+CAST( @orgId AS VARCHAR) + ' AND ' + @entity + '.ProgramID =  ' + CAST(@programId  AS VARCHAR) + '   AND ISNULL('+ @entity +'.StatusId, 1) In (1,2)';    
  
    
     
     SET @sqlCommand += ' ) t WHERE t.' + @primaryKeyName + '=' + @primaryKeyValue ;    
   
 EXEC sp_executesql @sqlCommand, N'  @newPgNo int output',@newPgNo output ;  
                                    
    SET @newPgNo =  @newPgNo/@pageSize + 1;     
 SET @pageSize = @newPgNo * @pageSize;    
 SET @sqlCommand='';    
    
     
    
 END    
    
 SET @sqlCommand += 'SELECT '+ @fields +' FROM PRGRM020_Roles (NOLOCK) '+  @entity       
 SET @sqlCommand += ' WHERE ' + @entity + '.OrgID= '+CAST( @orgId AS VARCHAR) + ' AND ' + @entity + '.ProgramID = ' + CAST(@programId  AS VARCHAR) + '  AND ISNULL('+ @entity +'.StatusId, 1) In (1,2)';    
  
    
 IF(ISNULL(@like, '') != '')      
  BEGIN      
  SET @sqlCommand = @sqlCommand + 'AND ('      
   DECLARE @likeStmt NVARCHAR(MAX)      
      
  SELECT @likeStmt = COALESCE(@likeStmt + ' OR ','') + Item + ' LIKE ''%' + @like + '%' + '''' FROM [dbo].[fnSplitString](@fields, ',')        
  SET @sqlCommand = @sqlCommand + @likeStmt + ') '      
  END      
 --IF(ISNULL(@where, '') != '')      
 -- BEGIN      
 --    SET @sqlCommand = @sqlCommand + @where       
 --END      
      
SET @sqlCommand = @sqlCommand + ' ORDER BY '+ @fields +' OFFSET @pageSize * (@pageNo - 1) ROWS FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);'       
  
EXEC sp_executesql @sqlCommand, N'@pageNo INT, @pageSize INT, @where NVARCHAR(100) ' ,      
     @pageNo = @pageNo,       
     @pageSize = @pageSize,
  @where = @where    

     
     
             
                     
END TRY                            
BEGIN CATCH                            
                             
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                      
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                      
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                      
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                            
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetProgramRoleView]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
  
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan             
-- Create date:               09/14/2018      
-- Description:               Get all  Program Role  
-- Execution:                 EXEC [dbo].[GetProgramRoleView]
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)   
-- Modified Desc:  
-- =============================================  
ALTER PROCEDURE [dbo].[GetProgramRoleView]  
 @userId BIGINT,  
 @roleId BIGINT,  
 @orgId BIGINT,  
 @entity NVARCHAR(100),  
 @pageNo INT,  
 @pageSize INT,  
 @orderBy NVARCHAR(500), 
 @groupBy NVARCHAR(500), 
 @groupByWhere NVARCHAR(500),  
 @where NVARCHAR(500),  
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
  
SET @TCountQuery = 'SELECT @TotalCount = COUNT(Id) FROM [dbo].[PRGRM020Program_Role] (NOLOCK) '+ @entity   
  
--Below for getting user specific 'Statuses'  
IF((ISNULL(@where, '') = '') OR (@where NOT LIKE '%'+@entity+'.StatusId%'))  
 BEGIN  
  SET @TCountQuery = @TCountQuery + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) fgus ON ISNULL(' + @entity + '.[StatusId],1) = fgus.[StatusId] '  
 END  
  
SET @TCountQuery = @TCountQuery + ' WHERE [OrgId] = @orgId AND [ProgramID] = @parentId ' + ISNULL(@where, '')  


EXEC sp_executesql @TCountQuery, N'@orgId BIGINT, @parentId BIGINT, @userId BIGINT, @TotalCount INT OUTPUT', @orgId, @parentId, @userId, @TotalCount  OUTPUT;  
  
IF(@recordId = 0)  
 BEGIN  
  SET @sqlCommand = 'SELECT ' + [dbo].[fnGetBaseQueryByUserId](@entity, @userId)   
  SET @sqlCommand = @sqlCommand + ' ,org.[OrgTitle] AS OrgIDName, prg.[PrgProgramTitle] AS ProgramIDName  ,orgrol.[OrgRoleCode] AS OrgRefRoleIdName, prgrol.[PrgRoleCode] AS PrgRoleIdName,cont.ConFullName AS PrgRoleContactIDName'  
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
  
SET @sqlCommand = @sqlCommand + ' FROM [dbo].[PRGRM020Program_Role] (NOLOCK) '+ @entity  
  
--Below to get BIGINT reference key name by Id if NOT NULL  
SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[ORGAN000Master] (NOLOCK) org ON ' + @entity + '.[OrgID]=org.[Id] '  
SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[ORGAN010Ref_Roles] (NOLOCK) orgrol ON ' + @entity + '.[OrgRefRoleId]=orgrol.[Id] ' 
SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[PRGRM020_Roles] (NOLOCK) prgrol ON ' + @entity + '.[PrgRoleId]=prgrol.[Id] ' 
SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[PRGRM000Master] (NOLOCK) prg ON ' + @entity + '.[ProgramID]=prg.[Id] '  
SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[CONTC000Master] (NOLOCK) cont ON ' + @entity + '.[PrgRoleContactID]=cont.[Id] ' 
  
--Below for getting user specific 'Statuses'  
IF((ISNULL(@where, '') = '') OR (@where NOT LIKE '%'+@entity+'.StatusId%'))  
 BEGIN  
  SET @sqlCommand = @sqlCommand + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) hfk ON ISNULL(' + @entity + '.[StatusId], 1) = hfk.[StatusId] '  
 END  
  
SET @sqlCommand = @sqlCommand + ' WHERE '+@entity+'.[OrgId] = @orgId AND '+@entity+'.[ProgramID]=@parentId '+ ISNULL(@where, '')  
  
IF((@recordId > 0) AND (((@isNext = 0) AND (@isEnd = 0)) OR ((@isNext = 1) AND (@isEnd = 0))))  
 BEGIN  
  IF((@isNext = 0) AND (@isEnd = 0))  
   BEGIN  
	IF(ISNULL(@orderBy, '') <> '')
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND ' + @orderBy + ' <= (SELECT ' + @orderBy + ' FROM [dbo].[PRGRM020Program_Role] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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
		SET @sqlCommand = @sqlCommand + ' AND ' + @orderBy + ' >= (SELECT ' + @orderBy + ' FROM [dbo].[PRGRM020Program_Role] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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
  
EXEC sp_executesql @sqlCommand, N'@pageNo INT, @pageSize INT,@orderBy NVARCHAR(500), @where NVARCHAR(500), @orgId BIGINT, @parentId BIGINT, @entity NVARCHAR(100),@userId BIGINT' ,  
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
/****** Object:  StoredProcedure [dbo].[GetProgramTreeView]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan             
-- Create date:               09/14/2018      
-- Description:               Get all Program 
-- Execution:                 EXEC [dbo].[GetProgramTreeView]
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)    
-- Modified Desc:  
-- =============================================
ALTER PROCEDURE [dbo].[GetProgramTreeView]
 @userId BIGINT,
 @roleId BIGINT,
 @orgId BIGINT,
 @entity NVARCHAR(100),
 @pageNo INT,
 @pageSize INT,
 @orderBy NVARCHAR(500),
 @groupBy NVARCHAR(500), 
 @groupByWhere NVARCHAR(500), 
 @where NVARCHAR(500),
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

SET @TCountQuery = 'SELECT @TotalCount = COUNT(Id) FROM [dbo].[PRGRM000Master] (NOLOCK) '+ @entity 

--Below for getting user specific 'Statuses'
IF((ISNULL(@where, '') = '') OR (@where NOT LIKE '%'+@entity+'.StatusId%'))
	BEGIN
		SET @TCountQuery = @TCountQuery + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) fgus ON ' + @entity + '.[StatusId] = fgus.[StatusId] '
	END

SET @TCountQuery = @TCountQuery + ' WHERE [PrgOrgID] = @orgId AND [PrgCustID] = @parentId ' + ISNULL(@where, '')
EXEC sp_executesql @TCountQuery, N'@orgId BIGINT, @parentId BIGINT, @userId BIGINT, @TotalCount INT OUTPUT', @orgId, @parentId, @userId, @TotalCount  OUTPUT;

IF(@recordId = 0)
	BEGIN
		SET @sqlCommand = 'SELECT prg.[Id]
							,prg.[PrgOrgID]
							,prg.[PrgCustID]
							,prg.[PrgHierarchyLevel]
							,prg.[PrgProgramTitle]
							,prg.[StatusId]
							--,refClass.SysOptionName as JobClassification
							--,refPrg.SysOptionName as JobProgramType
							--,refAcc.SysOptionName as JobAccessLevel
							--,refOp.SysOptionName as JobOptionLevel '
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

SET @sqlCommand = @sqlCommand + ' FROM [dbo].[PRGRM000Master] (NOLOCK) prg'

--Below for getting user specific 'Statuses'
IF((ISNULL(@where, '') = '') OR (@where NOT LIKE '%'+@entity+'.StatusId%'))
	BEGIN
		SET @sqlCommand = @sqlCommand + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) hfk ON ISNULL(' + @entity + '.[StatusId], 1) = hfk.[StatusId] '
	END

SET @sqlCommand = @sqlCommand + ' WHERE prg.PrgOrgID=@orgId AND prg.[PrgCustID]=@parentId '+ ISNULL(@where, '')

IF((@recordId > 0) AND (((@isNext = 0) AND (@isEnd = 0)) OR ((@isNext = 1) AND (@isEnd = 0))))
	BEGIN
		IF((@isNext = 0) AND (@isEnd = 0))  
   BEGIN  
	IF(ISNULL(@orderBy, '') <> '')
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND ' + @orderBy + ' <= (SELECT ' + @orderBy + ' FROM [dbo].[PRGRM000Master] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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
		SET @sqlCommand = @sqlCommand + ' AND ' + @orderBy + ' >= (SELECT ' + @orderBy + ' FROM [dbo].[PRGRM000Master] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
	 END
	ELSE
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND '+@entity+'.Id >= '+ CAST(@recordId AS NVARCHAR(50))  
	 END
   END   
	END

SET @sqlCommand = @sqlCommand + ' ORDER BY '+ ISNULL(@orderBy, 'prg.Id') 

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

EXEC sp_executesql @sqlCommand, N'@pageNo INT, @pageSize INT,@orderBy NVARCHAR(500), @where NVARCHAR(500), @orgId BIGINT, @parentId BIGINT,@userId BIGINT' ,
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
/****** Object:  StoredProcedure [dbo].[GetProgramTreeViewData]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Janardana             
-- Create date:               11/02/2018      
-- Description:               Get all Customer Program treeview Data under the specified Organization
-- Execution:                 EXEC [dbo].[GetProgramTreeViewData]
-- Modified on:  
-- Modified Desc:  
-- =============================================                     
ALTER PROCEDURE[dbo].[GetProgramTreeViewData]                
 @orgId BIGINT = 0,  
 @parentId BIGINT,  
 @isCustNode BIT = 0
AS                      
BEGIN TRY                      
      
	  
--	DECLARE   @orgId BIGINT = 1  
--DECLARE @parentId BIGINT = 19  
-- DECLARE @isCustNode BIT = 0
	                   
 SET NOCOUNT ON;  
    
   --INSERT CUSTOMERS   WHERE ParentId is null  
  IF @parentId IS NULL -- AND @model = 'Customer'  
  BEGIN  
    SELECT  c.Id As Id     
     , NULL  As ParentId    
     ,CAST(0 AS VARCHAR)+ '_' +  CAST(c.Id AS VARCHAR) As [Name]      
     ,c.CustCode  As [Text]      
     ,c.CustTitle As ToolTip
	 ,'mail_contact_16x16' As IconCss
	 ,CASE WHEN (SELECT COUNT(Id) FROM [PRGRM000Master] pgm WHERE  pgm.PrgCustID = c.Id AND StatusId = 1 AND PrgHierarchyLevel=1) =  0 THEN CAST(1 AS BIT)
	       ELSE  CAST(0 AS BIT) END As IsLeaf
     FROM [dbo].[CUST000Master] c      
    WHERE c.CustOrgID = @orgId  AND c.StatusId = 1;    
  END  
  
  ELSE IF @parentId IS NOT  NULL AND @isCustNode = 1
  BEGIN  
  
    SELECT prg.Id As Id   
           ,cst.Id as ParentId  
		   ,CAST(cst.Id AS VARCHAR)+ '_'  +CAST(prg.Id AS VARCHAR)  AS Name    
        
        ,prg.[PrgProgramCode]  AS [Text]    
        ,prg.[PrgProgramTitle]  AS  ToolTip   
        ,'functionlibrary_morefunctions_16x16' As IconCss
	   ,CASE WHEN (SELECT COUNT(Id) FROM [PRGRM000Master] pgm WHERE pgm.StatusId = 1 
	                                                          AND pgm.PrgHierarchyLevel = (prg.PrgHierarchyLevel +1) 
															  AND pgm.PrgHierarchyID.ToString() like prg.PrgHierarchyID.ToString()+'%' ) =  0 THEN CAST(1 AS BIT)
	       ELSE  CAST(0 AS BIT) END As IsLeaf
	  
        
   FROM [dbo].[PRGRM000Master](NOLOCK) prg      
     INNER JOIN CUST000Master cst ON prg.PrgCustID = cst.Id    
   WHERE prg.StatusId = 1 AND prg.[PrgHierarchyLevel] = 1 AND PrgCustID= @parentId;    
      
  
  END  
  ELSE   
  BEGIN  
     DECLARE @HierarchyID NVARCHAR(100),@HierarchyLevel INT  
  SELECT @HierarchyID = PrgHierarchyID.ToString(),  
         @HierarchyLevel = PrgHierarchyLevel  
   FROM [PRGRM000Master] WHERE Id = @parentId;  
     
     
    SELECT prg.Id As Id   
           ,@parentId as ParentId
	    --,CAST(cst.Id AS VARCHAR)+ '_' + CAST(prg.Id AS VARCHAR) AS Name  
		  , CAST(@parentId AS VARCHAR) + '_' + CAST(prg.Id AS VARCHAR) AS Name     
		,CASE WHEN @HierarchyLevel  = 1 THEN prg.[PrgProjectCode] 
		      WHEN @HierarchyLevel  = 2 THEN prg.[PrgPhaseCode]  END AS [Text]    
    --,prg.[PrgProgramCode]  AS [Text]    
    ,prg.[PrgProgramTitle]  AS  ToolTip   
    ,CASE WHEN @HierarchyLevel  = 1 THEN 'functionlibrary_statistical_16x16'
		      WHEN @HierarchyLevel  = 2 THEN 'functionlibrary_recentlyuse_16x16'  END AS IconCss    
	,CASE WHEN (SELECT COUNT(Id) FROM [PRGRM000Master] pgm WHERE pgm.StatusId = 1 
	                                                          AND pgm.PrgHierarchyLevel = (prg.PrgHierarchyLevel +1) 
															  AND pgm.PrgHierarchyID.ToString() like prg.PrgHierarchyID.ToString()+'%' ) =  0 THEN CAST(1 AS BIT)
	       ELSE  CAST(0 AS BIT) END As IsLeaf  
        
   FROM [dbo].[PRGRM000Master](NOLOCK) prg      
     INNER JOIN CUST000Master cst ON prg.PrgCustID = cst.Id    
   WHERE prg.StatusId = 1    
        AND prg.PrgHierarchyID.ToString() LIKE @HierarchyID+'%'   
     AND prg.PrgHierarchyLevel = (@HierarchyLevel + 1);    
    
  END  
    
END TRY                      
BEGIN CATCH                      
                      
  DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                   
                      
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetRefLookup]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Janardana             
-- Create date:               08/16/2018      
-- Description:               Get a Reference Lookup
-- Execution:                 EXEC [dbo].[GetRefLookup]
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)   
-- Modified Desc:  
-- =============================================         
ALTER PROCEDURE  [dbo].[GetRefLookup]        
    @userId BIGINT,        
    @roleId BIGINT,        
 @orgId BIGINT ,      
 @referenceType NVARCHAR(25)      
AS        
BEGIN TRY                        
 SET NOCOUNT ON;       
       
 IF @referenceType = 'Global'      
 BEGIN      
     SELECT LkupCode,LkupTableName FROM [dbo].[SYSTM000Ref_Lookup] WHERE LkupTableName=@referenceType;      
 END      
 ELSE IF @referenceType = 'Entity'      
 BEGIN      
     SELECT LkupCode,LkupTableName FROM [dbo].[SYSTM000Ref_Lookup] --WHERE TableName = 'Global' ;      
 END     
 ELSE      
 BEGIN      
        SELECT LkupCode,LkupTableName FROM [dbo].[SYSTM000Ref_Lookup]      
 END      
           
          
        
END TRY                        
BEGIN CATCH                        
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                        
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                        
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                        
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                        
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetRefRoleLogicals]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Janardana Behara
-- Create date:               06/14/2018      
-- Description:               Get a  Active Role Logicals
-- Execution:                 EXEC [dbo].[GetRefRoleLogicals]
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)   
-- Modified Desc:  
-- =============================================
ALTER PROCEDURE  [dbo].[GetRefRoleLogicals]
    @userId BIGINT,
    @roleId BIGINT,
	@orgId BIGINT,
    @id BIGINT
AS
BEGIN TRY                
 SET NOCOUNT ON;   
  SELECT ref.[Id]
		,ref.[PrgLogical]
		,ref.[PrxJobDefaultAnalyst]
		,ref.[PrxJobDefaultResponsible]
		,ref.[PrxJobGWDefaultAnalyst]
		,ref.[PrxJobGWDefaultResponsible]
  FROM  [dbo].[ORGAN010Ref_Roles] ref
 WHERE   [Id] = @id
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetRefRolesByProgramId]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================                          
/* Copyright (2018) Meridian Worldwide Transportation Group  
   All Rights Reserved Worldwide */  
-- =============================================          
-- Author:                    Janardana           
-- Create date:               07/06/2018        
-- Description:               Get Organization RefRoles based on organization   
-- Execution:                 EXEC [dbo].[GetRefRolesByProgramId]     
-- Modified on:    
-- Modified Desc:    
-- =============================================                         
ALTER PROCEDURE [dbo].[GetRefRolesByProgramId]                
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
 @programId BIGINT =NULL
             
AS                          
BEGIN TRY                          
   
  DECLARE @ProgramLevel INT          
  SELECT  @ProgramLevel = PrgHierarchyLevel  from [dbo].[PRGRM000Master] (NOLOCK) WHERE  Id= @programId AND PrgOrgID = @orgId;          
  
    DECLARE @sqlCommand NVARCHAR(MAX) = ''
   DECLARE @newPgNo INT
  IF(ISNULL(@primaryKeyValue, '') <> '')
  BEGIN

 
	SET @sqlCommand += ' SELECT @newPgNo = Item FROM (SELECT ROW_NUMBER() OVER(ORDER BY ' + @entity + '.' + @primaryKeyName+') as Item  ,' +@entity + '.' + @primaryKeyName + 
					   ' From ORGAN010Ref_Roles (NOLOCK) ' + @entity;
    
    SET @sqlCommand += ' LEFT JOIN ORGAN020Act_Roles actRole ON ' + @entity + '.Id=actRole.[OrgRefRoleId] AND actRole.[OrgID]=' + CAST(@orgId AS NVARCHAR(50)) + ' AND ISNULL(actRole.StatusId, 1) In (1,2) ' 


	IF  COL_LENGTH('ORGAN010Ref_Roles', 'StatusId') IS NOT NULL
	 BEGIN  
	    SET @sqlCommand = @sqlCommand + ' WHERE ISNULL('+ @entity +'.StatusId, 1) In (1,2)';
	 END

 --For RefRole
 SET @sqlCommand += ' AND ((((' + @entity + '.PrgLogical=1 OR ' + @entity + '.PrjLogical=1 OR ' + @entity + '.PhsLogical=1) AND '+CAST(@ProgramLevel AS VARCHAR)+' =1)  '  
 SET @sqlCommand += ' OR   ((' + @entity + '.PrjLogical=1 OR ' + @entity + '.PhsLogical=1 ) AND '+CAST(@ProgramLevel AS VARCHAR)+' =2)  '  
 SET @sqlCommand += ' OR   (' + @entity + '.PhsLogical=1 AND '+CAST(@ProgramLevel AS VARCHAR)+' =3)) '  

 --For ActRole
 SET @sqlCommand += ' OR (((actRole.PrgLogical=1 OR actRole.PrjLogical=1 OR actRole.PhsLogical=1) AND '+CAST(@ProgramLevel AS VARCHAR)+' =1)  '  
 SET @sqlCommand += ' OR   ((actRole.PrjLogical=1 OR actRole.PhsLogical=1 )AND '+CAST(@ProgramLevel AS VARCHAR)+' =2)  '  
 SET @sqlCommand += ' OR   (actRole.PhsLogical=1 AND '+CAST(@ProgramLevel AS VARCHAR)+' =3))) '  

	SET @sqlCommand += ' ) t WHERE t.' + @primaryKeyName + '=' + @primaryKeyValue;
		 
	EXEC sp_executesql @sqlCommand, N' @newPgNo int output',@newPgNo output                                    
    SET @newPgNo =  @newPgNo/@pageSize + 1; 
	SET @pageSize = @newPgNo * @pageSize;
	SET @sqlCommand='';

	

 END

 SET @sqlCommand += 'SELECT DISTINCT '+ @fields +' FROM ORGAN010Ref_Roles (NOLOCK) ' + @entity
 SET @sqlCommand += ' LEFT JOIN ORGAN020Act_Roles actRole ON ' + @entity + '.Id=actRole.[OrgRefRoleId] AND actRole.[OrgID]=' + CAST(@orgId AS NVARCHAR(50)) + ' AND ISNULL(actRole.StatusId, 1) In (1,2) ' 
 
 --For RefRole
 SET @sqlCommand += ' WHERE 1=1 AND ((((' + @entity + '.PrgLogical=1 OR ' + @entity + '.PrjLogical=1 OR ' + @entity + '.PhsLogical=1) AND '+CAST(@ProgramLevel AS VARCHAR)+' =1)  '  
 SET @sqlCommand += ' OR   ((' + @entity + '.PrjLogical=1 OR ' + @entity + '.PhsLogical=1 )AND '+CAST(@ProgramLevel AS VARCHAR)+' =2)  '  
 SET @sqlCommand += ' OR   (' + @entity + '.PhsLogical=1 AND '+CAST(@ProgramLevel AS VARCHAR)+' =3)) '  

 --For ActRole
 SET @sqlCommand += ' OR (((actRole.PrgLogical=1 OR actRole.PrjLogical=1 OR actRole.PhsLogical=1) AND '+CAST(@ProgramLevel AS VARCHAR)+' =1)  '  
 SET @sqlCommand += ' OR   ((actRole.PrjLogical=1 OR actRole.PhsLogical=1 )AND '+CAST(@ProgramLevel AS VARCHAR)+' =2)  '  
 SET @sqlCommand += ' OR   (actRole.PhsLogical=1 AND '+CAST(@ProgramLevel AS VARCHAR)+' =3))) '  

 IF  COL_LENGTH('ORGAN010Ref_Roles', 'StatusId') IS NOT NULL
 BEGIN  
    SET @sqlCommand = @sqlCommand + ' AND ISNULL(' + @entity + '.StatusId, 1) In (1,2)';
 END

 IF(ISNULL(@like, '') != '')  
  BEGIN  
  SET @sqlCommand = @sqlCommand + 'AND ('  
   DECLARE @likeStmt NVARCHAR(MAX)  
  
  SELECT @likeStmt = COALESCE(@likeStmt + ' OR ','') + Item + ' LIKE ''%' + @like + '%' + '''' FROM [dbo].[fnSplitString](@fields, ',')    
  SET @sqlCommand = @sqlCommand + @likeStmt + ') '  
  END  
 
  
SET @sqlCommand = @sqlCommand + ' ORDER BY '+ @fields +' OFFSET @pageSize * (@pageNo - 1) ROWS FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);'   
 
EXEC sp_executesql @sqlCommand, N'@pageNo INT, @pageSize INT, @where NVARCHAR(100)' ,  
     @pageNo = @pageNo,   
     @pageSize = @pageSize,  
     @where = @where
         
                   
END TRY                          
BEGIN CATCH                          
                           
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                    
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                    
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                    
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                          
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetRefRoleSecurities]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/* Copyright (2018) Meridian Worldwide Transportation Group
  All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               05/08/2018      
-- Description:               Get user securities  
-- Execution:                 EXEC [dbo].[GetRefRoleSecurities]   
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)   
-- Modified Desc:  
-- =============================================   
ALTER PROCEDURE  [dbo].[GetRefRoleSecurities]     
@userId BIGINT,    
@orgId BIGINT,    
@roleId BIGINT    
AS    
BEGIN TRY                    
SET NOCOUNT ON;  

 SELECT refRole.Id    
  ,refRole.[SecMainModuleId]    
  ,refRole.[SecMenuOptionLevelId]    
  ,refRole.[SecMenuAccessLevelId]    
FROM [dbo].[SYSTM000SecurityByRole] (NOLOCK) refRole  
WHERE refRole.OrgRefRoleId = @roleId  AND (ISNULL(refRole.StatusId, 1) =1)  
END TRY                    
BEGIN CATCH                    
DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                    
  ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                    
  ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                    
    
EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                    
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetReport]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan             
-- Create date:               12/01/2018      
-- Description:               Get a report By Id
-- Execution:                 EXEC [dbo].[GetReport]
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)   
-- Modified Desc:  
-- =============================================    
ALTER PROCEDURE [dbo].[GetReport]    
 @userId BIGINT,    
 @roleId BIGINT,    
 @orgId BIGINT,    
 @langCode NVARCHAR(10),    
 @id BIGINT    
AS    
BEGIN TRY                    
 SET NOCOUNT ON;       
 SELECT rep.[Id]  
      ,rep.[OrganizationId]  
      ,rep.[RprtMainModuleId]  
      ,rep.[RprtName]  
      ,rep.[RprtIsDefault]  
      ,rep.[StatusId]
      ,rep.[DateEntered]  
      ,rep.[EnteredBy]  
      ,rep.[DateChanged]  
      ,rep.[ChangedBy]   
 FROM [dbo].[SYSTM000Ref_Report] (NOLOCK) rep    
 WHERE rep.[OrganizationId] = @orgId     
 AND rep.Id=@id    
END TRY                    
BEGIN CATCH                    
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                    
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                    
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                    
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                    
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetReportView]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan             
-- Create date:               12/01/2018      
-- Description:               Get all Reports
-- Execution:                 EXEC [dbo].[GetReportView]
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)   
-- Modified Desc:  
-- =============================================
ALTER PROCEDURE [dbo].[GetReportView]
	@userId INT,
	@roleId BIGINT,
	@orgId BIGINT,
  	@langCode NVARCHAR(10),
	@entity NVARCHAR(100),
	@pageNo INT,
	@pageSize INT,
	@orderBy NVARCHAR(500),
	@groupBy NVARCHAR(500), 
	@groupByWhere NVARCHAR(500), 
	@where NVARCHAR(500),
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

	SET @TCountQuery = 'SELECT @TotalCount = COUNT(Id) FROM [dbo].[SYSTM000Ref_Report] (NOLOCK) '+ @entity +' WHERE [OrganizationId] = @orgId ' + ISNULL(@where, '')
	EXEC sp_executesql @TCountQuery, N'@orgId BIGINT, @TotalCount INT OUTPUT',@orgId ,@TotalCount  OUTPUT;
	
	IF(@recordId = 0)
	BEGIN
		SET @sqlCommand = 'SELECT ' + [dbo].[fnGetBaseQueryByUserId](@entity, @userId) 
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

	SET @sqlCommand = @sqlCommand + ' FROM [dbo].[SYSTM000Ref_Report] (NOLOCK) '+ @entity

	SET @sqlCommand = @sqlCommand + ' WHERE '+@entity+'.[OrganizationId] = @orgId '+ ISNULL(@where, '')
	
	IF((@recordId > 0) AND (((@isNext = 0) AND (@isEnd = 0)) OR ((@isNext = 1) AND (@isEnd = 0))))
	BEGIN
		IF((@isNext = 0) AND (@isEnd = 0))  
   BEGIN  
	IF(ISNULL(@orderBy, '') <> '')
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND ' + @orderBy + ' <= (SELECT ' + @orderBy + ' FROM [dbo].[SYSTM000Ref_Report] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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
		SET @sqlCommand = @sqlCommand + ' AND ' + @orderBy + ' >= (SELECT ' + @orderBy + ' FROM [dbo].[SYSTM000Ref_Report] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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

	EXEC sp_executesql @sqlCommand, N'@pageNo INT, @pageSize INT, @orgId BIGINT, @entity NVARCHAR(100), @orderBy NVARCHAR(500), @where NVARCHAR(500)' ,
					@orgId= @orgId,
					@entity= @entity,
					@pageNo= @pageNo, 
					@pageSize= @pageSize,
					@orderBy = @orderBy,
					@where = @where
	
END TRY                
BEGIN CATCH                
	DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
			,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
			,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
	EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetRibbonMenus]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan             
-- Create date:               12/23/2018      
-- Description:               Get default Ribbon
-- Execution:                 EXEC [dbo].[GetRibbonMenus]
-- Modified on:  
-- Modified Desc:  
-- ============================================= 
ALTER PROCEDURE [dbo].[GetRibbonMenus]
    @langCode NVARCHAR(10) 
AS  
BEGIN TRY    
 SET NOCOUNT ON;     
 SELECT mnu.Id  
		,mnu.[MnuModuleId] 
		,mnu.[MnuTableName] 
		,mnu.[MnuTitle]
		,mnu.[MnuBreakDownStructure]
		,mnu.[MnuTabOver]
		,mnu.[MnuIconVerySmall] 
		,mnu.[MnuIconMedium]
		,mnu.[MnuExecuteProgram] 
		,mnu.[MnuAccessLevelId]
		,mnu.[StatusId]
 FROM [dbo].[SYSTM000MenuDriver] (NOLOCK) mnu  
 WHERE mnu.[LangCode] = @langCode AND (mnu.MnuModuleId IS NULL OR  mnu.MnuModuleId < 1) AND (ISNULL(mnu.StatusId, 1) < 3)  
 ORDER BY mnu.[MnuBreakDownStructure]  
END TRY                  
BEGIN CATCH                  
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                  
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                  
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                  
   
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                  
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetScnCargo]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               08/16/2018      
-- Description:               Get a ScnCargo
-- Execution:                 EXEC [dbo].[GetScnCargo]
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)    
-- Modified Desc:  
-- ============================================= 
ALTER PROCEDURE  [dbo].[GetScnCargo]
    @userId BIGINT,
    @roleId BIGINT,
	@orgId BIGINT,
    @id BIGINT
AS
BEGIN TRY                
 SET NOCOUNT ON;   
  SELECT scn.[CargoID]
		,scn.[JobID]
		,scn.[CgoLineItem]
		,scn.[CgoPartNumCode]
		,scn.[CgoQtyOrdered]
		,scn.[CgoQtyExpected]
		,scn.[CgoQtyCounted]
		,scn.[CgoQtyDamaged]
		,scn.[CgoQtyOnHold]
		,scn.[CgoQtyShort]
		,scn.[CgoQtyOver]
		,scn.[CgoQtyUnits]
		,scn.[CgoStatus]
		,scn.[CgoInfoID]
		,scn.[ColorCD]
		,scn.[CgoSerialCD]
		,scn.[CgoLong]
		,scn.[CgoLat]
		,scn.[CgoProFlag01]
		,scn.[CgoProFlag02]
		,scn.[CgoProFlag03]
		,scn.[CgoProFlag04]
		,scn.[CgoProFlag05]
		,scn.[CgoProFlag06]
		,scn.[CgoProFlag07]
		,scn.[CgoProFlag08]
		,scn.[CgoProFlag09]
		,scn.[CgoProFlag10]
		,scn.[CgoProFlag11]
		,scn.[CgoProFlag12]
		,scn.[CgoProFlag13]
		,scn.[CgoProFlag14]
		,scn.[CgoProFlag15]
		,scn.[CgoProFlag16]
		,scn.[CgoProFlag17]
		,scn.[CgoProFlag18]
		,scn.[CgoProFlag19]
		,scn.[CgoProFlag20]
  FROM [dbo].[SCN005Cargo] scn
 WHERE scn.[CargoID] = @id
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetScnCargoDetail]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               08/16/2018      
-- Description:               Get a ScnCargoDetail
-- Execution:                 EXEC [dbo].[GetScnCargoDetail]
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)   
-- Modified Desc:  
-- ============================================= 
ALTER PROCEDURE  [dbo].[GetScnCargoDetail]
    @userId BIGINT,
    @roleId BIGINT,
	@orgId BIGINT,
    @id BIGINT
AS
BEGIN TRY                
 SET NOCOUNT ON;   
  SELECT scn.[CargoDetailID]
        ,scn.[CargoID]
        ,scn.[DetSerialNumber]
        ,scn.[DetQtyCounted]
        ,scn.[DetQtyDamaged]
        ,scn.[DetQtyShort]
        ,scn.[DetQtyOver]
        ,scn.[DetPickStatus]
        ,scn.[DetLong]
        ,scn.[DetLat]
  FROM [dbo].[SCN006CargoDetail] scn
 WHERE scn.[CargoDetailID] = @id
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetScnCargoDetailView]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               10/29/2018      
-- Description:               Get all ScnCargoDetail  
-- Execution:                 EXEC [dbo].[GetScnCargoDetailView]   
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)    
-- Modified Desc:  
-- ============================================= 
ALTER PROCEDURE [dbo].[GetScnCargoDetailView]
 @userId BIGINT,
 @roleId BIGINT,
 @orgId BIGINT,
 @entity NVARCHAR(100),
 @pageNo INT,
 @pageSize INT,
 @orderBy NVARCHAR(500),
 @groupBy NVARCHAR(500), 
 @groupByWhere NVARCHAR(500), 
 @where NVARCHAR(500),
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

SET @TCountQuery = 'SELECT @TotalCount = COUNT(' + @entity + '.Id) FROM [dbo].[SCN006CargoDetail] (NOLOCK) '+ @entity
SET @TCountQuery = 	@TCountQuery  +' WHERE 1=1 '+ ISNULL(@where, '')
EXEC sp_executesql @TCountQuery, N'@orgId BIGINT, @userId BIGINT, @parentId BIGINT, @TotalCount INT OUTPUT', @orgId, @userId, @parentId, @TotalCount  OUTPUT;


IF(@recordId = 0)
	BEGIN
		SET @sqlCommand = 'SELECT ' + [dbo].[fnGetBaseQueryByUserId](@entity, @userId)
	END
ELSE
	BEGIN
		IF((@isNext = 0) AND (@isEnd = 0))
			BEGIN
				 SET @sqlCommand = 'SELECT TOP 1 ISNULL(LAG(' + @entity + '.CargoDetailID) OVER (ORDER BY ' + ISNULL(@orderBy, @entity + '.CargoDetailID') + '), 0) AS CargoDetailID '
			END
		ELSE IF((@isNext = 1) AND (@isEnd = 0))
			BEGIN
				 SET @sqlCommand = 'SELECT TOP 1 ISNULL(LEAD(' + @entity + '.CargoDetailID) OVER (ORDER BY ' + ISNULL(@orderBy, @entity + '.CargoDetailID') + '), 0) AS CargoDetailID ' 
			END
		ELSE
			BEGIN
				SET @sqlCommand = 'SELECT TOP 1 ' + @entity + '.CargoDetailID '
			END
	END

SET @sqlCommand = @sqlCommand + ' FROM [dbo].[SCN006CargoDetail] (NOLOCK) '+ @entity

SET @sqlCommand = @sqlCommand + ' WHERE 1 = 1 '+ ISNULL(@where, '')

IF((@recordId > 0) AND (((@isNext = 0) AND (@isEnd = 0)) OR ((@isNext = 1) AND (@isEnd = 0))))
	BEGIN
		IF((@isNext = 0) AND (@isEnd = 0))  
   BEGIN  
	IF(ISNULL(@orderBy, '') <> '')
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND ' + @orderBy + ' <= (SELECT ' + @orderBy + ' FROM [dbo].[SCN006CargoDetail] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.CargoDetailID=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
	 END
	ELSE
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND '+@entity+'.CargoDetailID <= '+ CAST(@recordId AS NVARCHAR(50))  
	 END
   END  
  ELSE IF((@isNext = 1) AND (@isEnd = 0))  
   BEGIN  
    IF(ISNULL(@orderBy, '') <> '')
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND ' + @orderBy + ' >= (SELECT ' + @orderBy + ' FROM [dbo].[SCN006CargoDetail] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.CargoDetailID=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
	 END
	ELSE
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND '+@entity+'.CargoDetailID >= '+ CAST(@recordId AS NVARCHAR(50))  
	 END
   END   
	END

SET @sqlCommand = @sqlCommand + ISNULL(@where, '') + ' ORDER BY '+ ISNULL(@orderBy, @entity+'.CargoDetailID')

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

EXEC sp_executesql @sqlCommand, N'@pageNo INT, @pageSize INT, @entity NVARCHAR(100), @orderBy NVARCHAR(500), @where NVARCHAR(500), @orgId BIGINT,@userId BIGINT, @parentId BIGINT' ,
	 @entity= @entity,
     @pageNo= @pageNo, 
     @pageSize= @pageSize,
     @orderBy = @orderBy,
     @where = @where,
	 @orgId = @orgId,
	 @userId = @userId,
	 @parentId = @parentId
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetScnCargoView]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               10/29/2018      
-- Description:               Get all ScnCargo
-- Execution:                 EXEC [dbo].[GetScnCargoView]   
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)    
-- Modified Desc:  
-- ============================================= 
ALTER PROCEDURE [dbo].[GetScnCargoView]
 @userId BIGINT,
 @roleId BIGINT,
 @orgId BIGINT,
 @entity NVARCHAR(100),
 @pageNo INT,
 @pageSize INT,
 @orderBy NVARCHAR(500),
 @groupBy NVARCHAR(500), 
 @groupByWhere NVARCHAR(500), 
 @where NVARCHAR(500),
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

SET @TCountQuery = 'SELECT @TotalCount = COUNT(' + @entity + '.Id) FROM [dbo].[SCN005Cargo] (NOLOCK) '+ @entity
SET @TCountQuery = 	@TCountQuery  +' WHERE 1=1 '+ ISNULL(@where, '')
EXEC sp_executesql @TCountQuery, N'@orgId BIGINT, @userId BIGINT, @parentId BIGINT, @TotalCount INT OUTPUT', @orgId, @userId, @parentId, @TotalCount  OUTPUT;


IF(@recordId = 0)
	BEGIN
		SET @sqlCommand = 'SELECT ' + [dbo].[fnGetBaseQueryByUserId](@entity, @userId)
	END
ELSE
	BEGIN
		IF((@isNext = 0) AND (@isEnd = 0))
			BEGIN
				 SET @sqlCommand = 'SELECT TOP 1 ISNULL(LAG(' + @entity + '.CargoID) OVER (ORDER BY ' + ISNULL(@orderBy, @entity + '.CargoID') + '), 0) AS CargoID '
			END
		ELSE IF((@isNext = 1) AND (@isEnd = 0))
			BEGIN
				 SET @sqlCommand = 'SELECT TOP 1 ISNULL(LEAD(' + @entity + '.CargoID) OVER (ORDER BY ' + ISNULL(@orderBy, @entity + '.CargoID') + '), 0) AS CargoID ' 
			END
		ELSE
			BEGIN
				SET @sqlCommand = 'SELECT TOP 1 ' + @entity + '.CargoID '
			END
	END

SET @sqlCommand = @sqlCommand + ' FROM [dbo].[SCN005Cargo] (NOLOCK) '+ @entity

SET @sqlCommand = @sqlCommand + ' WHERE 1 = 1 '+ ISNULL(@where, '')

IF((@recordId > 0) AND (((@isNext = 0) AND (@isEnd = 0)) OR ((@isNext = 1) AND (@isEnd = 0))))
	BEGIN
		IF((@isNext = 0) AND (@isEnd = 0))  
   BEGIN  
	IF(ISNULL(@orderBy, '') <> '')
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND ' + @orderBy + ' <= (SELECT ' + @orderBy + ' FROM [dbo].[SCN005Cargo] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.CargoID=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
	 END
	ELSE
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND '+@entity+'.CargoID <= '+ CAST(@recordId AS NVARCHAR(50))  
	 END
   END  
  ELSE IF((@isNext = 1) AND (@isEnd = 0))  
   BEGIN  
    IF(ISNULL(@orderBy, '') <> '')
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND ' + @orderBy + ' >= (SELECT ' + @orderBy + ' FROM [dbo].[SCN005Cargo] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.CargoID=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
	 END
	ELSE
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND '+@entity+'.CargoID >= '+ CAST(@recordId AS NVARCHAR(50))  
	 END
   END   
	END

SET @sqlCommand = @sqlCommand + ISNULL(@where, '') + ' ORDER BY '+ ISNULL(@orderBy, @entity+'.CargoID')

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

EXEC sp_executesql @sqlCommand, N'@pageNo INT, @pageSize INT, @entity NVARCHAR(100), @orderBy NVARCHAR(500), @where NVARCHAR(500), @orgId BIGINT,@userId BIGINT, @parentId BIGINT' ,
	 @entity= @entity,
     @pageNo= @pageNo, 
     @pageSize= @pageSize,
     @orderBy = @orderBy,
     @where = @where,
	 @orgId = @orgId,
	 @userId = @userId,
	 @parentId = @parentId
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetScnDriverList]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               08/16/2018      
-- Description:               Get a ScnDriverList
-- Execution:                 EXEC [dbo].[GetScnDriverList]
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)    
-- Modified Desc:  
-- ============================================= 
ALTER PROCEDURE  [dbo].[GetScnDriverList]
    @userId BIGINT,
    @roleId BIGINT,
	@orgId BIGINT,
    @id BIGINT
AS
BEGIN TRY                
 SET NOCOUNT ON;   
  SELECT scn.[DriverID]
        ,scn.[FirstName]
        ,scn.[LastName]
        ,scn.[ProgramID]
        ,scn.[LocationNumber]
  FROM [dbo].[SCN016DriverList] scn
 WHERE scn.[DriverID] = @id
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetScnDriverListView]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               10/29/2018      
-- Description:               Get all ScnDriverList  
-- Execution:                 EXEC [dbo].[GetScnDriverListView]   
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)   
-- Modified Desc:  
-- ============================================= 
ALTER PROCEDURE [dbo].[GetScnDriverListView]
 @userId BIGINT,
 @roleId BIGINT,
 @orgId BIGINT,
 @entity NVARCHAR(100),
 @pageNo INT,
 @pageSize INT,
 @orderBy NVARCHAR(500),
 @groupBy NVARCHAR(500), 
 @groupByWhere NVARCHAR(500), 
 @where NVARCHAR(500),
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

SET @TCountQuery = 'SELECT @TotalCount = COUNT(' + @entity + '.Id) FROM [dbo].[SCN016DriverList] (NOLOCK) '+ @entity
SET @TCountQuery = 	@TCountQuery  +' WHERE 1=1 '+ ISNULL(@where, '')
EXEC sp_executesql @TCountQuery, N'@orgId BIGINT, @userId BIGINT, @parentId BIGINT, @TotalCount INT OUTPUT', @orgId, @userId, @parentId, @TotalCount  OUTPUT;


IF(@recordId = 0)
	BEGIN
		SET @sqlCommand = 'SELECT ' + [dbo].[fnGetBaseQueryByUserId](@entity, @userId)
	END
ELSE
	BEGIN
		IF((@isNext = 0) AND (@isEnd = 0))
			BEGIN
				 SET @sqlCommand = 'SELECT TOP 1 ISNULL(LAG(' + @entity + '.DriverID) OVER (ORDER BY ' + ISNULL(@orderBy, @entity + '.DriverID') + '), 0) AS DriverID '
			END
		ELSE IF((@isNext = 1) AND (@isEnd = 0))
			BEGIN
				 SET @sqlCommand = 'SELECT TOP 1 ISNULL(LEAD(' + @entity + '.DriverID) OVER (ORDER BY ' + ISNULL(@orderBy, @entity + '.DriverID') + '), 0) AS DriverID ' 
			END
		ELSE
			BEGIN
				SET @sqlCommand = 'SELECT TOP 1 ' + @entity + '.DriverID '
			END
	END

SET @sqlCommand = @sqlCommand + ' FROM [dbo].[SCN016DriverList] (NOLOCK) '+ @entity

SET @sqlCommand = @sqlCommand + ' WHERE 1 = 1 '+ ISNULL(@where, '')

IF((@recordId > 0) AND (((@isNext = 0) AND (@isEnd = 0)) OR ((@isNext = 1) AND (@isEnd = 0))))
	BEGIN
		IF((@isNext = 0) AND (@isEnd = 0))  
   BEGIN  
	IF(ISNULL(@orderBy, '') <> '')
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND ' + @orderBy + ' <= (SELECT ' + @orderBy + ' FROM [dbo].[SCN016DriverList] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.DriverID=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
	 END
	ELSE
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND '+@entity+'.DriverID <= '+ CAST(@recordId AS NVARCHAR(50))  
	 END
   END  
  ELSE IF((@isNext = 1) AND (@isEnd = 0))  
   BEGIN  
    IF(ISNULL(@orderBy, '') <> '')
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND ' + @orderBy + ' >= (SELECT ' + @orderBy + ' FROM [dbo].[SCN016DriverList] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.DriverID=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
	 END
	ELSE
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND '+@entity+'.DriverID >= '+ CAST(@recordId AS NVARCHAR(50))  
	 END
   END   
	END

SET @sqlCommand = @sqlCommand + ISNULL(@where, '') + ' ORDER BY '+ ISNULL(@orderBy, @entity+'.DriverID')

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

EXEC sp_executesql @sqlCommand, N'@pageNo INT, @pageSize INT, @entity NVARCHAR(100), @orderBy NVARCHAR(500), @where NVARCHAR(500), @orgId BIGINT,@userId BIGINT, @parentId BIGINT' ,
	 @entity= @entity,
     @pageNo= @pageNo, 
     @pageSize= @pageSize,
     @orderBy = @orderBy,
     @where = @where,
	 @orgId = @orgId,
	 @userId = @userId,
	 @parentId = @parentId
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetScnOrder]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               08/16/2018      
-- Description:               Get a ScnOrder
-- Execution:                 EXEC [dbo].[GetScnOrder]
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)    
-- Modified Desc:  
-- ============================================= 
ALTER PROCEDURE  [dbo].[GetScnOrder]
    @userId BIGINT,
    @roleId BIGINT,
	@orgId BIGINT,
    @id BIGINT
AS
BEGIN TRY                
 SET NOCOUNT ON;   
  SELECT scn.[JobID]
		,scn.[ProgramID]
		,scn.[RouteID]
		,scn.[DriverID]
		,scn.[JobDeviceID]
		,scn.[JobStop]
		,scn.[JobOrderID]
		,scn.[JobManifestID]
		,scn.[JobCarrierID]
		,scn.[JobReturnReasonID]
		,scn.[JobStatusCD]
		,scn.[JobOriginSiteCode]
		,scn.[JobOriginSiteName]
		,scn.[JobDeliverySitePOC]
		,scn.[JobDeliverySitePOC2]
		,scn.[JobDeliveryStreetAddress]
		,scn.[JobDeliveryStreetAddress2]
		,scn.[JobDeliveryCity]
		,scn.[JobDeliveryStateProvince]
		,scn.[JobDeliveryPostalCode]
		,scn.[JobDeliveryCountry]
		,scn.[JobDeliverySitePOCPhone]
		,scn.[JobDeliverySitePOCPhone2]
		,scn.[JobDeliveryPhoneHm]
		,scn.[JobDeliverySitePOCEmail]
		,scn.[JobDeliverySitePOCEmail2]
		,scn.[JobOriginStreetAddress]
		,scn.[JobOriginCity]
		,scn.[JobOriginStateProvince]
		,scn.[JobOriginPostalCode]
		,scn.[JobOriginCountry]
		,scn.[JobLongitude]
		,scn.[JobLatitude]
		,scn.[JobSignLongitude]
		,scn.[JobSignLatitude]
		,scn.[JobSignText]
		,scn.[JobSignCapture]
		,scn.[JobScheduledDate]
		,scn.[JobScheduledTime]
		,scn.[JobEstimatedDate]
		,scn.[JobEstimatedTime]
		,scn.[JobActualDate]
		,scn.[JobActualTime]
		,scn.[ColorCD]
		,scn.[JobFor]
		,scn.[JobFrom]
		,scn.[WindowStartTime]
		,scn.[WindowEndTime]
		,scn.[JobFlag01]
		,scn.[JobFlag02]
		,scn.[JobFlag03]
		,scn.[JobFlag04]
		,scn.[JobFlag05]
		,scn.[JobFlag06]
		,scn.[JobFlag07]
		,scn.[JobFlag08]
		,scn.[JobFlag09]
		,scn.[JobFlag10]
		,scn.[JobFlag11]
		,scn.[JobFlag12]
		,scn.[JobFlag13]
		,scn.[JobFlag14]
		,scn.[JobFlag15]
		,scn.[JobFlag16]
		,scn.[JobFlag17]
		,scn.[JobFlag18]
		,scn.[JobFlag19]
		,scn.[JobFlag20]
		,scn.[JobFlag21]
		,scn.[JobFlag22]
		,scn.[JobFlag23]
  FROM [dbo].[SCN000Order] scn
 WHERE scn.[JobID] = @id
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetScnOrderOSD]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               08/16/2018      
-- Description:               Get a ScnOrderOSD
-- Execution:                 EXEC [dbo].[GetScnOrderOSD]
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)    
-- Modified Desc:  
-- ============================================= 
ALTER PROCEDURE  [dbo].[GetScnOrderOSD]
    @userId BIGINT,
    @roleId BIGINT,
	@orgId BIGINT,
    @id BIGINT
AS
BEGIN TRY                
 SET NOCOUNT ON;   
  SELECT scn.[CargoOSDID]
		,scn.[OSDID]
		,scn.[DateTime]
		,scn.[CargoDetailID]
		,scn.[CargoID]
		,scn.[CgoSerialNumber]
		,scn.[OSDReasonID]
		,scn.[OSDQty]
		,scn.[Notes]
		,scn.[EditCD]
		,scn.[StatusID]
		,scn.[CgoSeverityCode]
  FROM [dbo].[SCN014OrderOSD] scn
 WHERE scn.[CargoOSDID] = @id
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetScnOrderOSDView]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               10/29/2018      
-- Description:               Get all ScnOrderOSD  
-- Execution:                 EXEC [dbo].[GetScnOrderOSDView]   
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)    
-- Modified Desc:  
-- ============================================= 
ALTER PROCEDURE [dbo].[GetScnOrderOSDView]
 @userId BIGINT,
 @roleId BIGINT,
 @orgId BIGINT,
 @entity NVARCHAR(100),
 @pageNo INT,
 @pageSize INT,
 @orderBy NVARCHAR(500),
 @groupBy NVARCHAR(500), 
 @groupByWhere NVARCHAR(500), 
 @where NVARCHAR(500),
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

SET @TCountQuery = 'SELECT @TotalCount = COUNT(' + @entity + '.Id) FROM [dbo].[SCN014OrderOSD] (NOLOCK) '+ @entity
SET @TCountQuery = 	@TCountQuery  +' WHERE 1=1 '+ ISNULL(@where, '')
EXEC sp_executesql @TCountQuery, N'@orgId BIGINT, @userId BIGINT, @parentId BIGINT, @TotalCount INT OUTPUT', @orgId, @userId, @parentId, @TotalCount  OUTPUT;


IF(@recordId = 0)
	BEGIN
		SET @sqlCommand = 'SELECT ' + [dbo].[fnGetBaseQueryByUserId](@entity, @userId)
	END
ELSE
	BEGIN
		IF((@isNext = 0) AND (@isEnd = 0))
			BEGIN
				 SET @sqlCommand = 'SELECT TOP 1 ISNULL(LAG(' + @entity + '.CargoOSDID) OVER (ORDER BY ' + ISNULL(@orderBy, @entity + '.CargoOSDID') + '), 0) AS CargoOSDID '
			END
		ELSE IF((@isNext = 1) AND (@isEnd = 0))
			BEGIN
				 SET @sqlCommand = 'SELECT TOP 1 ISNULL(LEAD(' + @entity + '.CargoOSDID) OVER (ORDER BY ' + ISNULL(@orderBy, @entity + '.CargoOSDID') + '), 0) AS CargoOSDID ' 
			END
		ELSE
			BEGIN
				SET @sqlCommand = 'SELECT TOP 1 ' + @entity + '.CargoOSDID '
			END
	END

SET @sqlCommand = @sqlCommand + ' FROM [dbo].[SCN014OrderOSD] (NOLOCK) '+ @entity

SET @sqlCommand = @sqlCommand + ' WHERE 1 = 1 '+ ISNULL(@where, '')

IF((@recordId > 0) AND (((@isNext = 0) AND (@isEnd = 0)) OR ((@isNext = 1) AND (@isEnd = 0))))
	BEGIN
		IF((@isNext = 0) AND (@isEnd = 0))  
   BEGIN  
	IF(ISNULL(@orderBy, '') <> '')
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND ' + @orderBy + ' <= (SELECT ' + @orderBy + ' FROM [dbo].[SCN014OrderOSD] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.CargoOSDID=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
	 END
	ELSE
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND '+@entity+'.CargoOSDID <= '+ CAST(@recordId AS NVARCHAR(50))  
	 END
   END  
  ELSE IF((@isNext = 1) AND (@isEnd = 0))  
   BEGIN  
    IF(ISNULL(@orderBy, '') <> '')
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND ' + @orderBy + ' >= (SELECT ' + @orderBy + ' FROM [dbo].[SCN014OrderOSD] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.CargoOSDID=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
	 END
	ELSE
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND '+@entity+'.CargoOSDID >= '+ CAST(@recordId AS NVARCHAR(50))  
	 END
   END   
	END

SET @sqlCommand = @sqlCommand + ISNULL(@where, '') + ' ORDER BY '+ ISNULL(@orderBy, @entity+'.CargoOSDID')

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

EXEC sp_executesql @sqlCommand, N'@pageNo INT, @pageSize INT, @entity NVARCHAR(100), @orderBy NVARCHAR(500), @where NVARCHAR(500), @orgId BIGINT,@userId BIGINT, @parentId BIGINT' ,
	 @entity= @entity,
     @pageNo= @pageNo, 
     @pageSize= @pageSize,
     @orderBy = @orderBy,
     @where = @where,
	 @orgId = @orgId,
	 @userId = @userId,
	 @parentId = @parentId
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetScnOrderRequirement]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               08/16/2018      
-- Description:               Get a ScnOrderRequirement
-- Execution:                 EXEC [dbo].[GetScnOrderRequirement]
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)   
-- Modified Desc:  
-- ============================================= 
ALTER PROCEDURE  [dbo].[GetScnOrderRequirement]
    @userId BIGINT,
    @roleId BIGINT,
	@orgId BIGINT,
    @id BIGINT
AS
BEGIN TRY                
 SET NOCOUNT ON;   
  SELECT scn.[RequirementID]
        ,scn.[RequirementCode]
        ,scn.[JobID]
        ,scn.[Notes]
        ,scn.[Complete]
  FROM [dbo].[SCN015OrderRequirement] scn
 WHERE scn.[RequirementID] = @id
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetScnOrderRequirementView]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               10/29/2018      
-- Description:               Get all ScnOrderRequirement  
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)    
-- Modified Desc:  
-- ============================================= 
ALTER PROCEDURE [dbo].[GetScnOrderRequirementView]
 @userId BIGINT,
 @roleId BIGINT,
 @orgId BIGINT,
 @entity NVARCHAR(100),
 @pageNo INT,
 @pageSize INT,
 @orderBy NVARCHAR(500),
 @groupBy NVARCHAR(500), 
 @groupByWhere NVARCHAR(500), 
 @where NVARCHAR(500),
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

SET @TCountQuery = 'SELECT @TotalCount = COUNT(' + @entity + '.Id) FROM [dbo].[SCN015OrderRequirement] (NOLOCK) '+ @entity
SET @TCountQuery = 	@TCountQuery  +' WHERE 1=1 '+ ISNULL(@where, '')
EXEC sp_executesql @TCountQuery, N'@orgId BIGINT, @userId BIGINT, @parentId BIGINT, @TotalCount INT OUTPUT', @orgId, @userId, @parentId, @TotalCount  OUTPUT;


IF(@recordId = 0)
	BEGIN
		SET @sqlCommand = 'SELECT ' + [dbo].[fnGetBaseQueryByUserId](@entity, @userId)
	END
ELSE
	BEGIN
		IF((@isNext = 0) AND (@isEnd = 0))
			BEGIN
				 SET @sqlCommand = 'SELECT TOP 1 ISNULL(LAG(' + @entity + '.RequirementID) OVER (ORDER BY ' + ISNULL(@orderBy, @entity + '.RequirementID') + '), 0) AS RequirementID '
			END
		ELSE IF((@isNext = 1) AND (@isEnd = 0))
			BEGIN
				 SET @sqlCommand = 'SELECT TOP 1 ISNULL(LEAD(' + @entity + '.RequirementID) OVER (ORDER BY ' + ISNULL(@orderBy, @entity + '.RequirementID') + '), 0) AS RequirementID ' 
			END
		ELSE
			BEGIN
				SET @sqlCommand = 'SELECT TOP 1 ' + @entity + '.RequirementID '
			END
	END

SET @sqlCommand = @sqlCommand + ' FROM [dbo].[SCN015OrderRequirement] (NOLOCK) '+ @entity

SET @sqlCommand = @sqlCommand + ' WHERE 1 = 1 '+ ISNULL(@where, '')

IF((@recordId > 0) AND (((@isNext = 0) AND (@isEnd = 0)) OR ((@isNext = 1) AND (@isEnd = 0))))
	BEGIN
		IF((@isNext = 0) AND (@isEnd = 0))  
   BEGIN  
	IF(ISNULL(@orderBy, '') <> '')
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND ' + @orderBy + ' <= (SELECT ' + @orderBy + ' FROM [dbo].[SCN015OrderRequirement] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.RequirementID=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
	 END
	ELSE
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND '+@entity+'.RequirementID <= '+ CAST(@recordId AS NVARCHAR(50))  
	 END
   END  
  ELSE IF((@isNext = 1) AND (@isEnd = 0))  
   BEGIN  
    IF(ISNULL(@orderBy, '') <> '')
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND ' + @orderBy + ' >= (SELECT ' + @orderBy + ' FROM [dbo].[SCN015OrderRequirement] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.RequirementID=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
	 END
	ELSE
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND '+@entity+'.RequirementID >= '+ CAST(@recordId AS NVARCHAR(50))  
	 END
   END   
	END

SET @sqlCommand = @sqlCommand + ISNULL(@where, '') + ' ORDER BY '+ ISNULL(@orderBy, @entity+'.RequirementID')

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

EXEC sp_executesql @sqlCommand, N'@pageNo INT, @pageSize INT, @entity NVARCHAR(100), @orderBy NVARCHAR(500), @where NVARCHAR(500), @orgId BIGINT,@userId BIGINT, @parentId BIGINT' ,
	 @entity= @entity,
     @pageNo= @pageNo, 
     @pageSize= @pageSize,
     @orderBy = @orderBy,
     @where = @where,
	 @orgId = @orgId,
	 @userId = @userId,
	 @parentId = @parentId
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetScnOrderService]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               08/16/2018      
-- Description:               Get a ScnOrderService
-- Execution:                 EXEC [dbo].[GetScnOrderService]
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)   
-- Modified Desc:  
-- ============================================= 
ALTER PROCEDURE  [dbo].[GetScnOrderService]
    @userId BIGINT,
    @roleId BIGINT,
	@orgId BIGINT,
    @id BIGINT
AS
BEGIN TRY                
 SET NOCOUNT ON;   
  SELECT scn.[ServicesID]
        ,scn.[ServicesCode]
        ,scn.[JobID]
        ,scn.[Notes]
        ,scn.[Complete]
  FROM [dbo].[SCN013OrderServices] scn
 WHERE scn.[ServicesID] = @id
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetScnOrderServiceView]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               10/29/2018      
-- Description:               Get all ScnOrderService  
-- Execution:                 EXEC [dbo].[GetScnOrderServiceView]   
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)   
-- Modified Desc:  
-- ============================================= 
ALTER PROCEDURE [dbo].[GetScnOrderServiceView]
 @userId BIGINT,
 @roleId BIGINT,
 @orgId BIGINT,
 @entity NVARCHAR(100),
 @pageNo INT,
 @pageSize INT,
 @orderBy NVARCHAR(500),
 @groupBy NVARCHAR(500), 
 @groupByWhere NVARCHAR(500), 
 @where NVARCHAR(500),
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

SET @TCountQuery = 'SELECT @TotalCount = COUNT(' + @entity + '.Id) FROM [dbo].[SCN013OrderServices] (NOLOCK) '+ @entity
SET @TCountQuery = 	@TCountQuery  +' WHERE 1=1 '+ ISNULL(@where, '')
EXEC sp_executesql @TCountQuery, N'@orgId BIGINT, @userId BIGINT, @parentId BIGINT, @TotalCount INT OUTPUT', @orgId, @userId, @parentId, @TotalCount  OUTPUT;


IF(@recordId = 0)
	BEGIN
		SET @sqlCommand = 'SELECT ' + [dbo].[fnGetBaseQueryByUserId](@entity, @userId)
	END
ELSE
	BEGIN
		IF((@isNext = 0) AND (@isEnd = 0))
			BEGIN
				 SET @sqlCommand = 'SELECT TOP 1 ISNULL(LAG(' + @entity + '.ServicesID) OVER (ORDER BY ' + ISNULL(@orderBy, @entity + '.ServicesID') + '), 0) AS ServicesID '
			END
		ELSE IF((@isNext = 1) AND (@isEnd = 0))
			BEGIN
				 SET @sqlCommand = 'SELECT TOP 1 ISNULL(LEAD(' + @entity + '.ServicesID) OVER (ORDER BY ' + ISNULL(@orderBy, @entity + '.ServicesID') + '), 0) AS ServicesID ' 
			END
		ELSE
			BEGIN
				SET @sqlCommand = 'SELECT TOP 1 ' + @entity + '.ServicesID '
			END
	END

SET @sqlCommand = @sqlCommand + ' FROM [dbo].[SCN013OrderServices] (NOLOCK) '+ @entity

SET @sqlCommand = @sqlCommand + ' WHERE 1 = 1 '+ ISNULL(@where, '')

IF((@recordId > 0) AND (((@isNext = 0) AND (@isEnd = 0)) OR ((@isNext = 1) AND (@isEnd = 0))))
	BEGIN
		IF((@isNext = 0) AND (@isEnd = 0))  
   BEGIN  
	IF(ISNULL(@orderBy, '') <> '')
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND ' + @orderBy + ' <= (SELECT ' + @orderBy + ' FROM [dbo].[SCN013OrderServices] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.ServicesID=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
	 END
	ELSE
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND '+@entity+'.ServicesID <= '+ CAST(@recordId AS NVARCHAR(50))  
	 END
   END  
  ELSE IF((@isNext = 1) AND (@isEnd = 0))  
   BEGIN  
    IF(ISNULL(@orderBy, '') <> '')
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND ' + @orderBy + ' >= (SELECT ' + @orderBy + ' FROM [dbo].[SCN013OrderServices] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.ServicesID=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
	 END
	ELSE
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND '+@entity+'.ServicesID >= '+ CAST(@recordId AS NVARCHAR(50))  
	 END
   END   
	END

SET @sqlCommand = @sqlCommand + ISNULL(@where, '') + ' ORDER BY '+ ISNULL(@orderBy, @entity+'.ServicesID')

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

EXEC sp_executesql @sqlCommand, N'@pageNo INT, @pageSize INT, @entity NVARCHAR(100), @orderBy NVARCHAR(500), @where NVARCHAR(500), @orgId BIGINT,@userId BIGINT, @parentId BIGINT' ,
	 @entity= @entity,
     @pageNo= @pageNo, 
     @pageSize= @pageSize,
     @orderBy = @orderBy,
     @where = @where,
	 @orgId = @orgId,
	 @userId = @userId,
	 @parentId = @parentId
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetScnOrderView]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               10/29/2018      
-- Description:               Get all ScnOrder
-- Execution:                 EXEC [dbo].[GetScnOrderView]   
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)   
-- Modified Desc:  
-- ============================================= 
ALTER PROCEDURE [dbo].[GetScnOrderView]
 @userId BIGINT,
 @roleId BIGINT,
 @orgId BIGINT,
 @entity NVARCHAR(100),
 @pageNo INT,
 @pageSize INT,
 @orderBy NVARCHAR(500),
 @groupBy NVARCHAR(500), 
 @groupByWhere NVARCHAR(500), 
 @where NVARCHAR(500),
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

SET @TCountQuery = 'SELECT @TotalCount = COUNT(' + @entity + '.Id) FROM [dbo].[SCN000Order] (NOLOCK) '+ @entity
SET @TCountQuery = 	@TCountQuery  +' WHERE 1=1 '+ ISNULL(@where, '')
EXEC sp_executesql @TCountQuery, N'@orgId BIGINT, @userId BIGINT, @parentId BIGINT, @TotalCount INT OUTPUT', @orgId, @userId, @parentId, @TotalCount  OUTPUT;


IF(@recordId = 0)
	BEGIN
		SET @sqlCommand = 'SELECT ' + [dbo].[fnGetBaseQueryByUserId](@entity, @userId)
	END
ELSE
	BEGIN
		IF((@isNext = 0) AND (@isEnd = 0))
			BEGIN
				 SET @sqlCommand = 'SELECT TOP 1 ISNULL(LAG(' + @entity + '.JobID) OVER (ORDER BY ' + ISNULL(@orderBy, @entity + '.JobID') + '), 0) AS JobID '
			END
		ELSE IF((@isNext = 1) AND (@isEnd = 0))
			BEGIN
				 SET @sqlCommand = 'SELECT TOP 1 ISNULL(LEAD(' + @entity + '.JobID) OVER (ORDER BY ' + ISNULL(@orderBy, @entity + '.JobID') + '), 0) AS JobID ' 
			END
		ELSE
			BEGIN
				SET @sqlCommand = 'SELECT TOP 1 ' + @entity + '.JobID '
			END
	END

SET @sqlCommand = @sqlCommand + ' FROM [dbo].[SCN000Order] (NOLOCK) '+ @entity

SET @sqlCommand = @sqlCommand + ' WHERE 1 = 1 '+ ISNULL(@where, '')

IF((@recordId > 0) AND (((@isNext = 0) AND (@isEnd = 0)) OR ((@isNext = 1) AND (@isEnd = 0))))
	BEGIN
		IF((@isNext = 0) AND (@isEnd = 0))  
   BEGIN  
	IF(ISNULL(@orderBy, '') <> '')
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND ' + @orderBy + ' <= (SELECT ' + @orderBy + ' FROM [dbo].[SCN000Order] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.JobID=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
	 END
	ELSE
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND '+@entity+'.JobID <= '+ CAST(@recordId AS NVARCHAR(50))  
	 END
   END  
  ELSE IF((@isNext = 1) AND (@isEnd = 0))  
   BEGIN  
    IF(ISNULL(@orderBy, '') <> '')
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND ' + @orderBy + ' >= (SELECT ' + @orderBy + ' FROM [dbo].[SCN000Order] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.JobID=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
	 END
	ELSE
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND '+@entity+'.JobID >= '+ CAST(@recordId AS NVARCHAR(50))  
	 END
   END   
	END

SET @sqlCommand = @sqlCommand + ISNULL(@where, '') + ' ORDER BY '+ ISNULL(@orderBy, @entity+'.JobID')

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

EXEC sp_executesql @sqlCommand, N'@pageNo INT, @pageSize INT, @entity NVARCHAR(100), @orderBy NVARCHAR(500), @where NVARCHAR(500), @orgId BIGINT,@userId BIGINT, @parentId BIGINT' ,
	 @entity= @entity,
     @pageNo= @pageNo, 
     @pageSize= @pageSize,
     @orderBy = @orderBy,
     @where = @where,
	 @orgId = @orgId,
	 @userId = @userId,
	 @parentId = @parentId
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetScnRouteList]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               08/16/2018      
-- Description:               Get a GetScnRouteList
-- Execution:                 EXEC [dbo].[GetScnRouteList]
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)    
-- Modified Desc:  
-- ============================================= 
ALTER PROCEDURE  [dbo].[GetScnRouteList]
    @userId BIGINT,
    @roleId BIGINT,
	@orgId BIGINT,
    @id BIGINT
AS
BEGIN TRY                
 SET NOCOUNT ON;   
  SELECT scn.[RouteID]
        ,scn.[RouteName]
        ,scn.[ProgramID]
  FROM [dbo].[SCN016RouteList] scn
 WHERE scn.[RouteID] = @id
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetScnRouteListView]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               10/29/2018      
-- Description:               Get all ScnRouteList  
-- Execution:                 EXEC [dbo].[GetScnRouteListView]   
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)    
-- Modified Desc:  
-- ============================================= 
ALTER PROCEDURE [dbo].[GetScnRouteListView]
 @userId BIGINT,
 @roleId BIGINT,
 @orgId BIGINT,
 @entity NVARCHAR(100),
 @pageNo INT,
 @pageSize INT,
 @orderBy NVARCHAR(500),
 @groupBy NVARCHAR(500), 
 @groupByWhere NVARCHAR(500), 
 @where NVARCHAR(500),
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

SET @TCountQuery = 'SELECT @TotalCount = COUNT(' + @entity + '.Id) FROM [dbo].[SCN016RouteList] (NOLOCK) '+ @entity
SET @TCountQuery = 	@TCountQuery  +' WHERE 1=1 '+ ISNULL(@where, '')
EXEC sp_executesql @TCountQuery, N'@orgId BIGINT, @userId BIGINT, @parentId BIGINT, @TotalCount INT OUTPUT', @orgId, @userId, @parentId, @TotalCount  OUTPUT;


IF(@recordId = 0)
	BEGIN
		SET @sqlCommand = 'SELECT ' + [dbo].[fnGetBaseQueryByUserId](@entity, @userId)
	END
ELSE
	BEGIN
		IF((@isNext = 0) AND (@isEnd = 0))
			BEGIN
				 SET @sqlCommand = 'SELECT TOP 1 ISNULL(LAG(' + @entity + '.RouteID) OVER (ORDER BY ' + ISNULL(@orderBy, @entity + '.RouteID') + '), 0) AS RouteID '
			END
		ELSE IF((@isNext = 1) AND (@isEnd = 0))
			BEGIN
				 SET @sqlCommand = 'SELECT TOP 1 ISNULL(LEAD(' + @entity + '.RouteID) OVER (ORDER BY ' + ISNULL(@orderBy, @entity + '.RouteID') + '), 0) AS RouteID ' 
			END
		ELSE
			BEGIN
				SET @sqlCommand = 'SELECT TOP 1 ' + @entity + '.RouteID '
			END
	END

SET @sqlCommand = @sqlCommand + ' FROM [dbo].[SCN016RouteList] (NOLOCK) '+ @entity

SET @sqlCommand = @sqlCommand + ' WHERE 1 = 1 '+ ISNULL(@where, '')

IF((@recordId > 0) AND (((@isNext = 0) AND (@isEnd = 0)) OR ((@isNext = 1) AND (@isEnd = 0))))
	BEGIN
		IF((@isNext = 0) AND (@isEnd = 0))  
   BEGIN  
	IF(ISNULL(@orderBy, '') <> '')
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND ' + @orderBy + ' <= (SELECT ' + @orderBy + ' FROM [dbo].[SCN016RouteList] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.RouteID=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
	 END
	ELSE
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND '+@entity+'.RouteID <= '+ CAST(@recordId AS NVARCHAR(50))  
	 END
   END  
  ELSE IF((@isNext = 1) AND (@isEnd = 0))  
   BEGIN  
    IF(ISNULL(@orderBy, '') <> '')
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND ' + @orderBy + ' >= (SELECT ' + @orderBy + ' FROM [dbo].[SCN016RouteList] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.RouteID=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
	 END
	ELSE
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND '+@entity+'.RouteID >= '+ CAST(@recordId AS NVARCHAR(50))  
	 END
   END   
	END

SET @sqlCommand = @sqlCommand + ISNULL(@where, '') + ' ORDER BY '+ ISNULL(@orderBy, @entity+'.RouteID')

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

EXEC sp_executesql @sqlCommand, N'@pageNo INT, @pageSize INT, @entity NVARCHAR(100), @orderBy NVARCHAR(500), @where NVARCHAR(500), @orgId BIGINT,@userId BIGINT, @parentId BIGINT' ,
	 @entity= @entity,
     @pageNo= @pageNo, 
     @pageSize= @pageSize,
     @orderBy = @orderBy,
     @where = @where,
	 @orgId = @orgId,
	 @userId = @userId,
	 @parentId = @parentId
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetScrCatalogList]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan             
-- Create date:               10/29/2018      
-- Description:               Get a Scr Catalog List
-- Execution:                 EXEC [dbo].[GetScrCatalogList]
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)   
-- Modified Desc:  
-- =============================================
ALTER PROCEDURE  [dbo].[GetScrCatalogList]
    @userId BIGINT,
    @roleId BIGINT,
	@orgId BIGINT,
    @id BIGINT
AS
BEGIN TRY                
 SET NOCOUNT ON;   
 SELECT scr.[Id]
		,scr.[CatalogProgramID]
		,scr.[CatalogItemNumber]
		,scr.[CatalogCode]
		,scr.[CatalogCustCode]
		,scr.[CatalogTitle]
		,scr.[CatalogPhoto]
		,scr.[CatalogUoMCode]
		,scr.[CatalogCubes]
		,scr.[CatalogWidth]
		,scr.[CatalogLength]
		,scr.[CatalogHeight]
		,scr.[CatalogWLHUoM]
		,scr.[CatalogWeight]
		,scr.[StatusId]
		,scr.[DateEntered]
		,scr.[EnteredBy]
		,scr.[DateChanged]
		,scr.[ChangedBy]

		,CASE WHEN pgm.PrgHierarchyLevel = 1 THEN     pgm.[PrgProgramCode]
		 WHEN pgm.PrgHierarchyLevel = 2 THEN     pgm.[PrgProjectCode]
		  WHEN pgm.PrgHierarchyLevel = 3 THEN     pgm.PrgPhaseCode
		  ELSE pgm.[PrgProgramTitle] END AS CatalogProgramIDName


   FROM [dbo].[SCR010CatalogList] scr
   INNER JOIN PRGRM000Master pgm ON scr.CatalogProgramID = pgm.Id
  WHERE scr.[Id]=@id
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetScrCatalogListView]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               10/29/2018      
-- Description:               Get all Scr Catalog List  
-- Execution:                 EXEC [dbo].[GetScrCatalogListView]   
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)   
-- Modified Desc:  
-- ============================================= 
ALTER PROCEDURE [dbo].[GetScrCatalogListView]
 @userId BIGINT,
 @roleId BIGINT,
 @orgId BIGINT,
 @entity NVARCHAR(100),
 @pageNo INT,
 @pageSize INT,
 @orderBy NVARCHAR(500),
 @groupBy NVARCHAR(500), 
 @groupByWhere NVARCHAR(500), 
 @where NVARCHAR(500),
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

SET @TCountQuery = 'SELECT @TotalCount = COUNT(' + @entity + '.Id) FROM [dbo].[SCR010CatalogList] (NOLOCK) '+ @entity +
				   ' JOIN [dbo].[PRGRM000Master] prg ON ' + @entity + '.CatalogProgramID = prg.Id AND prg.Id = @parentId '

--Below for getting user specific 'Statuses'
IF((ISNULL(@where, '') = '') OR (@where NOT LIKE '%'+@entity+'.StatusId%'))
	BEGIN
		SET @TCountQuery = @TCountQuery + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) fgus ON ' + @entity + '.[StatusId] = fgus.[StatusId] '
	END

SET @TCountQuery = 	@TCountQuery  +' WHERE prg.PrgOrgID = @orgId '+ ISNULL(@where, '')
EXEC sp_executesql @TCountQuery, N'@orgId BIGINT, @userId BIGINT, @parentId BIGINT, @TotalCount INT OUTPUT', @orgId, @userId, @parentId, @TotalCount  OUTPUT;


IF(@recordId = 0)
	BEGIN
		SET @sqlCommand = 'SELECT ' + [dbo].[fnGetBaseQueryByUserId](@entity, @userId) 
		--SET @sqlCommand = @sqlCommand + ' , prg.[PrgProgramTitle] AS CatalogProgramIDName ';
		SET @sqlCommand = @sqlCommand + ' , CASE WHEN prg.PrgHierarchyLevel = 1 THEN     prg.[PrgProgramCode]
		 WHEN prg.PrgHierarchyLevel = 2 THEN     prg.[PrgProjectCode]
		  WHEN prg.PrgHierarchyLevel = 3 THEN     prg.PrgPhaseCode
		  ELSE prg.[PrgProgramTitle] END AS CatalogProgramIDName';

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

SET @sqlCommand = @sqlCommand + ' FROM [dbo].[SCR010CatalogList] (NOLOCK) '+ @entity
SET @sqlCommand = @sqlCommand + ' JOIN [dbo].[PRGRM000Master] prg ON '+@entity+'.CatalogProgramID = prg.Id AND prg.Id=@parentId '

--Below for getting user specific 'Statuses'
IF((ISNULL(@where, '') = '') OR (@where NOT LIKE '%'+@entity+'.StatusId%'))
	BEGIN
		SET @sqlCommand = @sqlCommand + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) hfk ON ISNULL(' + @entity + '.[StatusId], 1) = hfk.[StatusId] '
	END

SET @sqlCommand = @sqlCommand + ' WHERE prg.PrgOrgID = @orgId '

IF((@recordId > 0) AND (((@isNext = 0) AND (@isEnd = 0)) OR ((@isNext = 1) AND (@isEnd = 0))))
	BEGIN
		IF((@isNext = 0) AND (@isEnd = 0))  
   BEGIN  
	IF(ISNULL(@orderBy, '') <> '')
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND ' + @orderBy + ' <= (SELECT ' + @orderBy + ' FROM [dbo].[SCR010CatalogList] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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
		SET @sqlCommand = @sqlCommand + ' AND ' + @orderBy + ' >= (SELECT ' + @orderBy + ' FROM [dbo].[SCR010CatalogList] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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

EXEC sp_executesql @sqlCommand, N'@pageNo INT, @pageSize INT, @entity NVARCHAR(100), @orderBy NVARCHAR(500), @where NVARCHAR(500), @orgId BIGINT,@userId BIGINT, @parentId BIGINT' ,
	 @entity= @entity,
     @pageNo= @pageNo, 
     @pageSize= @pageSize,
     @orderBy = @orderBy,
     @where = @where,
	 @orgId = @orgId,
	 @userId = @userId,
	 @parentId = @parentId
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetScrGatewayList]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               08/16/2018      
-- Description:               Get a ScrGatewayList
-- Execution:                 EXEC [dbo].[GetScrGatewayList]
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)    
-- Modified Desc:  
-- ============================================= 
ALTER PROCEDURE  [dbo].[GetScrGatewayList]
    @userId BIGINT,
    @roleId BIGINT,
	@orgId BIGINT,
    @id BIGINT
AS
BEGIN TRY                
 SET NOCOUNT ON;   
  SELECT scr.[GatewayStatusID]
        ,scr.[ProgramID]
        ,scr.[GatewayCode]
  FROM [dbo].[SCR016GatewayList] scr
 WHERE scr.[GatewayStatusID] = @id
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetScrGatewayListView]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               10/29/2018      
-- Description:               Get all ScrGatewayList  
-- Execution:                 EXEC [dbo].[GetScrGatewayListView]   
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)   
-- Modified Desc:  
-- ============================================= 
ALTER PROCEDURE [dbo].[GetScrGatewayListView]
 @userId BIGINT,
 @roleId BIGINT,
 @orgId BIGINT,
 @entity NVARCHAR(100),
 @pageNo INT,
 @pageSize INT,
 @orderBy NVARCHAR(500),
 @groupBy NVARCHAR(500), 
 @groupByWhere NVARCHAR(500), 
 @where NVARCHAR(500),
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

SET @TCountQuery = 'SELECT @TotalCount = COUNT(' + @entity + '.Id) FROM [dbo].[SCR016GatewayList] (NOLOCK) '+ @entity
SET @TCountQuery = 	@TCountQuery  +' WHERE 1=1 '+ ISNULL(@where, '')
EXEC sp_executesql @TCountQuery, N'@orgId BIGINT, @userId BIGINT, @parentId BIGINT, @TotalCount INT OUTPUT', @orgId, @userId, @parentId, @TotalCount  OUTPUT;


IF(@recordId = 0)
	BEGIN
		SET @sqlCommand = 'SELECT ' + [dbo].[fnGetBaseQueryByUserId](@entity, @userId)
	END
ELSE
	BEGIN
		IF((@isNext = 0) AND (@isEnd = 0))
			BEGIN
				 SET @sqlCommand = 'SELECT TOP 1 ISNULL(LAG(' + @entity + '.GatewayStatusID) OVER (ORDER BY ' + ISNULL(@orderBy, @entity + '.GatewayStatusID') + '), 0) AS GatewayStatusID '
			END
		ELSE IF((@isNext = 1) AND (@isEnd = 0))
			BEGIN
				 SET @sqlCommand = 'SELECT TOP 1 ISNULL(LEAD(' + @entity + '.GatewayStatusID) OVER (ORDER BY ' + ISNULL(@orderBy, @entity + '.GatewayStatusID') + '), 0) AS GatewayStatusID ' 
			END
		ELSE
			BEGIN
				SET @sqlCommand = 'SELECT TOP 1 ' + @entity + '.GatewayStatusID '
			END
	END

SET @sqlCommand = @sqlCommand + ' FROM [dbo].[SCR016GatewayList] (NOLOCK) '+ @entity

SET @sqlCommand = @sqlCommand + ' WHERE 1 = 1 '+ ISNULL(@where, '')

IF((@recordId > 0) AND (((@isNext = 0) AND (@isEnd = 0)) OR ((@isNext = 1) AND (@isEnd = 0))))
	BEGIN
		IF((@isNext = 0) AND (@isEnd = 0))  
   BEGIN  
	IF(ISNULL(@orderBy, '') <> '')
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND ' + @orderBy + ' <= (SELECT ' + @orderBy + ' FROM [dbo].[SCR016GatewayList] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.GatewayStatusID=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
	 END
	ELSE
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND '+@entity+'.GatewayStatusID <= '+ CAST(@recordId AS NVARCHAR(50))  
	 END
   END  
  ELSE IF((@isNext = 1) AND (@isEnd = 0))  
   BEGIN  
    IF(ISNULL(@orderBy, '') <> '')
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND ' + @orderBy + ' >= (SELECT ' + @orderBy + ' FROM [dbo].[SCR016GatewayList] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.GatewayStatusID=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
	 END
	ELSE
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND '+@entity+'.GatewayStatusID >= '+ CAST(@recordId AS NVARCHAR(50))  
	 END
   END   
	END

SET @sqlCommand = @sqlCommand + ISNULL(@where, '') + ' ORDER BY '+ ISNULL(@orderBy, @entity+'.GatewayStatusID')

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

EXEC sp_executesql @sqlCommand, N'@pageNo INT, @pageSize INT, @entity NVARCHAR(100), @orderBy NVARCHAR(500), @where NVARCHAR(500), @orgId BIGINT,@userId BIGINT, @parentId BIGINT' ,
	 @entity= @entity,
     @pageNo= @pageNo, 
     @pageSize= @pageSize,
     @orderBy = @orderBy,
     @where = @where,
	 @orgId = @orgId,
	 @userId = @userId,
	 @parentId = @parentId
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetScrInfoList]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               08/16/2018      
-- Description:               Get a GetScrInfoList
-- Execution:                 EXEC [dbo].[GetScrInfoList]
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)   
-- Modified Desc:  
-- ============================================= 
ALTER PROCEDURE  [dbo].[GetScrInfoList]
    @userId BIGINT,
    @roleId BIGINT,
	@orgId BIGINT,
    @id BIGINT
AS
BEGIN TRY                
 SET NOCOUNT ON;   
  SELECT scn.[InfoListID]
        ,scn.[InfoListDesc]
        ,scn.[InfoListPhoto]
  FROM [dbo].[SCR010InfoList] scn
 WHERE scn.[InfoListID] = @id
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetScrInfoListView]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               10/29/2018      
-- Description:               Get all ScrInfoList  
-- Execution:                 EXEC [dbo].[GetScrInfoListView]   
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)   
-- Modified Desc:  
-- ============================================= 
ALTER PROCEDURE [dbo].[GetScrInfoListView]
 @userId BIGINT,
 @roleId BIGINT,
 @orgId BIGINT,
 @entity NVARCHAR(100),
 @pageNo INT,
 @pageSize INT,
 @orderBy NVARCHAR(500),
 @groupBy NVARCHAR(500), 
 @groupByWhere NVARCHAR(500), 
 @where NVARCHAR(500),
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

SET @TCountQuery = 'SELECT @TotalCount = COUNT(' + @entity + '.Id) FROM [dbo].[SCR010InfoList] (NOLOCK) '+ @entity
SET @TCountQuery = 	@TCountQuery  +' WHERE 1=1 '+ ISNULL(@where, '')
EXEC sp_executesql @TCountQuery, N'@orgId BIGINT, @userId BIGINT, @parentId BIGINT, @TotalCount INT OUTPUT', @orgId, @userId, @parentId, @TotalCount  OUTPUT;


IF(@recordId = 0)
	BEGIN
		SET @sqlCommand = 'SELECT ' + [dbo].[fnGetBaseQueryByUserId](@entity, @userId)
	END
ELSE
	BEGIN
		IF((@isNext = 0) AND (@isEnd = 0))
			BEGIN
				 SET @sqlCommand = 'SELECT TOP 1 ISNULL(LAG(' + @entity + '.InfoListID) OVER (ORDER BY ' + ISNULL(@orderBy, @entity + '.InfoListID') + '), 0) AS InfoListID '
			END
		ELSE IF((@isNext = 1) AND (@isEnd = 0))
			BEGIN
				 SET @sqlCommand = 'SELECT TOP 1 ISNULL(LEAD(' + @entity + '.InfoListID) OVER (ORDER BY ' + ISNULL(@orderBy, @entity + '.InfoListID') + '), 0) AS InfoListID ' 
			END
		ELSE
			BEGIN
				SET @sqlCommand = 'SELECT TOP 1 ' + @entity + '.InfoListID '
			END
	END

SET @sqlCommand = @sqlCommand + ' FROM [dbo].[SCR010InfoList] (NOLOCK) '+ @entity

SET @sqlCommand = @sqlCommand + ' WHERE 1 = 1 '+ ISNULL(@where, '')

IF((@recordId > 0) AND (((@isNext = 0) AND (@isEnd = 0)) OR ((@isNext = 1) AND (@isEnd = 0))))
	BEGIN
		IF((@isNext = 0) AND (@isEnd = 0))  
   BEGIN  
	IF(ISNULL(@orderBy, '') <> '')
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND ' + @orderBy + ' <= (SELECT ' + @orderBy + ' FROM [dbo].[SCR010InfoList] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.InfoListID=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
	 END
	ELSE
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND '+@entity+'.InfoListID <= '+ CAST(@recordId AS NVARCHAR(50))  
	 END
   END  
  ELSE IF((@isNext = 1) AND (@isEnd = 0))  
   BEGIN  
    IF(ISNULL(@orderBy, '') <> '')
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND ' + @orderBy + ' >= (SELECT ' + @orderBy + ' FROM [dbo].[SCR010InfoList] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.InfoListID=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
	 END
	ELSE
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND '+@entity+'.InfoListID >= '+ CAST(@recordId AS NVARCHAR(50))  
	 END
   END   
	END

SET @sqlCommand = @sqlCommand + ISNULL(@where, '') + ' ORDER BY '+ ISNULL(@orderBy, @entity+'.InfoListID')

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

EXEC sp_executesql @sqlCommand, N'@pageNo INT, @pageSize INT, @entity NVARCHAR(100), @orderBy NVARCHAR(500), @where NVARCHAR(500), @orgId BIGINT,@userId BIGINT, @parentId BIGINT' ,
	 @entity= @entity,
     @pageNo= @pageNo, 
     @pageSize= @pageSize,
     @orderBy = @orderBy,
     @where = @where,
	 @orgId = @orgId,
	 @userId = @userId,
	 @parentId = @parentId
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetScrOsdList]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               10/29/2018      
-- Description:               Get a Scr Osd List
-- Execution:                 EXEC [dbo].[GetScrOsdList]   
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)    
-- Modified Desc:  
-- ============================================= 
ALTER PROCEDURE  [dbo].[GetScrOsdList]
    @userId BIGINT,
    @roleId BIGINT,
	@orgId BIGINT,
    @id BIGINT
AS
BEGIN TRY                
 SET NOCOUNT ON;   
 SELECT scr.[OSDID] as Id
		,scr.[ProgramID]
		,scr.[OSDItemNumber]
		,scr.[OSDCode]
		,scr.[OSDTitle]
		,scr.[OSDType]
		,scr.[StatusId]
		,scr.[DateEntered]
		,scr.[EnteredBy]
		,scr.[DateChanged]
		,scr.[ChangedBy]
   FROM [dbo].[SCR011OSDList] scr
  WHERE scr.[OSDID]=@id
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetScrOsdListView]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               10/29/2018      
-- Description:               Get all Scr Osd List  
-- Execution:                 EXEC [dbo].[GetScrOsdListView]   
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)   
-- Modified Desc:  
-- ============================================= 
ALTER PROCEDURE [dbo].[GetScrOsdListView]
 @userId BIGINT,
 @roleId BIGINT,
 @orgId BIGINT,
 @entity NVARCHAR(100),
 @pageNo INT,
 @pageSize INT,
 @orderBy NVARCHAR(500),
 @groupBy NVARCHAR(500), 
 @groupByWhere NVARCHAR(500), 
 @where NVARCHAR(500),
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

 -- Replace Orderby And Where column Name Id with OSDID
 IF(ISNULL(@where, '') <> '')
 BEGIN
    SET @where  = REPLACE(@where, @entity+'.Id',@entity+'.OSDID');
 END
  IF(ISNULL(@orderBy, '') <> '')
 BEGIN
    SET @orderBy  = REPLACE(@orderBy, @entity+'.Id',@entity+'.OSDID');
 END

SET @TCountQuery = 'SELECT @TotalCount = COUNT(' + @entity + '.OSDID) FROM [dbo].[SCR011OSDList] (NOLOCK) '+ @entity +
				   ' LEFT JOIN [dbo].[PRGRM000Master] prg ON ' + @entity + '.ProgramID = prg.Id AND prg.PrgOrgID = @orgId '

--Below for getting user specific 'Statuses'
IF((ISNULL(@where, '') = '') OR (@where NOT LIKE '%'+@entity+'.StatusId%'))
	BEGIN
		SET @TCountQuery = @TCountQuery + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) fgus ON ' + @entity + '.[StatusId] = fgus.[StatusId] '
	END

SET @TCountQuery = 	@TCountQuery  +' WHERE  1=1 '+ ISNULL(@where, '')

EXEC sp_executesql @TCountQuery, N'@orgId BIGINT, @userId BIGINT, @TotalCount INT OUTPUT', @orgId, @userId, @TotalCount  OUTPUT;

IF(@recordId = 0)
	BEGIN
		SET @sqlCommand = 'SELECT ' + [dbo].[fnGetBaseQueryByUserId](@entity, @userId) ;

		--Fetch the Projection list as Id
		SET @sqlCommand = STUFF(@sqlCommand, CHARINDEX(@entity+'.OSDID', @sqlCommand), LEN(@entity+'.OSDID'), @entity+'.OSDID as Id');

		SET @sqlCommand = @sqlCommand + ' , prg.[PrgProgramTitle] AS ProgramIDName '
	END
ELSE
	BEGIN
		IF((@isNext = 0) AND (@isEnd = 0))
			BEGIN
				 SET @sqlCommand = 'SELECT TOP 1 ISNULL(LAG(' + @entity + '.OSDID) OVER (ORDER BY ' + ISNULL(@orderBy, @entity + '.OSDID') + '), 0) AS Id '
			END
		ELSE IF((@isNext = 1) AND (@isEnd = 0))
			BEGIN
				 SET @sqlCommand = 'SELECT TOP 1 ISNULL(LEAD(' + @entity + '.OSDID) OVER (ORDER BY ' + ISNULL(@orderBy, @entity + '.OSDID') + '), 0) AS Id ' 
			END
		ELSE
			BEGIN
				SET @sqlCommand = 'SELECT TOP 1 ' + @entity + '.OSDID AS Id '
			END
	END

SET @sqlCommand = @sqlCommand + ' FROM [dbo].[SCR011OSDList] (NOLOCK) '+ @entity
SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[PRGRM000Master] prg ON '+@entity+'.ProgramID = prg.Id AND prg.PrgOrgID = @orgId '

--Below for getting user specific 'Statuses'
IF((ISNULL(@where, '') = '') OR (@where NOT LIKE '%'+@entity+'.StatusId%'))
	BEGIN
		SET @sqlCommand = @sqlCommand + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) hfk ON ISNULL(' + @entity + '.[StatusId], 1) = hfk.[StatusId] '
	END

SET @sqlCommand = @sqlCommand + ' WHERE  1=1 '

IF((@recordId > 0) AND (((@isNext = 0) AND (@isEnd = 0)) OR ((@isNext = 1) AND (@isEnd = 0))))
	BEGIN
		IF((@isNext = 0) AND (@isEnd = 0))  
   BEGIN  
	IF(ISNULL(@orderBy, '') <> '')
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND ' + @orderBy + ' <= (SELECT ' + @orderBy + ' FROM [dbo].[SCR011OSDList] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.OSDID=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
	 END
	ELSE
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND '+@entity+'.OSDID <= '+ CAST(@recordId AS NVARCHAR(50))  
	 END
   END  
  ELSE IF((@isNext = 1) AND (@isEnd = 0))  
   BEGIN  
    IF(ISNULL(@orderBy, '') <> '')
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND ' + @orderBy + ' >= (SELECT ' + @orderBy + ' FROM [dbo].[SCR011OSDList] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.OSDID=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
	 END
	ELSE
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND '+@entity+'.OSDID >= '+ CAST(@recordId AS NVARCHAR(50))  
	 END
   END   
	END

SET @sqlCommand = @sqlCommand + ISNULL(@where, '') + ' ORDER BY '+ ISNULL(@orderBy, @entity+'.OSDID')

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

EXEC sp_executesql @sqlCommand, N'@pageNo INT, @pageSize INT, @entity NVARCHAR(100), @orderBy NVARCHAR(500), @where NVARCHAR(500), @orgId BIGINT,@userId BIGINT' ,
	 @entity= @entity,
     @pageNo= @pageNo, 
     @pageSize= @pageSize,
     @orderBy = @orderBy,
     @where = @where,
	 @orgId = @orgId,
	 @userId = @userId
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetScrOsdReasonList]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               10/29/2018      
-- Description:               Get a Scr Osd Reason List 
-- Execution:                 EXEC [dbo].[GetScrOsdReasonList]   
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)   
-- Modified Desc:  
-- ============================================= 
ALTER PROCEDURE  [dbo].[GetScrOsdReasonList]
    @userId BIGINT,
    @roleId BIGINT,
	@orgId BIGINT,
    @id BIGINT
AS
BEGIN TRY                
 SET NOCOUNT ON;   
 SELECT scr.[ReasonID] as Id
		,scr.[ProgramID]
		,scr.[ReasonItemNumber]
		,scr.[ReasonIDCode]
		,scr.[ReasonTitle]
		,scr.[StatusId]
		,scr.[DateEntered]
		,scr.[EnteredBy]
		,scr.[DateChanged]
		,scr.[ChangedBy]
   FROM [dbo].[SCR011OSDReasonList] scr
  WHERE scr.[ReasonID]=@id
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetScrOsdReasonListView]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               10/29/2018      
-- Description:               Get all Scr Osd Reason List 
-- Execution:                 EXEC [dbo].[GetScrOsdReasonListView]   
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)    
-- Modified Desc:  
-- =============================================
ALTER PROCEDURE [dbo].[GetScrOsdReasonListView]
 @userId BIGINT,
 @roleId BIGINT,
 @orgId BIGINT,
 @entity NVARCHAR(100),
 @pageNo INT,
 @pageSize INT,
 @orderBy NVARCHAR(500),
 @groupBy NVARCHAR(500), 
 @groupByWhere NVARCHAR(500), 
 @where NVARCHAR(500),
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

  -- Replace Orderby And Where column Name Id with ReasonID

 IF(ISNULL(@where, '') <> '')
 BEGIN
    SET @where  = REPLACE(@where, @entity+'.Id',@entity+'.ReasonID');
 END
  IF(ISNULL(@orderBy, '') <> '')
 BEGIN
    SET @orderBy  = REPLACE(@orderBy, @entity+'.Id',@entity+'.ReasonID');
 END

SET @TCountQuery = 'SELECT @TotalCount = COUNT(' + @entity + '.ReasonID) FROM [dbo].[SCR011OSDReasonList] (NOLOCK) '+ @entity +
				   ' LEFT JOIN [dbo].[PRGRM000Master] prg ON ' + @entity + '.ProgramID = prg.Id AND prg.PrgOrgID = @orgId '

--Below for getting user specific 'Statuses'
IF((ISNULL(@where, '') = '') OR (@where NOT LIKE '%'+@entity+'.StatusId%'))
	BEGIN
		SET @TCountQuery = @TCountQuery + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) fgus ON ' + @entity + '.[StatusId] = fgus.[StatusId] '
	END

SET @TCountQuery = 	@TCountQuery  +' WHERE 1=1 '+ ISNULL(@where, '')
EXEC sp_executesql @TCountQuery, N'@orgId BIGINT, @userId BIGINT, @TotalCount INT OUTPUT', @orgId, @userId, @TotalCount  OUTPUT;

IF(@recordId = 0)
	BEGIN
		SET @sqlCommand = 'SELECT ' + [dbo].[fnGetBaseQueryByUserId](@entity, @userId) 
		--Fetch the Projection list as Id
		SET @sqlCommand = STUFF(@sqlCommand, CHARINDEX(@entity+'.ReasonID', @sqlCommand), LEN(@entity+'.ReasonID'), @entity+'.ReasonID as Id');

		SET @sqlCommand = @sqlCommand + ' , prg.[PrgProgramTitle] AS ProgramIDName '
	END
ELSE
	BEGIN
		IF((@isNext = 0) AND (@isEnd = 0))
			BEGIN
				 SET @sqlCommand = 'SELECT TOP 1 ISNULL(LAG(' + @entity + '.ReasonID) OVER (ORDER BY ' + ISNULL(@orderBy, @entity + '.ReasonID') + '), 0) AS Id '
			END
		ELSE IF((@isNext = 1) AND (@isEnd = 0))
			BEGIN
				 SET @sqlCommand = 'SELECT TOP 1 ISNULL(LEAD(' + @entity + '.ReasonID) OVER (ORDER BY ' + ISNULL(@orderBy, @entity + '.ReasonID') + '), 0) AS Id ' 
			END
		ELSE
			BEGIN
				SET @sqlCommand = 'SELECT TOP 1 ' + @entity + '.ReasonID AS Id '
			END
	END

SET @sqlCommand = @sqlCommand + ' FROM [dbo].[SCR011OSDReasonList] (NOLOCK) '+ @entity
SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[PRGRM000Master] prg ON '+@entity+'.ProgramID = prg.Id AND prg.PrgOrgID = @orgId '

--Below for getting user specific 'Statuses'
IF((ISNULL(@where, '') = '') OR (@where NOT LIKE '%'+@entity+'.StatusId%'))
	BEGIN
		SET @sqlCommand = @sqlCommand + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) hfk ON ISNULL(' + @entity + '.[StatusId], 1) = hfk.[StatusId] '
	END

SET @sqlCommand = @sqlCommand + ' WHERE 1=1 '

IF((@recordId > 0) AND (((@isNext = 0) AND (@isEnd = 0)) OR ((@isNext = 1) AND (@isEnd = 0))))
	BEGIN
		IF((@isNext = 0) AND (@isEnd = 0))  
   BEGIN  
	IF(ISNULL(@orderBy, '') <> '')
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND ' + @orderBy + ' <= (SELECT ' + @orderBy + ' FROM [dbo].[SCR011OSDReasonList] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.ReasonID=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
	 END
	ELSE
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND '+@entity+'.ReasonID <= '+ CAST(@recordId AS NVARCHAR(50))  
	 END
   END  
  ELSE IF((@isNext = 1) AND (@isEnd = 0))  
   BEGIN  
    IF(ISNULL(@orderBy, '') <> '')
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND ' + @orderBy + ' >= (SELECT ' + @orderBy + ' FROM [dbo].[SCR011OSDReasonList] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.ReasonID=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
	 END
	ELSE
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND '+@entity+'.ReasonID >= '+ CAST(@recordId AS NVARCHAR(50))  
	 END
   END   
	END

SET @sqlCommand = @sqlCommand + ISNULL(@where, '') + ' ORDER BY '+ ISNULL(@orderBy, @entity+'.ReasonID')

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

EXEC sp_executesql @sqlCommand, N'@pageNo INT, @pageSize INT, @entity NVARCHAR(100), @orderBy NVARCHAR(500), @where NVARCHAR(500), @orgId BIGINT,@userId BIGINT' ,
	 @entity= @entity,
     @pageNo= @pageNo, 
     @pageSize= @pageSize,
     @orderBy = @orderBy,
     @where = @where,
	 @orgId = @orgId,
	 @userId = @userId
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetScrRequirementList]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               10/29/2018      
-- Description:               Get a Scr Requirement List
-- Execution:                 EXEC [dbo].[GetScrRequirementList]   
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)    
-- Modified Desc:  
-- =============================================
ALTER PROCEDURE  [dbo].[GetScrRequirementList]
    @userId BIGINT,
    @roleId BIGINT,
	@orgId BIGINT,
    @id BIGINT
AS
BEGIN TRY                
 SET NOCOUNT ON;   
 SELECT scr.[RequirementID] AS Id
		,scr.[ProgramID]
		,scr.[RequirementLineItem]
		,scr.[RequirementCode]
		,scr.[RequirementTitle]
		,scr.[StatusId]
		,scr.[DateEntered]
		,scr.[EnteredBy]
		,scr.[DateChanged]
		,scr.[ChangedBy]
   FROM [dbo].[SCR012RequirementList] scr
  WHERE scr.[RequirementID]=@id
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetScrRequirementListView]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               10/29/2018      
-- Description:               Get all Scr Requirement List
-- Execution:                 EXEC [dbo].[GetScrRequirementListView]   
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)    
-- Modified Desc:  
-- =============================================  
ALTER PROCEDURE [dbo].[GetScrRequirementListView]
 @userId BIGINT,
 @roleId BIGINT,
 @orgId BIGINT,
 @entity NVARCHAR(100),
 @pageNo INT,
 @pageSize INT,
 @orderBy NVARCHAR(500),
 @groupBy NVARCHAR(500), 
 @groupByWhere NVARCHAR(500), 
 @where NVARCHAR(500),
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

  -- Replace Orderby And Where column Name Id with OSDID
 IF(ISNULL(@where, '') <> '')
 BEGIN
    SET @where  = REPLACE(@where, @entity+'.Id',@entity+'.RequirementID');
 END
  IF(ISNULL(@orderBy, '') <> '')
 BEGIN
    SET @orderBy  = REPLACE(@orderBy, @entity+'.Id',@entity+'.RequirementID');
 END

SET @TCountQuery = 'SELECT @TotalCount = COUNT(' + @entity + '.RequirementID) FROM [dbo].[SCR012RequirementList] (NOLOCK) '+ @entity +
				   ' LEFT JOIN [dbo].[PRGRM000Master] prg ON ' + @entity + '.ProgramID = prg.Id AND prg.PrgOrgID = @orgId '

--Below for getting user specific 'Statuses'
IF((ISNULL(@where, '') = '') OR (@where NOT LIKE '%'+@entity+'.StatusId%'))
	BEGIN
		SET @TCountQuery = @TCountQuery + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) fgus ON ' + @entity + '.[StatusId] = fgus.[StatusId] '
	END

SET @TCountQuery = 	@TCountQuery  +' WHERE 1=1 '+ ISNULL(@where, '')
EXEC sp_executesql @TCountQuery, N'@orgId BIGINT, @userId BIGINT, @TotalCount INT OUTPUT', @orgId, @userId, @TotalCount  OUTPUT;

IF(@recordId = 0)
	BEGIN
		SET @sqlCommand = 'SELECT ' + [dbo].[fnGetBaseQueryByUserId](@entity, @userId) 
		--Fetch the Projection list as Id
		SET @sqlCommand = STUFF(@sqlCommand, CHARINDEX(@entity+'.RequirementID', @sqlCommand), LEN(@entity+'.RequirementID'), @entity+'.RequirementID as Id');
		SET @sqlCommand = @sqlCommand + ' , prg.[PrgProgramTitle] AS ProgramIDName '
	END
ELSE
	BEGIN
		IF((@isNext = 0) AND (@isEnd = 0))
			BEGIN
				 SET @sqlCommand = 'SELECT TOP 1 ISNULL(LAG(' + @entity + '.RequirementID) OVER (ORDER BY ' + ISNULL(@orderBy, @entity + '.RequirementID') + '), 0) AS Id '
			END
		ELSE IF((@isNext = 1) AND (@isEnd = 0))
			BEGIN
				 SET @sqlCommand = 'SELECT TOP 1 ISNULL(LEAD(' + @entity + '.RequirementID) OVER (ORDER BY ' + ISNULL(@orderBy, @entity + '.RequirementID') + '), 0) AS Id ' 
			END
		ELSE
			BEGIN
				SET @sqlCommand = 'SELECT TOP 1 ' + @entity + '.RequirementID AS Id '
			END
	END

SET @sqlCommand = @sqlCommand + ' FROM [dbo].[SCR012RequirementList] (NOLOCK) '+ @entity
SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[PRGRM000Master] prg ON '+@entity+'.ProgramID = prg.Id AND prg.PrgOrgID = @orgId '

--Below for getting user specific 'Statuses'
IF((ISNULL(@where, '') = '') OR (@where NOT LIKE '%'+@entity+'.StatusId%'))
	BEGIN
		SET @sqlCommand = @sqlCommand + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) hfk ON ISNULL(' + @entity + '.[StatusId], 1) = hfk.[StatusId] '
	END

SET @sqlCommand = @sqlCommand + ' WHERE 1=1 '

IF((@recordId > 0) AND (((@isNext = 0) AND (@isEnd = 0)) OR ((@isNext = 1) AND (@isEnd = 0))))
	BEGIN
		IF((@isNext = 0) AND (@isEnd = 0))  
   BEGIN  
	IF(ISNULL(@orderBy, '') <> '')
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND ' + @orderBy + ' <= (SELECT ' + @orderBy + ' FROM [dbo].[SCR012RequirementList] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.RequirementID=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
	 END
	ELSE
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND '+@entity+'.RequirementID <= '+ CAST(@recordId AS NVARCHAR(50))  
	 END
   END  
  ELSE IF((@isNext = 1) AND (@isEnd = 0))  
   BEGIN  
    IF(ISNULL(@orderBy, '') <> '')
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND ' + @orderBy + ' >= (SELECT ' + @orderBy + ' FROM [dbo].[SCR012RequirementList] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.RequirementID=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
	 END
	ELSE
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND '+@entity+'.RequirementID >= '+ CAST(@recordId AS NVARCHAR(50))  
	 END
   END   
	END

SET @sqlCommand = @sqlCommand + ISNULL(@where, '') + ' ORDER BY '+ ISNULL(@orderBy, @entity+'.RequirementID')

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

EXEC sp_executesql @sqlCommand, N'@pageNo INT, @pageSize INT, @entity NVARCHAR(100), @orderBy NVARCHAR(500), @where NVARCHAR(500), @orgId BIGINT,@userId BIGINT' ,
	 @entity= @entity,
     @pageNo= @pageNo, 
     @pageSize= @pageSize,
     @orderBy = @orderBy,
     @where = @where,
	 @orgId = @orgId,
	 @userId = @userId
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetScrReturnReasonList]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               10/29/2018      
-- Description:               Get a Scr Return Reason List
-- Execution:                 EXEC [dbo].[GetScrReturnReasonList]   
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)   
-- Modified Desc:  
-- =============================================
ALTER PROCEDURE  [dbo].[GetScrReturnReasonList]
    @userId BIGINT,
    @roleId BIGINT,
	@orgId BIGINT,
    @id BIGINT
AS
BEGIN TRY                
 SET NOCOUNT ON;   
 SELECT scr.[ReturnReasonID] AS Id
		,scr.[ProgramID]
		,scr.[ReturnReasonLineItem]
		,scr.[ReturnReasonCode]
		,scr.[ReturnReasonTitle]
		,scr.[StatusId]
		,scr.[DateEntered]
		,scr.[EnteredBy]
		,scr.[DateChanged]
		,scr.[ChangedBy]
   FROM [dbo].[SCR014ReturnReasonList] scr
  WHERE scr.[ReturnReasonID]=@id
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetScrReturnReasonListView]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               10/29/2018      
-- Description:               Get all Scr Return Reason List
-- Execution:                 EXEC [dbo].[GetScrReturnReasonListView]  
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)  
-- Modified Desc:  
-- =============================================
ALTER PROCEDURE [dbo].[GetScrReturnReasonListView]
 @userId BIGINT,
 @roleId BIGINT,
 @orgId BIGINT,
 @entity NVARCHAR(100),
 @pageNo INT,
 @pageSize INT,
 @orderBy NVARCHAR(500),
 @groupBy NVARCHAR(500), 
 @groupByWhere NVARCHAR(500), 
 @where NVARCHAR(500),
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

  -- Replace Orderby And Where column Name Id with OSDID
 IF(ISNULL(@where, '') <> '')
 BEGIN
    SET @where  = REPLACE(@where, @entity+'.Id',@entity+'.ReturnReasonID');
 END
  IF(ISNULL(@orderBy, '') <> '')
 BEGIN
    SET @orderBy  = REPLACE(@orderBy, @entity+'.Id',@entity+'.ReturnReasonID');
 END

SET @TCountQuery = 'SELECT @TotalCount = COUNT(' + @entity + '.ReturnReasonID) FROM [dbo].[SCR014ReturnReasonList] (NOLOCK) '+ @entity +
				   ' LEFT JOIN [dbo].[PRGRM000Master] prg ON ' + @entity + '.ProgramID = prg.Id AND prg.PrgOrgID = @orgId '

--Below for getting user specific 'Statuses'
IF((ISNULL(@where, '') = '') OR (@where NOT LIKE '%'+@entity+'.StatusId%'))
	BEGIN
		SET @TCountQuery = @TCountQuery + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) fgus ON ' + @entity + '.[StatusId] = fgus.[StatusId] '
	END

SET @TCountQuery = 	@TCountQuery +' WHERE 1=1 '+ ISNULL(@where, '')
EXEC sp_executesql @TCountQuery, N'@orgId BIGINT, @userId BIGINT, @TotalCount INT OUTPUT', @orgId, @userId, @TotalCount  OUTPUT;

IF(@recordId = 0)
	BEGIN
		SET @sqlCommand = 'SELECT ' + [dbo].[fnGetBaseQueryByUserId](@entity, @userId) 
		--Fetch the Projection list as Id
		SET @sqlCommand = STUFF(@sqlCommand, CHARINDEX(@entity+'.ReturnReasonID', @sqlCommand), LEN(@entity+'.ReturnReasonID'), @entity+'.ReturnReasonID as Id');
		SET @sqlCommand = @sqlCommand + ' , prg.[PrgProgramTitle] AS ProgramIDName '
	END
ELSE
	BEGIN
		IF((@isNext = 0) AND (@isEnd = 0))
			BEGIN
				 SET @sqlCommand = 'SELECT TOP 1 ISNULL(LAG(' + @entity + '.ReturnReasonID) OVER (ORDER BY ' + ISNULL(@orderBy, @entity + '.ReturnReasonID') + '), 0) AS Id '
			END
		ELSE IF((@isNext = 1) AND (@isEnd = 0))
			BEGIN
				 SET @sqlCommand = 'SELECT TOP 1 ISNULL(LEAD(' + @entity + '.ReturnReasonID) OVER (ORDER BY ' + ISNULL(@orderBy, @entity + '.ReturnReasonID') + '), 0) AS Id ' 
			END
		ELSE
			BEGIN
				SET @sqlCommand = 'SELECT TOP 1 ' + @entity + '.ReturnReasonID AS Id '
			END
	END

SET @sqlCommand = @sqlCommand + ' FROM [dbo].[SCR014ReturnReasonList] (NOLOCK) '+ @entity
SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[PRGRM000Master] prg ON '+@entity+'.ProgramID = prg.Id AND prg.PrgOrgID = @orgId '

--Below for getting user specific 'Statuses'
IF((ISNULL(@where, '') = '') OR (@where NOT LIKE '%'+@entity+'.StatusId%'))
	BEGIN
		SET @sqlCommand = @sqlCommand + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) hfk ON ISNULL(' + @entity + '.[StatusId], 1) = hfk.[StatusId] '
	END

SET @sqlCommand = @sqlCommand + ' WHERE 1=1 '

IF((@recordId > 0) AND (((@isNext = 0) AND (@isEnd = 0)) OR ((@isNext = 1) AND (@isEnd = 0))))
	BEGIN
		IF((@isNext = 0) AND (@isEnd = 0))  
   BEGIN  
	IF(ISNULL(@orderBy, '') <> '')
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND ' + @orderBy + ' <= (SELECT ' + @orderBy + ' FROM [dbo].[SCR014ReturnReasonList] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.ReturnReasonID=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
	 END
	ELSE
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND '+@entity+'.ReturnReasonID <= '+ CAST(@recordId AS NVARCHAR(50))  
	 END
   END  
  ELSE IF((@isNext = 1) AND (@isEnd = 0))  
   BEGIN  
    IF(ISNULL(@orderBy, '') <> '')
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND ' + @orderBy + ' >= (SELECT ' + @orderBy + ' FROM [dbo].[SCR014ReturnReasonList] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.ReturnReasonID=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
	 END
	ELSE
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND '+@entity+'.ReturnReasonID >= '+ CAST(@recordId AS NVARCHAR(50))  
	 END
   END   
	END

SET @sqlCommand = @sqlCommand + ISNULL(@where, '') + ' ORDER BY '+ ISNULL(@orderBy, @entity+'.ReturnReasonID')

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

EXEC sp_executesql @sqlCommand, N'@pageNo INT, @pageSize INT, @entity NVARCHAR(100), @orderBy NVARCHAR(500), @where NVARCHAR(500), @orgId BIGINT,@userId BIGINT' ,
	 @entity= @entity,
     @pageNo= @pageNo, 
     @pageSize= @pageSize,
     @orderBy = @orderBy,
     @where = @where,
	 @orgId = @orgId,
	 @userId = @userId
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetScrServiceList]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group  
   All Rights Reserved Worldwide */  
-- =============================================          
-- Author:                    Akhil Chauhan           
-- Create date:               10/29/2018        
-- Description:               Get a Scr Service List  
-- Execution:                 EXEC [dbo].[GetScrServiceList]   
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)     
-- Modified Desc:    
-- =============================================  
ALTER PROCEDURE  [dbo].[GetScrServiceList]  
    @userId BIGINT,  
    @roleId BIGINT,  
 @orgId BIGINT,  
    @id BIGINT  
AS  
BEGIN TRY                  
 SET NOCOUNT ON;     
 SELECT scr.[ServiceID] AS Id  
  ,scr.[ProgramID]  
  ,scr.[ServiceLineItem]  
  ,scr.[ServiceCode]  
  ,scr.[ServiceTitle]  
  ,scr.[StatusId]  
  ,scr.[DateEntered]  
  ,scr.[EnteredBy]  
  ,scr.[DateChanged]  
  ,scr.[ChangedBy]  
   FROM [dbo].[SCR013ServiceList] scr  
  WHERE scr.[ServiceID]=@id  
END TRY                  
BEGIN CATCH                  
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                  
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                  
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                  
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                  
END CATCH  
GO
/****** Object:  StoredProcedure [dbo].[GetScrServiceListView]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               10/29/2018      
-- Description:               Get all Scr Service List   
-- Execution:                 EXEC [dbo].[GetScrServiceListView]   
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)   
-- Modified Desc:  
-- =============================================  
ALTER PROCEDURE [dbo].[GetScrServiceListView]
 @userId BIGINT,
 @roleId BIGINT,
 @orgId BIGINT,
 @entity NVARCHAR(100),
 @pageNo INT,
 @pageSize INT,
 @orderBy NVARCHAR(500),
 @groupBy NVARCHAR(500), 
 @groupByWhere NVARCHAR(500), 
 @where NVARCHAR(500),
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

   -- Replace Orderby And Where column Name Id with OSDID
 IF(ISNULL(@where, '') <> '')
 BEGIN
    SET @where  = REPLACE(@where, @entity+'.Id',@entity+'.ServiceID');
 END
  IF(ISNULL(@orderBy, '') <> '')
 BEGIN
    SET @orderBy  = REPLACE(@orderBy, @entity+'.Id',@entity+'.ServiceID');
 END

SET @TCountQuery = 'SELECT @TotalCount = COUNT(' + @entity + '.ServiceID) FROM [dbo].[SCR013ServiceList] (NOLOCK) '+ @entity +
				   ' LEFT JOIN [dbo].[PRGRM000Master] prg ON ' + @entity + '.ProgramID = prg.Id AND prg.PrgOrgID = @orgId '

--Below for getting user specific 'Statuses'
IF((ISNULL(@where, '') = '') OR (@where NOT LIKE '%'+@entity+'.StatusId%'))
	BEGIN
		SET @TCountQuery = @TCountQuery + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) fgus ON ' + @entity + '.[StatusId] = fgus.[StatusId] '
	END

SET @TCountQuery = 	@TCountQuery  +' WHERE 1=1 '+ ISNULL(@where, '')
EXEC sp_executesql @TCountQuery, N'@orgId BIGINT, @userId BIGINT, @TotalCount INT OUTPUT', @orgId, @userId, @TotalCount  OUTPUT;

IF(@recordId = 0)
	BEGIN
		SET @sqlCommand = 'SELECT ' + [dbo].[fnGetBaseQueryByUserId](@entity, @userId) 
		--Fetch the Projection list as Id
		SET @sqlCommand = STUFF(@sqlCommand, CHARINDEX(@entity+'.ServiceID', @sqlCommand), LEN(@entity+'.ServiceID'), @entity+'.ServiceID as Id');
		SET @sqlCommand = @sqlCommand + ' , prg.[PrgProgramTitle] AS ProgramIDName '
	END
ELSE
	BEGIN
		IF((@isNext = 0) AND (@isEnd = 0))
			BEGIN
				 SET @sqlCommand = 'SELECT TOP 1 ISNULL(LAG(' + @entity + '.ServiceID) OVER (ORDER BY ' + ISNULL(@orderBy, @entity + '.ServiceID') + '), 0) AS Id '
			END
		ELSE IF((@isNext = 1) AND (@isEnd = 0))
			BEGIN
				 SET @sqlCommand = 'SELECT TOP 1 ISNULL(LEAD(' + @entity + '.ServiceID) OVER (ORDER BY ' + ISNULL(@orderBy, @entity + '.ServiceID') + '), 0) AS Id ' 
			END
		ELSE
			BEGIN
				SET @sqlCommand = 'SELECT TOP 1 ' + @entity + '.ServiceID AS Id '
			END
	END

SET @sqlCommand = @sqlCommand + ' FROM [dbo].[SCR013ServiceList] (NOLOCK) '+ @entity
SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[PRGRM000Master] prg ON '+@entity+'.ProgramID = prg.Id AND prg.PrgOrgID = @orgId '

--Below for getting user specific 'Statuses'
IF((ISNULL(@where, '') = '') OR (@where NOT LIKE '%'+@entity+'.StatusId%'))
	BEGIN
		SET @sqlCommand = @sqlCommand + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) hfk ON ISNULL(' + @entity + '.[StatusId], 1) = hfk.[StatusId] '
	END

SET @sqlCommand = @sqlCommand + ' WHERE 1=1 '

IF((@recordId > 0) AND (((@isNext = 0) AND (@isEnd = 0)) OR ((@isNext = 1) AND (@isEnd = 0))))
	BEGIN
		IF((@isNext = 0) AND (@isEnd = 0))  
   BEGIN  
	IF(ISNULL(@orderBy, '') <> '')
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND ' + @orderBy + ' <= (SELECT ' + @orderBy + ' FROM [dbo].[SCR013ServiceList] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.ServiceID=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
	 END
	ELSE
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND '+@entity+'.ServiceID <= '+ CAST(@recordId AS NVARCHAR(50))  
	 END
   END  
  ELSE IF((@isNext = 1) AND (@isEnd = 0))  
   BEGIN  
    IF(ISNULL(@orderBy, '') <> '')
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND ' + @orderBy + ' >= (SELECT ' + @orderBy + ' FROM [dbo].[SCR013ServiceList] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.ServiceID=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
	 END
	ELSE
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND '+@entity+'.ServiceID >= '+ CAST(@recordId AS NVARCHAR(50))  
	 END
   END   
	END

SET @sqlCommand = @sqlCommand + ISNULL(@where, '') + ' ORDER BY '+ ISNULL(@orderBy, @entity+'.ServiceID')

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

EXEC sp_executesql @sqlCommand, N'@pageNo INT, @pageSize INT, @entity NVARCHAR(100), @orderBy NVARCHAR(500), @where NVARCHAR(500), @orgId BIGINT,@userId BIGINT' ,
	 @entity= @entity,
     @pageNo= @pageNo, 
     @pageSize= @pageSize,
     @orderBy = @orderBy,
     @where = @where,
	 @orgId = @orgId,
	 @userId = @userId
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetSecurityByRole]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               10/22/2018      
-- Description:               Get a security by role   
-- Execution:                 EXEC [dbo].[GetSecurityByRole]   
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)    
-- Modified Desc:  
-- =============================================  
ALTER PROCEDURE  [dbo].[GetSecurityByRole]
    @userId BIGINT,
    @roleId BIGINT,
	@orgId BIGINT,
    @id BIGINT
AS
BEGIN TRY                
 SET NOCOUNT ON;   
  SELECT syst.[Id]
		,syst.[OrgRefRoleId]
		,syst.[SecLineOrder]
		,syst.[SecMainModuleId]
		,syst.[SecMenuOptionLevelId]
		,syst.[SecMenuAccessLevelId]
		,syst.[DateEntered]
		,syst.[EnteredBy]
		,syst.[DateChanged]
		,syst.[ChangedBy]
   FROM [dbo].[SYSTM000SecurityByRole] syst
 WHERE [Id] = @id
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetSecurityByRoleView]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               10/22/2018      
-- Description:               Get all security by role  
-- Execution:                 EXEC [dbo].[GetSecurityByRoleView]   
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)   
-- Modified Desc:  
-- =============================================       
ALTER PROCEDURE [dbo].[GetSecurityByRoleView]    
 @userId BIGINT,    
 @roleId BIGINT,    
 @orgId BIGINT,    
 @entity NVARCHAR(100),    
 @pageNo INT,    
 @pageSize INT,    
 @orderBy NVARCHAR(500), 
 @groupBy NVARCHAR(500), 
 @groupByWhere NVARCHAR(500),    
 @where NVARCHAR(500),    
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
    
SET @TCountQuery = 'SELECT @TotalCount = COUNT(Id) FROM [dbo].[SYSTM000SecurityByRole] (NOLOCK) '+ @entity +' WHERE OrgRefRoleId =@parentId AND ISNULL('+@entity+'.StatusId, 1) < 3 ' + ISNULL(@where, '')    
EXEC sp_executesql @TCountQuery, N'@parentId BIGINT,@TotalCount INT OUTPUT',@parentId , @TotalCount  OUTPUT;    
    
IF(@recordId = 0)    
 BEGIN    
  SET @sqlCommand = 'SELECT ' + [dbo].[fnGetBaseQueryByUserId](@entity, @userId)     
  SET @sqlCommand = @sqlCommand + ' , rol.OrgRoleCode as OrgRefRoleIdName '    
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
    
SET @sqlCommand = @sqlCommand + ' FROM [dbo].[SYSTM000SecurityByRole] (NOLOCK) '+ @entity    
    
--Below to get BIGINT reference key name by Id if NOT NULL    
SET @sqlCommand = @sqlCommand + ' INNER JOIN [dbo].[ORGAN010Ref_Roles] (NOLOCK) rol ON ' + @entity + '.[OrgRefRoleId] = rol.[Id] '  
SET @sqlCommand = @sqlCommand + ' WHERE '+@entity+'.OrgRefRoleId =@parentId AND ISNULL('+@entity+'.StatusId, 1) < 3 ' + ISNULL(@where, '')    
    
IF((@recordId > 0) AND (((@isNext = 0) AND (@isEnd = 0)) OR ((@isNext = 1) AND (@isEnd = 0))))    
 BEGIN    
  IF((@isNext = 0) AND (@isEnd = 0))  
   BEGIN  
	IF(ISNULL(@orderBy, '') <> '')
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND ' + @orderBy + ' <= (SELECT ' + @orderBy + ' FROM [dbo].[SYSTM000SecurityByRole] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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
		SET @sqlCommand = @sqlCommand + ' AND ' + @orderBy + ' >= (SELECT ' + @orderBy + ' FROM [dbo].[SYSTM000SecurityByRole] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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
   
EXEC sp_executesql @sqlCommand, N'@pageNo INT, @pageSize INT,@orderBy NVARCHAR(500), @where NVARCHAR(500), @entity NVARCHAR(100) ,@parentId BIGINT' ,    
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
/****** Object:  StoredProcedure [dbo].[GetSelectedFieldsByTable]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group  
   All Rights Reserved Worldwide */  
-- =============================================          
-- Author:                    Akhil Chauhan           
-- Create date:               12/07/2018        
-- Description:               Get selected records by table    
-- Execution:                 EXEC [dbo].[GetSelectedFieldsByTable]     
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)      
-- Modified Desc:    
-- =============================================                              
ALTER PROCEDURE [dbo].[GetSelectedFieldsByTable]  
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
 @userId BIGINT=null,
 @entityFor NVARCHAR(50)=NULL
AS                    
BEGIN TRY                    
SET NOCOUNT ON;      
 DECLARE @sqlCommand NVARCHAR(MAX);    
 DECLARE @tableName NVARCHAR(100)    
 DECLARE @newPgNo INT  

  SELECT @tableName = [TblTableName] FROM [dbo].[SYSTM000Ref_Table] Where SysRefName = @entity  
 SET @sqlCommand = '';  
  if @entityFor='OrgRolesResp'
  BEGIN
  SET @entityFor='OrgActRole'
  END

 IF(ISNULL(@primaryKeyValue, '') <> '')  
 BEGIN  
 SET @sqlCommand += ' SELECT @newPgNo = Item FROM (SELECT ROW_NUMBER() OVER(ORDER BY ' + @entity + '.' + @primaryKeyName+') as Item  ,' +@entity + '.' + @primaryKeyName +   
        ' From '+ @tableName +' (NOLOCK) ' + @entity  
  
 IF  COL_LENGTH(@tableName, 'StatusId') IS NOT NULL  
  BEGIN    
     SET @sqlCommand = @sqlCommand + ' WHERE ISNULL('+ @entity +'.StatusId, 1) In (1,2)';  
  END  
   
 SET @sqlCommand += ' ) t WHERE t.' + @primaryKeyName + '=' + @primaryKeyValue;  
 EXEC sp_executesql @sqlCommand, N' @newPgNo int output',@newPgNo output                                      
    SET @newPgNo =  @newPgNo/@pageSize + 1;   
 SET @pageSize = @newPgNo * @pageSize;  
 SET @sqlCommand=''  
 END  
 
 IF @entityFor='OrgActRole' 
 BEGIN
  SET @sqlCommand += 'SELECT DISTINCT '+ @fields +' FROM '+ @tableName + ' (NOLOCK) '+  @entity + ' JOIN [dbo].[ORGAN020Act_Roles] '+ @entityFor+' ON '+@entityFor+'.OrgRefRoleId='+@entity+'.id'+
  ' JOIN [dbo].[fnGetUserStatuses]('+CAST(@userId AS VARCHAR(10))+') fgus ON ISNULL( '+@entityFor+'.[StatusId], 1) = fgus.[StatusId] WHERE 1=1 AND ISNULL('+@entityFor+'.[StatusId],1) IN (1,2) '--AND ACTR.OrgID=' +CAST(@orgId AS VARCHAR(10))+' '
 END
 ELSE
 BEGIN 
 SET @sqlCommand += 'SELECT '+ @fields +' FROM '+ @tableName + ' (NOLOCK) '+  @entity + ' WHERE 1=1 '    
 END
 IF @entity = 'Program'
 BEGIN
    DECLARE @queryFil NVARCHAR(MAX) = '  CASE WHEN '+  @entity + '.PrgHierarchyLevel = 1 THEN '+  @entity + '.PrgProgramCode
                                  WHEN '+  @entity + '.PrgHierarchyLevel = 2 THEN '+  @entity + '.PrgProjectCode
							 WHEN '+  @entity + '.PrgHierarchyLevel = 3 THEN '+  @entity + '.PrgPhaseCode
							 ELSE '+  @entity + '.PrgProgramTitle END  AS PrgProgramCode '

     SET @sqlCommand = REPLACE(@sqlCommand, +  @entity + '.PrgProgramCode',@queryFil); 
 END


   
 IF  COL_LENGTH(@tableName, 'StatusId') IS NOT NULL AND @entity<>'OrgRefRole'
 BEGIN    
    SET @sqlCommand = @sqlCommand + ' AND ISNULL(StatusId, 1) In (1,2)';  
 END  
  
 IF(ISNULL(@like, '') != '')    
  BEGIN    
  SET @sqlCommand = @sqlCommand + 'AND ('    
   DECLARE @likeStmt NVARCHAR(MAX)    
    
  SELECT @likeStmt = COALESCE(@likeStmt + ' OR ','') + Item + ' LIKE ''%' + @like + '%' + '''' FROM [dbo].[fnSplitString](@fields, ',')      
  SET @sqlCommand = @sqlCommand + @likeStmt + ') '    
  END    
 IF(ISNULL(@where, '') != '')    
  BEGIN    
     SET @sqlCommand = @sqlCommand + @where     
 END    
print @sqlCommand
SET @sqlCommand = @sqlCommand + ' ORDER BY '+ @fields +' OFFSET @pageSize * (@pageNo - 1) ROWS FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);'     
   
EXEC sp_executesql @sqlCommand, N'@pageNo INT, @pageSize INT, @where NVARCHAR(100)' ,    
     @pageNo = @pageNo,     
     @pageSize = @pageSize,    
     @where = @where  
END TRY                    
BEGIN CATCH                    
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                    
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                    
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                    
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                    
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetStatesDropDown]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               12/07/2018      
-- Description:               Get selected records by table
-- Execution:                 EXEC [dbo].[GetStatesDropDown]   
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)   
-- Modified Desc:  
-- =============================================                          
ALTER PROCEDURE [dbo].[GetStatesDropDown]
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
 @primaryKeyName NVARCHAR(50) = null  
AS                
BEGIN TRY                
SET NOCOUNT ON;  
 DECLARE @sqlCommand NVARCHAR(MAX);
 DECLARE @newPgNo INT
 SET @sqlCommand = '';

 IF(ISNULL(@primaryKeyValue, '') > '')
 BEGIN
	SET @sqlCommand += ' SELECT @newPgNo = Item FROM (SELECT ROW_NUMBER() OVER(ORDER BY ' + @entity + '.' + @primaryKeyName+') as Item  ,' +@entity + '.' + @primaryKeyName + 
					   ' From [dbo].[SYSTM000Ref_States] (NOLOCK) ' + @entity + ' JOIN [dbo].[SYSTM000Ref_Options] (NOLOCK) sysRef ON ' + @entity + '.[StateCountryId]=sysRef.Id WHERE '+ @entity +'.StatusId In (1,2)' +
					   ' ) t WHERE t.' + @primaryKeyName + '=''' + @primaryKeyValue + '''';
	EXEC sp_executesql @sqlCommand, N' @newPgNo int output',@newPgNo output                                    
    SET @newPgNo =  @newPgNo/@pageSize + 1; 
	SET @pageSize = @newPgNo * @pageSize;
	SET @sqlCommand=''
 END

 SET @sqlCommand = 'SELECT '+ @fields +', sysRef.[SysOptionName] as Country FROM [dbo].[SYSTM000Ref_States] (NOLOCK) '+  @entity 
 SET @sqlCommand += ' JOIN [dbo].[SYSTM000Ref_Options] (NOLOCK) sysRef ON ' + @entity + '.[StateCountryId]=sysRef.Id WHERE 1=1 AND ' + @entity + '.StatusId In (1,2) '

 IF(ISNULL(@like, '') != '')
 	BEGIN
 	SET @sqlCommand = @sqlCommand + 'AND ('
 	 DECLARE @likeStmt NVARCHAR(MAX)
 	SELECT @likeStmt = COALESCE(@likeStmt + ' OR ','') + Item + ' LIKE ''%' + @like + '%' + '''' FROM [dbo].[fnSplitString](@fields, ',')
 	SET @sqlCommand = @sqlCommand + @likeStmt + ')'
 	END
 IF(ISNULL(@where, '') != '')
 	BEGIN
 		IF(ISNULL(@like, '') != '')
 			BEGIN
 				SET @sqlCommand = @sqlCommand + ' AND (' + @where +')'
 			END
 		ELSE
 			BEGIN
 				SET @sqlCommand = @sqlCommand + @where 
 			END
 END

SET @sqlCommand = @sqlCommand + ' ORDER BY '+ @fields +' OFFSET @pageSize * (@pageNo - 1) ROWS FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);' 

EXEC sp_executesql @sqlCommand, N'@pageNo INT, @pageSize INT, @where NVARCHAR(100)' ,
     @pageNo = @pageNo, 
     @pageSize = @pageSize,
     @where = @where
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetSubSecurityByRole]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               09/22/2018      
-- Description:               Get a subsecurity by role
-- Execution:                 EXEC [dbo].[GetSubSecurityByRole]   
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)    
-- Modified Desc:  
-- ============================================= 
ALTER PROCEDURE  [dbo].[GetSubSecurityByRole]
    @userId BIGINT,
    @roleId BIGINT,
	@orgId BIGINT,
    @id BIGINT
AS
BEGIN TRY                
 SET NOCOUNT ON;   
  SELECT syst.[Id]
		 ,syst.[SecByRoleId]  
		  ,syst.[RefTableName]
		  ,syst.[SubsMenuOptionLevelId]  
		  ,syst.[SubsMenuAccessLevelId]  
		  ,syst.[StatusId]  
		  ,syst.[DateEntered]  
		  ,syst.[EnteredBy]  
		  ,syst.[DateChanged]  
		  ,syst.[ChangedBy]  
  FROM [dbo].[SYSTM010SubSecurityByRole] syst  
 WHERE syst.[Id] = @id
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetSubSecurityByRoleView]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               09/22/2018      
-- Description:               Get all subsecurity by role
-- Execution:                 EXEC [dbo].[GetSubSecurityByRoleView]   
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)   
-- Modified Desc:  
-- ============================================= 
ALTER PROCEDURE [dbo].[GetSubSecurityByRoleView]
 @userId BIGINT,
 @roleId BIGINT,
 @orgId BIGINT,
 @entity NVARCHAR(100),
 @pageNo INT,
 @pageSize INT,
 @orderBy NVARCHAR(500),
 @groupBy NVARCHAR(500), 
 @groupByWhere NVARCHAR(500), 
 @where NVARCHAR(500),
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

SET @TCountQuery = 'SELECT @TotalCount = COUNT('+@entity+'.Id) FROM [dbo].[SYSTM010SubSecurityByRole] (NOLOCK) '+ @entity 
				   + ' INNER JOIN [dbo].[SYSTM000SecurityByRole] sr ON '+@entity+'.[SecByRoleId]=sr.[Id]'
				   + ' WHERE sr.Id=@parentId AND ISNULL('+@entity+'.StatusId, 1)<3 ' + ISNULL(@where, '')

EXEC sp_executesql @TCountQuery, N'@parentId BIGINT, @TotalCount INT OUTPUT', @parentId, @TotalCount  OUTPUT;

IF(@recordId = 0)
	BEGIN
		SET @sqlCommand = 'SELECT ' + [dbo].[fnGetBaseQueryByUserId](@entity, @userId) 
		SET @sqlCommand = @sqlCommand + ' ,orgRoles.OrgRoleCode AS SecByRoleIdName '
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

SET @sqlCommand = @sqlCommand + ' FROM [dbo].[SYSTM010SubSecurityByRole] (NOLOCK) '+ @entity

--Below to get BIGINT reference key name by Id if NOT NULL
SET @sqlCommand = @sqlCommand + ' INNER JOIN [dbo].[SYSTM000SecurityByRole] (NOLOCK) sec ON ' + @entity + '.[SecByRoleId]=sec.[Id] '
SET @sqlCommand = @sqlCommand + ' INNER JOIN [dbo].[ORGAN010Ref_Roles] (NOLOCK) orgRoles ON sec.[OrgRefRoleId] = orgRoles.Id '

SET @sqlCommand = @sqlCommand + ' WHERE sec.Id=@parentId AND ISNULL(' + @entity + '.StatusId, 1)<3 '+ ISNULL(@where, '')

IF((@recordId > 0) AND (((@isNext = 0) AND (@isEnd = 0)) OR ((@isNext = 1) AND (@isEnd = 0))))
	BEGIN
		IF((@isNext = 0) AND (@isEnd = 0))  
   BEGIN  
	IF(ISNULL(@orderBy, '') <> '')
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND ' + @orderBy + ' <= (SELECT ' + @orderBy + ' FROM [dbo].[SYSTM010SubSecurityByRole] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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
		SET @sqlCommand = @sqlCommand + ' AND ' + @orderBy + ' >= (SELECT ' + @orderBy + ' FROM [dbo].[SYSTM010SubSecurityByRole] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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

EXEC sp_executesql @sqlCommand, N'@pageNo INT, @pageSize INT,@orderBy NVARCHAR(500), @where NVARCHAR(500), @entity NVARCHAR(100), @parentId BIGINT' ,
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
/****** Object:  StoredProcedure [dbo].[GetSysRefDropDown]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               12/07/2018      
-- Description:               Get selected records for system reference
-- Execution:                 EXEC [dbo].[GetSysRefDropDown]  
-- Modified on:  
-- Modified Desc:  
-- =============================================                         
ALTER PROCEDURE [dbo].[GetSysRefDropDown]
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
 @primaryKeyName NVARCHAR(50) = null  
AS                
BEGIN TRY                
SET NOCOUNT ON;  
 DECLARE @sqlCommand NVARCHAR(MAX);
 DECLARE @newPgNo INT
 SET @sqlCommand = '';

 IF(ISNULL(@primaryKeyValue, '') > '')
 BEGIN
	IF(@langCode='EN')
		BEGIN
			SET @sqlCommand += ' SELECT @newPgNo = Item FROM (SELECT ROW_NUMBER() OVER(ORDER BY ' + @entity + '.' + @primaryKeyName+') as Item  ,' +@entity + '.' + @primaryKeyName + 
							   ' From [dbo].[SYSTM000Ref_Options] (NOLOCK) ' + @entity + ' WHERE '+ @entity +'.StatusId In (1,2)' +
							   ' ) t WHERE t.' + @primaryKeyName + '=' + @primaryKeyValue;
			EXEC sp_executesql @sqlCommand, N' @newPgNo int output',@newPgNo output                                    
			SET @newPgNo =  @newPgNo/@pageSize + 1; 
			SET @pageSize = @newPgNo * @pageSize;
			SET @sqlCommand=''
		END
	ELSE
		BEGIN
			SET @sqlCommand += ' SELECT @newPgNo = Item FROM (SELECT ROW_NUMBER() OVER(ORDER BY refOpLang.SysRefId) as Item  , refOpLang.SysRefId as Id '+ 
						   ' From [dbo].[SYSTM010Ref_Options] (NOLOCK) refOpLang INNER JOIN [dbo].[SYSTM000Ref_Options] (NOLOCK) ' + @entity + 
						   ' ON '+ @entity +'.Id = refOpLang.SysRefId WHERE '+ @entity +'.StatusId In (1,2)' +
						   ' ) t WHERE t.' + @primaryKeyName + '=' + @primaryKeyValue;
			EXEC sp_executesql @sqlCommand, N' @newPgNo int output',@newPgNo output                                    
			SET @newPgNo =  @newPgNo/@pageSize + 1; 
			SET @pageSize = @newPgNo * @pageSize;
			SET @sqlCommand=''
		END
 END

IF(@langCode='EN')
	BEGIN
		SET @sqlCommand = 'SELECT '+ @fields + ' FROM [dbo].[SYSTM000Ref_Options] (NOLOCK) '+  @entity  + ' WHERE 1=1 '
	END
ELSE
	BEGIN
		SET @sqlCommand = 'SELECT refOpLang.SysRefId as Id,  refOp.LookupName,  refOpLang.SysLookupCode, refOpLang.SysOptionName, refOp.SysDefault, refOp. IsSysAdmin FROM [dbo].[SYSTM010Ref_Options] (NOLOCK)  refOpLang'
		SET @sqlCommand = @sqlCommand + ' INNER JOIN [dbo].[SYSTM000Ref_Options] (NOLOCK) ' + @entity + ' ON '+@entity+'.Id = refOpLang.SysRefId WHERE 1=1 '
	END

IF(ISNULL(@like, '') != '')
		BEGIN
		SET @sqlCommand = @sqlCommand + 'AND ('
		 DECLARE @likeStmt NVARCHAR(MAX)
		SELECT @likeStmt = COALESCE(@likeStmt + ' OR ','') + Item + ' LIKE ''%' + @like + '%' + '''' FROM [dbo].[fnSplitString](@fields, ',')
		SET @sqlCommand = @sqlCommand + @likeStmt + ')'
		END
IF(ISNULL(@where, '') != '')
	BEGIN
		IF(ISNULL(@like, '') != '')
			BEGIN
				SET @sqlCommand = @sqlCommand + ' AND (' + @where +')'
			END
		ELSE
			BEGIN
				SET @sqlCommand = @sqlCommand + @where 
			END
END

SET @sqlCommand = @sqlCommand + ' ORDER BY '+ @fields +' OFFSET @pageSize * (@pageNo - 1) ROWS FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);' 

EXEC sp_executesql @sqlCommand, N'@pageNo INT, @pageSize INT, @where NVARCHAR(100)' ,
     @pageNo = @pageNo, 
     @pageSize = @pageSize,
     @where = @where
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetSysRefOption]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               08/16/2018      
-- Description:               Get a Sys Ref Option
-- Execution:                 EXEC [dbo].[GetSysRefOption]  
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)    
-- Modified Desc:  
-- =============================================
ALTER PROCEDURE  [dbo].[GetSysRefOption]
    @userId BIGINT,
    @roleId BIGINT,
	@orgId BIGINT,
    @langCode NVARCHAR(10),
    @id BIGINT
AS
BEGIN TRY                
 SET NOCOUNT ON;   
IF(@langCode='EN')
 BEGIN
SELECT refOp.[Id]
	,refOp.[SysLookupId]
	,refOp.[SysOptionName]
	,refOp.[SysSortOrder]
	,refOp.[SysDefault]
	,refOp.[IsSysAdmin]
	,refOp.[StatusId]
	,refOp.[DateEntered]
	,refOp.[EnteredBy]
	,refOp.[DateChanged]
	,refOp.[ChangedBy]
	,lkup.[LkupCode] as LookupIdName
  FROM [dbo].[SYSTM000Ref_Options] (NOLOCK) refOp
  INNER JOIN [dbo].[SYSTM000Ref_Lookup] (NOLOCK) lkup ON lkup.Id = refOp.SysLookupId
 WHERE refOp.[Id]=@id 
END
ELSE
 BEGIN
SELECT refOp.[Id]
	,refOp.[SysLookupId]
	,refOpLang.[SysOptionName]
	,refOp.[SysSortOrder]
	,refOp.[SysDefault]
	,refOp.[IsSysAdmin]
	,refOp.[StatusId]
	,refOp.[DateEntered]
	,refOp.[EnteredBy]
	,refOp.[DateChanged]
	,refOp.[ChangedBy]
	,lkup.[LkupCode] as LookupIdName
  FROM [dbo].[SYSTM000Ref_Options] (NOLOCK) refOp
 INNER JOIN [dbo].[SYSTM010Ref_Options] refOpLang ON refOp.Id = refOpLang.[SysRefId]
 INNER JOIN [dbo].[SYSTM000Ref_Lookup] (NOLOCK) lkup ON lkup.Id = refOp.SysLookupId
 WHERE refOp.[Id]=@id AND refOpLang.LangCode=@langCode
 END
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetSysRefOptionView]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               09/23/2018      
-- Description:               Get all sys ref option
-- Execution:                 EXEC [dbo].[GetSysRefOptionView]  
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)   
-- Modified Desc:  
-- =============================================      
ALTER PROCEDURE [dbo].[GetSysRefOptionView]    
 @userId BIGINT,    
 @roleId BIGINT,    
 @orgId BIGINT,    
 @langCode NVARCHAR(10),    
 @entity NVARCHAR(100),    
 @pageNo INT,    
 @pageSize INT,    
 @orderBy NVARCHAR(500),
 @groupBy NVARCHAR(500), 
 @groupByWhere NVARCHAR(500),     
 @where NVARCHAR(500),    
 @parentId BIGINT,    
 @referenceType NVARCHAR(100)=NULL,   
 @isNext BIT,  
 @isEnd BIT,  
 @recordId BIGINT,   
 @TotalCount INT OUTPUT    
AS    
BEGIN TRY   
SET NOCOUNT ON;    
 DECLARE @sqlCommand NVARCHAR(MAX);  
 DECLARE @TCountQuery NVARCHAR(MAX);  
  
SET @TCountQuery = 'SELECT @TotalCount = COUNT(Id) FROM [dbo].[SYSTM000Ref_Options] (NOLOCK) '+ @entity 


--Below for getting user specific 'Statuses'      
 IF((ISNULL(@where, '') = '') OR (@where NOT LIKE '%'+@entity+'.StatusId%'))      
  BEGIN      
   SET @TCountQuery = @TCountQuery + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) fgus ON ISNULL(' + @entity + '.[StatusId], 1) = fgus.[StatusId] '
  END 

SET @TCountQuery = @TCountQuery +' WHERE 1 = 1 ' + ISNULL(@where, '')  


EXEC sp_executesql @TCountQuery, N'@langCode NVARCHAR(10), @userId BIGINT, @TotalCount INT OUTPUT', @langCode, @userId, @TotalCount  OUTPUT;  
  
IF(@recordId = 0)  
 BEGIN  
  SET @sqlCommand = 'SELECT ' + [dbo].[fnGetBaseQueryByUserId](@entity, @userId)   
  SET @sqlCommand = @sqlCommand + ' , lkup.[LkupCode] as LookupIdName '  
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
  
SET @sqlCommand = @sqlCommand + ' FROM [dbo].[SYSTM000Ref_Options] (NOLOCK) '+ @entity  
SET @sqlCommand = @sqlCommand + ' INNER JOIN [dbo].[SYSTM000Ref_Lookup] (NOLOCK) lkup ON ' + @entity + '.[SysLookupId] = lkup.[Id] ' 

--Below for getting user specific 'Statuses'      
IF((ISNULL(@where, '') = '') OR (@where NOT LIKE '%'+@entity+'.StatusId%'))      
 BEGIN      
  SET @sqlCommand = @sqlCommand + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) hfk ON ISNULL(' + @entity + '.[StatusId], 1) = hfk.[StatusId] '      
 END 
 
SET @sqlCommand = @sqlCommand + ' WHERE 1 = 1 ' + ISNULL(@where, '')   
  
IF((@recordId > 0) AND (((@isNext = 0) AND (@isEnd = 0)) OR ((@isNext = 1) AND (@isEnd = 0))))  
 BEGIN  
  IF((@isNext = 0) AND (@isEnd = 0))  
   BEGIN  
	IF(ISNULL(@orderBy, '') <> '')
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND ' + @orderBy + ' <= (SELECT ' + @orderBy + ' FROM [dbo].[SYSTM000Ref_Options] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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
		SET @sqlCommand = @sqlCommand + ' AND ' + @orderBy + ' >= (SELECT ' + @orderBy + ' FROM [dbo].[SYSTM000Ref_Options] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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
 
EXEC sp_executesql @sqlCommand, N'@pageNo INT, @pageSize INT, @langCode NVARCHAR(10),@orderBy NVARCHAR(500), @where NVARCHAR(500), @entity NVARCHAR(100), @userId BIGINT' ,  
     @langCode= @langCode,  
  @entity= @entity,  
     @pageNo= @pageNo,   
     @pageSize= @pageSize,  
     @orderBy = @orderBy,  
     @where = @where,
	 @userId = @userId  
END TRY                  
BEGIN CATCH                  
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                  
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                  
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                  
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                  
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetSysRefTabPageName]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               09/22/2018      
-- Description:               Get a Sys Ref ref tab page name
-- Execution:                 EXEC [dbo].[GetSysRefTabPageName]  
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)    
-- Modified Desc:  
-- =============================================  
ALTER PROCEDURE  [dbo].[GetSysRefTabPageName]
    @userId BIGINT,
    @roleId BIGINT,
	@orgId BIGINT,
    @langCode NVARCHAR(10),
    @id BIGINT
AS
BEGIN TRY                
 SET NOCOUNT ON;   
	SELECT refTpn.[Id]
		,refTpn.[LangCode]
		,refTpn.[RefTableName]
		,refTpn.[TabSortOrder]
		,refTpn.[TabTableName]
		,refTpn.[TabPageTitle]
		,refTpn.[TabExecuteProgram]
		,refTpn.[TabPageIcon]
		,refTpn.[StatusId]
		,refTpn.[DateEntered]
		,refTpn.[EnteredBy]
		,refTpn.[DateChanged]
		,refTpn.[ChangedBy]
 FROM [dbo].[SYSTM030Ref_TabPageName] refTpn
 WHERE [Id]=@id AND refTpn.LangCode= @langCode
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetSysRefTabPageNameView]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               09/22/2018      
-- Description:               Get all system ref tab page name
-- Execution:                 EXEC [dbo].[GetSysRefTabPageNameView]  
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)    
-- Modified Desc:  
-- ============================================= 
ALTER PROCEDURE [dbo].[GetSysRefTabPageNameView]
 @userId BIGINT,
 @roleId BIGINT,
 @orgId BIGINT,
 @langCode NVARCHAR(10),
 @entity NVARCHAR(100),
 @pageNo INT,
 @pageSize INT,
 @orderBy NVARCHAR(500),
 @groupBy NVARCHAR(500), 
 @groupByWhere NVARCHAR(500), 
 @where NVARCHAR(500),
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

SET @TCountQuery = 'SELECT @TotalCount = COUNT(Id) FROM [dbo].[SYSTM030Ref_TabPageName] (NOLOCK) '+ @entity +' WHERE [LangCode] = @langCode ' + ISNULL(@where, '')
EXEC sp_executesql @TCountQuery, N'@langCode NVARCHAR(10), @TotalCount INT OUTPUT', @langCode, @TotalCount  OUTPUT;

IF(@recordId = 0)
	BEGIN
		SET @sqlCommand = 'SELECT ' + [dbo].[fnGetBaseQueryByUserId](@entity, @userId) 
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

SET @sqlCommand = @sqlCommand + ' FROM [dbo].[SYSTM030Ref_TabPageName] (NOLOCK) '+ @entity
SET @sqlCommand = @sqlCommand + ' WHERE '+@entity+'.[LangCode] = @langCode '+ ISNULL(@where, '') 

IF((@recordId > 0) AND (((@isNext = 0) AND (@isEnd = 0)) OR ((@isNext = 1) AND (@isEnd = 0))))
	BEGIN
		IF((@isNext = 0) AND (@isEnd = 0))  
   BEGIN  
	IF(ISNULL(@orderBy, '') <> '')
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND ' + @orderBy + ' <= (SELECT ' + @orderBy + ' FROM [dbo].[SYSTM030Ref_TabPageName] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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
		SET @sqlCommand = @sqlCommand + ' AND ' + @orderBy + ' >= (SELECT ' + @orderBy + ' FROM [dbo].[SYSTM030Ref_TabPageName] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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

print @sqlCommand

EXEC sp_executesql @sqlCommand, N'@pageNo INT, @pageSize INT, @langCode NVARCHAR(10),@orderBy NVARCHAR(500), @where NVARCHAR(500), @entity NVARCHAR(100)' ,
     @langCode= @langCode,
	 @entity= @entity,
     @pageNo= @pageNo, 
     @pageSize= @pageSize,
     @orderBy = @orderBy,
     @where = @where
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetSystemAccount]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Janardana Behara        
-- Create date:               12/17/2018      
-- Description:               Get a System Account
-- Execution:                 EXEC [dbo].[GetSystemAccount] 
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)    
-- Modified Desc:  
-- =============================================    
ALTER PROCEDURE  [dbo].[GetSystemAccount]    
	@userId BIGINT,    
	@roleId BIGINT,    
	@orgId BIGINT,   
	@langCode NVARCHAR(10),        
	@id BIGINT    
AS    
BEGIN TRY                    
 SET NOCOUNT ON;       
  SELECT [Id]    
      ,[SysUserContactID]    
      ,[SysScreenName]    
      ,[SysPassword]    
      ,[SysOrgId]    
      ,[SysOrgRefRoleId]    
      ,[IsSysAdmin]    
      ,[SysAttempts]    
      ,[SysLoggedIn]    
      ,[SysLoggedInCount]    
      ,[SysDateLastAttempt]    
      ,[SysLoggedInStart]    
      ,[SysLoggedInEnd]    
      ,[StatusId]    
      ,[DateEntered]    
      ,[EnteredBy]    
      ,[DateChanged]    
      ,[ChangedBy]   
  FROM [dbo].[SYSTM000OpnSezMe]    
 WHERE [Id]=@id    
END TRY                    
BEGIN CATCH                    
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                    
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                    
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                    
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                    
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetSystemAccountView]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Janardana Behara        
-- Create date:               12/17/2018      
-- Description:               Get all System Account
-- Execution:                 EXEC [dbo].[GetSystemAccountView] 
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)    
-- Modified Desc:  
-- =============================================        
ALTER PROCEDURE [dbo].[GetSystemAccountView]      
 @userId BIGINT,      
 @roleId BIGINT,      
 @orgId BIGINT,      
 @entity NVARCHAR(100),      
 @pageNo INT,      
 @pageSize INT,      
 @orderBy NVARCHAR(500), 
 @groupBy NVARCHAR(500), 
 @groupByWhere NVARCHAR(500),      
 @where NVARCHAR(500),      
 @parentId BIGINT,      
 @isNext BIT,      
 @isEnd BIT,      
 @recordId BIGINT,     
 @langCode NVARCHAR(10),       
 @TotalCount INT OUTPUT      
AS      
BEGIN TRY                      
 SET NOCOUNT ON;        
 DECLARE @sqlCommand NVARCHAR(MAX);      
 DECLARE @TCountQuery NVARCHAR(MAX);      
      
SET @TCountQuery = 'SELECT @TotalCount = COUNT('+@entity+'.Id) FROM [dbo].[SYSTM000OpnSezMe] (NOLOCK) '+ @entity       
      
--Below for getting user specific 'Statuses'      
IF((ISNULL(@where, '') = '') OR (@where NOT LIKE '%'+@entity+'.StatusId%'))      
 BEGIN      
  SET @TCountQuery = @TCountQuery + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) fgus ON ' + @entity + '.[StatusId] = fgus.[StatusId] '   ;
  SET @TCountQuery = @TCountQuery + ' INNER JOIN [dbo].[ORGAN000Master] (NOLOCK) org ON ' + @entity + '.[SysOrgId] = org.[Id] ';  
  SET @TCountQuery = @TCountQuery + ' INNER JOIN [dbo].[ORGAN010Ref_Roles] (NOLOCK) rol ON ' + @entity + '.[SysOrgRefRoleId] = rol.[Id] '  ;  
 END      
      
SET @TCountQuery = @TCountQuery + ' WHERE [SysOrgId] = @orgId ' + ISNULL(@where, '')      

EXEC sp_executesql @TCountQuery, N'@orgId BIGINT, @userId BIGINT, @TotalCount INT OUTPUT', @orgId, @userId, @TotalCount  OUTPUT;      
     
IF(@recordId = 0)      
 BEGIN      
  SET @sqlCommand = 'SELECT ' + [dbo].[fnGetBaseQueryByUserId](@entity, @userId)       
  SET @sqlCommand = @sqlCommand + ' ,org.[OrgCode] AS SysOrgIdName, cont.[ConFullName] AS SysUserContactIDName, rol.OrgRoleCode as SysOrgRefRoleIdName '     
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
      
SET @sqlCommand = @sqlCommand + ' FROM [dbo].[SYSTM000OpnSezMe] (NOLOCK) '+ @entity      
--Below to get BIGINT reference key name by Id if NOT NULL      
SET @sqlCommand = @sqlCommand + ' INNER JOIN [dbo].[ORGAN000Master] (NOLOCK) org ON ' + @entity + '.[SysOrgId] = org.[Id] '  
SET @sqlCommand = @sqlCommand + ' INNER JOIN [dbo].[ORGAN010Ref_Roles] (NOLOCK) rol ON ' + @entity + '.[SysOrgRefRoleId] = rol.[Id] '  ;   
SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[CONTC000Master] (NOLOCK) cont ON ' + @entity + '.[SysUserContactID] = cont.[Id] '     
      
--Below for getting user specific 'Statuses'      
IF((ISNULL(@where, '') = '') OR (@where NOT LIKE '%'+@entity+'.StatusId%'))      
 BEGIN      
  SET @sqlCommand = @sqlCommand + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) hfk ON ISNULL(' + @entity + '.[StatusId], 1) = hfk.[StatusId] '      
 END      
      
SET @sqlCommand = @sqlCommand + ' WHERE '+@entity+'.[SysOrgId] = @orgId '+ ISNULL(@where, '')      
      
IF((@recordId > 0) AND (((@isNext = 0) AND (@isEnd = 0)) OR ((@isNext = 1) AND (@isEnd = 0))))      
 BEGIN      
  IF((@isNext = 0) AND (@isEnd = 0))  
   BEGIN  
	IF(ISNULL(@orderBy, '') <> '')
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND ' + @orderBy + ' <= (SELECT ' + @orderBy + ' FROM [dbo].[SYSTM000OpnSezMe] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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
		SET @sqlCommand = @sqlCommand + ' AND ' + @orderBy + ' >= (SELECT ' + @orderBy + ' FROM [dbo].[SYSTM000OpnSezMe] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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
    
EXEC sp_executesql @sqlCommand, N'@pageNo INT, @pageSize INT,@orderBy NVARCHAR(500), @where NVARCHAR(500), @orgId BIGINT, @entity NVARCHAR(100),@userId BIGINT' ,      
  @entity= @entity,      
     @pageNo= @pageNo,       
     @pageSize= @pageSize,      
     @orderBy = @orderBy,      
     @where = @where,      
  @orgId = @orgId,      
  @userId = @userId      
      
END TRY                      
BEGIN CATCH                      
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                      
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                      
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                      
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                      
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetSystemMessage]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               09/22/2018      
-- Description:               Get a system message
-- Execution:                 EXEC [dbo].[GetSystemMessage]   
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)   
-- Modified Desc:  
-- ============================================= 
ALTER PROCEDURE  [dbo].[GetSystemMessage]
    @userId BIGINT,
    @roleId BIGINT,
	@orgId BIGINT,
	@langCode NVARCHAR(10),
    @id BIGINT
AS
BEGIN TRY                
 SET NOCOUNT ON;   
  SELECT syst.[Id]
		,syst.[LangCode]
		,syst.[SysMessageCode]
		,syst.[SysRefId]
		,syst.[SysMessageScreenTitle]
		,syst.[SysMessageTitle]
		,syst.[SysMessageDescription]
		,syst.[SysMessageInstruction]
		,syst.[SysMessageButtonSelection]
		,syst.[DateEntered]
		,syst.[EnteredBy]
		,syst.[DateChanged]
		,syst.[ChangedBy]
  FROM [dbo].[SYSTM000Master] syst
 WHERE [Id] = @id
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetSystemMessageView]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               09/22/2018      
-- Description:               Get all system message
-- Execution:                 EXEC [dbo].[GetSystemMessageView] 
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)   
-- Modified Desc:  
-- =============================================   
ALTER PROCEDURE [dbo].[GetSystemMessageView]  
 @userId BIGINT,  
 @roleId BIGINT,  
 @orgId BIGINT,  
 @langCode NVARCHAR(10),  
 @entity NVARCHAR(100),  
 @pageNo INT,  
 @pageSize INT,  
 @orderBy NVARCHAR(500), 
 @groupBy NVARCHAR(500), 
 @groupByWhere NVARCHAR(500),  
 @where NVARCHAR(500),  
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
  
SET @TCountQuery = 'SELECT @TotalCount = COUNT('+@entity+'.Id) FROM [dbo].[SYSTM000Master] '+@entity+' INNER JOIN SYSTM000Ref_Options ref ON '+@entity+'.SysRefId = ref.Id  WHERE '+@entity+'.[LangCode] = @langCode AND ref.SysLookupId=27 ' + ISNULL(@where, '')
  
EXEC sp_executesql @TCountQuery, N'@langCode NVARCHAR(10), @TotalCount INT OUTPUT', @langCode, @TotalCount  OUTPUT;  
  
IF(@recordId = 0)  
 BEGIN  
  SET @sqlCommand = 'SELECT ' + [dbo].[fnGetBaseQueryByUserId](@entity, @userId)   
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
  
SET @sqlCommand = @sqlCommand + ' FROM [dbo].[SYSTM000Master] (NOLOCK) '+ @entity  
SET @sqlCommand = @sqlCommand + ' INNER JOIN SYSTM000Ref_Options (NOLOCK) ref ON '+ @entity+'.SysRefId = ref.Id '   
SET @sqlCommand = @sqlCommand + ' WHERE '+@entity+'.[LangCode] = @langCode  AND ref.SysLookupId=27 '+ ISNULL(@where, '')  
  
IF((@recordId > 0) AND (((@isNext = 0) AND (@isEnd = 0)) OR ((@isNext = 1) AND (@isEnd = 0))))  
 BEGIN  
  IF((@isNext = 0) AND (@isEnd = 0))  
   BEGIN  
	IF(ISNULL(@orderBy, '') <> '')
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND ' + @orderBy + ' <= (SELECT ' + @orderBy + ' FROM [dbo].[SYSTM000Master] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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
		SET @sqlCommand = @sqlCommand + ' AND ' + @orderBy + ' >= (SELECT ' + @orderBy + ' FROM [dbo].[SYSTM000Master] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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
  
EXEC sp_executesql @sqlCommand, N'@pageNo INT, @pageSize INT,@orderBy NVARCHAR(500), @where NVARCHAR(500), @orgId BIGINT, @langCode NVARCHAR(10), @entity NVARCHAR(100)' ,  
     @langCode= @langCode,  
  @entity= @entity,  
     @pageNo= @pageNo,   
     @pageSize= @pageSize,  
     @orderBy = @orderBy,  
     @where = @where,  
  @orgId = @orgId  
END TRY                  
BEGIN CATCH                  
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                  
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                  
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                  
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                  
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetSystemSettings]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Janardana Behara      
-- Create date:               01/23/2018      
-- Description:               Get system settings
-- Execution:                 EXEC [dbo].[GetSystemSettings]
-- Modified on:  
-- Modified Desc:  
-- =============================================     
ALTER PROCEDURE [dbo].[GetSystemSettings]
 @langCode NVARCHAR(24)   
AS    
BEGIN TRY      
 SET NOCOUNT ON;     
  SELECT settings.Id,
		 settings.[SysSessionTimeOut],
		 settings.[SysWarningTime],
		 settings.[SysMainModuleId],
		 settings.[SysStatusesIn],
		 settings.[SysGridViewPageSizes],
		 settings.[SysPageSize],
		 settings.[SysComboBoxPageSize],
		 settings.[SysThresholdPercentage],
		 settings.[SysDateFormat]
   FROM dbo.SYSTM000Ref_Settings(NOLOCK) settings
END TRY                    
BEGIN CATCH                    
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                    
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                    
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                    
     
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                    
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetSystemStatusLogView]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Janardana Behara        
-- Create date:               06/08/2018      
-- Description:               Get all System status logs
-- Execution:                 EXEC [dbo].[GetSystemStatusLogView] 
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)   
-- Modified Desc:  
-- =============================================        
ALTER PROCEDURE [dbo].[GetSystemStatusLogView]      
 @userId BIGINT,      
 @roleId BIGINT,      
 @orgId BIGINT,      
 @entity NVARCHAR(100),      
 @pageNo INT,      
 @pageSize INT,      
 @orderBy NVARCHAR(500), 
 @groupBy NVARCHAR(500), 
 @groupByWhere NVARCHAR(500),      
 @where NVARCHAR(500),      
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
      
SET @TCountQuery = 'SELECT @TotalCount = COUNT('+@entity+'.Id) FROM [dbo].[SYSTM000_StatusLog] (NOLOCK) '+ @entity       
      
--Below for getting user specific 'Statuses'      
IF((ISNULL(@where, '') = '') OR (@where NOT LIKE '%'+@entity+'.StatusId%'))      
 BEGIN      
  SET @TCountQuery = @TCountQuery + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) fgus ON ISNULL(' + @entity + '.[StatusId], 1) = fgus.[StatusId] '   ;
  SET @TCountQuery = @TCountQuery + ' INNER JOIN [dbo].[PRGRM000Master] (NOLOCK) pgm ON ' + @entity + '.[ProgramID] = pgm.[Id] ';  
  SET @TCountQuery = @TCountQuery + ' INNER JOIN [dbo].[JOBDL000Master] (NOLOCK) job ON ' + @entity + '.[JobID] = job.[Id] '  ;  
  SET @TCountQuery = @TCountQuery + ' INNER JOIN [dbo].[JOBDL020Gateways] (NOLOCK) jobgate ON ' + @entity + '.[GatewayID] = jobgate.[Id] '  ;  
  
 END      
      
SET @TCountQuery = @TCountQuery + ' WHERE pgm.[PrgOrgID] = @orgId ' + ISNULL(@where, '')      

EXEC sp_executesql @TCountQuery, N'@orgId BIGINT, @userId BIGINT, @TotalCount INT OUTPUT', @orgId, @userId, @TotalCount  OUTPUT;      
     
IF(@recordId = 0)      
 BEGIN      
  SET @sqlCommand = 'SELECT ' + [dbo].[fnGetBaseQueryByUserId](@entity, @userId)      ;
  SET @sqlCommand = @sqlCommand + ' , CASE WHEN pgm.PrgHierarchyLevel = 1 THEN pgm.PrgProgramCode
                                  WHEN pgm.PrgHierarchyLevel = 2 THEN pgm.PrgProjectCode
							 WHEN pgm.PrgHierarchyLevel = 3 THEN pgm.PrgPhaseCode
							 ELSE pgm.PrgProgramTitle END  AS ProgramIDName '
   
  SET @sqlCommand = @sqlCommand + ' ,job.JobCustomerSalesOrder as JobIDName , jobgate.GwyGatewayCode as GatewayIDName '     
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
      
SET @sqlCommand = @sqlCommand + ' FROM [dbo].[SYSTM000_StatusLog] (NOLOCK) '+ @entity      
--Below to get BIGINT reference key name by Id if NOT NULL      
  SET @sqlCommand = @sqlCommand + ' INNER JOIN [dbo].[PRGRM000Master] (NOLOCK) pgm ON ' + @entity + '.[ProgramID] = pgm.[Id] ';  
  SET @sqlCommand = @sqlCommand + ' INNER JOIN [dbo].[JOBDL000Master] (NOLOCK) job ON ' + @entity + '.[JobID] = job.[Id] '  ;  
  SET @sqlCommand = @sqlCommand + ' INNER JOIN [dbo].[JOBDL020Gateways] (NOLOCK) jobgate ON ' + @entity + '.[GatewayID] = jobgate.[Id] '  ;    
      
--Below for getting user specific 'Statuses'      
IF((ISNULL(@where, '') = '') OR (@where NOT LIKE '%'+@entity+'.StatusId%'))      
 BEGIN      
  SET @sqlCommand = @sqlCommand + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) hfk ON ISNULL(' + @entity + '.[StatusId], 1) = hfk.[StatusId] '      
 END      
      
SET @sqlCommand = @sqlCommand + ' WHERE pgm.[PrgOrgID] = @orgId '+ ISNULL(@where, '')      
      
IF((@recordId > 0) AND (((@isNext = 0) AND (@isEnd = 0)) OR ((@isNext = 1) AND (@isEnd = 0))))      
 BEGIN      
  IF((@isNext = 0) AND (@isEnd = 0))  
   BEGIN  
	IF(ISNULL(@orderBy, '') <> '')
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND ' + @orderBy + ' <= (SELECT ' + @orderBy + ' FROM [dbo].[SYSTM000_StatusLog] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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
		SET @sqlCommand = @sqlCommand + ' AND ' + @orderBy + ' >= (SELECT ' + @orderBy + ' FROM [dbo].[SYSTM000_StatusLog] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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
  
EXEC sp_executesql @sqlCommand, N'@pageNo INT, @pageSize INT,@orderBy NVARCHAR(500), @where NVARCHAR(500), @orgId BIGINT, @entity NVARCHAR(100),@userId BIGINT' ,      
  @entity= @entity,      
     @pageNo= @pageNo,       
     @pageSize= @pageSize,      
     @orderBy = @orderBy,      
     @where = @where,      
  @orgId = @orgId,      
  @userId = @userId      
      
END TRY                      
BEGIN CATCH                      
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                      
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                      
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                      
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                      
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetSysZipCode]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               08/16/2018      
-- Description:               Get a Sys ZipCode  
-- Execution:                 EXEC [dbo].[GetSysZipCode]   
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)    
-- Modified Desc:  
-- ============================================= 
ALTER PROCEDURE  [dbo].[GetSysZipCode]
    @userId BIGINT,
    @roleId BIGINT,
	@orgId BIGINT,
    @id BIGINT
AS
BEGIN TRY                
 SET NOCOUNT ON;   
SELECT syst.[Zipcode]
      ,syst.[ZipCity]
      ,syst.[ZipState]
      ,syst.[ZipLatitude]
      ,syst.[ZipLongitude]
      ,syst.[ZipTimezone]
      ,syst.[ZipDST]
      ,syst.[MrktID]
      ,syst.[DateEntered]
      ,syst.[EnteredBy]
      ,syst.[DateChanged]
      ,syst.[ChangedBy]
  FROM [dbo].[SYSTM000ZipcodeMaster] syst
 WHERE [Zipcode]=@id 
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetTableAssociations]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Janardana B         
-- Create date:               03/28/2018      
-- Description:               GET TABLE ASSOCIATIONS  
-- Execution:                 EXEC [dbo].[GetTableAssociations]   
-- Modified on:  
-- Modified Desc:  
-- =============================================

ALTER PROCEDURE [dbo].[GetTableAssociations]
(
 @tableName NVARCHAR(100)=NULL,
 @id NVARCHAR(1000) = NULL
)
AS
BEGIN TRY
 SET NOCOUNT ON;

DECLARE @ReferenceTable Table(
primaryId INT IDENTITY(1,1) primary key clustered,
referenceEntity NVARCHAR(50),
parentEntity NVARCHAR(50),
referenceTableName NVARCHAR(100),
referenceColumnName  NVARCHAR(100)
);

INSERT INTO @ReferenceTable(referenceEntity,parentEntity,referenceTableName,referenceColumnName)
SELECT 
(SELECT TOP 1 SysRefName FROM [dbo].[SYSTM000Ref_Table] WHERE TblTableName = sys.sysobjects.name) as [Entity],
@tableName As ParentTableName ,
sys.sysobjects.name AS TableName,

(SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE WHERE CONSTRAINT_NAME = sys.foreign_keys.name) AS ColumnName
FROM 
sys.foreign_keys 
inner join sys.sysobjects on
sys.foreign_keys.parent_object_id = sys.sysobjects.id
INNER JOIN  [dbo].[SYSTM000Ref_Table] refTable  ON OBJECT_ID(refTable.TblTableName) = referenced_object_id
WHERE refTable.SysRefName = @tableName;



CREATE TABLE #DataReferenceTable(
Id BIGINT,
ParentId BIGINT NULL,
Entity NVARCHAR(100),
ParentEntity NVARCHAR(100),
Name  NVARCHAR(250)
);



   Declare @minId INT,@maxId INT
   SELECT @minId = Min(primaryId),@maxId = Count(primaryId)  FROM @ReferenceTable
	WHILE(@minId <= @maxId)
	BEGIN
	   DECLARE @sqlCommand NVARCHAR(MAX);
	   DECLARE @refTableName NVARCHAR(100),@refTableColName NVARCHAR(100),@refEntity NVARCHAR(100),@parentEntity NVARCHAR(100)
   
	   SELECT  @refTableName = referenceTableName
			  ,@refTableColName = referenceColumnName
			  ,@refEntity = referenceEntity
			  ,@parentEntity = parentEntity
   
		FROM @ReferenceTable Where primaryId = @minId;
	

	   SET  @sqlCommand = 'INSERT INTO #DataReferenceTable(Id,ParentId,Entity,ParentEntity,Name) 
				 SELECT Id, '+@refTableColName+',@refEntity,@parentEntity,Id FROM  '+@refTableName+' WHERE '+@refTableColName+' IN (@id)';
	   EXEC sp_executesql @sqlCommand,N'@refEntity NVARCHAR(100),@parentEntity NVARCHAR(100),@id NVARCHAR(1000)',@refEntity,@parentEntity ,@id   ; 
	   SET @minId = @minId + 1;
	END

  SELECT * FROM #DataReferenceTable;
 
  DROP TABLE #DataReferenceTable;

END TRY                      
BEGIN CATCH                      
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                      
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                      
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                      
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                      
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetTableRowCount]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Janardana Behara
-- Create date:               05/09/2018      
-- Description:               Get Row Count based on table
-- Execution:                 SELECT FROM  [dbo].[GetTableRowCount]
-- Modified on:  
-- Modified Desc:  
-- ============================================= 

ALTER PROCEDURE [dbo].[GetTableRowCount] 
(
 @entity varchar(50)
,@fieldName varchar(100)
,@value varchar(100)
,@where NVARCHAR(MAX)
)

as
begin

 DECLARE @sqlCommand NVARCHAR(MAX),@attachmentCount INT = 0
 DECLARE  @tableName NVARCHAR(100) 
 select @tableName =TblTableName FROM [dbo].[SYSTM000Ref_Table] WHERE SysRefName =  @entity
 SET @sqlCommand = 'SELECT @attachmentCount = Count(*)  FROM ' + @tableName + ' WHERE ' + @fieldName + ' =  ''' + @value + '''  AND ISNULL(StatusId,0) = 1';

 IF LEN(ISNULL(@where,'')) > 0
 BEGIN
   SET @sqlCommand   =  @sqlCommand + ' ' + @where;

 END
  EXEC sp_executesql @sqlCommand, N' @attachmentCount int output',@attachmentCount output 
  SELECT @attachmentCount
end
GO
/****** Object:  StoredProcedure [dbo].[GetTables]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil        
-- Create date:               12/20/2018      
-- Description:               Get tables 
-- Execution:                 EXEC [dbo].[GetTables]   
-- Modified on:  
-- Modified Desc:  
-- =============================================                          
ALTER PROCEDURE [dbo].[GetTables]     
AS                  
BEGIN TRY                  
 SET NOCOUNT ON;     
 SELECT  refTab.SysRefName  
  ,refTab.LangCode  
  ,refTab.TblLangName
  ,refTab.TblTableName  
  ,refTab.TblMainModuleId  
  ,refOp.[SysOptionName] as MainModuleName 
  ,refTab.TblIcon 
  ,refTab.TblTypeId
  ,refOpType.[SysOptionName] as TblTypeIdName 
 FROM [dbo].[SYSTM000Ref_Table] refTab (NOLOCK)    
 LEFT JOIN [dbo].[SYSTM000Ref_Options] refOp (NOLOCK) ON  refTab.TblMainModuleId= refOp.Id  
 LEFT JOIN [dbo].[SYSTM000Ref_Options] refOpType (NOLOCK) ON  refTab.TblTypeId= refOpType.Id  
 ORDER BY refOp.Id ASC  
END TRY                  
BEGIN CATCH                  
DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                  
  ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                  
  ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                  
  
EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                  
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetUserCulture]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil        
-- Create date:               04/14/2018      
-- Description:               Get User Culture 
-- Execution:                 EXEC [dbo].[GetUserCulture]  
-- Modified on:  
-- Modified Desc:  
-- ============================================= 
ALTER PROCEDURE [dbo].[GetUserCulture] 
	@userId BIGINT
AS
BEGIN TRY                
 SET NOCOUNT ON;   
	SELECT 1 as SysRefId
		 ,'EN' as RefName
		 ,'EN' as LangName
END TRY                
BEGIN CATCH                
	DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
			,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
			,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
	EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetUserDashboards]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               03/30/2018      
-- Description:               Get Dashboard on module by User 
-- Execution:                 EXEC [dbo].[GetUserDashboards]   
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)    
-- Modified Desc:  
-- =============================================  
ALTER PROCEDURE  [dbo].[GetUserDashboards]
    @userId BIGINT,
    @roleId BIGINT,
	@orgId BIGINT,
    @mainModuleId INT
AS
BEGIN TRY                
 SET NOCOUNT ON;  
 DECLARE @roleCode NVARCHAR(25), @isSysAdmin BIT = 0 ; 
 SELECT @isSysAdmin =  sez.IsSysAdmin FROM [dbo].[SYSTM000OpnSezMe] sez where sez.Id= @userId
 SELECT @roleCode = actrole.OrgRoleTitle FROM [dbo].[ORGAN020Act_SecurityByRole] actrole where actrole.Id= @roleId
  SELECT dsh.[Id]
      ,dsh.[DshName]
 FROM [dbo].[SYSTM000Ref_Dashboard] dsh
 WHERE dsh.[DshMainModuleId] =  CASE WHEN ((@isSysAdmin) =1) THEN 
 dsh.DshMainModuleId  ELSE (CASE WHEN (@roleCode = 'SYSADMIN') THEN dsh.[DshMainModuleId] ELSE @mainModuleId END)
	END
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetUserPageOptnLevelAndPermission]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               07/23/2018      
-- Description:               Get GetPageOptionLevelAndPermission
-- Execution:                 EXEC [dbo].[GetPageOptionLevelAndPermission] 
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)   
-- Modified Desc:  
-- ============================================= 
ALTER PROCEDURE  [dbo].[GetUserPageOptnLevelAndPermission]
    @userId BIGINT,
    @orgId BIGINT,
    @roleId BIGINT,
	@entity NVARCHAR(100)
AS
BEGIN TRY                
 SET NOCOUNT ON;   
 
 DECLARE @currentOptionLevel INT = -1, @currentAccessLevel INT = -1, @currentModuleId INT = -1;

 SELECT @currentModuleId=TblMainModuleId FROM [dbo].[SYSTM000Ref_Table] WHERE SysRefName = @entity

 IF EXISTS(SELECT Id FROM [dbo].[SYSTM000MenuDriver] menuDriver JOIN [dbo].[fnGetUserStatuses](@userId) fgus ON ISNULL( menuDriver.[StatusId], 1) = fgus.[StatusId] WHERE MnuTableName = @entity AND MnuModuleId = @currentModuleId)
  BEGIN
	SELECT @currentOptionLevel=MnuOptionLevelId, @currentAccessLevel=MnuAccessLevelId FROM [dbo].[SYSTM000MenuDriver] menuDriver
	JOIN [dbo].[fnGetUserStatuses](@userId) fgus ON ISNULL( menuDriver.[StatusId], 1) = fgus.[StatusId]
	WHERE MnuTableName = @entity AND MnuModuleId = @currentModuleId
  END
 IF EXISTS(SELECT Id FROM [dbo].[SYSTM000OpnSezMe] Where Id= @userId AND IsSysAdmin = 1)
	 BEGIN
		SET @currentOptionLevel = 27;
		SET @currentAccessLevel = 21;
	 END
 ELSE
 BEGIN
	 IF EXISTS(SELECT sec.Id FROM [dbo].[ORGAN021Act_SecurityByRole] sec
		JOIN [dbo].[ORGAN020Act_Roles] actRole ON sec.OrgActRoleId = actRole.Id and actRole.Id = @roleId
	  	JOIN [dbo].[fnGetUserStatuses](@userId) fgus ON ISNULL(sec.[StatusId], 1) = fgus.[StatusId]
	  	WHERE SecMainModuleId=@currentModuleId AND sec.OrgId=@orgId)
	  BEGIN
	  	SELECT @currentOptionLevel=SecMenuOptionLevelId, @currentAccessLevel=SecMenuAccessLevelId FROM [dbo].[ORGAN021Act_SecurityByRole] sec
		JOIN [dbo].[ORGAN020Act_Roles] actRole ON sec.OrgActRoleId = actRole.Id and actRole.Id = @roleId
	  	JOIN [dbo].[fnGetUserStatuses](@userId) fgus ON ISNULL(sec.[StatusId], 1) = fgus.[StatusId]
	  	WHERE SecMainModuleId=@currentModuleId AND sec.OrgId=@orgId
	  END
	  
	 IF EXISTS(SELECT subSec.Id FROM [dbo].[ORGAN022Act_SubSecurityByRole] subSec 
	 JOIN [dbo].[ORGAN021Act_SecurityByRole] sec ON subSec.OrgSecurityByRoleId=sec.Id 
	 JOIN [dbo].[ORGAN020Act_Roles] actRole ON sec.OrgActRoleId = actRole.Id and actRole.Id = @roleId
	 JOIN [dbo].[fnGetUserStatuses](@userId) fgus ON ISNULL( subSec.[StatusId], 1) = fgus.[StatusId] 
	 WHERE SecMainModuleId=@currentModuleId AND sec.OrgId=@orgId AND RefTableName=@entity)
	  BEGIN
	  	SELECT @currentOptionLevel=SubsMenuOptionLevelId, @currentAccessLevel=SubsMenuAccessLevelId FROM [dbo].[ORGAN022Act_SubSecurityByRole] subSec 
	  	JOIN [dbo].[ORGAN021Act_SecurityByRole] sec ON subSec.OrgSecurityByRoleId=sec.Id 
		JOIN [dbo].[ORGAN020Act_Roles] actRole ON sec.OrgActRoleId = actRole.Id and actRole.Id = @roleId
	  	JOIN [dbo].[fnGetUserStatuses](@userId) fgus ON ISNULL( subSec.[StatusId], 1) = fgus.[StatusId] 
	  	WHERE SecMainModuleId=@currentModuleId AND sec.OrgId=@orgId AND RefTableName=@entity
	  END
 END

 SELECT @userId AS Id, @currentModuleId AS SecMainModuleId, @currentOptionLevel AS SecMenuOptionLevelId, @currentAccessLevel AS SecMenuAccessLevelId;
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetUserSecurities]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               08/16/2018      
-- Description:               Get user securities  
-- Execution:                 EXEC [dbo].[GetUserSecurities]   
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)    
-- Modified Desc:  
-- =============================================   
ALTER PROCEDURE  [dbo].[GetUserSecurities]     
 @userId BIGINT,    
 @orgId BIGINT,    
 @roleId BIGINT    
AS    
BEGIN TRY                    
 SET NOCOUNT ON;  

	 IF EXISTS(SELECT Id FROM [dbo].[SYSTM000OpnSezMe] Where Id= @userId AND IsSysAdmin = 1)
	 BEGIN
		--IF EXISTS(SELECT 1 FROM [dbo].[ORGAN020Act_Roles] (NOLOCK) actRole INNER JOIN [dbo].[ORGAN021Act_SecurityByRole] (NOLOCK) orgSec ON orgSec.[OrgActRoleId] = actRole.[Id] Where actRole.Id= @roleId AND actRole.[OrgId] = @orgId)
		--BEGIN
		--	SELECT orgSec.Id    
		--   ,orgSec.[SecMainModuleId]    
		--   ,orgSec.[SecMenuOptionLevelId]    
		--   ,orgSec.[SecMenuAccessLevelId]    
		-- FROM [dbo].[ORGAN020Act_Roles] (NOLOCK) actRole  
		-- INNER JOIN [dbo].[ORGAN021Act_SecurityByRole] (NOLOCK) orgSec ON orgSec.[OrgActRoleId] = actRole.[Id] AND (orgSec.SecMenuOptionLevelId > 22) AND (orgSec.SecMenuAccessLevelId > 16)
		-- WHERE actRole.[OrgId] = @orgId  AND actRole.Id = @roleId AND (ISNULL(orgSec.StatusId, 1) =1)  
		--END
		--ELSE
		--BEGIN
			SELECT 
	      Id as SecMainModuleId,
		  27 as SecMenuOptionLevelId,
		  21 as SecMenuAccessLevelId
	    FROM [dbo].[SYSTM000Ref_Options] WHERE SysLookupId = 22;
		--END

	 END
	 ELSE
	 BEGIN
		 SELECT orgSec.Id    
		   ,orgSec.[SecMainModuleId]    
		   ,orgSec.[SecMenuOptionLevelId]    
		   ,orgSec.[SecMenuAccessLevelId]    
		 FROM [dbo].[ORGAN020Act_Roles] (NOLOCK) actRole  
		 INNER JOIN [dbo].[ORGAN021Act_SecurityByRole] (NOLOCK) orgSec ON orgSec.[OrgActRoleId] = actRole.[Id] AND (orgSec.SecMenuOptionLevelId > 22) AND (orgSec.SecMenuAccessLevelId > 16)
		 WHERE actRole.[OrgId] = @orgId  AND actRole.Id = @roleId AND (ISNULL(orgSec.StatusId, 1) =1)  
    END
END TRY                    
BEGIN CATCH                    
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                    
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                    
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                    
     
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                    
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetUserSubSecurities]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               08/16/2018      
-- Description:               Get user securities  
-- Execution:                 EXEC [dbo].[GetUserSubSecurities]   
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)    
-- Modified Desc:  
-- =============================================   
ALTER PROCEDURE  [dbo].[GetUserSubSecurities] 
 @userId BIGINT,  
 @secByRoleId BIGINT,  
 @orgId BIGINT,  
 @roleId BIGINT
AS  
BEGIN TRY                  
 SET NOCOUNT ON; 
  IF NOT EXISTS(SELECT Id FROM [dbo].[SYSTM000OpnSezMe] Where Id= @userId AND IsSysAdmin = 1)
	 BEGIN
		 SELECT 
		 subSec.OrgSecurityByRoleId  
		   ,subSec.RefTableName  
		   ,subSec.SubsMenuOptionLevelId   
		   ,subSec.SubsMenuAccessLevelId   
		 FROM [dbo].[ORGAN021Act_SecurityByRole] (NOLOCK) sec  
		 INNER JOIN [dbo].[ORGAN022Act_SubSecurityByRole](NOLOCK) subSec ON subSec.[OrgSecurityByRoleId]= sec.Id 
		 INNER JOIN [dbo].[ORGAN020Act_Roles](NOLOCK) rol ON sec.OrgActRoleId = rol.Id
		 WHERE sec.OrgId= @orgId AND rol.Id= @roleId AND sec.Id = @secByRoleId AND subSec.StatusId=1 AND sec.StatusId=1;
	 END
  ELSE IF EXISTS(SELECT 1 FROM [dbo].[ORGAN020Act_Roles] (NOLOCK) actRole INNER JOIN [dbo].[ORGAN021Act_SecurityByRole] (NOLOCK) orgSec ON orgSec.[OrgActRoleId] = actRole.[Id] Where actRole.Id= @roleId AND actRole.[OrgId] = @orgId)
  BEGIN
	SELECT 
		 subSec.OrgSecurityByRoleId  
		   ,subSec.RefTableName  
		   ,27 as SecMenuOptionLevelId   
		   ,21 as SecMenuAccessLevelId
		 FROM [dbo].[ORGAN021Act_SecurityByRole] (NOLOCK) sec  
		 INNER JOIN [dbo].[ORGAN022Act_SubSecurityByRole](NOLOCK) subSec ON subSec.[OrgSecurityByRoleId]= sec.Id 
		 INNER JOIN [dbo].[ORGAN020Act_Roles](NOLOCK) rol ON sec.OrgActRoleId = rol.Id
		 WHERE sec.OrgId= @orgId AND rol.Id= @roleId AND sec.Id = @secByRoleId AND subSec.StatusId=1 AND sec.StatusId=1;
  END
END TRY                  
BEGIN CATCH                  
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                  
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                  
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                  
   
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                  
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetUserSysSetting]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group      
   All Rights Reserved Worldwide */      
-- =============================================              
-- Author:                    Akhil Chauhan               
-- Create date:               12/09/2018            
-- Description:               Get User System Setting        
-- Execution:                 EXEC [dbo].[GetUserSysSetting]        
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)          
-- Modified Desc:        
-- =============================================              
ALTER PROCEDURE  [dbo].[GetUserSysSetting]  
 @userId BIGINT,      
 @roleId BIGINT,      
 @orgId BIGINT,      
 @contactId BIGINT            
AS            
BEGIN TRY                            
 SET NOCOUNT ON;         
          
IF EXISTS( SELECT TOP 1 1 FROM [dbo].[SYSTM000Ref_UserSettings] (NOLOCK) usys WHERE usys.UserId=@userId AND usys.OrganizationId=@orgId)            
 BEGIN          
   DECLARE @sessionTimeOut INT,@warningTime INT, @dateFormat NVARCHAR(200)
   SELECT @sessionTimeOut = SysSessionTimeOut        
     ,@warningTime =SysWarningTime 
	 ,@dateFormat= SysDateFormat       
    FROM [dbo].[SYSTM000Ref_Settings] (NOLOCK)             
    SELECT  usys.[Id]
			,usys.[OrganizationId]
			,usys.[UserId]
			,usys.[LangCode]
			,usys.[SysMainModuleId]
			,usys.[SysDefaultAction]
			,usys.[SysStatusesIn]
			,usys.[SysGridViewPageSizes]
			,usys.[SysPageSize]
			,usys.[SysComboBoxPageSize]
			,usys.[SysThresholdPercentage]          
     ,@sessionTimeOut As SessionTimeOut        
     ,@warningTime As WarningTime   
	 ,@dateFormat as [SysDateFormat]
	 ,(Select ConImage FROM CONTC000Master where Id=@contactId) as UserIcon     
    FROM [dbo].[SYSTM000Ref_UserSettings] (NOLOCK) usys WHERE usys.UserId=@userId AND usys.OrganizationId=@orgId            
  END            
ELSE            
 BEGIN            
   SELECT  ssys.[Id]
         , @userId as [UserId]
		 ,@orgId as [OrganizationId]
         ,'EN' as [LangCode]   
		,ssys.[SysSessionTimeOut]
		,ssys.[SysWarningTime]
		,ssys.[SysMainModuleId]
		,ssys.[SysDefaultAction]
		,ssys.[SysStatusesIn]
		,ssys.[SysGridViewPageSizes]
		,ssys.[SysPageSize]
		,ssys.[SysComboBoxPageSize]
		,ssys.[SysThresholdPercentage]
		,ssys.[SysDateFormat]
		,(Select ConImage FROM CONTC000Master where Id=@contactId) as UserIcon     
     FROM [dbo].[SYSTM000Ref_Settings] (NOLOCK) ssys
 END        
            
END TRY                            
BEGIN CATCH                            
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                            
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                            
  ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                            
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                            
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetValidation]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               08/16/2018      
-- Description:               Get a Sys Validation 
-- Execution:                 EXEC [dbo].[GetValidation]
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)    
-- Modified Desc:  
-- ============================================= 
ALTER PROCEDURE  [dbo].[GetValidation]
    @userId BIGINT,
    @roleId BIGINT,
	@orgId BIGINT,
    @langCode NVARCHAR(10),
    @id BIGINT
AS
BEGIN TRY                
 SET NOCOUNT ON;   
IF(@langCode='EN')
 BEGIN
SELECT syst.[Id]
      ,syst.[LangCode]
      ,syst.[ValTableName]
      ,syst.[RefTabPageId]
      ,syst.[ValFieldName]
      ,syst.[ValRequired]
      ,syst.[ValRequiredMessage]
      ,syst.[ValUnique]
      ,syst.[ValUniqueMessage]
      ,syst.[ValRegExLogic0]
      ,syst.[ValRegEx1]
      ,syst.[ValRegExMessage1]
      ,syst.[ValRegExLogic1]
      ,syst.[ValRegEx2]
      ,syst.[ValRegExMessage2]
      ,syst.[ValRegExLogic2]
      ,syst.[ValRegEx3]
      ,syst.[ValRegExMessage3]
      ,syst.[ValRegExLogic3]
      ,syst.[ValRegEx4]
      ,syst.[ValRegExMessage4]
      ,syst.[ValRegExLogic4]
      ,syst.[ValRegEx5]
      ,syst.[ValRegExMessage5]
      ,syst.[DateEntered]
      ,syst.[EnteredBy]
      ,syst.[DateChanged]
      ,syst.[ChangedBy]
  FROM [dbo].[SYSTM000Validation] syst
 WHERE [Id]=@id 
END
ELSE
 BEGIN
SELECT syst.[Id]
      ,syst.[LangCode]
      ,syst.[ValTableName]
      ,syst.[RefTabPageId]
      ,syst.[ValFieldName]
      ,syst.[ValRequired]
      ,syst.[ValRequiredMessage]
      ,syst.[ValUnique]
      ,syst.[ValUniqueMessage]
      ,syst.[ValRegExLogic0]
      ,syst.[ValRegEx1]
      ,syst.[ValRegExMessage1]
      ,syst.[ValRegExLogic1]
      ,syst.[ValRegEx2]
      ,syst.[ValRegExMessage2]
      ,syst.[ValRegExLogic2]
      ,syst.[ValRegEx3]
      ,syst.[ValRegExMessage3]
      ,syst.[ValRegExLogic3]
      ,syst.[ValRegEx4]
      ,syst.[ValRegExMessage4]
      ,syst.[ValRegExLogic4]
      ,syst.[ValRegEx5]
      ,syst.[ValRegExMessage5]
      ,syst.[DateEntered]
      ,syst.[EnteredBy]
      ,syst.[DateChanged]
      ,syst.[ChangedBy]
  FROM [dbo].[SYSTM000Validation] syst
 WHERE [Id]=@id 
 END
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetValidationRegExpsByTblName]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               10/25/2018      
-- Description:               Get regular expression and message for table
-- Execution:                 EXEC [dbo].[GetValidationRegExpsByTblName]
-- Modified on:  
-- Modified Desc:  
-- =============================================  
ALTER PROCEDURE [dbo].[GetValidationRegExpsByTblName]  
  @langCode NVARCHAR(10),  
  @tableName NVARCHAR(100)  
AS                  
BEGIN TRY                  
 SET NOCOUNT ON;  
 SELECT val.[ValTableName],val.[ValFieldName]  
      ,val.[ValRegExLogic0]  
      ,val.[ValRegEx1]  
      ,val.[ValRegExMessage1]  
      ,val.[ValRegExLogic1]  
      ,val.[ValRegEx2]  
      ,val.[ValRegExMessage2]  
      ,val.[ValRegExLogic2]  
      ,val.[ValRegEx3]  
      ,val.[ValRegExMessage3]  
      ,val.[ValRegExLogic3]  
      ,val.[ValRegEx4]  
      ,val.[ValRegExMessage4]  
      ,val.[ValRegExLogic4]  
      ,val.[ValRegEx5]  
      ,val.[ValRegExMessage5]  
  FROM [dbo].[SYSTM000Validation]  (NOLOCK) val WHERE val.[LangCode] =@langCode AND val.[ValTableName] = @tableName AND ISNULL(val.[StatusId],1) =1  
END TRY                  
BEGIN CATCH                  
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                  
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                  
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                  
   
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                  
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetValidationView]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               09/04/2018      
-- Description:               Get all system validation 
-- Execution:                 EXEC [dbo].[GetValidationView]
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)    
-- Modified Desc:  
-- =============================================  
     
ALTER PROCEDURE [dbo].[GetValidationView]    
 @userId BIGINT,    
 @roleId BIGINT,    
 @orgId BIGINT,    
 @langCode NVARCHAR(10),    
 @entity NVARCHAR(100),    
 @pageNo INT,    
 @pageSize INT,    
 @orderBy NVARCHAR(500),
 @groupBy NVARCHAR(500), 
 @groupByWhere NVARCHAR(500),     
 @where NVARCHAR(500),    
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
    
SET @TCountQuery = 'SELECT @TotalCount = COUNT(Id) FROM [dbo].[SYSTM000Validation] (NOLOCK) '+ @entity +' WHERE [LangCode] = @langCode ' + ISNULL(@where, '')    
EXEC sp_executesql @TCountQuery, N'@langCode NVARCHAR(10), @TotalCount INT OUTPUT', @langCode, @TotalCount  OUTPUT;    
    
IF(@recordId = 0)    
 BEGIN    
  SET @sqlCommand = 'SELECT ' + [dbo].[fnGetBaseQueryByUserId](@entity, @userId)     
  --SET @sqlCommand = @sqlCommand + ' ,tabPage.[LangTabName] AS RefTabPageIdName '    
  SET @sqlCommand = @sqlCommand + ' ,tabPage.[TabTableName] AS RefTabPageIdName '    
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
    
SET @sqlCommand = @sqlCommand + ' FROM [dbo].[SYSTM000Validation] (NOLOCK) '+ @entity    
    
--Below to get BIGINT reference key name by Id if NOT NULL    
SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[SYSTM030Ref_TabPageName] (NOLOCK) tabPage ON ' + @entity + '.[RefTabPageId]=tabPage.[Id] '    
    
SET @sqlCommand = @sqlCommand + ' WHERE '+@entity+'.[LangCode] = @langCode '+ ISNULL(@where, '')    
    
IF((@recordId > 0) AND (((@isNext = 0) AND (@isEnd = 0)) OR ((@isNext = 1) AND (@isEnd = 0))))    
 BEGIN    
  IF((@isNext = 0) AND (@isEnd = 0))  
   BEGIN  
	IF(ISNULL(@orderBy, '') <> '')
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND ' + @orderBy + ' <= (SELECT ' + @orderBy + ' FROM [dbo].[SYSTM000Validation] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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
		SET @sqlCommand = @sqlCommand + ' AND ' + @orderBy + ' >= (SELECT ' + @orderBy + ' FROM [dbo].[SYSTM000Validation] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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
    
EXEC sp_executesql @sqlCommand, N'@pageNo INT, @pageSize INT, @langCode NVARCHAR(10), @entity NVARCHAR(100), @orderBy NVARCHAR(500), @where NVARCHAR(500)' ,    
     @langCode= @langCode,    
  @entity= @entity,    
     @pageNo= @pageNo,     
     @pageSize= @pageSize,    
     @orderBy = @orderBy,    
     @where = @where    
END TRY                    
BEGIN CATCH                    
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                    
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                    
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                    
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                    
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetVendBusinessTerm]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               09/16/2018      
-- Description:               Get a vend business term 
-- Execution:                 EXEC [dbo].[GetVendBusinessTerm]
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)    
-- Modified Desc:  
-- ============================================= 
ALTER PROCEDURE  [dbo].[GetVendBusinessTerm]
    @userId BIGINT,
    @roleId BIGINT,
	@orgId BIGINT,
    @langCode NVARCHAR(10),
    @id BIGINT
AS
BEGIN TRY                
 SET NOCOUNT ON;   
IF(@langCode='EN')
 BEGIN
SELECT vend.[Id]
      ,vend.[LangCode]
      ,vend.[VbtOrgID]
      ,vend.[VbtVendorID]
      ,vend.[VbtItemNumber]
      ,vend.[VbtCode]
      ,vend.[VbtTitle]
      ,vend.[BusinessTermTypeId]
      ,vend.[VbtActiveDate]
      ,vend.[VbtValue]
      ,vend.[VbtHiThreshold]
      ,vend.[VbtLoThreshold]
      ,vend.[VbtAttachment]
      ,vend.[StatusId]
      ,vend.[EnteredBy]
      ,vend.[DateEntered]
      ,vend.[ChangedBy]
      ,vend.[DateChanged]
  FROM [dbo].[VEND020BusinessTerms] vend
 WHERE [Id]=@id 
END
ELSE
 BEGIN
SELECT vend.[Id]
      ,vend.[LangCode]
      ,vend.[VbtOrgID]
      ,vend.[VbtVendorID]
      ,vend.[VbtItemNumber]
      ,vend.[VbtCode]
      ,vend.[VbtTitle]
      ,vend.[BusinessTermTypeId]
      ,vend.[VbtActiveDate]
      ,vend.[VbtValue]
      ,vend.[VbtHiThreshold]
      ,vend.[VbtLoThreshold]
      ,vend.[VbtAttachment]
      ,vend.[StatusId]
      ,vend.[EnteredBy]
      ,vend.[DateEntered]
      ,vend.[ChangedBy]
      ,vend.[DateChanged]
  FROM [dbo].[VEND020BusinessTerms] vend
 WHERE [Id]=@id  
 END
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetVendBusinessTermView]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               09/04/2018      
-- Description:               Get all vendor business term
-- Execution:                 EXEC [dbo].[GetVendBusinessTermView]
-- Modified on:               04/25/2018
-- Modified Desc:             Removed lang code filter
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)  
-- =============================================
ALTER PROCEDURE [dbo].[GetVendBusinessTermView]
 @userId BIGINT,
 @roleId BIGINT,
 @orgId BIGINT,
 @langCode NVARCHAR(10),
 @entity NVARCHAR(100),
 @pageNo INT,
 @pageSize INT,
 @orderBy NVARCHAR(500),
 @groupBy NVARCHAR(500), 
 @groupByWhere NVARCHAR(500), 
 @where NVARCHAR(500),
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

SET @TCountQuery = 'SELECT @TotalCount = COUNT(Id) FROM [dbo].[VEND020BusinessTerms] (NOLOCK) '+ @entity 

--Below for getting user specific 'Statuses'
IF((ISNULL(@where, '') = '') OR (@where NOT LIKE '%'+@entity+'.StatusId%'))
	BEGIN
		SET @TCountQuery = @TCountQuery + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) fgus ON ' + @entity + '.[StatusId] = fgus.[StatusId] '
	END

SET @TCountQuery = @TCountQuery +' WHERE  [VbtOrgId] = @orgId AND [VbtVendorID] = @parentId ' + ISNULL(@where, '')
EXEC sp_executesql @TCountQuery, N' @orgId BIGINT, @parentId BIGINT, @userId BIGINT, @TotalCount INT OUTPUT',@orgId, @parentId, @userId, @TotalCount  OUTPUT;

IF(@recordId = 0)
	BEGIN
		SET @sqlCommand = 'SELECT ' + [dbo].[fnGetBaseQueryByUserId](@entity, @userId) 
		SET @sqlCommand = @sqlCommand + ' ,org.[OrgCode] AS VbtOrgIDName, vend.[VendCode] AS VbtVendorIDName '
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

SET @sqlCommand = @sqlCommand + ' FROM [dbo].[VEND020BusinessTerms] (NOLOCK) '+ @entity

--Below to get BIGINT reference key name by Id if NOT NULL
SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[ORGAN000Master] (NOLOCK) org ON ' + @entity + '.[VbtOrgID]=org.[Id] '
SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[VEND000Master] (NOLOCK) vend ON ' + @entity + '.[VbtVendorID]=vend.[Id] '

--Below for getting user specific 'Statuses'
IF((ISNULL(@where, '') = '') OR (@where NOT LIKE '%'+@entity+'.StatusId%'))
	BEGIN
		SET @sqlCommand = @sqlCommand + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) hfk ON ISNULL(' + @entity + '.[StatusId], 1) = hfk.[StatusId] '
	END

SET @sqlCommand = @sqlCommand + ' WHERE '+@entity+'.[VbtOrgId] = @orgId  AND '+@entity+'.[VbtVendorID] = @parentId '+ ISNULL(@where, '')

IF((@recordId > 0) AND (((@isNext = 0) AND (@isEnd = 0)) OR ((@isNext = 1) AND (@isEnd = 0))))
	BEGIN
		IF((@isNext = 0) AND (@isEnd = 0))  
   BEGIN  
	IF(ISNULL(@orderBy, '') <> '')
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND ' + @orderBy + ' <= (SELECT ' + @orderBy + ' FROM [dbo].[VEND020BusinessTerms] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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
		SET @sqlCommand = @sqlCommand + ' AND ' + @orderBy + ' >= (SELECT ' + @orderBy + ' FROM [dbo].[VEND020BusinessTerms] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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

EXEC sp_executesql @sqlCommand, N'@pageNo INT, @pageSize INT, @orderBy NVARCHAR(500), @where NVARCHAR(500), @orgId BIGINT, @entity NVARCHAR(100), @parentId BIGINT,@userId BIGINT' ,
    
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
/****** Object:  StoredProcedure [dbo].[GetVendContact]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               08/16/2018      
-- Description:               Get a vend contact
-- Execution:                 EXEC [dbo].[GetVendContact]
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)   
-- Modified Desc:  
-- ============================================= 
ALTER PROCEDURE  [dbo].[GetVendContact]
    @userId BIGINT,
    @roleId BIGINT,
	@orgId BIGINT,
    @id BIGINT
AS
BEGIN TRY                
 SET NOCOUNT ON;   
SELECT vend.[Id]
      ,vend.[VendVendorID]
      ,vend.[VendItemNumber]
      ,vend.[VendContactCode]
      ,vend.[VendContactTitle]
      ,vend.[VendContactMSTRID]
      ,vend.[StatusId]
      ,vend.[EnteredBy]
      ,vend.[DateEntered]
      ,vend.[ChangedBy]
      ,vend.[DateChanged]
  FROM [dbo].[VEND010Contacts] vend
 WHERE [Id]=@id 
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetVendContactView]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               09/04/2018      
-- Description:               Get all vendor contact
-- Execution:                 EXEC [dbo].[GetVendContactView]
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)   
-- Modified Desc:  
-- =============================================
ALTER PROCEDURE [dbo].[GetVendContactView]
 @userId BIGINT,
 @roleId BIGINT,
 @orgId BIGINT,
 @entity NVARCHAR(100),
 @pageNo INT,
 @pageSize INT,
 @orderBy NVARCHAR(500),
 @groupBy NVARCHAR(500), 
 @groupByWhere NVARCHAR(500), 
 @where NVARCHAR(500),
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

SET @TCountQuery = 'SELECT @TotalCount = COUNT(Id) FROM [dbo].[VEND010Contacts] (NOLOCK) '+ @entity 

--Below for getting user specific 'Statuses'
IF((ISNULL(@where, '') = '') OR (@where NOT LIKE '%'+@entity+'.StatusId%'))
	BEGIN
		SET @TCountQuery = @TCountQuery + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) fgus ON ' + @entity + '.[StatusId] = fgus.[StatusId] '
	END

SET @TCountQuery = @TCountQuery +' WHERE [VendVendorID] = @parentId ' + ISNULL(@where, '')
EXEC sp_executesql @TCountQuery, N'@parentId BIGINT, @userId BIGINT, @TotalCount INT OUTPUT', @parentId, @userId, @TotalCount  OUTPUT;

IF((ISNULL(@groupBy, '') = '') OR (@recordId > 0))
 BEGIN

IF(@recordId = 0)
	BEGIN
		SET @sqlCommand = 'SELECT ' + [dbo].[fnGetBaseQueryByUserId](@entity, @userId) 
		SET @sqlCommand = @sqlCommand + ' , vend.[VendCode] AS VendVendorIDName, cont.[ConFullName] AS VendContactMSTRIDName '
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

SET @sqlCommand = @sqlCommand + ' FROM [dbo].[VEND010Contacts] (NOLOCK) '+ @entity

--Below to get BIGINT reference key name by Id if NOT NULL
SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[VEND000Master] (NOLOCK) vend ON ' + @entity + '.[VendVendorID]=vend.[Id] '
SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[CONTC000Master] (NOLOCK) cont ON ' + @entity + '.[VendContactMSTRID]=cont.[Id] '
SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[SYSTM000Ref_States] (NOLOCK) sts ON cont.[ConBusinessStateId]=sts.[Id] '
SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[SYSTM000Ref_Options] (NOLOCK) sysRef ON cont.[ConBusinessCountryId]=sysRef.[Id] '

--Below for getting user specific 'Statuses'
IF((ISNULL(@where, '') = '') OR (@where NOT LIKE '%'+@entity+'.StatusId%'))
	BEGIN
		SET @sqlCommand = @sqlCommand + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) hfk ON ISNULL(' + @entity + '.[StatusId], 1) = hfk.[StatusId] '
	END

--Special case: Updating GroupByWhere if having ConBusinessFullAddress in this condition.
SET @groupByWhere = REPLACE(@groupByWhere, @entity+'.ConBusinessFullAddress', '( coalesce(cont.[ConBusinessAddress1], '''') + coalesce(CHAR(13) + cont.[ConBusinessAddress2], '''') + coalesce(CHAR(13) + cont.[ConBusinessCity], '''') + CASE WHEN ((coalesce(cont.[ConBusinessAddress1], '''') <> '''') OR (coalesce(cont.[ConBusinessAddress2], '''') <> '''') OR (coalesce(cont.[ConBusinessCity], '''') <> '''')) THEN coalesce('', '' + sts.[StateAbbr], '''') ELSE coalesce('''' + sts.[StateAbbr], '''') END + coalesce('', '' + cont.[ConBusinessZipPostal], '''') + coalesce(CHAR(13) + sysRef.[SysOptionName], '''') )')

SET @sqlCommand = @sqlCommand + ' WHERE 1=1 AND '+ @entity + '.[VendVendorID]=@parentId '+ ISNULL(@where, '') + ISNULL(@groupByWhere, '')  

IF((@recordId > 0) AND (((@isNext = 0) AND (@isEnd = 0)) OR ((@isNext = 1) AND (@isEnd = 0))))
	BEGIN
		IF((@isNext = 0) AND (@isEnd = 0))  
   BEGIN  
	IF(ISNULL(@orderBy, '') <> '')
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND ' + @orderBy + ' <= (SELECT ' + @orderBy + ' FROM [dbo].[VEND010Contacts] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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
		SET @sqlCommand = @sqlCommand + ' AND ' + @orderBy + ' >= (SELECT ' + @orderBy + ' FROM [dbo].[VEND010Contacts] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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

	IF(@groupBy = (@entity + '.VendVendorIDName'))
	 BEGIN
		SET @groupBy = ' vend.[VendCode] ';
		SET @SelectClauseToAdd = @SelectClauseToAdd + ' , vend.[VendCode] AS VendVendorIDName ';
	 END
	ELSE IF(@groupBy = (@entity + '.VendContactMSTRIDName'))
	 BEGIN
		SET @groupBy = ' cont.[ConFullName] ';
		SET @SelectClauseToAdd = @SelectClauseToAdd + ' , cont.[ConFullName] AS VendContactMSTRIDName ';
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
	SET @sqlCommand = @sqlCommand + ' FROM [dbo].[VEND010Contacts] (NOLOCK) '+ @entity 
	SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[VEND000Master] (NOLOCK) vend ON ' + @entity + '.[VendVendorID]=vend.[Id] '
	SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[CONTC000Master] (NOLOCK) cont ON ' + @entity + '.[VendContactMSTRID]=cont.[Id] '
	SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[SYSTM000Ref_States] (NOLOCK) sts ON cont.[ConBusinessStateId]=sts.[Id] '
	SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[SYSTM000Ref_Options] (NOLOCK) sysRef ON cont.[ConBusinessCountryId]=sysRef.[Id] '
	
	--Below for getting user specific 'Statuses'
	IF((ISNULL(@where, '') = '') OR (@where NOT LIKE '%'+@entity+'.StatusId%'))
		BEGIN
			SET @sqlCommand = @sqlCommand + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) fgus ON ISNULL(' + @entity + '.[StatusId], 1) = fgus.[StatusId] '
		END
	
	--Special case: Updating GroupByWhere if having ConBusinessFullAddress in this condition.
	SET @groupByWhere = REPLACE(@groupByWhere, @entity+'.ConBusinessFullAddress', '( coalesce(cont.[ConBusinessAddress1], '''') + coalesce(CHAR(13) + cont.[ConBusinessAddress2], '''') + coalesce(CHAR(13) + cont.[ConBusinessCity], '''') + coalesce('', '' + sts.[StateAbbr], '''') + coalesce('', '' + cont.[ConBusinessZipPostal], '''') + coalesce(CHAR(13) + sysRef.[SysOptionName], '''') )')

	SET @sqlCommand = @sqlCommand + ' WHERE 1=1 AND '+@entity+'.[VendVendorID] = @parentId ' + ISNULL(@groupByWhere, '')  
	SET @sqlCommand = @sqlCommand + ' GROUP BY ' + @groupBy 
	IF(ISNULL(@orderBy, '') <> '')
	 BEGIN
	 	SET @sqlCommand = @sqlCommand + ' ORDER BY '+ @orderBy
	 END

END

--To replace EntityName from custom column names
	 SET @sqlCommand = REPLACE(@sqlCommand, @entity+'.VendVendorIDName', 'vend.[VendCode]')
	 SET @sqlCommand = REPLACE(@sqlCommand, @entity+'.VendContactMSTRIDName', 'cont.[ConFullName]')
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

EXEC sp_executesql @sqlCommand, N'@pageNo INT, @pageSize INT, @orderBy NVARCHAR(500), @where NVARCHAR(500), @entity NVARCHAR(100), @parentId BIGINT,@userId BIGINT' ,
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
/****** Object:  StoredProcedure [dbo].[GetVendDCLocation]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
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
      ,vend.[VdcContactMSTRID]
      ,vend.[StatusId]
      ,vend.[EnteredBy]
      ,vend.[DateEntered]
      ,vend.[ChangedBy]
      ,vend.[DateChanged]
  FROM [dbo].[VEND040DCLocations] vend
 WHERE [Id]=@id
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetVendDcLocationContact]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
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
	,cont.ConCompany
	,cont.ConBusinessAddress1
	,cont.ConBusinessAddress2
	,cont.ConBusinessCity
	,cont.ConBusinessStateId
	,cont.ConBusinessZipPostal
	,cont.ConBusinessCountryId
	FROM [dbo].[VEND040DCLocations]  vdc
	JOIN [dbo].[CONTC000Master] cont ON vdc.VdcContactMSTRID = cont.Id
	WHERE vdc.Id = @parentId
 END
 ELSE
 BEGIN
 SELECT vend.[Id] AS 'VlcContactMSTRID'
		,vend.[VlcVendDcLocationId]
		,vend.[VlcItemNumber]
		,vend.[VlcContactCode]
		,vend.[VlcContactTitle]
		,vend.[VlcContactMSTRID] AS 'Id'
		,vend.[VlcAssignment]
		,vend.[VlcGateway]
		,vend.[StatusId]
		--,vend.[EnteredBy]
		--,vend.[DateEntered]
		--,vend.[ChangedBy]
		--,vend.[DateChanged]
		,ve.Id AS ParentId
		
		,cont.ConTitleId
		,cont.ConFirstName
		,cont.ConMiddleName
		,cont.ConLastName
		,cont.ConJobTitle
		,cont.ConCompany
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
  FROM [dbo].[VEND041DCLocationContacts] vend
  JOIN [dbo].[VEND040DCLocations] cdc ON vend.VlcVendDcLocationId = cdc.Id
  JOIN [dbo].[VEND000Master] ve ON cdc.VdcVendorID = ve.Id
  JOIN [dbo].[CONTC000Master] cont ON vend.VlcContactMSTRID = cont.Id
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
/****** Object:  StoredProcedure [dbo].[GetVendDcLocationContactView]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
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
 @where NVARCHAR(500),  
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
  
SET @TCountQuery = 'SELECT @TotalCount = COUNT(Id) FROM [dbo].[VEND041DCLocationContacts] (NOLOCK) '+ @entity   
  
--Below for getting user specific 'Statuses'  
IF((ISNULL(@where, '') = '') OR (@where NOT LIKE '%'+@entity+'.StatusId%'))  
 BEGIN  
  SET @TCountQuery = @TCountQuery + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) fgus ON ' + @entity + '.[StatusId] = fgus.[StatusId] '  
 END  
  
SET @TCountQuery = @TCountQuery + ' WHERE [VlcVendDcLocationId] = @parentId ' + ISNULL(@where, '')  
  
EXEC sp_executesql @TCountQuery, N' @orgId BIGINT, @parentId BIGINT, @userId BIGINT, @TotalCount INT OUTPUT',  @orgId, @parentId, @userId, @TotalCount  OUTPUT;  
  
IF(@recordId = 0)  
 BEGIN  
  SET @sqlCommand = 'SELECT ' + [dbo].[fnGetBaseQueryByUserId](@entity, @userId)   
  SET @sqlCommand = @sqlCommand + ' , cont.[ConFullName] AS VlcContactMSTRIDName, refOp.SysOptionName AS VendorType, cont.ConBusinessPhone AS ConBusinessPhone, cont.ConBusinessPhoneExt AS ConBusinessPhoneExt, cont.ConMobilePhone AS ConMobilePhone '  
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
  
 SET @sqlCommand = @sqlCommand + ' FROM [dbo].[VEND041DCLocationContacts] (NOLOCK) '+ @entity  
  
--Below to get BIGINT reference key name by Id if NOT NULL  
SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[CONTC000Master] (NOLOCK) cont ON ' + @entity + '.[VlcContactMSTRID]=cont.[Id] '  
SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[SYSTM000Ref_Options] (NOLOCK) refOp ON cont.ConUDF01=refOp.[Id] '  
  
--Below for getting user specific 'Statuses'  
IF((ISNULL(@where, '') = '') OR (@where NOT LIKE '%'+@entity+'.StatusId%'))  
 BEGIN  
  SET @sqlCommand = @sqlCommand + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) hfk ON ISNULL(' + @entity + '.[StatusId], 1) = hfk.[StatusId] '  
 END  
  
SET @sqlCommand = @sqlCommand + ' WHERE '+ @entity + '.[VlcVendDcLocationId]=@parentId ' + ISNULL(@where, '')  
  
  
IF((@recordId > 0) AND (((@isNext = 0) AND (@isEnd = 0)) OR ((@isNext = 1) AND (@isEnd = 0))))  
 BEGIN  
  IF((@isNext = 0) AND (@isEnd = 0))  
   BEGIN  
	IF(ISNULL(@orderBy, '') <> '')
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND ' + @orderBy + ' <= (SELECT ' + @orderBy + ' FROM [dbo].[VEND041DCLocationContacts] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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
		SET @sqlCommand = @sqlCommand + ' AND ' + @orderBy + ' >= (SELECT ' + @orderBy + ' FROM [dbo].[VEND041DCLocationContacts] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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
EXEC sp_executesql @sqlCommand, N'@pageNo INT, @pageSize INT, @entity NVARCHAR(100), @orderBy NVARCHAR(500), @where NVARCHAR(500), @orgId BIGINT, @parentId BIGINT,@userId BIGINT' ,  
    
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
/****** Object:  StoredProcedure [dbo].[GetVendDCLocationView]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
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
 @where NVARCHAR(500),
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

SET @TCountQuery = 'SELECT @TotalCount = COUNT(Id) FROM [dbo].[VEND040DCLocations] (NOLOCK) '+ @entity 

--Below for getting user specific 'Statuses'
IF((ISNULL(@where, '') = '') OR (@where NOT LIKE '%'+@entity+'.StatusId%'))
	BEGIN
		SET @TCountQuery = @TCountQuery + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) fgus ON ' + @entity + '.[StatusId] = fgus.[StatusId] '
	END

SET @TCountQuery = @TCountQuery + ' WHERE [VdcVendorID] = @parentId ' + ISNULL(@where, '')
EXEC sp_executesql @TCountQuery, N'@parentId BIGINT, @userId BIGINT, @TotalCount INT OUTPUT', @parentId, @userId, @TotalCount  OUTPUT;

IF((ISNULL(@groupBy, '') = '') OR (@recordId > 0))
BEGIN

IF(@recordId = 0)
	BEGIN
		SET @sqlCommand = 'SELECT ' + [dbo].[fnGetBaseQueryByUserId](@entity, @userId) 
		SET @sqlCommand = @sqlCommand + ' , vend.[VendCode] AS VdcVendorIDName, cont.[ConFullName] AS VdcContactMSTRIDName '
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

SET @sqlCommand = @sqlCommand + ' FROM [dbo].[VEND040DCLocations] (NOLOCK) '+ @entity

--Below to get BIGINT reference key name by Id if NOT NULL
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
SET @groupByWhere = REPLACE(@groupByWhere, @entity+'.ConBusinessFullAddress', '( coalesce(cont.[ConBusinessAddress1], '''') + coalesce(CHAR(13) + cont.[ConBusinessAddress2], '''') + coalesce(CHAR(13) + cont.[ConBusinessCity], '''') + CASE WHEN ((coalesce(cont.[ConBusinessAddress1], '''') <> '''') OR (coalesce(cont.[ConBusinessAddress2], '''') <> '''') OR (coalesce(cont.[ConBusinessCity], '''') <> '''')) THEN coalesce('', '' + sts.[StateAbbr], '''') ELSE coalesce('''' + sts.[StateAbbr], '''') END + coalesce('', '' + cont.[ConBusinessZipPostal], '''') + coalesce(CHAR(13) + sysRef.[SysOptionName], '''') )')


SET @sqlCommand = @sqlCommand + ' WHERE 1=1 AND '+ @entity + '.[VdcVendorID]=@parentId '+ ISNULL(@where, '') + ISNULL(@groupByWhere, '')  

IF((@recordId > 0) AND (((@isNext = 0) AND (@isEnd = 0)) OR ((@isNext = 1) AND (@isEnd = 0))))
	BEGIN
		IF((@isNext = 0) AND (@isEnd = 0))  
   BEGIN  
	IF(ISNULL(@orderBy, '') <> '')
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND ' + @orderBy + ' <= (SELECT ' + @orderBy + ' FROM [dbo].[VEND040DCLocations] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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
		SET @sqlCommand = @sqlCommand + ' AND ' + @orderBy + ' >= (SELECT ' + @orderBy + ' FROM [dbo].[VEND040DCLocations] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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

EXEC sp_executesql @sqlCommand, N'@pageNo INT, @pageSize INT, @orderBy NVARCHAR(500), @where NVARCHAR(500), @entity NVARCHAR(100), @parentId BIGINT,@userId BIGINT' ,
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
/****** Object:  StoredProcedure [dbo].[GetVendDocReference]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               08/16/2018      
-- Description:               Get a vend doc ref
-- Execution:                 EXEC [dbo].[GetVendDocReference]
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)    
-- Modified Desc:  
-- =============================================
ALTER PROCEDURE  [dbo].[GetVendDocReference]
    @userId BIGINT,
    @roleId BIGINT,
	@orgId BIGINT,
    @id BIGINT
AS
BEGIN TRY                
 SET NOCOUNT ON;   
SELECT vend.[Id]
      ,vend.[VdrOrgID]
      ,vend.[VdrVendorID]
      ,vend.[VdrItemNumber]
      ,vend.[VdrCode]
      ,vend.[VdrTitle]
      ,vend.[DocRefTypeId]
      ,vend.[DocCategoryTypeId]
      ,vend.[VdrAttachment]
      ,vend.[VdrDateStart]
      ,vend.[VdrDateEnd]
      ,vend.[VdrRenewal]
      ,vend.[StatusId]
      ,vend.[EnteredBy]
      ,vend.[DateEntered]
      ,vend.[ChangedBy]
      ,vend.[DateChanged]
  FROM [dbo].[VEND030DocumentReference] vend
 WHERE [Id]=@id
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetVendDocReferenceView]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               09/04/2018      
-- Description:               Get all vendor document reference
-- Execution:                 EXEC [dbo].[GetVendDocReferenceView]
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)    
-- Modified Desc:  
-- =============================================
ALTER PROCEDURE [dbo].[GetVendDocReferenceView]
 @userId BIGINT,
 @roleId BIGINT,
 @orgId BIGINT,
 @entity NVARCHAR(100),
 @pageNo INT,
 @pageSize INT,
 @orderBy NVARCHAR(500),
 @groupBy NVARCHAR(500), 
 @groupByWhere NVARCHAR(500), 
 @where NVARCHAR(500),
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

SET @TCountQuery = 'SELECT @TotalCount = COUNT(Id) FROM [dbo].[VEND030DocumentReference] (NOLOCK) '+ @entity 

--Below for getting user specific 'Statuses'
IF((ISNULL(@where, '') = '') OR (@where NOT LIKE '%'+@entity+'.StatusId%'))
	BEGIN
		SET @TCountQuery = @TCountQuery + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) fgus ON ' + @entity + '.[StatusId] = fgus.[StatusId] '
	END

SET @TCountQuery = @TCountQuery + ' WHERE [VdrVendorID] = @parentId AND [VdrOrgId] = @orgId ' + ISNULL(@where, '')
EXEC sp_executesql @TCountQuery, N'@parentId BIGINT, @orgId BIGINT, @userId BIGINT, @TotalCount INT OUTPUT', @parentId, @orgId, @userId, @TotalCount  OUTPUT;

IF(@recordId = 0)
	BEGIN
		SET @sqlCommand = 'SELECT ' + [dbo].[fnGetBaseQueryByUserId](@entity, @userId) 
		SET @sqlCommand = @sqlCommand + ' ,org.[OrgCode] AS VdrOrgIDName, vend.[VendCode] AS VdrVendorIDName '
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

SET @sqlCommand = @sqlCommand + ' FROM [dbo].[VEND030DocumentReference] (NOLOCK) '+ @entity

--Below to get BIGINT reference key name by Id if NOT NULL
SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[ORGAN000Master] (NOLOCK) org ON ' + @entity + '.[VdrOrgID]=org.[Id] '
SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[VEND000Master] (NOLOCK) vend ON ' + @entity + '.[VdrVendorID]=vend.[Id] '

--Below for getting user specific 'Statuses'
IF((ISNULL(@where, '') = '') OR (@where NOT LIKE '%'+@entity+'.StatusId%'))
	BEGIN
		SET @sqlCommand = @sqlCommand + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) hfk ON ISNULL(' + @entity + '.[StatusId], 1) = hfk.[StatusId] '
	END

SET @sqlCommand = @sqlCommand + ' WHERE '+@entity+'.[VdrOrgId] = @orgId AND '+ @entity + '.[VdrVendorID]=@parentId '+ ISNULL(@where, '')

IF((@recordId > 0) AND (((@isNext = 0) AND (@isEnd = 0)) OR ((@isNext = 1) AND (@isEnd = 0))))
	BEGIN
		IF((@isNext = 0) AND (@isEnd = 0))  
   BEGIN  
	IF(ISNULL(@orderBy, '') <> '')
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND ' + @orderBy + ' <= (SELECT ' + @orderBy + ' FROM [dbo].[VEND030DocumentReference] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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
		SET @sqlCommand = @sqlCommand + ' AND ' + @orderBy + ' >= (SELECT ' + @orderBy + ' FROM [dbo].[VEND030DocumentReference] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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

EXEC sp_executesql @sqlCommand, N'@pageNo INT, @pageSize INT, @orderBy NVARCHAR(500), @where NVARCHAR(500), @orgId BIGINT, @entity NVARCHAR(100), @parentId BIGINT,@userId BIGINT' ,
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
/****** Object:  StoredProcedure [dbo].[GetVendFinancialCalender]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               08/16/2018      
-- Description:               Get a vend Fin Cal
-- Execution:                 EXEC [dbo].[GetVendFinancialCalender]
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)   
-- Modified Desc:  
-- ============================================= 
ALTER PROCEDURE  [dbo].[GetVendFinancialCalender]
    @userId BIGINT,
    @roleId BIGINT,
	@orgId BIGINT,
    @id BIGINT
AS
BEGIN TRY                
 SET NOCOUNT ON;   
SELECT vend.[Id]
      ,vend.[OrgID]
      ,vend.[VendID]
      ,vend.[FclPeriod]
      ,vend.[FclPeriodCode]
      ,vend.[FclPeriodStart]
      ,vend.[FclPeriodEnd]
      ,vend.[FclPeriodTitle]
      ,vend.[FclAutoShortCode]
      ,vend.[FclWorkDays]
      ,vend.[FinCalendarTypeId]
      ,vend.[StatusId]
      ,vend.[DateEntered]
      ,vend.[EnteredBy]
      ,vend.[DateChanged]
      ,vend.[ChangedBy]
  FROM [dbo].[VEND050Finacial_Cal] vend
 WHERE [Id]=@id
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetVendFinancialCalenderView]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               09/04/2018      
-- Description:               Get all vendor finance calander 
-- Execution:                 EXEC [dbo].[GetVendFinancialCalenderView]
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)    
-- Modified Desc:  
-- =============================================
ALTER PROCEDURE [dbo].[GetVendFinancialCalenderView]
 @userId BIGINT,
 @roleId BIGINT,
 @orgId BIGINT,
 @entity NVARCHAR(100),
 @pageNo INT,
 @pageSize INT,
 @orderBy NVARCHAR(500),
 @groupBy NVARCHAR(500), 
 @groupByWhere NVARCHAR(500), 
 @where NVARCHAR(500),
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

SET @TCountQuery = 'SELECT @TotalCount = COUNT(Id) FROM [dbo].[VEND050Finacial_Cal] (NOLOCK) '+ @entity 

--Below for getting user specific 'Statuses'
IF((ISNULL(@where, '') = '') OR (@where NOT LIKE '%'+@entity+'.StatusId%'))
	BEGIN
		SET @TCountQuery = @TCountQuery + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) fgus ON ' + @entity + '.[StatusId] = fgus.[StatusId] '
	END

SET @TCountQuery = @TCountQuery + ' WHERE [VendID] = @parentId AND [OrgId] = @orgId ' + ISNULL(@where, '')
EXEC sp_executesql @TCountQuery, N'@parentId BIGINT, @orgId BIGINT, @userId BIGINT, @TotalCount INT OUTPUT', @parentId, @orgId, @userId, @TotalCount  OUTPUT;

IF(@recordId = 0)
	BEGIN
		SET @sqlCommand = 'SELECT ' + [dbo].[fnGetBaseQueryByUserId](@entity, @userId) 
		SET @sqlCommand = @sqlCommand + ' ,org.[OrgCode] AS OrgIDName, vend.[VendCode] AS VendIDName '
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

SET @sqlCommand = @sqlCommand + ' FROM [dbo].[VEND050Finacial_Cal] (NOLOCK) '+ @entity

--Below to get BIGINT reference key name by Id if NOT NULL
SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[ORGAN000Master] (NOLOCK) org ON ' + @entity + '.[OrgID]=org.[Id] '
SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[VEND000Master] (NOLOCK) vend ON ' + @entity + '.[VendID]=vend.[Id] '

--Below for getting user specific 'Statuses'
IF((ISNULL(@where, '') = '') OR (@where NOT LIKE '%'+@entity+'.StatusId%'))
	BEGIN
		SET @sqlCommand = @sqlCommand + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) hfk ON ISNULL(' + @entity + '.[StatusId], 1) = hfk.[StatusId] '
	END

SET @sqlCommand = @sqlCommand + ' WHERE '+@entity+'.[OrgId] = @orgId AND '+ @entity + '.[VendID]=@parentId '+ ISNULL(@where, '')

IF((@recordId > 0) AND (((@isNext = 0) AND (@isEnd = 0)) OR ((@isNext = 1) AND (@isEnd = 0))))
	BEGIN
		IF((@isNext = 0) AND (@isEnd = 0))  
   BEGIN  
	IF(ISNULL(@orderBy, '') <> '')
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND ' + @orderBy + ' <= (SELECT ' + @orderBy + ' FROM [dbo].[VEND050Finacial_Cal] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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
		SET @sqlCommand = @sqlCommand + ' AND ' + @orderBy + ' >= (SELECT ' + @orderBy + ' FROM [dbo].[VEND050Finacial_Cal] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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

EXEC sp_executesql @sqlCommand, N'@pageNo INT, @pageSize INT, @orderBy NVARCHAR(500), @where NVARCHAR(500), @orgId BIGINT, @entity NVARCHAR(100), @parentId BIGINT,@userId BIGINT' ,
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
/****** Object:  StoredProcedure [dbo].[GetVendor]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               08/16/2018      
-- Description:               Get a Vender
-- Execution:                 EXEC [dbo].[GetVendor]
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)    
-- Modified Desc:  
-- ============================================= 
ALTER PROCEDURE  [dbo].[GetVendor]
    @userId BIGINT,
    @roleId BIGINT,
	@orgId BIGINT,
    @id BIGINT
AS
BEGIN TRY                
 SET NOCOUNT ON;   
SELECT vend.[Id]
      ,vend.[VendERPID]
      ,vend.[VendOrgID]
      ,vend.[VendItemNumber]
      ,vend.[VendCode]
      ,vend.[VendTitle]
      ,vend.[VendWorkAddressId]
      ,vend.[VendBusinessAddressId]
      ,vend.[VendCorporateAddressId]
      ,vend.[VendContacts]
      ,vend.[VendLogo]
      ,vend.[VendTypeId]
      ,vend.[VendWebPage]
      ,vend.[StatusId]
      ,vend.[EnteredBy]
      ,vend.[DateEntered]
      ,vend.[ChangedBy]
      ,vend.[DateChanged]
	  ,org.OrgCode as 'RoleCode'
  FROM [dbo].[VEND000Master] vend
  INNER JOIN [dbo].[ORGAN000Master] org ON vend.VendOrgID = org.Id
 WHERE vend.[Id]=@id 
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetVendorLocations]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Janardana         
-- Create date:               02/28/2018      
-- Description:               Get all Vendor location by id  
-- Execution:                 EXEC [dbo].[GetVendorLocations]
-- Modified on:  
-- Modified Desc:  
-- =============================================                
ALTER PROCEDURE [dbo].[GetVendorLocations] 
     @id BIGINT,
	 @pageNo INT,  
	 @pageSize INT,  
	 @orderBy NVARCHAR(500),  
	 @like NVARCHAR(500) = NULL,  
	 @where NVARCHAR(500) = null,
	 @primaryKeyValue NVARCHAR(100) = null,
	 @primaryKeyName NVARCHAR(50) = null      

AS                  
BEGIN TRY         
 SET NOCOUNT ON;  
 DECLARE @programId BIGINT,@vendorId BIGINT
 DECLARE @newPgNo INT
 SELECT @programId = PvlProgramID,@vendorId = PvlVendorID  FROM  [dbo].[PRGRM051VendorLocations](NOLOCK) WHERE Id =@id;
 
 IF(ISNULL(@primaryKeyValue, '') > '')
  BEGIN
	SELECT @newPgNo = Item FROM (SELECT ROW_NUMBER() OVER(ORDER BY Id) as Item, Id FROM [dbo].[PRGRM051VendorLocations] (NOLOCK) 
	WHERE PvlProgramID =@programId AND  PvlVendorID =@vendorId AND StatusId IN (1,2) ) t WHERE t.Id = @primaryKeyValue
	SET @newPgNo =  @newPgNo/@pageSize + 1; 
	SET @pageSize = @newPgNo * @pageSize;
  END

  SELECT Id, PvlLocationCode FROM  [dbo].[PRGRM051VendorLocations](NOLOCK) 
  WHERE  PvlProgramID =@programId 
    AND  PvlVendorID =@vendorId 
   AND StatusId IN (1,2)  
 ORDER BY Id OFFSET @pageSize * (@pageNo - 1) ROWS FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);   
                
END TRY                  
BEGIN CATCH                  
                  
 DECLARE @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE()),                  
   @ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY()),                  
   @RelatedTo VARCHAR(100)  = (SELECT OBJECT_NAME(@@PROCID))                  
 EXEC [ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage , NULL, NULL, @ErrorSeverity                  
                  
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[GetVendorView]    Script Date: 11/26/2018 8:31:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               11/04/2018      
-- Description:               Get all vendor
-- Execution:                 EXEC [dbo].[GetVendorView]
-- Modified on:				  11/26/2018( Nikhil - Introduced roleId to support security)    
-- Modified Desc:  
-- =============================================
ALTER PROCEDURE [dbo].[GetVendorView]
 @userId BIGINT,
 @roleId BIGINT,
 @orgId BIGINT,
 @entity NVARCHAR(100),
 @pageNo INT,
 @pageSize INT,
 @orderBy NVARCHAR(500),
 @groupBy NVARCHAR(500), 
 @groupByWhere NVARCHAR(500), 
 @where NVARCHAR(500),
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

SET @TCountQuery = 'SELECT @TotalCount = COUNT(Id) FROM [dbo].[VEND000Master] (NOLOCK) '+ @entity 

--Below for getting user specific 'Statuses'
IF((ISNULL(@where, '') = '') OR (@where NOT LIKE '%'+@entity+'.StatusId%'))
	BEGIN
		SET @TCountQuery = @TCountQuery + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) fgus ON ' + @entity + '.[StatusId] = fgus.[StatusId] '
	END

SET @TCountQuery = @TCountQuery + ' WHERE [VendOrgId] = @orgId ' + ISNULL(@where, '')
EXEC sp_executesql @TCountQuery, N'@orgId BIGINT, @userId BIGINT, @TotalCount INT OUTPUT', @orgId, @userId, @TotalCount  OUTPUT;

IF(@recordId = 0)
	BEGIN
		SET @sqlCommand = 'SELECT ' + [dbo].[fnGetBaseQueryByUserId](@entity, @userId) 
		SET @sqlCommand = @sqlCommand + ' ,org.[OrgCode] AS VendOrgIDName, contWA.[ConFullName] AS VendWorkAddressIdName, ' + 
										' contBA.[ConFullName] AS VendBusinessAddressIdName, contCA.[ConFullName] AS VendCorporateAddressIdName '
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

SET @sqlCommand = @sqlCommand + ' FROM [dbo].[VEND000Master] (NOLOCK) '+ @entity

--Below to get BIGINT reference key name by Id if NOT NULL
SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[ORGAN000Master] (NOLOCK) org ON ' + @entity + '.[VendOrgID] = org.[Id] '
SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[CONTC000Master] (NOLOCK) contWA ON ' + @entity + '.[VendWorkAddressId] = contWA.[Id] '
SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[CONTC000Master] (NOLOCK) contBA ON ' + @entity + '.[VendBusinessAddressId] = contBA.[Id] '
SET @sqlCommand = @sqlCommand + ' LEFT JOIN [dbo].[CONTC000Master] (NOLOCK) contCA ON ' + @entity + '.[VendCorporateAddressId] = contCA.[Id] '

--Below for getting user specific 'Statuses'
IF((ISNULL(@where, '') = '') OR (@where NOT LIKE '%'+@entity+'.StatusId%'))
	BEGIN
		SET @sqlCommand = @sqlCommand + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) hfk ON ' + @entity + '.[StatusId] = hfk.[StatusId] '
	END

SET @sqlCommand = @sqlCommand + ' WHERE '+@entity+'.[VendOrgId] = @orgId '+ ISNULL(@where, '')

IF((@recordId > 0) AND (((@isNext = 0) AND (@isEnd = 0)) OR ((@isNext = 1) AND (@isEnd = 0))))
	BEGIN
		IF((@isNext = 0) AND (@isEnd = 0))  
   BEGIN  
	IF(ISNULL(@orderBy, '') <> '')
	 BEGIN
		SET @sqlCommand = @sqlCommand + ' AND ' + @orderBy + ' <= (SELECT ' + @orderBy + ' FROM [dbo].[VEND000Master] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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
		SET @sqlCommand = @sqlCommand + ' AND ' + @orderBy + ' >= (SELECT ' + @orderBy + ' FROM [dbo].[VEND000Master] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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

EXEC sp_executesql @sqlCommand, N'@pageNo INT, @pageSize INT, @orderBy NVARCHAR(500), @where NVARCHAR(500), @orgId BIGINT, @entity NVARCHAR(100),@userId BIGINT' ,
	 @entity= @entity,
     @pageNo= @pageNo, 
     @pageSize= @pageSize,
     @orderBy = @orderBy,
     @where = @where,
	 @orgId = @orgId,
	 @userId = @userId
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
