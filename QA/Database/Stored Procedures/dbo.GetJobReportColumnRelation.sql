SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetJobReportColumnRelation] 
(
@reportTypeId INT
)
AS
BEGIN
	SET NOCOUNT ON;
Select ReportId ReportType, ColumnId From dbo.Job080ReportColumnRelation
Where ReportId = @reportTypeId
END
GO
