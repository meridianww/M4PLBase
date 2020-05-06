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
		,'Country'
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
		WHERE ActionCode = ''
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
		''
		,'UDF01'
		,'ProFlags01'
		,1
		,'UserDefinedField'
		)
END

IF NOT EXISTS (
		SELECT 1
		FROM JobUpdateDecisionMaker
		WHERE ActionCode = ''
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
		''
		,'UDF03'
		,'ProFlags04'
		,1
		,'UserDefinedField'
		)
END

IF NOT EXISTS (
		SELECT 1
		FROM JobUpdateDecisionMaker
		WHERE ActionCode = ''
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
		''
		,'UDF05'
		,'ProFlags05'
		,1
		,'UserDefinedField'
		)
END

IF NOT EXISTS (
		SELECT 1
		FROM JobUpdateDecisionMaker
		WHERE ActionCode = ''
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
		''
		,'UDF06'
		,'ProFlags06'
		,1
		,'UserDefinedField'
		)
END