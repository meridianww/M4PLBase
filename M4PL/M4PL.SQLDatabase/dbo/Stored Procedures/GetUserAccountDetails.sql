-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetUserAccountDetails] 
	@SysUserID BIGINT
AS
BEGIN
	
	SET NOCOUNT ON;
	SELECT * FROM dbo.SYSTM000OpnSezMe (NOLOCK) WHERE SysUserID = @SysUserID

END