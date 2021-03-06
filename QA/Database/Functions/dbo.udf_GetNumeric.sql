SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Copyright (2019) Meridian Worldwide Transportation Group
-- All Rights Reserved Worldwide
-- Author:		Nathan Fujimoto
-- Create date: 11/26/2019
-- Description:	The User Defined Fucnction returns only the numeric portion of the value 
-- =============================================
CREATE FUNCTION [dbo].[udf_GetNumeric](@sAlphaNumeric NVARCHAR(256))
RETURNS NVARCHAR(256)
AS
BEGIN
	DECLARE @iAlpha INT
	SET @iAlpha = PATINDEX('%[^0-9]%', @sAlphaNumeric)
	BEGIN
		IF ISNUMERIC(@sAlphaNumeric) < 1 AND ISNUMERIC(SUBSTRING(@sAlphaNumeric,2,1)) < 1	
		BEGIN
			WHILE @iAlpha > 0
					BEGIN
						SET @sAlphaNumeric = STUFF(@sAlphaNumeric, @iAlpha, 1, '' )
						SET @iAlpha = PATINDEX('%[^0-9]%', @sAlphaNumeric )
					END
				END
		ELSE
			BEGIN
			IF ISNUMERIC(@sAlphaNumeric) < 1 AND ISNUMERIC(SUBSTRING(@sAlphaNumeric,2,1)) > 0 
				SET @sAlphaNumeric = RIGHT(RTRIM(@sAlphaNumeric), LEN(@sAlphaNumeric)-2)
			END
		END
	RETURN ISNULL(@sAlphaNumeric,0)
END
GO
