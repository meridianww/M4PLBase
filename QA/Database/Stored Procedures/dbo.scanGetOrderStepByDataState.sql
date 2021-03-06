SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Copyright (2018) Meridian Worldwide Transportation Group
-- All Rights Reserved Worldwide
-- Author:		Nathan Fujimoto
-- Create date: 6/9/2018
-- Description:	The stored procedure returns the orders that are ready to be sync in the M4PL Job and Gateway Tables
-- =============================================
CREATE PROCEDURE [dbo].[scanGetOrderStepByDataState] 
	-- Add the parameters for the stored procedure here
	@DataState nvarchar
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT [JobID]
      ,[JobFlag11]
      ,[JobFlag12]
      ,[JobFlag13]
	  ,[JobFlag14]
  FROM [dbo].[SCN000Order]
  WHERE [JobFlag12] = @DataState AND JobFlag14 Is Null
END
GO
