SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Prashant Aggarwal
-- Create date: 06/02/2020
-- Description:	Get Job Attachment List By Invoice Number
-- Call Sample EXEC [dbo].[GetJobAttachmentByInvoiceNumber] '7802954228'
-- =============================================
CREATE PROCEDURE [dbo].[GetJobAttachmentByInvoiceNumber] (@invoiceNumber NVARCHAR(50))
AS
BEGIN
	SET NOCOUNT ON;

	SELECT SA.AttFileName [FileName]
		,OP.SysOptionName FileType
		,SA.AttData FileContent
	FROM dbo.JOBDL040DocumentReference JDR
	INNER JOIN dbo.JobDL000Master Job ON Job.Id = JDR.JobId
	INNER JOIN dbo.SYSTM020Ref_Attachments SA ON SA.AttPrimaryRecordID = JDR.Id
		AND SA.StatusId = 1
		AND SA.AttData IS NOT NULL
		AND SA.AttTableName = 'JobDocReference'
	INNER JOIN dbo.SYSTM000Ref_Options OP ON OP.id = JDR.DocTypeId
		AND OP.SysLookupCode = 'JobDocReferenceType'
	WHERE ISNULL(Job.JobSalesInvoiceNumber, '') = @invoiceNumber
		AND JDR.StatusId = 1
    Order By OP.SysOptionName DESC
END

GO
