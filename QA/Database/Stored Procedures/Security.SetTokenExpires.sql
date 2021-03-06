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
-- Execution:                 EXEC [dbo].[SetTokenExpires]
-- Modified on:  
-- Modified Desc:  
-- =============================================
CREATE PROCEDURE [Security].[SetTokenExpires] 
-- Add the parameters for the stored procedure here
@UserId BIGINT
,@UserAuthTokenId VARCHAR(36)
AS
BEGIN
DECLARE @rowCount INT = 0;

-- SET NOCOUNT ON added to prevent extra result sets from
UPDATE [Security].[AUTH020_Token]
SET AccessToken = NULL
,ExpiresUtc = GETUTCDATE()
,IsLoggedIn = 0
,UpdatedDate = GETDATE()
WHERE [UserId] = @UserId AND Id = @UserAuthTokenId

SET @rowCount = (
SELECT @@ROWCOUNT
);

IF @rowCount > 0
BEGIN
UPDATE SYSTM000OpnSezMe 
SET  SysLoggedInCount = CASE WHEN SysLoggedInCount > 0 THEN SysLoggedInCount - 1 ELSE SysLoggedInCount END
    ,SysLoggedInEnd = CASE WHEN SysLoggedInCount = 1 THEN  GETUTCDATE() ELSE SysLoggedInEnd END
	,SysLoggedIn = CASE WHEN SysLoggedInCount = 1 THEN  0  ELSE SysLoggedIn END
WHERE Id = @UserId;
END
DELETE FROM [Security].[AUTH010_RefreshToken] WHERE UserAuthTokenId = @UserAuthTokenId
SELECT @rowCount
END
GO
