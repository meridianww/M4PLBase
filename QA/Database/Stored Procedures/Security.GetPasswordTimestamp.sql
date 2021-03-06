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
-- Execution:                 EXEC [dbo].[GetPasswordTimestamp]
-- Modified on:  
-- Modified Desc:  
-- =============================================

CREATE PROCEDURE [Security].[GetPasswordTimestamp](
	@userId BIGINT
)
AS
BEGIN
Select Cast([UpdatedTimestamp] AS BIGINT) AS [PasswordTimestamp] FROM [Security].[AUTH050_UserPassword] WHERE UserId = @userId

END;
GO
