SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/* Copyright (2018) Meridian Worldwide Transportation Group        
   All Rights Reserved Worldwide */
-- =============================================                
-- Author:                    Manoj Kumar          
-- Create date:               05/07/2020             
-- Description:              Get Gateway code of Jobgateway               
-- =============================================              
CREATE PROCEDURE [dbo].[GetJobGatewayCode] (@Id BIGINT)
AS
BEGIN
	SET NOCOUNT ON;

	SELECT GwyGatewayCode
	FROM [dbo].[JOBDL020Gateways]
	WHERE Id = @Id
END
GO
