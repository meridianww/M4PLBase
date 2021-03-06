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
-- Execution:                 EXEC [dbo].[AddRefreshToken]
-- Modified on:  
-- Modified Desc:  
-- =============================================

CREATE PROCEDURE [Security].[AddRefreshToken] (
     @Id VARCHAR(128)
	,@Username VARCHAR(50)
	,@AuthClientId VARCHAR(128)
	,@IssuedUtc DATETIME
	,@ExpiresUtc DATETIME
	,@ProtectedTicket VARCHAR(8000)
	,@UserAuthTokenId VARCHAR(36)
	)
AS
BEGIN	 
	INSERT INTO [Security].[AUTH010_RefreshToken] (
		 [Id]
		,[Username]
		,[AuthClientId]
		,[IssuedUtc]
		,[ExpiresUtc]
		,[ProtectedTicket]
		,[UserAuthTokenId]
		)
	VALUES (
		@Id
		,@Username
		,@AuthClientId
		,@IssuedUtc
		,@ExpiresUtc
		,@ProtectedTicket
		,@UserAuthTokenId
		)

	SELECT @Id AS RefreshTokenId
END;
GO
