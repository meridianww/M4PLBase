SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================      
-- Author       : Akhil       
-- Create date  : 05 Dec 2017    
-- Description  : To get PascalName    
-- Modified Date:      
-- Modified By  :      
-- Modified Desc:      
-- =============================================  

CREATE function [dbo].[fnGetPascalName](@PascalName varchar(max))
returns varchar(max)
as
begin

    declare @char char(1)
    set @char = 'A'

    -- Loop through the letters A - Z, replace them with a space and the letter
    while ascii(@char) <= ascii('Z')
    begin
        set @PascalName = replace(@PascalName, @char collate Latin1_General_CS_AS, ' ' + @char) 
        set @char = char(ascii(@char) + 1)
    end

    return LTRIM(@PascalName) --remove extra space at the beginning

end
GO
