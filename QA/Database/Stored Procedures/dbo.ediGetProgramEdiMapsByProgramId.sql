SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Copyright (2018) Meridian Worldwide Transportation Group
-- All Rights Reserved Worldwide
-- Author:		Nathan Fujimoto
-- Create date: 4/3/2018
-- Description:	The stored procedure returns all the EDI Mapping records from the PRGRM071EdiMapping table for a specific Program ID. 
--				The Status of the EDI Header and Mapping Records needs to be 'Active' (value of 1)
-- =============================================
CREATE PROCEDURE [dbo].[ediGetProgramEdiMapsByProgramId]


	@EdiHeaderStatus int,
	@ProgramId bigint,
	@EdiMappingStatus int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	Select  EdiHeader.PehProgramID, EdiHeader.PehTradingPartner, PehItemNumber, EdiHeader.PehEdiDocument, EdiHeader.PehSndRcv,  ediMap.[PemInsertUpdate], ediMap.[PemEdiTableName],ediMap.[PemEdiFieldName],ediMap.[PemEdiFieldDataType],ediMap.[PemSysTableName],ediMap.[PemSysFieldName],ediMap.[PemSysFieldDataType], EdiHeader.PehInsertCode, EdiHeader.PehUpdateCode, EdiHeader.PehCancelCode, EdiHeader.PehHoldCode, EdiHeader.PehOriginalCode, EdiHeader.PehReturnCode, EdiHeader.PehSCACCode, EdiHeader.PehParentEDI  from PRGRM071EdiMapping As ediMap Inner Join PRGRM070EdiHeader As EdiHeader On ediMap.[PemHeaderID] = EdiHeader.Id  AND EdiHeader.StatusId = @EdiHeaderStatus And EdiHeader.PehProgramID = @ProgramId And ediMap.StatusId = @EdiMappingStatus Order By EdiHeader.PehProgramID asc, EdiHeader.PehItemNumber asc
END
GO
