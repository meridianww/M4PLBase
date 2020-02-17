/****** Object:  StoredProcedure [dbo].[GetCustomerLocations]    Script Date: 12/30/2019 6:12:07 PM ******/
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
-- Execution:                 EXEC [dbo].[GetRecordsByCustomerEnity] 0,'program',1
-- Modified on:  
-- Modified Desc:  
-- ============================================= 
CREATE PROCEDURE [dbo].[GetRecordsByCustomerEnity] @CustomerId BIGINT
	,@entity NVARCHAR(40)
	,@pageNo INT = 1
	,@pageSize INT = 500
	,@like NVARCHAR(500) = NULL
	,@orgId BIGINT = 0
AS
BEGIN TRY
	DECLARE @sqlCommand NVARCHAR(MAX) = ''
		,@newPgNo INT
		,@prgOrgId BIGINT = 0;

	CREATE TABLE #Temptbl (colVal NVARCHAR(20))

	IF ((@CustomerId IS NOT NULL) AND (@CustomerId > 0))
	BEGIN
		IF (@entity = 'Program')
		BEGIN
			SET @sqlCommand = 'SELECT * FROM (SELECT DISTINCT Id,PrgProgramCode AS ProgramCode,PrgProgramTitle as ProgramTittle FROM PRGRM000Master WHERE PrgOrgID = 1 AND StatusId IN (1,2) AND PrgCustID =' + CONVERT(NVARCHAR(50), @CustomerId) + ') AS RESULT'
		END
		ELSE IF (@entity = 'Origin')
		BEGIN
			SET @sqlCommand = 'SELECT DISTINCT PlantIDCode AS Origin FROM JOBDL000Master WHERE ProgramID IN
			 (SELECT Id FROM PRGRM000Master WHERE PrgOrgID = 1 AND StatusId IN (1,2) AND PrgCustID =' + CONVERT(NVARCHAR(50), @CustomerId) + ')
			 AND StatusId IN (1,2) AND PlantIDCode IS NOT NULL AND PlantIDCode <> '''''
		END
		ELSE IF (@entity = 'Destination')
		BEGIN
			SET @sqlCommand = 'SELECT DISTINCT JobSiteCode AS Destination FROM JOBDL000Master WHERE ProgramID IN
			 (SELECT Id FROM PRGRM000Master WHERE PrgOrgID = 1 AND StatusId IN (1,2) AND PrgCustID =' + CONVERT(NVARCHAR(50), @CustomerId) + ')
			 AND StatusId IN (1,2) AND JobSiteCode IS NOT NULL AND JobSiteCode <> '''''
		END
		ELSE IF (@entity = 'Brand')
		BEGIN
			SET @sqlCommand = 'SELECT DISTINCT JobCarrierContract AS Brand FROM JOBDL000Master WHERE ProgramID IN
			 (SELECT Id FROM PRGRM000Master WHERE PrgOrgID = 1 AND StatusId IN (1,2) AND PrgCustID = ' + CONVERT(NVARCHAR(50), @CustomerId) + ')
			 AND StatusId IN (1,2) AND JobCarrierContract IS NOT NULL AND JobCarrierContract <> '''''
		END
		ELSE IF (@entity = 'GatewayStatus')
		BEGIN
			SET @sqlCommand = 'SELECT DISTINCT PgdGatewayTitle AS GatewayStatus FROM PRGRM010Ref_GatewayDefaults WHERE PgdProgramID IN
			 (SELECT Id FROM PRGRM000Master WHERE PrgOrgID = 1 AND StatusId IN (1,2) AND PrgCustID = ' + CONVERT(NVARCHAR(50), @CustomerId) + ')
			 AND StatusId IN (1,2) AND PgdGatewayTitle IS NOT NULL AND PgdGatewayTitle <> '''''
		END
		ELSE IF (@entity = 'ServiceMode')
		BEGIN
			SET @sqlCommand = 'SELECT DISTINCT JobServiceMode AS ServiceMode FROM JOBDL000Master WHERE ProgramID IN
			 (SELECT Id FROM PRGRM000Master WHERE PrgOrgID = 1 AND StatusId IN (1,2) AND PrgCustID = ' + CONVERT(NVARCHAR(50), @CustomerId) + ')
			 AND StatusId IN (1,2) AND JobServiceMode IS NOT NULL AND JobServiceMode <> '''''
		END
		ELSE IF (@entity = 'ProductType')
		BEGIN
			SET @sqlCommand = 'SELECT DISTINCT JobProductType AS ProductType FROM JOBDL000Master WHERE ProgramID IN
			 (SELECT Id FROM PRGRM000Master WHERE PrgOrgID = 1 AND StatusId IN (1,2) AND PrgCustID = ' + CONVERT(NVARCHAR(50), @CustomerId) + ')
			 AND StatusId IN (1,2) AND JobProductType IS NOT NULL AND JobProductType <> '''''
		END

		ELSE IF (@entity = 'Scheduled')
		BEGIN
			INSERT INTO #Temptbl
			VALUES ('Scheduled')

			INSERT INTO #Temptbl
			VALUES ('Not Scheduled')

			SET @sqlCommand = 'SELECT colVal as ScheduledName FROM #Temptbl'
		END
		ELSE IF (@entity = 'OrderType')
		BEGIN
			INSERT INTO #Temptbl
			VALUES ('Original')

			INSERT INTO #Temptbl
			VALUES ('Return') 

			SET @sqlCommand = 'SELECT colVal as OrderTypeName FROM #Temptbl'
		END
		ELSE IF (@entity = 'JobStatus')
		BEGIN
			SET @sqlCommand = 'select SysOptionName as JobStatusIdName from SYSTM000Ref_Options where SysLookupCode=''Status'' and Id is not null AND StatusId IN (1,2) ORDER BY SysOptionName'
		END
		ELSE IF (@entity = 'JobChannel')
		BEGIN
			SET @sqlCommand = 'SELECT DISTINCT JobChannel FROM JOBDL000Master WHERE ProgramID IN
			 (SELECT Id FROM PRGRM000Master WHERE PrgOrgID = 1 AND StatusId IN (1,2) AND PrgCustID = ' + CONVERT(NVARCHAR(50), @CustomerId) + ')
			 AND StatusId IN (1,2) AND JobChannel IS NOT NULL AND JobChannel <> '''''
		END
		ELSE IF (@entity = 'DateType')
		BEGIN
			INSERT INTO #Temptbl
			VALUES ('Order Date')

			INSERT INTO #Temptbl
			VALUES ('Shipment Date')

			INSERT INTO #Temptbl
			VALUES ('Receive Date')			

			INSERT INTO #Temptbl
			VALUES ('Schedule Date')

			INSERT INTO #Temptbl
			VALUES ('Delivery Date')

			SET @sqlCommand = 'SELECT colVal as DateTypeName FROM #Temptbl'
		END

	END
	ELSE
	BEGIN

	    IF (@entity = 'Scheduled')
		BEGIN
			INSERT INTO #Temptbl
			VALUES ('Scheduled')

			INSERT INTO #Temptbl
			VALUES ('Not Scheduled')

			SET @sqlCommand = 'SELECT colVal as ScheduledName FROM #Temptbl'
		END
		ELSE IF (@entity = 'OrderType')
		BEGIN
			INSERT INTO #Temptbl
			VALUES ('Original')

			INSERT INTO #Temptbl
			VALUES ('Return')

			SET @sqlCommand = 'SELECT colVal as OrderTypeName FROM #Temptbl'
		END
		ELSE IF (@entity = 'JobStatus')
		BEGIN
			SET @sqlCommand = 'select SysOptionName as JobStatusIdName from SYSTM000Ref_Options where SysLookupCode=''Status'' and Id is not null AND StatusId IN (1,2) ORDER BY SysOptionName'
		END
		ELSE IF (@entity = 'JobChannel')
		BEGIN
			SET @sqlCommand = 'SELECT DISTINCT JobChannel FROM JOBDL000Master WHERE ProgramID IN
			 (SELECT Id FROM PRGRM000Master WHERE PrgOrgID = 1 AND StatusId IN (1,2))
			 AND StatusId IN (1,2) AND JobChannel IS NOT NULL AND JobChannel <> '''''
		END
		ELSE IF (@entity = 'DateType')
		BEGIN
			INSERT INTO #Temptbl
			VALUES ('Order Date')

			INSERT INTO #Temptbl
			VALUES ('Shipment Date')

			INSERT INTO #Temptbl
			VALUES ('Receive Date')

			INSERT INTO #Temptbl
			VALUES ('Schedule Date')

			INSERT INTO #Temptbl
			VALUES ('Delivery Date')

			SET @sqlCommand = 'SELECT colVal as DateTypeName FROM #Temptbl'
		END

		ELSE IF (@entity = 'Program')
		BEGIN
			SET @sqlCommand = 'SELECT * FROM (SELECT DISTINCT Id,PrgProgramCode AS ProgramCode,PrgProgramTitle as ProgramTittle FROM PRGRM000Master WHERE PrgOrgID = 1 AND StatusId IN (1,2)) AS RESULT'
		    print @sqlCommand
		END
		ELSE IF (@entity = 'Origin')
		BEGIN
			SET @sqlCommand = 'SELECT DISTINCT PlantIDCode AS Origin FROM JOBDL000Master WHERE ProgramID IN
			 (SELECT Id FROM PRGRM000Master WHERE PrgOrgID = 1 AND StatusId IN (1,2) )
			 AND StatusId IN (1,2) AND PlantIDCode IS NOT NULL AND PlantIDCode <> '''''
		END
		ELSE IF (@entity = 'Destination')
		BEGIN
			SET @sqlCommand = 'SELECT DISTINCT JobSiteCode AS Destination FROM JOBDL000Master WHERE ProgramID IN
			 (SELECT Id FROM PRGRM000Master WHERE PrgOrgID = 1 AND StatusId IN (1,2) )
			 AND StatusId IN (1,2) AND JobSiteCode IS NOT NULL AND JobSiteCode <> '''''
			 
		END
		ELSE IF (@entity = 'Brand')
		BEGIN
			SET @sqlCommand = 'SELECT DISTINCT JobCarrierContract AS Brand FROM JOBDL000Master WHERE ProgramID IN
			 (SELECT Id FROM PRGRM000Master WHERE PrgOrgID = 1 AND StatusId IN (1,2) )
			 AND StatusId IN (1,2) AND JobCarrierContract IS NOT NULL AND JobCarrierContract <> '''''
		END
		ELSE IF (@entity = 'GatewayStatus')
		BEGIN
			SET @sqlCommand = 'SELECT DISTINCT PgdGatewayTitle AS GatewayStatus FROM PRGRM010Ref_GatewayDefaults WHERE PgdProgramID IN
			 (SELECT Id FROM PRGRM000Master WHERE PrgOrgID = 1 AND StatusId IN (1,2) )
			 AND StatusId IN (1,2) AND PgdGatewayTitle IS NOT NULL AND PgdGatewayTitle <> '''''
		END
		ELSE IF (@entity = 'ServiceMode')
		BEGIN
			SET @sqlCommand = 'SELECT DISTINCT JobServiceMode AS ServiceMode FROM JOBDL000Master WHERE ProgramID IN
			 (SELECT Id FROM PRGRM000Master WHERE PrgOrgID = 1 AND StatusId IN (1,2) )
			 AND StatusId IN (1,2) AND JobServiceMode IS NOT NULL AND JobServiceMode <> '''''
		END
		ELSE IF (@entity = 'ProductType')
		BEGIN
			SET @sqlCommand = 'SELECT DISTINCT JobProductType AS ProductType FROM JOBDL000Master WHERE ProgramID IN
			 (SELECT Id FROM PRGRM000Master WHERE PrgOrgID = 1 AND StatusId IN (1,2) )
			 AND StatusId IN (1,2) AND JobProductType IS NOT NULL AND JobProductType <> '''''
		END


	END



	EXEC sp_executesql @sqlCommand
		,N'@pageNo INT, @pageSize INT, @CustomerId BIGINT, @entity NVARCHAR(40)'
		,@pageNo = @pageNo
		,@pageSize = @pageSize
		,@CustomerId = @CustomerId
		,@entity = @entity

	DROP TABLE #Temptbl
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