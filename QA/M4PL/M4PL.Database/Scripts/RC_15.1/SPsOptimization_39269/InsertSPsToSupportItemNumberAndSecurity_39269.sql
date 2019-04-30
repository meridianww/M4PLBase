USE [M4PL_3030_Azure]
GO
/****** Object:  StoredProcedure [dbo].[InsAndUpdChooseColumn]    Script Date: 11/26/2018 8:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               10/26/2018      
-- Description:               Insert and update choose column
-- Execution:                 EXEC [dbo].[InsAndUpdChooseColumn]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- ============================================= 
ALTER PROCEDURE  [dbo].[InsAndUpdChooseColumn]
    @userId BIGINT,
	@colTableName nvarchar(100) = NULL,
	@colSortOrder nvarchar(4000) = NULL,
	@colNotVisible nvarchar(4000) = NULL,
	@colIsFreezed nvarchar(4000) = NULL,
	@colIsDefault nvarchar(4000) = NULL,
	@colGroupBy nvarchar(4000) = null,
	@colGridLayout nvarchar(4000) = NULL,
	@dateEntered datetime2(7) = NULL,
	@enteredBy nvarchar(50) = NULL,
	@dateChanged datetime2(7) = NULL,
	@changedBy nvarchar(50) = NULL
AS
BEGIN TRY                
 SET NOCOUNT ON;   

 IF EXISTS(SELECT Id FROM [dbo].[SYSTM000ColumnSettingsByUser] WHERE ColUserId = @userId AND [ColTableName] = @colTableName )
 BEGIN
	 UPDATE [dbo].[SYSTM000ColumnSettingsByUser]
		SET	 [ColUserId]			=	ISNULL(@userId, ColUserId)
			,[ColTableName]		=	ISNULL(@colTableName, ColTableName)
			,[ColSortOrder]		=	@colSortOrder
			,[ColNotVisible]	=	@colNotVisible
			,[ColIsFreezed]		=	@colIsFreezed
			,[ColIsDefault]		=	@colIsDefault
			,[ColGroupBy]		=	@colGroupBy
			,[ColGridLayout]	=	@colGridLayout
			,[DateChanged]		=	@dateChanged
			,[ChangedBy]		=	@changedBy
		WHERE ColUserId = @userId AND [ColTableName] = @colTableName
END
ELSE
BEGIN
	INSERT INTO [dbo].[SYSTM000ColumnSettingsByUser]
           (ColUserId
			,[ColTableName]
			,[ColSortOrder]
			,[ColNotVisible]
			,[ColIsFreezed]
			,[ColIsDefault]
			,[ColGroupBy]
			,[ColGridLayout]
			,[DateEntered]
			,[EnteredBy])
     VALUES
           (@userId
			,@colTableName
			,@colSortOrder
			,@colNotVisible
			,@colIsFreezed
			,@colIsDefault
			,@colGroupBy
			,@colGridLayout
			,@dateEntered
			,@enteredBy) 

END
	EXEC [dbo].[GetColumnAliasesByUserAndTbl] @userId, @colTableName

END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[InsAssignUnassignProgram]    Script Date: 11/26/2018 8:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Janardana         
-- Create date:               12/01/2018      
-- Description:               Map vendor Locations
-- Execution:                 EXEC [dbo].[InsAssignUnassignProgram]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================  
                 
ALTER PROCEDURE [dbo].[InsAssignUnassignProgram] @userId BIGINT        
	 ,@parentId BIGINT        
	 ,@assign BIT        
	 ,@locationIds VARCHAR(MAX)        
	 ,@vendorIds VARCHAR(MAX) = NULL      
	 ,@enteredBy NVARCHAR(50) = NULL      
	 ,@assignedOn DATETIME2(7) = NULL        
AS        
BEGIN TRY        
 BEGIN TRANSACTION        
        
 DECLARE @success BIT  = 0        
        
 IF @assign = 1        
 BEGIN        
  DECLARE @MaxItemNumber INT        
        
  SELECT @MaxItemNumber = PvlItemNumber        
  FROM [dbo].[PRGRM051VendorLocations]        
  WHERE PvlProgramID = @parentId        
   AND StatusId IN (1,2)        
        
  IF LEN(ISNULL(@locationIds, '')) > 0        
  BEGIN        
   -- map vendor locations by location Ids            
   INSERT INTO [dbo].[PRGRM051VendorLocations] (        
    PvlProgramID        
    ,PvlVendorID        
    ,PvlItemNumber        
    ,PvlLocationCode        
    ,PvlLocationTitle        
    ,PvlContactMSTRID        
    ,StatusId        
    ,EnteredBy        
    ,DateEntered        
    )        
   SELECT @parentId        
    ,(SELECT VdcVendorID       FROM VEND040DCLocations  WHERE Id = Item  )        
    ,ISNULL(@MaxItemNumber, 0) + Row_Number() OVER (ORDER BY Item  )        
    ,(SELECT VdcLocationCode  FROM VEND040DCLocations  WHERE Id = Item  )        
    ,(SELECT VdcLocationTitle  FROM VEND040DCLocations  WHERE Id = Item  )        
    ,(SELECT VdcContactMSTRID  FROM VEND040DCLocations WHERE Id = Item )        
    ,1        
    ,@enteredBy        
    ,ISNULL(@assignedOn,GETUTCDATE())        
   FROM dbo.fnSplitString(@locationIds, ',');        
        
    SET @success = 1        
        
   END        
        
  -- map vendor locations by vendor Ids            
      
      
  IF LEN(ISNULL(@vendorIds, '')) > 0        
  BEGIN        
     SELECT @MaxItemNumber = PvlItemNumber   FROM [dbo].[PRGRM051VendorLocations] WHERE PvlProgramID = @parentId  AND StatusId IN (1,2)        
      
      
    INSERT INTO [dbo].[PRGRM051VendorLocations] (        
     PvlProgramID        
    ,PvlVendorID        
    ,PvlItemNumber        
    ,PvlLocationCode        
    ,PvlLocationTitle        
    ,PvlContactMSTRID        
    ,StatusId        
    ,EnteredBy        
    ,DateEntered        
    )        
   SELECT @parentId        
    ,VdcVendorID        
    ,ISNULL(@MaxItemNumber, 0) + Row_Number() OVER (ORDER BY Id  )        
    ,VdcLocationCode       
    ,VdcLocationTitle       
    ,VdcContactMSTRID      
    ,1        
    ,@enteredBy        
    ,ISNULL(@assignedOn,GETUTCDATE())  
 FROM  VEND040DCLocations  
 WHERE VdcVendorID IN (select Item from dbo.fnSplitString(@vendorIds, ',')) 
 AND StatusId IN (1,2) 
 AND VdcLocationCode NOT IN (select PvlLocationCode FROM PRGRM051VendorLocations WHERE PvlProgramID = @parentId AND StatusId IN (1,2) AND PvlVendorID  IN (select Item from dbo.fnSplitString(@vendorIds, ',')));      
      
   INSERT INTO [dbo].[PRGRM051VendorLocations] (        
    PvlProgramID        
    ,PvlVendorID        
    ,PvlItemNumber        
    ,PvlLocationCode        
    ,PvlLocationTitle        
    ,PvlContactMSTRID        
    ,StatusId        
    ,EnteredBy        
    ,DateEntered        
    )        
   SELECT @parentId        
    ,Item        
    ,ISNULL(@MaxItemNumber, 0) + Row_Number() OVER (        
     ORDER BY Item        
     )        
    ,(        
     SELECT VendCode        
     FROM VEND000Master        
     WHERE Id = Item        
     )        
    ,(        
     SELECT VendTitle        
     FROM VEND000Master        
     WHERE Id = Item        
     )        
    ,(        
     SELECT ISNULL(VendWorkAddressId, ISNULL(VendCorporateAddressId, VendBusinessAddressId))        
     FROM VEND000Master        
     WHERE Id = Item    
     )        
    ,1        
     ,@enteredBy        
    ,ISNULL(@assignedOn,GETUTCDATE())  
   FROM dbo.fnSplitString(@vendorIds, ',')      
   WHERE ITEM  Not In (SELECT VdcVendorID FROM  VEND040DCLocations WHERE vdcvendorId IN (select Item from dbo.fnSplitString(@vendorIds, ',')) AND StatusId IN (1,2)  );        
        
   -- Create DC Locations for the vendor When location is not exits        
   INSERT INTO  VEND040DCLocations (        
     VdcVendorID        
    ,VdcItemNumber        
    ,VdcLocationCode  
	,VdcCustomerCode            
    ,VdcLocationTitle        
    ,VdcContactMSTRID        
    ,StatusId        
    ,EnteredBy        
    ,DateEntered        
    )        
   SELECT Item        
    ,1        
    ,(        
     SELECT VendCode        
     FROM VEND000Master        
     WHERE Id = Item        
     ) 
	 ,(        
     SELECT VendCode        
     FROM VEND000Master        
     WHERE Id = Item        
     )      
	        
    ,(        
     SELECT VendTitle        
     FROM VEND000Master        
     WHERE Id = Item        
     )        
    ,(        
     SELECT ISNULL(VendWorkAddressId, ISNULL(VendCorporateAddressId, VendBusinessAddressId))        
     FROM VEND000Master        
     WHERE Id = Item        
     )        
    ,1        
     ,@enteredBy        
    ,ISNULL(@assignedOn,GETUTCDATE())   
   FROM dbo.fnSplitString(@vendorIds, ',')  WHERE ITEM  Not In (SELECT VdcVendorID FROM  VEND040DCLocations WHERE vdcvendorId IN (select Item from dbo.fnSplitString(@vendorIds, ',')) AND StatusId IN (1,2) );          
        
   SET @success = 1        
  END        
 END        
 ELSE        
 BEGIN      
  IF LEN(ISNULL(@locationIds, '')) > 0        
  BEGIN        
        UPDATE [dbo].[PRGRM051VendorLocations]   SET StatusId = 3  
                                              ,DateChanged = ISNULL(@assignedOn,GETUTCDATE())        
             ,ChangedBy = @enteredBy  
           WHERE Id IN ( SELECT Item    FROM dbo.fnSplitString(@LocationIds, ',') )        
                AND PvlProgramID = @parentId;     
  END    
  IF LEN(ISNULL(@vendorIds, '')) > 0    
  BEGIN    
        UPDATE [dbo].[PRGRM051VendorLocations]   SET StatusId = 3    
                                           ,DateChanged = ISNULL(@assignedOn,GETUTCDATE())        
             ,ChangedBy = @enteredBy      
           WHERE Id IN (SELECT Id FROM PRGRM051VendorLocations WHERE PvlVendorID IN (SELECT Item    FROM dbo.fnSplitString(@vendorIds, ',')) AND StatusId IN(1,2) )        
                AND PvlProgramID = @parentId;     
             
  END    
       
        
        
  --Update Item No after delete           
  CREATE TABLE #temptable (        
   Id BIGINT        
   ,PvlItemNumber INT        
   )        
        
  INSERT INTO #temptable (        
   Id        
   ,PvlItemNumber        
   )        
  SELECT Id        
   ,ROW_NUMBER() OVER (        
    ORDER BY PvlItemNumber        
    )        
  FROM PRGRM051VendorLocations        
  WHERE PvlProgramID = @parentId        
   AND StatusId IN (        
    1        
    ,2        
    )        
  ORDER BY Id        
        
  MERGE INTO PRGRM051VendorLocations c1        
  USING #temptable c2        
   ON c1.Id = c2.Id        
  WHEN MATCHED        
   THEN        
    UPDATE        
    SET c1.PvlItemNumber = c2.PvlItemNumber;        
        
     SET @success = 1        
 END        
        
 COMMIT TRANSACTION        
 SELECT @success        
END TRY        
        
BEGIN CATCH        
 ROLLBACK TRANSACTION        
        
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                  
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                  
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                  
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity   
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[InsAttachment]    Script Date: 11/26/2018 8:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Janardhan Behara 
-- Create date:               11/11/2018      
-- Description:               Ins a Attachment  
-- Execution:                 EXEC [dbo].[InsAttachment]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- ============================================= 
  
ALTER PROCEDURE  [dbo].[InsAttachment]  
	(@userId BIGINT  
	,@roleId BIGINT 
	,@entity NVARCHAR(100)  
	,@attTableName NVARCHAR(100) = NULL  
	,@attPrimaryRecordID BIGINT = NULL  
	,@attItemNumber INT = NULL  
	,@attTitle NVARCHAR(50) = NULL  
	,@attTypeId INT = NULL  
	,@attFileName NVARCHAR(50) = NULL  
	,@statusId INT =NULL 
	,@primaryTableFieldName NVARCHAR(100) = NULL
	,@enteredBy NVARCHAR(50) = NULL  
	,@dateEntered DATETIME2(7) = NULL)  
AS  
BEGIN TRY                  
 SET NOCOUNT ON; 
  DECLARE @updatedItemNumber INT      
  DECLARE @where NVARCHAR(MAX) = ' AND AttTableName ='''  +  @attTableName+'''';
  EXEC [dbo].[ResetItemNumber] @userId, 0, @attPrimaryRecordID, @entity, @attItemNumber, @statusId, NULL, @where, @updatedItemNumber OUTPUT  
    
 DECLARE @currentId BIGINT;  
 INSERT INTO [dbo].[SYSTM020Ref_Attachments]  
           ([AttTableName]  
           ,[AttPrimaryRecordID]  
           ,[AttItemNumber]  
           ,[AttTitle]  
           ,[AttTypeId]  
           ,[AttFileName]  
		   ,[StatusId]  
           ,[EnteredBy]  
           ,[DateEntered])  
     VALUES  
           (@attTableName
           ,@attPrimaryRecordID   
           ,@updatedItemNumber --@attItemNumber   
           ,@attTitle
           ,@attTypeId  
           ,@attFileName    
		   ,ISNULL(@statusId,1) 
           ,@enteredBy    
           ,ISNULL(@dateEntered,GETUTCDATE()))   
     SET @currentId = SCOPE_IDENTITY();  

	IF(ISNULL(@primaryTableFieldName, '') <> '')
		BEGIN
			DECLARE @updateQuery NVARCHAR(MAX)
			DECLARE @actualTableName NVARCHAR(100)
			SELECT @actualTableName = TblTableName FROM [dbo].[SYSTM000Ref_Table] WHERE SysRefName = @attTableName
			SET @updateQuery = 'UPDATE '+ @actualTableName + ' SET ' + @primaryTableFieldName + '=ISNULL(' + @primaryTableFieldName + ', 0)+1 WHERE Id='+CAST(@attPrimaryRecordID AS NVARCHAR(10)) +
							   '; SELECT * FROM [dbo].[SYSTM020Ref_Attachments] WHERE Id='+CAST(@currentId AS NVARCHAR(20))
			EXEC sp_executesql @updateQuery
		END
	ELSE
		BEGIN
			 SELECT * FROM [dbo].[SYSTM020Ref_Attachments] WHERE Id = @currentId;     
		END
END TRY                
BEGIN CATCH                  
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                  
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                  
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                  
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                  
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[InsColumnAlias]    Script Date: 11/26/2018 8:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan 
-- Create date:               08/16/2018      
-- Description:               Ins a Sys Column alias
-- Execution:                 EXEC [dbo].[InsColumnAlias]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================
ALTER PROCEDURE  [dbo].[InsColumnAlias]		  
	@userId BIGINT
	,@roleId BIGINT 
	,@entity NVARCHAR(100)
	,@langCode NVARCHAR(10) = NULL
	,@colTableName NVARCHAR(100) 
	,@colColumnName NVARCHAR(50) 
	,@colAliasName NVARCHAR(50)  = NULL
	,@lookupId INT
	,@colCaption NVARCHAR(50)  = NULL
	,@colDescription NVARCHAR(255)  = NULL
	,@colSortOrder INT  = NULL
	,@colIsReadOnly BIT  = NULL
	,@colIsVisible BIT 
	,@colIsDefault BIT  
	,@statusId INT  = NULL
AS
BEGIN TRY                
 SET NOCOUNT ON;   
 DECLARE @currentId BIGINT;
   INSERT INTO [dbo].[SYSTM000ColumnsAlias]
           ([LangCode]
           ,[ColTableName]
           ,[ColColumnName]
           ,[ColAliasName]
		   ,[ColLookupId]
           ,[ColCaption]
           ,[ColDescription]
           ,[ColSortOrder]
           ,[ColIsReadOnly]
           ,[ColIsVisible]
           ,[ColIsDefault]
		   ,[StatusId])
     VALUES
		   (@langCode  
           ,@colTableName  
           ,@colColumnName  
           ,@colAliasName 
		   ,@lookupId 
           ,@colCaption  
           ,@colDescription 
           ,@colSortOrder   
           ,@colIsReadOnly   
           ,@colIsVisible   
           ,@colIsDefault
		   ,@statusId)
  

  SET @currentId = SCOPE_IDENTITY();
  IF(@lookupId > 0)
  BEGIN
   UPDATE cal
      SET cal.[ColLookupCode] = lk.LkupCode 
	  FROM  [SYSTM000ColumnsAlias] cal
	  INNER JOIN [dbo].[SYSTM000Ref_Lookup] lk  ON lk.Id= cal.ColLookupId AND cal.Id = @currentId
	END

 EXEC [dbo].[GetColumnAlias] @userId, @roleId, 1, @langCode, @currentId 

END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH



/***** Object:  StoredProcedure [dbo].[UpdSysColumnAlias]    Script Date: 8/16/2017 1:30:20 PM *****/
SET ANSI_NULLS ON
GO
/****** Object:  StoredProcedure [dbo].[InsColumnAliasesByTableName]    Script Date: 11/26/2018 8:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan 
-- Create date:               04/14/2018      
-- Description:               Insert ColumnAliases By Table Name  
-- Execution:                 EXEC [dbo].[InsColumnAliasesByTableName]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================
ALTER PROCEDURE [dbo].[InsColumnAliasesByTableName]
  @langCode NVARCHAR(10),
  @tableName NVARCHAR(100)
AS                
BEGIN TRY                
 SET NOCOUNT ON;   
   IF NOT EXISTS(SELECT TOP 1 1 FROM SYSTM000ColumnsAlias WHERE [ColTableName]= @tableName AND [LangCode] =@langCode)
   BEGIN
	 DECLARE @currentId BIGINT;
	 INSERT INTO [dbo].[SYSTM000ColumnsAlias]
           ([LangCode]
           ,[ColTableName]
           ,[ColColumnName]
           ,[ColAliasName]
           ,[ColCaption]
           ,[ColDescription]
           ,[ColSortOrder]
		   ,[ColIsReadOnly]
           ,[ColIsVisible]
           ,[ColIsDefault])
	  SELECT @langCode as LangCode
		  , tbl.SysRefName as ColTableName
		  ,c.name as ColColumnName
		  ,[dbo].[fnGetPascalName](c.name) as ColAliasName
		  ,[dbo].[fnGetPascalName](c.name+'Caption') as ColCaption
		  ,[dbo].[fnGetPascalName](c.name+'Desc') as ColDescription
		  ,CAST( ROW_NUMBER() OVER (ORDER BY c.object_id) AS int) as ColSortOrder
		  ,(CASE  WHEN ( c.name = 'Id' OR c.name = 'DateEntered' OR  c.name = 'EnteredBy' OR   c.name = 'DateChanged' OR  c.name = 'ChangedBy' OR c.name = 'SysRefId' OR c.name = 'SysRefName') THEN 1 ELSE 0 END ) as ColIsReadOnly
		  ,(CASE  WHEN (c.name = 'DateEntered' OR  c.name = 'EnteredBy' OR   c.name = 'DateChanged' OR  c.name = 'ChangedBy' OR t.name ='varbinary' OR t.name='image' OR t.name='LookupName') THEN 0 ELSE 1 END ) as ColIsVisible
		  ,1 as ColIsDefault
	 FROM sys.columns c
	INNER JOIN [dbo].[SYSTM000Ref_Table] (NOLOCK) tbl ON tbl.SysRefName = @tableName
	 INNER JOIN  sys.types t ON c.user_type_id = t.user_type_id
	 WHERE  c.object_id = OBJECT_ID(tbl.TblTableName)

	 SET @currentId = SCOPE_IDENTITY();
	 EXEC GetColumnAliasesByTableName @langCode, @tableName;
	END
END TRY                
BEGIN CATCH                
	DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
			,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
			,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 
	EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[InsContact]    Script Date: 11/26/2018 8:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
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
	,@conCompany NVARCHAR(100) = NULL
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
 INSERT INTO [dbo].[CONTC000Master]
        ([ConERPId]
        ,[ConCompany]
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
        ,[EnteredBy] )
     VALUES
		(@conERPId 
		,@conCompany 
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
		,@enteredBy)

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
/****** Object:  StoredProcedure [dbo].[InsCredential]    Script Date: 11/26/2018 8:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               08/16/2018      
-- Description:               Ins a org credential
-- Execution:                 EXEC [dbo].[InsCredential]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================
ALTER PROCEDURE  [dbo].[InsCredential]		  
	@userId BIGINT
	,@roleId BIGINT 
	,@entity NVARCHAR(100)
	,@orgId BIGINT = NULL
	,@creItemNumber INT = NULL 
	,@creCode NVARCHAR(20) = NULL 
	,@creTitle NVARCHAR(50) = NULL 
	,@creExpDate DATETIME2(7) = NULL 
	,@statusId INT = NULL
	,@dateEntered DATETIME2(7) = NULL 
	,@enteredBy NVARCHAR(50) = NULL   
AS
BEGIN TRY                
 SET NOCOUNT ON; 
  DECLARE @updatedItemNumber INT      
  EXEC [dbo].[ResetItemNumber] @userId, 0, @orgId, @entity, @creItemNumber, @statusId, NULL, NULL,  @updatedItemNumber OUTPUT 
   
 DECLARE @currentId BIGINT;
   INSERT INTO [dbo].[ORGAN030Credentials]
           ([OrgId]
           ,[CreItemNumber]
           ,[CreCode]
           ,[CreTitle]
           ,[CreExpDate]
		   ,[StatusId]
           ,[DateEntered]
           ,[EnteredBy])
     VALUES
		    (@orgId  
            ,@updatedItemNumber  
            ,@creCode  
            ,@creTitle  
            ,@creExpDate 
			,@statusId 
            ,@dateEntered  
            ,@enteredBy )  
	SET @currentId = SCOPE_IDENTITY();
	SELECT * FROM [dbo].[ORGAN030Credentials] WHERE Id = @currentId;
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH



/***** Object:  StoredProcedure [dbo].[UpdOrgCredential]    Script Date: 8/16/2017 1:30:20 PM *****/
SET ANSI_NULLS ON
GO
/****** Object:  StoredProcedure [dbo].[InsCustBusinessTerm]    Script Date: 11/26/2018 8:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               08/16/2018      
-- Description:               Ins a cust contact
-- Execution:                 EXEC [dbo].[InsCustBusinessTerm]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================
ALTER PROCEDURE  [dbo].[InsCustBusinessTerm]		  
	@userId BIGINT
	,@roleId BIGINT 
	,@entity NVARCHAR(100)
	,@langCode NVARCHAR(10)
	,@cbtOrgId BIGINT = NULL
	,@cbtCustomerId BIGINT  = NULL
	,@cbtItemNumber INT  = NULL
	,@cbtCode NVARCHAR(20)  = NULL
	,@cbtTitle NVARCHAR(50)  = NULL
	,@businessTermTypeId  INT  = NULL
	,@cbtActiveDate DATETIME2(7) = NULL 
	,@cbtValue DECIMAL(18,2)  = NULL
	,@cbtHiThreshold DECIMAL(18,2)  = NULL
	,@cbtLoThreshold DECIMAL(18,2)  = NULL
	,@cbtAttachment INT  = NULL
	,@statusId BIGINT = NULL 
	,@enteredBy NVARCHAR(50) = NULL 
	,@dateEntered DATETIME2(7)  = NULL
AS
BEGIN TRY                
 SET NOCOUNT ON; 
  DECLARE @updatedItemNumber INT      
 EXEC [dbo].[ResetItemNumber] @userId, 0, @cbtCustomerId, @entity, @cbtItemNumber, @statusId, NULL, NULL,  @updatedItemNumber OUTPUT  
   
 DECLARE @currentId BIGINT;
   INSERT INTO [dbo].[CUST020BusinessTerms]
           ([LangCode]
           ,[CbtOrgID]
           ,[CbtCustomerId]
           ,[CbtItemNumber]
           ,[CbtCode]
           ,[CbtTitle]
           ,[BusinessTermTypeId]
           ,[CbtActiveDate]
           ,[CbtValue]
           ,[CbtHiThreshold]
           ,[CbtLoThreshold]
           ,[CbtAttachment]
           ,[StatusId]
           ,[EnteredBy]
           ,[DateEntered]) 
     VALUES
		   (@langCode  
           ,@cbtOrgId  
           ,@cbtCustomerId  
           ,@updatedItemNumber 
           ,@cbtCode   
           ,@cbtTitle   
           ,@businessTermTypeId
           ,@cbtActiveDate   
           ,@cbtValue  
           ,@cbtHiThreshold 
           ,@cbtLoThreshold  
           ,@cbtAttachment  
           ,@statusId  
           ,@enteredBy 
           ,@dateEntered)  		
	SET @currentId = SCOPE_IDENTITY();
	 EXEC [dbo].[GetCustBusinessTerm] @userId, @roleId, @cbtOrgId, @langCode ,@currentId
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[InsCustContact]    Script Date: 11/26/2018 8:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               08/16/2018      
-- Description:               Ins a cust contact
-- Execution:                 EXEC [dbo].[InsCustContact]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================
ALTER PROCEDURE  [dbo].[InsCustContact]		  
	@userId BIGINT
	,@roleId BIGINT 
	,@entity NVARCHAR(100)
	,@custCustomerId  BIGINT = NULL
	,@custItemNumber INT = NULL 
	,@custContactCode NVARCHAR(20) = NULL 
	,@custContactTitle NVARCHAR(50) = NULL 
	,@custContactMSTRId BIGINT = NULL 
	,@statusId INT = NULL 
	,@enteredBy NVARCHAR(50) = NULL 
	,@dateEntered DATETIME2(7) = NULL
AS
BEGIN TRY                
 SET NOCOUNT ON;  
  DECLARE @updatedItemNumber INT      
  EXEC [dbo].[ResetItemNumber] @userId, 0, @custCustomerId, @entity, @custItemNumber, @statusId, NULL, NULL,  @updatedItemNumber OUTPUT  
  
 DECLARE @currentId BIGINT;
   INSERT INTO [dbo].[CUST010Contacts]
           ([CustCustomerID]
           ,[CustItemNumber]
           ,[CustContactCode]
           ,[CustContactTitle]
           ,[CustContactMSTRID]
           ,[StatusId]
           ,[EnteredBy]
           ,[DateEntered])
     VALUES
		 (@custCustomerID   
         ,@updatedItemNumber  
         ,@custContactCode 
         ,@custContactTitle  
         ,@custContactMSTRID  
         ,@statusId  
         ,@enteredBy  
         ,@dateEntered)	
		 SET @currentId = SCOPE_IDENTITY();
		
		IF(@statusId = 1)
		BEGIN
			EXEC [dbo].[UpdateColumnCount] @tableName = 'CUST000Master', @columnName = 'CustContacts',  @rowId = @custCustomerID, @countToChange = 1
		END

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
	   FROM [dbo].[CUST010Contacts] cust WHERE [Id]=@currentId
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[InsCustDcLocation]    Script Date: 11/26/2018 8:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               08/16/2018      
-- Description:               Ins a cust dc locations
-- Execution:                 EXEC [dbo].[InsCustDcLocation]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================  
ALTER PROCEDURE  [dbo].[InsCustDcLocation]		  
	@userId BIGINT
	,@roleId BIGINT 
	,@entity NVARCHAR(100)
	,@cdcCustomerId BIGINT 
	,@cdcItemNumber INT 
	,@cdcLocationCode NVARCHAR(20)
	,@cdcCustomerCode NVARCHAR(20)
	,@cdcLocationTitle NVARCHAR(50) 
	,@cdcContactMSTRId BIGINT 
	,@statusId INT 
	,@enteredBy NVARCHAR(50) 
	,@dateEntered DATETIME2(7) 		  
AS
BEGIN TRY                
 SET NOCOUNT ON;   
   DECLARE @updatedItemNumber INT      
  EXEC [dbo].[ResetItemNumber] @userId, 0, @cdcCustomerId, @entity, @cdcItemNumber, @statusId, NULL, NULL,  @updatedItemNumber OUTPUT  

 DECLARE @currentId BIGINT;
   INSERT INTO [dbo].[CUST040DCLocations]
           ([CdcCustomerId]
           ,[CdcItemNumber]
           ,[CdcLocationCode]
		   ,[CdcCustomerCode]
           ,[CdcLocationTitle]
           ,[CdcContactMSTRId]
           ,[StatusId]
           ,[EnteredBy]
           ,[DateEntered])
     VALUES
		   (@cdcCustomerId 
           ,@updatedItemNumber  
           ,@cdcLocationCode   
		   --,@cdcCustomerCode
		   ,ISNULL(@cdcCustomerCode,@cdcLocationCode)
           ,@cdcLocationTitle   
           ,@cdcContactMSTRId  
           ,@statusId 
           ,@enteredBy 
           ,@dateEntered) 	
		   SET @currentId = SCOPE_IDENTITY();
	EXEC [dbo].[GetCustDcLocation] @userId, @roleId, 1 ,@currentId
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[InsCustDcLocationContact]    Script Date: 11/26/2018 8:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               09/25/2018      
-- Description:               Ins a cust dc locations Contact
-- Execution:                 EXEC [dbo].[InsCustDcLocationContact]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================  
ALTER PROCEDURE  [dbo].[InsCustDcLocationContact]		  
	@userId BIGINT
	,@roleId BIGINT 
	,@entity NVARCHAR(100)
	,@clcCustDcLocationId BIGINT = NULL
	,@clcItemNumber INT = NULL
	,@clcContactCode NVARCHAR(20) = NULL
	,@clcContactTitle  NVARCHAR(50) = NULL
	,@clcContactMSTRID BIGINT = NULL
	,@clcAssignment NVARCHAR(20) = NULL
	,@clcGateway NVARCHAR(20) = NULL
	,@statusId INT  = NULL
	,@conTitleId INT = NULL
	,@conLastName NVARCHAR(25) = NULL
	,@conFirstName NVARCHAR(25) = NULL
	,@conMiddleName NVARCHAR(25) = NULL
	,@conJobTitle NVARCHAR(50) = NULL
	,@conCompany NVARCHAR(100) = NULL
	,@conTypeId INT = NULL
	,@conUDF01 INT = NULL
	,@conBusinessPhone NVARCHAR(25) = NULL
	,@conBusinessPhoneExt NVARCHAR(15) = NULL
	,@conMobilePhone NVARCHAR(25) = NULL
	,@conEmailAddress NVARCHAR(100) = NULL
	,@conEmailAddress2 NVARCHAR(100) = NULL
	,@conBusinessAddress1 NVARCHAR(255) = NULL
	,@conBusinessAddress2 NVARCHAR(150) = NULL
	,@conBusinessCity NVARCHAR(25) = NULL
	,@conBusinessStateId INT = NULL
	,@conBusinessZipPostal NVARCHAR(20) = NULL
	,@conBusinessCountryId INT = NULL
	,@enteredBy NVARCHAR(50) = NULL 
	,@dateEntered DATETIME2(7) = NULL  
AS
BEGIN TRY                
 SET NOCOUNT ON;   
   DECLARE @updatedItemNumber INT      
  EXEC [dbo].[ResetItemNumber] @userId, 0, @clcCustDcLocationId, @entity, @clcItemNumber, @statusId, NULL, NULL,  @updatedItemNumber OUTPUT  
 DECLARE @currentId BIGINT;

 -- First insert into ContactMaster table
 INSERT INTO [dbo].[CONTC000Master]
        ([ConCompany]
        ,[ConTitleId]
        ,[ConLastName]
        ,[ConFirstName]
        ,[ConMiddleName]
        ,[ConEmailAddress]
        ,[ConEmailAddress2]
        ,[ConJobTitle]
        ,[ConBusinessPhone]
        ,[ConBusinessPhoneExt]
        ,[ConMobilePhone]
        ,[ConBusinessAddress1]
        ,[ConBusinessAddress2]
        ,[ConBusinessCity]
        ,[ConBusinessStateId]
        ,[ConBusinessZipPostal]
        ,[ConBusinessCountryId]
		,[ConUDF01]
        ,[StatusId]
        ,[ConTypeId]
        ,[DateEntered]
        ,[EnteredBy] )
     VALUES
		(@conCompany 
		,@conTitleId
		,@conLastName
		,@conFirstName
		,@conMiddleName
		,@conEmailAddress
		,@conEmailAddress2
		,@conJobTitle
		,@conBusinessPhone
		,@conBusinessPhoneExt
		,@conMobilePhone
		,@conBusinessAddress1
		,@conBusinessAddress2
		,@conBusinessCity
		,@conBusinessStateId
		,@conBusinessZipPostal
		,@conBusinessCountryId
		,@conUDF01
		,@statusId
		,@conTypeId
		,@dateEntered
		,@enteredBy)
	
	SET @currentId = SCOPE_IDENTITY();

   -- Then Insert into CustDcLocationContact
   INSERT INTO [dbo].[CUST041DCLocationContacts]
           ([ClcCustDcLocationId]
		   	,[ClcItemNumber]
		   	,[ClcContactCode]
		   	,[ClcContactTitle]
		   	,[ClcContactMSTRID]
		   	,[ClcAssignment]
		   	,[ClcGateway]
		   	,[StatusId]
		   	,[EnteredBy]
		   	,[DateEntered])
     VALUES
		   (@clcCustDcLocationId 
           ,@updatedItemNumber  
           ,@clcContactCode   
		   ,@clcContactTitle
           ,@currentId   
           ,@clcAssignment  
           ,@clcGateway  
           ,@statusId 
           ,@enteredBy 
           ,@dateEntered) 	
	
	SET @currentId = SCOPE_IDENTITY();

	EXEC [dbo].[GetCustDcLocationContact] @userId, @roleId, 1 ,@currentId
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[InsCustDocReference]    Script Date: 11/26/2018 8:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               08/16/2018      
-- Description:               Ins a cust document reference
-- Execution:                 EXEC [dbo].[InsCustDocReference]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================  
ALTER PROCEDURE  [dbo].[InsCustDocReference]		  
	@userId BIGINT
	,@roleId BIGINT 
	,@entity NVARCHAR(100)
	,@cdrOrgId BIGINT = NULL
	,@cdrCustomerId BIGINT = NULL
	,@cdrItemNumber INT = NULL
	,@cdrCode NVARCHAR(20) = NULL
	,@cdrTitle NVARCHAR(50) = NULL
	,@docRefTypeId INT = NULL
	,@docCategoryTypeId INT = NULL
	,@cdrAttachment INT = NULL
	,@cdrDateStart DATETIME2(7) = NULL
	,@cdrDateEnd DATETIME2(7) = NULL
	,@cdrRenewal BIT = NULL
	,@statusId INT = NULL 
	,@enteredBy NVARCHAR(50) = NULL
	,@dateEntered DATETIME2(7) = NULL
AS
BEGIN TRY                
 SET NOCOUNT ON; 
  
  DECLARE @updatedItemNumber INT      
EXEC [dbo].[ResetItemNumber] @userId, 0, @cdrCustomerId, @entity, @cdrItemNumber, @statusId, NULL, NULL,  @updatedItemNumber OUTPUT
   
 DECLARE @currentId BIGINT;
   INSERT INTO [dbo].[CUST030DocumentReference]
           ([CdrOrgId]
           ,[CdrCustomerId]
           ,[CdrItemNumber]
           ,[CdrCode]
           ,[CdrTitle]
           ,[DocRefTypeId]
           ,[DocCategoryTypeId]
           ,[CdrAttachment]
           ,[CdrDateStart]
           ,[CdrDateEnd]
           ,[CdrRenewal]
           ,[StatusId]
           ,[EnteredBy]
           ,[DateEntered])
     VALUES
		   (@cdrOrgId  
           ,@cdrCustomerId  
           ,@updatedItemNumber 
           ,@cdrCode  
           ,@cdrTitle 
           ,@docRefTypeId  
           ,@docCategoryTypeId 
           ,@cdrAttachment  
           ,@cdrDateStart   
           ,@cdrDateEnd  
           ,@cdrRenewal  
		   ,@statusId
           ,@enteredBy   
           ,@dateEntered)	
		   SET @currentId = SCOPE_IDENTITY();
	EXEC [dbo].[GetCustDocReference] @userId, @roleId, @cdrOrgId ,@currentId  
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[InsCustFinacialCalender]    Script Date: 11/26/2018 8:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               08/16/2018      
-- Description:               Ins a cust finacial cal
-- Execution:                 EXEC [dbo].[InsCustFinacialCalender]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- ============================================= 
ALTER PROCEDURE  [dbo].[InsCustFinacialCalender]		  
	@userId BIGINT
	,@roleId BIGINT 
	,@entity NVARCHAR(100)
	,@orgId BIGINT  = NULL
	,@custId BIGINT  = NULL
	,@fclPeriod INT  = NULL
	,@fclPeriodCode NVARCHAR(20) = NULL 
	,@fclPeriodStart DATETIME2(7) = NULL 
	,@fclPeriodEnd DATETIME2(7)  = NULL
	,@fclPeriodTitle NVARCHAR(50) = NULL 
	,@fclAutoShortCode NVARCHAR(15) = NULL 
	,@fclWorkDays INT  = NULL
	,@finCalendarTypeId INT  = NULL
	,@statusId INT = NULL 
	,@dateEntered DATETIME2(7) = NULL 
	,@enteredBy NVARCHAR(50) = NULL 
AS
BEGIN TRY                
 SET NOCOUNT ON;  
  
  DECLARE @updatedItemNumber INT      
  EXEC [dbo].[ResetItemNumber] @userId, 0, @custId, @entity, @fclPeriod, @statusId, NULL, NULL,  @updatedItemNumber OUTPUT  
  
 DECLARE @currentId BIGINT;
   INSERT INTO [dbo].[CUST050Finacial_Cal]
           ([OrgId]
           ,[CustId]
           ,[FclPeriod]
           ,[FclPeriodCode]
           ,[FclPeriodStart]
           ,[FclPeriodEnd]
           ,[FclPeriodTitle]
           ,[FclAutoShortCode]
           ,[FclWorkDays]
           ,[FinCalendarTypeId]
		   ,[StatusId]
           ,[DateEntered]
           ,[EnteredBy])
     VALUES
		   (@orgId   
           ,@custId  
           ,@updatedItemNumber   
           ,@fclPeriodCode  
           ,@fclPeriodStart  
           ,@fclPeriodEnd  
           ,@fclPeriodTitle  
           ,@fclAutoShortCode  
           ,@fclWorkDays   
           ,@finCalendarTypeId  
		   ,@statusId
           ,@dateEntered 
           ,@enteredBy) 	
		   SET @currentId = SCOPE_IDENTITY();
	EXEC [dbo].[GetCustFinacialCalender] @userId, @roleId, @orgId ,@currentId  
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[InsCustomer]    Script Date: 11/26/2018 8:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               08/16/2018      
-- Description:               Ins a customer 
-- Execution:                 EXEC [dbo].[InsCustomer]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================

ALTER PROCEDURE  [dbo].[InsCustomer]
	(@userId BIGINT
	,@roleId BIGINT 
	,@entity NVARCHAR(100)
	,@custERPId NVARCHAR(10) = NULL
	,@custOrgId BIGINT = NULL
	,@custItemNumber INT = NULL
	,@custCode NVARCHAR(20) = NULL
	,@custTitle NVARCHAR(50) = NULL
	,@custWorkAddressId BIGINT = NULL
	,@custBusinessAddressId BIGINT = NULL
	,@custCorporateAddressId BIGINT = NULL
	,@custContacts INT = NULL
	,@custTypeId INT = NULL
	,@custTypeCode NVARCHAR(100) = NULL
	,@custWebPage NVARCHAR(100) = NULL
	,@statusId INT = NULL
	,@enteredBy NVARCHAR(50) = NULL
	,@dateEntered DATETIME2(7) = NULL)
AS
BEGIN TRY                
 SET NOCOUNT ON;   
 
  DECLARE @updatedItemNumber INT      
 EXEC [dbo].[ResetItemNumber] @userId, 0, @custOrgId, @entity, @custItemNumber, @statusId, NULL, NULL,  @updatedItemNumber OUTPUT

  IF NOT EXISTS(SELECT Id  FROM [dbo].[SYSTM000Ref_Options] WHERE SysOptionName = @custTypeCode) AND ISNULL(@custTypeCode, '') <> '' AND ISNULL(@custTypeId,0) = 0
  BEGIN
     DECLARE @highestTypeCodeSortOrder INT;
	 SELECT @highestTypeCodeSortOrder = MAX(SysSortOrder) FROM [dbo].[SYSTM000Ref_Options] WHERE SysLookupId=8; 
	 SET @highestTypeCodeSortOrder = ISNULL(@highestTypeCodeSortOrder, 0) + 1;
     INSERT INTO [dbo].[SYSTM000Ref_Options](SysLookupId, SysLookupCode, SysOptionName, SysSortOrder, StatusId, DateEntered, EnteredBy)
	 VALUES(8, 'CustomerType', @custTypeCode, @highestTypeCodeSortOrder , ISNULL(@statusId,1), @dateEntered, @enteredBy)
	 SET @custTypeId = SCOPE_IDENTITY();
  END
  ELSE IF ((ISNULL(@custTypeId,0) > 0) AND (ISNULL(@custTypeCode, '') <> ''))
  BEGIN
    UPDATE [dbo].[SYSTM000Ref_Options] SET SysOptionName =@custTypeCode WHERE Id =@custTypeId
  END
 
 IF(ISNULL(@custWorkAddressId, 0) = 0)
  SET @custWorkAddressId = NULL;
 IF(ISNULL(@custBusinessAddressId, 0) = 0)
  SET @custBusinessAddressId = NULL;
 IF(ISNULL(@custCorporateAddressId, 0) = 0)
  SET @custCorporateAddressId = NULL;

 DECLARE @currentId BIGINT;

 INSERT INTO [dbo].[CUST000Master]
           ([CustERPId]
           ,[CustOrgId]
           ,[CustItemNumber]
           ,[CustCode]
           ,[CustTitle]
           ,[CustWorkAddressId]
           ,[CustBusinessAddressId]
           ,[CustCorporateAddressId]
           ,[CustContacts]
           ,[CustTypeId]
           ,[CustWebPage]
           ,[StatusId]
           ,[EnteredBy]
           ,[DateEntered])
     VALUES
           (@custERPId
           ,@custOrgId 
           ,@updatedItemNumber -- @custItemNumber 
           ,@custCode  
           ,@custTitle 
           ,@custWorkAddressId  
           ,@custBusinessAddressId  
           ,@custCorporateAddressId  
           ,@custContacts  
           ,@custTypeId  
           ,@custWebPage  
           ,@statusId  
           ,@enteredBy  
           ,@dateEntered) 
		   SET @currentId = SCOPE_IDENTITY();
	EXEC [dbo].[GetCustomer] @userId, @roleId, @custOrgId ,@currentId 
END TRY              
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[InsDashboard]    Script Date: 11/26/2018 8:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               01/10/2018      
-- Description:               Ins Dashboard
-- Execution:                 EXEC [dbo].[InsDashboard]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- ============================================= 
ALTER PROCEDURE  [dbo].[InsDashboard]		  
	@userId BIGINT
	,@roleId BIGINT 
	,@entity NVARCHAR(100)
	,@orgId BIGINT = NULL
	,@mainModuleId INT = NULL
	,@dashboardName NVARCHAR(100) = NULL
	,@dashboardDesc NVARCHAR(255) = NULL
	,@isDefault BIT = NULL
	,@statusId INT = NULL
	,@dateEntered DATETIME2(7) = NULL
	,@enteredBy NVARCHAR(50) = NULL
AS
BEGIN TRY                
 SET NOCOUNT ON;   
 DECLARE @currentId BIGINT;
IF NOT EXISTS(SELECT DshMainModuleId FROM [dbo].[SYSTM000Ref_Dashboard] WHERE [DshMainModuleId] = @mainModuleId)
	BEGIN
		SET @isDefault =1  --first dashboard should be default
	END
   INSERT INTO [dbo].[SYSTM000Ref_Dashboard]
           ([OrganizationId]
           ,[DshMainModuleId]
           ,[DshName]
           ,[DshDescription]
           ,[DshIsDefault]
           ,[StatusId]
           ,[DateEntered]
           ,[EnteredBy])
     VALUES
		    (@orgId
           ,@mainModuleId
           ,@dashboardName
           ,@dashboardDesc
           ,@isDefault
           ,@statusId
           ,@dateEntered
           ,@enteredBy)  
		   SET @currentId = SCOPE_IDENTITY();
	EXEC [dbo].[GetDashboard] @userId, @roleId,  @orgId,  'EN',  @currentId 
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[InsDeliveryStatus]    Script Date: 11/26/2018 8:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               06/06/2018      
-- Description:               Ins a DeliveryStatus
-- Execution:                 EXEC [dbo].[InsDeliveryStatus]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================  
ALTER PROCEDURE  [dbo].[InsDeliveryStatus]		  
	(@userId BIGINT
	,@roleId BIGINT 
	,@entity NVARCHAR(100)
	,@orgId BIGINT
	,@delStatusCode NVARCHAR(25) = NULL
	,@delStatusTitle NVARCHAR(50) = NULL 
	,@severityId INT  = NULL
	,@itemNumber INT  = NULL
	,@statusId INT  = NULL
	,@dateEntered DATETIME2(7)  = NULL
	,@enteredBy NVARCHAR(50) = NULL)
AS
BEGIN TRY                
 SET NOCOUNT ON;
   DECLARE @updatedItemNumber INT      
  EXEC [dbo].[ResetItemNumber] @userId, 0, NULL, @entity, @itemNumber, @statusId, NULL, NULL,  @updatedItemNumber OUTPUT   
 
    
 DECLARE @currentId BIGINT;
   INSERT INTO [dbo].[SYSTM000Delivery_Status]
           ([OrganizationId]
		   ,[DeliveryStatusCode]
           ,[DeliveryStatusTitle]
           ,[SeverityId]
           ,[ItemNumber]
           ,[StatusId]
           ,[DateEntered]
           ,[EnteredBy])
     VALUES
		   (@orgId
		   ,@delStatusCode
           ,@delStatusTitle
           ,@severityId  
           ,@updatedItemNumber   
           ,@statusId   
           ,@dateEntered  
           ,@enteredBy) 		
		   SET @currentId = SCOPE_IDENTITY();


     -- Get DeliveryStatus Data
	 EXEC [dbo].[GetDeliveryStatus] @userId , @roleId, @orgId, @currentId
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[InsJob]    Script Date: 11/26/2018 8:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group        
   All Rights Reserved Worldwide */        
-- =============================================                
-- Author:                    Akhil Chauhan                 
-- Create date:               09/14/2018              
-- Description:               Ins a Job            
-- Execution:                 EXEC [dbo].[InsJob]        
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)          
-- Modified Desc:          
-- =============================================              
              
ALTER PROCEDURE  [dbo].[InsJob]              
	(@userId BIGINT              
	,@roleId BIGINT 
	,@entity NVARCHAR(100)              
	,@jobMITJobId bigint = NULL              
	,@programId bigint = NULL              
	,@jobSiteCode nvarchar(30) = NULL              
	,@jobConsigneeCode nvarchar(30) = NULL              
	,@jobCustomerSalesOrder nvarchar(30) = NULL    
	,@jobBOL nvarchar(30) = NULL           
	,@jobBOLMaster nvarchar(30) = NULL              
	,@jobBOLChild nvarchar(30) = NULL              
	,@jobCustomerPurchaseOrder nvarchar(30) = NULL              
	,@jobCarrierContract nvarchar(30) = NULL        
	,@jobManifestNo  varchar(30) = NULL      
	,@jobGatewayStatus  nvarchar(50) = NULL              
	,@statusId int = NULL              
	,@jobStatusedDate datetime2(7) = NULL              
	,@jobCompleted bit = NULL           
	,@jobType nvarchar(20) = NULL          
	,@shipmentType nvarchar(20) = NULL     
	,@jobDeliveryAnalystContactID bigint =Null         
	,@jobDeliveryResponsibleContactId bigint = NULL              
	,@jobDeliverySitePOC nvarchar(75) = NULL              
	,@jobDeliverySitePOCPhone nvarchar(50) = NULL              
	,@jobDeliverySitePOCEmail nvarchar(50) = NULL              
	,@jobDeliverySiteName nvarchar(50) = NULL              
	,@jobDeliveryStreetAddress nvarchar(100) = NULL              
	,@jobDeliveryStreetAddress2 nvarchar(100) = NULL              
	,@jobDeliveryCity nvarchar(50) = NULL              
	,@jobDeliveryState nvarchar(50) = NULL        
	,@jobDeliveryPostalCode nvarchar(50) = NULL              
	,@jobDeliveryCountry nvarchar(50) = NULL            
	,@jobDeliveryTimeZone nvarchar(15) = NULL              
	,@jobDeliveryDateTimePlanned datetime2(7) = NULL               
	,@jobDeliveryDateTimeActual datetime2(7) = NULL                
	,@jobDeliveryDateTimeBaseline datetime2(7) = NULL            
	,@jobDeliveryRecipientPhone nvarchar(50) = NULL              
	,@jobDeliveryRecipientEmail nvarchar(50) = NULL              
	,@jobLatitude nvarchar(50) = NULL              
	,@jobLongitude nvarchar(50) = NULL              
	,@jobOriginResponsibleContactId bigint = NULL              
	,@jobOriginSitePOC nvarchar(75) = NULL              
	,@jobOriginSitePOCPhone nvarchar(50) = NULL              
	,@jobOriginSitePOCEmail nvarchar(50) = NULL              
	,@jobOriginSiteName nvarchar(50) = NULL              
	,@jobOriginStreetAddress nvarchar(100) = NULL              
	,@jobOriginStreetAddress2 nvarchar(100) = NULL              
	,@jobOriginCity nvarchar(50) = NULL              
	,@jobOriginState nvarchar(50) = NULL              
	,@jobOriginPostalCode nvarchar(50) = NULL              
	,@jobOriginCountry nvarchar(50) = NULL        
	,@jobOriginTimeZone nvarchar(15) = NULL              
	,@jobOriginDateTimePlanned datetime2(7) = NULL            
	,@jobOriginDateTimeActual datetime2(7) = NULL             
	,@jobOriginDateTimeBaseline datetime2(7) = NULL             
	,@jobProcessingFlags nvarchar(20) = NULL               
	,@jobDeliverySitePOC2 nvarchar(75) = NULL              
	,@jobDeliverySitePOCPhone2 nvarchar(50) = NULL              
	,@jobDeliverySitePOCEmail2 nvarchar(50) = NULL              
	,@jobOriginSitePOC2 nvarchar(75) = NULL              
	,@jobOriginSitePOCPhone2 nvarchar(50) = NULL              
	,@jobOriginSitePOCEmail2 nvarchar(50) = NULL              
	,@jobSellerCode NVARCHAR(20) =NULL              
	,@jobSellerSitePOC NVARCHAR(75) =NULL    
	,@jobSellerSitePOCPhone NVARCHAR(50) =NULL              
	,@jobSellerSitePOCEmail NVARCHAR(50) =NULL              
	,@jobSellerSitePOC2 NVARCHAR(75) =NULL              
	,@jobSellerSitePOCPhone2 NVARCHAR(50) =NULL              
	,@jobSellerSitePOCEmail2 NVARCHAR(50) =NULL              
	,@jobSellerSiteName NVARCHAR(50) =NULL              
	,@jobSellerStreetAddress NVARCHAR(100) =NULL              
	,@jobSellerStreetAddress2 NVARCHAR(100) =NULL              
	,@jobSellerCity NVARCHAR(50) =NULL              
	,@jobSellerState nvarchar(50) = NULL          
	,@jobSellerPostalCode NVARCHAR(50) =NULL              
	,@jobSellerCountry nvarchar(50) = NULL            
	,@jobUser01 NVARCHAR(20) =NULL              
	,@jobUser02 NVARCHAR(20) =NULL              
	,@jobUser03 NVARCHAR(20) =NULL              
	,@jobUser04 NVARCHAR(20) =NULL              
	,@jobUser05 NVARCHAR(20) =NULL              
	,@jobStatusFlags NVARCHAR(20) =NULL              
	,@jobScannerFlags NVARCHAR(20) =NULL
	,@plantIDCode NVARCHAR(30) =NULL
	,@carrierID NVARCHAR(30) =NULL
	,@jobDriverId BIGINT =NULL
	,@windowDelStartTime DATETIME2(7) =NULL
	,@windowDelEndTime DATETIME2(7) =NULL
	,@windowPckStartTime DATETIME2(7) =NULL
	,@windowPckEndTime DATETIME2(7) =NULL
	,@jobRouteId INT =NULL
	,@jobStop NVARCHAR(20) =NULL
	,@jobSignText NVARCHAR(75) =NULL
	,@jobSignLatitude NVARCHAR(50) =NULL
	,@jobSignLongitude NVARCHAR(50) =NULL
	,@enteredBy nvarchar(50) = NULL              
	,@dateEntered datetime2(7) = NULL)              
AS              
BEGIN TRY                              
 SET NOCOUNT ON;                 
 DECLARE @currentId BIGINT;      
 --Adding this to handle job gatweay item number issue
 DECLARE @updatedItemNumber INT;
 
 INSERT INTO [dbo].[JOBDL000Master]              
           ([JobMITJobID]              
   ,[ProgramID]              
   ,[JobSiteCode]              
   ,[JobConsigneeCode]              
   ,[JobCustomerSalesOrder]        
   ,[JobBOL]          
   ,[JobBOLMaster]              
   ,[JobBOLChild]              
   ,[JobCustomerPurchaseOrder]              
   ,[JobCarrierContract]          
   ,[JobManifestNo]          
   ,[JobGatewayStatus]              
   ,[StatusId]              
   ,[JobStatusedDate]              
   ,[JobCompleted]            
   ,[JobType]          
   ,[ShipmentType]     
   ,[JobDeliveryAnalystContactID]             
   ,[JobDeliveryResponsibleContactID]              
   ,[JobDeliverySitePOC]              
   ,[JobDeliverySitePOCPhone]              
   ,[JobDeliverySitePOCEmail]              
   ,[JobDeliverySiteName]              
   ,[JobDeliveryStreetAddress]              
   ,[JobDeliveryStreetAddress2]              
   ,[JobDeliveryCity]              
   ,[JobDeliveryState]              
   ,[JobDeliveryPostalCode]              
   ,[JobDeliveryCountry]              
   ,[JobDeliveryTimeZone]              
   ,[JobDeliveryDateTimePlanned]              
               
   ,[JobDeliveryDateTimeActual]              
               
   ,[JobDeliveryDateTimeBaseline]              
               
   ,[JobDeliveryRecipientPhone]              
   ,[JobDeliveryRecipientEmail]              
   ,[JobLatitude]              
   ,[JobLongitude]              
   ,[JobOriginResponsibleContactID]              
   ,[JobOriginSitePOC]              
   ,[JobOriginSitePOCPhone]              
   ,[JobOriginSitePOCEmail]              
   ,[JobOriginSiteName]              
   ,[JobOriginStreetAddress]              
   ,[JobOriginStreetAddress2]              
   ,[JobOriginCity]              
   ,[JobOriginState]              
   ,[JobOriginPostalCode]              
   ,[JobOriginCountry]              
   ,[JobOriginTimeZone]              
   ,[JobOriginDateTimePlanned]              
                
   ,[JobOriginDateTimeActual]              
               
   ,[JobOriginDateTimeBaseline]              
               
   ,[JobProcessingFlags]              
   ,[JobDeliverySitePOC2]                     
   ,[JobDeliverySitePOCPhone2]                
   ,[JobDeliverySitePOCEmail2]                
   ,[JobOriginSitePOC2]                       
   ,[JobOriginSitePOCPhone2]                  
   ,[JobOriginSitePOCEmail2]                  
   ,[JobSellerCode]              
   ,[JobSellerSitePOC]              
   ,[JobSellerSitePOCPhone]              
   ,[JobSellerSitePOCEmail]              
   ,[JobSellerSitePOC2]              
   ,[JobSellerSitePOCPhone2]              
   ,[JobSellerSitePOCEmail2]              
   ,[JobSellerSiteName]              
   ,[JobSellerStreetAddress]          
   ,[JobSellerStreetAddress2]              
   ,[JobSellerCity]              
   ,[JobSellerState]              
   ,[JobSellerPostalCode]              
   ,[JobSellerCountry]              
   ,[JobUser01]                
   ,[JobUser02]                
   ,[JobUser03]                
   ,[JobUser04]                
   ,[JobUser05]                
   ,[JobStatusFlags]               
   ,[JobScannerFlags] 
   ,[PlantIDCode]      
   ,[CarrierID]      
   ,[JobDriverId]      
   ,[WindowDelStartTime]      
   ,[WindowDelEndTime]      
   ,[WindowPckStartTime]       
   ,[WindowPckEndTime]      
   ,[JobRouteId]      
   ,[JobStop]       
   ,[JobSignText]      
   ,[JobSignLatitude]     
   ,[JobSignLongitude]               
   ,[EnteredBy]              
   ,[DateEntered])              
     VALUES              
           (@jobMITJobId              
   ,@programId              
   ,@jobSiteCode              
   ,@jobConsigneeCode              
   ,@jobCustomerSalesOrder  
   ,@jobBOL              
   ,@jobBOLMaster              
   ,@jobBOLChild              
   ,@jobCustomerPurchaseOrder              
   ,@jobCarrierContract         
   ,@jobManifestNo         
   ,@jobgatewayStatus
   ,@statusId              
   ,@jobStatusedDate              
   ,@jobCompleted          
   ,@jobType        
   ,@shipmentType        
   ,@jobDeliveryAnalystContactID    
   ,@jobDeliveryResponsibleContactId              
   ,@jobDeliverySitePOC              
   ,@jobDeliverySitePOCPhone              
   ,@jobDeliverySitePOCEmail              
   ,@jobDeliverySiteName              
   ,@jobDeliveryStreetAddress              
   ,@jobDeliveryStreetAddress2              
   ,@jobDeliveryCity              
   ,@jobDeliveryState              
   ,@jobDeliveryPostalCode              
   ,@jobDeliveryCountry              
   ,@jobDeliveryTimeZone              
   ,@jobDeliveryDateTimePlanned              
               
   ,CASE WHEN ISNULL(@jobCompleted,0) =1 AND @jobDeliveryDateTimeActual IS NULL THEN  GETUTCDATE()  ELSE  @jobDeliveryDateTimeActual END           
              
   ,@jobDeliveryDateTimeBaseline              
               
   ,@jobDeliveryRecipientPhone              
   ,@jobDeliveryRecipientEmail              
   ,@jobLatitude              
   ,@jobLongitude              
   ,@jobOriginResponsibleContactID              
   ,@jobOriginSitePOC              
   ,@jobOriginSitePOCPhone              
   ,@jobOriginSitePOCEmail              
   ,@jobOriginSiteName              
   ,@jobOriginStreetAddress              
   ,@jobOriginStreetAddress2              
   ,@jobOriginCity              
   ,@jobOriginState              
   ,@jobOriginPostalCode              
   ,@jobOriginCountry              
   ,@jobOriginTimeZone              
   ,@jobOriginDateTimePlanned              
            
   ,CASE WHEN ISNULL(@jobCompleted,0) =1 AND @jobOriginDateTimeActual  IS NULL THEN  GETUTCDATE()  ELSE  @jobOriginDateTimeActual  END               
             
   ,@jobOriginDateTimeBaseline              
              
   ,@jobProcessingFlags              
   ,@jobDeliverySitePOC2              
   ,@jobDeliverySitePOCPhone2              
   ,@jobDeliverySitePOCEmail2              
   ,@jobOriginSitePOC2              
   ,@jobOriginSitePOCPhone2              
   ,@jobOriginSitePOCEmail2              
   ,@jobSellerCode              
   ,@jobSellerSitePOC              
   ,@jobSellerSitePOCPhone              
   ,@jobSellerSitePOCEmail              
   ,@jobSellerSitePOC2              
   ,@jobSellerSitePOCPhone2              
   ,@jobSellerSitePOCEmail2              
   ,@jobSellerSiteName              
   ,@jobSellerStreetAddress              
   ,@jobSellerStreetAddress2              
   ,@jobSellerCity              
   ,@jobSellerState              
   ,@jobSellerPostalCode              
   ,@jobSellerCountry              
   ,@jobUser01              
   ,@jobUser02              
   ,@jobUser03              
   ,@jobUser04              
   ,@jobUser05              
   ,@jobStatusFlags              
   ,@jobScannerFlags 
   ,@plantIDCode
   ,@carrierID
   ,@jobDriverId
   ,@windowDelStartTime
   ,@windowDelEndTime
   ,@windowPckStartTime
   ,@windowPckEndTime
   ,@jobRouteId
   ,@jobStop
   ,@jobSignText
   ,@jobSignLatitude
   ,@jobSignLongitude
   ,@enteredBy              
   ,@dateEntered)              
              
   SET @currentId = SCOPE_IDENTITY();              
     

   -- INSERT DEFAULT  PROGRAM GATEWAYS INTO Job GATEWAYS              
 --   INSERT INTO [dbo].[JOBDL020Gateways]              
 --   (JobID              
 --   ,ProgramID        
 --   ,GwyGatewaySortOrder              
 --   ,GwyGatewayCode              
 --   ,GwyGatewayTitle              
 --   ,GwyGatewayDuration              
 --   ,GwyGatewayDescription              
 --   ,GwyComment              
 --   ,GatewayUnitId              
 --   ,GwyGatewayDefault              
 --   ,GatewayTypeId              
 --   ,GwyDateRefTypeId         
 --,Scanner         
 --,GwyShipApptmtReasonCode        
 --,GwyShipStatusReasonCode          
 --,GwyGatewayResponsible      
 --,GwyGatewayAnalyst      
 --,GwyOrderType      
 --,GwyShipmentType            
 --   ,StatusId              
 --   ,DateEntered              
 --   ,EnteredBy              
 --   )              
 --SELECT                 
 -- @currentId              
 --   ,prgm.[PgdProgramID]
	-- ,ROW_NUMBER() OVER(ORDER BY prgm.[PgdGatewaySortOrder])        
 --   ,prgm.[PgdGatewayCode]                      
 --   ,prgm.[PgdGatewayTitle]               
 --   ,prgm.[PgdGatewayDuration]            
 --   ,prgm.[PgdGatewayDescription]                  
 --   ,prgm.[PgdGatewayComment]           
 --   ,prgm.[UnitTypeId]                      
 --   ,prgm.[PgdGatewayDefault]                   
 --   ,prgm.[GatewayTypeId]                       
 --   ,prgm.[GatewayDateRefTypeId]           
 -- ,prgm.[Scanner]         
 -- ,prgm.PgdShipApptmtReasonCode        
 -- ,prgm.PgdShipStatusReasonCode           
 -- ,prgm.PgdGatewayResponsible      
 -- ,prgm.PgdGatewayAnalyst        
 -- ,prgm.PgdOrderType      
 -- ,prgm.PgdShipmentType          
 -- ,194 --prgm.[StatusId]     given 194 as gateway status lookup's 'Active' status id            
 --,@dateEntered              
 --,@enteredBy              
 -- FROM [dbo].[PRGRM010Ref_GatewayDefaults] prgm              
 -- INNER JOIN  [dbo].[fnGetUserStatuses](@userId) fgus ON prgm.StatusId = fgus.StatusId              
 -- WHERE PgdGatewayDefault = 1 AND prgm.PgdProgramID = @programId AND prgm.StatusId=1 
 -- ORDER BY prgm.[PgdGatewaySortOrder];              
 EXEC  [dbo].[CopyJobGatewayFromProgram] @currentId,@programId,@dateEntered,@enteredBy, @userId       
     
      
           
              
   -- INSERT DEFAULT  PROGRAM ATTRIBUTES INTO Job ATTRIBUTES              
   INSERT INTO JOBDL030Attributes              
   (JobID,              
   AjbLineOrder,              
   AjbAttributeCode,              
   AjbAttributeTitle,              
   AjbAttributeDescription,              
   AjbAttributeComments,              
   AjbAttributeQty,              
   AjbUnitTypeId,              
   AjbDefault,              
   StatusId,              
  DateEntered,              
   EnteredBy)              
   SELECT @currentId, ROW_NUMBER() OVER(ORDER BY prgm.AttItemNumber) ,prgm.AttCode,prgm.AttTitle,prgm.AttDescription,prgm.AttComments, prgm.AttQuantity,prgm.UnitTypeId,prgm.AttDefault,prgm.StatusId,@dateEntered,@enteredBy               
  FROM [dbo].[PRGRM020Ref_AttributesDefault] prgm               
  INNER JOIN  [dbo].[fnGetUserStatuses](@userId) fgus ON prgm.StatusId = fgus.StatusId              
  WHERE AttDefault = 1 AND  prgm.ProgramID = @programId        
  ORDER BY prgm.AttItemNumber  ;              
         
  
  
  -- INSERT INTO CustomerContacts vendorContact and programContacts WHERE JobGateway Analyst Is Selected In RefRole    
  DECLARE @orgId BIGINT,@custId BIGINT    
  SELECT  @orgId = pgm.PrgOrgID,@custId =  pgm.PrgCustID FROM [JOBDL000Master] job    
  INNER JOIN PRGRM000Master pgm ON job.ProgramID = pgm.Id     
  WHERE job.Id = @currentId;    
 
  EXEC CopyActRoleOnJobCreate @userId,@roleId,@orgId,@custId,@programId,@dateEntered,@enteredBy  ;
        
           
  EXEC [dbo].[GetJob] @userId,@roleId,0,@currentId,@programId    ;    
              
 --SELECT * FROM [dbo].[JOBDL000Master] WHERE Id = @currentId;                 
END TRY                            
BEGIN CATCH                              
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                              
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                              
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                              
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                              
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[InsJobAttribute]    Script Date: 11/26/2018 8:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               09/14/2018      
-- Description:               Ins a Job Attribute
-- Execution:                 EXEC [dbo].[InsJobAttribute]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- ============================================= 

ALTER PROCEDURE  [dbo].[InsJobAttribute]
	(@userId BIGINT
	,@roleId BIGINT 
	,@entity NVARCHAR(100)
	,@jobId bigint
	,@ajbLineOrder int
	,@ajbAttributeCode nvarchar(20)
	,@ajbAttributeTitle nvarchar(50)
	,@ajbAttributeQty decimal(18, 2)
	,@ajbUnitTypeId int
	,@ajbDefault bit
	,@statusId int = NULL
	,@dateEntered datetime2(7)
	,@enteredBy nvarchar(50))
AS
BEGIN TRY                
 SET NOCOUNT ON;  
  
  DECLARE @updatedItemNumber INT      
   EXEC [dbo].[ResetItemNumber] @userId, 0, @jobId, @entity, @ajbLineOrder, @statusId, NULL, NULL,  @updatedItemNumber OUTPUT  
  
 DECLARE @currentId BIGINT;
 INSERT INTO [dbo].[JOBDL030Attributes]
           ([JobID]
			,[AjbLineOrder]
			,[AjbAttributeCode]
			,[AjbAttributeTitle]
			,[AjbAttributeQty]
			,[AjbUnitTypeId]
			,[AjbDefault]
			,[StatusId]
			,[DateEntered]
			,[EnteredBy])
     VALUES
           (@jobId
			,@updatedItemNumber
		   	,@ajbAttributeCode
		   	,@ajbAttributeTitle
		   	,@ajbAttributeQty
		   	,@ajbUnitTypeId
		   	,@ajbDefault
			,ISNULL(@statusId,1)
		   	,@dateEntered
		   	,@enteredBy)
			SET @currentId = SCOPE_IDENTITY();
	SELECT * FROM [dbo].[JOBDL030Attributes] WHERE Id = @currentId;   
END TRY              
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[InsJobCargo]    Script Date: 11/26/2018 8:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               09/14/2018      
-- Description:               Ins a Job Cargo
-- Execution:                 EXEC [dbo].[InsJobCargo]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================


ALTER PROCEDURE  [dbo].[InsJobCargo]
	(@userId BIGINT
	,@roleId BIGINT 
	,@entity NVARCHAR(100)
	,@jobId bigint
	,@cgoLineItem int
	,@cgoPartNumCode nvarchar(30)
	,@cgoTitle nvarchar(50)
	,@cgoSerialNumber nvarchar(255)
	,@cgoPackagingType nvarchar(20)
	,@cgoMasterCartonLabel nvarchar(30)
	,@cgoWeight decimal(18, 2)  
	,@cgoWeightUnits NVARCHAR(20)= NULL  
	,@cgoLength decimal(18, 2)  
	,@cgoWidth decimal(18, 2)  
	,@cgoHeight decimal(18, 2)  
	,@cgoVolumeUnits NVARCHAR(20)= NULL
	,@cgoCubes decimal(18, 2)  = NULL
	,@cgoQtyExpected decimal(18, 2)= NULL
	,@cgoQtyOnHand decimal(18, 2)= NULL
	,@cgoQtyDamaged decimal(18, 2)= NULL
	,@cgoQtyOnHold decimal(18, 2)= NULL
	,@cgoQtyShortOver decimal(18, 2)= NULL
	,@cgoQtyUnits nvarchar(20)= NULL
	,@cgoReasonCodeOSD nvarchar(20)  
	,@cgoReasonCodeHold nvarchar(20)  
	,@cgoSeverityCode int
	,@cgoLatitude NVARCHAR(50) = NULL
	,@cgoLongitude NVARCHAR(50) = NULL
	,@statusId int = NULL
	,@cgoProcessingFlags nvarchar(20)
	,@enteredBy nvarchar(50)
	,@dateEntered datetime2(7))
AS
BEGIN TRY                
 SET NOCOUNT ON; 
  DECLARE @updatedItemNumber INT      
   EXEC [dbo].[ResetItemNumber] @userId, 0, @jobId, @entity, @cgoLineItem, @statusId, NULL, NULL,  @updatedItemNumber OUTPUT  

 DECLARE @currentId BIGINT;
 INSERT INTO [dbo].[JOBDL010Cargo]
           (  [JobID]
			  ,[CgoLineItem]
			  ,[CgoPartNumCode]
			  ,[CgoTitle]
			  ,[CgoSerialNumber]
			  ,[CgoPackagingType]
			  ,[CgoMasterCartonLabel]
			  ,[CgoWeight]
			  ,[CgoWeightUnits]
			  ,[CgoLength]
			  ,[CgoWidth]
			  ,[CgoHeight]
			  ,[CgoVolumeUnits]
			  ,[CgoCubes]
			  ,[CgoQtyExpected]
			  ,[CgoQtyOnHand]
			  ,[CgoQtyDamaged]
			  ,[CgoQtyOnHold]
			  ,[CgoQtyShortOver]
			  ,[CgoQtyUnits]
			  ,[CgoReasonCodeOSD]
			  ,[CgoReasonCodeHold]
			  ,[CgoSeverityCode]
			  ,[CgoLatitude]
			  ,[CgoLongitude]
			  ,[StatusId]
			 -- ,[CgoProcessingFlags]
			,[EnteredBy]
			,[DateEntered])
     VALUES
           (@jobId 
			,@cgoLineItem 
			,@cgoPartNumCode
			,@cgoTitle 
			,@cgoSerialNumber 
			,@cgoPackagingType 
			,@cgoMasterCartonLabel
			,@cgoWeight 
		    ,@cgoWeightUnits   
		    ,@cgoLength  
		    ,@cgoWidth 
		    ,@cgoHeight  
		    ,@cgoVolumeUnits
            ,@cgoCubes 
		    ,@cgoQtyExpected 
			,@cgoQtyOnHand 
			,@cgoQtyDamaged
			,@cgoQtyOnHold 
			,@cgoQtyShortOver
			,@cgoQtyUnits 
			,@cgoReasonCodeOSD 
            ,@cgoReasonCodeHold
			,@cgoSeverityCode 
			,@cgoLatitude
			,@cgoLongitude
			,@statusId 
			--,@cgoProcessingFlags 
		   	,@enteredBy
		   	,@dateEntered)
			SET @currentId = SCOPE_IDENTITY();
	SELECT * FROM [dbo].[JOBDL010Cargo] WHERE Id = @currentId;   
END TRY              
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[InsJobDocReference]    Script Date: 11/26/2018 8:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               09/14/2018      
-- Description:               Ins a Job Doc Reference   
-- Execution:                 EXEC [dbo].[InsJobDocReference]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================    
    
ALTER PROCEDURE  [dbo].[InsJobDocReference]    
	(@userId BIGINT    
	,@roleId BIGINT 
	,@entity NVARCHAR(100)    
	,@jobId bigint    
	,@jdrItemNumber int    
	,@jdrCode nvarchar(20)    
	,@jdrTitle nvarchar(50)    
	,@docTypeId int    
	,@jdrAttachment int    
	,@jdrDateStart datetime2(7)    
	,@jdrDateEnd datetime2(7)    
	,@jdrRenewal bit    
	,@statusId int = null    
	,@enteredBy nvarchar(50)    
	,@dateEntered datetime2(7))    
AS    
BEGIN TRY                    
 SET NOCOUNT ON;       
  DECLARE @updatedItemNumber INT          
  DECLARE @where NVARCHAR(MAX) =  ' AND DocTypeId ='  +  CAST(@docTypeId AS VARCHAR)   
  EXEC [dbo].[ResetItemNumber] @userId, 0, @jobId, @entity, @jdrItemNumber, @statusId, NULL, @where,  @updatedItemNumber OUTPUT  ;    
    
    
 DECLARE @currentId BIGINT;    
 INSERT INTO [dbo].[JOBDL040DocumentReference]    
           ([JobID]  
   ,[JdrItemNumber]    
   ,[JdrCode]    
   ,[JdrTitle]    
   ,[DocTypeId]    
   ,[JdrAttachment]    
   ,[JdrDateStart]    
   ,[JdrDateEnd]    
   ,[JdrRenewal]    
   ,[StatusId]    
   ,[EnteredBy]    
   ,[DateEntered])    
     VALUES    
           (@jobId    
           ,@updatedItemNumber    
      ,@jdrCode    
      ,@jdrTitle    
      ,@docTypeId    
      ,@jdrAttachment    
      ,@jdrDateStart    
      ,@jdrDateEnd    
      ,@jdrRenewal    
   ,@statusId    
      ,@enteredBy    
      ,@dateEntered)    
   SET @currentId = SCOPE_IDENTITY();    
 SELECT * FROM [dbo].[JOBDL040DocumentReference] WHERE Id = @currentId;       
END TRY                  
BEGIN CATCH                    
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                    
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                    
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                    
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                    
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[InsJobGateway]    Script Date: 11/26/2018 8:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group  
   All Rights Reserved Worldwide */  
-- =============================================          
-- Author:                    Akhil Chauhan           
-- Create date:               09/14/2018        
-- Description:               Ins a Job Gateway    
-- Execution:                 EXEC [dbo].[InsJobGateway]  
-- Modified on:               04/27/2018
-- Modified Desc:             Added scanner field
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)
-- =============================================        
        
ALTER PROCEDURE  [dbo].[InsJobGateway]        
	(@userId BIGINT        
	,@roleId BIGINT 
	,@entity NVARCHAR(100)        
	,@jobId bigint        
	,@programId bigint        
	,@gwyGatewaySortOrder int        
	,@gwyGatewayCode nvarchar(20)        
	,@gwyGatewayTitle nvarchar(50)        
	,@gwyGatewayDuration decimal(18, 2)        
	,@gwyGatewayDefault bit        
	,@gatewayTypeId int        
	,@gwyGatewayAnalyst bigint        
	,@gwyGatewayResponsible bigint        
	,@gwyGatewayPCD datetime2(7)        
	,@gwyGatewayECD datetime2(7)        
	,@gwyGatewayACD datetime2(7)        
	,@gwyCompleted bit        
	,@gatewayUnitId int        
	,@gwyAttachments int        
	,@gwyProcessingFlags nvarchar(20)        
	,@gwyDateRefTypeId int    
	,@scanner bit 
	,@gwyShipApptmtReasonCode nvarchar(20)     
	,@gwyShipStatusReasonCode nvarchar(20)    
	,@gwyOrderType nvarchar(20)     
	,@gwyShipmentType nvarchar(20)      
	,@statusId int        
	--,@gwyUpdatedStatusOn  datetime2(7)          
	,@gwyUpdatedById int        
	,@gwyClosedOn datetime2(7)        
	,@gwyClosedBy NVARCHAR(50) =NULL  
	,@gwyPerson  NVARCHAR(50) = NULL
	,@gwyPhone   NVARCHAR(25) = NULL 
	,@gwyEmail   NVARCHAR(25) = NULL
	,@gwyTitle   NVARCHAR(50) = NULL
	,@gwyDDPCurrent DATETIME2(7) = NULL        
	,@gwyDDPNew DATETIME2(7) = NULL        
	,@gwyUprWindow DECIMAL(18, 2) = NULL 
	,@gwyLwrWindow DECIMAL(18, 2) = NULL  
	,@gwyUprDate DATETIME2(7) = NULL        
	,@gwyLwrDate DATETIME2(7) = NULL     
	,@dateEntered datetime2(7)        
	,@enteredBy nvarchar(50))        
AS        
BEGIN TRY                        
 SET NOCOUNT ON;         
   DECLARE @updatedItemNumber INT              
   DECLARE @where NVARCHAR(MAX) = ' AND GatewayTypeId ='  +  CAST(@gatewayTypeId AS VARCHAR)                    
  EXEC [dbo].[ResetItemNumber] @userId, 0, @jobId, @entity, @gwyGatewaySortOrder, @statusId, NULL, @where,  @updatedItemNumber OUTPUT

  IF(@programId = 0)    
  BEGIN    
     SELECT @programId = ProgramID FROM JOBDL000Master WHERE Id = @jobId;    
  END    
         
           
 DECLARE @currentId BIGINT;        
 INSERT INTO [dbo].[JOBDL020Gateways]        
           ([JobID]        
   ,[ProgramID]        
   ,[GwyGatewaySortOrder]        
   ,[GwyGatewayCode]        
   ,[GwyGatewayTitle]        
   ,[GwyGatewayDuration]        
   ,[GwyGatewayDefault]        
   ,[GatewayTypeId]        
   ,[GwyGatewayAnalyst]        
   ,[GwyGatewayResponsible]        
   ,[GwyGatewayPCD]        
   ,[GwyGatewayECD]        
   ,[GwyGatewayACD]        
   ,[GwyCompleted]        
   ,[GatewayUnitId]        
   ,[GwyAttachments]        
   ,[GwyProcessingFlags]        
   ,[GwyDateRefTypeId]  
   ,[Scanner]  
   ,[GwyShipApptmtReasonCode]    
   ,[GwyShipStatusReasonCode] 
   ,[GwyOrderType]
   ,[GwyShipmentType]      
   ,[StatusId]       
   --,[GwyUpdatedStatusOn]         
   ,[GwyUpdatedById]        
   ,[GwyClosedOn]        
   ,[GwyClosedBy]  
   ,[GwyPerson]
   ,[GwyPhone]
   ,[GwyEmail]
   ,[GwyTitle]
   ,[GwyDDPCurrent]
   ,[GwyDDPNew]
   ,[GwyUprWindow]
   ,[GwyLwrWindow]
   ,[GwyUprDate]
   ,[GwyLwrDate]
   ,[DateEntered]        
   ,[EnteredBy])        
     VALUES        
           (@jobId        
      ,@programId        
      ,@updatedItemNumber        
      ,@gwyGatewayCode        
      ,@gwyGatewayTitle        
      ,@gwyGatewayDuration        
      ,@gwyGatewayDefault        
      ,@gatewayTypeId        
      ,@gwyGatewayAnalyst        
      ,@gwyGatewayResponsible        
      ,@gwyGatewayPCD        
      ,@gwyGatewayECD        
      ,ISNULL(@gwyGatewayACD, CASE WHEN @gwyCompleted  = 1 THEN GETUTCDATE() END)
      ,@gwyCompleted 
	  ,@gatewayUnitId        
      ,@gwyAttachments        
      ,@gwyProcessingFlags        
      ,@gwyDateRefTypeId   
	  ,@scanner  
	  ,@gwyShipApptmtReasonCode     
     ,@gwyShipStatusReasonCode
	 ,@gwyOrderType
	 ,@gwyShipmentType
      ,@statusId        
   --,@gwyUpdatedStatusOn      
      ,@gwyUpdatedById        
      ,@gwyClosedOn        
      ,@gwyClosedBy   
	  ,@gwyPerson
	  ,@gwyPhone
	  ,@gwyEmail
	  ,@gwyTitle
	  ,@gwyDDPCurrent
	  ,@gwyDDPNew
	  ,@gwyUprWindow
	  ,@gwyLwrWindow
	  ,@gwyUprDate
	  ,@gwyLwrDate
      ,@dateEntered        
      ,@enteredBy)        
   SET @currentId = SCOPE_IDENTITY();    
   
   UPDATE [JOBDL020Gateways] SET GwyCompleted =1 
   WHERE GwyCompleted =0 
      AND GwyGatewayACD IS NOT NULL 
	  AND  Id = @currentId;
       
 SELECT * FROM [dbo].[JOBDL020Gateways] WHERE Id = @currentId;           
END TRY                      
BEGIN CATCH                        
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                        
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                        
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                        
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                        
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[InsJobRefCostSheet]    Script Date: 11/26/2018 8:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               09/14/2018      
-- Description:               Ins a Job Ref Cost Sheet
-- Execution:                 EXEC [dbo].[InsJobRefCostSheet]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================

ALTER PROCEDURE  [dbo].[InsJobRefCostSheet]
	(@userId BIGINT
	,@roleId BIGINT 
	,@entity NVARCHAR(100)
	,@jobId bigint
	,@cstLineItem nvarchar(20)
	,@cstChargeId int
	,@cstChargeCode nvarchar(25)
	,@cstTitle nvarchar(50)
	,@cstSurchargeOrder bigint
	,@cstSurchargePercent float
	,@chargeTypeId int
	,@cstNumberUsed int
	,@cstDuration decimal(18, 2)
	,@cstQuantity decimal(18, 2)
	,@costUnitId int
	,@cstCostRate decimal(18, 2)
	,@cstCost decimal(18, 2)
	,@cstMarkupPercent float
	,@cstRevenueRate decimal(18, 2)
	,@cstRevDuration decimal(18, 2)
	,@cstRevQuantity decimal(18, 2)
	,@cstRevBillable decimal(18, 2)
	,@statusId int
	,@enteredBy nvarchar(50)
	,@dateEntered datetime2(7))
AS
BEGIN TRY                
 SET NOCOUNT ON;
    DECLARE @updatedItemNumber INT      
   EXEC [dbo].[ResetItemNumber] @userId, 0, @jobId, @entity, @cstLineItem, @statusId, NULL, NULL,  @updatedItemNumber OUTPUT 
 
    
 DECLARE @currentId BIGINT;
 INSERT INTO [dbo].[JOBDL060Ref_CostSheetJob]
           ([JobID]
			,[CstLineItem]
			,[CstChargeID]
			,[CstChargeCode]
			,[CstTitle]
			,[CstSurchargeOrder]
			,[CstSurchargePercent]
			,[ChargeTypeId]
			,[CstNumberUsed]
			,[CstDuration]
			,[CstQuantity]
			,[CostUnitId]
			,[CstCostRate]
			,[CstCost]
			,[CstMarkupPercent]
			,[CstRevenueRate]
			,[CstRevDuration]
			,[CstRevQuantity]
			,[CstRevBillable]
			,[StatusId]
			,[EnteredBy]
			,[DateEntered])
     VALUES
           (@jobID
		   	,@updatedItemNumber
		   	,@cstChargeID
		   	,@cstChargeCode
		   	,@cstTitle
		   	,@cstSurchargeOrder
		   	,@cstSurchargePercent
		   	,@chargeTypeId
		   	,@cstNumberUsed
		   	,@cstDuration
		   	,@cstQuantity
		   	,@costUnitId
		   	,@cstCostRate
		   	,@cstCost
		   	,@cstMarkupPercent
		   	,@cstRevenueRate
		   	,@cstRevDuration
		   	,@cstRevQuantity
		   	,@cstRevBillable
		   	,@statusId
		   	,@enteredBy
		   	,@dateEntered)
			SET @currentId = SCOPE_IDENTITY();
	SELECT * FROM [dbo].[JOBDL060Ref_CostSheetJob] WHERE Id = @currentId; 
END TRY              
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[InsJobRefStatus]    Script Date: 11/26/2018 8:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               09/14/2018      
-- Description:               Ins a Job Ref Status
-- Execution:                 EXEC [dbo].[InsJobRefStatus]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================

ALTER PROCEDURE  [dbo].[InsJobRefStatus]
	(@userId BIGINT
	,@roleId BIGINT 
	,@entity NVARCHAR(100)
	,@jobId bigint
	,@jbsOutlineCode nvarchar(20)
	,@jbsStatusCode nvarchar(25)
	,@jbsTitle nvarchar(50)
	,@statusId int
	,@severityId int
	,@enteredBy nvarchar(50)
	,@dateEntered datetime2(7))
AS
BEGIN TRY                
 SET NOCOUNT ON;   
 DECLARE @currentId BIGINT;
 INSERT INTO [dbo].[JOBDL050Ref_Status]
           ([JobID]
			,[JbsOutlineCode]
			,[JbsStatusCode]
			,[JbsTitle]
			,[StatusId]
			,[SeverityId]
			,[EnteredBy]
			,[DateEntered])
     VALUES
           (@jobId
		   	,@jbsOutlineCode
		   	,@jbsStatusCode
		   	,@jbsTitle
		   	,@statusId
		   	,@severityId
		   	,@enteredBy
		   	,@dateEntered)
			SET @currentId = SCOPE_IDENTITY();
	SELECT * FROM [dbo].[JOBDL050Ref_Status] WHERE Id = @currentId; 
END TRY              
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[InsMenuAccessLevel]    Script Date: 11/26/2018 8:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               08/16/2018      
-- Description:               Ins a Sys menu access level
-- Execution:                 EXEC [dbo].[InsMenuAccessLevel]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- ============================================= 
ALTER PROCEDURE  [dbo].[InsMenuAccessLevel]		  
	@userId BIGINT
	,@roleId BIGINT 
	,@entity NVARCHAR(100)
	,@langCode NVARCHAR(10) = NULL
	,@sysRefId INT = NULL
	,@malOrder INT  = NULL
	,@malTitle NVARCHAR(50) = NULL 
	,@dateEntered DATETIME2(7)  = NULL
	,@enteredBy NVARCHAR(50)  = NULL
AS
BEGIN TRY                
 SET NOCOUNT ON;   
 DECLARE @currentId BIGINT;
   INSERT INTO [dbo].[SYSTM010MenuAccessLevel]
           ([LangCode]
           ,[SysRefId]
           ,[MalOrder]
           ,[MalTitle]
           ,[DateEntered]
           ,[EnteredBy] )  
      VALUES
		   (@langCode  
           ,@sysRefId  
           ,@malOrder  
           ,@malTitle  
           ,@dateEntered  
           ,@enteredBy  ) 
		   SET @currentId = SCOPE_IDENTITY();
	SELECT * FROM [dbo].[SYSTM010MenuAccessLevel] WHERE Id = @currentId;   
END TRY    
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH



/***** Object:  StoredProcedure [dbo].[UpdSysMenuAccessLevel]    Script Date: 8/16/2017 1:30:20 PM *****/
SET ANSI_NULLS ON
GO
/****** Object:  StoredProcedure [dbo].[InsMenuDriver]    Script Date: 11/26/2018 8:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               09/12/2018      
-- Description:               Ins menu driver
-- Execution:                 EXEC [dbo].[InsMenuDriver]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================    
ALTER PROCEDURE  [dbo].[InsMenuDriver]      
	@userId BIGINT  
	,@roleId BIGINT 
	,@entity NVARCHAR(100)  
	,@langCode NVARCHAR(10)  
	,@mnuModuleId BIGINT = NULL  
	,@mnuBreakDownStructure NVARCHAR(20) = NULL  
	,@mnuTableName NVARCHAR(100) = NULL  
	,@mnuTitle NVARCHAR(50) = NULL  
	,@mnuTabOver NVARCHAR(25) = NULL  
	,@mnuRibbon BIT = NULL  
	,@mnuMenuItem BIT = NULL  
	,@mnuExecuteProgram NVARCHAR(255) = NULL  
	,@mnuClassificationId BIGINT = NULL  
	,@mnuProgramTypeId BIGINT = NULL  
	,@mnuOptionLevelId BIGINT = NULL  
	,@mnuAccessLevelId BIGINT = NULL  
	,@statusId int = null  
	,@dateEntered DATETIME2(7) = NULL  
	,@enteredBy NVARCHAR(50) = NULL  
	,@moduleName NVARCHAR(50) = null  
AS  
BEGIN TRY                  
 SET NOCOUNT ON;     
 DECLARE @currentId BIGINT;  

   IF(ISNULL(@mnuModuleId,0) = 0 AND  LEN(@moduleName) > 0 AND NOT EXISTS(SELECT Id FROM  [SYSTM000Ref_Options] WHERE SysLookupId= 22 AND SysOptionName=@moduleName))
   BEGIN         
		DECLARE @order INT
		SELECT @order = MAX(SysSortOrder) FROM [SYSTM000Ref_Options] WHERE SysLookupId= 22;
			INSERT INTO [dbo].[SYSTM000Ref_Options]([SysLookupId],[SysLookupCode],[SysOptionName],[SysSortOrder],[SysDefault],[IsSysAdmin],[StatusId],[DateEntered],[EnteredBy])
				 VALUES(22,'MainModule',@moduleName,ISNULL(@order,0) +1,0,0,1,@dateEntered,@enteredBy)
           SET @mnuModuleId = SCOPE_IDENTITY();
   END


   INSERT INTO [dbo].[SYSTM000MenuDriver]  
           ([LangCode]  
   ,[MnuModuleId]  
   ,[MnuBreakDownStructure]  
   ,[MnuTableName]  
   ,[MnuTitle]  
   ,[MnuTabOver]  
   ,[MnuRibbon]  
   ,[MnuMenuItem]  
   ,[MnuExecuteProgram]  
   ,[MnuClassificationId]  
   ,[MnuProgramTypeId]  
   ,[MnuOptionLevelId]  
   ,[MnuAccessLevelId]  
   ,[StatusId]  
   ,[DateEntered]  
   ,[EnteredBy])  
     VALUES  
      (@langCode  
     ,@mnuModuleId  
     ,@mnuBreakDownStructure  
     ,@mnuTableName  
     ,@mnuTitle  
     ,@mnuTabOver  
     ,@mnuRibbon  
     ,@mnuMenuItem  
     ,@mnuExecuteProgram  
     ,@mnuClassificationId  
     ,@mnuProgramTypeId  
     ,@mnuOptionLevelId  
     ,@mnuAccessLevelId  
     ,@statusId  
     ,@dateEntered  
     ,@enteredBy)    
     SET @currentId = SCOPE_IDENTITY();  
 SELECT * FROM [dbo].[SYSTM000MenuDriver] WHERE Id = @currentId;   
END TRY                  
BEGIN CATCH                  
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                  
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                  
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                  
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                  
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[InsMenuOptionLevel]    Script Date: 11/26/2018 8:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               08/16/2018      
-- Description:               Ins a Sys menu Option level
-- Execution:                 EXEC [dbo].[InsMenuOptionLevel]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================  
ALTER PROCEDURE  [dbo].[InsMenuOptionLevel]		  
	@userId BIGINT
	,@roleId BIGINT 
	,@entity NVARCHAR(100)
	,@langCode NVARCHAR(10)
	,@sysRefId INT
	,@molOrder INT = NULL
	,@molMenuLevelTitle NVARCHAR(50) = NULL 
	,@molMenuAccessDefault INT = NULL 
	,@molMenuAccessOnly BIT = NULL 
	,@dateEntered DATETIME2(7) = NULL 
	,@enteredBy NVARCHAR(50) = NULL  
AS
BEGIN TRY                
 SET NOCOUNT ON;   
 DECLARE @currentId BIGINT;
   INSERT INTO [dbo].[SYSTM010MenuOptionLevel]
           ([LangCode]
           ,[SysRefId]
           ,[MolOrder]
           ,[MolMenuLevelTitle]
           ,[MolMenuAccessDefault]
           ,[MolMenuAccessOnly]
           ,[DateEntered]
           ,[EnteredBy] )  
      VALUES
		   (@langCode  
           ,@sysRefId   
           ,@molOrder  
           ,@molMenuLevelTitle 
           ,@molMenuAccessDefault   
           ,@molMenuAccessOnly  
           ,@dateEntered  
           ,@enteredBy  )    
		   SET @currentId = SCOPE_IDENTITY();
	SELECT * FROM [dbo].[SYSTM010MenuOptionLevel] WHERE Id = @currentId;
END TRY    
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH



/***** Object:  StoredProcedure [dbo].[UpdSysMenuOptionLevel]    Script Date: 8/16/2017 1:30:20 PM *****/
SET ANSI_NULLS ON
GO
/****** Object:  StoredProcedure [dbo].[InsMessageType]    Script Date: 11/26/2018 8:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               09/22/2018      
-- Description:               Ins a message type 
-- Execution:                 EXEC [dbo].[InsMessageType]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================

ALTER PROCEDURE  [dbo].[InsMessageType]
	(@userId BIGINT
	,@roleId BIGINT 
	,@entity NVARCHAR(100)
	,@langCode NVARCHAR(10)
	,@sysRefId int
	,@sysMsgtypeTitle nvarchar(50)
	,@statusId int = null
	,@dateEntered datetime2(7)
	,@enteredBy nvarchar(50))
AS
BEGIN TRY                
 SET NOCOUNT ON;   
 DECLARE @currentId BIGINT;
 INSERT INTO [dbo].[SYSMS010Ref_MessageTypes]
           ([LangCode]
			,[SysRefId]
			,[SysMsgtypeTitle]
			,[StatusId]
			,[DateEntered]
			,[EnteredBy])
     VALUES
           (@langCode
		   	,@sysRefId
		   	,@sysMsgtypeTitle
			,@statusId
		   	,@dateEntered
		   	,@enteredBy) 
			SET @currentId = SCOPE_IDENTITY();
	SELECT * FROM [dbo].[SYSMS010Ref_MessageTypes] WHERE Id = @currentId;
END TRY              
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[InsOrgActRole]    Script Date: 11/26/2018 8:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
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
	,@orgLogical BIT = NULL
	,@prgLogical BIT = NULL
	,@prjLogical BIT = NULL
	,@phsLogical BIT = NULL
	,@jobLogical BIT = NULL
	,@prxContactDefault BIT = NULL
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
           ,[OrgLogical]
           ,[PrgLogical]
           ,[PrjLogical]
           ,[PhsLogical]
           ,[JobLogical]
           ,[PrxContactDefault]
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
           ,@orgLogical 
           ,@prgLogical   
           ,@prjLogical    
           ,@phsLogical   
           ,@jobLogical   
           ,@prxContactDefault   
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
/****** Object:  StoredProcedure [dbo].[InsOrgActSecurityByRole]    Script Date: 11/26/2018 8:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 /* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               08/16/2017      
-- Description:               Ins a org act security by role   
-- Execution:                 EXEC [dbo].[InsOrgActSecurityByRole]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================  

ALTER PROCEDURE  [dbo].[InsOrgActSecurityByRole]  
	(@userId BIGINT  
	,@roleId BIGINT 
	,@entity NVARCHAR(100)  
	,@orgId bigint 
	,@secLineOrder int  = NULL  
	,@mainModuleId int  
	,@menuOptionLevelId int  
	,@menuAccessLevelId int  
	,@statusId int = NULL  
	,@actRoleId BIGINT
	,@dateEntered datetime2(7)  
	,@enteredBy nvarchar(50)  
)  
AS  
BEGIN TRY                  
 SET NOCOUNT ON;     
 DECLARE @updatedItemNumber INT , @parentContactId BIGINT = NULL
 
 SELECT @parentContactId=OrgRoleContactID FROM [dbo].[ORGAN020Act_Roles] WHERE Id = @actRoleId
 
 IF(ISNULL(@parentContactId, 0) <> 0)
   BEGIN
		DECLARE @currentId BIGINT;  
		SELECT TOP 1 @secLineOrder = [SecLineOrder] + 1 FROM [dbo].[ORGAN021Act_SecurityByRole]  WHERE [OrgId] = @orgId AND [OrgActRoleId] = @actRoleId ORDER BY SecLineOrder DESC
		SET @secLineOrder = ISNULL(@secLineOrder, 1)
	DECLARE @where NVARCHAR(MAX) = ' AND [OrgActRoleId]=' +  CAST(@actRoleId AS VARCHAR)     
	EXEC [dbo].[ResetItemNumber] @userId, 0, @orgId, @entity, @secLineOrder, @statusId, NULL, @where,  @updatedItemNumber OUTPUT 
		INSERT INTO [dbo].[ORGAN021Act_SecurityByRole]  
		          ([OrgId]  
		  ,[OrgActRoleId]
		  ,[ContactId]  
		  ,[SecLineOrder]  
		  ,[SecMainModuleId]  
		  ,[SecMenuOptionLevelId]  
		  ,[SecMenuAccessLevelId]  
		  ,[StatusId]  
		  ,[DateEntered]  
		  ,[EnteredBy])  
		    VALUES  
		     (@orgId  
		     ,@actRoleId
			 ,@parentContactId
		     ,@updatedItemNumber   
		     ,@mainModuleId  
		     ,@menuOptionLevelId  
		     ,@menuAccessLevelId  
			  ,@statusId  
		     ,@dateEntered  
		     ,@enteredBy)   
		  SET @currentId = SCOPE_IDENTITY(); 
		  
		  EXECUTE  GetOrgActSecurityByRole @userId,@roleId,@orgId,@currentId;
	
	END

END TRY                
BEGIN CATCH                  
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                  
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                  
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                  
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                  
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[InsOrgActSubSecurityByRole]    Script Date: 11/26/2018 8:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 /* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               08/16/2017      
-- Description:               Ins a org act subsecurity by role 
-- Execution:                 EXEC [dbo].[InsOrgActSubSecurityByRole]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- ============================================= 

ALTER PROCEDURE  [dbo].[InsOrgActSubSecurityByRole]
	(@userId BIGINT
	,@roleId BIGINT 
	,@entity NVARCHAR(100)
	,@secByRoleId bigint
	,@refTableName nvarchar(100)
	,@menuOptionLevelId int
	,@menuAccessLevelId int
	,@statusId int
	,@dateEntered datetime2(7)
	,@enteredBy nvarchar(50))
AS
BEGIN TRY                
 SET NOCOUNT ON;   
 DECLARE @currentId BIGINT;
 INSERT INTO [dbo].[ORGAN022Act_SubSecurityByRole]
            ([OrgSecurityByRoleId]
           ,[RefTableName]
           ,[SubsMenuOptionLevelId]
           ,[SubsMenuAccessLevelId]
           ,[StatusId]
           ,[DateEntered]
           ,[EnteredBy])
     VALUES
           (@secByRoleId
		   	,@refTableName
		   	,@menuOptionLevelId
		   	,@menuAccessLevelId
		   	,@statusId
		   	,@dateEntered
		   	,@enteredBy
		   ) 
		   SET @currentId = SCOPE_IDENTITY();
	SELECT * FROM [dbo].[ORGAN022Act_SubSecurityByRole] WHERE Id = @currentId;
END TRY              
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[InsOrganization]    Script Date: 11/26/2018 8:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               08/16/2018      
-- Description:               Ins a organization
-- Execution:                 EXEC [dbo].[InsOrganization]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================  
ALTER PROCEDURE  [dbo].[InsOrganization]		  
	(@userId BIGINT
	,@roleId BIGINT 
	,@entity NVARCHAR(100)
	,@orgCode NVARCHAR(25) = NULL
	,@orgTitle NVARCHAR(50) = NULL 
	,@orgGroupId INT  = NULL
	,@orgSortOrder INT  = NULL
	,@statusId INT  = NULL
	,@dateEntered DATETIME2(7)  = NULL
	,@enteredBy NVARCHAR(50) = NULL
	,@orgContactId BIGINT  = NULL)
AS
BEGIN TRY                
 SET NOCOUNT ON;
   DECLARE @updatedItemNumber INT      
  DECLARE @where NVARCHAR(MAX) = null   
	EXEC [dbo].[ResetItemNumber] @userId, 0, NULL, @entity, @orgSortOrder, @statusId, NULL, NULL,  @updatedItemNumber OUTPUT 
 
    
 DECLARE @currentId BIGINT;
   INSERT INTO [dbo].[ORGAN000Master]
           ([OrgCode]
           ,[OrgTitle]
           ,[OrgGroupId]
           ,[OrgSortOrder]
           ,[StatusId]
           ,[DateEntered]
           ,[EnteredBy]
           ,[OrgContactId])
     VALUES
		   (@orgCode
           ,@orgTitle
           ,@orgGroupId  
           ,@updatedItemNumber   
           ,@statusId   
           ,@dateEntered  
           ,@enteredBy    
           ,@orgContactId) 		
		   SET @currentId = SCOPE_IDENTITY();

	-- Below to insert Ref Roles rows in Act Roles
	 EXEC [dbo].[CopyRefRoles] @currentId, @enteredBy   

	 -- INSERT Dashboard
	INSERT INTO [dbo].[SYSTM000Ref_Dashboard]
		  ([OrganizationId]
		  ,[DshMainModuleId]
		  ,[DshName]
		  ,[DshTemplate]
		  ,[DshDescription]
		  ,[DshIsDefault]
		  ,[StatusId]
		  ,[DateEntered]
		  ,[EnteredBy]
		  ,[DateChanged]
		  ,[ChangedBy])
		SELECT  @currentId
		  ,[DshMainModuleId]
		  ,[DshName]
		  ,[DshTemplate]
		  ,[DshDescription]
		  ,[DshIsDefault]
		  ,[StatusId]
		  ,[DateEntered]
		  ,[EnteredBy]
		  ,[DateChanged]
		  ,[ChangedBy]
		  FROM [dbo].[SYSTM000Ref_Dashboard] 
		  WHERE OrganizationId = 0 AND DshMainModuleId=0

     -- Get Organization Data
	 EXEC [dbo].[GetOrganization] @userId , @orgCode, @currentId, @currentId
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[InsOrgCredential]    Script Date: 11/26/2018 8:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               09/12/2018      
-- Description:               Ins a org credential
-- Execution:                 EXEC [dbo].[InsOrgCredential]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- ============================================= 
ALTER PROCEDURE  [dbo].[InsOrgCredential]		  
	@userId BIGINT
	,@roleId BIGINT 
	,@entity NVARCHAR(100)
	,@orgId BIGINT = NULL
	,@creItemNumber INT = NULL 
	,@creCode NVARCHAR(20) = NULL 
	,@creTitle NVARCHAR(50) = NULL 
	,@creExpDate DATETIME2(7) = NULL 
	,@statusId INT = NULL
	,@dateEntered DATETIME2(7) = NULL
	,@enteredBy NVARCHAR(50) = NULL
AS
BEGIN TRY                
 SET NOCOUNT ON; 
  DECLARE @updatedItemNumber INT      
 EXEC [dbo].[ResetItemNumber] @userId, 0, @orgId, @entity, @creItemNumber, @statusId, NULL, NULL,  @updatedItemNumber OUTPUT 
   
 DECLARE @currentId BIGINT;
   INSERT INTO [dbo].[ORGAN030Credentials]
           ([OrgId]
           ,[CreItemNumber] 
		   ,[CreCode]
		   ,[CreTitle]
		   ,[StatusId]
		   ,[CreExpDate]
           ,[DateEntered]
           ,[EnteredBy])
     VALUES
		   (@orgId  
           ,@updatedItemNumber 
           ,@creCode  
           ,@creTitle  
		   ,@statusId
           ,@creExpDate  
           ,@dateEntered 
           ,@enteredBy ) 	
		   SET @currentId = SCOPE_IDENTITY();
 EXEC [dbo].[GetOrgCredential] @userId, @roleId, @orgId, @currentId
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[InsOrgFinacialCalender]    Script Date: 11/26/2018 8:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               08/16/2018      
-- Description:               Ins a org finacial cal
-- Execution:                 EXEC [dbo].[InsOrgFinacialCalender]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- ============================================= 
ALTER PROCEDURE  [dbo].[InsOrgFinacialCalender]		  
	@userId BIGINT
	,@roleId BIGINT 
	,@entity NVARCHAR(100)
	,@orgId BIGINT = NULL
	,@fclPeriod INT = NULL 
	,@fclPeriodCode NVARCHAR(20)  = NULL
	,@fclPeriodStart DATETIME2(7)  = NULL
	,@fclPeriodEnd DATETIME2(7)  = NULL
	,@fclPeriodTitle NVARCHAR(50)  = NULL
	,@fclAutoShortCode NVARCHAR(15)  = NULL
	,@fclWorkDays INT  = NULL
	,@finCalendarTypeId INT  = NULL
	,@statusId INT = NULL
	,@dateEntered DATETIME2(7)  = NULL
	,@enteredBy NVARCHAR(50)  = NULL
AS
BEGIN TRY                
 SET NOCOUNT ON; 
   DECLARE @updatedItemNumber INT      
 EXEC [dbo].[ResetItemNumber] @userId, 0, @orgId, @entity, @fclPeriod, @statusId, NULL, NULL,  @updatedItemNumber OUTPUT 
 
   
 DECLARE @currentId BIGINT;
   INSERT INTO [dbo].[ORGAN020Financial_Cal]
           ([OrgId]
           ,[FclPeriod]
           ,[FclPeriodCode]
           ,[FclPeriodStart]
           ,[FclPeriodEnd]
           ,[FclPeriodTitle]
           ,[FclAutoShortCode]
           ,[FclWorkDays]
           ,[FinCalendarTypeId]
		   ,[StatusId]
           ,[DateEntered]
           ,[EnteredBy])
     VALUES
		    (@orgId   
            ,@updatedItemNumber   
            ,@fclPeriodCode  
            ,@fclPeriodStart  
            ,@fclPeriodEnd  
            ,@fclPeriodTitle  
            ,@fclAutoShortCode   
            ,@fclWorkDays  
            ,@finCalendarTypeId
            ,@statusId  
            ,@dateEntered  
            ,@enteredBy)  
			SET @currentId = SCOPE_IDENTITY();
	 EXEC [dbo].[GetOrgFinacialCalender] @userId, @roleId, @orgId, @currentId
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH



/***** Object:  StoredProcedure [dbo].[UpdOrgFinacialCal]    Script Date: 8/16/2017 1:30:20 PM *****/
SET ANSI_NULLS ON
GO
/****** Object:  StoredProcedure [dbo].[InsOrgMarketSupport]    Script Date: 11/26/2018 8:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               08/16/2018      
-- Description:               Ins a Org MRKT Org Support
-- Execution:                 EXEC [dbo].[InsOrgMarketSupport]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================  
ALTER PROCEDURE  [dbo].[InsOrgMarketSupport]		  
	@userId BIGINT
	,@roleId BIGINT 
	,@entity NVARCHAR(100)
	,@orgId BIGINT = NULL
	,@mrkOrder INT = NULL
	,@mrkCode NVARCHAR(20) = NULL 
	,@mrkTitle NVARCHAR(50) = NULL
	,@dateEntered DATETIME2(7) = NULL
	,@enteredBy NVARCHAR(50) = NULL
AS
BEGIN TRY                
 SET NOCOUNT ON; 
  DECLARE @updatedItemNumber INT      
 EXEC [dbo].[ResetItemNumber] @userId, 0, @orgId, @entity, @mrkOrder, NULL, NULL, NULL,  @updatedItemNumber OUTPUT  
 
   
 DECLARE @currentId BIGINT;
   INSERT INTO [dbo].[ORGAN002MRKT_OrgSupport]
           ([OrgId]
           ,[MrkOrder]
           ,[MrkCode]
           ,[MrkTitle]
           ,[DateEntered]
           ,[EnteredBy])
     VALUES
		   (@orgId 
           ,@updatedItemNumber 
           ,@mrkCode 
           ,@mrkTitle 
           ,@dateEntered 
           ,@enteredBy) 	
		   SET @currentId = SCOPE_IDENTITY();
 EXEC [dbo].[GetOrgMarketSupport] @userId, @roleId, @orgId, @currentId
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH



/***** Object:  StoredProcedure [dbo].[UpdOrgMrktOrgSupport]    Script Date: 8/16/2017 1:30:20 PM *****/
SET ANSI_NULLS ON
GO
/****** Object:  StoredProcedure [dbo].[InsOrgPocContact]    Script Date: 11/26/2018 8:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               08/16/2018      
-- Description:               Ins a org POC contact
-- Execution:                 EXEC [dbo].[InsOrgPocContact]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- ============================================= 
ALTER PROCEDURE  [dbo].[InsOrgPocContact]		  
	@userId BIGINT
	,@roleId BIGINT 
	,@entity NVARCHAR(100)
	,@orgId BIGINT = NULL
	,@contactId BIGINT = NULL
	,@pocCode NVARCHAR(20) = NULL
	,@pocTitle NVARCHAR(50) = NULL
	,@pocTypeId INT = NULL
	,@pocDefault BIT = NULL
	,@statusId INT = NULL
	,@dateEntered DATETIME2(7) = NULL
	,@enteredBy NVARCHAR(50) = NULL
	,@pocSortOrder INT = NULL
AS
BEGIN TRY                
 SET NOCOUNT ON;   
  DECLARE @updatedItemNumber INT      
EXEC [dbo].[ResetItemNumber] @userId, 0, @orgId, @entity, @pocSortOrder, @statusId, NULL, NULL,  @updatedItemNumber OUTPUT


 DECLARE @currentId BIGINT;
  INSERT INTO [dbo].[ORGAN001POC_Contacts]
           ([OrgId]
           ,[ContactID]
           ,[PocCode]
           ,[PocTitle]
           ,[PocTypeId]
           ,[PocDefault]
		   ,[StatusId]
           ,[DateEntered]
           ,[EnteredBy]
           ,[PocSortOrder])
     VALUES
		  ( @orgId  
           ,@contactId  
           ,@pocCode 
           ,@pocTitle 
           ,@pocTypeId 
           ,@pocDefault 
		   ,@statusId
           ,@dateEntered  
           ,@enteredBy 
           ,@updatedItemNumber)	
		   SET @currentId = SCOPE_IDENTITY();
	 EXEC [dbo].[GetOrgPocContact] @userId, @roleId, @orgId, @currentId
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[InsOrgRefRole]    Script Date: 11/26/2018 8:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
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
	,@orgLogical BIT = NULL 
	,@prgLogical BIT  = NULL
	,@prjLogical BIT  = NULL
	,@jobLogical BIT  = NULL
	,@prxContactDefault BIT  = NULL
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
              ,[OrgLogical]
              ,[PrgLogical]
              ,[PrjLogical]
              ,[JobLogical]
              ,[PrxContactDefault]
              ,[PrxJobDefaultAnalyst]
			  ,[PrxJobDefaultResponsible]
              ,[PrxJobGWDefaultAnalyst]
              ,[PrxJobGWDefaultResponsible]
              ,[DateEntered]
              ,[EnteredBy]
              ,[PhsLogical]
			  ,[StatusId])
     VALUES
		   (NULL  
           ,@updatedItemNumber   
           ,@orgRoleCode  
           ,@orgRoleDefault  
           ,@orgRoleTitle  
           ,@orgRoleContactId   
           ,@roleTypeId 
           ,@orgLogical  
           ,@prgLogical 
           ,@prjLogical  
           ,@jobLogical   
           ,@prxContactDefault   
           ,@prxJobDefaultAnalyst   
		   ,@prxJobDefaultResponsible
           ,@prxJobGWDefaultAnalyst   
           ,@PrxJobGWDefaultResponsible    
           ,@dateEntered  
           ,@enteredBy   
           ,@phsLogical
		   ,@statusId)	
		   SET @currentId = SCOPE_IDENTITY();

		 --  IF NOT EXISTS (SELECT TOP 1 1 FROM [dbo].[ORGAN020Act_Roles] WHERE OrgRefRoleId =@currentId )
		 --  BEGIN
			--  INSERT INTO [dbo].[ORGAN020Act_Roles](    
			--   [OrgID]    
			--  ,[OrgRoleSortOrder]    
			--  ,[OrgRefRoleId]    
			--  ,[OrgRoleDefault]    
			--  ,[OrgRoleTitle]    
			--  ,[OrgRoleContactID]    
			--  ,[RoleTypeId]    
			--  ,[StatusId]    
			--  ,[OrgRoleDescription]    
			--  ,[OrgComments]    
			--  ,[OrgLogical]    
			--  ,[PrgLogical]    
			--  ,[PrjLogical]    
			--  ,[PhsLogical]    
			--  ,[JobLogical]    
			--  ,[PrxContactDefault]    
			--  ,[PrxJobDefaultAnalyst]    
			--  ,[PrxJobGWDefaultAnalyst]    
			--  ,[PrxJobGWDefaultResponsible]    
			--  ,[EnteredBy])  
   
			--	SELECT  @orgId    
			--	,((SELECT COUNT(Id) FROM ORGAN020Act_Roles where [OrgID]= @orgId) +1)
			--	,refRole.[Id]    
			--	,refRole.[OrgRoleDefault]    
			--	,refRole.[OrgRoleTitle]    
			--	,refRole.[OrgRoleContactID]    
			--	,refRole.[RoleTypeId]    
			--	,refRole.[StatusId]    
			--	,refRole.[OrgRoleDescription]    
			--	,refRole.[OrgComments]    
			--	,refRole.[OrgLogical]    
			--	,refRole.[PrgLogical]    
			--	,refRole.[PrjLogical]    
			--	,refRole.[PhsLogical]    
			--	,refRole.[JobLogical]    
			--	,refRole.[PrxContactDefault]    
			--	,refRole.[PrxJobDefaultAnalyst]    
			--	,refRole.[PrxJobGWDefaultAnalyst]    
			--	,refRole.[PrxJobGWDefaultResponsible]    
			--	,@enteredBy   
			--   FROM [dbo].[ORGAN010Ref_Roles] (NOLOCK) refRole  
			--   WHERE refRole.[Id] = @currentId;
		 --END
	 EXEC [dbo].[GetOrgRefRole] @userId, @roleId, @orgId, @currentId

END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[InsOrUpdOrgActRole]    Script Date: 11/26/2018 8:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Janardana Behara       
-- Create date:               12/17/2018      
-- Description:               Insert or update act role after SystemAccount add/update
-- Execution:                 EXEC [dbo].[CopyActRoleContactSecurity]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================   
ALTER PROCEDURE  [dbo].[InsOrUpdOrgActRole] 
	 @userId BIGINT,  
	 @roleId BIGINT,  
	 @actRoleId BIGINT = NULL,   
	 @sysOrgId BIGINT = NULL,
	 @sysUserContactId BIGINT = NULL,
	 @statusId INT = NULL,      
	 @dateEntered DATETIME2(7) = NULL,  
	 @enteredBy NVARCHAR(50)    
AS    
BEGIN TRY                    
 SET NOCOUNT ON;  

 IF(ISNULL(@actRoleId,0) <> 0 AND ISNULL(@sysOrgId,0) <> 0 AND ISNULL(@sysUserContactId,0) <> 0)
 BEGIN
	DECLARE @currentRefRoleId BIGINT = (SELECT OrgRefRoleId FROM [dbo].[ORGAN020Act_Roles] WHERE OrgID = @sysOrgId AND OrgRoleContactID=@sysUserContactId);
	-- If Code, Contact, Org combination is not available in actrole then insert with security
	IF (ISNULL(@currentRefRoleId, 0) = 0)
	BEGIN
		DECLARE @currentRoleDefault BIT = NULL
		,@currentRoleTitle NVARCHAR(50) = NULL
		,@roleTypeId INT = NULL
        ,@orgLogical BIT = NULL
        ,@prgLogical BIT = NULL
        ,@prjLogical BIT = NULL
        ,@phsLogical BIT = NULL
        ,@jobLogical BIT = NULL
        ,@prxContactDefault BIT = NULL
        ,@prxJobDefaultAnalyst BIT = NULL
		,@prxJobDefaultResponsible BIT = NULL
        ,@prxJobGWDefaultAnalyst BIT = NULL
        ,@prxJobGWDefaultResponsible BIT = NULL ;

		SELECT @currentRoleDefault=OrgRoleDefault
		,@currentRoleTitle=[OrgRoleTitle]
		,@roleTypeId=[RoleTypeId]
		,@orgLogical = [OrgLogical]
        ,@prgLogical = [PrgLogical]
        ,@prjLogical = [PrjLogical]
        ,@phsLogical = [PhsLogical]
        ,@jobLogical = [JobLogical]
        ,@prxContactDefault = [PrxContactDefault]
        ,@prxJobDefaultAnalyst = [PrxJobDefaultAnalyst]
		,@prxJobDefaultResponsible = [PrxJobDefaultResponsible]
        ,@prxJobGWDefaultAnalyst = [PrxJobGWDefaultAnalyst]
        ,@prxJobGWDefaultResponsible = [PrxJobGWDefaultResponsible]
		FROM [dbo].[ORGAN010Ref_Roles] WHERE Id = @actRoleId

		EXEC [dbo].[InsOrgActRole]	@userId, @roleId, @sysOrgId, 0, @actRoleId, @currentRoleDefault, @currentRoleTitle, @sysUserContactId, @roleTypeId, @orgLogical, @prgLogical, @prjLogical, @phsLogical, @jobLogical, @prxContactDefault, @prxJobDefaultAnalyst,@prxJobDefaultResponsible, @prxJobGWDefaultAnalyst, @prxJobGWDefaultResponsible, @statusId, @dateEntered, @enteredBy, 1
	END
	ELSE IF((ISNULL(@currentRefRoleId, 0) > 0) AND (@actRoleId <> @currentRefRoleId))
	BEGIN
		DECLARE @currentActRoleId BIGINT = (SELECT Id FROM [dbo].[ORGAN020Act_Roles] WHERE OrgID = @sysOrgId AND OrgRoleContactID=@sysUserContactId AND OrgRefRoleId=@currentRefRoleId);

		-- update roleId if already exists
		UPDATE [dbo].[ORGAN020Act_Roles] SET OrgRefRoleId = @actRoleId WHERE Id = @currentActRoleId;

		--FIRST DELETE OrgActSubSecurityByRole
		DELETE subs FROM [dbo].[ORGAN022Act_SubSecurityByRole] subs 
		INNER JOIN [dbo].[ORGAN021Act_SecurityByRole] sec ON subs.OrgSecurityByRoleId = sec.Id
		WHERE sec.OrgActRoleId = @currentActRoleId AND sec.OrgId = @sysOrgId;

		--THEN DELETE OrgActSecurityByRole
		DELETE FROM [dbo].[ORGAN021Act_SecurityByRole] WHERE OrgActRoleId = @currentActRoleId AND OrgId = @sysOrgId;

		--THEN INSERT AGAIN all the securities
		EXEC [dbo].[CopyActRoleContactSecurity] @sysOrgId, @roleId, @currentActRoleId, @sysUserContactId, @enteredBy

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
/****** Object:  StoredProcedure [dbo].[InsPrgEdiHeader]    Script Date: 11/26/2018 8:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               09/16/2018      
-- Description:               Ins a  Program Edi header
-- Execution:                 EXEC [dbo].[InsPrgEdiHeader]
-- Modified on:               05/10/2018
-- Modified Desc:             Added OrderType and SetPurpose fields
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.) 
-- ============================================= 

ALTER PROCEDURE  [dbo].[InsPrgEdiHeader]
	(@userId BIGINT
	,@roleId BIGINT 
	,@entity NVARCHAR(100)
	,@pehProgramId bigint
	,@pehItemNumber int
	,@pehEdiCode nvarchar(20)
	,@pehEdiTitle nvarchar(50)
	,@pehTradingPartner nvarchar(20)
	,@pehEdiDocument nvarchar(20)
	,@pehEdiVersion nvarchar(20)
	,@pehSCACCode nvarchar(20)
	,@pehSndRcv bit
	,@pehInsertCode   nvarchar(20)
	,@pehUpdateCode   nvarchar(20)
	,@pehCancelCode   nvarchar(20)
	,@pehHoldCode     nvarchar(20)
	,@pehOriginalCode nvarchar(20)
	,@pehReturnCode	  nvarchar(20)
	,@uDF01 nvarchar(20)
	,@uDF02 nvarchar(20)
	,@uDF03 nvarchar(20)
	,@uDF04 nvarchar(20)
	,@uDF05 nvarchar(20)
	,@uDF06 nvarchar(20)
	,@uDF07 nvarchar(20)
	,@uDF08 nvarchar(20)
	,@uDF09 nvarchar(20)
	,@uDF10 nvarchar(20)           
	,@pehAttachments int
	,@statusId int
	,@pehDateStart datetime2(7)
	,@pehDateEnd datetime2(7)			
	,@enteredBy nvarchar(50)
	,@dateEntered datetime2(7))
AS
BEGIN TRY                
 SET NOCOUNT ON; 
  DECLARE @updatedItemNumber INT      
 EXEC [dbo].[ResetItemNumber] @userId, 0, @pehProgramId, @entity, @pehItemNumber, @statusId, NULL, NULL,  @updatedItemNumber OUTPUT
   
 DECLARE @currentId BIGINT;
 INSERT INTO [dbo].[PRGRM070EdiHeader]
           ([PehProgramID]
			,[PehItemNumber]
			,[PehEdiCode]
			,[PehEdiTitle]
			,[PehTradingPartner]
			,[PehEdiDocument]
			,[PehEdiVersion]
			,[PehSCACCode]
			,[PehInsertCode]  
			,[PehUpdateCode]   
			,[PehCancelCode]   
			,[PehHoldCode]    
			,[PehOriginalCode] 
			,[PehReturnCode]
			,[UDF01]
            ,[UDF02]
            ,[UDF03]
            ,[UDF04]
			,[UDF05]
			,[UDF06]
			,[UDF07]
			,[UDF08]
			,[UDF09]
			,[UDF10]
			,[PehAttachments]
			,[StatusId]
			,[PehDateStart]
			,[PehDateEnd]
			,[PehSndRcv]
			,[EnteredBy]
			,[DateEntered])
     VALUES
           (@pehProgramId
		   	,@updatedItemNumber
		   	,@pehEdiCode
		   	,@pehEdiTitle
		   	,@pehTradingPartner
		   	,@pehEdiDocument
		   	,@pehEdiVersion
		   	,@pehSCACCode
			,@pehInsertCode   
            ,@pehUpdateCode   
            ,@pehCancelCode   
            ,@pehHoldCode     
            ,@pehOriginalCode 
            ,@pehReturnCode	  
			,@uDF01
            ,@uDF02
            ,@uDF03
            ,@uDF04
			,@uDF05
			,@uDF06
			,@uDF07
			,@uDF08
			,@uDF09
			,@uDF10
		   	,@pehAttachments
		   	,@statusId
		   	,@pehDateStart
		   	,@pehDateEnd
			,@pehSndRcv
		   	,@enteredBy
		   	,@dateEntered)
			SET @currentId = SCOPE_IDENTITY();
	SELECT * FROM [dbo].[PRGRM070EdiHeader] WHERE Id = @currentId;	
END TRY              
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[InsPrgEdiMapping]    Script Date: 11/26/2018 8:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               09/16/2018      
-- Description:               Ins a  Program Edi mapping
-- Execution:                 EXEC [dbo].[InsPrgEdiMapping]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================

ALTER PROCEDURE  [dbo].[InsPrgEdiMapping]
	(@userId BIGINT
	,@roleId BIGINT 
	,@entity NVARCHAR(100)
	,@pemHeaderID bigint
	,@pemEdiTableName  NVARCHAR(50)
	,@pemEdiFieldName NVARCHAR(50)
	,@pemEdiFieldDataType NVARCHAR(20)
	,@pemSysTableName NVARCHAR(50)
	,@pemSysFieldName NVARCHAR(50)
	,@pemSysFieldDataType NVARCHAR(20)
	,@statusId  int
	,@pemInsertUpdate int
	,@pemDateStart datetime2(7)
	,@pemDateEnd datetime2(7)
	,@enteredBy NVARCHAR(50)
	,@dateEntered datetime2(7))
AS
BEGIN TRY                
 SET NOCOUNT ON;   
 DECLARE @currentId BIGINT;

 SELECT @pemSysFieldDataType =  DATA_TYPE from INFORMATION_SCHEMA.COLUMNS IC where TABLE_NAME = @pemSysTableName and COLUMN_NAME = @pemSysFieldName
 SELECT @pemEdiFieldDataType =  DATA_TYPE from INFORMATION_SCHEMA.COLUMNS IC where TABLE_NAME = @pemEdiTableName and COLUMN_NAME = @pemEdiFieldName

 INSERT INTO [dbo].[PRGRM071EdiMapping]
            ( [PemHeaderID]
             ,[PemEdiTableName]
             ,[PemEdiFieldName]
             ,[PemEdiFieldDataType]
             ,[PemSysTableName]
             ,[PemSysFieldName]
             ,[PemSysFieldDataType]
             ,[StatusId]
             ,[PemInsertUpdate]
             ,[PemDateStart]
             ,[PemDateEnd]
             ,[EnteredBy]
             ,[DateEntered]
             )
     VALUES
           ( @pemHeaderID 
			,@pemEdiTableName  
			,@pemEdiFieldName 
			,@pemEdiFieldDataType
			,@pemSysTableName 
			,@pemSysFieldName 
			,@pemSysFieldDataType 
			,@statusId  
			,@pemInsertUpdate 
			,@pemDateStart
			,@pemDateEnd 
			,@enteredBy
			,@dateEntered )
			SET @currentId = SCOPE_IDENTITY();
	SELECT * FROM [dbo].[PRGRM071EdiMapping] WHERE Id = @currentId;	
END TRY              
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[InsPrgMvoc]    Script Date: 11/26/2018 8:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               09/26/2018      
-- Description:               Ins a  Program MVOC  
-- Execution:                 EXEC [dbo].[InsPrgMvoc]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- ============================================= 
  
ALTER PROCEDURE  [dbo].[InsPrgMvoc]  
	(@userId BIGINT  
	,@roleId BIGINT 
	,@entity NVARCHAR(100)  
	,@vocOrgID bigint  
	,@vocProgramID bigint  
	,@vocSurveyCode nvarchar(20)  
	,@vocSurveyTitle nvarchar(50)  
	,@statusId int  
	,@vocDateOpen datetime2(7)  
	,@vocDateClose datetime2(7)  
	,@dateEntered datetime2(7)  
	,@enteredBy nvarchar(50))  
AS  
BEGIN TRY                  
 SET NOCOUNT ON;     
 DECLARE @currentId BIGINT;  
 INSERT INTO [dbo].[MVOC000Program]  
           (VocOrgID  
   ,VocProgramID  
   ,VocSurveyCode  
   ,VocSurveyTitle  
   ,StatusId  
   ,VocDateOpen  
   ,VocDateClose  
   ,DateEntered  
   ,EnteredBy)  
     VALUES  
           (@vocOrgID   
      ,@vocProgramID  
      ,@vocSurveyCode  
      ,@vocSurveyTitle  
      ,@statusId  
      ,@vocDateOpen  
      ,@vocDateClose  
      ,@dateEntered  
      ,@enteredBy)  
   SET @currentId = SCOPE_IDENTITY();  
 SELECT * FROM [dbo].[MVOC000Program] WHERE Id = @currentId;   
END TRY                
BEGIN CATCH                  
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                  
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                  
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                  
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                  
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[InsPrgMvocRefQuestion]    Script Date: 11/26/2018 8:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               09/26/2018      
-- Description:               Ins a  MVOC ref question
-- Execution:                 EXEC [dbo].[InsPrgMvocRefQuestion]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================

ALTER PROCEDURE  [dbo].[InsPrgMvocRefQuestion]
	(@userId BIGINT
	,@roleId BIGINT 
	,@entity NVARCHAR(100)
	,@mVOCID bigint
	,@queQuestionNumber int
	,@queCode nvarchar(20)
	,@queTitle nvarchar(50)
	,@quesTypeId int
	,@queType_YNAnswer bit
	,@queType_YNDefault bit
	,@queType_RangeLo int
	,@queType_RangeHi int
	,@queType_RangeAnswer int
	,@queType_RangeDefault int
	,@statusId int = null
	,@dateEntered datetime2(7)
	,@enteredBy nvarchar(50))
AS
BEGIN TRY                
 SET NOCOUNT ON;
 DECLARE @updatedItemNumber INT      
   EXEC [dbo].[ResetItemNumber] @userId, 0, @mVOCID, @entity, @queQuestionNumber, @statusId, NULL, NULL,  @updatedItemNumber OUTPUT  
 DECLARE @currentId BIGINT;
 INSERT INTO [dbo].[MVOC010Ref_Questions]
           (MVOCID
			,QueQuestionNumber
			,QueCode
			,QueTitle
			,QuesTypeId
			,QueType_YNAnswer
			,QueType_YNDefault
			,QueType_RangeLo
			,QueType_RangeHi
			,QueType_RangeAnswer
			,QueType_RangeDefault
			,StatusId
			,DateEntered
			,EnteredBy)
     VALUES
           (@mVOCID
		   	,@updatedItemNumber
		   	,@queCode
		   	,@queTitle
		   	,@quesTypeId
		   	,@queType_YNAnswer
		   	,@queType_YNDefault
		   	,@queType_RangeLo
		   	,@queType_RangeHi
		   	,@queType_RangeAnswer
		   	,@queType_RangeDefault
			,@statusId
		   	,@dateEntered
		   	,@enteredBy)
			SET @currentId = SCOPE_IDENTITY();

	EXEC [dbo].[GetPrgMvocRefQuestion] @userId, @roleId, 0, @currentId

END TRY              
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[InsPrgRefAttributeDefault]    Script Date: 11/26/2018 8:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               09/14/2018      
-- Description:               Ins a  Program Ref Attributes
-- Execution:                 EXEC [dbo].[InsPrgRefAttributeDefault]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================

ALTER PROCEDURE  [dbo].[InsPrgRefAttributeDefault]
	(@userId BIGINT
	,@roleId BIGINT 
	,@entity NVARCHAR(100)
	,@programId bigint
	,@attItemNumber int
	,@attCode nvarchar(20)
	,@attTitle nvarchar(50)
	,@attQuantity int
	,@unitTypeId int
	,@statusId int
	,@attDefault bit
	,@dateEntered datetime2(7)
	,@enteredBy nvarchar(50))
AS
BEGIN TRY                
 SET NOCOUNT ON;  
  DECLARE @updatedItemNumber INT      
  EXEC [dbo].[ResetItemNumber] @userId, 0, @programId, @entity, @attItemNumber, @statusId, NULL, NULL,  @updatedItemNumber OUTPUT
 DECLARE @currentId BIGINT;
 INSERT INTO [dbo].[PRGRM020Ref_AttributesDefault]
           ([ProgramID]
			,[AttItemNumber]
			,[AttCode]
			,[AttTitle]
			,[AttQuantity]
			,[UnitTypeId]
			,[StatusId]
			,[AttDefault]
			,[DateEntered]
			,[EnteredBy])
     VALUES
           (@programId
		   	,@updatedItemNumber
		   	,@attCode
		   	,@attTitle
		   	,@attQuantity
		   	,@unitTypeId
			,@statusId
		   	,@attDefault
		   	,@dateEntered
		   	,@enteredBy)
			SET @currentId = SCOPE_IDENTITY();
	SELECT * FROM [dbo].[PRGRM020Ref_AttributesDefault] WHERE Id = @currentId;	
END TRY              
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[InsPrgRefGatewayDefault]    Script Date: 11/26/2018 8:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group  
   All Rights Reserved Worldwide */  
-- =============================================          
-- Author:                    Akhil Chauhan           
-- Create date:               09/14/2018        
-- Description:               Ins a  Program Ref Gateway Default  
-- Execution:                 EXEC [dbo].[InsPrgRefGatewayDefault]  
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)    
-- Modified Desc:    
-- =============================================     
    
ALTER PROCEDURE  [dbo].[InsPrgRefGatewayDefault]    
	(@userId BIGINT    
	,@roleId BIGINT 
	,@entity NVARCHAR(100)    
	,@pgdProgramId bigint    
	,@pgdGatewaySortOrder int    
	,@pgdGatewayCode nvarchar(20)    
	,@pgdGatewayTitle nvarchar(50)    
	,@pgdGatewayDuration decimal(18, 0)    
	,@unitTypeId int    
	,@pgdGatewayDefault bit    
	,@gatewayTypeId int    
	,@gatewayDateRefTypeId int   
	,@scanner bit  
	,@pgdShipApptmtReasonCode nvarchar(20)   
	,@pgdShipStatusReasonCode nvarchar(20)   
	,@pgdOrderType nvarchar(20)     
	,@pgdShipmentType nvarchar(20)      
	,@pgdGatewayResponsible bigint
	,@pgdGatewayAnalyst bigint
	,@statusId int    
	,@dateEntered datetime2(7)    
	,@enteredBy nvarchar(50))    
AS    
BEGIN TRY                    
 SET NOCOUNT ON;      
 DECLARE @updatedItemNumber INT          
 DECLARE @where NVARCHAR(MAX) =' AND GatewayTypeId ='  +  CAST(@gatewayTypeId AS VARCHAR) + ' AND PgdOrderType ='''  +  CAST(@pgdOrderType AS VARCHAR)  +''' AND PgdShipmentType ='''  +  CAST(@pgdShipmentType AS VARCHAR) +''''
 EXEC [dbo].[ResetItemNumber] @userId, 0, @pgdProgramId, @entity, @pgdGatewaySortOrder, @statusId, NULL, @where,  @updatedItemNumber OUTPUT  
 
      
 DECLARE @currentId BIGINT;    
 INSERT INTO [dbo].[PRGRM010Ref_GatewayDefaults]    
           ([PgdProgramID]    
   ,[PgdGatewaySortOrder]    
   ,[PgdGatewayCode]    
   ,[PgdGatewayTitle]    
   ,[PgdGatewayDuration]    
   ,[UnitTypeId]    
   ,[PgdGatewayDefault]    
   ,[GatewayTypeId]    
   ,[GatewayDateRefTypeId]  
   ,[Scanner]
   ,[PgdShipApptmtReasonCode]
   ,[PgdShipStatusReasonCode]
   ,[PgdOrderType]
   ,[PgdShipmentType]     
   ,[PgdGatewayResponsible]
   ,[PgdGatewayAnalyst]
   ,[StatusId]    
   ,[DateEntered]    
   ,[EnteredBy])    
     VALUES    
           (@pgdProgramID    
   ,@updatedItemNumber    
   ,@pgdGatewayCode    
   ,@pgdGatewayTitle    
      ,@pgdGatewayDuration    
      ,@unitTypeId    
      ,@pgdGatewayDefault    
      ,@gatewayTypeId    
      ,@gatewayDateRefTypeId    
	  ,@scanner
	  ,@pgdShipApptmtReasonCode
      ,@pgdShipStatusReasonCode
	  ,@pgdOrderType
      ,@pgdShipmentType    
	  ,@pgdGatewayResponsible 
      ,@pgdGatewayAnalyst 
      ,@statusId    
      ,@dateEntered    
      ,@enteredBy)    
   SET @currentId = SCOPE_IDENTITY();    
 SELECT * FROM [dbo].[PRGRM010Ref_GatewayDefaults] WHERE Id = @currentId;     
END TRY                  
BEGIN CATCH                    
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                    
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                    
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                    
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                    
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[InsPrgShipApptmtReasonCode]    Script Date: 11/26/2018 8:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               09/14/2018      
-- Description:               Ins a  Program Ship Apptmt Reason Code
-- Execution:                 EXEC [dbo].[InsPrgShipApptmtReasonCode]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- ============================================= 

ALTER PROCEDURE  [dbo].[InsPrgShipApptmtReasonCode]
	(@userId BIGINT
	,@roleId BIGINT 
	,@entity NVARCHAR(100)
	,@pacOrgId bigint
	,@pacProgramId bigint
	,@pacApptItem int
	,@pacApptReasonCode nvarchar(20)
	,@pacApptLength int
	,@pacApptInternalCode nvarchar(20)
	,@pacApptPriorityCode nvarchar(20)
	,@pacApptTitle nvarchar(50)
	,@pacApptCategoryCode nvarchar(20)
	,@pacApptUser01Code nvarchar(20)
	,@pacApptUser02Code nvarchar(20)
	,@pacApptUser03Code nvarchar(20)
	,@pacApptUser04Code nvarchar(20)
	,@pacApptUser05Code nvarchar(20)
	,@statusId int
	,@dateEntered datetime2(7)
	,@enteredBy nvarchar(50))
AS
BEGIN TRY                
 SET NOCOUNT ON;  
  DECLARE @updatedItemNumber INT      
EXEC [dbo].[ResetItemNumber] @userId, 0, @pacProgramId, @entity, @pacApptItem, @statusId, NULL, NULL,  @updatedItemNumber OUTPUT 
  
 DECLARE @currentId BIGINT;
 INSERT INTO [dbo].[PRGRM031ShipApptmtReasonCodes]
           ([PacOrgID]
			,[PacProgramID]
			,[PacApptItem]
			,[PacApptReasonCode]
			,[PacApptLength]
			,[PacApptInternalCode]
			,[PacApptPriorityCode]
			,[PacApptTitle]
			,[PacApptCategoryCode]
			,[PacApptUser01Code]
			,[PacApptUser02Code]
			,[PacApptUser03Code]
			,[PacApptUser04Code]
			,[PacApptUser05Code]
			,[StatusId]
			,[DateEntered]
			,[EnteredBy])
     VALUES
           (@pacOrgId
		   	,@pacProgramId
		   	,@updatedItemNumber
		   	,@pacApptReasonCode
		   	,@pacApptLength
		   	,@pacApptInternalCode
		   	,@pacApptPriorityCode
		   	,@pacApptTitle
		   	,@pacApptCategoryCode
		   	,@pacApptUser01Code
		   	,@pacApptUser02Code
		   	,@pacApptUser03Code
		   	,@pacApptUser04Code
		   	,@pacApptUser05Code
		   	,@statusId
		   	,@dateEntered
		   	,@enteredBy)
			SET @currentId = SCOPE_IDENTITY();
	SELECT * FROM [dbo].[PRGRM031ShipApptmtReasonCodes] WHERE Id = @currentId;
END TRY              
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[InsPrgShipStatusReasonCode]    Script Date: 11/26/2018 8:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               09/14/2018      
-- Description:               Ins a  Program Ship Status Reason Code
-- Execution:                 EXEC [dbo].[InsPrgShipStatusReasonCode]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================  

ALTER PROCEDURE  [dbo].[InsPrgShipStatusReasonCode]
	(@userId BIGINT
	,@roleId BIGINT 
	,@entity NVARCHAR(100)
	,@pscOrgId bigint
	,@pscProgramId bigint
	,@pscShipItem int
	,@pscShipReasonCode nvarchar(20)
	,@pscShipLength int
	,@pscShipInternalCode nvarchar(20)
	,@pscShipPriorityCode nvarchar(20)
	,@pscShipTitle nvarchar(50)
	,@pscShipCategoryCode nvarchar(20)
	,@pscShipUser01Code nvarchar(20)
	,@pscShipUser02Code nvarchar(20)
	,@pscShipUser03Code nvarchar(20)
	,@pscShipUser04Code nvarchar(20)
	,@pscShipUser05Code nvarchar(20)
	,@statusId int
	,@dateEntered datetime2(7)
	,@enteredBy nvarchar(50))
AS
BEGIN TRY                
 SET NOCOUNT ON; 
  DECLARE @updatedItemNumber INT      
 EXEC [dbo].[ResetItemNumber] @userId, 0, @pscProgramId, @entity, @pscShipItem, @statusId, NULL, NULL,  @updatedItemNumber OUTPUT
   
 DECLARE @currentId BIGINT;
 INSERT INTO [dbo].[PRGRM030ShipStatusReasonCodes]
           ([PscOrgID]
			,[PscProgramID]
			,[PscShipItem]
			,[PscShipReasonCode]
			,[PscShipLength]
			,[PscShipInternalCode]
			,[PscShipPriorityCode]
			,[PscShipTitle]
			,[PscShipCategoryCode]
			,[PscShipUser01Code]
			,[PscShipUser02Code]
			,[PscShipUser03Code]
			,[PscShipUser04Code]
			,[PscShipUser05Code]
			,[StatusId]
			,[DateEntered]
			,[EnteredBy])
     VALUES
           (@pscOrgID
		   	,@pscProgramID 
		   	,@updatedItemNumber
		   	,@pscShipReasonCode
		   	,@pscShipLength
		   	,@pscShipInternalCode
		   	,@pscShipPriorityCode
		   	,@pscShipTitle
		   	,@pscShipCategoryCode
		   	,@pscShipUser01Code
		   	,@pscShipUser02Code
		   	,@pscShipUser03Code
		   	,@pscShipUser04Code
		   	,@pscShipUser05Code
		   	,@statusId
		   	,@dateEntered
		   	,@enteredBy)
			SET @currentId = SCOPE_IDENTITY();
	SELECT * FROM [dbo].[PRGRM030ShipStatusReasonCodes] WHERE Id = @currentId;
END TRY              
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[InsPrgVendLocation]    Script Date: 11/26/2018 8:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               09/16/2018      
-- Description:               Ins a  Program vendor location
-- Execution:                 EXEC [dbo].[InsPrgVendLocation]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- ============================================= 
  
ALTER PROCEDURE  [dbo].[InsPrgVendLocation]  
	(@userId BIGINT  
	,@roleId BIGINT 
	,@entity NVARCHAR(100)  
	,@pvlProgramID bigint  
	,@pvlVendorID bigint  
	,@pvlItemNumber int  
	,@pvlLocationCode nvarchar(20)  
	,@pvlLocationCodeCustomer nvarchar(20)  
	,@pvlLocationTitle nvarchar(50)  
	,@pvlContactMSTRID bigint  
	,@statusId int  
	,@pvlDateStart datetime2(7)  
	,@pvlDateEnd datetime2(7)
	,@pvlUserCode1 NVARCHAR(20) = NULL
	,@pvlUserCode2 NVARCHAR(20) = NULL
	,@pvlUserCode3 NVARCHAR(20) = NULL
	,@pvlUserCode4 NVARCHAR(20) = NULL
	,@pvlUserCode5 NVARCHAR(20) = NULL  
	,@enteredBy nvarchar(50)  
	,@dateEntered datetime2(7))  
AS  
BEGIN TRY                  
 SET NOCOUNT ON;   
 DECLARE @updatedItemNumber INT        
   EXEC [dbo].[ResetItemNumber] @userId, 0, @pvlProgramID, @entity, @pvlItemNumber, @statusId, NULL, NULL,  @updatedItemNumber OUTPUT    
 DECLARE @currentId BIGINT;  
 INSERT INTO [dbo].[PRGRM051VendorLocations]  
           ([PvlProgramID]  
   ,[PvlVendorID]  
   ,[PvlItemNumber]  
   ,[PvlLocationCode]  
   ,[PvlLocationCodeCustomer]  
   ,[PvlLocationTitle]  
   ,[PvlContactMSTRID]  
   ,[StatusId]  
   ,[PvlDateStart]  
   ,[PvlDateEnd] 
   ,[PvlUserCode1]
   ,[PvlUserCode2]
   ,[PvlUserCode3]
   ,[PvlUserCode4]
   ,[PvlUserCode5]
   ,[EnteredBy]  
   ,[DateEntered])  
     VALUES  
           (@pvlProgramID  
      ,@pvlVendorID  
      ,@updatedItemNumber  
      ,@pvlLocationCode  
      ,@pvlLocationCodeCustomer  
      ,@pvlLocationTitle  
      ,@pvlContactMSTRID  
      ,@statusId  
      ,@pvlDateStart  
      ,@pvlDateEnd
	  ,@pvlUserCode1
	  ,@pvlUserCode2
	  ,@pvlUserCode3
	  ,@pvlUserCode4
	  ,@pvlUserCode5
   ,@enteredBy  
   ,@dateEntered)  
   SET @currentId = SCOPE_IDENTITY();  
 SELECT * FROM [dbo].[PRGRM051VendorLocations] WHERE Id = @currentId;  
END TRY                
BEGIN CATCH                  
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                  
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                  
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                  
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                  
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[InsProgram]    Script Date: 11/26/2018 8:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group        
   All Rights Reserved Worldwide */        
-- =============================================                
-- Author:                    Akhil Chauhan                 
-- Create date:               09/06/2018              
-- Description:               Ins a program         
-- Execution:                 EXEC [dbo].[InsProgram]        
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)          
-- Modified Desc:          
-- =============================================        
        
ALTER PROCEDURE  [dbo].[InsProgram]        
	(@userId BIGINT        
	,@roleId BIGINT 
	,@entity NVARCHAR(100)        
	,@prgOrgId bigint        
	,@prgCustId bigint        
	,@prgItemNumber nvarchar(20)        
	,@prgProgramCode nvarchar(20)        
	,@prgProjectCode nvarchar(20)        
	,@prgPhaseCode nvarchar(20)        
	,@prgProgramTitle nvarchar(50)        
	,@prgAccountCode nvarchar(50)  
	,@delEarliest decimal(18,2) = NULL  
	,@delLatest decimal(18,2) = NULL  
	,@delDay BIT = NULL  
	,@pckEarliest decimal(18,2)  = NULL  
	,@pckLatest decimal(18,2) = NULL  
	,@pckDay BIT  = NULL  
	,@statusId INT        
	,@prgDateStart datetime2(7)        
	,@prgDateEnd datetime2(7)        
	,@prgDeliveryTimeDefault datetime2(7)        
	,@prgPickUpTimeDefault datetime2(7)        
	,@dateEntered datetime2(7)        
	,@enteredBy nvarchar(50)         
	,@parentId bigint =NULL)        
AS        
BEGIN TRY                        
 SET NOCOUNT ON;          
 DECLARE @currentId BIGINT;        
          
IF ISNULL(@parentId,0) = 0        
BEGIN        
 INSERT INTO [dbo].[PRGRM000Master]        
           ([PrgOrgId]          
           ,[PrgCustId]          
           ,[PrgItemNumber]          
           ,[PrgProgramCode]          
           ,[PrgProjectCode]          
           ,[PrgPhaseCode]          
           ,[PrgProgramTitle]          
           ,[PrgAccountCode]   
     ,[DelEarliest]   
     ,[DelLatest]   
     ,[DelDay]   
     ,[PckEarliest]   
     ,[PckLatest]   
     ,[PckDay]          
           ,[StatusId]          
           ,[PrgDateStart]          
           ,[PrgDateEnd]          
           ,[PrgDeliveryTimeDefault]          
           ,[PrgPickUpTimeDefault]          
           ,[PrgHierarchyID]          
           ,[DateEntered]          
           ,[EnteredBy])        
     VALUES        
           (@prgOrgId          
           ,@prgCustId          
           ,@prgItemNumber          
           ,@prgProgramCode          
           ,@prgProjectCode          
           ,@prgPhaseCode          
           ,@prgProgramTitle          
           ,@prgAccountCode   
     ,@delEarliest  
     ,@delLatest  
     ,@delDay  
     ,@pckEarliest  
     ,@pckLatest  
     ,@pckDay  
           ,@statusId          
           ,@prgDateStart          
           ,@prgDateEnd          
           ,@prgDeliveryTimeDefault          
           ,@prgPickUpTimeDefault          
           ,hierarchyid::GetRoot().GetDescendant((select MAX(PrgHierarchyID) from [dbo].[PRGRM000Master]  where PrgHierarchyID.GetAncestor(1) = hierarchyid::GetRoot()),NULL)          
           ,@dateEntered          
           ,@enteredBy)         
     SET @currentId = SCOPE_IDENTITY();        
 --SELECT * FROM [dbo].[PRGRM000Master] WHERE Id = @currentId;        
        
END        
ELSE          
 BEGIN            
    DECLARE @parentNode hierarchyid, @lc hierarchyid            
    SELECT @parentNode = [PrgHierarchyID]            
    FROM  [dbo].[PRGRM000Master]            
    WHERE Id = @parentId            
    SET TRANSACTION ISOLATION LEVEL SERIALIZABLE            
    BEGIN TRANSACTION            
    SELECT @lc = max(PrgHierarchyID)             
    FROM   [dbo].[PRGRM000Master]           
    WHERE PrgHierarchyID.GetAncestor(1)  =@parentNode ;            
          
    INSERT INTO [dbo].[PRGRM000Master]        
           ([PrgOrgId]          
           ,[PrgCustId]          
           ,[PrgItemNumber]          
           ,[PrgProgramCode]          
           ,[PrgProjectCode]          
           ,[PrgPhaseCode]          
           ,[PrgProgramTitle]          
           ,[PrgAccountCode]    
     ,[DelEarliest]   
     ,[DelLatest]   
     ,[DelDay]   
     ,[PckEarliest]   
     ,[PckLatest]   
     ,[PckDay]             
           ,[StatusId]          
           ,[PrgDateStart]          
           ,[PrgDateEnd]          
           ,[PrgDeliveryTimeDefault]          
           ,[PrgPickUpTimeDefault]          
           ,[PrgHierarchyID]          
           ,[DateEntered]          
           ,[EnteredBy])        
     VALUES        
           (@prgOrgId          
           ,@prgCustId          
           ,@prgItemNumber          
           ,@prgProgramCode          
           ,@prgProjectCode          
     ,@prgPhaseCode          
           ,@prgProgramTitle          
           ,@prgAccountCode          
     ,@delEarliest  
     ,@delLatest  
     ,@delDay  
     ,@pckEarliest  
     ,@pckLatest  
     ,@pckDay  
           ,@statusId          
           ,@prgDateStart          
           ,@prgDateEnd          
           ,@prgDeliveryTimeDefault          
           ,@prgPickUpTimeDefault          
           ,@parentNode.GetDescendant(@lc, NULL)          
           ,@dateEntered          
           ,@enteredBy)         
        
      SET @currentId = SCOPE_IDENTITY();        
        
        
          
        
  COMMIT           
END         
        
     
 EXEC CopyActRoleOnProgramCreate @userId,@roleId,@prgOrgId,@prgCustId,@currentId,@dateEntered,@enteredBy  ;  
  
 IF @parentId > 0  
 BEGIN  
     EXEC CopyProgramGatewaysAndAttributesFromParent  @userId,@roleId,@prgOrgId,@currentId,@parentId,@dateEntered,@enteredBy;  
 END  
   
       
        
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
  ,prg.[DelDay]   
  ,prg.[PckEarliest]   
  ,prg.[PckLatest]   
  ,prg.[PckDay]              
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
  WHERE Id = @currentId;        
        
        
END TRY                      
BEGIN CATCH                        
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                        
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                        
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                        
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                        
END CATCH

select * from SYSTM000ErrorLog order By id desc
GO
/****** Object:  StoredProcedure [dbo].[InsProgramBillableRate]    Script Date: 11/26/2018 8:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               09/14/2018      
-- Description:               Ins a  Program Billable Rate
-- Execution:                 EXEC [dbo].[InsProgramBillableRate]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================

ALTER PROCEDURE  [dbo].[InsProgramBillableRate]
	(@userId BIGINT
	,@roleId BIGINT 
	,@entity NVARCHAR(100)
	,@pbrPrgrmId bigint
	,@pbrCode nvarchar(20)
	,@pbrCustomerCode nvarchar(20)
	,@pbrEffectiveDate datetime2(7)
	,@pbrTitle nvarchar(50)
	,@rateCategoryTypeId INT
	,@rateTypeId INT
	,@pbrBillablePrice decimal(18, 2)
	,@rateUnitTypeId INT
	,@pbrFormat nvarchar(20)
	,@pbrExpression01 nvarchar(255)
	,@pbrLogic01 nvarchar(255)
	,@pbrExpression02 nvarchar(255)
	,@pbrLogic02 nvarchar(255)
	,@pbrExpression03 nvarchar(255)
	,@pbrLogic03 nvarchar(255)
	,@pbrExpression04 nvarchar(255)
	,@pbrLogic04 nvarchar(255)
	,@pbrExpression05 nvarchar(255)
	,@pbrLogic05 nvarchar(255)
	,@statusId INT
	,@pbrVendLocationId bigint
	,@enteredBy nvarchar(50)
	,@dateEntered datetime2(7))
AS
BEGIN TRY                
 SET NOCOUNT ON;   
 DECLARE @currentId BIGINT;
 INSERT INTO [dbo].[PRGRM040ProgramBillableRate]
           ([PbrPrgrmID]
			,[PbrCode]
			,[PbrCustomerCode]
			,[PbrEffectiveDate]
			,[PbrTitle]
			,[RateCategoryTypeId]
			,[RateTypeId]
			,[PbrBillablePrice]
			,[RateUnitTypeId]
			,[PbrFormat]
			,[PbrExpression01]
			,[PbrLogic01]
			,[PbrExpression02]
			,[PbrLogic02]
			,[PbrExpression03]
			,[PbrLogic03]
			,[PbrExpression04]
			,[PbrLogic04]
			,[PbrExpression05]
			,[PbrLogic05]
			,[StatusId]
			,[PbrVendLocationID]
			,[EnteredBy]
			,[DateEntered])
     VALUES
           (@pbrPrgrmId
		   	,@pbrCode
		   	,@pbrCustomerCode
		   	,@pbrEffectiveDate
		   	,@pbrTitle
		   	,@rateCategoryTypeId
		   	,@rateTypeId
		   	,@pbrBillablePrice
		   	,@rateUnitTypeId
		   	,@pbrFormat
		   	,@pbrExpression01
		   	,@pbrLogic01
		   	,@pbrExpression02
		   	,@pbrLogic02
		   	,@pbrExpression03
		   	,@pbrLogic03
		   	,@pbrExpression04
		   	,@pbrLogic04
		   	,@pbrExpression05
		   	,@pbrLogic05
		   	,@statusId
		   	,@pbrVendLocationID
		   	,@enteredBy
		   	,@dateEntered)
			SET @currentId = SCOPE_IDENTITY();
	SELECT * FROM [dbo].[PRGRM040ProgramBillableRate] WHERE Id = @currentId;
END TRY              
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[InsProgramCostRate]    Script Date: 11/26/2018 8:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               09/14/2018      
-- Description:               Ins a  Program Cost Rate
-- Execution:                 EXEC [dbo].[InsProgramCostRate]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================

ALTER PROCEDURE  [dbo].[InsProgramCostRate]
	(@userId BIGINT
	,@roleId BIGINT 
	,@entity NVARCHAR(100)
	,@pcrPrgrmId bigint
	,@pcrCode nvarchar(20)
	,@pcrVendorCode nvarchar(20)
	,@pcrEffectiveDate datetime2(7)
	,@pcrTitle nvarchar(50)
	,@rateCategoryTypeId INT
	,@rateTypeId INT
	,@pcrCostRate decimal(18, 2)
	,@rateUnitTypeId INT
	,@pcrFormat nvarchar(20)
	,@pcrExpression01 nvarchar(255)
	,@pcrLogic01 nvarchar(255)
	,@pcrExpression02 nvarchar(255)
	,@pcrLogic02 nvarchar(255)
	,@pcrExpression03 nvarchar(255)
	,@pcrLogic03 nvarchar(255)
	,@pcrExpression04 nvarchar(255)
	,@pcrLogic04 nvarchar(255)
	,@pcrExpression05 nvarchar(255)
	,@pcrLogic05 nvarchar(255)
	,@statusId INT
	,@pcrCustomerId bigint
	,@enteredBy nvarchar(50)
	,@dateEntered datetime2(7))
AS
BEGIN TRY                
 SET NOCOUNT ON;   
 DECLARE @currentId BIGINT;
 DECLARE @CustomerID BIGINT
 SELECT @CustomerID = PrgCustID from PRGRM000Master WHERE Id = @pcrPrgrmId


 INSERT INTO [dbo].[PRGRM041ProgramCostRate]
           ([PcrPrgrmID]
			,[PcrCode]
			,[PcrVendorCode]
			,[PcrEffectiveDate]
			,[PcrTitle]
			,[RateCategoryTypeId]
			,[RateTypeId]
			,[PcrCostRate]
			,[RateUnitTypeId]
			,[PcrFormat]
			,[PcrExpression01]
			,[PcrLogic01]
			,[PcrExpression02]
			,[PcrLogic02]
			,[PcrExpression03]
			,[PcrLogic03]
			,[PcrExpression04]
			,[PcrLogic04]
			,[PcrExpression05]
			,[PcrLogic05]
			,[StatusId]
			,[PcrCustomerID]
			,[EnteredBy]
			,[DateEntered])
     VALUES
           (@pcrPrgrmID
		   	,@pcrCode
		   	,@pcrVendorCode
		   	,@pcrEffectiveDate
		   	,@pcrTitle
		   	,@rateCategoryTypeId
		   	,@rateTypeId
		   	,@pcrCostRate
		   	,@rateUnitTypeId
		   	,@pcrFormat
		   	,@pcrExpression01
		   	,@pcrLogic01
		   	,@pcrExpression02
		   	,@pcrLogic02
		   	,@pcrExpression03
		   	,@pcrLogic03
		   	,@pcrExpression04
		   	,@pcrLogic04
		   	,@pcrExpression05
		   	,@pcrLogic05
		   	,@statusId
		   	,@CustomerID --@pcrCustomerID
		   	,@enteredBy
		   	,@dateEntered)
			SET @currentId = SCOPE_IDENTITY();
	SELECT * FROM [dbo].[PRGRM041ProgramCostRate] WHERE Id = @currentId;
END TRY              
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[InsProgramRole]    Script Date: 11/26/2018 8:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
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
	,@prgLogical BIT  =NULL
	,@jobLogical BIT  =NULL
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
			 
			,[PrgLogical]
			,[JobLogical]
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
			,@prgLogical 
			,@jobLogical 
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
/****** Object:  StoredProcedure [dbo].[InsReport]    Script Date: 11/26/2018 8:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               12/01/2018      
-- Description:               Ins Report  
-- Execution:                 EXEC [dbo].[InsReport]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================    
ALTER PROCEDURE  [dbo].[InsReport]      
	@userId BIGINT  
	,@roleId BIGINT 
	,@entity NVARCHAR(100)  
	,@orgId BIGINT = NULL  
	,@mainModuleId INT = NULL  
	,@reportName NVARCHAR(100) = NULL  
	,@reportDesc NVARCHAR(255) = NULL  
	,@isDefault BIT  
	,@statusId INT = NULL
	,@dateEntered DATETIME2(7) = NULL  
	,@enteredBy NVARCHAR(50) = NULL  
AS  
BEGIN TRY                  
 SET NOCOUNT ON;     
 DECLARE @currentId BIGINT;  
IF NOT EXISTS(SELECT RprtMainModuleId FROM [dbo].[SYSTM000Ref_Report] WHERE [RprtMainModuleId] = @mainModuleId)  
 BEGIN  
  SET @isDefault =1  --first report should be default  
 END  
   INSERT INTO [dbo].[SYSTM000Ref_Report]  
           ([OrganizationId]  
           ,[RprtMainModuleId]  
           ,[RprtName]  
           ,[RprtDescription]  
           ,[RprtIsDefault]  
           ,[StatusId] 
           ,[DateEntered]  
           ,[EnteredBy])  
     VALUES  
      (@orgId  
           ,@mainModuleId  
           ,@reportName  
           ,@reportDesc  
           ,@isDefault  
           ,@statusId 
           ,@dateEntered  
           ,@enteredBy)    
     SET @currentId = SCOPE_IDENTITY();  
 EXEC [dbo].[GetReport] @userId, @roleId,  @orgId,  'EN',  @currentId   
END TRY                  
BEGIN CATCH                  
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                  
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                  
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                  
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                  
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[InsScnCargo]    Script Date: 11/26/2018 8:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               08/16/2018      
-- Description:               Ins a ScnCargo 
-- Execution:                 EXEC [dbo].[InsScnCargo]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================

ALTER PROCEDURE  [dbo].[InsScnCargo]
	(@userId BIGINT
	,@roleId BIGINT 
	,@entity NVARCHAR(100)
	,@cargoID BIGINT = NULL
	,@jobID BIGINT = NULL
	,@cgoLineItem INT = NULL
	,@cgoPartNumCode NVARCHAR(30) = NULL
	,@cgoQtyOrdered DECIMAL(18, 2) = NULL
	,@cgoQtyExpected DECIMAL(18, 2) = NULL
	,@cgoQtyCounted DECIMAL(18, 2) = NULL
	,@cgoQtyDamaged DECIMAL(18, 2) = NULL
	,@cgoQtyOnHold DECIMAL(18, 2) = NULL
	,@cgoQtyShort DECIMAL(18, 2) = NULL
	,@cgoQtyOver DECIMAL(18, 2) = NULL
	,@cgoQtyUnits NVARCHAR(20) = NULL
	,@cgoStatus NVARCHAR(20) = NULL
	,@cgoInfoID NVARCHAR(50) = NULL
	,@colorCD INT = NULL
	,@cgoSerialCD NVARCHAR(255) = NULL
	,@cgoLong NVARCHAR(30) = NULL
	,@cgoLat NVARCHAR(30) = NULL
	,@cgoProFlag01 NVARCHAR(1) = NULL
	,@cgoProFlag02 NVARCHAR(1) = NULL
	,@cgoProFlag03 NVARCHAR(1) = NULL
	,@cgoProFlag04 NVARCHAR(1) = NULL
	,@cgoProFlag05 NVARCHAR(1) = NULL
	,@cgoProFlag06 NVARCHAR(1) = NULL
	,@cgoProFlag07 NVARCHAR(1) = NULL
	,@cgoProFlag08 NVARCHAR(1) = NULL
	,@cgoProFlag09 NVARCHAR(1) = NULL
	,@cgoProFlag10 NVARCHAR(1) = NULL
	,@cgoProFlag11 NVARCHAR(1) = NULL
	,@cgoProFlag12 NVARCHAR(1) = NULL
	,@cgoProFlag13 NVARCHAR(1) = NULL
	,@cgoProFlag14 NVARCHAR(1) = NULL
	,@cgoProFlag15 NVARCHAR(1) = NULL
	,@cgoProFlag16 NVARCHAR(1) = NULL
	,@cgoProFlag17 NVARCHAR(1) = NULL
	,@cgoProFlag18 NVARCHAR(1) = NULL
	,@cgoProFlag19 NVARCHAR(1) = NULL
	,@cgoProFlag20 NVARCHAR(1) = NULL
	,@enteredBy NVARCHAR(50) = NULL
	,@dateEntered DATETIME2(7) = NULL)
AS
BEGIN TRY                
 SET NOCOUNT ON;   
 
 DECLARE @currentId BIGINT;

 INSERT INTO [dbo].[SCN005Cargo]
           ([CargoID]
			,[JobID]
			,[CgoLineItem]
			,[CgoPartNumCode]
			,[CgoQtyOrdered]
			,[CgoQtyExpected]
			,[CgoQtyCounted]
			,[CgoQtyDamaged]
			,[CgoQtyOnHold]
			,[CgoQtyShort]
			,[CgoQtyOver]
			,[CgoQtyUnits]
			,[CgoStatus]
			,[CgoInfoID]
			,[ColorCD]
			,[CgoSerialCD]
			,[CgoLong]
			,[CgoLat]
			,[CgoProFlag01]
			,[CgoProFlag02]
			,[CgoProFlag03]
			,[CgoProFlag04]
			,[CgoProFlag05]
			,[CgoProFlag06]
			,[CgoProFlag07]
			,[CgoProFlag08]
			,[CgoProFlag09]
			,[CgoProFlag10]
			,[CgoProFlag11]
			,[CgoProFlag12]
			,[CgoProFlag13]
			,[CgoProFlag14]
			,[CgoProFlag15]
			,[CgoProFlag16]
			,[CgoProFlag17]
			,[CgoProFlag18]
			,[CgoProFlag19]
			,[CgoProFlag20])
     VALUES
           (@cargoID
			,@jobID
			,@cgoLineItem
			,@cgoPartNumCode
			,@cgoQtyOrdered
			,@cgoQtyExpected
			,@cgoQtyCounted
			,@cgoQtyDamaged
			,@cgoQtyOnHold
			,@cgoQtyShort
			,@cgoQtyOver
			,@cgoQtyUnits
			,@cgoStatus
			,@cgoInfoID
			,@colorCD
			,@cgoSerialCD
			,@cgoLong
			,@cgoLat
			,@cgoProFlag01
			,@cgoProFlag02
			,@cgoProFlag03
			,@cgoProFlag04
			,@cgoProFlag05
			,@cgoProFlag06
			,@cgoProFlag07
			,@cgoProFlag08
			,@cgoProFlag09
			,@cgoProFlag10
			,@cgoProFlag11
			,@cgoProFlag12
			,@cgoProFlag13
			,@cgoProFlag14
			,@cgoProFlag15
			,@cgoProFlag16
			,@cgoProFlag17
			,@cgoProFlag18
			,@cgoProFlag19
			,@cgoProFlag20) 

		   --SET @currentId = SCOPE_IDENTITY();

	EXEC [dbo].[GetScnCargo] @userId, @roleId,0 ,@currentId 

END TRY              
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[InsScnCargoDetail]    Script Date: 11/26/2018 8:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               08/16/2018      
-- Description:               Ins a ScnCargoDetail 
-- Execution:                 EXEC [dbo].[InsScnCargoDetail]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================

ALTER PROCEDURE  [dbo].[InsScnCargoDetail]
	(@userId BIGINT
	,@roleId BIGINT 
	,@entity NVARCHAR(100)
	,@cargoDetailID BIGINT = NULL
	,@cargoID BIGINT = NULL
	,@detSerialNumber NVARCHAR(255) = NULL
	,@detQtyCounted DECIMAL(18, 2) = NULL
	,@detQtyDamaged  DECIMAL(18, 2) = NULL
	,@detQtyShort  DECIMAL(18, 2) = NULL
	,@detQtyOver  DECIMAL(18, 2) = NULL
	,@detPickStatus NVARCHAR(20) = NULL
	,@detLong NVARCHAR(30) = NULL
	,@detLat NVARCHAR(30) = NULL
	,@enteredBy NVARCHAR(50) = NULL
	,@dateEntered DATETIME2(7) = NULL)
AS
BEGIN TRY                
 SET NOCOUNT ON;   
 
 DECLARE @currentId BIGINT;

 INSERT INTO [dbo].[SCN006CargoDetail]
           ([CargoDetailID]
			,[CargoID]
			,[DetSerialNumber]
			,[DetQtyCounted]
			,[DetQtyDamaged]
			,[DetQtyShort]
			,[DetQtyOver]
			,[DetPickStatus]
			,[DetLong]
			,[DetLat])
     VALUES
           (@cargoDetailID
           ,@cargoID 
           ,@detSerialNumber -- @custItemNumber 
           ,@detQtyCounted  
           ,@detQtyDamaged 
           ,@detQtyShort  
           ,@detQtyOver  
           ,@detPickStatus  
           ,@detLong  
           ,@detLat) 

		   --SET @currentId = SCOPE_IDENTITY();

	EXEC [dbo].[GetScnCargoDetail] @userId, @roleId,0 ,@currentId 
END TRY              
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[InsScnDriverList]    Script Date: 11/26/2018 8:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               08/16/2018      
-- Description:               Ins a ScnDriverList 
-- Execution:                 EXEC [dbo].[InsScnDriverList]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================

ALTER PROCEDURE  [dbo].[InsScnDriverList]
	(@userId BIGINT
	,@roleId BIGINT 
	,@entity NVARCHAR(100)
	,@driverID BIGINT = NULL
	,@firstName NVARCHAR(50) = NULL
	,@lastName NVARCHAR(50) = NULL
	,@programID BIGINT = NULL
	,@locationNumber NVARCHAR(20) = NULL
	,@enteredBy NVARCHAR(50) = NULL
	,@dateEntered DATETIME2(7) = NULL)
AS
BEGIN TRY                
 SET NOCOUNT ON;   

 DECLARE @currentId BIGINT;

 INSERT INTO [dbo].[SCN016DriverList]
           ([DriverID]
           ,[FirstName]
           ,[LastName]
           ,[ProgramID]
           ,[LocationNumber])
     VALUES
           (@driverID
		   ,@firstName
		   ,@lastName
		   ,@programID
		   ,@locationNumber) 
		   --SET @currentId = SCOPE_IDENTITY();
	EXEC [dbo].[GetScnDriverList] @userId, @roleId, 0 ,@driverID 
END TRY              
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[InsScnOrder]    Script Date: 11/26/2018 8:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               08/16/2018      
-- Description:               Ins a ScnOrder 
-- Execution:                 EXEC [dbo].[InsScnOrder]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================

ALTER PROCEDURE  [dbo].[InsScnOrder]
	(@userId BIGINT
	,@roleId BIGINT 
	,@entity NVARCHAR(100)
	,@jobID BIGINT = NULL
	,@programID BIGINT = NULL
	,@routeID INT = NULL
	,@driverID BIGINT = NULL
	,@jobDeviceID NVARCHAR(30) = NULL
	,@jobStop INT = NULL
	,@jobOrderID NVARCHAR(30) = NULL
	,@jobManifestID NVARCHAR(30) = NULL
	,@jobCarrierID NVARCHAR(30) = NULL
	,@jobReturnReasonID INT = NULL
	,@jobStatusCD NVARCHAR(30) = NULL
	,@jobOriginSiteCode NVARCHAR(30) = NULL
	,@jobOriginSiteName NVARCHAR(50) = NULL
	,@jobDeliverySitePOC NVARCHAR(75) = NULL
	,@jobDeliverySitePOC2 NVARCHAR(75) = NULL
	,@jobDeliveryStreetAddress NVARCHAR(100) = NULL
	,@jobDeliveryStreetAddress2 NVARCHAR(100) = NULL
	,@jobDeliveryCity NVARCHAR(50) = NULL
	,@jobDeliveryStateProvince NVARCHAR(50) = NULL
	,@jobDeliveryPostalCode NVARCHAR(50) = NULL
	,@jobDeliveryCountry NVARCHAR(50) = NULL
	,@jobDeliverySitePOCPhone NVARCHAR(50) = NULL
	,@jobDeliverySitePOCPhone2 NVARCHAR(50) = NULL
	,@jobDeliveryPhoneHm  NVARCHAR(50) = NULL
	,@jobDeliverySitePOCEmail NVARCHAR(50) = NULL
	,@jobDeliverySitePOCEmail2 NVARCHAR(50) = NULL
	,@jobOriginStreetAddress NVARCHAR(100) = NULL
	,@jobOriginCity NVARCHAR(50) = NULL
	,@jobOriginStateProvince NVARCHAR(50) = NULL
	,@jobOriginPostalCode NVARCHAR(50) = NULL
	,@jobOriginCountry NVARCHAR(50) = NULL
	,@jobLongitude NVARCHAR(30) = NULL
	,@jobLatitude NVARCHAR(30) = NULL
	,@jobSignLongitude NVARCHAR(30) = NULL
	,@jobSignLatitude NVARCHAR(30) = NULL
	,@jobSignText NVARCHAR(50) = NULL
	,@jobScheduledDate DATETIME2(7) = NULL
	,@jobScheduledTime DATETIME2(7) = NULL
	,@jobEstimatedDate DATETIME2(7) = NULL
	,@jobEstimatedTime DATETIME2(7) = NULL
	,@jobActualDate DATETIME2(7) = NULL
	,@jobActualTime DATETIME2(7) = NULL
	,@colorCD INT = NULL
	,@jobFor NVARCHAR(50) = NULL
	,@jobFrom NVARCHAR(50) = NULL
	,@windowStartTime DATETIME2(7) = NULL
	,@windowEndTime DATETIME2(7) = NULL
	,@jobFlag01 NVARCHAR(1) = NULL
	,@jobFlag02 NVARCHAR(1) = NULL
	,@jobFlag03 NVARCHAR(1) = NULL
	,@jobFlag04 NVARCHAR(1) = NULL
	,@jobFlag05 NVARCHAR(1) = NULL
	,@jobFlag06 NVARCHAR(1) = NULL
	,@jobFlag07 NVARCHAR(1) = NULL
	,@jobFlag08 NVARCHAR(1) = NULL
	,@jobFlag09 NVARCHAR(1) = NULL
	,@jobFlag10 NVARCHAR(1) = NULL
	,@jobFlag11 NVARCHAR(1) = NULL
	,@jobFlag12 NVARCHAR(1) = NULL
	,@jobFlag13 NVARCHAR(1) = NULL
	,@jobFlag14 NVARCHAR(1) = NULL
	,@jobFlag15 NVARCHAR(1) = NULL
	,@jobFlag16 NVARCHAR(1) = NULL
	,@jobFlag17 NVARCHAR(1) = NULL
	,@jobFlag18 NVARCHAR(1) = NULL
	,@jobFlag19 NVARCHAR(1) = NULL
	,@jobFlag20 NVARCHAR(1) = NULL
	,@jobFlag21 INT = NULL
	,@jobFlag22 BIGINT = NULL
	,@jobFlag23 INT = NULL
	,@enteredBy NVARCHAR(50) = NULL
	,@dateEntered DATETIME2(7) = NULL)
AS
BEGIN TRY                
 SET NOCOUNT ON;   
 
 DECLARE @currentId BIGINT;

 INSERT INTO [dbo].[SCN000Order]
           ([JobID]
			,[ProgramID]
			,[RouteID]
			,[DriverID]
			,[JobDeviceID]
			,[JobStop]
			,[JobOrderID]
			,[JobManifestID]
			,[JobCarrierID]
			,[JobReturnReasonID]
			,[JobStatusCD]
			,[JobOriginSiteCode]
			,[JobOriginSiteName]
			,[JobDeliverySitePOC]
			,[JobDeliverySitePOC2]
			,[JobDeliveryStreetAddress]
			,[JobDeliveryStreetAddress2]
			,[JobDeliveryCity]
			,[JobDeliveryStateProvince]
			,[JobDeliveryPostalCode]
			,[JobDeliveryCountry]
			,[JobDeliverySitePOCPhone]
			,[JobDeliverySitePOCPhone2]
			,[JobDeliveryPhoneHm]
			,[JobDeliverySitePOCEmail]
			,[JobDeliverySitePOCEmail2]
			,[JobOriginStreetAddress]
			,[JobOriginCity]
			,[JobOriginStateProvince]
			,[JobOriginPostalCode]
			,[JobOriginCountry]
			,[JobLongitude]
			,[JobLatitude]
			,[JobSignLongitude]
			,[JobSignLatitude]
			,[JobSignText]
			,[JobScheduledDate]
			,[JobScheduledTime]
			,[JobEstimatedDate]
			,[JobEstimatedTime]
			,[JobActualDate]
			,[JobActualTime]
			,[ColorCD]
			,[JobFor]
			,[JobFrom]
			,[WindowStartTime]
			,[WindowEndTime]
			,[JobFlag01]
			,[JobFlag02]
			,[JobFlag03]
			,[JobFlag04]
			,[JobFlag05]
			,[JobFlag06]
			,[JobFlag07]
			,[JobFlag08]
			,[JobFlag09]
			,[JobFlag10]
			,[JobFlag11]
			,[JobFlag12]
			,[JobFlag13]
			,[JobFlag14]
			,[JobFlag15]
			,[JobFlag16]
			,[JobFlag17]
			,[JobFlag18]
			,[JobFlag19]
			,[JobFlag20]
			,[JobFlag21]
			,[JobFlag22]
			,[JobFlag23])
     VALUES
           (@jobID
			,@programID
			,@routeID
			,@driverID
			,@jobDeviceID
			,@jobStop
			,@jobOrderID
			,@jobManifestID
			,@jobCarrierID
			,@jobReturnReasonID
			,@jobStatusCD
			,@jobOriginSiteCode
			,@jobOriginSiteName
			,@jobDeliverySitePOC
			,@jobDeliverySitePOC2
			,@jobDeliveryStreetAddress
			,@jobDeliveryStreetAddress2
			,@jobDeliveryCity
			,@jobDeliveryStateProvince
			,@jobDeliveryPostalCode
			,@jobDeliveryCountry
			,@jobDeliverySitePOCPhone
			,@jobDeliverySitePOCPhone2
			,@jobDeliveryPhoneHm 
			,@jobDeliverySitePOCEmail
			,@jobDeliverySitePOCEmail2
			,@jobOriginStreetAddress
			,@jobOriginCity
			,@jobOriginStateProvince
			,@jobOriginPostalCode
			,@jobOriginCountry
			,@jobLongitude
			,@jobLatitude
			,@jobSignLongitude
			,@jobSignLatitude
			,@jobSignText
			,@jobScheduledDate
			,@jobScheduledTime
			,@jobEstimatedDate
			,@jobEstimatedTime
			,@jobActualDate
			,@jobActualTime
			,@colorCD
			,@jobFor
			,@jobFrom
			,@windowStartTime
			,@windowEndTime
			,@jobFlag01
			,@jobFlag02
			,@jobFlag03
			,@jobFlag04
			,@jobFlag05
			,@jobFlag06
			,@jobFlag07
			,@jobFlag08
			,@jobFlag09
			,@jobFlag10
			,@jobFlag11
			,@jobFlag12
			,@jobFlag13
			,@jobFlag14
			,@jobFlag15
			,@jobFlag16
			,@jobFlag17
			,@jobFlag18
			,@jobFlag19
			,@jobFlag20
			,@jobFlag21
			,@jobFlag22
			,@jobFlag23) 
		   --SET @currentId = SCOPE_IDENTITY();
	EXEC [dbo].[GetScnOrder] @userId, @roleId,0 ,@jobID 
END TRY              
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[InsScnOrderOSD]    Script Date: 11/26/2018 8:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               08/16/2018      
-- Description:               Ins a ScnOrderOSD 
-- Execution:                 EXEC [dbo].[InsScnOrderOSD]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================

ALTER PROCEDURE  [dbo].[InsScnOrderOSD]
	(@userId BIGINT
	,@roleId BIGINT 
	,@entity NVARCHAR(100)
	,@cargoOSDID BIGINT = NULL
	,@oSDID BIGINT = NULL
	,@dateTime DATETIME2(7) = NULL
	,@cargoDetailID BIGINT = NULL
	,@cargoID BIGINT = NULL
	,@cgoSerialNumber NVARCHAR(255) = NULL
	,@oSDReasonID BIGINT = NULL
	,@oSDQty DECIMAL(18, 2) = NULL
	,@notes NVARCHAR(MAX) = NULL
	,@editCD NVARCHAR(50) = NULL
	,@statusID NVARCHAR(30) = NULL
	,@cgoSeverityCode NVARCHAR(20) = NULL
	,@enteredBy NVARCHAR(50) = NULL
	,@dateEntered DATETIME2(7) = NULL)
AS
BEGIN TRY                
 SET NOCOUNT ON;   
 
 DECLARE @currentId BIGINT;

 INSERT INTO [dbo].[SCN014OrderOSD]
           ([CargoOSDID]
			,[OSDID]
			,[DateTime]
			,[CargoDetailID]
			,[CargoID]
			,[CgoSerialNumber]
			,[OSDReasonID]
			,[OSDQty]
			,[Notes]
			,[EditCD]
			,[StatusID]
			,[CgoSeverityCode])
     VALUES
           (@cargoOSDID
			,@oSDID
			,@dateTime
			,@cargoDetailID
			,@cargoID
			,@cgoSerialNumber
			,@oSDReasonID
			,@oSDQty
			,@notes
			,@editCD
			,@statusID
			,@cgoSeverityCode) 
	EXEC [dbo].[GetScnOrderOSD] @userId, @roleId,0 ,@cargoOSDID 
END TRY              
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[InsScnOrderRequirement]    Script Date: 11/26/2018 8:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               08/16/2018      
-- Description:               Ins a ScnOrderRequirement 
-- Execution:                 EXEC [dbo].[InsScnOrderRequirement]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================

ALTER PROCEDURE  [dbo].[InsScnOrderRequirement]
	(@userId BIGINT
	,@roleId BIGINT 
	,@entity NVARCHAR(100)
	,@requirementID BIGINT = NULL
	,@requirementCode NVARCHAR(20) = NULL
	,@jobID BIGINT = NULL
	,@notes NVARCHAR(MAX) = NULL
	,@complete NVARCHAR(1) = NULL
	,@enteredBy NVARCHAR(50) = NULL
	,@dateEntered DATETIME2(7) = NULL)
AS
BEGIN TRY                
 SET NOCOUNT ON;   
 
 DECLARE @currentId BIGINT;

 INSERT INTO [dbo].[SCN015OrderRequirement]
           ([RequirementID]
			,[RequirementCode]
			,[JobID]
			,[Notes]
			,[Complete])
     VALUES
           (@requirementID
           ,@requirementCode 
           ,@jobID
           ,@notes  
           ,@complete) 
		   --SET @currentId = SCOPE_IDENTITY();
	EXEC [dbo].[GetScnOrderRequirement] @userId, @roleId, 0 ,@requirementID 
END TRY              
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[InsScnOrderService]    Script Date: 11/26/2018 8:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               08/16/2018      
-- Description:               Ins a ScnOrderService 
-- Execution:                 EXEC [dbo].[InsScnOrderService]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================

ALTER PROCEDURE  [dbo].[InsScnOrderService]
	(@userId BIGINT
	,@roleId BIGINT 
	,@entity NVARCHAR(100)
	,@servicesID BIGINT = NULL
	,@servicesCode NVARCHAR(50) = NULL
	,@jobID BIGINT = NULL
	,@notes NVARCHAR(MAX) = NULL
	,@complete NVARCHAR(1) = NULL
	,@enteredBy NVARCHAR(50) = NULL
	,@dateEntered DATETIME2(7) = NULL)
AS
BEGIN TRY                
 SET NOCOUNT ON;   
 
 DECLARE @currentId BIGINT;

 INSERT INTO [dbo].[SCN013OrderServices]
           ([ServicesID]
			,[ServicesCode]
			,[JobID]
			,[Notes]
			,[Complete])
     VALUES
           (@servicesID
           ,@servicesCode 
           ,@jobID
           ,@notes  
           ,@complete) 

		   --SET @currentId = SCOPE_IDENTITY();

	EXEC [dbo].[GetScnOrderService] @userId, @roleId,0 ,@servicesID 
END TRY              
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[InsScnRouteList]    Script Date: 11/26/2018 8:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               08/16/2018      
-- Description:               Ins a ScnRouteList 
-- Execution:                 EXEC [dbo].[InsScnRouteList]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================

ALTER PROCEDURE  [dbo].[InsScnRouteList]
	(@userId BIGINT
	,@roleId BIGINT 
	,@entity NVARCHAR(100)
	,@routeID BIGINT = NULL
	,@routeName NVARCHAR(50) = NULL
	,@programID BIGINT = NULL
	,@enteredBy NVARCHAR(50) = NULL
	,@dateEntered DATETIME2(7) = NULL)
AS
BEGIN TRY                
 SET NOCOUNT ON;   
 
 DECLARE @currentId BIGINT;

 INSERT INTO [dbo].[SCN016RouteList]
           ([RouteID]
           ,[RouteName]
           ,[ProgramID])
     VALUES
           (@routeID
			,@routeName
			,@programID) 

		   --SET @currentId = SCOPE_IDENTITY();

	EXEC [dbo].[GetScnRouteList] @userId, @roleId, 0 ,@routeID 
END TRY              
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[InsScrCatalogList]    Script Date: 11/26/2018 8:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               10/29/2018      
-- Description:               Ins a Scr Catalog List
-- Execution:                 EXEC [dbo].[InsScrCatalogList]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================
ALTER PROCEDURE  [dbo].[InsScrCatalogList]		  
	@userId BIGINT
	,@roleId BIGINT 
	,@entity NVARCHAR(100)
	,@catalogProgramID bigint = NULL
	,@catalogItemNumber int = NULL
	,@catalogCode nvarchar(20) = NULL
	,@catalogTitle nvarchar(50) = NULL
	,@catalogCustCode nvarchar(20) = NULL
	,@catalogUoMCode	nvarchar(20) = NULL
	,@catalogCubes	DECIMAL(18,2) = NULL
	,@catalogWidth	DECIMAL(18,2) = NULL
	,@catalogLength	DECIMAL(18,2) = NULL
	,@catalogHeight	DECIMAL(18,2) = NULL
	,@catalogWLHUoM	nvarchar(20) = NULL
	,@catalogWeight	nvarchar(20) = NULL
	,@statusId int = NULL
	,@dateEntered datetime2(7)
	,@enteredBy nvarchar(50)
AS
BEGIN TRY                
 SET NOCOUNT ON;  
 DECLARE @updatedItemNumber INT      
  EXEC [dbo].[ResetItemNumber] @userId, 0, @catalogProgramID, @entity, @catalogItemNumber, @statusId, NULL, NULL,  @updatedItemNumber OUTPUT   
 DECLARE @currentId BIGINT;
   INSERT INTO [dbo].[SCR010CatalogList]
           ([CatalogProgramID]
			,[CatalogItemNumber]
			,[CatalogCode]
			,[CatalogTitle]
			,[CatalogCustCode]
			,[CatalogUoMCode]
            ,[CatalogCubes]
            ,[CatalogWidth]
            ,[CatalogLength]
            ,[CatalogHeight]
            ,[CatalogWLHUoM]
			,[CatalogWeight]
			,[StatusId]
			,[DateEntered]
			,[EnteredBy]) 
     VALUES
		   (@catalogProgramID
			,@updatedItemNumber
			,@catalogCode
			,@catalogTitle
			,@catalogCustCode
			,@catalogUoMCode
            --,@catalogCubes 
			,(@catalogWidth * @catalogLength * @catalogHeight)
            ,@catalogWidth
            ,@catalogLength
            ,@catalogHeight
            ,@catalogWLHUoM
			,@catalogWeight
			,@statusId
			,@dateEntered
			,@enteredBy)  		
	SET @currentId = SCOPE_IDENTITY();

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
  WHERE scr.[Id]=@currentId;


END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[InsScrGatewayList]    Script Date: 11/26/2018 8:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               08/16/2018      
-- Description:               Ins a ScrGatewayList 
-- Execution:                 EXEC [dbo].[InsScrGatewayList]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================

ALTER PROCEDURE  [dbo].[InsScrGatewayList]
	(@userId BIGINT
	,@roleId BIGINT 
	,@entity NVARCHAR(100)
	,@gatewayStatusID BIGINT = NULL
	,@programID BIGINT = NULL
	,@gatewayCode NVARCHAR(20) = NULL
	,@enteredBy NVARCHAR(50) = NULL
	,@dateEntered DATETIME2(7) = NULL)
AS
BEGIN TRY                
 SET NOCOUNT ON;   
 
 DECLARE @currentId BIGINT;

 INSERT INTO [dbo].[SCR016GatewayList]
           ([GatewayStatusID]
			,[ProgramID]
			,[GatewayCode])
     VALUES
           (@gatewayStatusID
           ,@programID 
           ,@gatewayCode)
		    
		   --SET @currentId = SCOPE_IDENTITY();

	EXEC [dbo].[GetScrGatewayList] @userId, @roleId, 0 ,@gatewayStatusID 
END TRY              
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[InsScrInfoList]    Script Date: 11/26/2018 8:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               08/16/2018      
-- Description:               Ins a ScrInfoList 
-- Execution:                 EXEC [dbo].[InsScrInfoList]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================

ALTER PROCEDURE  [dbo].[InsScrInfoList]
	(@userId BIGINT
	,@roleId BIGINT 
	,@entity NVARCHAR(100)
	,@infoListID BIGINT = NULL
	,@infoListDesc NVARCHAR(MAX) = NULL
	,@enteredBy NVARCHAR(50) = NULL
	,@dateEntered DATETIME2(7) = NULL)
AS
BEGIN TRY                
 SET NOCOUNT ON;   
 
 DECLARE @currentId BIGINT;

 INSERT INTO [dbo].[SCR010InfoList]
           ([InfoListID]
           ,[InfoListDesc])
     VALUES
           (@infoListID
           ,@infoListDesc) 

		   --SET @currentId = SCOPE_IDENTITY();

	EXEC [dbo].[GetScrInfoList] @userId, @roleId,0 ,@infoListID 
END TRY              
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[InsScrOsdList]    Script Date: 11/26/2018 8:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               10/29/2018      
-- Description:               Ins a Scr Osd List
-- Execution:                 EXEC [dbo].[InsScrOsdList]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- ============================================= 
ALTER PROCEDURE  [dbo].[InsScrOsdList]		  
	@userId BIGINT
	,@roleId BIGINT 
	,@entity NVARCHAR(100)
	,@programID bigint = NULL
	,@osdItemNumber int = NULL
	,@osdCode nvarchar(20) = NULL
	,@osdTitle nvarchar(50) = NULL
	,@oSDType nvarchar(20) = NULL
	,@statusId int = NULL
	,@dateEntered datetime2(7)
	,@enteredBy nvarchar(50)
AS
BEGIN TRY                
 SET NOCOUNT ON;   
  DECLARE @updatedItemNumber INT      
 EXEC [dbo].[ResetItemNumber] @userId, 0, @programID, @entity, @osdItemNumber, @statusId, NULL, NULL,  @updatedItemNumber OUTPUT

 DECLARE @currentId BIGINT;
   INSERT INTO [dbo].[SCR011OSDList]
           ([ProgramID]
			,[OSDItemNumber]
			,[OSDCode]
			,[OSDTitle]
			,[OSDType]
			,[StatusId]
			,[DateEntered]
			,[EnteredBy]) 
     VALUES
		   (@programID
			,@updatedItemNumber
			,@osdCode
			,@osdTitle
			,@oSDType
			,@statusId
			,@dateEntered
			,@enteredBy)  		
	SET @currentId = SCOPE_IDENTITY();

	EXEC GetScrOsdList @userId,@roleId,0,@currentId;

END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[InsScrOsdReasonList]    Script Date: 11/26/2018 8:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               10/29/2018      
-- Description:               Ins a Scr Osd Reason List
-- Execution:                 EXEC [dbo].[InsScrOsdReasonList]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- ============================================= 
ALTER PROCEDURE  [dbo].[InsScrOsdReasonList]		  
	@userId BIGINT
	,@roleId BIGINT 
	,@entity NVARCHAR(100)
	,@programID bigint = NULL
	,@reasonItemNumber int = NULL
	,@reasonIDCode nvarchar(20) = NULL
	,@reasonTitle nvarchar(50) = NULL
	,@statusId int = NULL
	,@dateEntered datetime2(7)
	,@enteredBy nvarchar(50)
AS
BEGIN TRY                
 SET NOCOUNT ON;  
  DECLARE @updatedItemNumber INT      
 EXEC [dbo].[ResetItemNumber] @userId, 0, @programID, @entity, @reasonItemNumber, @statusId, NULL, NULL,  @updatedItemNumber OUTPUT 
 DECLARE @currentId BIGINT;
   INSERT INTO [dbo].[SCR011OSDReasonList]
           ( [ProgramID]
			,[ReasonItemNumber]
			,[ReasonIDCode]
			,[ReasonTitle]
			,[StatusId]
			,[DateEntered]
			,[EnteredBy]) 
     VALUES
		   ( @programID
			,@updatedItemNumber
			,@reasonIDCode
			,@reasonTitle
			,@statusId
			,@dateEntered
			,@enteredBy)  		
	SET @currentId = SCOPE_IDENTITY();
	
	EXEC GetScrOsdReasonList @userId,@roleId,0,@currentId;

END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[InsScrRequirementList]    Script Date: 11/26/2018 8:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               10/29/2018      
-- Description:               Ins a Scr Requirement List
-- Execution:                 EXEC [dbo].[InsScrRequirementList]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================
ALTER PROCEDURE  [dbo].[InsScrRequirementList]		  
	@userId BIGINT
	,@roleId BIGINT 
	,@entity NVARCHAR(100)
	,@programID bigint = NULL
	,@requirementLineItem int = NULL
	,@requirementCode nvarchar(20) = NULL
	,@requirementTitle nvarchar(50) = NULL
	,@statusId int = NULL
	,@dateEntered datetime2(7)
	,@enteredBy nvarchar(50)
AS
BEGIN TRY                
 SET NOCOUNT ON;   
  DECLARE @updatedItemNumber INT      
 EXEC [dbo].[ResetItemNumber] @userId, 0, @programID, @entity, @requirementLineItem, @statusId, NULL, NULL,  @updatedItemNumber OUTPUT
 DECLARE @currentId BIGINT;
   INSERT INTO [dbo].[SCR012RequirementList]
           ([ProgramID]
			,[RequirementLineItem]
			,[RequirementCode]
			,[RequirementTitle]
			,[StatusId]
			,[DateEntered]
			,[EnteredBy]) 
     VALUES
		   (@programID
			,@updatedItemNumber
			,@requirementCode
			,@requirementTitle
			,@statusId
			,@dateEntered
			,@enteredBy)  		
	SET @currentId = SCOPE_IDENTITY();
	EXEC GetScrRequirementList @userId, @roleId, 0, @currentId;
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[InsScrReturnReasonList]    Script Date: 11/26/2018 8:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               10/29/2018      
-- Description:               Ins a Scr Return Reason List
-- Execution:                 EXEC [dbo].[InsScrReturnReasonList]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================
ALTER PROCEDURE  [dbo].[InsScrReturnReasonList]		  
	@userId BIGINT
	,@roleId BIGINT 
	,@entity NVARCHAR(100)
	,@programID bigint = NULL
	,@returnReasonLineItem int = NULL
	,@returnReasonCode nvarchar(20) = NULL
	,@returnReasonTitle nvarchar(50) = NULL
	,@statusId nvarchar(20) = NULL
	,@dateEntered datetime2(7)
	,@enteredBy nvarchar(50)
AS
BEGIN TRY                
 SET NOCOUNT ON; 
 DECLARE @updatedItemNumber INT      
 EXEC [dbo].[ResetItemNumber] @userId, 0, @programID, @entity, @returnReasonLineItem, @statusId, NULL, NULL,  @updatedItemNumber OUTPUT  
 DECLARE @currentId BIGINT;
   INSERT INTO [dbo].[SCR014ReturnReasonList]
           (ProgramID
			,ReturnReasonLineItem
			,ReturnReasonCode
			,ReturnReasonTitle
			,StatusId
			,DateEntered
			,EnteredBy) 
     VALUES
		   (@programID
			,@updatedItemNumber
			,@returnReasonCode
			,@returnReasonTitle
			,@statusId
			,@dateEntered
			,@enteredBy)  		
	SET @currentId = SCOPE_IDENTITY();
	EXEC GetScrReturnReasonList @userId, @roleId, 0, @currentId;  
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[InsScrServiceList]    Script Date: 11/26/2018 8:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               10/29/2018      
-- Description:               Ins a Scr Service List
-- Execution:                 EXEC [dbo].[InsScrServiceList]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================
ALTER PROCEDURE  [dbo].[InsScrServiceList]		  
	@userId BIGINT
	,@roleId BIGINT 
	,@entity NVARCHAR(100)
	,@programID bigint = NULL
	,@serviceLineItem int = NULL
	,@serviceCode nvarchar(20) = NULL
	,@serviceTitle nvarchar(50) = NULL
	,@statusId int = NULL
	,@dateEntered datetime2(7)
	,@enteredBy nvarchar(50)
AS
BEGIN TRY                
 SET NOCOUNT ON; 
 DECLARE @updatedItemNumber INT      
   EXEC [dbo].[ResetItemNumber] @userId, 0, @programID, @entity, @serviceLineItem, @statusId, NULL, NULL,  @updatedItemNumber OUTPUT
   
 DECLARE @currentId BIGINT;
   INSERT INTO [dbo].[SCR013ServiceList]
           ([ProgramID]
			,[ServiceLineItem]
			,[ServiceCode]
			,[ServiceTitle]
			,[StatusId]
			,[DateEntered]
			,[EnteredBy]) 
     VALUES
		   (@programID
			,@updatedItemNumber
			,@serviceCode
			,@serviceTitle
			,@statusId
			,@dateEntered
			,@enteredBy)  		
	SET @currentId = SCOPE_IDENTITY();
	
	EXEC GetScrServiceList @userId, @roleId, 0, @currentId

END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[InsSecurityByRole]    Script Date: 11/26/2018 8:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               09/22/2018      
-- Description:               Ins a security by role
-- Execution:                 EXEC [dbo].[InsSecurityByRole]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================  
  
ALTER PROCEDURE  [dbo].[InsSecurityByRole]  
	(@userId BIGINT  
	,@roleId BIGINT 
	,@entity NVARCHAR(100)  
	,@orgId bigint 
	,@secLineOrder int  = NULL  
	,@mainModuleId int  
	,@menuOptionLevelId int  
	,@menuAccessLevelId int  
	,@statusId int = NULL  
	,@actRoleId BIGINT
	,@dateEntered datetime2(7)  
	,@enteredBy nvarchar(50)  
)  
AS  
BEGIN TRY                  
 SET NOCOUNT ON;     
 DECLARE @updatedItemNumber INT
 DECLARE @currentId BIGINT;  
 SELECT TOP 1 @secLineOrder = [SecLineOrder] + 1 FROM [dbo].[SYSTM000SecurityByRole]  WHERE  [OrgRefRoleId] = @actRoleId ORDER BY SecLineOrder DESC
 SET @secLineOrder = ISNULL(@secLineOrder, 1)
EXEC [dbo].[ResetItemNumber] @userId, 0, @actRoleId, @entity, @secLineOrder, @statusId, NULL, NULL,  @updatedItemNumber OUTPUT  
 INSERT INTO [dbo].[SYSTM000SecurityByRole]  
           (
   [OrgRefRoleId]
   ,[SecLineOrder]  
   ,[SecMainModuleId]  
   ,[SecMenuOptionLevelId]  
   ,[SecMenuAccessLevelId]  
   ,[StatusId]  
   ,[DateEntered]  
   ,[EnteredBy])  
     VALUES  
           (
      @actRoleId
      ,@updatedItemNumber   
      ,@mainModuleId  
      ,@menuOptionLevelId  
      ,@menuAccessLevelId  
   ,@statusId  
      ,@dateEntered  
      ,@enteredBy)   
   SET @currentId = SCOPE_IDENTITY(); 
   
   EXECUTE  GetSecurityByRole @userId,@roleId,@orgId,@currentId;
 
END TRY                
BEGIN CATCH                  
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                  
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                  
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                  
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                  
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[InsSubSecurityByRole]    Script Date: 11/26/2018 8:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               09/22/2018      
-- Description:               Ins a subsecurity by role 
-- Execution:                 EXEC [dbo].[InsSubSecurityByRole]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- ============================================= 

ALTER PROCEDURE  [dbo].[InsSubSecurityByRole]
	(@userId BIGINT
	,@roleId BIGINT 
	,@entity NVARCHAR(100)
	,@secByRoleId bigint
	,@refTableName nvarchar(100)
	,@menuOptionLevelId int
	,@menuAccessLevelId int
	,@statusId int
	,@dateEntered datetime2(7)
	,@enteredBy nvarchar(50))
AS
BEGIN TRY                
 SET NOCOUNT ON;   
 DECLARE @currentId BIGINT;
 INSERT INTO [dbo].[SYSTM010SubSecurityByRole]
            ([SecByRoleId]
           ,[RefTableName]
           ,[SubsMenuOptionLevelId]
           ,[SubsMenuAccessLevelId]
           ,[StatusId]
           ,[DateEntered]
           ,[EnteredBy])
     VALUES
           (@secByRoleId
		   	,@refTableName
		   	,@menuOptionLevelId
		   	,@menuAccessLevelId
		   	,@statusId
		   	,@dateEntered
		   	,@enteredBy
		   ) 
		   SET @currentId = SCOPE_IDENTITY();
	SELECT * FROM [dbo].[SYSTM010SubSecurityByRole] WHERE Id = @currentId;
END TRY              
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[InsSysAdminAccessSBR]    Script Date: 11/26/2018 8:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Janardana        
-- Create date:               03/30/2018      
-- Description:               Insert System Admin FullRole TO SBR
-- Execution:                 EXEC [dbo].[InsSysAdminAccessSBR]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================    
ALTER PROCEDURE  [dbo].[InsSysAdminAccessSBR]     
	 --@userId BIGINT,    
	 @orgId BIGINT,    
	 @roleId BIGINT,
	 @enteredBy NVARCHAR(50)  
AS    
BEGIN TRY                    
 SET NOCOUNT ON;  

	 INSERT INTO [dbo].[SYSTM000SecurityByRole]
           (
           [OrgRefRoleId]
           ,[SecLineOrder]
           ,[SecMainModuleId]
           ,[SecMenuOptionLevelId]
           ,[SecMenuAccessLevelId]
           ,[StatusId]
           ,[DateEntered]
           ,[EnteredBy]
           )

		   SELECT
		   @roleId as RoleId
		   ,ROW_NUMBER() OVER( ORDER By Id)
	       ,Id as SecMainModuleId,
		    27 as SecMenuOptionLevelId,
		    21 as SecMenuAccessLevelId
		   ,1
		   ,GETUTCDATE()
		   ,@enteredBy
	    FROM [dbo].[SYSTM000Ref_Options] WHERE SysLookupId = 22 AND Id <> 178;
END TRY                    
BEGIN CATCH                    
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                    
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                    
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                    
     
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                    
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[InsSysRefOption]    Script Date: 11/26/2018 8:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan             
-- Create date:               08/16/2018      
-- Description:               Ins a Sys Ref Option
-- Execution:                 EXEC [dbo].[InsSysRefOption]
-- Modified on:               Janardana
-- Modified Desc:			  Added lookupname and Inserting into refTable 
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)
-- =============================================    
ALTER PROCEDURE  [dbo].[InsSysRefOption]        
	@userId BIGINT    
	,@roleId BIGINT 
	,@entity NVARCHAR(100)    
	,@langCode NVARCHAR(10)    
	,@lookupId int 
	,@lookupName NVARCHAR(100)     
	,@sysOptionName nvarchar(100)    
	,@sysSortOrder int    
	,@sysDefault bit
	,@isSysAdmin bit        
	,@statusId int = null  
	,@dateEntered datetime2(7)    
	,@enteredBy nvarchar(50)  
AS    
BEGIN TRY                    
 SET NOCOUNT ON;    
   
  DECLARE @updatedItemNumber INT        
  DECLARE @where NVARCHAR(MAX) =    ' AND SysLookupId ='''  +  CAST(@lookupId AS VARCHAR)+''''  
  EXEC [dbo].[ResetItemNumber] @userId, 0, NULL, @entity, @sysSortOrder, @statusId, NULL, @where,  @updatedItemNumber OUTPUT   
      
 DECLARE @currentId INT;    
       
   --INSERT INTO REF TABLE If @lookupName NOt EXISTS   
     
           
 IF NOT EXISTS( SELECT Id FROM SYSTM000Ref_Lookup WHERE LkupCode=@lookupName)    
 BEGIN    
        INSERT INTO [dbo].[SYSTM000Ref_Lookup](LkupCode,LkupTableName) VALUES(@lookupId,'Global');   
		SET @lookupId = SCOPE_IDENTITY(); 
 END    
    
       
    
   INSERT INTO [dbo].[SYSTM000Ref_Options]    
           ([SysLookupId]  
		   ,[SysLookupCode]  
   ,[SysOptionName]    
   ,[SysSortOrder]    
   ,[SysDefault]   
   ,[IsSysAdmin]
   ,[StatusId]   
   ,[DateEntered]    
   ,[EnteredBy] )      
      VALUES    
     (@lookupId  
	 , @lookupName
      ,@sysOptionName    
      ,@updatedItemNumber    
      ,@sysDefault   
	  ,@isSysAdmin 
   ,@statusId  
      ,@dateEntered    
      ,@enteredBy)     
   SET @currentId = SCOPE_IDENTITY();    
    
 --  --UPDATE Column Alias    
    
 --  IF @entity IS NOT NULL AND @entityColumn IS NOT NULL    
 --  BEGIN    
 --   UPDATE SYSTM000ColumnsAlias     
 --SET ColLookupId = @lookupId  
 --WHERE  ColTableName  = @entity      
 --         AND ColColumnName  = @entityColumn;      
 --   END    
    
 SELECT * FROM [dbo].[SYSTM000Ref_Options] WHERE Id = @currentId;    
END TRY        
BEGIN CATCH                    
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                    
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                    
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                    
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                    
END CATCH    
    
    
    
/***** Object:  StoredProcedure [dbo].[UpdSysRefOption]    Script Date: 8/16/2017 1:30:20 PM *****/    
SET ANSI_NULLS ON
GO
/****** Object:  StoredProcedure [dbo].[InsSysRefTabPageName]    Script Date: 11/26/2018 8:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               09/22/2018      
-- Description:               Ins a Sys ref tab page name
-- Execution:                 EXEC [dbo].[InsSysRefTabPageName]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================
ALTER PROCEDURE  [dbo].[InsSysRefTabPageName]
	@userId BIGINT
	,@roleId BIGINT 
	,@entity NVARCHAR(100)
	,@langCode NVARCHAR(10)
	,@refTableName nvarchar(100)
	,@tabSortOrder int
	,@tabTableName nvarchar(100)
	,@tabPageTitle nvarchar(50)
	,@tabExecuteProgram nvarchar(50)
	,@statusId int = null
	,@dateEntered datetime2(7)
	,@enteredBy nvarchar(50)
AS
BEGIN TRY                
 SET NOCOUNT ON; 

 

  DECLARE @updatedItemNumber INT      
 DECLARE @where NVARCHAR(MAX) = ' AND RefTableName = '  + @refTableName;   
  EXEC [dbo].[ResetItemNumber] @userId, 0, NULL, @entity, @tabSortOrder, @statusId, NULL, @where,  @updatedItemNumber OUTPUT
   
 DECLARE @currentId BIGINT;
   INSERT INTO [dbo].[SYSTM030Ref_TabPageName]
           ( [RefTableName]
			,[LangCode]
			,[TabSortOrder]
			,[TabTableName]
			,[TabPageTitle]
			,[TabExecuteProgram]
			,[StatusId]
			,[DateEntered]
			,[EnteredBy] )  
      VALUES
		   (@refTableName
		   	,@langCode
		   	,@updatedItemNumber
		   	,@tabTableName
			,@tabPageTitle
		   	,@tabExecuteProgram
			,@statusId
		   	,@dateEntered
		   	,@enteredBy) 
			SET @currentId = SCOPE_IDENTITY();
	SELECT * FROM [dbo].[SYSTM030Ref_TabPageName] WHERE Id = @currentId;
END TRY    
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH



/***** Object:  StoredProcedure [dbo].[UpdSysRefTabPageName]    Script Date: 8/16/2017 1:30:20 PM *****/
SET ANSI_NULLS ON
GO
/****** Object:  StoredProcedure [dbo].[InsSystemAccount]    Script Date: 11/26/2018 8:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Janardana Behara       
-- Create date:               12/17/2018      
-- Description:               Ins a System Account
-- Execution:                 EXEC [dbo].[InsSystemAccount]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================   
ALTER PROCEDURE  [dbo].[InsSystemAccount]      
	@userId BIGINT  
	,@roleId BIGINT 
	,@entity NVARCHAR(100)  
	,@orgId BIGINT = NULL  
	,@sysUserContactId BIGINT = NULL   
	,@sysScreenName NVARCHAR(50) = NULL 
	,@sysPassword NVARCHAR(250) = NULL   
	,@sysOrgId BIGINT = NULL   
	,@actRoleId BIGINT = NULL   
	,@isSysAdmin BIT = NULL 
	,@sysAttempts INT = NULL
	,@statusId INT = NULL      
	,@dateEntered DATETIME2(7) = NULL  
	,@enteredBy NVARCHAR(50) = NULL       
AS  
BEGIN TRY                  
 SET NOCOUNT ON;     
 DECLARE @currentId BIGINT;  
   INSERT INTO [dbo].[SYSTM000OpnSezMe]
            (  [SysUserContactID]
			  ,[SysScreenName]
			  ,[SysPassword]
			  ,[SysOrgId]
			  ,[SysOrgRefRoleId]
			  ,[IsSysAdmin]
			  ,[SysAttempts]
			  ,[StatusId]
			  ,[DateEntered]
			  ,[EnteredBy]			 
			  )  
     VALUES  
      (     @sysUserContactId 
	       ,@sysScreenName
           ,@sysPassword 
           ,@sysOrgId 
           ,@actRoleId
           ,@isSysAdmin
		   ,@sysAttempts		  
		   ,@statusId
		   ,@dateEntered
		   ,@enteredBy)    
 SET @currentId = SCOPE_IDENTITY();  

 --INSERT sezme user into security tables
 INSERT INTO [Security].[AUTH050_UserPassword](UserId,[Password],UpdatedBy,UpdatedDatetime) Values (@currentId,@sysPassword,@userId,GETUTCDATE())

 EXEC [dbo].[InsOrUpdOrgActRole] @userId, @roleId, @actRoleId, @sysOrgId, @sysUserContactId, @statusId, @dateEntered, @enteredBy

 SELECT * FROM [dbo].[SYSTM000OpnSezMe] WHERE Id = @currentId;  
END TRY                  
BEGIN CATCH                  
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                  
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                  
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                  
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                  
END CATCH  
  
  
  
/***** Object:  StoredProcedure [dbo].[UpdOrgCredential]    Script Date: 8/16/2017 1:30:20 PM *****/  
SET ANSI_NULLS ON
GO
/****** Object:  StoredProcedure [dbo].[InsSystemMessage]    Script Date: 11/26/2018 8:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan    
-- Create date:               09/22/2018      
-- Description:               Ins a system message
-- Execution:                 EXEC [dbo].[InsSystemMessage]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================

ALTER PROCEDURE  [dbo].[InsSystemMessage]
	(@userId BIGINT
	,@roleId BIGINT 
	,@entity NVARCHAR(100)
	,@langCode NVARCHAR(10)
	,@sysMessageCode nvarchar(25)
	,@sysRefId int
	,@sysMessageScreenTitle nvarchar(50)
	,@sysMessageTitle nvarchar(50)
	,@sysMessageDescription nvarchar(MAX)
	,@sysMessageInstruction nvarchar(MAX)
	,@sysMessageButtonSelection nvarchar(100)
	,@statusId INT = NULL      
	,@dateEntered datetime2(7)
	,@enteredBy nvarchar(50))
AS
BEGIN TRY                
 SET NOCOUNT ON;   
 DECLARE @currentId BIGINT;
 INSERT INTO [dbo].[SYSTM000Master]
           ([LangCode]
			,[SysMessageCode]
			,[SysRefId]
			,[SysMessageScreenTitle]
			,[SysMessageTitle]
			,[SysMessageDescription]
			,[SysMessageInstruction]
			,[SysMessageButtonSelection]
			,[StatusId]
			,[DateEntered]
			,[EnteredBy])
     VALUES
           (@langCode
			,@sysMessageCode
			,@sysRefId
			,@sysMessageScreenTitle
			,@sysMessageTitle
			,@sysMessageDescription
			,@sysMessageInstruction
			,@sysMessageButtonSelection
			,@statusId
			,@dateEntered
			,@enteredBy) 
			SET @currentId = SCOPE_IDENTITY();
	SELECT * FROM [dbo].[SYSTM000Master] WHERE Id = @currentId;
END TRY              
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[InsSysZipCode]    Script Date: 11/26/2018 8:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan    
-- Create date:               08/16/2018      
-- Description:               Ins a Sys ZipCode
-- Execution:                 EXEC [dbo].[InsSysZipCode]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================
ALTER PROCEDURE  [dbo].[InsSysZipCode]		  
	@userId BIGINT
	,@roleId BIGINT 
	,@entity NVARCHAR(100)
	,@zipcode NVARCHAR(15) 
	,@zipCity NVARCHAR(50) = NULL
	,@zipState NVARCHAR(50) = NULL 
	,@zipLatitude FLOAT = NULL 
	,@zipLongitude FLOAT = NULL 
	,@zipTimezone FLOAT = NULL 
	,@zipDST FLOAT = NULL 
	,@mrktID INT = NULL 
	,@dateEntered DATETIME2(7) = NULL 
	,@enteredBy NVARCHAR(50) = NULL   
AS
BEGIN TRY                
 SET NOCOUNT ON;   
 DECLARE @currentId NVARCHAR(15);
   INSERT INTO [dbo].[SYSTM000ZipcodeMaster]
           ([Zipcode]
           ,[ZipCity]
           ,[ZipState]
           ,[ZipLatitude]
           ,[ZipLongitude]
           ,[ZipTimezone]
           ,[ZipDST]
           ,[MrktID]
           ,[DateEntered]
           ,[EnteredBy] )  
      VALUES
		   (@zipcode 
           ,@zipCity  
           ,@zipState  
           ,@zipLatitude 
           ,@zipLongitude  
           ,@zipTimezone   
           ,@zipDST   
           ,@mrktID 
           ,@dateEntered   
           ,@enteredBy)  
		   SET @currentId = SCOPE_IDENTITY();
	SELECT * FROM [dbo].[SYSTM000ZipcodeMaster] WHERE Zipcode = @currentId;  
END TRY    
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH





/***** Object:  StoredProcedure [dbo].[UpdUsrSetUser]    Script Date: 8/16/2017 1:30:20 PM *****/
SET ANSI_NULLS ON
GO
/****** Object:  StoredProcedure [dbo].[InsValidation]    Script Date: 11/26/2018 8:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               08/16/2018      
-- Description:               Ins a Sys Validation 
-- Execution:                 EXEC [dbo].[InsValidation]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================
ALTER PROCEDURE  [dbo].[InsValidation]		  
	@userId BIGINT
	,@roleId BIGINT 
	,@entity NVARCHAR(100)
	,@langCode NVARCHAR(10)
	,@valTableName NVARCHAR(100) 
	,@refTabPageId BIGINT 
	,@valFieldName NVARCHAR(50) = NULL
	,@valRequired BIT  = NULL
	,@valRequiredMessage NVARCHAR(255)  = NULL
	,@valUnique BIT  = NULL
	,@valUniqueMessage NVARCHAR(255)  = NULL
	,@valRegExLogic0 NVARCHAR(255) = NULL 
	,@valRegEx1 NVARCHAR(255) = NULL 
	,@valRegExMessage1 NVARCHAR(255)  = NULL
	,@valRegExLogic1 NVARCHAR(255)  = NULL
	,@valRegEx2 NVARCHAR(255)  = NULL
	,@valRegExMessage2 NVARCHAR(255) = NULL 
	,@valRegExLogic2 NVARCHAR(255) = NULL 
	,@valRegEx3 NVARCHAR(255) = NULL 
	,@valRegExMessage3 NVARCHAR(255)  = NULL
	,@valRegExLogic3 NVARCHAR(255) = NULL 
	,@valRegEx4 NVARCHAR(255)  = NULL
	,@valRegExMessage4 NVARCHAR(255) = NULL 
	,@valRegExLogic4 NVARCHAR(255) = NULL 
	,@valRegEx5 NVARCHAR(255)  = NULL
	,@valRegExMessage5 NVARCHAR(255)  = NULL
	,@statusId INT = NULL      
	,@dateEntered DATETIME2(7) = NULL 
	,@enteredBy NVARCHAR(50)  = NULL 
AS
BEGIN TRY                
 SET NOCOUNT ON;   
 DECLARE @currentId BIGINT;
   INSERT INTO [dbo].[SYSTM000Validation]
           ([LangCode]
           ,[ValTableName]
           ,[RefTabPageId]
           ,[ValFieldName]
           ,[ValRequired]
           ,[ValRequiredMessage]
           ,[ValUnique]
           ,[ValUniqueMessage]
           ,[ValRegExLogic0]
           ,[ValRegEx1]
           ,[ValRegExMessage1]
           ,[ValRegExLogic1]
           ,[ValRegEx2]
           ,[ValRegExMessage2]
           ,[ValRegExLogic2]
           ,[ValRegEx3]
           ,[ValRegExMessage3]
           ,[ValRegExLogic3]
           ,[ValRegEx4]
           ,[ValRegExMessage4]
           ,[ValRegExLogic4]
           ,[ValRegEx5]
           ,[ValRegExMessage5]
		   ,[StatusId]
           ,[DateEntered]
           ,[EnteredBy] )
     VALUES
		   (@langCode 
           ,@valTableName  
           ,ISNULL(@refTabPageId,0)  
           ,@valFieldName  
           ,@valRequired  
           ,@valRequiredMessage  
           ,@valUnique 
           ,@valUniqueMessage 
           ,@valRegExLogic0  
           ,@valRegEx1 
           ,@valRegExMessage1 
           ,@valRegExLogic1  
           ,@valRegEx2  
           ,@valRegExMessage2  
           ,@valRegExLogic2  
           ,@valRegEx3  
           ,@valRegExMessage3   
           ,@valRegExLogic3   
           ,@valRegEx4  
           ,@valRegExMessage4  
           ,@valRegExLogic4  
           ,@valRegEx5 
           ,@valRegExMessage5  
		   ,@statusId
           ,@dateEntered  
           ,@enteredBy )  
		   SET @currentId = SCOPE_IDENTITY();
	SELECT * FROM [dbo].[SYSTM000Validation] WHERE Id = @currentId;
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH



/***** Object:  StoredProcedure [dbo].[UpdSysValidation]    Script Date: 8/16/2017 1:30:20 PM *****/
SET ANSI_NULLS ON
GO
/****** Object:  StoredProcedure [dbo].[InsVendBusinessTerm]    Script Date: 11/26/2018 8:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               08/16/2018      
-- Description:               Ins a Vend Business Term
-- Execution:                 EXEC [dbo].[InsVendBusinessTerm]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- ============================================= 
ALTER PROCEDURE  [dbo].[InsVendBusinessTerm]
	@userId BIGINT
	,@roleId BIGINT 
	,@entity NVARCHAR(100)
	,@langCode NVARCHAR(10)
	,@vbtOrgId BIGINT = NULL
	,@vbtVendorId BIGINT = NULL 
	,@vbtItemNumber INT  = NULL
	,@vbtCode NVARCHAR(20)  = NULL
	,@vbtTitle NVARCHAR(50)  = NULL
	,@businessTermTypeId INT  = NULL
	,@vbtActiveDate DATETIME2(7)  = NULL
	,@vbtValue DECIMAL(18,2)  = NULL
	,@vbtHiThreshold DECIMAL(18,2)  = NULL
	,@vbtLoThreshold DECIMAL(18,2)  = NULL
	,@vbtAttachment INT  = NULL
	,@statusId INT  = NULL
	,@enteredBy NVARCHAR(50)  = NULL
	,@dateEntered DATETIME2(7)    = NULL
AS
BEGIN TRY                
 SET NOCOUNT ON; 
  DECLARE @updatedItemNumber INT      
  EXEC [dbo].[ResetItemNumber] @userId, 0, @vbtVendorId, @entity, @vbtItemNumber, @statusId, NULL, NULL,  @updatedItemNumber OUTPUT
   
 DECLARE @currentId BIGINT;
   INSERT INTO [dbo].[VEND020BusinessTerms]
           ([LangCode]
           ,[VbtOrgID]
           ,[VbtVendorID]
           ,[VbtItemNumber]
           ,[VbtCode]
           ,[VbtTitle]
           ,[BusinessTermTypeId]
           ,[VbtActiveDate]
           ,[VbtValue]
           ,[VbtHiThreshold]
           ,[VbtLoThreshold]
           ,[VbtAttachment]
           ,[StatusId]
           ,[EnteredBy]
           ,[DateEntered] )  
      VALUES
		   (@langCode 
           ,@vbtOrgID   
           ,@vbtVendorID  
           ,@updatedItemNumber  
           ,@vbtCode  
           ,@vbtTitle  
           ,@businessTermTypeId  
           ,@vbtActiveDate  
           ,@vbtValue  
           ,@vbtHiThreshold  
           ,@vbtLoThreshold  
           ,@vbtAttachment  
           ,@statusId  
           ,@enteredBy  
           ,@dateEntered ) 
		   SET @currentId = SCOPE_IDENTITY();
		EXEC [dbo].[GetVendBusinessTerm] @userId, @roleId, @vbtOrgId, @langCode, @currentId 
END TRY    
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[InsVendContact]    Script Date: 11/26/2018 8:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               08/16/2018      
-- Description:               Ins a Vend Contact
-- Execution:                 EXEC [dbo].[InsVendContact]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================
ALTER PROCEDURE  [dbo].[InsVendContact]
	@userId BIGINT
	,@roleId BIGINT 
	,@entity NVARCHAR(100)
	,@vendVendorId BIGINT = NULL
	,@vendItemNumber INT  = NULL
	,@vendContactCode NVARCHAR(20) = NULL 
	,@vendContactTitle NVARCHAR(50) = NULL 
	,@vendContactMSTRId BIGINT = NULL 
	,@statusId INT = NULL 
	,@enteredBy NVARCHAR(50) = NULL 
	,@dateEntered DATETIME2(7) = NULL 
AS
BEGIN TRY                
 SET NOCOUNT ON;  
  DECLARE @updatedItemNumber INT      
  EXEC [dbo].[ResetItemNumber] @userId, 0, @vendVendorId, @entity, @vendItemNumber, @statusId, NULL, NULL,  @updatedItemNumber OUTPUT 
  
 DECLARE @currentId BIGINT;
   INSERT INTO [dbo].[VEND010Contacts]
           ([VendVendorId]
           ,[VendItemNumber]
           ,[VendContactCode]
           ,[VendContactTitle]
           ,[VendContactMSTRId]
           ,[StatusId]
           ,[EnteredBy]
           ,[DateEntered] )  
      VALUES
		   (@vendVendorId  
           ,@updatedItemNumber   
           ,@vendContactCode   
           ,@vendContactTitle  
           ,@vendContactMSTRId  
           ,@statusId  
           ,@enteredBy  
           ,@dateEntered  ) 
		   SET @currentId = SCOPE_IDENTITY();
		
		IF((@statusId = 1) OR (@statusId = 2))
		BEGIN
			EXEC [dbo].[UpdateColumnCount] @tableName = 'VEND000Master', @columnName = 'VendContacts',  @rowId = @vendVendorId, @countToChange = 1
		END

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
		WHERE [Id]=@currentId 
END TRY    
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH



/***** Object:  StoredProcedure [dbo].[UpdVendContact]    Script Date: 8/16/2017 1:30:20 PM *****/
SET ANSI_NULLS ON
GO
/****** Object:  StoredProcedure [dbo].[InsVendDCLocation]    Script Date: 11/26/2018 8:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               08/16/2018      
-- Description:               Ins a Vend dc loc
-- Execution:                 EXEC [dbo].[InsVendDCLocation]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================
ALTER PROCEDURE  [dbo].[InsVendDCLocation]
	@userId BIGINT
	,@roleId BIGINT 
	,@entity NVARCHAR(100)
	,@vdcVendorId BIGINT = NULL
	,@vdcItemNumber INT = NULL
	,@vdcLocationCode NVARCHAR(20) = NULL 
	,@vdcCustomerCode NVARCHAR(20) = NULL 
	,@vdcLocationTitle NVARCHAR(50) = NULL 
	,@vdcContactMSTRId BIGINT = NULL 
	,@statusId INT = NULL 
	,@enteredBy NVARCHAR(50) = NULL 
	,@dateEntered DATETIME2(7) = NULL 
AS
BEGIN TRY                
 SET NOCOUNT ON; 
   DECLARE @updatedItemNumber INT      
 EXEC [dbo].[ResetItemNumber] @userId, 0, @vdcVendorId, @entity, @vdcItemNumber, @statusId, NULL, NULL,  @updatedItemNumber OUTPUT
 
   
 DECLARE @currentId BIGINT;
   INSERT INTO [dbo].[VEND040DCLocations]
           ([VdcVendorId]
           ,[VdcItemNumber]
           ,[VdcLocationCode]
		   ,[VdcCustomerCode]
           ,[VdcLocationTitle]
           ,[VdcContactMSTRId]
           ,[StatusId]
           ,[EnteredBy]
           ,[DateEntered] )  
      VALUES
		   (@vdcVendorId  
           ,@updatedItemNumber  
           ,@vdcLocationCode  
		   ,ISNULL(@vdcCustomerCode,@vdcLocationCode)
           ,@vdcLocationTitle  
           ,@vdcContactMSTRId  
           ,@statusId 
           ,@enteredBy
           ,@dateEntered ) 
		   SET @currentId = SCOPE_IDENTITY();
		EXEC [dbo].[GetVendDCLocation] @userId, @roleId, 1 ,@currentId 
END TRY    
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH



/***** Object:  StoredProcedure [dbo].[UpdVendDcLoc]    Script Date: 8/16/2017 1:30:20 PM *****/
SET ANSI_NULLS ON
GO
/****** Object:  StoredProcedure [dbo].[InsVendDcLocationContact]    Script Date: 11/26/2018 8:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               09/25/2018     
-- Description:               Ins a vend dc location Contact
-- Execution:                 EXEC [dbo].[InsVendDcLocationContact]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================  
ALTER PROCEDURE  [dbo].[InsVendDcLocationContact]		  
	@userId BIGINT
	,@roleId BIGINT 
	,@entity NVARCHAR(100)
	,@vlcVendDcLocationId BIGINT  = NULL
	,@vlcItemNumber INT = NULL
	,@vlcContactCode NVARCHAR(20)  = NULL
	,@vlcContactTitle NVARCHAR(50)  = NULL
	,@vlcContactMSTRID BIGINT = NULL
	,@vlcAssignment NVARCHAR(20)  = NULL
	,@vlcGateway NVARCHAR(20)  = NULL
	,@statusId INT  = NULL
	,@conTitleId INT = NULL
	,@conLastName NVARCHAR(25) = NULL
	,@conFirstName NVARCHAR(25) = NULL
	,@conMiddleName NVARCHAR(25) = NULL
	,@conJobTitle NVARCHAR(50) = NULL
	,@conCompany NVARCHAR(100) = NULL
	,@conTypeId INT = NULL
	,@conUDF01 INT = NULL
	,@conBusinessPhone NVARCHAR(25) = NULL
	,@conBusinessPhoneExt NVARCHAR(15) = NULL
	,@conMobilePhone NVARCHAR(25) = NULL
	,@conEmailAddress NVARCHAR(100) = NULL
	,@conEmailAddress2 NVARCHAR(100) = NULL
	,@conBusinessAddress1 NVARCHAR(255) = NULL
	,@conBusinessAddress2 NVARCHAR(150) = NULL
	,@conBusinessCity NVARCHAR(25) = NULL
	,@conBusinessStateId INT = NULL
	,@conBusinessZipPostal NVARCHAR(20) = NULL
	,@conBusinessCountryId INT = NULL
	,@enteredBy NVARCHAR(50)  = NULL
	,@dateEntered DATETIME2(7) 	 = NULL	  
AS
BEGIN TRY                
 SET NOCOUNT ON;   
   DECLARE @updatedItemNumber INT      
  EXEC [dbo].[ResetItemNumber] @userId, 0, @vlcVendDcLocationId, @entity, @vlcItemNumber, @statusId, NULL, NULL,  @updatedItemNumber OUTPUT
 DECLARE @currentId BIGINT;

 -- First insert into ContactMaster table
 INSERT INTO [dbo].[CONTC000Master]
        ([ConCompany]
        ,[ConTitleId]
        ,[ConLastName]
        ,[ConFirstName]
        ,[ConMiddleName]
        ,[ConEmailAddress]
        ,[ConEmailAddress2]
        ,[ConJobTitle]
        ,[ConBusinessPhone]
        ,[ConBusinessPhoneExt]
        ,[ConMobilePhone]
        ,[ConBusinessAddress1]
        ,[ConBusinessAddress2]
        ,[ConBusinessCity]
        ,[ConBusinessStateId]
        ,[ConBusinessZipPostal]
        ,[ConBusinessCountryId]
		,[ConUDF01]
        ,[StatusId]
        ,[ConTypeId]
        ,[DateEntered]
        ,[EnteredBy] )
     VALUES
		(@conCompany 
		,@conTitleId
		,@conLastName
		,@conFirstName
		,@conMiddleName
		,@conEmailAddress
		,@conEmailAddress2
		,@conJobTitle
		,@conBusinessPhone
		,@conBusinessPhoneExt
		,@conMobilePhone
		,@conBusinessAddress1
		,@conBusinessAddress2
		,@conBusinessCity
		,@conBusinessStateId
		,@conBusinessZipPostal
		,@conBusinessCountryId
		,@conUDF01
		,@statusId
		,@conTypeId
		,@dateEntered
		,@enteredBy)
	
	SET @currentId = SCOPE_IDENTITY();

   -- Then Insert into VendDcLocationContact
   INSERT INTO [dbo].[VEND041DCLocationContacts]
           ([VlcVendDcLocationId]
		   	,[VlcItemNumber]
		   	,[VlcContactCode]
		   	,[VlcContactTitle]
		   	,[VlcContactMSTRID]
		   	,[VlcAssignment]
		   	,[VlcGateway]
		   	,[StatusId]
		   	,[EnteredBy]
		   	,[DateEntered])
     VALUES
		   (@vlcVendDcLocationId 
           ,@updatedItemNumber  
           ,@vlcContactCode   
		   ,@vlcContactTitle
           ,@currentId   
           ,@vlcAssignment  
           ,@vlcGateway  
           ,@statusId 
           ,@enteredBy 
           ,@dateEntered) 	
		   SET @currentId = SCOPE_IDENTITY();
	EXEC [dbo].[GetVendDcLocationContact] @userId, @roleId, 1 ,@currentId
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[InsVendDocReference]    Script Date: 11/26/2018 8:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               08/16/2018      
-- Description:               Ins a Vend Doc Ref
-- Execution:                 EXEC [dbo].[InsVendDocReference]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================
ALTER PROCEDURE  [dbo].[InsVendDocReference]
	@userId BIGINT
	,@roleId BIGINT 
	,@entity NVARCHAR(100)
	,@vdrOrgId BIGINT = NULL
	,@vdrVendorId BIGINT  = NULL
	,@vdrItemNumber INT  = NULL
	,@vdrCode NVARCHAR(20)  = NULL
	,@vdrTitle NVARCHAR(50)  = NULL
	,@docRefTypeId INT  = NULL
	,@docCategoryTypeId INT = NULL 
	,@vdrAttachment INT  = NULL
	,@vdrDateStart DATETIME2(7) = NULL 
	,@vdrDateEnd DATETIME2(7)  = NULL
	,@vdrRenewal BIT  = NULL
	,@statusId INT = NULL 
	,@enteredBy NVARCHAR(50) = NULL 
	,@dateEntered DATETIME2(7)   = NULL
AS
BEGIN TRY                
 SET NOCOUNT ON;  
    DECLARE @updatedItemNumber INT      
   EXEC [dbo].[ResetItemNumber] @userId, 0, @vdrVendorId, @entity, @vdrItemNumber, @statusId, NULL, NULL,  @updatedItemNumber OUTPUT
 DECLARE @currentId BIGINT;
   INSERT INTO [dbo].[VEND030DocumentReference]
           ([VdrOrgId]
           ,[VdrVendorId]
           ,[VdrItemNumber]
           ,[VdrCode]
           ,[VdrTitle]
           ,[DocRefTypeId]
           ,[DocCategoryTypeId]
           ,[VdrAttachment]
           ,[VdrDateStart]
           ,[VdrDateEnd]
           ,[VdrRenewal]
           ,[StatusId]
           ,[EnteredBy]
           ,[DateEntered] )  
      VALUES
		   (@vdrOrgId  
           ,@vdrVendorId   
           ,@updatedItemNumber   
           ,@vdrCode  
           ,@vdrTitle   
           ,@docRefTypeId 
           ,@docCategoryTypeId   
           ,@vdrAttachment  
           ,@vdrDateStart  
           ,@vdrDateEnd  
           ,@vdrRenewal  
		   ,@statusId
           ,@enteredBy   
           ,@dateEntered  ) 
		   SET @currentId = SCOPE_IDENTITY();
		EXEC [dbo].[GetVendDocReference] @userId, @roleId, @vdrOrgId ,@currentId 
END TRY    
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH



/***** Object:  StoredProcedure [dbo].[UpdVendDocRef]    Script Date: 8/16/2017 1:30:20 PM *****/
SET ANSI_NULLS ON
GO
/****** Object:  StoredProcedure [dbo].[InsVendFinancialCalender]    Script Date: 11/26/2018 8:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               08/16/2018      
-- Description:               Ins a Vend Fin Cal
-- Execution:                 EXEC [dbo].[InsVendFinancialCalender]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- ============================================= 
ALTER PROCEDURE  [dbo].[InsVendFinancialCalender]
	@userId BIGINT
	,@roleId BIGINT 
	,@entity NVARCHAR(100)
	,@orgId BIGINT = NULL
	,@vendId BIGINT = NULL 
	,@fclPeriod INT  = NULL
	,@fclPeriodCode NVARCHAR(20)  = NULL
	,@fclPeriodStart DATETIME2(7)  = NULL
	,@fclPeriodEnd DATETIME2(7)  = NULL
	,@fclPeriodTitle NVARCHAR(50)  = NULL
	,@fclAutoShortCode NVARCHAR(15)  = NULL
	,@fclWorkDays INT  = NULL
	,@finCalendarTypeId INT  = NULL
	,@statusId INT = NULL 
	,@dateEntered DATETIME2(7)  = NULL
	,@enteredBy NVARCHAR(50)    = NULL
AS
BEGIN TRY                
 SET NOCOUNT ON; 
   DECLARE @updatedItemNumber INT      
 EXEC [dbo].[ResetItemNumber] @userId, 0, @vendId, @entity, @fclPeriod, @statusId, NULL, NULL,  @updatedItemNumber OUTPUT 
 
   
 DECLARE @currentId BIGINT;
   INSERT INTO [dbo].[VEND050Finacial_Cal]
           ([OrgId]
           ,[VendId]
           ,[FclPeriod]
           ,[FclPeriodCode]
           ,[FclPeriodStart]
           ,[FclPeriodEnd]
           ,[FclPeriodTitle]
           ,[FclAutoShortCode]
           ,[FclWorkDays]
           ,[FinCalendarTypeId]
           ,[StatusId]
           ,[DateEntered]
           ,[EnteredBy] )  
      VALUES
		   (@orgId  
           ,@vendId  
           ,@updatedItemNumber   
           ,@fclPeriodCode  
           ,@fclPeriodStart   
           ,@fclPeriodEnd  
           ,@fclPeriodTitle  
           ,@fclAutoShortCode  
           ,@fclWorkDays  
           ,@finCalendarTypeId  
		   ,@statusId
           ,@dateEntered  
           ,@enteredBy ) 
		   SET @currentId = SCOPE_IDENTITY();
		EXEC [dbo].[GetVendFinancialCalender] @userId, @roleId, @orgId ,@currentId 
END TRY    
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH



/***** Object:  StoredProcedure [dbo].[UpdVendFinCal]    Script Date: 8/16/2017 1:30:20 PM *****/
SET ANSI_NULLS ON
GO
/****** Object:  StoredProcedure [dbo].[InsVendor]    Script Date: 11/26/2018 8:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               08/16/2018      
-- Description:               Ins a Vender
-- Execution:                 EXEC [dbo].[InsVendor]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- ============================================= 
ALTER PROCEDURE  [dbo].[InsVendor]
	@userId BIGINT
	,@roleId BIGINT 
	,@entity NVARCHAR(100)
	,@vendERPId NVARCHAR(10) = NULL 
	,@vendOrgId BIGINT = NULL
	,@vendItemNumber INT = NULL
	,@vendCode NVARCHAR(20) = NULL
	,@vendTitle NVARCHAR(50) = NULL
	,@vendWorkAddressId BIGINT = NULL
	,@vendBusinessAddressId BIGINT = NULL
	,@vendCorporateAddressId BIGINT = NULL
	,@vendContacts INT = NULL
	,@vendTypeId INT = NULL
	,@vendTypeCode NVARCHAR(100) = NULL
	,@vendWebPage NVARCHAR(100) = NULL
	,@statusId INT = NULL
	,@enteredBy NVARCHAR(50) = NULL
	,@dateEntered DATETIME2(7) = NULL
AS
BEGIN TRY                
 SET NOCOUNT ON;
    DECLARE @updatedItemNumber INT      
  EXEC [dbo].[ResetItemNumber] @userId, 0, @vendOrgId, @entity, @vendItemNumber, @statusId, NULL, NULL,  @updatedItemNumber OUTPUT
  
  IF NOT EXISTS(SELECT Id  FROM [dbo].[SYSTM000Ref_Options] WHERE SysOptionName = @vendTypeCode) AND ISNULL(@vendTypeCode, '') <> '' AND ISNULL(@vendTypeId,0) = 0
  BEGIN
     DECLARE @highestTypeCodeSortOrder INT;
	 SELECT @highestTypeCodeSortOrder = MAX(SysSortOrder) FROM [dbo].[SYSTM000Ref_Options] WHERE SysLookupId=8; 
	 SET @highestTypeCodeSortOrder = ISNULL(@highestTypeCodeSortOrder, 0) + 1;
     INSERT INTO [dbo].[SYSTM000Ref_Options](SysLookupId, SysLookupCode, SysOptionName, SysSortOrder, StatusId, DateEntered, EnteredBy)
	 VALUES(50, 'VendorType', @vendTypeCode, @highestTypeCodeSortOrder , ISNULL(@statusId,1), @dateEntered, @enteredBy)
	 SET @vendTypeId = SCOPE_IDENTITY();
  END
  ELSE IF ((ISNULL(@vendTypeId,0) > 0) AND (ISNULL(@vendTypeCode, '') <> ''))
  BEGIN
    UPDATE [dbo].[SYSTM000Ref_Options] SET SysOptionName =@vendTypeCode WHERE Id =@vendTypeId
  END
   
  IF(ISNULL(@vendWorkAddressId, 0) = 0)
  SET @vendWorkAddressId = NULL;
 IF(ISNULL(@vendBusinessAddressId, 0) = 0)
  SET @vendBusinessAddressId = NULL;
 IF(ISNULL(@vendCorporateAddressId, 0) = 0)
  SET @vendCorporateAddressId = NULL; 
    
 DECLARE @currentId BIGINT;
   INSERT INTO [dbo].[VEND000Master]
           ([VendERPId]
           ,[VendOrgId]
           ,[VendItemNumber]
           ,[VendCode]
           ,[VendTitle]
           ,[VendWorkAddressId]
           ,[VendBusinessAddressId]
           ,[VendCorporateAddressId]
           ,[VendContacts]
           ,[VendTypeId]
           ,[VendWebPage]
           ,[StatusId]
           ,[EnteredBy]
           ,[DateEntered] )  
      VALUES
		   (@vendERPId  
           ,@vendOrgId  
           ,@updatedItemNumber   
           ,@vendCode  
           ,@vendTitle 
           ,@vendWorkAddressId  
           ,@vendBusinessAddressId  
           ,@vendCorporateAddressId 
           ,@vendContacts 
           ,@vendTypeId   
           ,@vendWebPage   
           ,@statusId  
           ,@enteredBy  
           ,@dateEntered ) 
		   SET @currentId = SCOPE_IDENTITY();
		EXEC [dbo].[GetVendor] @userId, @roleId, @vendOrgId ,@currentId 
END TRY    
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
