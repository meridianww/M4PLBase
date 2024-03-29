SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Copyright (2018) Meridian Worldwide Transportation Group
-- All Rights Reserved Worldwide
-- Author:		Nathan Fujimoto
-- Create date: 6/21/2018
-- Description:	The stored procedure returns Contact ID of the Program Role that is the default Job Analyst
-- =============================================
CREATE PROCEDURE [dbo].[ediGetProgramDefaultJobAnalyst]
	-- Add the parameters for the stored procedure here
	@ProgramId bigint,
	@StatusId int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT 
		[PrgRoleContactID]
	FROM [dbo].[PRGRM020Program_Role] 
	WHERE PrxJobDefaultAnalyst = 1 AND StatusId = @StatusId AND ProgramID = @ProgramId
END
GO
