SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetJobAdditionalInfo] (@id BIGINT)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @JobDeliveryAnalystContactIDName NVARCHAR(100)
		,@JobDeliveryResponsibleContactIDName NVARCHAR(100)
		,@JobQtyUnitTypeIdName NVARCHAR(50)
		,@JobCubesUnitTypeIdName NVARCHAR(50)
		,@JobWeightUnitTypeIdName NVARCHAR(50)
		,@JobOriginResponsibleContactIDName NVARCHAR(50)
		,@JobDriverIdName NVARCHAR(100)

	SELECT @JobDeliveryAnalystContactIDName = ConFullName
	FROM CONTC000Master
	WHERE Id = (
			SELECT JobDeliveryAnalystContactID
			FROM JOBDL000Master
			WHERE Id = @ID
			)

	SELECT @JobDeliveryResponsibleContactIDName = ConFullName
	FROM CONTC000Master
	WHERE Id = (
			SELECT JobDeliveryResponsibleContactID
			FROM JOBDL000Master
			WHERE Id = @ID
			)

	SELECT @JobOriginResponsibleContactIDName = ConFullName
	FROM CONTC000Master
	WHERE Id = (
			SELECT JobOriginResponsibleContactID
			FROM JOBDL000Master
			WHERE Id = @ID
			)

	SELECT @JobDriverIdName = ConFullName
	FROM CONTC000Master
	WHERE Id = (
			SELECT JobDriverId
			FROM JOBDL000Master
			WHERE Id = @ID
			)

	SELECT @JobQtyUnitTypeIdName = SysOptionName
	FROM SYSTM000Ref_Options
	WHERE Id = CASE 
			WHEN (
					SELECT JobQtyUnitTypeId
					FROM JOBDL000Master
					WHERE Id = @ID
					) = 0
				THEN (
						SELECT ID
						FROM SYSTM000Ref_Options
						WHERE SysLookupCode = 'CABINET'
						)
			ELSE (
					SELECT JobQtyUnitTypeId
					FROM JOBDL000Master
					WHERE Id = @ID
					)
			END

	SELECT @JobCubesUnitTypeIdName = SysOptionName
	FROM SYSTM000Ref_Options
	WHERE Id = CASE 
			WHEN (
					SELECT JobCubesUnitTypeId
					FROM JOBDL000Master
					WHERE Id = @ID
					) = 0
				THEN (
						SELECT ID
						FROM SYSTM000Ref_Options
						WHERE SysLookupCode = 'E'
						)
			ELSE (
					SELECT JobCubesUnitTypeId
					FROM JOBDL000Master
					WHERE Id = @ID
					)
			END;

	SELECT @JobWeightUnitTypeIdName = SysOptionName
	FROM SYSTM000Ref_Options
	WHERE Id = CASE 
			WHEN (
					SELECT JobWeightUnitTypeId
					FROM JOBDL000Master
					WHERE Id = @ID
					) = 0
				THEN (
						SELECT ID
						FROM SYSTM000Ref_Options
						WHERE SysLookupCode = 'K'
						)
			ELSE (
					SELECT JobWeightUnitTypeId
					FROM JOBDL000Master
					WHERE Id = @ID
					)
			END;

	SELECT CAST(ISNULL(Customer.CustERPID, 0) AS BIGINT) CustomerERPId
		,CAST(ISNULL(Vendor.VendERPID, 0) AS BIGINT) VendorERPId
		,JOM.SONumber JobSONumber
		,JPM.PONumber JobPONumber
		,EJOM.SONumber JobElectronicInvoiceSONumber
		,EJPM.PONumber JobElectronicInvoicePONumber
		,@JobDeliveryAnalystContactIDName AS JobDeliveryAnalystContactIDName
		,@JobDeliveryResponsibleContactIDName AS JobDeliveryResponsibleContactIDName
		,@JobQtyUnitTypeIdName AS JobQtyUnitTypeIdName
		,@JobCubesUnitTypeIdName AS JobCubesUnitTypeIdName
		,@JobWeightUnitTypeIdName AS JobWeightUnitTypeIdName
		,@JobOriginResponsibleContactIDName AS JobOriginResponsibleContactIDName
		,@JobDriverIdName AS JobDriverIdName
	FROM [dbo].[JOBDL000Master] job
	INNER JOIN PRGRM000MASTER prg ON job.ProgramID = prg.Id
	INNER JOIN dbo.CUST000Master Customer ON Customer.Id = prg.PrgCustID
	LEFT JOIN dbo.PRGRM051VendorLocations PVC ON PVC.PvlProgramID = prg.Id
		AND ISNULL(PVC.PvlLocationCode, '') = ISNULL(Job.JobSiteCode, '')
		AND PVC.StatusId = 1
	LEFT JOIN dbo.Vend000Master Vendor ON Vendor.Id = PVC.PvlVendorId
	LEFT JOIN dbo.NAV000JobSalesOrderMapping JOM ON JOM.JobId = Job.Id
		AND ISNULL(JOM.IsElectronicInvoiced, 0) = 0
	LEFT JOIN dbo.NAV000JobPurchaseOrderMapping JPM ON JPM.JobSalesOrderMappingId = JOM.JobSalesOrderMappingId
		AND ISNULL(JPM.IsElectronicInvoiced, 0) = 0
	LEFT JOIN dbo.NAV000JobSalesOrderMapping EJOM ON EJOM.JobId = Job.Id
		AND ISNULL(EJOM.IsElectronicInvoiced, 0) = 1
	LEFT JOIN dbo.NAV000JobPurchaseOrderMapping EJPM ON EJPM.JobSalesOrderMappingId = EJOM.JobSalesOrderMappingId
		AND ISNULL(EJPM.IsElectronicInvoiced, 0) = 1
	WHERE job.[Id] = @id
END
GO

