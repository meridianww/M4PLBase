UPDATE JobUpdateDecisionMaker
SET JobColumnName = 'ProFlags03'
WHERE xCBLColumnName = 'UDF03'

UPDATE JobUpdateDecisionMaker
SET JobColumnName = 'ProFlags02'
WHERE xCBLColumnName = 'UDF02'

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
		WHERE ActionCode = 'XCBL_Service_FirstSt'
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
		'XCBL_Service_FirstSt'
		,'UDF01'
		,'ProFlags01'
		,1
		,'UserDefinedField'
		)
END

IF NOT EXISTS (
		SELECT 1
		FROM JobUpdateDecisionMaker
		WHERE ActionCode = 'XCBL-Service_9Y'
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
		'XCBL-Service_9Y'
		,'UDF03'
		,'ProFlags03'
		,1
		,'UserDefinedField'
		)
END
IF NOT EXISTS (
		SELECT 1
		FROM JobUpdateDecisionMaker
		WHERE ActionCode = 'XCBL-Service_7Y'
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
		'XCBL-Service_7Y'
		,'UDF02'
		,'ProFlags02'
		,1
		,'UserDefinedField'
		)
END

IF NOT EXISTS (
		SELECT 1
		FROM JobUpdateDecisionMaker
		WHERE ActionCode = 'XCBL-Service_12Y'
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
		'XCBL-Service_12Y'
		,'UDF04'
		,'ProFlags04'
		,1
		,'UserDefinedField'
		)
END

IF NOT EXISTS (
		SELECT 1
		FROM JobUpdateDecisionMaker
		WHERE ActionCode = 'XCBL-Service_SameDay'
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
		'XCBL-Service_SameDay'
		,'UDF05'
		,'ProFlags05'
		,1
		,'UserDefinedField'
		)
END

IF NOT EXISTS (
		SELECT 1
		FROM JobUpdateDecisionMaker
		WHERE ActionCode = 'XCBL-Service_HOO'
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
		'XCBL-Service_HOO'
		,'UDF06'
		,'ProFlags06'
		,1
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
		,1
		,'SummaryHeader'
		)
END
