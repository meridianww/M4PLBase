
/* Copyright (2018) Meridian Worldwide Transportation Group      
   All Rights Reserved Worldwide */      
-- =============================================              
-- Author:                    Janardana Behara               
-- Create date:               06/06/2018            
-- Description:               Copy ActRole On job Create  
-- Execution:                 EXEC [dbo].[CopyRefRoleOnProgramCreate]      
-- Modified on:				  2nd May 2019
-- Modified Desc:			  Implemented contact bridge related item by Parthiban M
-- =============================================      
      
ALTER PROCEDURE  [dbo].[CopyActRoleOnJobCreate]      
     (  @userId BIGINT      
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
     
      
      
  -- 1) Customer  Contacts 2) Vendor Contacts 3) Program Roles    
  -- 1) Insert Into Customer Contacts       
DECLARE @ccMaxNumber INT      
SELECT @ccMaxNumber = MAX(ConItemNumber) FROM [CONTC010Bridge] WHERE ConPrimaryRecordId = @custId AND StatusId In (1,2) AND ConTableName='CustContact';      
      
INSERT INTO [dbo].[CONTC010Bridge]      
           ([ConOrgId]
		   ,[ConPrimaryRecordId] 
		   ,[ConTableName] 
		   ,[ConCodeId] 
		   ,[ConTableTypeId]
           ,[ConTypeId]    
           ,[ConItemNumber]                 
           ,[ContactMSTRID]      
           ,[StatusId]      
           ,[EnteredBy]      
           ,[DateEntered])      
SELECT @orgId,@custId,'CustContact',OrgRefRoleId,183,64,(ROW_NUMBER() Over(Order By OrgRoleSortOrder) + ISNULL(@ccMaxNumber,0) ),OrgRoleContactID,ISNULL(StatusId,1),@enteredBy    , @dateEntered     
  from  [dbo].[ORGAN020Act_Roles]       
   WHERE  (PrxJobGWDefaultAnalyst = 1 OR PrxJobGWDefaultResponsible = 1)    
    AND ISNULL(StatusId,1) = 1     
 AND OrgID = @orgId    
 AND OrgRoleContactID IS NOT NULL     
 AND OrgRoleContactID NOT IN( SELECT ContactMSTRID FROM [CONTC010Bridge] WHERE ConPrimaryRecordId = @custId AND ConTableName='CustContact');     
        
 -- 2) Insert into Vendor Contacts    
    
   INSERT INTO [dbo].[CONTC010Bridge]      
           ([ConOrgId]
		   ,[ConPrimaryRecordId] 
		   ,[ConTableName]  
		   ,[ConCodeId] 
		   ,[ConTableTypeId]
           ,[ConTypeId]   
           ,[ConItemNumber]                 
           ,[ContactMSTRID]      
           ,[StatusId]      
           ,[EnteredBy]      
           ,[DateEntered])      
      
SELECT @orgId,@custId,'VendContact',ref.OrgRefRoleId,183,63,ROW_NUMBER() Over(Order By ref.OrgRoleSortOrder)  ,ref.OrgRoleContactID,ISNULL(ref.StatusId,1),@enteredBy  , @dateEntered       
        
  from  [dbo].[ORGAN020Act_Roles]  ref      
  INNER JOIN CONTC010Bridge vc On ref.OrgRoleContactID = vc.ContactMSTRID AND vc.ConTableName='CustContact'       
  INNER JOIN VEND000Master vm On vc.ConPrimaryRecordId = vm.Id    
  INNER JOIN PRGRM051VendorLocations pvl ON vm.id=pvl.PvlVendorID AND Pvl.PvlProgramID  = @programId      
   WHERE (ref.PrxJobGWDefaultAnalyst = 1 OR ref.PrxJobGWDefaultResponsible = 1)    
    AND ISNULL(ref.StatusId,1) = 1      
 AND ref.OrgID = @orgId    
 AND ref.OrgRoleContactID IS NOT NULL     
    AND ref.OrgRoleContactID NOT IN( SELECT ContactMSTRID FROM [CONTC010Bridge] WHERE ConPrimaryRecordId = @custId AND ConTableName='CustContact');      
      
    
        
  DECLARE @roleMaxNumber INT      
  SELECT @roleMaxNumber = MAX(PrgRoleSortOrder) FROM [PRGRM020Program_Role] WHERE [ProgramID] = @programId AND StatusId In (1,2) ;    
      
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
  ,[DateEntered]      
  ,[EnteredBy]      
  )      
  SELECT @orgId ,@programId, ROW_NUMBER() Over(Order By OrgRoleSortOrder) + @roleMaxNumber,OrgRefRoleId,NUll,NULL,OrgRoleContactID,RoleTypeId,ISNULL(StatusId,1), @dateEntered  ,@enteredBy       
  from  [dbo].[ORGAN020Act_Roles]       
   WHERE  (PrxJobGWDefaultAnalyst = 1  OR PrxJobGWDefaultResponsible = 1)    
    AND ISNULL(StatusId,1) = 1      
 AND OrgID = @orgId    
 AND OrgRoleContactID IS NOT NULL     
    AND OrgRoleContactID NOT IN( SELECT PrgRoleContactID FROM PRGRM020Program_Role WHERE [ProgramID] = @programId);      
      
       
      
END TRY               
BEGIN CATCH                      
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                      
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                      
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                      
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                      
END CATCH
GO

/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Janardana Behara        
-- Create date:               05/29/2018      
-- Description:               Get selected records by table  
-- Execution:                 [dbo].[GetPPPGatewayContactCombobox]  'EN',1,'Contact','Contact.id,Contact.ConFullName',1,10,NULL,NULL,NULL,1,'Id',2,NULL
-- Modified on:				  2nd May 2019
-- Modified Desc:			  Implemented contact bridge related item by Parthiban M 
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
 ,ConFileAs NVARCHAR(100)
  )   
--Adding for 39449
IF @entityFor = 'PPPRoleCodeContact'
BEGIN
DECLARE @CustomerId INT
SELECT @CustomerId=PrgCustID FROM PRGRM000Master where id=@parentid

INSERT INTO #contactComboTable(Id,ConFullName,ConJobTitle,ConFileAs)  
(
--GET EMPLOYEE TYPE
select contact.Id,contact.ConFullName,contact.ConJobTitle,contact.ConFileAs from CONTC000Master contact
INNER JOIN  [dbo].[PRGRM020Program_Role] pgContact ON pgContact.[PrgRoleContactID] = contact.Id  
INNER JOIN PRGRM000Master pgm  ON pgm.Id  =  pgContact.ProgramID 
WHERE pgContact.ProgramID = @parentId AND ISNULL(contact.StatusId,1)<>3 and contact.ConTypeId=62 AND contact.ConOrgId = @orgId 
 UNION
 --GET CUSTOMER CONTACT
 SELECT contact.Id,contact.ConFullName,contact.ConJobTitle,contact.ConFileAs FROM  [dbo].CONTC000Master contact
INNER JOIN   [dbo].[CONTC010Bridge] custContact ON  contact.Id = custContact.[ContactMSTRID] AND custContact.ConTableName = 'CustContact'
INNER JOIN   CUST000Master cust ON custContact.[ConPrimaryRecordId] = cust.Id
INNER JOIN PRGRM000Master pgm  ON pgm.PrgCustID  =  cust.Id 
WHERE cust.ID=@CustomerId AND contact.ConOrgId = @orgId 
AND ISNULL(custContact.StatusId,1)<>3 
AND ISNULL(contact.StatusId,1) <>3
UNION
 --GET CUSTOMER DC LOC CONTACT
select contact.Id,contact.ConFullName,contact.ConJobTitle,contact.ConFileAs 
FROM [dbo].[CUST040DCLocations] cdc
JOIN [dbo].[CONTC000Master] contact ON cdc.CdcContactMSTRID = contact.Id--to check
WHERE cdc.CdcCustomerID = @CustomerId AND contact.ConOrgId = @orgId 
AND ISNULL(cdc.StatusId,1)<>3 and ISNULL(contact.StatusId,1)<>3
UNION
--GET CUSTOMER DC LOCATION SUB CONTACT
select contact.Id,contact.ConFullName,contact.ConJobTitle,contact.ConFileAs 
 FROM [dbo].[CONTC010Bridge] cust
 JOIN [dbo].[CUST040DCLocations] cdc ON cust.ConPrimaryRecordId = cdc.Id
 JOIN [dbo].[CUST000Master] cu ON cdc.CdcCustomerID = cu.Id
 JOIN [dbo].[CONTC000Master] contact ON cust.ContactMSTRID = contact.Id
 WHERE cu.[Id]=@CustomerId AND ISNULL(cust.StatusId,1)<>3 AND ISNULL(cdc.StatusId,1)<>3 AND ISNULL(contact.StatusId,1)<>3 AND contact.ConOrgId = @orgId 
 AND cust.ConTableName = 'CustDcLocationContact'
 --SELECT * FROM [dbo].[PRGRM051VendorLocations]
UNION
--GET VENDOR CONTACT
SELECT contact.Id,contact.ConFullName,contact.ConJobTitle,contact.ConFileAs FROM  [dbo].CONTC000Master contact
INNER JOIN  [dbo].[CONTC010Bridge] vendContact ON contact.Id = vendContact.[ContactMSTRID] AND vendContact.ConTableName = 'VendContact'
INNER JOIN   VEND000Master vend ON vendContact.[ConPrimaryRecordId] = vend.Id
WHERE vendContact.[ConPrimaryRecordId] IN (SELECT DISTINCT PvlVendorID FROM
[dbo].[PRGRM051VendorLocations] pvl WHERE pvl.PvlProgramID = @parentId AND ISNULL(pvl.StatusId,1)<>3)
 AND ISNULL(contact.StatusId,1) <>3
 AND ISNULL(vendContact.StatusId,1)<>3 AND contact.ConOrgId = @orgId 
UNION
--GET VENDOR DC CONTACT
SELECT contact.Id,contact.ConFullName,contact.ConJobTitle,contact.ConFileAs 
FROM [dbo].[VEND040DCLocations]  vdc
	JOIN [dbo].[CONTC000Master] contact ON vdc.VdcContactMSTRID = contact.Id
	WHERE vdc.VdcVendorId IN (SELECT DISTINCT PvlVendorID FROM
[dbo].[PRGRM051VendorLocations] pvl WHERE pvl.PvlProgramID = @parentId AND ISNULL(pvl.StatusId,1)<>3)
 AND ISNULL(contact.StatusId,1)<>3
 AND ISNULL(vdc.StatusId,1)<>3  AND contact.ConOrgId = @orgId 
	--select * from [dbo].[CUST040DCLocations]
UNION
--GET VENDOR DC CHILD CONTACT
SELECT contact.Id,contact.ConFullName,contact.ConJobTitle,contact.ConFileAs 
FROM [dbo].[CONTC010Bridge] vend
  JOIN [dbo].[VEND040DCLocations] cdc ON vend.ConPrimaryRecordId = cdc.Id
  JOIN [dbo].[VEND000Master] ve ON cdc.VdcVendorID = ve.Id
  JOIN [dbo].[CONTC000Master] contact ON vend.ContactMSTRID = contact.Id
 WHERE ve.[Id] IN (SELECT DISTINCT PvlVendorID FROM
[dbo].[PRGRM051VendorLocations] pvl WHERE pvl.PvlProgramID = @parentId AND ISNULL(pvl.StatusId,1)<>3)
 AND ISNULL(contact.StatusId,1)<>3
 AND ISNULL(vend.StatusId,1)<>3 AND contact.ConOrgId = @orgId AND vend.ConTableName = 'VendDcLocationContact'
)
END

ELSE IF @entityFor = 'PPPRespGateway' --OR  @entityFor = 'PPPRoleCodeContact'
   BEGIN
-- Program Role Contacts
 INSERT INTO #contactComboTable(Id,ConFullName,ConJobTitle,ConFileAs)  

(select contact.Id,contact.ConFullName,contact.ConJobTitle,contact.ConFileAs from CONTC000Master contact

INNER JOIN  [dbo].[PRGRM020Program_Role] pgContact ON pgContact.[PrgRoleContactID] = contact.Id  
INNER JOIN PRGRM000Master pgm  ON pgm.Id  =  pgContact.ProgramID 
WHERE pgContact.ProgramID = @parentId AND contact.StatusId In(1,2) AND contact.ConOrgId = @orgId 
UNION

-- Customer Contacts
SELECT contact.Id,contact.ConFullName,contact.ConJobTitle,contact.ConFileAs FROM  [dbo].CONTC000Master contact
INNER JOIN    [dbo].[CONTC010Bridge] custContact ON  contact.Id = custContact.[ContactMSTRID] AND custContact.ConTableName = 'CustContact'
INNER JOIN   CUST000Master cust ON custContact.[ConPrimaryRecordId] = cust.Id
INNER JOIN PRGRM000Master pgm  ON pgm.PrgCustID  =  cust.Id 
WHERE pgm.Id = @parentId
AND custContact.StatusId In(1,2) 
AND contact.StatusId In(1,2) AND contact.ConOrgId = @orgId 

UNION
--Vendor Contacts
SELECT contact.Id,contact.ConFullName,contact.ConJobTitle,contact.ConFileAs FROM  [dbo].CONTC000Master contact
INNER JOIN  [dbo].[CONTC010Bridge] vendContact ON contact.Id = vendContact.[ContactMSTRID] AND vendContact.ConTableName = 'VendContact'
INNER JOIN   VEND000Master vend ON vendContact.[ConPrimaryRecordId] = vend.Id
WHERE vendContact.[ConPrimaryRecordId] IN (SELECT DISTINCT PvlVendorID FROM

 [dbo].[PRGRM051VendorLocations] pvl WHERE pvl.PvlProgramID = @parentId )
 AND contact.StatusId In(1,2)
 AND vendContact.StatusId In(1,2) AND contact.ConOrgId = @orgId 
 )
  END

ELSE IF @entityFor = 'PPPJobRespContact'
   BEGIN
     INSERT INTO #contactComboTable(Id,ConFullName,ConJobTitle,ConFileAs)  
	EXEC [dbo].[GetJobResponsibleComboboxContacts] @orgId,@parentId 
	 
   END
ELSE IF @entityFor = 'PPPJobAnalystContact'
   BEGIN
     INSERT INTO #contactComboTable(Id,ConFullName,ConJobTitle,ConFileAs)  
	EXEC [dbo].[GetJobAnalystComboboxContacts]  @orgId,@parentId 
END
 
  --find new page no
    IF(ISNULL(@primaryKeyValue, '') <> '')
	 BEGIN
    
	IF NOT EXISTS(SELECT Id FROM #contactComboTable Where Id = @primaryKeyValue)
	BEGIN
	    INSERT INTO #contactComboTable(Id,ConFullName,ConJobTitle,ConFileAs)  
	    SELECT contact.Id,contact.ConFullName,contact.ConJobTitle,contact.ConFileAs FROM  [dbo].CONTC000Master contact 
	    WHERE contact.Id = @primaryKeyValue AND contact.ConOrgId = @orgId ;
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

/* Copyright (2018) Meridian Worldwide Transportation Group        
   All Rights Reserved Worldwide */        
-- =============================================                
-- Author:                    Janardana Behara                 
-- Create date:               06/06/2018              
-- Description:               Copy ActRole On ProgramCreate    
-- Execution:                 EXEC [dbo].[CopyActRoleOnProgramCreate]        
-- Modified on:				  2nd May 2019
-- Modified Desc:			  Implemented contact bridge related item by Parthiban M          
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
  SELECT @ccMaxNumber = MAX(ConItemNumber) FROM [CONTC010Bridge] WHERE ConPrimaryRecordId = @custId AND StatusId In (1,2) AND ConTableName='CustContact'       
        
  INSERT INTO [dbo].[CONTC010Bridge]      
           ([ConOrgId]
		   ,[ConPrimaryRecordId] 
		   ,[ConTableName] 
		   ,[ConCodeId] 
		   ,[ConTableTypeId]
           ,[ConTypeId]    
           ,[ConItemNumber]                 
           ,[ContactMSTRID]      
           ,[StatusId]      
           ,[EnteredBy]      
           ,[DateEntered])        
SELECT @orgId,@custId,'CustContact',OrgRefRoleId,183,64,(ROW_NUMBER() Over(Order By OrgRoleSortOrder) + ISNULL(@ccMaxNumber,0)),OrgRoleContactID,ISNULL(StatusId,1), @enteredBy,@dateEntered        
  from  [dbo].[ORGAN020Act_Roles]         
   WHERE(@hierarchyLevel = 1 OR @hierarchyLevel = 2 OR @hierarchyLevel = 3 OR PrxJobDefaultAnalyst = 1 OR PrxJobDefaultResponsible = 1    
           )        
    AND OrgID = @orgId      
    AND ISNULL(StatusId,1) = 1        
 AND OrgRoleContactID IS NOT NULL      
    AND OrgRoleContactID NOT IN( SELECT ContactMSTRID FROM [CONTC010Bridge] WHERE ConPrimaryRecordId = @custId AND ConTableName='CustContact');        
  
  -- Update Customer's Contact  Count after Customer Contact insertion
  UPDATE [dbo].[CUST000Master] SET CustContacts = (SELECT Count(Id) FROM [CONTC010Bridge] WHERE ConPrimaryRecordId = @custId AND ConTableName='CustContact' AND StatusId in(1,2)) WHERE Id = @custId
      
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

/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               08/16/2018      
-- Description:               Upd a cust DCLocations
-- Execution:                 EXEC [dbo].[UpdCustDcLocation]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- Modified on:				  2nd May 2019
-- Modified Desc:			  Implemented contact bridge related item by Parthiban M    
-- =============================================
ALTER PROCEDURE  [dbo].[UpdCustDcLocation]		  
	@userId BIGINT
	,@roleId BIGINT  
	,@entity NVARCHAR(100)
	,@id BIGINT
	,@cdcCustomerId BIGINT = NULL
	,@cdcItemNumber INT  = NULL
	,@cdcLocationCode NVARCHAR(20)  = NULL
	,@cdcCustomerCode NVARCHAR(20) =NULL
	,@cdcLocationTitle NVARCHAR(50)  = NULL
	,@cdcContactMSTRId BIGINT  = NULL
	,@statusId INT   = NULL
	,@changedBy NVARCHAR(50)  = NULL
	,@dateChanged DATETIME2(7)  = NULL		  
	,@isFormView BIT = 0
AS
BEGIN TRY                
 SET NOCOUNT ON;   
  DECLARE @updatedItemNumber INT      
 EXEC [dbo].[ResetItemNumber] @userId, @id, @cdcCustomerId, @entity, @cdcItemNumber, @statusId, NULL, NULL,  @updatedItemNumber OUTPUT 

    UPDATE  [dbo].[CUST040DCLocations]
       SET   CdcCustomerId	  = CASE WHEN (@isFormView = 1) THEN @cdcCustomerId WHEN ((@isFormView = 0) AND (@cdcCustomerId=-100)) THEN NULL ELSE ISNULL(@cdcCustomerId, CdcCustomerId) END
            ,CdcItemNumber	  = CASE WHEN (@isFormView = 1) THEN @updatedItemNumber WHEN ((@isFormView = 0) AND (@updatedItemNumber=-100)) THEN NULL ELSE ISNULL(@updatedItemNumber, CdcItemNumber) END
            ,CdcLocationCode  = CASE WHEN (@isFormView = 1) THEN @cdcLocationCode WHEN ((@isFormView = 0) AND (@cdcLocationCode='#M4PL#')) THEN NULL ELSE ISNULL(@cdcLocationCode, CdcLocationCode) END 
			,CdcCustomerCode  = CASE WHEN (@isFormView = 1) THEN ISNULL(@cdcCustomerCode,@cdcLocationCode) WHEN ((@isFormView = 0) AND (@cdcCustomerCode='#M4PL#')) THEN @cdcLocationCode ELSE ISNULL(@cdcCustomerCode,CdcCustomerCode)  END
            ,CdcLocationTitle = CASE WHEN (@isFormView = 1) THEN @cdcLocationTitle WHEN ((@isFormView = 0) AND (@cdcLocationTitle='#M4PL#')) THEN NULL ELSE ISNULL(@cdcLocationTitle, CdcLocationTitle) END  
            ,CdcContactMSTRId = CASE WHEN (@isFormView = 1) THEN @cdcContactMSTRId WHEN ((@isFormView = 0) AND (@cdcContactMSTRId=-100)) THEN NULL ELSE ISNULL(@cdcContactMSTRId, CdcContactMSTRId) END
            ,StatusId		  = CASE WHEN (@isFormView = 1) THEN @statusId WHEN ((@isFormView = 0) AND (@statusId=-100)) THEN NULL ELSE ISNULL(@statusId, StatusId) END
            ,ChangedBy		  = @changedBy   
            ,DateChanged	  = @dateChanged 
	  WHERE  Id = @id 
	              
	EXEC [dbo].[GetCustDcLocation] @userId, @roleId, 1 ,@id 
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO

/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan    
-- Create date:               08/16/2018      
-- Description:               Upd a vend dc loc
-- Execution:                 EXEC [dbo].[UpdVendDCLocation]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- Modified on:				  2nd May 2019
-- Modified Desc:			  Implemented contact bridge related item by Parthiban M    
-- ============================================= 
ALTER PROCEDURE  [dbo].[UpdVendDCLocation]		  
	@userId BIGINT
	,@roleId BIGINT  
	,@entity NVARCHAR(100)
	,@id BIGINT
	,@vdcVendorId BIGINT = NULL
	,@vdcItemNumber INT  = NULL
	,@vdcLocationCode NVARCHAR(20)  = NULL
	,@vdcCustomerCode NVARCHAR(20) = NULL 
	,@vdcLocationTitle NVARCHAR(50)  = NULL
	,@vdcContactMSTRId BIGINT  = NULL
	,@statusId INT  = NULL
	,@changedBy NVARCHAR(50)  = NULL
	,@dateChanged DATETIME2(7)   = NULL
	,@isFormView BIT = 0
AS
BEGIN TRY                
 SET NOCOUNT ON; 
  DECLARE @updatedItemNumber INT, @oldLocationCode NVARCHAR(20) = null, @newLocationCode NVARCHAR(20) = null, @newVdcLocationTitle NVARCHAR(50) = null, @newVdcContactMSTRId BIGINT = NULL;      
 EXEC [dbo].[ResetItemNumber] @userId, @id, @vdcVendorId, @entity, @vdcItemNumber, @statusId, NULL, NULL,  @updatedItemNumber OUTPUT
   
   SELECT @oldLocationCode = VdcLocationCode FROM [dbo].[VEND040DCLocations] WHERE Id = @id;

   UPDATE [dbo].[VEND040DCLocations]
    SET     VdcVendorId 		= CASE WHEN (@isFormView = 1) THEN @vdcVendorId WHEN ((@isFormView = 0) AND (@vdcVendorId=-100)) THEN NULL ELSE ISNULL(@vdcVendorId, VdcVendorId) END
           ,VdcItemNumber 		= CASE WHEN (@isFormView = 1) THEN @updatedItemNumber WHEN ((@isFormView = 0) AND (@updatedItemNumber=-100)) THEN NULL ELSE ISNULL(@updatedItemNumber, VdcItemNumber) END
           ,VdcLocationCode 	= CASE WHEN (@isFormView = 1) THEN @vdcLocationCode WHEN ((@isFormView = 0) AND (@vdcLocationCode='#M4PL#')) THEN NULL ELSE ISNULL(@vdcLocationCode, VdcLocationCode)  END
		   ,VdcCustomerCode 	= CASE WHEN (@isFormView = 1) THEN ISNULL(@vdcCustomerCode,@vdcLocationCode) WHEN ((@isFormView = 0) AND (@vdcCustomerCode='#M4PL#')) THEN @vdcLocationCode ELSE ISNULL(@vdcCustomerCode,VdcCustomerCode)  END
           ,VdcLocationTitle 	= CASE WHEN (@isFormView = 1) THEN @vdcLocationTitle WHEN ((@isFormView = 0) AND (@vdcLocationTitle='#M4PL#')) THEN NULL ELSE ISNULL(@vdcLocationTitle, VdcLocationTitle)  END
           ,VdcContactMSTRId 	= CASE WHEN (@isFormView = 1) THEN @vdcContactMSTRId WHEN ((@isFormView = 0) AND (@vdcContactMSTRId=-100)) THEN NULL ELSE ISNULL(@vdcContactMSTRId, VdcContactMSTRId)  END
           ,StatusId 			= CASE WHEN (@isFormView = 1) THEN @statusId WHEN ((@isFormView = 0) AND (@statusId=-100)) THEN NULL ELSE ISNULL(@statusId, StatusId) END
           ,ChangedBy 			= @changedBy 
           ,DateChanged   		= @dateChanged 
      WHERE Id = @id 	
	
	SELECT @newLocationCode = VdcLocationCode, @newVdcLocationTitle=VdcLocationTitle, @newVdcContactMSTRId = VdcContactMSTRID FROM [dbo].[VEND040DCLocations] WHERE Id = @id;
	  
	 
	 /*Below to update Program Vendor Location*/
	 UPDATE [dbo].[PRGRM051VendorLocations] SET 
	 [PvlLocationCode] = @newLocationCode,
	 [PvlLocationTitle] = @newVdcLocationTitle,
	 [PvlContactMSTRID] = @newVdcContactMSTRId
	 WHERE [PvlVendorID] = @vdcVendorId AND [PvlLocationCode] = @oldLocationCode
	  	  
	 EXEC [dbo].[GetVendDCLocation] @userId, @roleId, 1 ,@id 
END TRY    
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO