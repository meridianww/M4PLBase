SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               10/29/2018      
-- Description:               Upd a Scr Catalog List
-- Execution:                 EXEC [dbo].[UpdScrCatalogList]
-- Modified on:               11/27/2018( Nikhil - Introduced roleId and entity parameters to support security and generic ResetItemNumber. Also formatted passed params.)  
-- Modified Desc:  
-- =============================================
CREATE PROCEDURE  [dbo].[UpdScrCatalogList]		  
	@userId BIGINT
	,@roleId BIGINT  
	,@entity NVARCHAR(100)
	,@id  BIGINT
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
	,@changedBy  NVARCHAR(50)
	,@dateChanged  DATETIME2(7)
	,@isFormView BIT = 0
AS
BEGIN TRY                
 SET NOCOUNT ON;   
  DECLARE @updatedItemNumber INT      
  EXEC [dbo].[ResetItemNumber] @userId, @id, @catalogProgramID, @entity, @catalogItemNumber, @statusId, NULL, NULL,  @updatedItemNumber OUTPUT  

   UPDATE  [dbo].[SCR010CatalogList] 
      SET    CatalogProgramID    =   CASE WHEN (@isFormView = 1) THEN @catalogProgramID WHEN ((@isFormView = 0) AND (@catalogProgramID=-100)) THEN NULL ELSE ISNULL(@catalogProgramID, CatalogProgramID) END
			,CatalogItemNumber   =   CASE WHEN (@isFormView = 1) THEN @updatedItemNumber WHEN ((@isFormView = 0) AND (@updatedItemNumber=-100)) THEN NULL ELSE ISNULL(@updatedItemNumber, CatalogItemNumber) END
			,CatalogCode         =   CASE WHEN (@isFormView = 1) THEN @catalogCode WHEN ((@isFormView = 0) AND (@catalogCode='#M4PL#')) THEN NULL ELSE ISNULL(@catalogCode, CatalogCode) END      
			,CatalogTitle        =   CASE WHEN (@isFormView = 1) THEN @catalogTitle WHEN ((@isFormView = 0) AND (@catalogTitle='#M4PL#')) THEN NULL ELSE ISNULL(@catalogTitle, CatalogTitle) END     

			,CatalogCustCode        =   CASE WHEN (@isFormView = 1) THEN @catalogCustCode WHEN ((@isFormView = 0) AND (@catalogCustCode='#M4PL#')) THEN NULL ELSE ISNULL(@catalogCustCode, CatalogCustCode) END     
			,CatalogUoMCode        =   CASE WHEN (@isFormView = 1) THEN @catalogUoMCode WHEN ((@isFormView = 0) AND (@catalogUoMCode='#M4PL#')) THEN NULL ELSE ISNULL(@catalogUoMCode, CatalogUoMCode) END     
			--,CatalogCubes	      =   CASE WHEN (@isFormView = 1) THEN @catalogCubes WHEN ((@isFormView = 0) AND (@catalogCubes=-100)) THEN NULL ELSE ISNULL(@catalogCubes, CatalogCubes) END     
			,CatalogWidth	      =   CASE WHEN (@isFormView = 1) THEN @catalogWidth WHEN ((@isFormView = 0) AND (@catalogWidth=-100)) THEN NULL ELSE ISNULL(@catalogWidth, CatalogWidth) END     
			,CatalogLength      =   CASE WHEN (@isFormView = 1) THEN @catalogLength WHEN ((@isFormView = 0) AND (@catalogLength=-100)) THEN NULL ELSE ISNULL(@catalogLength, CatalogLength) END     
			,CatalogHeight      =   CASE WHEN (@isFormView = 1) THEN @catalogHeight WHEN ((@isFormView = 0) AND (@catalogHeight=-100)) THEN NULL ELSE ISNULL(@catalogHeight, CatalogHeight) END     
			,CatalogWLHUoM      =   CASE WHEN (@isFormView = 1) THEN @catalogWLHUoM WHEN ((@isFormView = 0) AND (@catalogWLHUoM=-100)) THEN NULL ELSE ISNULL(@catalogWLHUoM, CatalogWLHUoM) END     
			,CatalogWeight      =   CASE WHEN (@isFormView = 1) THEN @catalogWeight WHEN ((@isFormView = 0) AND (@catalogWeight=-100)) THEN NULL ELSE ISNULL(@catalogWeight, CatalogWeight) END     

			,StatusId            =   CASE WHEN (@isFormView = 1) THEN @statusId WHEN ((@isFormView = 0) AND (@statusId=-100)) THEN NULL ELSE ISNULL(@statusId, StatusId) END         
			,DateChanged         =   ISNULL(@dateChanged, DateChanged)      
			,ChangedBy           =   ISNULL(@changedBy, ChangedBy)
       WHERE Id = @id		;   

	   UPDATE [SCR010CatalogList] SET CatalogCubes = (CatalogWidth *CatalogHeight *CatalogLength)   WHERE Id = @id		;   


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
  WHERE scr.[Id]=@id

END TRY                
BEGIN CATCH                
 DECLARE  @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE())                
   ,@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY())                
   ,@RelatedTo VARCHAR(100) = (SELECT OBJECT_NAME(@@PROCID))                
 EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo, NULL, @ErrorMessage, NULL, NULL, @ErrorSeverity                
END CATCH
GO
