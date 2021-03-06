SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Copyright (2018) Meridian Worldwide Transportation Group
-- All Rights Reserved Worldwide
-- Author:		Nathan Fujimoto
-- Create date: 4/3/2018
-- Description:	The stored procedure returns the Insert, Update, Cancel, Hold, Original, and Return Codes for the Trading Partner and EDI Document specified
-- =============================================
CREATE PROCEDURE [dbo].[ediGetSetPurposeCodesByProgramId]
 
	-- Add the parameters for the stored procedure here
	@ProgramId bigint,
	@EdiDocument nvarchar(20),
	@StatusId int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	Select PehTradingPartner, PehInsertCode, PehUpdateCode, PehCancelCode, PehHoldCode, PehOriginalCode, PehReturnCode FROM PRGRM070EdiHeader WHERE PehProgramID = @ProgramId AND StatusId = @StatusId AND PehEdiDocument = @EdiDocument
END
GO
