SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/* Copyright (2018) Meridian Worldwide Transportation Group 
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Kamal         
-- Create date:               12/30/2019      
-- Description:               Get all program code by customer ID
-- Execution:                 EXEC [dbo].[GetProgramByCustomer] 10007,'oRIGIN',1
-- Modified on:  
-- Modified Desc:  
-- ============================================= 
create PROCEDURE [dbo].[GetProgramOriginByCustomer] @CustomerId BIGINT
    ,@entity NVARCHAR(40)
	,@pageNo INT =1
	,@pageSize INT =500
	,@like NVARCHAR(500) = NULL
	,@orgId BIGINT=0
AS
BEGIN TRY
	DECLARE @sqlCommand NVARCHAR(MAX) = ''
		,@newPgNo INT, @prgOrgId BIGINT =0;
		 
	IF (@CustomerId IS NOT NULL)
	BEGIN
	IF(@entity = 'Program')
	BEGIN
		SET @sqlCommand = 'SELECT * FROM (SELECT DISTINCT Id,PrgProgramCode AS ProgramCode,PrgProgramTitle as ProgramTittle FROM PRGRM000Master WHERE PrgOrgID = 1 AND StatusId IN (1,2) AND PrgCustID =' + CONVERT(NVARCHAR(50), @CustomerId) +') AS RESULT' 
	END		 
	ELSE IF(@entity = 'Origin')
	BEGIN 
			SET @sqlCommand = 'SELECT DISTINCT CdcLocationCode AS Origin FROM CUST040DCLocations WHERE CdcCustomerID = ' + CAST(@CustomerId AS nvarchar(20)) + ' AND StatusId IN (1,2) AND CdcLocationCode IS NOT NULL AND CdcLocationCode <> '''''
	END 
	END 

		EXEC sp_executesql @sqlCommand
			,N'@pageNo INT, @pageSize INT, @CustomerId BIGINT, @entity NVARCHAR(40)'
			,@pageNo = @pageNo
			,@pageSize = @pageSize
			,@CustomerId = @CustomerId
			,@entity = @entity
 
END TRY

BEGIN CATCH
	DECLARE @ErrorMessage VARCHAR(MAX) = (
			SELECT ERROR_MESSAGE()
			)
		,@ErrorSeverity VARCHAR(MAX) = (
			SELECT ERROR_SEVERITY()
			)
		,@RelatedTo VARCHAR(100) = (
			SELECT OBJECT_NAME(@@PROCID)
			)

	EXEC [dbo].[ErrorLog_InsDetails] @RelatedTo
		,NULL
		,@ErrorMessage
		,NULL
		,NULL
		,@ErrorSeverity
END CATCH
GO
