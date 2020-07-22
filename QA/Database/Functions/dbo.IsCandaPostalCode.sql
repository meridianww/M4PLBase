SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================  
-- Author       : Prashant Aggarwal  
-- Create date  : 14 July 2020
-- Description  : If Passed String is a Valid Canadian Zip Code Then Return 0 else -1  
-- ============================================= 
CREATE FUNCTION dbo.IsCandaPostalCode (@PostalCode NVARCHAR(10))
RETURNS BIT
AS
BEGIN
	DECLARE @Result BIT
	DECLARE @i INT

	SET @Result = 0
	SET @i = 1
	SET @PostalCode = Upper(Replace(LTrim(@PostalCode), ' ', ''))
	IF Len(@PostalCode) <> 6
		SET @Result = - 1
	ELSE
		WHILE (@i <= 6)
		BEGIN
			IF (@i % 2 = 1)
				AND SubString(@PostalCode, @i, 1) NOT BETWEEN 'A'
					AND 'Z'
				SET @Result = - 1
			ELSE IF (@i % 2 = 0)
				AND SubString(@PostalCode, @i, 1) NOT BETWEEN '0'
					AND '9'
				SET @Result = - 1
			SET @i = @i + 1
		END

	RETURN @Result
END
GO

