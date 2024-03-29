SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Copyright (2018) Meridian Worldwide Transportation Group
-- All Rights Reserved Worldwide
-- Author:		Nathan Fujimoto
-- Create date: 8/6/2019
-- Description:	The stored procedure returns all the EDI Condition records from the PRGRM072EdiConditions table for a specific Program ID. 
--				
-- =============================================
CREATE PROCEDURE [dbo].[ediGetProgramEdiConditions] 
	-- Add the parameters for the stored procedure here
	@ProgramId bigint,
	@StatusActive nvarchar,
	@EdiDocument nvarchar
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	select header.PehProgramID, conditions.Id, conditions.PecParentProgramId, conditions.PecProgramId, conditions.PecJobField, conditions.PecCondition, conditions.PerLogical, conditions.PecJobField2, conditions.PecCondition2, conditions.PecCondition2  
	FROM PRGRM070EdiHeader header INNER JOIN PRGRM072EdiConditions conditions ON header.id = conditions.PecParentProgramId
	where header.PehProgramID = @ProgramId  and conditions.StatusId = @StatusActive and header.PehEdiDocument = @EdiDocument
END
GO
