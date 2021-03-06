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

CREATE PROCEDURE  [dbo].[InsPrgEdiMapping]
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
