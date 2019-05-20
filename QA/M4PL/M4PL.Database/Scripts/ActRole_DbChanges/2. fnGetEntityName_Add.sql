-- =============================================      
-- Author       : Nikhil       
-- Create date  : 19 May 2019    
-- Description  : To Get EntityName    
-- Modified Date:      
-- Modified By  :      
-- Modified Desc:      
-- =============================================  

CREATE FUNCTION [dbo].[fnGetEntityName](@entityId INT)
RETURNS VARCHAR(100)
AS
BEGIN
	DECLARE @entityName VARCHAR(100);
    
	IF(@entityId =1)
		BEGIN
			SET @entityName = 'SystemAccount'
		END
	ELSE IF(@entityId = 2)
		BEGIN
			SET @entityName = 'OrgRefRole'
		END
	RETURN @entityName
END
GO

