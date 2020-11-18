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
Select KeyName,Value From SYSTM000Configuration Where Environment IN (0,@environment)
END
GO
