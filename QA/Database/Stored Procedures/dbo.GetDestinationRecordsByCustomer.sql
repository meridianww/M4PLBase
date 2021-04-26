SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/* Copyright (2018) Meridian Worldwide Transportation Group 
   All Rights Reserved Worldwide */
-- =============================================        
-- Author:                    Kamal         
-- Create date:               12/14/2020      
-- Description:               Get all program code by customer ID
-- Execution:                 EXEC [dbo].[GetDestinationRecordsByCustomer] 10007,1,2,14
-- Modified on:  
-- Modified Desc:  
-- ============================================= 
alter PROCEDURE [dbo].[GetDestinationRecordsByCustomer] @CustomerId BIGINT = 0
	,@orgId BIGINT = 1
	,@userId BIGINT = 0
	,@roleId BIGINT = 0
AS
BEGIN TRY
	DECLARE @JobCount BIGINT
		,@IsJobAdmin BIT = 0

	IF (
			@userId <> 0
			AND @roleId <> 0
			)
	BEGIN
		----------------------------------Security entity ids for job------------------------------------------------
		IF OBJECT_ID('tempdb..#EntityIdVendorTemp') IS NOT NULL
		BEGIN
			DROP TABLE #EntityIdVendorTemp
		END

		CREATE TABLE #EntityIdVendorTemp (EntityId BIGINT PRIMARY KEY)

		INSERT INTO #EntityIdVendorTemp
		EXEC [dbo].[GetCustomEntityIdByEntityName] @userId
			,@roleId
			,@orgId
			,'Vendor'

		SELECT @JobCount = Count(ISNULL(EntityId, 0))
		FROM #EntityIdVendorTemp
		WHERE ISNULL(EntityId, 0) = - 1

		IF (@JobCount = 1)
		BEGIN
			SET @IsJobAdmin = 1
		END
				-----------------------------------------------End-----------------------------------------------------------
	END

	IF (@IsJobAdmin = 0)
	BEGIN
		IF (@CustomerId > 0)
		BEGIN
			--SELECT DISTINCT Prg.JobSiteCode AS Destination FROM [dbo].[vwJobMasterData] Prg (NOEXPAND)
			-- INNER JOIN #EntityIdJobTemp tmp ON Prg.[Id] = tmp.[EntityId] AND PRG.CustomerId=@CustomerId
			-- AND Prg.StatusId IN (1,2)
			SELECT DISTINCT VDC.VdcLocationCode AS Destination, VDC.Id as Id
			FROM VEND040DCLocations VDC
			INNER JOIN PRGRM051VendorLocations PVL ON VDC.VdcVendorID = PVL.PvlVendorID
			INNER JOIN PRGRM000Master P ON PVL.PVLPROGRAMID = P.ID
			INNER JOIN #EntityIdVendorTemp tmp ON VDC.VdcVendorID = tmp.EntityId
			WHERE P.PrgCustID = @CustomerId
				AND VDC.StatusId = 1
				AND PVL.StatusId = 1
				AND P.StatusId = 1
		END
		ELSE
		BEGIN
			SELECT DISTINCT VDC.VdcLocationCode AS Destination, VDC.Id as Id
			FROM VEND040DCLocations VDC
			INNER JOIN #EntityIdVendorTemp tmp ON VDC.VdcVendorID = tmp.EntityId
			WHERE VDC.StatusId = 1
				--SELECT DISTINCT Prg.JobSiteCode AS Destination FROM [dbo].[vwJobMasterData] Prg (NOEXPAND)
				--INNER JOIN #EntityIdJobTemp tmp ON Prg.[Id] = tmp.[EntityId]
				--AND Prg.StatusId IN (1,2)
		END
	END
	ELSE
	BEGIN
		IF (@CustomerId > 0)
		BEGIN
			--SELECT DISTINCT JobSiteCode AS Destination FROM [dbo].[vwJobMasterData] (NOEXPAND)
			--Where CustomerId=@CustomerId
			--AND ISNULL(JobSiteCode,'') <> '' AND StatusId IN (1,2)
			SELECT DISTINCT VDC.VdcLocationCode AS Destination, VDC.Id as Id
			FROM VEND040DCLocations VDC
			INNER JOIN PRGRM051VendorLocations PVL ON VDC.VdcVendorID = PVL.PvlVendorID
			INNER JOIN PRGRM000Master P ON PVL.PVLPROGRAMID = P.ID
			WHERE P.PrgCustID = @CustomerId
				AND VDC.StatusId = 1
				AND PVL.StatusId = 1
				AND P.StatusId = 1
		END
		ELSE
		BEGIN
			--SELECT DISTINCT JobSiteCode AS Destination FROM [dbo].[vwJobMasterData] (NOEXPAND)
			--Where ISNULL(JobSiteCode,'') <> '' AND StatusId IN (1,2)
			SELECT DISTINCT VDC.VdcLocationCode AS Destination, VDC.Id as Id
			FROM VEND040DCLocations VDC
			INNER JOIN PRGRM051VendorLocations PVL ON VDC.VdcVendorID = PVL.PvlVendorID
			WHERE VDC.StatusId = 1
				AND PVL.StatusId = 1
		END
	END
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

