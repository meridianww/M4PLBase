
If  NOT EXISTS (select 1 from [SYSTM000MenuDriver] where MnuTitle = 'Locations' )
BEGIN
DECLARE @AppBreakDownStructure NVARCHAR(400)  
DECLARE @MnuBreakDownStructure NVARCHAR(400)  
DEClARE  @newstrucutre int 
SELECT @AppBreakDownStructure =  MnuBreakDownStructure from  [SYSTM000MenuDriver] where   MnuTitle= 'App Reference'
SELECT  @MnuBreakDownStructure= MAX(MnuBreakDownStructure) from [SYSTM000MenuDriver] where MnuBreakDownStructure like @AppBreakDownStructure + '___'
SELECT  @newstrucutre = SUBSTRING(@MnuBreakDownStructure, LEN(@AppBreakDownStructure)+2,LEN(@MnuBreakDownStructure)- LEN(@AppBreakDownStructure)) ;
SELECT @MnuBreakDownStructure =CONCAT(@AppBreakDownStructure,'.0',@newstrucutre+1);
 
If(ISNULL(@MnuBreakDownStructure,'')<>'')
BEGIN
INSERT INTO [dbo].[SYSTM000MenuDriver]
           ([LangCode]
           ,[MnuModuleId]
           ,[MnuTableName]
           ,[MnuBreakDownStructure]
           ,[MnuTitle]
           ,[MnuDescription]
           ,[MnuTabOver]
           ,[MnuMenuItem]
           ,[MnuRibbon]
           ,[MnuRibbonTabName]
           ,[MnuIconVerySmall]
           ,[MnuIconSmall]
           ,[MnuIconMedium]
           ,[MnuIconLarge]
           ,[MnuExecuteProgram]
           ,[MnuClassificationId]
           ,[MnuProgramTypeId]
           ,[MnuOptionLevelId]
           ,[MnuAccessLevelId]
           ,[MnuHelpFile]
           ,[MnuHelpBookMark]
           ,[MnuHelpPageNumber]
           ,[StatusId]
           ,[DateEntered]
           ,[EnteredBy]
           ,[DateChanged]
           ,[ChangedBy])
     VALUES
           ('EN'
           ,NULL
           ,NULL
           ,@MnuBreakDownStructure
           ,'Locations'
           ,NULL
           ,NULL
           ,NULL
           ,1
           ,NULL
           ,NULL
           ,NULL
           ,NULL
           ,NULL
           ,NULL
           ,53
           ,50
           ,NULL
           ,17
           ,NULL
           ,NULL
           ,NULL
           ,1
           ,getdate()
           ,NULL
           ,getdate()
           ,NULL)
  END
 END

