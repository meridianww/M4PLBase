
GO
/* Copyright (2018) Meridian Worldwide Transportation Group        
   All Rights Reserved Worldwide */        
-- =============================================                
-- Author:                    Janardana Behara                 
-- Create date:               06/06/2018              
-- Description:               Copy ActRole On ProgramCreate    
-- Execution:                 EXEC [dbo].[CopyActRoleOnProgramCreate]        
-- Modified on:          
-- Modified Desc:          
-- =============================================        
        
ALTER  PROCEDURE  [dbo].[CopyActRoleOnProgramCreate]        
		(@userId BIGINT        
		,@roleId BIGINT        
		,@orgId bigint        
		,@custId bigint      
		,@programId bigint      
		,@dateEntered datetime2(7)        
		,@enteredBy nvarchar(50)         
		)        
AS        
BEGIN TRY                        
 SET NOCOUNT ON;          
       
        
 DECLARE @hierarchyLevel INT        
 SELECT  @hierarchyLevel = PrgHierarchyLevel FROM  [dbo].[PRGRM000Master]   WHERE Id = @programId;        
        
        
  --Insert Into Customer Contacts    When program Created and PPP is Opted in ActRoles      
  DECLARE @ccMaxNumber INT        
  SELECT @ccMaxNumber = MAX(CustItemNumber) FROM [CUST010Contacts] WHERE CustCustomerID = @custId AND StatusId In (1,2)        
        
  INSERT INTO [dbo].[CUST010Contacts]        
           ([CustCustomerID]        
           ,[CustItemNumber]                   
           ,[CustContactMSTRID]        
           ,[StatusId]        
           ,[EnteredBy]        
           ,[DateEntered])        
SELECT @custId,(ROW_NUMBER() Over(Order By OrgRoleSortOrder) + ISNULL(@ccMaxNumber,0)),OrgRoleContactID,ISNULL(StatusId,1), @enteredBy,@dateEntered        
  from  [dbo].[ORGAN020Act_Roles]         
   WHERE(@hierarchyLevel = 1 OR @hierarchyLevel = 2 OR @hierarchyLevel = 3 OR PrxJobDefaultAnalyst = 1 OR PrxJobDefaultResponsible = 1    
           )        
    AND OrgID = @orgId      
    AND ISNULL(StatusId,1) = 1        
 AND OrgRoleContactID IS NOT NULL      
    AND OrgRoleContactID NOT IN( SELECT CustContactMSTRID FROM [CUST010Contacts] WHERE CustCustomerID = @custId);        
  
  -- Update Customer's Contact  Count after Customer Contact insertion
  UPDATE [dbo].[CUST000Master] SET CustContacts = (SELECT Count(Id) FROM [CUST010Contacts] WHERE CustCustomerID = @custId AND StatusId in(1,2)) WHERE Id = @custId
      
 --Insert Into Program roles(Contacts tab) When PPP Logicals are checked in Reference Roles        
  DECLARE @rcMaxNumber INT        
  SELECT @rcMaxNumber = MAX(PrgRoleSortOrder) FROM [PRGRM020Program_Role] WHERE ProgramID = @programId AND StatusId In (1,2)        
      
  INSERT INTO [dbo].[PRGRM020Program_Role] (        
         [OrgID]        
  ,[ProgramID]        
  ,[PrgRoleSortOrder]        
  ,[OrgRefRoleId]        
  ,[PrgRoleId]        
  ,[PrgRoleTitle]        
  ,[PrgRoleContactID]        
  ,[RoleTypeId]        
  ,[StatusId]  
  ,[PrxJobDefaultAnalyst]
  ,[PrxJobDefaultResponsible]
  ,[PrxJobGWDefaultAnalyst]
  ,[PrxJobGWDefaultResponsible]
  ,[DateEntered] 
  ,[EnteredBy]        
  )        
  SELECT 
  @orgId
  ,@programId
  , ROW_NUMBER() Over(Order By OrgRoleSortOrder) + ISNULL(@rcMaxNumber,0)
  ,[OrgRefRoleId]
  ,NUll
  ,NULL
  ,OrgRoleContactID
  ,RoleTypeId
  ,ISNULL(StatusId,1)  
  ,[PrxJobDefaultAnalyst]
  ,[PrxJobDefaultResponsible]
  ,[PrxJobGWDefaultAnalyst]
  ,[PrxJobGWDefaultResponsible]  
  ,@dateEntered
  ,@enteredBy         
  from  [dbo].[ORGAN020Act_Roles]        
   WHERE         
     ( @hierarchyLevel = 1  OR @hierarchyLevel = 2 OR @hierarchyLevel = 3 OR PrxJobDefaultAnalyst = 1 OR PrxJobDefaultResponsible = 1      
     )        
  AND OrgID = @orgId      
  AND OrgRoleContactID IS NOT NULL      
     AND ISNULL(StatusId,1) = 1      
     AND OrgRoleContactID NOT IN( SELECT PrgRoleContactID FROM PRGRM020Program_Role WHERE [ProgramID] = @programId);        
        
         
        
END TRY                      
BEGIN CATCH                        
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                        
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                        
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                        
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                        
END CATCH
GO
PRINT N'Altering [dbo].[CopyRefRoles]...';


GO
/*Copyright (2018) Meridian Worldwide Transportation Group
  All Rights Reserved Worldwide */
-- =====================================================================  
-- Author:                    Akhil Chauhan              
-- Create date:               08/16/2018
-- Description:               Copy Ref Roles Rows to Act Roles  
-- Execution:                 EXEC [dbo].[CopyRefRoles]   
-- Modified on:  
-- Modified Desc:  
-- ======================================================================        
ALTER PROCEDURE  [dbo].[CopyRefRoles] 
 @orgId BIGINT,     
 @enteredBy NVARCHAR(50)    
AS    
BEGIN TRY                    
 SET NOCOUNT ON;  
   
 -- INSERT INTO ACTROLE RoleId from RefRole Table
         
 INSERT INTO [dbo].[ORGAN020Act_Roles](    
       [OrgID]    
      ,[OrgRoleSortOrder]    
      ,[OrgRefRoleId]    
      ,[OrgRoleDefault]    
      ,[OrgRoleTitle]    
      ,[OrgRoleContactID]    
      ,[RoleTypeId]    
      ,[StatusId]    
      ,[OrgRoleDescription]    
      ,[OrgComments]    
      ,[PrxJobDefaultAnalyst]    
	  ,[PrxJobDefaultResponsible]    
      ,[PrxJobGWDefaultAnalyst]    
      ,[PrxJobGWDefaultResponsible]    
      ,[EnteredBy]    
 )  
   
   SELECT  @orgId    
    ,ROW_NUMBER() OVER(ORDER By  refRole.[OrgRoleSortOrder])    
    ,refRole.[Id]    
    ,refRole.[OrgRoleDefault]    
    ,refRole.[OrgRoleTitle]    
    ,refRole.[OrgRoleContactID]    
    ,refRole.[RoleTypeId]    
    ,ISNULL(refRole.[StatusId], 1)    
    ,refRole.[OrgRoleDescription]    
    ,refRole.[OrgComments]    
    ,refRole.[PrxJobDefaultAnalyst]  
	,refRole.[PrxJobDefaultResponsible]   
    ,refRole.[PrxJobGWDefaultAnalyst]    
    ,refRole.[PrxJobGWDefaultResponsible]    
    ,@enteredBy   
     
   FROM [dbo].[ORGAN010Ref_Roles] (NOLOCK) refRole  
   WHERE ISNULL(refRole.StatusId, 1) < 3 AND ISNULL(refRole.OrgRoleDefault, 0) = 1;

   -- Copy Security By Role for current ActRole from RefRole

	--Created a Table Variable and Variable Counter
	DECLARE @InitialTable TABLE(RowNo BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY CLUSTERED, ActRoleId BIGINT, RefRoleId BIGINT, RoleContactId BIGINT NULL)
	DECLARE @IncrementalCounter BIGINT --This variable is declare for Loop

	--All values are inserted into Table Variable
	INSERT INTO @InitialTable (ActRoleId, RefRoleId, RoleContactId) 
	SELECT [Id], [OrgRefRoleId], [OrgRoleContactID] FROM [dbo].[ORGAN020Act_Roles] WHERE [OrgID]=@orgId AND [OrgRoleContactID] IS NOT NULL

	--Initialize the Counter
	SET @IncrementalCounter = 1

	--Condition of Checking the No of records to be traverse
	WHILE @IncrementalCounter <= ISNULL((SELECT COUNT(RowNo) FROM @InitialTable),0)
	BEGIN
		DECLARE @actRoleId BIGINT, @refRoleId BIGINT, @roleContactId BIGINT
		SELECT @refRoleId = RefRoleId, @actRoleId = ActRoleId, @roleContactId = RoleContactId  FROM @InitialTable WHERE RowNo = @IncrementalCounter
		EXEC [dbo].[CopyActRoleContactSecurity] @orgId, @refRoleId, @actRoleId, @roleContactId, @enteredBy
		SET @IncrementalCounter = @incrementalCounter +1
	END

END TRY                    
BEGIN CATCH                    
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                    
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                    
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                    
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                    
END CATCH
GO
PRINT N'Altering [dbo].[GetActrolesByProgramId]...';


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
  WHERE   act.OrgID = @orgId
  
  ORDER BY  rol.Id,rol.OrgRoleCode,rol.OrgRoleTitle 
  OFFSET @pageSize * (@pageNo - 1) ROWS FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);   
     
  END          
  ELSE IF @ProgramLevel=2          
  BEGIN          
        SELECT rol.Id,rol.OrgRoleCode,rol.OrgRoleTitle FROM [dbo].[ORGAN010Ref_Roles] (NOLOCK)  rol  
  INNER JOIN ORGAN020Act_Roles (NOLOCK)  act ON rol.Id= act.[OrgRefRoleId]  
  WHERE   act.OrgID = @OrgId    
  ORDER BY  rol.Id,rol.OrgRoleCode,rol.OrgRoleTitle 
  OFFSET @pageSize * (@pageNo - 1) ROWS FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);      
  END          
  ELSE IF  @ProgramLevel=3          
  BEGIN          
      SELECT rol.Id,rol.OrgRoleCode,rol.OrgRoleTitle FROM [dbo].[ORGAN010Ref_Roles] (NOLOCK)  rol  
  INNER JOIN ORGAN020Act_Roles (NOLOCK)  act ON rol.Id= act.[OrgRefRoleId]  
  WHERE   act.OrgID = @OrgId
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
PRINT N'Altering [dbo].[GetOrgActRole]...';


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
PRINT N'Altering [dbo].[InsOrgActRole]...';


GO

/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               08/16/2018      
-- Description:               Ins a org act role
-- Execution:                 EXEC [dbo].[InsOrgActRole]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================  
ALTER PROCEDURE  [dbo].[InsOrgActRole]		  
	@userId BIGINT
	,@roleId BIGINT 
	,@entity NVARCHAR(100)
	,@orgId BIGINT = NULL
	,@orgRoleSortOrder INT = NULL
	,@orgRefRoleId BIGINT = NULL
	,@orgRoleDefault BIT = NULL
	,@orgRoleTitle NVARCHAR(50)= NULL 
	,@orgRoleContactId BIGINT = NULL
	,@roleTypeId INT = NULL
	,@prxJobDefaultAnalyst BIT = NULL
	,@prxJobDefaultResponsible BIT = NULL
	,@prxJobGWDefaultAnalyst BIT = NULL
	,@prxJobGWDefaultResponsible BIT = NULL
	,@statusId INT = NULL
	,@dateEntered DATETIME2(7) 
	,@enteredBy NVARCHAR(50) = NULL
	,@doNotGetRecord BIT = 0
AS
BEGIN TRY                
 SET NOCOUNT ON; 
  DECLARE @updatedItemNumber INT      
  EXEC [dbo].[ResetItemNumber] @userId, 0, @orgId, @entity, @orgRoleSortOrder, @statusId, NULL, NULL,  @updatedItemNumber OUTPUT 
 
 DECLARE @currentId BIGINT;
   INSERT INTO [dbo].[ORGAN020Act_Roles]
           ([OrgId]
           ,[OrgRoleSortOrder]
           ,[OrgRefRoleId]
           ,[OrgRoleDefault]
           ,[OrgRoleTitle]
           ,[OrgRoleContactId]
           ,[RoleTypeId]
           ,[PrxJobDefaultAnalyst]
		   ,[PrxJobDefaultResponsible]
           ,[PrxJobGWDefaultAnalyst]
           ,[PrxJobGWDefaultResponsible]
		   ,[StatusId]
           ,[DateEntered]
           ,[EnteredBy])
     VALUES
		   (@orgId  
           ,@updatedItemNumber 
           ,@orgRefRoleId  
           ,@orgRoleDefault  
           ,@orgRoleTitle  
           ,@orgRoleContactId  
           ,@roleTypeId 
           ,@prxJobDefaultAnalyst   
		   ,@prxJobDefaultResponsible
           ,@prxJobGWDefaultAnalyst   
           ,@prxJobGWDefaultResponsible
		   ,@statusId   
           ,@dateEntered 
           ,@enteredBy ) 	
		   SET @currentId = SCOPE_IDENTITY();
	 
	 IF(@orgRoleContactId IS NOT NULL)
	 BEGIN
		EXEC [dbo].[CopyActRoleContactSecurity] @orgId, @orgRefRoleId, @currentId, @orgRoleContactId, @enteredBy
	 END
	 
	 IF(@doNotGetRecord = 0)
	 BEGIN
		EXEC [dbo].[GetOrgActRole] @userId, @roleId, @orgId, @currentId 
	 END

END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH



/***** Object:  StoredProcedure [dbo].[UpdOrgActRole]    Script Date: 8/16/2017 1:30:20 PM *****/
SET ANSI_NULLS ON
GO
PRINT N'Altering [dbo].[UpdOrgActRole]...';


GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan   
-- Create date:               08/16/2018      
-- Description:               Upd a Org act role 
-- Execution:                 EXEC [dbo].[UpdOrgActRole]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================     
ALTER PROCEDURE  [dbo].[UpdOrgActRole]      
	@userId BIGINT  
	,@roleId BIGINT  
	,@entity NVARCHAR(100)  
	,@id BIGINT   
	,@orgId BIGINT = NULL  
	,@orgRoleSortOrder INT  = NULL  
	,@orgRefRoleId BIGINT = NULL   
	,@orgRoleDefault BIT  = NULL  
	,@orgRoleTitle NVARCHAR(50)  = NULL  
	,@orgRoleContactId BIGINT  = NULL  
	,@roleTypeId INT  = NULL  
	,@prxJobDefaultAnalyst BIT  = NULL  
	,@prxJobDefaultResponsible BIT  = NULL  
	,@prxJobGWDefaultAnalyst BIT  = NULL  
	,@prxJobGWDefaultResponsible BIT  = NULL  
	,@statusId INT = NULL
	,@dateChanged DATETIME2(7)  = NULL  
	,@changedBy NVARCHAR(50)  = NULL 
	,@isFormView BIT = 0
AS  
BEGIN TRY                  
 SET NOCOUNT ON;
  DECLARE @updatedItemNumber INT 
  DECLARE @oldContactId BIGINT = NULL
  EXEC [dbo].[ResetItemNumber] @userId, @id, @orgId, @entity, @orgRoleSortOrder, @statusId, NULL, NULL,  @updatedItemNumber OUTPUT
	  SELECT @oldContactId=OrgRoleContactId FROM [dbo].[ORGAN020Act_Roles] WHERE Id = @id AND OrgID = @orgId
	IF(ISNULL(@oldContactId, 0) < 1) -- If no contact present then add security for it in actrole security
		BEGIN
			EXEC [dbo].[CopyActRoleContactSecurity] @orgId, @orgRefRoleId, @id, @orgRoleContactId, @changedBy
		END
	ELSE IF(ISNULL(@orgRoleContactId, 0) > 0) 
		BEGIN
		  UPDATE [dbo].[ORGAN021Act_SecurityByRole] SET [ContactId] = @orgRoleContactId  WHERE OrgId = @orgId AND OrgActRoleId = @id
		END
  UPDATE [dbo].[ORGAN020Act_Roles]  
    SET     OrgId						= CASE WHEN (@isFormView = 1) THEN @orgId WHEN ((@isFormView = 0) AND (@orgId=-100)) THEN NULL ELSE ISNULL(@orgId, OrgId) END 
           ,OrgRoleSortOrder			= CASE WHEN (@isFormView = 1) THEN @updatedItemNumber WHEN ((@isFormView = 0) AND (@updatedItemNumber=-100)) THEN NULL ELSE ISNULL(@updatedItemNumber, OrgRoleSortOrder) END  
           ,[OrgRefRoleId]				= CASE WHEN (@isFormView = 1) THEN @orgRefRoleId WHEN ((@isFormView = 0) AND (@orgRefRoleId=-100)) THEN NULL ELSE ISNULL(@orgRefRoleId, [OrgRefRoleId]) END  
           ,OrgRoleDefault				= ISNULL(@orgRoleDefault, OrgRoleDefault)  
           ,OrgRoleTitle				= CASE WHEN (@isFormView = 1) THEN @orgRoleTitle WHEN ((@isFormView = 0) AND (@orgRoleTitle='#M4PL#')) THEN NULL ELSE ISNULL(@orgRoleTitle, OrgRoleTitle) END  
           ,OrgRoleContactId			= CASE WHEN (@isFormView = 1) THEN @orgRoleContactId WHEN ((@isFormView = 0) AND (@orgRoleContactId=-100)) THEN NULL ELSE ISNULL(@orgRoleContactId, OrgRoleContactId) END  
           ,RoleTypeId					= CASE WHEN (@isFormView = 1) THEN @roleTypeId WHEN ((@isFormView = 0) AND (@roleTypeId=-100)) THEN NULL ELSE ISNULL(@roleTypeId, RoleTypeId) END  
           ,PrxJobDefaultAnalyst		= ISNULL(@prxJobDefaultAnalyst, PrxJobDefaultAnalyst)  
		   ,PrxJobDefaultResponsible		= ISNULL(@prxJobDefaultResponsible, PrxJobDefaultResponsible)  
           ,PrxJobGWDefaultAnalyst		= ISNULL(@prxJobGWDefaultAnalyst, PrxJobGWDefaultAnalyst)  
           ,PrxJobGWDefaultResponsible  = ISNULL(@prxJobGWDefaultResponsible, PrxJobGWDefaultResponsible)     
           ,StatusId					= CASE WHEN (@isFormView = 1) THEN @statusId WHEN ((@isFormView = 0) AND (@statusId=-100)) THEN NULL ELSE ISNULL(@statusId, StatusId) END     
           ,DateChanged					= @dateChanged    
           ,ChangedBy					= @changedBy     
     WHERE Id = @id  ;
  EXEC [dbo].[GetOrgActRole] @userId, @roleId, @orgId, @id
END TRY                  
BEGIN CATCH                  
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                  
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                  
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                  
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                  
END CATCH
GO
PRINT N'Altering [dbo].[GetOrgRefRole]...';


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
       ,org.[PrxJobDefaultAnalyst]
	   ,org.[PrxJobDefaultResponsible]
       ,org.[PrxJobGWDefaultAnalyst]
       ,org.[PrxJobGWDefaultResponsible]
	   ,org.[StatusId]
       ,org.[DateEntered]
       ,org.[EnteredBy]
       ,org.[DateChanged]
       ,org.[ChangedBy]
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
PRINT N'Altering [dbo].[InsOrgRefRole]...';


GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               08/16/2018      
-- Description:               Ins a Org Ref Role
-- Execution:                 EXEC [dbo].[InsOrgRefRole]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- ============================================= 
ALTER PROCEDURE  [dbo].[InsOrgRefRole]		  
	@userId BIGINT
	,@roleId BIGINT 
	,@entity NVARCHAR(100)
	,@orgId BIGINT = NULL
	,@orgRoleSortOrder INT = NULL 
	,@orgRoleCode NVARCHAR(25) = NULL 
	,@orgRoleDefault BIT = NULL 
	,@orgRoleTitle NVARCHAR(50) = NULL 
	,@orgRoleContactId BIGINT  = NULL
	,@roleTypeId INT = NULL 
	,@prxJobDefaultAnalyst BIT  = NULL
	,@prxJobDefaultResponsible BIT  = NULL  
	,@prxJobGWDefaultAnalyst BIT  = NULL
	,@prxJobGWDefaultResponsible BIT = NULL 
	,@dateEntered DATETIME2(7) 
	,@enteredBy NVARCHAR(50)  = NULL
	,@phsLogical BIT  = NULL
	,@statusId INT = NULL
AS
BEGIN TRY                
 SET NOCOUNT ON;
  DECLARE @updatedItemNumber INT      
 EXEC [dbo].[ResetItemNumber] @userId, 0, NULL, @entity, @orgRoleSortOrder, @statusId, NULL, NULL,  @updatedItemNumber OUTPUT
 
    
 DECLARE @currentId BIGINT;
   INSERT INTO [dbo].[ORGAN010Ref_Roles]
              ([OrgId]
              ,[OrgRoleSortOrder]
              ,[OrgRoleCode]
              ,[OrgRoleDefault]
              ,[OrgRoleTitle]
              ,[OrgRoleContactId]
              ,[RoleTypeId]
              ,[PrxJobDefaultAnalyst]
			  ,[PrxJobDefaultResponsible]
              ,[PrxJobGWDefaultAnalyst]
              ,[PrxJobGWDefaultResponsible]
              ,[DateEntered]
              ,[EnteredBy]
              ,[StatusId])
     VALUES
		   (NULL  
           ,@updatedItemNumber   
           ,@orgRoleCode  
           ,@orgRoleDefault  
           ,@orgRoleTitle  
           ,@orgRoleContactId   
           ,@roleTypeId 
           ,@prxJobDefaultAnalyst   
		   ,@prxJobDefaultResponsible
           ,@prxJobGWDefaultAnalyst   
           ,@PrxJobGWDefaultResponsible    
           ,@dateEntered  
           ,@enteredBy   
           ,@statusId)	
		   SET @currentId = SCOPE_IDENTITY();

		 
	 EXEC [dbo].[GetOrgRefRole] @userId, @roleId, @orgId, @currentId

END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
PRINT N'Altering [dbo].[UpdOrgRefRole]...';


GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               08/16/2018      
-- Description:               Upd a Org Ref Role
-- Execution:                 EXEC [dbo].[UpdOrgRefRole]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================
ALTER PROCEDURE  [dbo].[UpdOrgRefRole]		  
	@userId BIGINT
	,@roleId BIGINT  
	,@entity NVARCHAR(100)
	,@id BIGINT 
	,@orgId BIGINT = NULL
	,@orgRoleSortOrder INT = NULL 
	,@orgRoleCode NVARCHAR(25) = NULL 
	,@orgRoleDefault BIT = NULL 
	,@orgRoleTitle NVARCHAR(50) = NULL 
	,@orgRoleContactId BIGINT = NULL 
	,@roleTypeId INT = NULL 
	,@prxJobDefaultAnalyst BIT  = NULL
	,@prxJobDefaultResponsible BIT  = NULL  
	,@prxJobGWDefaultAnalyst BIT  = NULL
	,@prxJobGWDefaultResponsible BIT  = NULL
	,@dateChanged DATETIME2(7)  = NULL
	,@changedBy NVARCHAR(50) = NULL 
	,@statusId INT = NULL
	,@isFormView BIT = 0
AS
BEGIN TRY                
 SET NOCOUNT ON;   
  DECLARE @updatedItemNumber INT      
  EXEC [dbo].[ResetItemNumber] @userId, @id, NULL, @entity, @orgRoleSortOrder, @statusId, NULL, NULL,  @updatedItemNumber OUTPUT  
  UPDATE [dbo].[ORGAN010Ref_Roles]
       SET     OrgId 						=	NULL
              ,OrgRoleSortOrder 			=	CASE WHEN (@isFormView = 1) THEN @updatedItemNumber WHEN ((@isFormView = 0) AND (@updatedItemNumber=-100)) THEN NULL ELSE ISNULL(@updatedItemNumber, OrgRoleSortOrder) END
              ,OrgRoleCode 					=	CASE WHEN (@isFormView = 1) THEN @orgRoleCode WHEN ((@isFormView = 0) AND (@orgRoleCode='#M4PL#')) THEN NULL ELSE ISNULL(@orgRoleCode, OrgRoleCode) END
              ,OrgRoleDefault 				=	ISNULL(@orgRoleDefault, OrgRoleDefault)
              ,OrgRoleTitle 				=	CASE WHEN (@isFormView = 1) THEN @orgRoleTitle WHEN ((@isFormView = 0) AND (@orgRoleTitle='#M4PL#')) THEN NULL ELSE ISNULL(@orgRoleTitle, OrgRoleTitle) END
              ,OrgRoleContactId 			=	CASE WHEN (@isFormView = 1) THEN @orgRoleContactId WHEN ((@isFormView = 0) AND (@orgRoleContactId=-100)) THEN NULL ELSE ISNULL(@orgRoleContactId, OrgRoleContactId) END
              ,RoleTypeId 					=	CASE WHEN (@isFormView = 1) THEN @roleTypeId WHEN ((@isFormView = 0) AND (@roleTypeId=-100)) THEN NULL ELSE ISNULL(@roleTypeId, RoleTypeId) END
              ,PrxJobDefaultAnalyst 		=	ISNULL(@prxJobDefaultAnalyst, PrxJobDefaultAnalyst)
			  ,PrxJobDefaultResponsible 	=	ISNULL(@prxJobDefaultResponsible, PrxJobDefaultResponsible)
              ,PrxJobGWDefaultAnalyst 		=	ISNULL(@prxJobGWDefaultAnalyst, PrxJobGWDefaultAnalyst)
              ,PrxJobGWDefaultResponsible	=	ISNULL(@prxJobGWDefaultResponsible, PrxJobGWDefaultResponsible)  
              ,StatusId  					=	CASE WHEN (@isFormView = 1) THEN @statusId WHEN ((@isFormView = 0) AND (@statusId=-100)) THEN NULL ELSE ISNULL(@statusId, StatusId) END
              ,DateChanged 					=	@dateChanged  
              ,ChangedBy 					=	@changedBy 
     WHERE Id =	@id		
	
 EXEC [dbo].[GetOrgRefRole] @userId, @roleId, @orgId, @id
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
PRINT N'Altering [dbo].[GetProgramRole]...';


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
PRINT N'Altering [dbo].[GetRefRoleLogicals]...';


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
PRINT N'Altering [dbo].[GetRefRolesByProgramId]...';


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
 SET @sqlCommand += ' AND (( '+CAST(@ProgramLevel AS VARCHAR)+' =1 '  
 SET @sqlCommand += ' OR   ' +CAST(@ProgramLevel AS VARCHAR)+' =2  '  
 SET @sqlCommand += ' OR   ' +CAST(@ProgramLevel AS VARCHAR)+' =3) '  

 --For ActRole
 SET @sqlCommand += ' OR ('+CAST(@ProgramLevel AS VARCHAR)+' =1  '  
 SET @sqlCommand += ' OR  ' +CAST(@ProgramLevel AS VARCHAR)+' =2  '  
 SET @sqlCommand += ' OR   '+CAST(@ProgramLevel AS VARCHAR)+' =3 )) '  

	SET @sqlCommand += ' ) t WHERE t.' + @primaryKeyName + '=' + @primaryKeyValue;
		 
	EXEC sp_executesql @sqlCommand, N' @newPgNo int output',@newPgNo output                                    
    SET @newPgNo =  @newPgNo/@pageSize + 1; 
	SET @pageSize = @newPgNo * @pageSize;
	SET @sqlCommand='';

	

 END

 SET @sqlCommand += 'SELECT DISTINCT '+ @fields +' FROM ORGAN010Ref_Roles (NOLOCK) ' + @entity
 SET @sqlCommand += ' LEFT JOIN ORGAN020Act_Roles actRole ON ' + @entity + '.Id=actRole.[OrgRefRoleId] AND actRole.[OrgID]=' + CAST(@orgId AS NVARCHAR(50)) + ' AND ISNULL(actRole.StatusId, 1) In (1,2) ' 
 
 --For RefRole
 SET @sqlCommand += ' WHERE 1=1 AND (( '+CAST(@ProgramLevel AS VARCHAR)+' =1  '  
 SET @sqlCommand += ' OR   ' +CAST(@ProgramLevel AS VARCHAR)+' =2 '  
 SET @sqlCommand += ' OR   ' +CAST(@ProgramLevel AS VARCHAR)+' =3) '  

 --For ActRole
 SET @sqlCommand += ' OR ('+CAST(@ProgramLevel AS VARCHAR)+' =1  '  
 SET @sqlCommand += ' OR   '+CAST(@ProgramLevel AS VARCHAR)+' =2  '  
 SET @sqlCommand += ' OR   '+CAST(@ProgramLevel AS VARCHAR)+' =3)) '  

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
PRINT N'Altering [dbo].[InsProgramRole]...';


GO

/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               09/14/2018      
-- Description:               Ins a  Program Role
-- Execution:                 EXEC [dbo].[InsProgramRole]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================

ALTER PROCEDURE  [dbo].[InsProgramRole]
	(@userId BIGINT
	,@roleId BIGINT 
	,@entity NVARCHAR(100)
	,@orgId bigint
	,@programId bigint
	,@prgRoleSortOrder int
	,@orgRoleId BIGINT
	,@prgRoleId BIGINT
	,@prgRoleCode nvarchar(25)
	,@prgRoleTitle nvarchar(50)
	,@prgRoleContactId bigint
	,@roleTypeId int
	,@statusId int
	,@prxJobDefaultAnalyst BIT  =NULL
	,@prxJobDefaultResponsible BIT  =NULL
	,@prxJobGWDefaultAnalyst BIT  =NULL
	,@prxJobGWDefaultResponsible BIT  =NULL
	,@dateEntered datetime2(7)
	,@enteredBy nvarchar(50))
AS
BEGIN TRY                
 SET NOCOUNT ON;  
  DECLARE @updatedItemNumber INT      
 EXEC [dbo].[ResetItemNumber] @userId, 0, @programId, @entity, @prgRoleSortOrder, @statusId, NULL, NULL,  @updatedItemNumber OUTPUT 
   IF NOT EXISTS(SELECT Id  FROM PRGRM020_Roles WHERE ProgramID =@programId AND PrgRoleCode = @prgRoleCode) AND ISNULL(@prgRoleId,0) = 0
  BEGIN
     INSERT INTO PRGRM020_Roles(OrgID,ProgramID,PrgRoleCode,PrgRoleTitle,StatusId,DateEntered,EnteredBy)
	 VALUES(@orgId,@programId,@prgRoleCode,@prgRoleTitle,ISNULL(@statusId,1),@dateEntered,@enteredBy)

	 SET @prgRoleId = SCOPE_IDENTITY();
  END
  ELSE IF @prgRoleId > 0
  BEGIN
    UPDATE PRGRM020_Roles SET PrgRoleCode =@prgRoleCode WHERE Id =@prgRoleId AND ProgramID =@programId 
  END

  
 DECLARE @currentId BIGINT;
 INSERT INTO [dbo].[PRGRM020Program_Role]
           ( [OrgID]
			,[ProgramID]
			,[PrgRoleSortOrder]
			,[OrgRefRoleId]
			,[PrgRoleId]
			,[PrgRoleTitle]
			,[PrgRoleContactID]
			,[RoleTypeId]
			,[StatusId]
			,[PrxJobDefaultAnalyst]
		    ,[PrxJobDefaultResponsible]
		    ,[PrxJobGWDefaultAnalyst]
		    ,[PrxJobGWDefaultResponsible]


			,[DateEntered]
			,[EnteredBy])
     VALUES
           (@orgID
		   	,@programID
		   	,@updatedItemNumber
		   	,@orgRoleId
		   	,@prgRoleId
		   	,@prgRoleTitle
			,@prgRoleContactID
			,@roleTypeId
			,@statusId
			,@prxJobDefaultAnalyst 
		    ,@prxJobDefaultResponsible 
		    ,@prxJobGWDefaultAnalyst 
		    ,@prxJobGWDefaultResponsible 
			,@dateEntered
			,@enteredBy)
			SET @currentId = SCOPE_IDENTITY();
	SELECT * FROM [dbo].[PRGRM020Program_Role] WHERE Id = @currentId;
END TRY              
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
PRINT N'Altering [dbo].[UpdProgramRole]...';


GO

/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               08/16/2018      
-- Description:               Upd a Program Role
-- Execution:                 EXEC [dbo].[UpdProgramRole]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================
ALTER PROCEDURE  [dbo].[UpdProgramRole]
	(@userId BIGINT
	,@roleId BIGINT  
	,@entity NVARCHAR(100)
	,@id bigint
	,@orgId bigint = NULL
	,@programId bigint = NULL
	,@prgRoleSortOrder int = NULL
	,@orgRoleId BIGINT = NULL
	,@prgRoleid BIGINT = NULL
	,@prgRoleCode nvarchar(25) = NULL
	,@prgRoleTitle nvarchar(50) = NULL
	,@prgRoleContactId bigint = NULL
	,@roleTypeId int = NULL
	,@statusId int = NULL
	,@prxJobDefaultAnalyst BIT  =NULL
	,@prxJobDefaultResponsible BIT  =NULL
	,@prxJobGWDefaultAnalyst BIT  =NULL
	,@prxJobGWDefaultResponsible BIT  =NULL

	,@dateChanged datetime2(7) = NULL
	,@changedBy nvarchar(50) = NULL
	,@isFormView BIT = 0) 
AS
BEGIN TRY                
 SET NOCOUNT ON; 
 DECLARE @updatedItemNumber INT      
 EXEC [dbo].[ResetItemNumber] @userId, @id, @programId, @entity, @prgRoleSortOrder, @statusId, NULL, NULL,  @updatedItemNumber OUTPUT 
 PRINT @updatedItemNumber
  IF @prgRoleid > 0
  BEGIN
    UPDATE PRGRM020_Roles SET PrgRoleCode = @prgRoleCode WHERE Id =@prgRoleid AND ProgramID = @programId
  END

 IF NOT EXISTS(SELECT Id  FROM PRGRM020_Roles WHERE ProgramID =@programId AND PrgRoleCode = @prgRoleCode) AND ISNULL(@prgRoleid,0) = 0 AND @prgRoleCode IS NOT NULL
  BEGIN
     INSERT INTO PRGRM020_Roles(OrgID,ProgramID,PrgRoleCode,PrgRoleTitle,StatusId,DateEntered,EnteredBy)
	 VALUES (@orgId,@programId,@prgRoleCode,@prgRoleTitle,ISNULL(@statusId,1),@dateChanged,@changedBy)

	 SET @prgRoleid = SCOPE_IDENTITY();
  END

   
 UPDATE [dbo].[PRGRM020Program_Role]
		SET  [OrgID]                 = CASE WHEN (@isFormView = 1) THEN @orgID WHEN ((@isFormView = 0) AND (@orgID=-100)) THEN NULL ELSE ISNULL(@orgID, OrgID) END
			,[ProgramID]             = CASE WHEN (@isFormView = 1) THEN @programID WHEN ((@isFormView = 0) AND (@programID=-100)) THEN NULL ELSE ISNULL(@programID, ProgramID) END
			,[PrgRoleSortOrder]      = CASE WHEN (@isFormView = 1) THEN @updatedItemNumber WHEN ((@isFormView = 0) AND (@updatedItemNumber=-100)) THEN NULL ELSE ISNULL(@updatedItemNumber, PrgRoleSortOrder) END
			,[OrgRefRoleId]			 = CASE WHEN (@isFormView = 1) THEN @orgRoleId WHEN ((@isFormView = 0) AND (@orgRoleId=-100)) THEN NULL ELSE ISNULL(@orgRoleId, [OrgRefRoleId]) END
			,[PrgRoleId]			 = CASE WHEN (@isFormView = 1) THEN @prgRoleId WHEN ((@isFormView = 0) AND (@prgRoleId=-100)) THEN NULL ELSE ISNULL(@prgRoleId, PrgRoleId) END
			,[PrgRoleTitle]          = CASE WHEN (@isFormView = 1) THEN @prgRoleTitle WHEN ((@isFormView = 0) AND (@prgRoleTitle='#M4PL#')) THEN NULL ELSE ISNULL(@prgRoleTitle, PrgRoleTitle) END
			,[PrgRoleContactID]      = CASE WHEN (@isFormView = 1) THEN @prgRoleContactID WHEN ((@isFormView = 0) AND (@prgRoleContactID=-100)) THEN NULL ELSE ISNULL(@prgRoleContactID, PrgRoleContactID) END
			,[RoleTypeId]            = CASE WHEN (@isFormView = 1) THEN @roleTypeId WHEN ((@isFormView = 0) AND (@roleTypeId=-100)) THEN NULL ELSE ISNULL(@roleTypeId, RoleTypeId) END
			,[StatusId]				 = CASE WHEN (@isFormView = 1) THEN @statusId WHEN ((@isFormView = 0) AND (@statusId=-100)) THEN NULL ELSE ISNULL(@statusId, StatusId) END
            ,[PrxJobDefaultAnalyst]		    = ISNULL(@prxJobDefaultAnalyst, PrxJobDefaultAnalyst)  
		    ,[PrxJobDefaultResponsible]  	= ISNULL(@prxJobDefaultResponsible, PrxJobDefaultResponsible)  
            ,[PrxJobGWDefaultAnalyst]		= ISNULL(@prxJobGWDefaultAnalyst, PrxJobGWDefaultAnalyst)  
            ,[PrxJobGWDefaultResponsible]   = ISNULL(@prxJobGWDefaultResponsible, PrxJobGWDefaultResponsible)     

			,[DateChanged]           = @dateChanged
			,[ChangedBy]             = @changedBy
	 WHERE   [Id] = @id
	SELECT prg.[Id]
		,prg.[OrgID]
		,prg.[ProgramID]
		,prg.[PrgRoleSortOrder]
		,prg.[OrgRefRoleId]
		,prg.[PrgRoleId]
		,prg.[PrgRoleTitle]
		,prg.[PrgRoleContactID]
		,prg.[RoleTypeId]
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
PRINT N'Refreshing [dbo].[InsProgram]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[InsProgram]';


GO
PRINT N'Refreshing [dbo].[InsOrganization]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[InsOrganization]';


GO
PRINT N'Refreshing [dbo].[UpdSystemAccount]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[UpdSystemAccount]';


GO
PRINT N'Update complete.';
