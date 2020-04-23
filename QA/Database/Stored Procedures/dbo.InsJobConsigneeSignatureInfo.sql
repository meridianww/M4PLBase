SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Kamal       
-- Create date:               04/23/2020      
-- Description:               Insert record into ConsigneeSignatureInfo
-- Execution:                 EXEC [dbo].[InsJobConsigneeSignatureInfo] 1234,'kamal',NULL
-- Modified on:				     
-- Modified Desc:  
-- ============================================= 
CREATE PROCEDURE InsJobConsigneeSignatureInfo @JobId BIGINT NULL
	,@UserName NVARCHAR(200) NULL
	,@Signature VARBINARY(MAX) NULL
AS
BEGIN
	--IF NOT EXISTS (
	--		SELECT 1
	--		FROM [dbo].[ConsigneeSignatureInfo]
	--		WHERE JobId = @JobId
	--		)
	--BEGIN
		INSERT INTO [dbo].[ConsigneeSignatureInfo] (
			FirstName
			,LastName
			,JobId
			,[Signature]
			,CreatedDate
			)
		VALUES (
			@UserName
			,NULL
			,@JobId
			,@Signature
			,GETUTCDATE()
			)
	-- END
END