
CREATE PROCEDURE [dbo].[spGetAllMenus] --9
	@MnuModule INT = 0
AS
BEGIN 
	SET NOCOUNT ON;

	DECLARE @SQL NVARCHAR(MAX) = '';

	SET @SQL = '
		SELECT
			[MenuID]               
			,[MnuBreakDownStructure]
			,[MnuModule]            
			,[MnuTitle]             
			,[MnuDescription]       
			,[MnuTabOver]     
			,[MnuRibbon]            
			,[MnuRibbonTabName]     
			,[MnuMenuItem]          
			,[MnuExecuteProgram]    
			,[MnuProgramType]       
			,[MnuClassification]    
			,[MnuOptionLevel]       
		FROM
			dbo.SYSTM000MenuDriver (NOLOCK)
	'
	IF ISNULL(@MnuModule, 0) > 0
	BEGIN
		SET @SQL = @SQL + '
		WHERE
			[MnuModule] = ' + CAST(@MnuModule AS NVARCHAR)
	END

	PRINT (@SQL);
	EXEC (@SQL);

END