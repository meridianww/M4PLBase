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
 
   
 UPDATE [dbo].[PRGRM071EdiMapping]
		SET  [PemHeaderID]       =  ISNULL(@pemHeaderID, PemHeaderID) 
			,[PemEdiTableName]   =  ISNULL(@pemEdiTableName, PemEdiTableName) 
			,[PemEdiFieldName]   =  ISNULL(@pemEdiFieldName, PemEdiFieldName) 
			,[PemEdiFieldDataType] =  ISNULL(@pemEdiFieldDataType, PemEdiFieldDataType) 


			,[PemSysTableName]    =  ISNULL(@pemSysTableName, PemSysTableName) 
			,[PemSysFieldName]   =   ISNULL(@pemSysFieldName, PemSysFieldName) 
			,[PemSysFieldDataType] = ISNULL(@pemSysFieldDataType, PemSysFieldDataType) 
			
			,[StatusId]          =  ISNULL(@statusId, StatusId) 
			,[PemInsertUpdate]   =  ISNULL(@pemInsertUpdate, PemInsertUpdate) 
			,[PemDateStart]      = CASE WHEN ( (CONVERT(CHAR(10), @pemDateStart, 103)='01/01/1753')) THEN NULL ELSE ISNULL(@pemDateStart, PemDateStart) END
			,[PemDateEnd]        = CASE  WHEN ( (CONVERT(CHAR(10), @pemDateEnd, 103)='01/01/1753')) THEN NULL ELSE ISNULL(@pemDateEnd, PemDateEnd) END
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
