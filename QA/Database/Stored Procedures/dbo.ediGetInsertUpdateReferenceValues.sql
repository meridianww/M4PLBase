SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Copyright (2018) Meridian Worldwide Transportation Group
-- All Rights Reserved Worldwide
-- Author:		Nathan Fujimoto
-- Create date: 4/17/2018
-- Description:	The stored procedure returns the ID values for the Insert and Update SQL statements in the Reference Option table
-- =============================================
CREATE PROCEDURE [dbo].[ediGetInsertUpdateReferenceValues]
	-- Add the parameters for the stored procedure here
	@ActionInsert nvarchar(100),
	@ActionUpdate nvarchar(100),
	@SqlStatement nvarchar(100)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT [Id] ,[SysOptionName] FROM [SYSTM000Ref_Options] Where (SysOptionName = @ActionInsert OR SysOptionName = @ActionUpdate) AND SysLookupCode = @SqlStatement
END
GO
