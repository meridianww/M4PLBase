SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Copyright (2018) Meridian Worldwide Transportation Group
-- All Rights Reserved Worldwide
-- Author:		Nathan Fujimoto
-- Create date: 5/12/2018
-- Description:	The stored procedure sets the archive flag and updates all other Processing Flags to NULL
-- =============================================
CREATE PROCEDURE [dbo].[ediArchive204SummaryRecord] 
	-- Add the parameters for the stored procedure here
	@HeaderID bigint,
	@ArchiveFlag varchar
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	Update EDI204SummaryHeader SET ProFlags01 = @ArchiveFlag, ProFlags02 = Null, ProFlags03 = Null, ProFlags04 = Null, ProFlags05 = Null, ProFlags06 = Null, ProFlags07 = Null, ProFlags08 = Null, ProFlags09 = Null, ProFlags10 = Null WHERE eshHeaderID = @HeaderID
END
GO
