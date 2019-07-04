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
CREATE  PROCEDURE [dbo].[GetProgramTreeViewData]                
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
