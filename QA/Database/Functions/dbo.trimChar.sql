CREATE FUNCTION [dbo].[trimChar]
(
    @p_string  varchar(max),
    @p_char varchar(1)
)
RETURNS varchar(max)
AS
BEGIN
   declare @l_string varchar(max) = @p_string
   -- lets do the front
   while SUBSTRING(@l_string,1,1) = @p_char
   begin
      set @l_string = substring(@l_string,2,len(@l_string))
   end

   -- lets do the back
   set @l_string = reverse(@l_string)
   while SUBSTRING(@l_string,1,1) = @p_char
   begin
      set @l_string = substring(@l_string,2,len(@l_string))
   end
   set @l_string = reverse(@l_string)

   return @l_string

END