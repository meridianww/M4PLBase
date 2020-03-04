SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Copyright (2018) Meridian Worldwide Transportation Group
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Akhil Chauhan         
-- Create date:               10/31/2018      
-- Description:               Check record before delete  
-- Execution:                 EXEC [dbo].[GetGatewayTypeByJobID]  725469  
-- Modified on:  
-- Modified Desc:  
-- =============================================

ALTER PROCEDURE GetGatewayTypeByJobID
@jobGatewayateId BIGINT
AS 
BEGIN
   SELECT GatewayTypeId,GwyTitle as Title FROM  JOBDL020Gateways  where id= @jobGatewayateId  
END