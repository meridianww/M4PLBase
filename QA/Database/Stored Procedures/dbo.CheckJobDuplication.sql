SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Prashant Aggarwal
-- Create date: 04/08/2020
-- Description:	Check Job Duplication
-- =============================================
CREATE PROCEDURE [dbo].[CheckJobDuplication] --'NM A3666614',10012
(
@CustomerSalesOrderNo VARCHAR(150)
,@programId BIGINT = NULL
)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @IsExists BIT = 1, @CustomerId BIGINT

	IF EXISTS (
			SELECT 1
			FROM dbo.JOBDL000Master Job WITH(NOLOCK)
			INNER JOIN dbo.PRGRM000Master Prg WITH(NOLOCK) ON Prg.Id = Job.ProgramId
			WHERE Job.ProgramId = @programId AND Job.JobCustomerSalesOrder = @CustomerSalesOrderNo AND Job.StatusId= 1
			)
	BEGIN
		SET @IsExists = 0
	END

	SELECT @IsExists
END

GO
