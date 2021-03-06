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
CREATE PROCEDURE  [dbo].[InsColumnAlias]		  
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
	,@isGridColumn BIT=0
	,@colGridAliasName NVARCHAR(50) = NULL

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
		   ,[StatusId]
		   ,[IsGridColumn]
		   ,ColGridAliasName)
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
		   ,@statusId
		   ,@isGridColumn
		   ,@colGridAliasName)
  

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
