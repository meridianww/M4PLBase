SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Prashant Aggarwal
-- Create date: 07/28/2010
-- Description:	Update Nav Rate For a Program Location
-- =============================================
CREATE PROCEDURE [dbo].[UpdateNavRateByLocation] @programId BIGINT
	,@changedBy NVARCHAR(150)
	,@dateChanged DATETIME2(7)
	,@uttNavRate [dbo].[uttNavRate] READONLY
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @UnitType INT, @RateType INT

	SELECT @UnitType = Id FROM SYSTM000Ref_Options
	WHERE SysLookupCode = 'UnitType' AND SysOptionName = 'Day'

	SELECT @RateType = Id FROM SYSTM000Ref_Options
	WHERE SysLookupCode = 'RateType' AND SysOptionName = 'Simple'

	SELECT BL.Id ProgramLocationId
		,NR.Location
		,NR.Code
		,NR.CustomerCode
		,NR.EffectiveDate
		,NR.Title
		,NR.Category RateCategoryTypeId
		,@RateType RateTypeId
		,@UnitType RateUnitTypeId
		,NR.BillablePrice
		,NR.BillableElectronicInvoice
	INTO #BillableTemp
	FROM dbo.PRGRM042ProgramBillableLocations BL
	INNER JOIN dbo.PRGRM000Master Program ON Program.Id = BL.PblProgramID
	INNER JOIN @uttNavRate NR ON NR.Location = BL.PblLocationCode
	WHERE BL.StatusId = 1 AND BL.PblProgramID = @programId  AND ISNULL(NR.Code, '') <> ''

	SELECT CL.Id ProgramLocationId
		,NR.Location
		,NR.Code
		,NR.VendorCode
		,NR.EffectiveDate
		,NR.Title
		,Program.PrgCustId CustomerId
		,NR.Category RateCategoryTypeId
		,@RateType RateTypeId
		,@UnitType RateUnitTypeId
		,NR.CostRate
		,NR.CostElectronicInvoice
	INTO #CostTemp
	FROM dbo.PRGRM043ProgramCostLocations CL
	INNER JOIN dbo.PRGRM000Master Program ON Program.Id = CL.PclProgramID
	INNER JOIN @uttNavRate NR ON NR.Location = CL.PclLocationCode
	WHERE CL.StatusId = 1 AND CL.PclProgramID = @programId AND ISNULL(NR.Code, '') <> ''

	MERGE [dbo].[PRGRM040ProgramBillableRate] T
	USING #BillableTemp S
		ON (S.ProgramLocationId = T.ProgramLocationId AND S.Code = T.PbrCode)
	WHEN MATCHED
		THEN
			UPDATE
			SET T.PbrCustomerCode = CASE WHEN ISNULL(S.CustomerCode, '') <> '' THEN S.CustomerCode ELSE S.Code END
				,T.PbrEffectiveDate = S.EffectiveDate
				,T.PbrTitle = S.Title
				,T.RateCategoryTypeId = S.RateCategoryTypeId
				,T.RateTypeId = S.RateTypeId
				,T.PbrBillablePrice = S.BillablePrice
				,T.RateUnitTypeId = S.RateUnitTypeId
				,T.StatusId = 1
				,T.ChangedBy = @changedBy
				,T.DateChanged = @dateChanged
				,T.PbrElectronicBilling = S.BillableElectronicInvoice
	WHEN NOT MATCHED BY TARGET
		THEN
			INSERT (
				PbrCode
				,PbrCustomerCode
				,PbrEffectiveDate
				,PbrTitle
				,RateCategoryTypeId
				,RateTypeId
				,PbrBillablePrice
				,RateUnitTypeId
				,StatusId
				,EnteredBy
				,DateEntered
				,ProgramLocationId
				,PbrElectronicBilling
				)
			VALUES (
				S.Code
				,CASE WHEN ISNULL(S.CustomerCode, '') <> '' THEN S.CustomerCode ELSE S.Code END
				,S.EffectiveDate
				,S.Title
				,S.RateCategoryTypeId
				,S.RateTypeId
				,S.BillablePrice
				,S.RateUnitTypeId
				,1
				,@changedBy
				,@dateChanged
				,S.ProgramLocationId
				,S.BillableElectronicInvoice
				);

	MERGE [dbo].[PRGRM041ProgramCostRate] T
	USING #CostTemp S
		ON (S.ProgramLocationId = T.ProgramLocationId AND S.Code = T.PcrCode)
	WHEN MATCHED
		THEN
			UPDATE
			SET  T.PcrVendorCode = CASE WHEN ISNULL(S.VendorCode, '') <> '' THEN S.VendorCode ELSE S.Code END
				,T.PcrEffectiveDate = S.EffectiveDate
				,T.PcrTitle = S.Title
				,T.RateCategoryTypeId = S.RateCategoryTypeId
				,T.RateTypeId = S.RateTypeId
				,T.PcrCostRate = S.CostRate
				,T.RateUnitTypeId = S.RateUnitTypeId
				,T.StatusId = 1
				,T.ChangedBy = @changedBy
				,T.DateChanged = @dateChanged
				,T.PcrElectronicBilling = S.CostElectronicInvoice
	WHEN NOT MATCHED BY TARGET
		THEN
			INSERT (
				PcrCode
				,PcrVendorCode
				,PcrEffectiveDate
				,PcrTitle
				,RateCategoryTypeId
				,RateTypeId
				,PcrCostRate
				,RateUnitTypeId
				,StatusId
				,PcrCustomerID
				,EnteredBy
				,DateEntered
				,ProgramLocationId
				,PcrElectronicBilling
				)
			VALUES (
				S.Code
				,CASE WHEN ISNULL(S.VendorCode, '') <> '' THEN S.VendorCode ELSE S.Code END
				,S.EffectiveDate
				,S.Title
				,S.RateCategoryTypeId
				,S.RateTypeId
				,S.CostRate
				,S.RateUnitTypeId
				,1
				,S.CustomerId
				,@changedBy
				,@dateChanged
				,S.ProgramLocationId
				,S.CostElectronicInvoice
				);

	DROP TABLE #BillableTemp

	DROP TABLE #CostTemp
END
GO
