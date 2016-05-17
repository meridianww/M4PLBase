-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[spRemoveUserAccount] 
	@SysUserID BIGINT
AS
BEGIN

	DELETE FROM dbo.SYSTM000OpnSezMe 
	WHERE 
	SysUserID = @SysUserID
		
END