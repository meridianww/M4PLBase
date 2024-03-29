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
-- Execution:                 EXEC [dbo].[AddNewUserLoginProvider]
-- Modified on:  
-- Modified Desc:  
-- =============================================

CREATE PROCEDURE [Security].[AddNewUserLoginProvider] (
	 @UserId BIGINT
	,@LoginProvider VARCHAR(50)
	,@ProviderKey VARCHAR(128)
	)
AS
BEGIN
	INSERT INTO [Security].[AUTH030_LoginProvider] (
		[LoginProvider]
		,[ProviderKey]
		,[UserId]
		)
	VALUES (
		@LoginProvider
		,@ProviderKey
		,@UserId
		)
END;
GO
