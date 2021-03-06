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
-- Execution:                 EXEC [dbo].[GetAllRefreshToken] 
-- Modified on:  
-- Modified Desc:  
-- =============================================
CREATE PROCEDURE [Security].[GetAllRefreshToken]
AS
BEGIN
	SELECT [Id]
		,[Username]
		,[AuthClientId] 
		,TODATETIMEOFFSET([IssuedUtc], '+00:00') AS [IssuedUtc] 
		,TODATETIMEOFFSET([ExpiresUtc], '+00:00') AS [ExpiresUtc]
		,[ProtectedTicket]
		,[UserAuthTokenId]
	FROM [Security].[AUTH010_RefreshToken]
END;
GO
