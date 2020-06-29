SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Manoj Kumar.S
-- Create date: 05/05/2020
-- Description:	Get Gateway Description 
-- =============================================
CREATE PROCEDURE dbo.GetJobComments
	@JobId BIGINT
AS
BEGIN

	SET NOCOUNT ON;
		 
   SELECT Id, 
   GwyComment,
   GwyGatewayCode
   from JOBDL020Gateways where JobId = @JobId
   AND GwyGatewayCode = 'Comment' AND GwyGatewayTitle = 'Shipping Instruction'
   
END
GO
