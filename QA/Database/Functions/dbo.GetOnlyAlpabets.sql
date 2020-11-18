create function dbo.GetOnlyAlpabets(@string varchar(max))

returns varchar(max)

begin

   While PatIndex('%[^a-z]%', @string) > 0

        Set @string = Stuff(@string, PatIndex('%[^a-z]%', @string), 1, '')

return @string

end