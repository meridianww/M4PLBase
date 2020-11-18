SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetJobIdByActualControlId] 
@UttStringIdList dbo.UttStringIdList READONLY
AS
BEGIN
SET NOCOUNT ON;

Select Job.Id JobId, Temp.Id ActualControlId From dbo.JobDL000Master Job
INNER JOIN @UttStringIdList Temp ON dbo.udf_GetNumeric(Job.JobCustomerSalesOrder) = Temp.Id
END
GO
