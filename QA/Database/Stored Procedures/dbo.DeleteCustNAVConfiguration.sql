SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Kamal      
-- Create date:               12/18/2020
-- Description:               Update/delete Customer Nav Configuration  
-- Execution:                
-- =============================================  
CREATE PROCEDURE DeleteCustNAVConfiguration
    @id BIGINT =0,
	@roleId BIGINT = 0
AS
BEGIN
   IF(@id >0)
       BEGIN
		   UPDATE SYSTM000CustNAVConfiguration 
		   SET StatusId =3 WHERE NAVConfigurationId = @id
		   SELECT 1
		END
		ELSE
		BEGIN
		   SELECT 0
		END  
END