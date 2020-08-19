
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Prashant Aggarwal
-- Create date: 08/18/2020
-- Description:	Update Last Executed Date Time
-- =============================================
CREATE PROCEDURE [dbo].[UpdateOrderSearchConfiguration]
 @EntityName varchar(50)
,@LastExecuted DATETIME
,@LastLSN BINARY(10)
AS
BEGIN
	IF NOT EXISTS (SELECT 1 FROM [dbo].[OrderSearchConfig] WITH (NOLOCK) WHERE [EntityName] = @EntityName)
	BEGIN 
		INSERT INTO [dbo].[OrderSearchConfig] ([EntityName], [LastExecutedDatetime])
		VALUES (@EntityName, @LastExecuted)
	END
	ELSE
	BEGIN
		UPDATE [dbo].[OrderSearchConfig]
		SET [LastExecutedDatetime] = @LastExecuted, [LastLSN] = @LastLSN
		WHERE [EntityName] = @EntityName
	END  
	
END
