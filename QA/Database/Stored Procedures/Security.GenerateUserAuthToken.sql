SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               04/13/2018      
-- Description:               
-- Execution:                 EXEC [dbo].[GenerateUserAuthToken] 
-- Modified on:  
-- Modified Desc:  
-- =============================================
CREATE PROCEDURE [Security].[GenerateUserAuthToken] (
	@Username VARCHAR(50)
	,@CheckExistence BIT = 0
	,@KillOldSession BIT = 0
	)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @userId BIGINT
	DECLARE @authTokenReturn VARCHAR(36) = NULL

	SELECT  @userId = [Id] FROM [dbo].[SYSTM000OpnSezMe] sez WHERE sez.SysScreenName = @Username AND StatusId = 1

	IF ISNULL(@userId, 0) > 0
	BEGIN
		IF (@KillOldSession = 1)
		BEGIN
			UPDATE [Security].[AUTH020_Token]
			SET ExpiresUtc = GETUTCDATE()
				,AccessToken = NULL
				,IsLoggedIn = 0
				,UpdatedDate = GETDATE()
			WHERE UserId = @userId And IsExpired = 0

			DELETE rt FROM [Security].[AUTH010_RefreshToken] rt 
			Inner Join [Security].[AUTH020_Token] uat on uat.Id = rt.Id 
			WHERE UserId = @userId
		END

		IF (@CheckExistence = 1)
		BEGIN
			IF EXISTS (SELECT TOP 1 1 FROM [Security].[AUTH020_Token] uat WHERE uat.UserId = @userId AND uat.IsExpired = 0)
			BEGIN
				SELECT @authTokenReturn UserAuthToken;
				RETURN;
			END
		END

		SET @authTokenReturn = (SELECT REPLACE(CAST(NEWID() AS VARCHAR(36)), '-', ''));	

		INSERT INTO [Security].[AUTH020_Token] (
			 Id
			,UserId
			,IssuedUtc
			,ExpiresUtc
			,IsLoggedIn
			,CreatedDate
			,UpdatedDate
			,IPAddress
			)
		VALUES (
			@authTokenReturn
			,@UserId
			,GETUTCDATE()
			,GETUTCDATE()
			,0
			,GETDATE()
			,GETDATE()
			,N''
			);
	END

	SELECT @authTokenReturn UserAuthTokenId;
END;
GO
