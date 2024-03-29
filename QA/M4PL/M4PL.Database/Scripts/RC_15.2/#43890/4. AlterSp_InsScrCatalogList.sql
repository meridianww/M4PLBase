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
	,@catalogWLHUoM	int = NULL
	,@catalogWeight	int = NULL
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