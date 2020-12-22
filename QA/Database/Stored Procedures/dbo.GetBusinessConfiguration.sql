SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetBusinessConfiguration]
(
@environment INT
)
AS
BEGIN
	SET NOCOUNT ON;

WITH Active_CustomerNavConfiguration AS (
  SELECT ServiceUrl,ServiceUserName, ServicePassword,CustomerId, ROW_NUMBER() OVER (PARTITION BY CustomerId ORDER BY NavConfigurationId DESC) AS RowNumber
  FROM dbo.SYSTM000CustNAVConfiguration
  Where StatusId = 1 AND ISNULL(IsProductionEnvironment,0) = CASE WHEN @environment = 1 THEN 1 ELSE 0 END
)

SELECT ServiceUrl,ServiceUserName, ServicePassword,CustomerId FROM Active_CustomerNavConfiguration WHERE RowNumber = 1

Select KeyName,Value From SYSTM000Configuration Where Environment IN (0,@environment)


END
GO
