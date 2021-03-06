SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================  
-- Author       : JANARDANA B  
-- Create date  : 20 July 2016
-- Description  : Split String with character and output as table  
-- Modified Date:  
-- Modified By  :  
-- Modified Desc:  
-- ============================================= 

CREATE FUNCTION [dbo].[fnSplitString]
(    
      @Input NVARCHAR(MAX),
      @Character CHAR(1)
)
RETURNS @Output TABLE (
      Item NVARCHAR(1000)
)
AS
BEGIN
      DECLARE @StartIndex INT, @EndIndex INT, @CurrentItem NVARCHAR(100)
 
      SET @StartIndex = 1
      IF SUBSTRING(@Input, LEN(@Input) - 1, LEN(@Input)) <> @Character
      BEGIN
            SET @Input = @Input + @Character
      END
 
      WHILE CHARINDEX(@Character, @Input) > 0
      BEGIN
            SET @EndIndex = CHARINDEX(@Character, @Input)
			SELECT @CurrentItem = SUBSTRING(@Input, @StartIndex, @EndIndex - 1)
            IF(LTRIM(RTRIM(@CurrentItem)) <> '')
			BEGIN
				INSERT INTO @Output(Item) VALUES(@CurrentItem)
			END
           
            SET @Input = SUBSTRING(@Input, @EndIndex + 1, LEN(@Input))
      END
 
      RETURN
END
GO
