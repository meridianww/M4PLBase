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
-- Execution:                 EXEC [dbo].[RemoveRefreshToken]
-- Modified on:  
-- Modified Desc:  
-- =============================================
CREATE PROCEDURE [Security].[RemoveRefreshToken] @Id VARCHAR(128)
AS
BEGIN
	DELETE
	FROM [Security].[AUTH010_RefreshToken]
	WHERE Id = @Id
END;
GO
