
GO
PRINT N'Altering [dbo].[CONTC000Master]...';


GO
ALTER TABLE [dbo].[CONTC000Master]
    ADD [ConOrgId] BIGINT NULL;

GO
UPDATE CON SET CON.ConOrgId =  ORG.Id
FROM CONTC000MASTER CON INNER JOIN [ORGAN000MASTER] ORG ON CON.ConCompany = ORG.OrgTitle

GO
ALTER TABLE [DBO].[CONTC000MASTER] DROP COLUMN [CONCOMPANY]


GO
PRINT N'Altering [dbo].[GetContact]...';


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
      ,org.[OrgTitle] as ConCompany
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
   INNER JOIN [dbo].[ORGAN000Master] org ON org.ID =  con.ConOrgId
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
PRINT N'Altering [dbo].[GetJobAnalystComboboxContacts]...';


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
   cont.ConFileAs        
  FROM  CONTC000MASTER cont      
  INNER JOIN [dbo].[PRGRM010Ref_GatewayDefaults] pr      
  ON cont.Id = pr.[PgdGatewayAnalyst]   
  WHERE pr.PgdProgramID = @programId      
  AND  cont.StatusId In(1,2)  AND cont.ConOrgId = @orgId 

   UNION  

SELECT contact.Id,contact.ConFullName,contact.ConJobTitle,contact.ConFileAs 
FROM  [dbo].CONTC000Master contact  
INNER JOIN  [dbo].[PRGRM020Program_Role] prgRole ON contact.Id = prgRole.[PrgRoleContactID] AND   prgRole.ProgramID = @programId AND prgRole.PrxJobDefaultAnalyst =1
WHERE  contact.StatusId In(1,2)  
AND prgRole.StatusId In(1,2) AND contact.ConOrgId = @orgId  


END TRY                              
BEGIN CATCH                              
                               
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                        
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                        
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                        
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                              
END CATCH
GO
PRINT N'Altering [dbo].[GetJobResponsibleComboboxContacts]...';


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
   cont.ConFileAs        
  FROM  CONTC000MASTER cont      
  INNER JOIN [dbo].[PRGRM010Ref_GatewayDefaults] pr      
  ON cont.Id = pr.[PgdGatewayResponsible]   
  WHERE pr.PgdProgramID = @programId AND cont.ConOrgId = @orgId    
  AND  cont.StatusId In(1,2)  

  UNION  

SELECT contact.Id,contact.ConFullName,contact.ConJobTitle,contact.ConFileAs 
FROM  [dbo].CONTC000Master contact  
INNER JOIN  [dbo].[PRGRM020Program_Role] prgRole ON contact.Id = prgRole.[PrgRoleContactID] AND   prgRole.ProgramID = @programId AND prgRole.PrxJobDefaultResponsible =1
WHERE  contact.StatusId In(1,2)  
AND prgRole.StatusId In(1,2)  AND contact.ConOrgId = @orgId   

  --AND pr.OrgID=1      
                       
END TRY                              
BEGIN CATCH                              
                               
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                        
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                        
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                        
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                              
END CATCH
GO
PRINT N'Altering [dbo].[GetPPPGatewayContactCombobox]...';


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
INNER JOIN    [dbo].[CUST010Contacts] custContact ON  contact.Id = custContact.[CustContactMSTRID]
INNER JOIN   CUST000Master cust ON custContact.[CustCustomerID] = cust.Id
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
 FROM [dbo].[CUST041DCLocationContacts] cust
 JOIN [dbo].[CUST040DCLocations] cdc ON cust.ClcCustDcLocationId = cdc.Id
 JOIN [dbo].[CUST000Master] cu ON cdc.CdcCustomerID = cu.Id
 JOIN [dbo].[CONTC000Master] contact ON cust.ClcContactMSTRID = contact.Id
 WHERE cu.[Id]=@CustomerId AND ISNULL(cust.StatusId,1)<>3 AND ISNULL(cdc.StatusId,1)<>3 AND ISNULL(contact.StatusId,1)<>3 AND contact.ConOrgId = @orgId 
 --SELECT * FROM [dbo].[PRGRM051VendorLocations]
UNION
--GET VENDOR CONTACT
SELECT contact.Id,contact.ConFullName,contact.ConJobTitle,contact.ConFileAs FROM  [dbo].CONTC000Master contact
INNER JOIN  [dbo].[VEND010Contacts] vendContact ON contact.Id = vendContact.[VendContactMSTRID]
INNER JOIN   VEND000Master vend ON vendContact.[VendVendorID] = vend.Id
WHERE vendContact.[VendVendorID] IN (SELECT DISTINCT PvlVendorID FROM
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
FROM [dbo].[VEND041DCLocationContacts] vend
  JOIN [dbo].[VEND040DCLocations] cdc ON vend.VlcVendDcLocationId = cdc.Id
  JOIN [dbo].[VEND000Master] ve ON cdc.VdcVendorID = ve.Id
  JOIN [dbo].[CONTC000Master] contact ON vend.VlcContactMSTRID = contact.Id
 WHERE ve.[Id] IN (SELECT DISTINCT PvlVendorID FROM
[dbo].[PRGRM051VendorLocations] pvl WHERE pvl.PvlProgramID = @parentId AND ISNULL(pvl.StatusId,1)<>3)
 AND ISNULL(contact.StatusId,1)<>3
 AND ISNULL(vend.StatusId,1)<>3 AND contact.ConOrgId = @orgId 
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
INNER JOIN    [dbo].[CUST010Contacts] custContact ON  contact.Id = custContact.[CustContactMSTRID]
INNER JOIN   CUST000Master cust ON custContact.[CustCustomerID] = cust.Id
INNER JOIN PRGRM000Master pgm  ON pgm.PrgCustID  =  cust.Id 
WHERE pgm.Id = @parentId
AND custContact.StatusId In(1,2) 
AND contact.StatusId In(1,2) AND contact.ConOrgId = @orgId 

UNION
--Vendor Contacts
SELECT contact.Id,contact.ConFullName,contact.ConJobTitle,contact.ConFileAs FROM  [dbo].CONTC000Master contact
INNER JOIN  [dbo].[VEND010Contacts] vendContact ON contact.Id = vendContact.[VendContactMSTRID]
INNER JOIN   VEND000Master vend ON vendContact.[VendVendorID] = vend.Id
WHERE vendContact.[VendVendorID] IN (SELECT DISTINCT PvlVendorID FROM

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
PRINT N'Altering [dbo].[InsContact]...';


GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               08/16/2018      
-- Description:               Ins a contact 
-- Execution:                 EXEC [dbo].[InsContact]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- ============================================= 
ALTER PROCEDURE  [dbo].[InsContact]
	 @userId BIGINT
	,@roleId BIGINT 
	,@entity NVARCHAR(100)
	,@conERPId NVARCHAR(50) = NULL
	,@conTitleId INT = NULL
	,@conLastName NVARCHAR(25) = NULL
	,@conFirstName NVARCHAR(25) = NULL
	,@conMiddleName NVARCHAR(25) = NULL
	,@conEmailAddress NVARCHAR(100) = NULL
	,@conEmailAddress2 NVARCHAR(100) = NULL
	,@conJobTitle NVARCHAR(50) = NULL
	,@conBusinessPhone NVARCHAR(25) = NULL
	,@conBusinessPhoneExt NVARCHAR(15) = NULL
	,@conHomePhone NVARCHAR(25) = NULL
	,@conMobilePhone NVARCHAR(25) = NULL
	,@conFaxNumber NVARCHAR(25) = NULL
	,@conBusinessAddress1 NVARCHAR(255) = NULL
	,@conBusinessAddress2 NVARCHAR(150) = NULL
	,@conBusinessCity NVARCHAR(25) = NULL
	,@conBusinessStateId INT = NULL
	,@conBusinessZipPostal NVARCHAR(20) = NULL
	,@conBusinessCountryId INT = NULL
	,@conHomeAddress1 NVARCHAR(150) = NULL
	,@conHomeAddress2 NVARCHAR(150) = NULL
	,@conHomeCity NVARCHAR(25) = NULL
	,@conHomeStateId INT = NULL
	,@conHomeZipPostal NVARCHAR(20) = NULL
	,@conHomeCountryId INT = NULL
	,@conAttachments INT = NULL
	,@conWebPage NTEXT = NULL
	,@conNotes NTEXT = NULL
	,@statusId INT = NULL
	,@conTypeId INT = NULL
	,@conOutlookId NVARCHAR(50) = NULL
	,@dateEntered DATETIME2(7)
	,@enteredBy NVARCHAR(50) = NULL
AS
BEGIN TRY                
 SET NOCOUNT ON;   
 DECLARE @currentId BIGINT;
 DECLARE @OrgID BIGINT;
 select @OrgID =OrgID from [dbo].[ORGAN020Act_Roles]  where id= @roleId and OrgRoleContactID = @userId
 INSERT INTO [dbo].[CONTC000Master]
        ([ConERPId]
        ,[ConTitleId]
        ,[ConLastName]
        ,[ConFirstName]
        ,[ConMiddleName]
        ,[ConEmailAddress]
        ,[ConEmailAddress2]
        ,[ConJobTitle]
        ,[ConBusinessPhone]
        ,[ConBusinessPhoneExt]
        ,[ConHomePhone]
        ,[ConMobilePhone]
        ,[ConFaxNumber]
        ,[ConBusinessAddress1]
        ,[ConBusinessAddress2]
        ,[ConBusinessCity]
        ,[ConBusinessStateId]
        ,[ConBusinessZipPostal]
        ,[ConBusinessCountryId]
        ,[ConHomeAddress1]
        ,[ConHomeAddress2]
        ,[ConHomeCity]
        ,[ConHomeStateId]
        ,[ConHomeZipPostal]
        ,[ConHomeCountryId]
        ,[ConAttachments]
        ,[ConWebPage]
        ,[ConNotes]
        ,[StatusId]
        ,[ConTypeId]
        ,[ConOutlookId]
        ,[DateEntered]
        ,[EnteredBy]
	    ,[ConOrgId])
     VALUES
		(@conERPId 
		,@conTitleId
		,@conLastName
		,@conFirstName
		,@conMiddleName
		,@conEmailAddress
		,@conEmailAddress2
		,@conJobTitle
		,@conBusinessPhone
		,@conBusinessPhoneExt
		,@conHomePhone
		,@conMobilePhone
		,@conFaxNumber
		,@conBusinessAddress1
		,@conBusinessAddress2
		,@conBusinessCity
		,@conBusinessStateId
		,@conBusinessZipPostal
		,@conBusinessCountryId
		,@conHomeAddress1
		,@conHomeAddress2
		,@conHomeCity
		,@conHomeStateId
		,@conHomeZipPostal
		,@conHomeCountryId
		,@conAttachments
		,@conWebPage
		,@conNotes
		,@statusId
		,@conTypeId
		,@conOutlookId
		,@dateEntered
		,@enteredBy
		,@OrgID)

		SET @currentId = SCOPE_IDENTITY();
	 SELECT * FROM [dbo].[CONTC000Master] WHERE Id = @currentId;
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
PRINT N'Altering [dbo].[GetContactCombobox]...';


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
	
		SET @sqlCommand = @sqlCommand + ' WHERE '+  @entity +'.ConOrgId ='+  CAST(@orgId AS NVARCHAR(100)) +  ' AND (ISNULL('+ @entity +'.StatusId, 1) In (1,2)  OR ' + @primaryKeyName + '=' + @primaryKeyValue + ')';
	    
	
		SET @sqlCommand += ' ) t WHERE t.' + @primaryKeyName + '=' + @primaryKeyValue;
		
		EXEC sp_executesql @sqlCommand, N' @newPgNo int output',@newPgNo output                                    
		SET @newPgNo =  @newPgNo/@pageSize + 1; 
		SET @pageSize = @newPgNo * @pageSize;
		SET @sqlCommand=''
	 END
	 
	 SET @sqlCommand += 'SELECT '+ @fields +' From [dbo].[CONTC000Master] (NOLOCK) '+  @entity + ' WHERE 1=1 '  + ' AND '+ @entity +'.ConOrgId ='+  CAST(@orgId AS NVARCHAR(100))
	
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
	  SET @sqlCommand = @sqlCommand + ' AND ('  
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
PRINT N'Altering [dbo].[GetContactView]...';


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
SET @TCountQuery = @TCountQuery + ' INNER JOIN [dbo].[fnGetUserStatuses](@userId) fgus ON ISNULL(' + @entity + '.[StatusId], 1) = fgus.[StatusId] '

SET @TCountQuery = @TCountQuery +' WHERE 1=1 ' + ISNULL(@where, '') + ' AND '+ @entity +'.ConOrgId ='+  CAST(@orgId AS nvarchar(100))

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

SET @sqlCommand = @sqlCommand + ' WHERE 1=1 '+ ISNULL(@where, '')+ ' AND '+ @entity +'.ConOrgId ='+  CAST(@orgId AS nvarchar(100))

IF((@recordId > 0) AND (((@isNext = 0) AND (@isEnd = 0)) OR ((@isNext = 1) AND (@isEnd = 0))))
	BEGIN
		IF((@isNext = 0) AND (@isEnd = 0))  
	    BEGIN  
	 	IF(ISNULL(@orderBy, '') <> '')
	 	 BEGIN
	 		SET @sqlCommand = @sqlCommand + ' AND ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' <= (SELECT ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' FROM [dbo].[CONTC000Master] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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
	 		SET @sqlCommand = @sqlCommand + ' AND ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' >= (SELECT ' + REPLACE(REPLACE(@orderBy, ' DESC', ''), ' ASC', '') + ' FROM [dbo].[CONTC000Master] (NOLOCK) '+ @entity + ' WHERE ' + @entity + '.Id=' + CAST(@recordId AS NVARCHAR(50)) +') ' 
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
PRINT N'Inserting Record in [SYSTM000ColumnsAlias].';
INSERT INTO [dbo].[SYSTM000ColumnsAlias] ([LangCode], [ColTableName], [ColColumnName], [ColAliasName], [ColCaption], [ColLookupId], [ColLookupCode], [ColDescription], [ColSortOrder], [ColIsReadOnly], [ColIsVisible], [ColIsDefault], [StatusId], [ColDisplayFormat], [ColAllowNegativeValue], [ColIsGroupBy], [ColMask]) VALUES (N'EN', N'Contact', N'ConOrgId', N'Company Name', N'Company Name', NULL, NULL, NULL, 3, 1, 1, 1, 1, NULL, NULL, 0, NULL)

GO
PRINT N'Delete conCompany record from [SYSTM000ColumnsAlias].';
Delete from [SYSTM000ColumnsAlias] where ColTableName ='Contact' and ColColumnName ='conCompany'

GO
PRINT N'Delete conCompany record from [SYSTM000ColumnsAlias].';
Delete from [SYSTM000ColumnsAlias] where ColTableName ='Contact' and ColColumnName ='conCompany'
PRINT N'Update complete.';



