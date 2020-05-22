SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Manoj Kumar.S
-- Create date: 21/May/2020
-- Description:	Get Active Customer
-- =============================================
ALTER PROCEDURE [dbo].[GetActiveCustomers]
AS
BEGIN
	SET NOCOUNT ON;

	SELECT Id
		,CustCode
		,CustTitle
	FROM [dbo].[CUST000Master]
	WHERE StatusId = 1
END
GO
