DECLARE @UnitType INT, @EachUnitType INT

	SELECT @UnitType = Id FROM SYSTM000Ref_Options
	WHERE SysLookupCode = 'UnitType' AND SysOptionName = 'Day'

	SELECT @EachUnitType = Id FROM SYSTM000Ref_Options
	WHERE SysLookupCode = 'UnitType' AND SysOptionName = 'Each'

	Update [dbo].[PRGRM040ProgramBillableRate]
	SET RateUnitTypeId = @EachUnitType
	Where RateUnitTypeId = @UnitType

	Update [dbo].[PRGRM041ProgramCostRate]
	SET RateUnitTypeId = @EachUnitType
	Where RateUnitTypeId = @UnitType