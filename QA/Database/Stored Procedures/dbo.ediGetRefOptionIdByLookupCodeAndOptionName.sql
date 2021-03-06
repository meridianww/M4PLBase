SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Copyright (2018) Meridian Worldwide Transportation Group
-- All Rights Reserved Worldwide
-- Author:		Nathan Fujimoto
-- Create date: 5/14/2018
-- Description:	The stored procedure returns the ID of the record matching the System Reference Option Name and is a Status Code
-- =============================================
CREATE PROCEDURE [dbo].[ediGetRefOptionIdByLookupCodeAndOptionName]
	-- Add the parameters for the stored procedure here
	@LookupCode nvarchar(100),
	@OptionName nvarchar(100)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT Id FROM [dbo].[SYSTM000Ref_Options] WHERE SysLookupCode = @LookupCode AND SysOptionName = @OptionName AND StatusId = 1
END
GO
