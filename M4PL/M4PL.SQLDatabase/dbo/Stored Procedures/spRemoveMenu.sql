CREATE PROCEDURE dbo.[spRemoveMenu]
	@MenuID INT
AS
BEGIN

	DELETE FROM [dbo].[SYSTM000MenuDriver] WHERE MenuID = @MenuID

END