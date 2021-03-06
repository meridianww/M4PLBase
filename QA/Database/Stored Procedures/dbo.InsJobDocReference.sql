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
    
CREATE PROCEDURE  [dbo].[InsJobDocReference]    
	(@DocRefId BIGINT
	,@userId BIGINT    
	,@roleId BIGINT 
	,@entity NVARCHAR(100) = 'JobDocReference'   
	,@jobId bigint    
	,@jdrItemNumber int =0
	,@jdrCode nvarchar(20)    
	,@jdrTitle nvarchar(50)    
	,@docTypeId int    
	,@jdrAttachment int    
	,@jdrDateStart datetime2(7)    
	,@jdrDateEnd datetime2(7)    
	,@jdrRenewal bit    
	,@statusId int = null    
	,@enteredBy nvarchar(50)    
	,@dateEntered datetime2(7)
	,@where nvarchar(200)=NULL)    
AS    
BEGIN TRY                    
 SET NOCOUNT ON;       
  DECLARE @updatedItemNumber INT          
 ---- DECLARE @where NVARCHAR(MAX) =  ' AND DocTypeId ='  +  CAST(@docTypeId AS VARCHAR)   
 -- EXEC [dbo].[ResetItemNumber] @userId, 0, @jobId, @entity, @jdrItemNumber, @statusId, NULL, @where,  @updatedItemNumber OUTPUT  ;    

 SELECT @updatedItemNumber = CASE WHEN COUNT(jdr.Id) IS NULL THEN 1 ELSE COUNT(jdr.Id) + 1 END FROM [JOBDL040DocumentReference] jdr
 INNER JOIN SYSTM000Ref_Options sro ON jdr.DocTypeId = sro.Id AND sro.SysLookupCode = 'JobDocReferenceType'
 WHERE jdr.JobID = @jobId AND jdr.StatusId=1 
    
    
 DECLARE @currentId BIGINT;    
 INSERT INTO [dbo].[JOBDL040DocumentReference]    
           ([Id]
   ,[JobID]  
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
           (@DocRefId
	  ,@jobId    
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
    
 SELECT * FROM [dbo].[JOBDL040DocumentReference] WHERE Id = @DocRefId;       

 UPDATE [dbo].[EntitySequenceReference] SET IsUsed = 1
 WHERE Entity = 'DocumentReference' AND SequenceNumber = @DocRefId

END TRY                  
BEGIN CATCH                    
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                    
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                    
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                    
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                    
END CATCH

GO
