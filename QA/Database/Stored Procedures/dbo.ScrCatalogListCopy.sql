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

  CREATE  PROCEDURE [dbo].[ScrCatalogListCopy]
  (
    @programId BIGINT,
	@enteredBy NVARCHAR(50),
	@fromRecordId BIGINT,
	 @PacificDateTime DATETIME2(7)
  )
  AS 
  BEGIN
   SET NOCOUNT ON;   

  INSERT INTO [dbo].[SCR010CatalogList]
           ( [CatalogProgramID]
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
			,[CatalogPhoto]
			,[StatusId]
			,[DateEntered]
			,[EnteredBy]) 
      
			SELECT 
			 @programId
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
			,[CatalogPhoto]
			,[StatusId]
			,@PacificDateTime      
			,@enteredBy            
			FROM SCR010CatalogList WHERE CatalogProgramID= @fromRecordId   AND StatusId IN(1,2)   
			
END
GO
