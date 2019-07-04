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
CREATE PROCEDURE [dbo].[GetCustPPPTree]  
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
