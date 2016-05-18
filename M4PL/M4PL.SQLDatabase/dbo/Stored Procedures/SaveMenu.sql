
CREATE PROCEDURE dbo.[SaveMenu]
	@MenuID                INT           
	,@MnuBreakDownStructure NVARCHAR (20) 
	,@MnuModule             INT           
	,@MnuTitle              NVARCHAR (50) 
	,@MnuDescription        NTEXT         
	,@MnuTabOver            NVARCHAR (25) 
	,@MnuIconVerySmall      IMAGE         
	,@MnuIconSmall          IMAGE         
	,@MnuIconMedium         IMAGE         
	,@MnuIconLarge          IMAGE         
	,@MnuRibbon             BIT           
	,@MnuRibbonTabName      NVARCHAR (255)
	,@MnuMenuItem           BIT           
	,@MnuExecuteProgram     NVARCHAR (255)
	,@MnuProgramType        NVARCHAR (20) 
	,@MnuClassification     NVARCHAR (20) 
	,@MnuOptionLevel        INT           
	,@MnuDateEnteredBy      NVARCHAR (255)
	,@MnuDateChangedBy      NVARCHAR (50) 
AS
BEGIN

	IF @MenuID = 0 
		GOTO AddInsert;
	ELSE
	BEGIN
		IF EXISTS (SELECT 1 FROM [dbo].[SYSTM000MenuDriver] (NOLOCK) WHERE MenuID = @MenuID)
			GOTO EditUpdate;
		ELSE
			GOTO AddInsert;
	END

	AddInsert:
	BEGIN
		INSERT INTO [dbo].[SYSTM000MenuDriver]
		(   
			 [MnuBreakDownStructure]
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
		)
		VALUES
		(
			 @MnuBreakDownStructure
			 ,@MnuModule        
			 ,@MnuTitle         
			 ,@MnuDescription   
			 ,@MnuTabOver       
			 ,@MnuIconVerySmall 
			 ,@MnuIconSmall     
			 ,@MnuIconMedium    
			 ,@MnuIconLarge     
			 ,@MnuRibbon        
			 ,@MnuRibbonTabName 
			 ,@MnuMenuItem      
			 ,@MnuExecuteProgram
			 ,@MnuProgramType   
			 ,@MnuClassification
			 ,@MnuOptionLevel   
			 ,GETDATE()   
			 ,@MnuDateEnteredBy 
		)
	END

	EditUpdate:
	BEGIN
		UPDATE 
			[dbo].[SYSTM000MenuDriver]
		SET
			 [MnuBreakDownStructure]	= @MnuBreakDownStructure
			 ,[MnuModule]				= @MnuModule        
			 ,[MnuTitle]				= @MnuTitle         
			 ,[MnuDescription]   		= @MnuDescription   
			 ,[MnuTabOver]       		= @MnuTabOver       
			 ,[MnuIconVerySmall] 		= @MnuIconVerySmall 
			 ,[MnuIconSmall]     		= @MnuIconSmall     
			 ,[MnuIconMedium]    		= @MnuIconMedium    
			 ,[MnuIconLarge]     		= @MnuIconLarge     
			 ,[MnuRibbon]        		= @MnuRibbon        
			 ,[MnuRibbonTabName] 		= @MnuRibbonTabName 
			 ,[MnuMenuItem]      		= @MnuMenuItem      
			 ,[MnuExecuteProgram]		= @MnuExecuteProgram
			 ,[MnuProgramType]   		= @MnuProgramType   
			 ,[MnuClassification]		= @MnuClassification
			 ,[MnuOptionLevel]   		= @MnuOptionLevel   
			 ,[MnuDateChanged]			= GETDATE()
			 ,[MnuDateChangedBy]		= @MnuDateChangedBy
		WHERE					   
			MenuID = @MenuID
	END

END