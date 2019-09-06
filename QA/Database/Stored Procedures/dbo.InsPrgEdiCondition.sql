GO
/* Copyright (2019) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Nikhil Chauhan         
-- Create date:               08/21/2019      
-- Description:               Ins a Program Edi Condition 
-- Execution:                 EXEC [dbo].[InsPrgEdiCondition]
-- =============================================  
  
CREATE PROCEDURE  [dbo].[InsPrgEdiCondition]  
	(@userId BIGINT  
	,@roleId BIGINT 
	,@entity NVARCHAR(100)  
	,@pecProgramId BIGINT
	,@pecJobField nvarchar(50)   
	,@pecCondition nvarchar(50)   
	,@perLogical nvarchar(50)     
	,@pecJobField2 nvarchar(50)  
	,@pecCondition2 nvarchar(50)   
	,@dateEntered datetime2(7)  
	,@enteredBy nvarchar(50)  
)  
AS  
BEGIN TRY                  
 SET NOCOUNT ON;     
 DECLARE @currentId BIGINT;  

 INSERT INTO [dbo].[PRGRM072EdiConditions]
           (
            [PecProgramId]
           ,[PecJobField]
           ,[PecCondition]
           ,[PerLogical]
           ,[PecJobField2]
           ,[PecCondition2]
           ,[EnteredBy]
           ,[DateEntered]
		   --,[PecParentProgramId]
           ,[ChangedBy]
		   ,[DateChanged])
     VALUES
           (
            @pecProgramId
           ,@pecJobField
           ,@pecCondition
           ,@perLogical
           ,@pecJobField2
           ,@pecCondition2
           ,@enteredBy
           ,@dateEntered
		   --,NULL
           ,NULL
           ,NULL) 
   SET @currentId = SCOPE_IDENTITY(); 
   
   EXECUTE  [GetPrgEdiConditionByEdiHeader] @userId,@roleId,@currentId;
 
END TRY                
BEGIN CATCH                  
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                  
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                  
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                  
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                  
END CATCH