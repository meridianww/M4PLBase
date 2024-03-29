SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================      
-- Author       : Akhil       
-- Create date  : 05 Dec 2017    
-- Description  : To get User Statuses   
-- Modified Date:      
-- Modified By  :      
-- Modified Desc:      
-- ============================================= 

CREATE FUNCTION [dbo].[fnGetUserStatuses]
(
	@userId BIGINT
)
RETURNS @Output TABLE (
      StatusId NVARCHAR(50)
)
AS
BEGIN

DECLARE @userStatuses NVARCHAR(50)

IF EXISTS( SELECT TOP 1 1 FROM [dbo].[SYSTM000Ref_UserSettings] (NOLOCK) usys WHERE usys.UserId=@userId)
	BEGIN
	     
		SELECT @userStatuses = VALUE  FROM [dbo].[fnGetUserSettings] (0, @userId , 'System', 'SysStatusesIn') ;
	END
ELSE
	BEGIN
		SELECT @userStatuses = VALUE  FROM [dbo].[fnGetUserSettings] (0,0 , 'System', 'SysStatusesIn');
	END

	INSERT INTO @Output SELECT * FROM [dbo].[fnSplitString](@userStatuses, ',') 

RETURN 
END
GO
