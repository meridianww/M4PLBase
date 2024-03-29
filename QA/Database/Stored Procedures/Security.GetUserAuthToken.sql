SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               04/14/2018      
-- Description:               
-- Execution:                 EXEC [dbo].[GetUserAuthToken]
-- Modified on:  
-- Modified Desc:  
-- =============================================
CREATE PROCEDURE [Security].[GetUserAuthToken] (
	@UserId BIGINT
	,@AccessToken VARCHAR(8000)
	)
AS
BEGIN
	SELECT uat.[Id]
		,uat.[UserId]
		,uat.[AuthClientId]
		,TODATETIMEOFFSET(uat.[IssuedUtc], '+00:00') AS [IssuedUtc] 
		,TODATETIMEOFFSET(uat.[ExpiresUtc], '+00:00') AS [ExpiresUtc]
		,uat.[AccessToken] AS DecodedAccessToken
		,uat.[IsLoggedIn]
		,uat.[CreatedDate]
		,uat.[UpdatedDate]
		,uat.[IsExpired]
	FROM [Security].[AUTH020_Token] uat
	WHERE uat.UserId = @UserId
		AND uat.AccessToken = @AccessToken
END;
GO
