SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/* Copyright (2018) Meridian Worldwide Transportation Group        
   All Rights Reserved Worldwide */        
-- =============================================                
-- Author:                    Janardana Behara                 
-- Create date:               09/14/2018              
-- Description:               Ins a Job            
-- Execution:                 EXEC [dbo].[ScrCatalogListCopy] 
-- Modified on:          
-- Modified Desc:          
-- =============================================  
  

  CREATE  PROCEDURE [dbo].[PrgMvocCopy]
  (
    @programId BIGINT,
	@enteredBy NVARCHAR(50),
	@fromRecordId BIGINT,
	@PacificDateTime DATETIME2(7)
  )
  AS 
  BEGIN TRY
   SET NOCOUNT ON;   


   DECLARE @MvocTable TABLE( 
   Id BIGINT PRIMARY KEY IDENTITY(1,1),
   MvocId BIGINT)

   INSERT INTO @MvocTable(MvocId)
   SELECT Id FROM MVOC000Program WHERE VocProgramID= @fromRecordId   AND StatusId IN(1,2)   

   DECLARE @PkeyId BIGINT
   SET @PkeyId =  1;
   WHILE EXISTS(SELECT Id FROM @MvocTable WHERE Id  = @PkeyId)
   BEGIN
     
	  DECLARE @MvocId BIGINT;
	  DECLARE @newMvocId BIGINT;

      SELECT @MvocId = MvocId FROM @MvocTable WHERE Id  = @PkeyId;

	  --INSERT PROGRAM MVCOC
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
      
	 SELECT 
			VocOrgID  
		   ,@programId  
		   ,VocSurveyCode  
		   ,VocSurveyTitle  
		   ,StatusId  
		   ,VocDateOpen  
		   ,VocDateClose
			,@PacificDateTime      
			,@enteredBy            
			FROM MVOC000Program WHERE Id= @MvocId   AND StatusId IN(1,2)   

	 SET @newMvocId = SCOPE_IDENTITY();

      -- INSERT REF QUESTIONS
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
     SELECT 
             @newMvocId
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
			,EnteredBy

			FROM [MVOC010Ref_Questions] Where MVOCID = @MvocId AND StatusId IN(1,2)   


	  SET @PkeyId = @PkeyId +  1;
   END

END TRY              
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
