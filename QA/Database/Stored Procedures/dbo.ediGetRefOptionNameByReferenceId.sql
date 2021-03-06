SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Copyright (2018) Meridian Worldwide Transportation Group
-- All Rights Reserved Worldwide
-- Author:		Nathan Fujimoto
-- Create date: 5/12/2018
-- Description:	The stored procedure returns the Option Name of the record matching the System Reference Option record ID and is Active
-- =============================================
CREATE PROCEDURE [dbo].[ediGetRefOptionNameByReferenceId]
	-- Add the parameters for the stored procedure here
	@ReferenceId bigint
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT [SysOptionName] FROM [dbo].[SYSTM000Ref_Options] WHERE Id = @ReferenceId AND StatusId = 1
END
GO
