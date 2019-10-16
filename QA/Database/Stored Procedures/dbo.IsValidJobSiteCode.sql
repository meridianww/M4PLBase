
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


/* Copyright (2019) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Nikhil Chauhan         
-- Create date:               10/03/2019     
-- Description:               IsValidJobSiteCode
-- Execution:                 EXEC IsValidJobSiteCode
-- ============================================= 
CREATE PROCEDURE [dbo].[IsValidJobSiteCode] 
     @userId BIGINT
	,@roleId BIGINT
	,@conOrgId BIGINT
	,@programId BIGINT
	,@jobSiteCode NVARCHAR(50)
	,@langCode nvarchar(50) = 'EN'
AS
BEGIN TRY

	SET NOCOUNT ON;

	 DECLARE @SystemMessage nvarchar(255); 

	IF NOT EXISTS(SELECT TOP 1 1 FROM [dbo].[VEND040DCLocations]where VdcLocationCode =  @jobSiteCode  AND StatusId IN (1,2) )
	BEGIN 
	SET  @SystemMessage =  ( SELECT SysMessageDescription FROM [dbo].[SYSTM000Master] WHERE SysMessageCode = 'IsValidSiteCode' AND LangCode =@langCode)
		END
	ELSE
	BEGIN
	SET  @SystemMessage =  NULL
	END
	Select @SystemMessage;
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


