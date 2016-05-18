CREATE FUNCTION dbo.fnSpaceBeforeCap
(
	@str NVARCHAR(MAX)
)
RETURNS NVARCHAR(MAX)
AS
BEGIN

	DECLARE @i INT, @j INT
	DECLARE @returnval NVARCHAR(MAX) = ''
	SELECT @i = 1, @j = LEN(@str)

	DECLARE @w NVARCHAR(MAX)

	WHILE @i <= @j
	BEGIN
		IF SUBSTRING(@str,@i,1) = UPPER(SUBSTRING(@str,@i,1)) COLLATE Latin1_General_CS_AS
		BEGIN
			IF @w IS NOT NULL
			SET @returnval = @returnval + ' ' + @w
			SET @w = SUBSTRING(@str,@i,1)
		END
		ELSE
			SET @w = @w + SUBSTRING(@str,@i,1)
		SET @i = @i + 1
	END
	IF @w IS NOT NULL
		SET @returnval = @returnval + ' ' + @w

	RETURN LTRIM(@returnval)

END

--SELECT dbo.fnSpaceBeforeCap('ThisIsAString')