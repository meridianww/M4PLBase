BEGIN
	IF NOT EXISTS (Select 1 From DashboardCategory Where DashboardCategoryName = 'xCBL')
	BEGIN
		INSERT INTO DashboardCategory VALUES('xCBL', 'xCBL Changes')
	END
	IF NOT EXISTS (Select 1 From DashboardSubCategory Where DashboardSubCategoryName = 'AddressChange')
	BEGIN
		INSERT INTO DashboardSubCategory VALUES('AddressChange', 'Address Change')
	END
	IF NOT EXISTS (Select 1 From DashboardSubCategory Where DashboardSubCategoryName = 'ScheduleChange')
	BEGIN
		INSERT INTO DashboardSubCategory VALUES('ScheduleChange', 'Schedule Change')
	END
	IF NOT EXISTS (Select 1 From DashboardSubCategory Where DashboardSubCategoryName = 'GPSCoordinates')
	BEGIN
		INSERT INTO DashboardSubCategory VALUES('GPSCoordinates', 'GPS Coordinates')
	END
	IF NOT EXISTS (Select 1 From DashboardSubCategory Where DashboardSubCategoryName = '48HourChange')
	BEGIN
		INSERT INTO DashboardSubCategory VALUES('48HourChange', '48 Hour Change')
	END
	IF NOT EXISTS (Select 1 From DashboardSubCategory Where DashboardSubCategoryName = 'ATDCAAPUPUD')
	BEGIN
		INSERT INTO DashboardSubCategory VALUES('ATDCAAPUPUD ', 'ATD/CAA/PU/PUD')
	END
	
	DECLARE @dashboardId  BIGINT = 0, @dashboardCategoryId INT = 0, @dashboardSubCategoryId INT = 0;
	SELECT @dashboardId = DashboardId FROM Dashboard WHERE DashboardName = 'Default_Job'
	IF(@dashboardId > 0)
	BEGIN
		-- DASHBOARD CATEGORY RELATIONAL MAPPING FOR OTHER/NO POD UPLOAD --
		BEGIN
			SELECT @dashboardCategoryId = DashboardCategoryId FROM DashboardCategory WHERE DashboardCategoryName = 'Other'
			SELECT @dashboardSubCategoryId = DashboardSubCategoryId FROM DashboardSubCategory WHERE DashboardSubCategoryName = 'NoPODUpload'
			IF(@dashboardCategoryId > 0 AND @dashboardSubCategoryId > 0)
			BEGIN
				DELETE FROM DashboardCategoryRelation WHERE DashboardId = @dashboardId AND DashboardCategoryId = @dashboardCategoryId AND DashboardSubCategory = @dashboardSubCategoryId
				INSERT INTO DashboardCategoryRelation VALUES(@dashboardId, @dashboardCategoryId, @dashboardSubCategoryId, 
				' AND JOBDL020Gateways.GwyOrderType <> ''RETURN'' AND JOBDL020Gateways.GwyGatewayCode = ''Delivered'' AND ISNULL(JOBDL020Gateways.GwyCompleted,0) = 1 '
				, '#FF0000', '#ffffff')
			END
		END
		
		-- DASHBOARD CATEGORY RELATIONAL MAPPING FOR xCBL --
		BEGIN
			SELECT @dashboardCategoryId = DashboardCategoryId FROM DashboardCategory WHERE DashboardCategoryName = 'xCBL'
			IF(@dashboardCategoryId > 0)
			BEGIN
				BEGIN
					SELECT @dashboardSubCategoryId = DashboardSubCategoryId FROM DashboardSubCategory WHERE DashboardSubCategoryName = 'AddressChange'
					IF(@dashboardSubCategoryId > 0)
					BEGIN
						DELETE FROM DashboardCategoryRelation WHERE DashboardId = @dashboardId AND DashboardCategoryId = @dashboardCategoryId AND DashboardSubCategory = @dashboardSubCategoryId
						INSERT INTO DashboardCategoryRelation VALUES(@dashboardId, @dashboardCategoryId, @dashboardSubCategoryId, 
						' AND JOBDL020Gateways.GwyGatewayCode = ''XCBL'' AND JOBDL020Gateways.GwyGatewayTitle = ''xCBL Address Change'' AND JOBDL020Gateways.GwyCompleted = 0 AND JOBDL000Master.IsCancelled = 0 ', '#FF0000', '#ffffff')
					END
				END
				BEGIN
					SELECT @dashboardSubCategoryId = DashboardSubCategoryId FROM DashboardSubCategory WHERE DashboardSubCategoryName = 'ScheduleChange'
					IF(@dashboardSubCategoryId > 0)
					BEGIN
						DELETE FROM DashboardCategoryRelation WHERE DashboardId = @dashboardId AND DashboardCategoryId = @dashboardCategoryId AND DashboardSubCategory = @dashboardSubCategoryId
						INSERT INTO DashboardCategoryRelation VALUES(@dashboardId, @dashboardCategoryId, @dashboardSubCategoryId, 
						' AND JOBDL020Gateways.GwyGatewayCode = ''XCBL'' AND JOBDL020Gateways.GwyGatewayTitle = ''xCBL Schedule Change'' AND JOBDL020Gateways.GwyCompleted = 0 AND JOBDL000Master.IsCancelled = 0 ', '#FF0000', '#ffffff')
					END
				END
				BEGIN
					SELECT @dashboardSubCategoryId = DashboardSubCategoryId FROM DashboardSubCategory WHERE DashboardSubCategoryName = 'GPSCoordinates'
					IF(@dashboardSubCategoryId > 0)
					BEGIN
						DELETE FROM DashboardCategoryRelation WHERE DashboardId = @dashboardId AND DashboardCategoryId = @dashboardCategoryId AND DashboardSubCategory = @dashboardSubCategoryId
						INSERT INTO DashboardCategoryRelation VALUES(@dashboardId, @dashboardCategoryId, @dashboardSubCategoryId, 
						' AND JOBDL020Gateways.GwyGatewayCode = ''XCBL'' AND JOBDL020Gateways.GwyGatewayTitle = ''xCBL GPS Coordinates'' AND JOBDL020Gateways.GwyCompleted = 0 AND JOBDL000Master.IsCancelled = 0 ', '#FF0000', '#ffffff')
					END
				END
				BEGIN
					SELECT @dashboardSubCategoryId = DashboardSubCategoryId FROM DashboardSubCategory WHERE DashboardSubCategoryName = '48HourChange'
					IF(@dashboardSubCategoryId > 0)
					BEGIN
						DELETE FROM DashboardCategoryRelation WHERE DashboardId = @dashboardId AND DashboardCategoryId = @dashboardCategoryId AND DashboardSubCategory = @dashboardSubCategoryId
						INSERT INTO DashboardCategoryRelation VALUES(@dashboardId, @dashboardCategoryId, @dashboardSubCategoryId, 
						' AND JOBDL020Gateways.GwyGatewayCode = ''XCBL'' AND JOBDL020Gateways.GwyGatewayTitle = ''xCBL 48Hr Date Change'' AND JOBDL020Gateways.GwyCompleted = 0 AND JOBDL000Master.IsCancelled = 0 ', '#FF0000', '#ffffff')
					END
				END
			END
		END
	END
END