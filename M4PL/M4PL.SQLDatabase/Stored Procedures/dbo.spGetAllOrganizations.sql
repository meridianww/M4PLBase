
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].spGetAllOrganizations 
AS
BEGIN
	
	SET NOCOUNT ON;
	SELECT * FROM dbo.[ORGAN000Master] (NOLOCK) ORDER BY OrgSortOrder

END