CREATE PROCEDURE [dbo].[GetMenuDetails] --9
	@MenuID INT
AS
BEGIN 
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

END