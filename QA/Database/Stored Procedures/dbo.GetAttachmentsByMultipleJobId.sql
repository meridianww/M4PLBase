SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Manoj Kumar.S         
-- Create date:               03/June/2020      
-- Description:               Get a Attachments by Job Is
-- Execution:                 EXEC [dbo].[GetAttachmentByJobId]   126879 
-- Modified on:				  
-- Modified Desc:  
-- ============================================= 
CREATE PROCEDURE [dbo].[GetAttachmentsByMultipleJobId] @JobIdList uttIDList READONLY
AS
BEGIN TRY
	SET NOCOUNT ON;

	Select docRef.Id DocumentId, Op.[SysOptionName] DocumentType INTO #DocumentTemp
    FROM [dbo].[JOBDL040DocumentReference] AS docRef
     INNER JOIN [dbo].[SYSTM000Ref_Options] OP ON OP.Id = docRef.DocTypeId AND OP.SysLookupCode = 'JobDocReferenceType'
     INNER JOIN @JobIdList UTT ON UTT.Id = docRef.[JobID] AND docRef.[StatusId] = 1

	SELECT att.[Id]
		,temp.DocumentType
	FROM [dbo].[SYSTM020Ref_Attachments] att
	INNER JOIN #DocumentTemp temp ON temp.DocumentId = att.AttPrimaryRecordId
	Where att.AttTableName = 'JobDocReference'

	DROP TABLE #DocumentTemp

END TRY

BEGIN CATCH
	DECLARE @ErrorMessage VARCHAR(MAX) = (
			SELECT ERROR_MESSAGE()
			)
		,@ErrorSeverity VARCHAR(MAX) = (
			SELECT ERROR_SEVERITY()
			)
		,@RelatedTo VARCHAR(100) = (
			SELECT OBJECT_NAME(@@PROCID)
			)

	EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo
		,NULL
		,@ErrorMessage
		,NULL
		,NULL
		,@ErrorSeverity
END CATCH

GO
