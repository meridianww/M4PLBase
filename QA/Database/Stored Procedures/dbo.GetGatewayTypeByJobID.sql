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
-- Execution:                 EXEC [dbo].[GetGatewayTypeByJobID]  389231  
-- Modified on:  
-- Modified Desc:  
-- =============================================

CREATE PROCEDURE GetGatewayTypeByJobID
@jobGatewayateId BIGINT
AS 
BEGIN
   SELECT GatewayTypeId,GwyGatewayTitle as Tittle FROM  JOBDL020Gateways  where id= @jobGatewayateId  
END