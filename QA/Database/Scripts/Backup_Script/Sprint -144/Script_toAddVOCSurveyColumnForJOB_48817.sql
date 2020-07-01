IF NOT  EXISTS(SELECT 1 FROM sys.columns 
          WHERE Name = N'IsJobVocSurvey'
          AND Object_ID = Object_ID(N'[dbo].[JOBDL000Master]'))
BEGIN
 ALTER TABLE [dbo].[JOBDL000Master] ADD IsJobVocSurvey BIT Default(0)
END