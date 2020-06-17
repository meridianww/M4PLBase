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
CREATE PROCEDURE [dbo].[GetAttachmentByJobId] @Jobid BIGINT
AS
BEGIN TRY
	SET NOCOUNT ON;

	SELECT att.[Id]
		,att.[AttTableName]
		,att.[AttPrimaryRecordID]
		,att.[AttItemNumber]
		,job.[JobCustomerSalesOrder] AS [AttTitle]
		,att.[AttTypeId]
		,att.[AttFileName]
		,att.[AttData]
		,att.[DateEntered]
		,att.[EnteredBy]
		,att.[DateChanged]
		,att.[ChangedBy]
		,att.[AttDownloadDate]
		,att.[AttDownloadedDate]
		,att.[AttDownloadedBy]
		,Op.[SysOptionName] DocumentType
	FROM [dbo].[JOBDL040DocumentReference] AS docRef
	INNER JOIN [dbo].[SYSTM000Ref_Options] OP ON OP.Id = docRef.DocTypeId
		AND OP.SysLookupCode = 'JobDocReferenceType'
	INNER JOIN [dbo].[SYSTM020Ref_Attachments] att ON docRef.Id = att.AttPrimaryRecordId
		AND att.AttTableName = 'JobDocReference'
	INNER JOIN [dbo].[JobDL000Master] job ON job.Id = docRef.[JobID]
	WHERE docRef.[JobID] = @Jobid
		AND docRef.[StatusId] = 1
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

