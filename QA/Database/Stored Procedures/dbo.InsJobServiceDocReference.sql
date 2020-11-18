SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Kamal        
-- Create date:               08/21/2018      
-- Description:               Ins a Job Service Doc Reference   
-- Execution:                 EXEC [dbo].[InsJobServiceDocReference]
-- =============================================    
ALTER PROCEDURE [dbo].[InsJobServiceDocReference] (
	@userId BIGINT
	,@roleId BIGINT
	,@jobId BIGINT
	,@jdrCode NVARCHAR(20)
	,@jdrTitle NVARCHAR(50)
	,@docTypeId INT
	,@statusId INT = 1
	,@enteredBy NVARCHAR(50)
	,@dateEntered DATETIME2(7)
	,@uttDocumentAttachment dbo.uttDocumentAttachment READONLY
	)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @updatedItemNumber INT
		,@entity NVARCHAR(100) = 'JobDocReference'
		,@DocRefId BIGINT = 0
		,@NextValue BIGINT
		,@AttachmentCount INT

	SELECT @AttachmentCount = Count(FileName)
	FROM @uttDocumentAttachment

	SELECT @NextValue = NEXT VALUE
	FOR DocumentReferenceSequence

	INSERT INTO [dbo].[EntitySequenceReference]
	VALUES (
		@NextValue
		,'DocumentReference'
		,0
		)

	SET @DocRefId = @NextValue

	SELECT @updatedItemNumber = CASE 
			WHEN COUNT(jdr.Id) IS NULL
				THEN 1
			ELSE COUNT(jdr.Id) + 1
			END
	FROM [JOBDL040DocumentReference] jdr
	INNER JOIN SYSTM000Ref_Options sro ON jdr.DocTypeId = sro.Id
		AND sro.SysLookupCode = 'JobDocReferenceType'
	WHERE jdr.JobID = @jobId
		AND jdr.StatusId = 1

	INSERT INTO [dbo].[JOBDL040DocumentReference] (
		[Id]
		,[JobID]
		,[JdrItemNumber]
		,[JdrCode]
		,[JdrTitle]
		,[DocTypeId]
		,[StatusId]
		,[EnteredBy]
		,[DateEntered]
		,[JdrAttachment]
		)
	VALUES (
		@DocRefId
		,@jobId
		,@updatedItemNumber
		,@jdrCode
		,@jdrTitle
		,@docTypeId
		,@statusId
		,@enteredBy
		,@dateEntered
		,@AttachmentCount
		)

	SELECT @DocRefId Id

	UPDATE [dbo].[EntitySequenceReference]
	SET IsUsed = 1
	WHERE Entity = 'DocumentReference'
		AND SequenceNumber = @DocRefId

	IF (ISNULL(@AttachmentCount, 0) > 0)
	BEGIN
		INSERT INTO [dbo].[SYSTM020Ref_Attachments] (
			[AttPrimaryRecordID]
			,[AttItemNumber]
			,[AttFileName]
			,[AttData]
			,[AttTableName]
			,[AttTypeId]
			,[AttTitle]
			,[StatusId]
			,[DateEntered]
			,[EnteredBy]
			)
		SELECT @DocRefId
			,[ItemNumber]
			,[FileName]
			,[Content]
			,[EntityName]
			,1
			,[Title]
			,1
			,@dateEntered
			,@enteredBy
		FROM @uttDocumentAttachment
	END
END
GO

