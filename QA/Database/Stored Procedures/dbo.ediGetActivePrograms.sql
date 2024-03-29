SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Copyright (2018) Meridian Worldwide Transportation Group
-- All Rights Reserved Worldwide
-- Author:		Nathan Fujimoto
-- Create date: 5/31/2018
-- Description:	The stored procedure gets all the active Programs
-- =============================================
CREATE PROCEDURE [dbo].[ediGetActivePrograms]
	-- Add the parameters for the stored procedure here
	@StatusActive nvarchar
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT [Id] FROM [dbo].[PRGRM000Master] WHERE StatusId = @StatusActive
END
GO
