
DELETE FROM JobUpdateDecisionMaker where XCBLTableName='UserDefinedField'

IF NOT EXISTS (
		SELECT 1
		FROM JobUpdateDecisionMaker
		WHERE ActionCode = 'XCBL-Address Change'
			AND JobColumnName = 'Country'
		)
BEGIN
	INSERT INTO JobUpdateDecisionMaker (
		ActionCode
		,XCBLColumnName
		,JobColumnName
		,IsAutoUpdate
		,XCBLTableName
		)
	VALUES (
		'XCBL-Address Change'
		,'CountryCode'
		,'Country'
		,1
		,'Address'
		)
END

IF NOT EXISTS (
		SELECT 1
		FROM JobUpdateDecisionMaker
		WHERE ActionCode = 'XCBL-Address Change'
			AND JobColumnName = 'State'
		)
BEGIN
	INSERT INTO JobUpdateDecisionMaker (
		ActionCode
		,XCBLColumnName
		,JobColumnName
		,IsAutoUpdate
		,XCBLTableName
		)
	VALUES (
		'XCBL-Address Change'
		,'State'
		,'State'
		,1
		,'Address'
		)
END

IF NOT EXISTS (
		SELECT 1
		FROM JobUpdateDecisionMaker
		WHERE ActionCode = 'XCBL-Schedule'
			AND JobColumnName = 'JobDeliveryDateTimePlanned'
		)
BEGIN
	INSERT INTO JobUpdateDecisionMaker (
		ActionCode
		,XCBLColumnName
		,JobColumnName
		,IsAutoUpdate
		,XCBLTableName
		)
	VALUES (
		'XCBL-Schedule'
		,'ScheduledDeliveryDate'
		,'JobDeliveryDateTimePlanned'
		,1
		,'SummaryHeader'
		)
END

---------CONFIRM THE Action Code Add and Execute the Script

IF NOT EXISTS (
		SELECT 1
		FROM JobUpdateDecisionMaker
		WHERE ActionCode = 'XCBL_FirstStop'
			AND JobColumnName = 'ProFlags01'
		)
BEGIN
	INSERT INTO JobUpdateDecisionMaker (
		ActionCode
		,XCBLColumnName
		,JobColumnName
		,IsAutoUpdate
		,XCBLTableName
		)
	VALUES (
		'XCBL_FirstStop'
		,'UDF01'
		,'ProFlags01'
		,0
		,'UserDefinedField'
		)
END

IF NOT EXISTS (
		SELECT 1
		FROM JobUpdateDecisionMaker
		WHERE ActionCode = 'XCBL-Before9'
			AND JobColumnName = 'ProFlags03'
		)
BEGIN
	INSERT INTO JobUpdateDecisionMaker (
		ActionCode
		,XCBLColumnName
		,JobColumnName
		,IsAutoUpdate
		,XCBLTableName
		)
	VALUES (
		'XCBL-Before9'
		,'UDF03'
		,'ProFlags03'
		,0
		,'UserDefinedField'
		)
END
IF NOT EXISTS (
		SELECT 1
		FROM JobUpdateDecisionMaker
		WHERE ActionCode = 'XCBL-Before7'
			AND JobColumnName = 'ProFlags02'
		)
BEGIN
	INSERT INTO JobUpdateDecisionMaker (
		ActionCode
		,XCBLColumnName
		,JobColumnName
		,IsAutoUpdate
		,XCBLTableName
		)
	VALUES (
		'XCBL-Before7'
		,'UDF02'
		,'ProFlags02'
		,0
		,'UserDefinedField'
		)
END

IF NOT EXISTS (
		SELECT 1
		FROM JobUpdateDecisionMaker
		WHERE ActionCode = 'XCBL-Before12'
			AND JobColumnName = 'ProFlags04'
		)
BEGIN
	INSERT INTO JobUpdateDecisionMaker (
		ActionCode
		,XCBLColumnName
		,JobColumnName
		,IsAutoUpdate
		,XCBLTableName
		)
	VALUES (
		'XCBL-Before12'
		,'UDF04'
		,'ProFlags04'
		,0
		,'UserDefinedField'
		)
END

IF NOT EXISTS (
		SELECT 1
		FROM JobUpdateDecisionMaker
		WHERE ActionCode = 'XCBL-SameDay'
			AND JobColumnName = 'ProFlags05'
		)
BEGIN
	INSERT INTO JobUpdateDecisionMaker (
		ActionCode
		,XCBLColumnName
		,JobColumnName
		,IsAutoUpdate
		,XCBLTableName
		)
	VALUES (
		'XCBL-SameDay'
		,'UDF05'
		,'ProFlags05'
		,0
		,'UserDefinedField'
		)
END

IF NOT EXISTS (
		SELECT 1
		FROM JobUpdateDecisionMaker
		WHERE ActionCode = 'XCBL-OwnerOccupied'
			AND JobColumnName = 'ProFlags06'
		)
BEGIN
	INSERT INTO JobUpdateDecisionMaker (
		ActionCode
		,XCBLColumnName
		,JobColumnName
		,IsAutoUpdate
		,XCBLTableName
		)
	VALUES (
		'XCBL-OwnerOccupied'
		,'UDF06'
		,'ProFlags06'
		,0
		,'UserDefinedField'
		)
END

IF NOT EXISTS (
		SELECT 1
		FROM JobUpdateDecisionMaker
		WHERE ActionCode = 'XCBL-Date'
			AND JobColumnName = 'XCBL-Date'
		)
BEGIN
	INSERT INTO JobUpdateDecisionMaker (
		ActionCode
		,XCBLColumnName
		,JobColumnName
		,IsAutoUpdate
		,XCBLTableName
		)
	VALUES (
		'XCBL-Date'
		,'XCBL-Date'
		,'XCBL-Date'
		,0
		,'SummaryHeader'
		)
END



IF NOT EXISTS (
		SELECT 1
		FROM JobUpdateDecisionMaker
		WHERE ActionCode = 'XCBL-Schedule'
			AND JobColumnName = 'JobDeliveryDateTimePlanned'
		)
BEGIN
	INSERT INTO JobUpdateDecisionMaker (
		ActionCode
		,XCBLColumnName
		,JobColumnName
		,IsAutoUpdate
		,XCBLTableName
		)
	VALUES (
		'XCBL-Schedule'
		,'ScheduledDeliveryDate'
		,'JobDeliveryDateTimePlanned'
		,1
		,'SummaryHeader'
		)
END