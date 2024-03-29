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
-- Execution:                 EXEC [dbo].[FindRefreshToken] 
-- Modified on:  
-- Modified Desc:  
-- =============================================
CREATE PROCEDURE [Security].[FindRefreshToken] 
@Id VARCHAR(128)
AS
BEGIN
	SELECT rt.[Id]
		,rt.[Username]
		,rt.[AuthClientId]
		,TODATETIMEOFFSET(rt.[IssuedUtc], '+00:00') AS [IssuedUtc] 
		,TODATETIMEOFFSET(rt.[ExpiresUtc], '+00:00') AS [ExpiresUtc]
		,rt.[ProtectedTicket]
		,rt.[UserAuthTokenId]
	FROM [Security].[AUTH010_RefreshToken] rt
	WHERE rt.Id = @Id
END;
GO
