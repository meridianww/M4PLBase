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
CREATE PROCEDURE [dbo].[GetJobTreeViewData]                     
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
