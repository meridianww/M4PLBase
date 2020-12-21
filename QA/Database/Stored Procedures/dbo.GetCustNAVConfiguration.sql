SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Kamal      
-- Create date:               12/17/2020
-- Description:               Get Customer Nav Configuration  
-- Execution:                
-- =============================================  
CREATE PROCEDURE [dbo].[GetCustNAVConfiguration] 
@userId BIGINT = 0,
@roleId BIGINT = 0,
@orgId BIGINT = 0,
@id BIGINT = 0
AS
BEGIN
   SELECT * FROM SYSTM000CustNAVConfiguration WHERE NAVConfigurationId = @id 
END

