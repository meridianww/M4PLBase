SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               08/16/2018      
-- Description:               Upd a Program EDI mapping
-- Execution:                 EXEC [dbo].[UpdPrgEdiMapping]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================
CREATE PROCEDURE  [dbo].[UpdPrgEdiMapping]
	(@userId BIGINT
	,@roleId BIGINT  
	,@entity NVARCHAR(100)
	,@id bigint
	,@pemHeaderID bigint
	,@pemEdiTableName  NVARCHAR(50)=NULL
	,@pemEdiFieldName NVARCHAR(50)=NULL
	,@pemEdiFieldDataType NVARCHAR(20)=NULL
	,@pemSysTableName NVARCHAR(50)=NULL
	,@pemSysFieldName NVARCHAR(50)=NULL
	,@pemSysFieldDataType NVARCHAR(20) =NULL
	,@statusId  int=NULL
	,@pemInsertUpdate int=NULL
	,@pemDateStart datetime2(7)=NULL
	,@pemDateEnd datetime2(7) =NULL
	,@changedBy nvarchar(50) = NULL
	,@dateChanged datetime2(7) = NULL
	,@isFormView BIT = 0) 
AS
BEGIN TRY                
 SET NOCOUNT ON; 
 
 --SELECT @pemSysFieldDataType =  DATA_TYPE from INFORMATION_SCHEMA.COLUMNS IC where TABLE_NAME = @pemSysTableName and COLUMN_NAME = @pemSysFieldName
 --SELECT @pemEdiFieldDataType =  DATA_TYPE from INFORMATION_SCHEMA.COLUMNS IC where TABLE_NAME = @pemEdiTableName and COLUMN_NAME = @pemEdiFieldName
 
   
 UPDATE [dbo].[PRGRM071EdiMapping]
		SET  [PemHeaderID]       = CASE WHEN (@isFormView = 1) THEN @pemHeaderID WHEN ((@isFormView = 0) AND (@pemHeaderID=-100)) THEN NULL ELSE ISNULL(@pemHeaderID, PemHeaderID) END
			,[PemEdiTableName]   = CASE WHEN (@isFormView = 1) THEN @pemEdiTableName WHEN ((@isFormView = 0) AND (@pemEdiTableName='#M4PL#')) THEN NULL ELSE ISNULL(@pemEdiTableName, PemEdiTableName) END
			,[PemEdiFieldName]   = CASE WHEN (@isFormView = 1) THEN @pemEdiFieldName WHEN ((@isFormView = 0) AND (@pemEdiFieldName='#M4PL#')) THEN NULL ELSE ISNULL(@pemEdiFieldName, PemEdiFieldName) END
			,[PemEdiFieldDataType] = CASE WHEN (@isFormView = 1) THEN @pemEdiFieldDataType WHEN ((@isFormView = 0) AND (@pemEdiFieldDataType='#M4PL#')) THEN @pemEdiFieldDataType ELSE ISNULL(@pemEdiFieldDataType, PemEdiFieldDataType) END


			,[PemSysTableName]    = CASE WHEN (@isFormView = 1) THEN @pemSysTableName WHEN ((@isFormView = 0) AND (@pemSysTableName='#M4PL#')) THEN NULL ELSE ISNULL(@pemSysTableName, PemSysTableName) END
			,[PemSysFieldName]   = CASE WHEN (@isFormView = 1) THEN @pemSysFieldName WHEN ((@isFormView = 0) AND (@pemSysFieldName='#M4PL#')) THEN NULL ELSE ISNULL(@pemSysFieldName, PemSysFieldName) END
			,[PemSysFieldDataType] = CASE WHEN (@isFormView = 1) THEN @pemSysFieldDataType WHEN ((@isFormView = 0) AND (@pemSysFieldDataType='#M4PL#')) THEN @pemSysFieldDataType ELSE ISNULL(@pemSysFieldDataType, PemSysFieldDataType) END
			
			,[StatusId]          = CASE WHEN (@isFormView = 1) THEN @statusId WHEN ((@isFormView = 0) AND (@statusId=-100)) THEN NULL ELSE ISNULL(@statusId, StatusId) END
			,[PemInsertUpdate]   = CASE WHEN (@isFormView = 1) THEN @pemInsertUpdate WHEN ((@isFormView = 0) AND (@pemInsertUpdate=-100)) THEN NULL ELSE ISNULL(@pemInsertUpdate, PemInsertUpdate) END
			,[PemDateStart]      = CASE WHEN (@isFormView = 1) THEN @pemDateStart WHEN ((@isFormView = 0) AND (CONVERT(CHAR(10), @pemDateStart, 103)='01/01/1753')) THEN NULL ELSE ISNULL(@pemDateStart, PemDateStart) END
			,[PemDateEnd]        = CASE WHEN (@isFormView = 1) THEN @pemDateEnd WHEN ((@isFormView = 0) AND (CONVERT(CHAR(10), @pemDateEnd, 103)='01/01/1753')) THEN NULL ELSE ISNULL(@pemDateEnd, PemDateEnd) END
			,[ChangedBy]         = @changedBy
			,[DateChanged]       = @dateChanged
	 WHERE   [Id] = @id;
	SELECT  prg.[Id]
		 ,prg.[PemHeaderID]
         ,prg.[PemEdiTableName]
         ,prg.[PemEdiFieldName]
         ,prg.[PemEdiFieldDataType]
         ,prg.[PemSysTableName]
         ,prg.[PemSysFieldName]
         ,prg.[PemSysFieldDataType]
         ,prg.[StatusId]
         ,prg.[PemInsertUpdate]
         ,prg.[PemDateStart]
         ,prg.[PemDateEnd]
         ,prg.[EnteredBy]
         ,prg.[DateEntered]
         ,prg.[ChangedBy]
         ,prg.[DateChanged]
  FROM   [dbo].[PRGRM071EdiMapping] prg
 WHERE   [Id] = @id
END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
