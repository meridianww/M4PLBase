-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].spRemoveOrganization
	@OrganizationID INT
AS
BEGIN
	
	DELETE FROM dbo.[ORGAN000Master] WHERE OrganizationID = @OrganizationID

END