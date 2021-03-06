SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Copyright (2018) Meridian Worldwide Transportation Group
-- All Rights Reserved Worldwide
-- Author:		Nathan Fujimoto
-- Create date: 9/29/2018
-- Description:	The stored procedure gets the EDI File Locations for the specified Program ID
-- =============================================
CREATE PROCEDURE [dbo].[ediGetEdiFileLocationsByProgramId]
	-- Add the parameters for the stored procedure here
	@ProgramId bigint
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	Select PehInOutFolder, PehArchiveFolder, PehProcessFolder, PehSndRcv From PRGRM070EdiHeader Where PehProgramID = @ProgramId
END
GO
