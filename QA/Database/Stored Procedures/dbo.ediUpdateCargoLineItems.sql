SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Copyright (2018) Meridian Worldwide Transportation Group
-- All Rights Reserved Worldwide
-- Author:		Nathan Fujimoto
-- Create date: 4/3/2018
-- Description:	The stored procedure updates the Line Item column for the specified Cargo ID
-- =============================================
CREATE PROCEDURE [dbo].[ediUpdateCargoLineItems]
	-- Add the parameters for the stored procedure here
	@LineItem int,
	@CargoId bigint
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	UPDATE [dbo].[JOBDL010Cargo] SET CgoLineItem = @LineItem WHERE Id = @CargoId
END
GO
