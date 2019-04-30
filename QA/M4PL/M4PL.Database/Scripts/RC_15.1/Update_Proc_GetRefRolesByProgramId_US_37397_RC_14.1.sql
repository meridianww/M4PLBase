/****** Object:  StoredProcedure [dbo].[GetRefRolesByProgramId]    Script Date: 9/20/2018 2:56:47 PM ******/
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




