ALTER PROCEDURE [dbo].[UdtCopyPPPModel]    
 (    
 @UdtCopyPPPModel CopyPPPModel READONLY,    
 @createdBy NVARCHAR(50),      
 @OrgId BIGINT ,    
 @userId BIGINT,     
 @langCode NVARCHAR(10)    
 )    
AS                                    
BEGIN TRY                                    
     
 --INSERT ParentId NUll Records -- only one record exist    
 DECLARE @recordId BIGINT ,@IsSelected BIT ,@configIds NVARCHAR(MAX), @toCustOrPPIds NVARCHAR(MAX)    
 SELECT @recordId = RecordId    
       ,@IsSelected = SelectAll    
    ,@configIds = ConfigurationIds    
    ,@toCustOrPPIds = ToPPPIds    
  FROM @UdtCopyPPPModel Where (ParentId  IS NULL OR ParentId = 0);     
    
	IF LEN(@configIds) = 0
	BEGIN
	 SET @configIds = NULL;
	END

 -- Get the Current Record Hierarchy Level    
 DECLARE @HierarchyLevel INT      
 SELECT @HierarchyLevel = PrgHierarchyLevel FROM PRGRM000Master Where Id = @recordId;      
    
 DECLARE @CustPPPIdTables TABLE(PrimaryId INT PRIMARY KEY IDENTITY(1,1),Id BIGINT);      
     
 --Insert Target PPP Ids or Customer Ids Into Table     
 INSERT INTO @CustPPPIdTables(Id)      
 SELECT item FROM [dbo].[fnSplitString](@toCustOrPPIds,',');      
    
    
 DECLARE @pId INT  = 1    
 DECLARE @targetId BIGINT    
 SELECT @targetId = Id FROM @CustPPPIdTables Where PrimaryId = @pId;    




    
 --Loop the targets Ids and     
    
 While(@targetId IS NOT NULL)      
 BEGIN     
    
    --Find customerId ,Hierarchy Id     
     DECLARE @custId BIGINT, @HieId hierarchyid;    
     
  IF @HierarchyLevel = 1    
  BEGIN    
   SET @custId = @targetId;    
   SET @HieId =  hierarchyid::GetRoot().GetDescendant((select MAX(PrgHierarchyID) from [dbo].[PRGRM000Master]  where PrgHierarchyID.GetAncestor(1) = hierarchyid::GetRoot()),NULL);    
  END    
    
  ELSE IF (@HierarchyLevel = 2 OR @HierarchyLevel = 3)    
  BEGIN    
   Declare @parentNode hierarchyid, @lc hierarchyid ;    
    
   SELECT  @custId = PrgCustId, @parentNode = [PrgHierarchyID] FROM  [dbo].[PRGRM000Master]  WHERE Id = @targetId;     
    
   SELECT @lc = max(PrgHierarchyID)  FROM   [dbo].[PRGRM000Master]   WHERE PrgHierarchyID.GetAncestor(1)  = @parentNode ;     
    
   SET @HieId =  @parentNode.GetDescendant(@lc, NULL)         
  END    
    

    
  -- Get The Configuration Ids     
  IF @IsSelected = 1     
  BEGIN    
          
  SELECT @configIds = COALESCE(@configIds+',' ,'') + TabTableName   FROM [dbo].[SYSTM030Ref_TabPageName]    
  WHERE LangCode= @langCode AND  RefTablename = 'Program' And TabTableName <> 'Program'    
  AND TabTableName NOT IN (    
  select RefTableName from [dbo].[SYSTM000SecurityByRole] Sbr     
    INNER JOIN  [dbo].[SYSTM010SubSecurityByRole] subSbr ON sbr.Id  = subSbr.SecByRoleId    
   INNER JOIN [dbo].[CONTC010Bridge] cb ON cb.ConCodeId = sbr.OrgRefRoleId AND cb.ConTableName = [dbo].fnGetEntityName(1)
	Where cb.ContactMSTRID =@userId     
    AND cb.ConOrgId = @OrgId     
    AND sbr.StatusID =1     
    AND sbr.SecMainModuleId = 12    
    AND subSbr.StatusId =1    
    )  ; 
	 
  END    
   

  --Insert PPP    
  EXEC CopyPPPLevel @recordId , @custId , @OrgId , @configIds , @createdBy,@HieId ,@IsSelected,@toCustOrPPIds, @langCode ,@userId ,@UdtCopyPPPModel;  
  
  -- loop the remaining records  
  
  
  
  
      
  --Increment the Loop    
  SET @pId = @pId + 1;      
  SET @targetId = NULL;    
  SELECT @targetId = Id FROM @CustPPPIdTables Where PrimaryId = @pId;      
    
 END    
    
           
                  
END TRY                                    
BEGIN CATCH                                    
                                    
  DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                              
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                              
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                              
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                                 
                                    
END CATCH
GO

