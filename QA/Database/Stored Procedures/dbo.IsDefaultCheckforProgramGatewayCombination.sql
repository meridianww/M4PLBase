SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Kamal
-- Create date: 01/06/2020
-- Description:	Checked default program gateway to copy into job gateway for a combination
-- =============================================
CREATE PROCEDURE [dbo].[IsDefaultCheckforProgramGatewayCombination] 
(
@WhereCondition VARCHAR(400)
,@programId BIGINT = NULL
)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @IsExists BIT = 1,@vi INT = 0
	DECLARE @SQLCOMAND NVARCHAR(MAX) = 
	'SELECT @vi = COUNT(ID) FROM dbo.PRGRM010Ref_GatewayDefaults WITH(NOLOCK) WHERE 1=1 AND PgdGatewayDefaultForJob = 1 ' 
	SET @SQLCOMAND += @WhereCondition

EXEC SP_EXECUTESQL 
        @Query  = @SQLCOMAND
      , @Params = N'@vi INT OUTPUT'
      , @vi = @vi OUTPUT
	  
	IF (@vi > 0)
	BEGIN
		SET @IsExists = 0
	END
	ELSE
	BEGIN
	  SET @IsExists = 1
	END

	SELECT @IsExists
END

GO