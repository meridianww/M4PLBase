-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[RemoveContact] 
	@ContactID INT
AS
BEGIN
	
	DELETE FROM DBO.CONTC000Master WHERE ContactID = @ContactID

END