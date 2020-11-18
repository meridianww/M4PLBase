	INSERT INTO JobUpdateDecisionMaker
	SELECT 'XCBL-Reschedule'ActionCode,
		  'ScheduledDeliveryDate'xCBLColumnName,
		  'JobDeliveryDateTimePlanned'JobColumnName,
		  1 IsAutoUpdate,
		  'SummaryHeader'XCBLTableName