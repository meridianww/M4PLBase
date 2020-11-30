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
-- Execution:                 EXEC [dbo].[GetRecordsByCustomerEnity] 10007,'Location',1
-- Modified on:  
-- Modified Desc:  
-- ============================================= 
ALTER PROCEDURE [dbo].[GetRecordsByCustomerEnity] 
	@CustomerId BIGINT
	,@entity NVARCHAR(40)
	,@pageNo INT = 1
	,@pageSize INT = 500
	,@like NVARCHAR(500) = NULL
	,@orgId BIGINT = 1
	,@userId BIGINT = 0
	,@roleId BIGINT = 0
AS
BEGIN TRY
	DECLARE @sqlCommand NVARCHAR(MAX) = ''
		,@newPgNo INT
		,@prgOrgId BIGINT = 0
		,@JobCount BIGINT,@IsJobAdmin BIT = 0

IF(@userId <> 0 AND @roleId <> 0)
BEGIN
----------------------------------Security entity ids for job------------------------------------------------
	IF OBJECT_ID('tempdb..#EntityIdJobTemp') IS NOT NULL
	BEGIN
	DROP TABLE #EntityIdJobTemp
	END
	
	 CREATE TABLE #EntityIdJobTemp
	(
	EntityId BIGINT
	)
	
	INSERT INTO #EntityIdJobTemp
	EXEC [dbo].[GetCustomEntityIdByEntityName] @userId, @roleId,@orgId,'Job'
	SELECT @JobCount = Count(ISNULL(EntityId, 0))
	FROM #EntityIdJobTemp
	WHERE ISNULL(EntityId, 0) = -1
	IF (@JobCount = 1)
	BEGIN
		SET @IsJobAdmin = 1
	END 
-----------------------------------------------End-----------------------------------------------------------
----------------------------------Security entity ids for program--------------------------------------------
	IF OBJECT_ID('tempdb..#EntityIdProgamTemp') IS NOT NULL
	BEGIN
	DROP TABLE #EntityIdProgamTemp
	END
	
	 CREATE TABLE #EntityIdProgamTemp
	(
	EntityId BIGINT
	)
	
	INSERT INTO #EntityIdProgamTemp
	EXEC [dbo].[GetCustomEntityIdByEntityName] @userId, @roleId,@orgId,'Program',0,1
-----------------------------------------------End--------------------------------------------------------
END
	CREATE TABLE #Temptbl (colVal NVARCHAR(20))

	IF ((@CustomerId IS NOT NULL) AND (@CustomerId > 0))
	BEGIN
		IF (@entity = 'Program')---security check required---
		BEGIN
			SET @sqlCommand = 'SELECT * FROM (SELECT DISTINCT  '+@entity+'.Id, '+@entity+'.PrgProgramCode AS ProgramCode, '
			+@entity+'.PrgProgramTitle as ProgramTitle FROM PRGRM000Master ' + @entity
				IF(ISNULL(@IsJobAdmin, 0) = 0 AND @userId <> 0 AND @roleId <> 0)
				BEGIN
					SET @sqlCommand = @sqlCommand + ' INNER JOIN #EntityIdProgamTemp tmp ON ' + @entity + '.[Id] = tmp.[EntityId] '
				END  
			SET @sqlCommand = @sqlCommand + ' WHERE  '+@entity+'.PrgOrgID = 1 AND  '+@entity+'.StatusId IN (1,2) AND  '+@entity+'.PrgCustID =' 
			+ CONVERT(NVARCHAR(50), @CustomerId) + ') AS RESULT'
		END
		ELSE IF (@entity = 'Origin')---security check required---
		BEGIN
			SET @sqlCommand = 'SELECT DISTINCT ' + @entity + '.PlantIDCode AS Origin FROM JOBDL000Master ' + @entity
			IF(ISNULL(@IsJobAdmin, 0) = 0 AND @userId <> 0 AND @roleId <> 0)
			BEGIN
				SET @sqlCommand = @sqlCommand + ' INNER JOIN #EntityIdJobTemp tmp ON ' + @entity + '.[Id] = tmp.[EntityId] '
			END
			SET @sqlCommand = @sqlCommand + ' WHERE ' + @entity + '.ProgramID IN '
			+ ' (SELECT Id FROM PRGRM000Master WHERE PrgOrgID = 1 AND StatusId IN (1,2) AND PrgCustID =' + CONVERT(NVARCHAR(50), @CustomerId) + ') '
			+ ' AND ' + @entity + '.StatusId IN (1,2) AND ' + @entity + '.PlantIDCode IS NOT NULL AND ' + @entity + '.PlantIDCode <> '''''
		END
		ELSE IF (@entity = 'Destination')---security check required---
		BEGIN
			SET @sqlCommand = 'SELECT DISTINCT ' + @entity + '.JobSiteCode AS Destination FROM JOBDL000Master ' + @entity
			IF(ISNULL(@IsJobAdmin, 0) = 0 AND @userId <> 0 AND @roleId <> 0)
			BEGIN
				SET @sqlCommand = @sqlCommand + ' INNER JOIN #EntityIdJobTemp tmp ON ' + @entity + '.[Id] = tmp.[EntityId] '
			END
			SET @sqlCommand = @sqlCommand + ' WHERE ' + @entity + '.ProgramID IN (SELECT Id FROM PRGRM000Master WHERE PrgOrgID = 1 AND StatusId IN (1,2) AND PrgCustID =' 
			+ CONVERT(NVARCHAR(50), @CustomerId) + ') '
			+' AND ' + @entity + '.StatusId IN (1,2) AND ' + @entity + '.JobSiteCode IS NOT NULL AND ' + @entity + '.JobSiteCode <> '''''
		END
		ELSE IF (@entity = 'Brand')
		BEGIN
			SET @sqlCommand = 'SELECT DISTINCT JobCarrierContract AS Brand FROM JOBDL000Master WHERE ProgramID IN
			 (SELECT Id FROM PRGRM000Master WHERE PrgOrgID = 1 AND StatusId IN (1,2) AND PrgCustID = ' + CONVERT(NVARCHAR(50), @CustomerId) + ')
			 AND StatusId IN (1,2) AND JobCarrierContract IS NOT NULL AND JobCarrierContract <> '''''
		END
		ELSE IF (@entity = 'GatewayStatus')
		BEGIN
		 	SET @sqlCommand = 'SELECT DISTINCT CASE WHEN GatewayTypeId = 85 THEN PgdGatewayCode ELSE PgdGatewayTitle END AS GatewayStatus FROM PRGRM010Ref_GatewayDefaults 
			WHERE GatewayTypeId  IN (select Id  from SYSTM000Ref_Options  WHERE SysLookupCode = ''GatewayType''
			AND (SysOptionName = ''Gateway'' OR  SysOptionName = ''Action'')) AND 
			PgdProgramID IN (SELECT Id FROM PRGRM000Master WHERE PrgOrgID = 1 AND StatusId IN (1,2) AND PrgCustID = ' + CONVERT(NVARCHAR(50), @CustomerId) + ')
			AND StatusId IN (1,2) AND PgdGatewayCode IS NOT NULL AND PgdGatewayCode <> '''''
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
			SET @sqlCommand = 'select SysOptionName as JobStatusIdName from SYSTM000Ref_Options where SysLookupCode=''Status'' and Id is not null AND StatusId IN (1,2) AND SysOptionName <> ''All'' ORDER BY SysOptionName'
		END
		ELSE IF (@entity = 'JobChannel')
		BEGIN
			SET @sqlCommand = 'SELECT DISTINCT JobChannel FROM JOBDL000Master WHERE ProgramID IN
			 (SELECT Id FROM PRGRM000Master WHERE PrgOrgID = 1 AND StatusId IN (1,2) AND PrgCustID = ' + CONVERT(NVARCHAR(50), @CustomerId) + ')
			 AND StatusId IN (1,2) AND JobChannel IS NOT NULL AND JobChannel <> '''''
		END
		ELSE IF (@entity = 'PackagingCode')
		BEGIN
			SET @sqlCommand = 'select SysOptionName as PackagingCode from SYSTM000Ref_Options where SysLookupCode=''PackagingCode'' and Id is not null AND StatusId IN (1,2) ORDER BY SysOptionName'
		END
		ELSE IF (@entity = 'WeightUnit')
		BEGIN
			SET @sqlCommand = 'select SysOptionName as WeightUnit from SYSTM000Ref_Options where SysLookupCode=''WeightUnittype'' and Id is not null AND StatusId IN (1,2) ORDER BY SysOptionName'
		END
		ELSE IF (@entity = 'CargoTitle')
		BEGIN
			SET @sqlCommand = 'select distinct top 500 CgoTitle AS CargoTitle from JOBDL010Cargo where StatusId =1 AND JobID IN (SELECT ID FROM JOBDL000Master WHERE StatusId =1 AND JobCompleted =0)'
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
			VALUES ('Delivered Date')

			SET @sqlCommand = 'SELECT colVal as DateTypeName FROM #Temptbl'
		END
		ELSE IF (@entity = 'Location')
		BEGIN
		SET @sqlCommand = 'SELECT JobSiteCode AS Location FROM (SELECT DISTINCT JOB.JobSiteCode FROM JOBDL000Master JOB '
		
		  IF(ISNULL(@IsJobAdmin, 0) = 0 AND @userId <> 0 AND @roleId <> 0)
			BEGIN
				SET @sqlCommand = @sqlCommand + ' INNER JOIN #EntityIdJobTemp TJOB ON JOB.Id = TJOB.EntityId '
			END
			SET @sqlCommand = @sqlCommand +' WHERE JOB.ProgramID IN (SELECT ID FROM PRGRM000Master WHERE StatusId IN (1,2) AND PrgCustID =' + CONVERT(NVARCHAR(50), @CustomerId) + ') AND JOB.JobSiteCode IS NOT NULL AND JOB.JobSiteCode <> '''' AND JOB.StatusId IN (1,2)) AS QueryResult'
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
			SET @sqlCommand = 'select SysOptionName as JobStatusIdName from SYSTM000Ref_Options where SysLookupCode=''Status'' and Id is not null AND StatusId IN (1,2) AND SysOptionName <> ''All'' ORDER BY SysOptionName'
		END
		ELSE IF (@entity = 'PackagingCode')
		BEGIN
			SET @sqlCommand = 'select SysOptionName as PackagingCode from SYSTM000Ref_Options where SysLookupCode=''PackagingCode'' and Id is not null AND StatusId IN (1,2) ORDER BY SysOptionName'
		END
		ELSE IF (@entity = 'WeightUnit')
		BEGIN
			SET @sqlCommand = 'select SysOptionName as WeightUnit from SYSTM000Ref_Options where SysLookupCode=''WeightUnittype'' and Id is not null AND StatusId IN (1,2) ORDER BY SysOptionName'
		END
		ELSE IF (@entity = 'CargoTitle')
		BEGIN
			SET @sqlCommand = 'select distinct top 500 CgoTitle AS CargoTitle from JOBDL010Cargo where StatusId =1 AND JobID IN (SELECT ID FROM JOBDL000Master WHERE StatusId =1 AND JobCompleted =0)'
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
			VALUES ('Delivered Date')

			SET @sqlCommand = 'SELECT colVal as DateTypeName FROM #Temptbl'
		END

		ELSE IF (@entity = 'Program')---security check required---
		BEGIN
			SET @sqlCommand = 'SELECT * FROM (SELECT DISTINCT '+@entity+'.Id, '+@entity+'.PrgProgramCode AS ProgramCode, '+@entity+'.PrgProgramTitle as ProgramTitle '
				+ ' FROM PRGRM000Master '+@entity
				IF(ISNULL(@IsJobAdmin, 0) = 0 AND @userId <> 0 AND @roleId <> 0)
				BEGIN
					SET @sqlCommand = @sqlCommand + ' INNER JOIN #EntityIdProgamTemp tmp ON ' + @entity + '.[Id] = tmp.[EntityId] '
				END  
			SET @sqlCommand = @sqlCommand +' WHERE '+@entity+'.PrgOrgID = 1 AND '+@entity+'.StatusId IN (1,2)) AS RESULT'
		    print @sqlCommand
		END
		ELSE IF (@entity = 'Origin')---security check required---
		BEGIN
			SET @sqlCommand = 'SELECT DISTINCT ' + @entity + '.PlantIDCode AS Origin FROM JOBDL000Master ' + @entity
			IF(ISNULL(@IsJobAdmin, 0) = 0 AND @userId <> 0 AND @roleId <> 0)
			BEGIN
				SET @sqlCommand = @sqlCommand + ' INNER JOIN #EntityIdJobTemp tmp ON ' + @entity + '.[Id] = tmp.[EntityId] '
			END  
			--SET @sqlCommand += ' INNER JOIN PRGRM000Master PRG ON PRG.Id = ' + @entity + '.ProgramID AND PRG.PrgOrgID = 1 AND PRG.StatusId IN (1,2) '
			SET @sqlCommand = @sqlCommand + ' WHERE (1=1) ' --+ @entity + '.ProgramID IN (SELECT Id FROM PRGRM000Master WHERE PrgOrgID = 1 AND StatusId IN (1,2) ) '
			+' AND ' + @entity + '.StatusId IN (1,2) AND ' + @entity + '.PlantIDCode IS NOT NULL AND ' + @entity + '.PlantIDCode <> '''''
		END
		ELSE IF (@entity = 'Destination')---security check required---
		BEGIN
			SET @sqlCommand = 'SELECT DISTINCT ' + @entity + '.JobSiteCode AS Destination FROM JOBDL000Master ' + @entity 
			
			IF(ISNULL(@IsJobAdmin, 0) = 0 AND @userId <> 0 AND @roleId <> 0)
			BEGIN
				SET @sqlCommand = @sqlCommand + ' INNER JOIN #EntityIdJobTemp tmp ON ' + @entity + '.[Id] = tmp.[EntityId] '
			END 
			--SET @sqlCommand += ' INNER JOIN PRGRM000Master PRG ON PRG.Id = ' + @entity + '.ProgramID AND PRG.PrgOrgID = 1 AND PRG.StatusId IN (1,2) '
			SET @sqlCommand = @sqlCommand + ' WHERE (1=1) ' --+ @entity + '.ProgramID IN (SELECT Id FROM PRGRM000Master WHERE PrgOrgID = 1 AND StatusId IN (1,2) ) '
			+' AND ' + @entity + '.StatusId IN (1,2) AND ' + @entity + '.JobSiteCode IS NOT NULL AND ' + @entity + '.JobSiteCode <> '''''
			 
		END
		ELSE IF (@entity = 'Brand')
		BEGIN
			SET @sqlCommand = 'SELECT DISTINCT JobCarrierContract AS Brand FROM JOBDL000Master WHERE ProgramID IN
			 (SELECT Id FROM PRGRM000Master WHERE PrgOrgID = 1 AND StatusId IN (1,2) )
			 AND StatusId IN (1,2) AND JobCarrierContract IS NOT NULL AND JobCarrierContract <> '''''
		END
		ELSE IF (@entity = 'GatewayStatus')
		BEGIN
			SET @sqlCommand = 'SELECT DISTINCT CASE WHEN GatewayTypeId = 85 THEN PgdGatewayCode ELSE PgdGatewayTitle END AS GatewayStatus FROM PRGRM010Ref_GatewayDefaults WHERE PgdProgramID IN
			 (SELECT Id FROM PRGRM000Master WHERE PrgOrgID = 1 AND StatusId IN (1,2) )
			 AND StatusId IN (1,2) AND PgdGatewayCode IS NOT NULL AND PgdGatewayCode <> '''''
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
		ELSE IF (@entity = 'Location')
		BEGIN 
		  SET @sqlCommand = 'SELECT JobSiteCode AS Location FROM (SELECT DISTINCT JobSiteCode FROM JOBDL000Master WHERE (1=1) '
							
		  IF(ISNULL(@IsJobAdmin, 0) = 0 AND @userId <> 0 AND @roleId <> 0)
			BEGIN
			--select * from #EntityIdJobTemp
				SET @sqlCommand = @sqlCommand + ' AND Id in (SELECT EntityId FROM #EntityIdJobTemp) '
			END
			ELSE
			BEGIN
				SET @sqlCommand = @sqlCommand +' AND ProgramID IN (SELECT ID FROM PRGRM000Master '
				+ ' WHERE StatusId IN (1,2) AND JobSiteCode IS NOT NULL AND JobSiteCode <> '''' AND StatusId IN (1,2))'
			END
			SET @sqlCommand = @sqlCommand + ' ) AS QueryResult'
		END
	END

	PRINT @sqlCommand
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

GO
