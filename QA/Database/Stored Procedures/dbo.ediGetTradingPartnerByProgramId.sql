SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Copyright (2018) Meridian Worldwide Transportation Group
-- All Rights Reserved Worldwide
-- Author:		Nathan Fujimoto
-- Create date: 5/31/2018
-- Description:	The stored procedure returns the Trading Parnter Number matching the Program ID
-- =============================================
CREATE PROCEDURE [dbo].[ediGetTradingPartnerByProgramId]
	-- Add the parameters for the stored procedure here
	@ProgramId bigint,
	@StatusActive int,
	@EdiDocument nvarchar(20)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT header.PehEdiCode, header.Id, header.PehProgramID, header.PehTradingPartner, header.PehSCACCode, conditions.PecProgramId 
	FROM  PRGRM070EdiHeader header INNER JOIN PRGRM072EdiConditions conditions 
	ON header.Id = conditions.PecParentProgramId
	WHERE header.PehEdiDocument = @EdiDocument AND conditions.PecProgramId = @ProgramId AND header.StatusId = @StatusActive
END
GO
