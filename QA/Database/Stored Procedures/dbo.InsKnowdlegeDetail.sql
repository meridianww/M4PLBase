SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Kamal         
-- Create date:               12/11/2020    
-- Description:               Insert Knowdlege Detail
-- Execution:                 EXEC [dbo].[InsKnowledgeDetail] 'Document Name.pdf','https://www.localhost:56136.com','Document Name'
-- Modified on:  
-- Modified Desc:  
-- =============================================
ALTER PROCEDURE [dbo].[InsKnowledgeDetail]
@DocumentName NVARCHAR(100),
@Url NVARCHAR(50),
@FileName NVARCHAR(90)
AS
BEGIN
	IF NOT EXISTS(SELECT 1 FROM SYSTM000KnowdlegeDetail WHERE CategoryId=2 AND Name= @DocumentName)
		BEGIN
			INSERT INTO dbo.SYSTM000KnowdlegeDetail (CategoryId, Name, DisplayName, URL, DateEntered, EnteredBy, StatusId)
			VALUES (2, @DocumentName, @FileName,
			@Url+'/Video/Document/'+ @DocumentName , GETUTCDATE(), 'System', 1)
			SELECT 1;
		END
	ELSE
		BEGIN
		  SELECT 0;
		END
END