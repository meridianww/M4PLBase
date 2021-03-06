SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               08/16/2018      
-- Description:               Upd a Job Doc Reference
-- Execution:                 EXEC [dbo].[UpdJobDocReference]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================    
CREATE PROCEDURE  [dbo].[UpdJobDocReference]  
	(@userId BIGINT  
	,@roleId BIGINT  
	,@entity NVARCHAR(100)  
	,@id bigint  
	,@jobId bigint = NULL 
	,@jdrItemNumber int = NULL  
	,@jdrCode nvarchar(20) = NULL  
	,@jdrTitle nvarchar(50) = NULL  
	,@docTypeId INT = NULL  
	,@jdrAttachment int = NULL  
	,@jdrDateStart datetime2(7) = NULL  
	,@jdrDateEnd datetime2(7) = NULL  
	,@jdrRenewal bit = NULL  
	,@statusId int = NULL  
	,@changedBy nvarchar(50) = NULL  
	,@dateChanged datetime2(7) = NULL
	,@isFormView BIT = 0
	,@where nvarchar(200)=NULL )   
AS  
BEGIN TRY                  
 SET NOCOUNT ON;     
 DECLARE @updatedItemNumber INT        

 DECLARE  @olddocTypeId INT 
 DECLARE  @primaryId INT 
 SET @primaryId =@id;
 --SELECT @olddocTypeId = DocTypeId from JOBDL040DocumentReference WHERE id= @id;
 --IF @olddocTypeId <> @docTypeId
 --BEGIN
 --   SET @primaryId = 0
 --END
-- DECLARE @where NVARCHAR(MAX) =  ' AND DocTypeId ='  +  CAST(@docTypeId AS VARCHAR)   
  EXEC [dbo].[ResetItemNumber] @userId, @primaryId, @jobId, @entity, @jdrItemNumber, @statusId, NULL, @where,  @updatedItemNumber OUTPUT 
 UPDATE [dbo].[JOBDL040DocumentReference]  
  SET  [JobID]              = CASE WHEN (@isFormView = 1) THEN @jobId WHEN ((@isFormView = 0) AND (@jobId=-100)) THEN NULL ELSE ISNULL(@jobId, JobID) END  
      ,[JdrItemNumber]      = CASE WHEN (@isFormView = 1) THEN @updatedItemNumber WHEN ((@isFormView = 0) AND (@updatedItemNumber=-100)) THEN NULL ELSE ISNULL(@updatedItemNumber, JdrItemNumber)  END
   ,[JdrCode]               = CASE WHEN (@isFormView = 1) THEN @JdrCode WHEN ((@isFormView = 0) AND (@JdrCode='#M4PL#')) THEN NULL ELSE ISNULL(@JdrCode, JdrCode)  END
   ,[JdrTitle]              = CASE WHEN (@isFormView = 1) THEN @JdrTitle WHEN ((@isFormView = 0) AND (@JdrTitle='#M4PL#')) THEN NULL ELSE ISNULL(@JdrTitle, JdrTitle)  END
   ,[DocTypeId]             = CASE WHEN (@isFormView = 1) THEN @docTypeId WHEN ((@isFormView = 0) AND (@docTypeId=-100)) THEN NULL ELSE ISNULL(@docTypeId, DocTypeId)  END
   ,[StatusId]				= CASE WHEN (@isFormView = 1) THEN @statusId WHEN ((@isFormView = 0) AND (@statusId=-100)) THEN NULL ELSE ISNULL(@statusId, StatusId )  END
   --,[JdrAttachment]         = CASE WHEN (@isFormView = 1) THEN @JdrAttachment WHEN ((@isFormView = 0) AND (@JdrAttachment=-100)) THEN NULL ELSE ISNULL(@JdrAttachment, JdrAttachment) END 
   ,[JdrDateStart]          = CASE WHEN (@isFormView = 1) THEN @JdrDateStart WHEN ((@isFormView = 0) AND (CONVERT(CHAR(10), @JdrDateStart, 103)='01/01/1753')) THEN NULL ELSE ISNULL(@JdrDateStart, JdrDateStart)  END
   ,[JdrDateEnd]            = CASE WHEN (@isFormView = 1) THEN @JdrDateEnd WHEN ((@isFormView = 0) AND (CONVERT(CHAR(10), @JdrDateEnd, 103)='01/01/1753')) THEN NULL ELSE ISNULL(@JdrDateEnd , JdrDateEnd)  END
   ,[JdrRenewal]            = ISNULL(@JdrRenewal, JdrRenewal)  
   ,[ChangedBy]             = @changedBy  
   ,[DateChanged]           = @dateChanged  
  WHERE   [Id] = @id  
 SELECT job.[Id]  
  ,job.[JobID]  
  ,job.[JdrItemNumber]  
  ,job.[JdrCode]  
  ,job.[JdrTitle]  
  ,job.[DocTypeId]  
  ,job.[StatusId]  
  ,job.[JdrAttachment]  
  ,job.[JdrDateStart]  
  ,job.[JdrDateEnd]  
  ,job.[JdrRenewal]  
  ,job.[EnteredBy]  
  ,job.[DateEntered]  
  ,job.[ChangedBy]  
  ,job.[DateChanged]  
  FROM   [dbo].[JOBDL040DocumentReference] job  
 WHERE   [Id] = @id  
END TRY                  
BEGIN CATCH                  
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                  
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                  
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                  
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                  
END CATCH
GO
