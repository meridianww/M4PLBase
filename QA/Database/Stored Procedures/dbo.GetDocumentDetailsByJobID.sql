SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/* Copyright (2018) Meridian Worldwide Transportation Group  
   All Rights Reserved Worldwide */
-- =============================================          
-- Author:                    Kamal          
-- Create date:               08/22/2020      
-- Description:               Get a Job Details by job id  
-- Exec :					  Exec GetOrderDetailsById 170712   
-- =============================================  
CREATE PROCEDURE GetDocumentDetailsByJobID @userId BIGINT
	,@roleId BIGINT
	,@orgId BIGINT = 1
	,@id BIGINT
AS
BEGIN
	DECLARE @IsLoginUser BIT = 0;

	IF (
			@userId = 0
			AND @roleId = 0
			AND @orgId = 0
			)
	BEGIN
		SET @IsLoginUser = 0
	END
	ELSE
	BEGIN
		SET @IsLoginUser = 1
	END
	IF (@IsLoginUser = 1)
	BEGIN
		SELECT ATT.Id
			,DOCUMENT.JobID
			,DOCUMENT.JdrTitle JdrCode
			,ATT.AttFileName JdrTitle
			,DOCUMENT.DocTypeId
			,OPT.SysOptionName AS DocTypeIdName
		FROM JOBDL040DocumentReference DOCUMENT
		INNER JOIN [dbo].[SYSTM020Ref_Attachments] ATT ON ATT.AttPrimaryRecordID = DOCUMENT.Id
			AND ATT.AttTableName = 'JobDocReference'
		LEFT JOIN SYSTM000Ref_Options OPT ON OPT.Id = DOCUMENT.DocTypeId
		WHERE DOCUMENT.JobID = @id
			AND ATT.StatusId = 1
			AND DOCUMENT.StatusId = 1
	END
END