﻿-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].spGetOrganizationDetails
	@OrganizationID INT
AS
BEGIN
	
	SET NOCOUNT ON;
	SELECT * FROM dbo.[ORGAN000Master] (NOLOCK) WHERE OrganizationID = @OrganizationID

END