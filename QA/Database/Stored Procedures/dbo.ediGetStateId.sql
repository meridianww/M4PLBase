SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Copyright (2018) Meridian Worldwide Transportation Group
-- All Rights Reserved Worldwide
-- Author:		Nathan Fujimoto
-- Create date: 4/3/2018
-- Description:	The stored procedure returns the State ID from the SYSTM000Ref_State table matching the two character State code.
-- =============================================
CREATE PROCEDURE [dbo].[ediGetStateId] 
	-- Add the parameters for the stored procedure here
	@State varchar(25),
	@CountryId int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT Id FROM SYSTM000Ref_States WHERE StateAbbr = @State And StateCountryId = @CountryId
END
GO
