
GO
/****** Object:  StoredProcedure [dbo].[GetPPPGatewayContactCombobox]    Script Date: 7/4/2019 12:27:22 PM ******/
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
-- Modified By:               Nikhil(07/04/2019)    
-- Modified Desc:             Updated it for @entityFor = 'PPPRoleCodeContact' to display only relevent Customer Contact,CustomerDClocation,CustomerDCLocationContact,Mapped Vendor Contact,its DC location and DC location Contact based on Customer.
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
IF @entityFor = 'PPPRoleCodeContact'
BEGIN
DECLARE @CustomerId INT
SELECT @CustomerId=PrgCustID FROM PRGRM000Master where id=@parentid

INSERT INTO #contactComboTable(Id,ConFullName,ConJobTitle,ConFileAs)  
(

--GET EMPLOYEE CONTACT OF ORGANIZATION PASSED AS @ORGID. 
SELECT contact.Id,contact.ConFullName,contact.ConJobTitle,contact.ConFileAs FROM  [dbo].CONTC000Master contact  
INNER JOIN [dbo].[SYSTM000Ref_Options] refOpt on refOpt.Id = contact.ConTypeId
WHERE contact.ConOrgId = @orgId   AND  refOpt.SysOptionName = 'Employee'  AND  ISNULL(contact.StatusId,1)<>3  AND ISNULL(refOpt.StatusId,1)<>3

 UNION
-- GET CUSTOMER CONTACT
SELECT contact.Id,contact.ConFullName,contact.ConJobTitle,contact.ConFileAs FROM  [dbo].CONTC000Master contact
INNER JOIN   [dbo].[CONTC010Bridge] custContact ON  contact.Id = custContact.[ContactMSTRID] AND custContact.ConTableName = 'CustContact'
INNER JOIN   CUST000Master cust ON custContact.[ConPrimaryRecordId] = cust.Id
INNER JOIN PRGRM000Master pgm  ON pgm.PrgCustID  =  cust.Id 
WHERE cust.ID=@CustomerId AND contact.ConOrgId = @orgId AND  pgm.Id = @parentId
AND ISNULL(custContact.StatusId,1)<>3 
AND ISNULL(contact.StatusId,1) <>3

UNION
--GET CUSTOMER DC LOC SUB CONTACT
SELECT contact.Id,contact.ConFullName,contact.ConJobTitle,contact.ConFileAs FROM  [dbo].CONTC000Master contact
INNER JOIN  [dbo].[CONTC010Bridge] ConBridge ON  contact.Id = ConBridge.[ContactMSTRID] AND ConBridge.ConTableName = 'CustDcLocationContact'
INNER JOIN  [dbo].[CUST040DCLocations] cdcLocation ON cdcLocation.Id = ConBridge.[ConPrimaryRecordId]  
INNER JOIN  [dbo].CUST000Master cust ON cdcLocation.CdcCustomerID = cust.Id
INNER JOIN PRGRM000Master pgm  ON pgm.PrgCustID  =  cust.Id 
WHERE pgm.Id = @parentId
AND ISNULL(ConBridge.StatusId,1)<>3  
AND ISNULL(contact.StatusId,1)<>3  AND contact.ConOrgId = @orgId 

UNION
-- CUSTOMER DC LOCATION
SELECT contact.Id,contact.ConFullName,contact.ConJobTitle,contact.ConFileAs FROM  [dbo].CONTC000Master contact
INNER JOIN    [dbo].[CUST040DCLocations] custDCL ON  contact.Id = custDCL.[CdcContactMSTRID] 
INNER JOIN   CUST000Master cust ON custDCL.CdcCustomerID = cust.Id
INNER JOIN PRGRM000Master pgm  ON pgm.PrgCustID  =  cust.Id 
WHERE pgm.Id = @parentId
AND custDCL.StatusId In(1,2) 
AND contact.StatusId In(1,2) AND contact.ConOrgId = @orgId 

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



ELSE IF @entityFor = 'PPPRespGateway' 
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
 
 
 --UNION
--Customer DC Location Contacts
--SELECT contact.Id,contact.ConFullName,contact.ConJobTitle,contact.ConFileAs FROM  [dbo].CONTC000Master contact
--INNER JOIN  [dbo].[CONTC010Bridge] ConBridge ON  contact.Id = ConBridge.[ContactMSTRID] AND ConBridge.ConTableName = 'CustDcLocationContact'
--INNER JOIN  [dbo].[CUST040DCLocations] cdcLocation ON cdcLocation.Id = ConBridge.[ConPrimaryRecordId]  
--INNER JOIN  [dbo].CUST000Master cust ON cdcLocation.CdcCustomerID = cust.Id
--INNER JOIN PRGRM000Master pgm  ON pgm.PrgCustID  =  cust.Id 
--WHERE pgm.Id = @parentId
--AND ConBridge.StatusId In(1,2) 
--AND contact.StatusId In(1,2) AND contact.ConOrgId = @orgId 

--UNION
---- Customer DC Location
--SELECT contact.Id,contact.ConFullName,contact.ConJobTitle,contact.ConFileAs FROM  [dbo].CONTC000Master contact
--INNER JOIN    [dbo].[CUST040DCLocations] custDCL ON  contact.Id = custDCL.[CdcContactMSTRID] 
--INNER JOIN   CUST000Master cust ON custDCL.CdcCustomerID = cust.Id
--INNER JOIN PRGRM000Master pgm  ON pgm.PrgCustID  =  cust.Id 
--WHERE pgm.Id = @parentId
--AND custDCL.StatusId In(1,2) 
--AND contact.StatusId In(1,2) AND contact.ConOrgId = @orgId 

--UNION
---- Employee Contact of Organization passed as @orgId. 
--SELECT contact.Id,contact.ConFullName,contact.ConJobTitle,contact.ConFileAs FROM  [dbo].CONTC000Master contact  
--INNER JOIN [dbo].[SYSTM000Ref_Options] refOpt on refOpt.Id = contact.ConTypeId
--WHERE contact.ConOrgId = @orgId   AND  refOpt.SysOptionName = 'Employee'  AND   contact.StatusId In(1,2)  AND refOpt.StatusId IN(1,2)


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
