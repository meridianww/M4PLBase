CREATE PROCEDURE dbo.RemoveMenu
	@MenuID INT
AS
BEGIN

	DELETE FROM [dbo].[SYSTM000MenuDriver] WHERE MenuID = @MenuID

END