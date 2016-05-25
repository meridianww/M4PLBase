CREATE PROCEDURE [dbo].[GetMenuDetails] --9
	@MenuID INT
AS
BEGIN TRY
	SET NOCOUNT ON;

	SELECT
		 [MenuID]                
		 ,[MnuBreakDownStructure] 
		 ,[MnuModule]             
		 ,[MnuTitle]              
		 ,[MnuDescription]        
		 ,[MnuTabOver]            
		 ,[MnuIconVerySmall]      
		 ,[MnuIconSmall]          
		 ,[MnuIconMedium]         
		 ,[MnuIconLarge]          
		 ,[MnuRibbon]             
		 ,[MnuRibbonTabName]      
		 ,[MnuMenuItem]           
		 ,[MnuExecuteProgram]     
		 ,[MnuProgramType]        
		 ,[MnuClassification]     
		 ,[MnuOptionLevel]        
		 ,[MnuDateEntered]        
		 ,[MnyDateEnteredBy]      
		 ,[MnuDateChanged]        
		 ,[MnuDateChangedBy]           
	FROM
		dbo.SYSTM000MenuDriver (NOLOCK)
	WHERE
		MenuID = @MenuID

END TRY
BEGIN CATCH

	DECLARE @ErrorMessage VARCHAR(MAX) = (SELECT ERROR_MESSAGE()),
			@ErrorSeverity VARCHAR(MAX) = (SELECT ERROR_SEVERITY()),
			@RelatedTo VARCHAR(100)  = (SELECT OBJECT_NAME(@@PROCID))
	EXEC [ErrorLog_InsertErrorDetails] @RelatedTo, NULL, @ErrorMessage , NULL, NULL, @ErrorSeverity

END CATCH