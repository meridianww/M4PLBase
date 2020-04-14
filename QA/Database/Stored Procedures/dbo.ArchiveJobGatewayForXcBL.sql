SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/* Copyright (2018) Meridian Worldwide Transportation Group        
   All Rights Reserved Worldwide */
-- =============================================                
-- Author:                    Prashant Aggarwal             
-- Create date:               04/14/2020             
-- Description:              ArchiveJobGatewayForXcBL               
-- =============================================              
CREATE PROCEDURE [dbo].[ArchiveJobGatewayForXcBL] (
	@JobID BIGINT
	,@ProgramID BIGINT
	,@GwyGatewayCode NVARCHAR(50)
	,@DateChanged DATETIME2(7)
	,@ChangedBy NVARCHAR(50)
	)
AS
BEGIN
	SET NOCOUNT ON;

	UPDATE [dbo].[JOBDL020Gateways]
	SET StatusId = 3
		,DateChanged = @DateChanged
		,ChangedBy = @ChangedBy
	WHERE GwyGatewayCode = @GwyGatewayCode
		AND JobID = @JobID
		AND ProgramID = @ProgramID
END
GO

