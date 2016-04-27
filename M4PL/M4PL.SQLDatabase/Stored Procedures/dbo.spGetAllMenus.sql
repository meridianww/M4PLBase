
CREATE PROCEDURE [dbo].[spGetAllMenus] --9
	@MnuModule INT = 0
AS
BEGIN 
	SET NOCOUNT ON;

	DECLARE @SQL NVARCHAR(MAX) = '';

	SET @SQL = '
		SELECT
			MD.[MenuID]               
			,MD.[MnuBreakDownStructure]
			,MD.[MnuModule]
			,ISNULL(RO.[SysOptionName], ''NA'') AS ModuleName
			,MD.[MnuTitle]             
			,MD.[MnuDescription]       
			,MD.[MnuTabOver]     
			,MD.[MnuRibbon]            
			,MD.[MnuRibbonTabName]     
			,MD.[MnuMenuItem]          
			,MD.[MnuExecuteProgram]    
			,MD.[MnuProgramType]       
			,MD.[MnuClassification]    
			,MD.[MnuOptionLevel]       
			,ISNULL(RO1.[SysOptionName], ''NA'') AS Permission
		FROM
			dbo.SYSTM000MenuDriver MD (NOLOCK)
		INNER JOIN dbo.SYSTM010Ref_Options RO (NOLOCK) 
		ON 
			RO.SysOptionID = MD.MnuModule
	'
	IF ISNULL(@MnuModule, 0) > 0
	BEGIN
		SET @SQL = @SQL + '
			AND [MnuModule] = ' + CAST(@MnuModule AS NVARCHAR)
	END

	SET @SQL = @SQL + '
			AND RO.SysTableName = ''SYSTM000MenuDriver''
			AND RO.SysColumnName = ''MnuModule''
		LEFT JOIN dbo.SYSTM010Ref_Options RO1 (NOLOCK)
		ON 
			RO1.SysOptionID = MD.MnuOptionLevel
			AND RO1.SysTableName = ''SYSTM000MenuDriver''
			AND RO1.SysColumnName = ''MnuOptionLevel''
	'

	PRINT (@SQL);
	EXEC (@SQL);

END