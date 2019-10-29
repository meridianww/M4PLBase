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
Create PROCEDURE [dbo].[ediGetProgramEdiConditions] 
	-- Add the parameters for the stored procedure here
	@ProgramId bigint
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT Id, PecParentProgramId, PecProgramId, PecJobField, PecCondition, PerLogical, PecJobField2, PecCondition2, PecCondition2 FROM PRGRM072EdiConditions WHERE PecParentProgramId = @ProgramId
END

GO
