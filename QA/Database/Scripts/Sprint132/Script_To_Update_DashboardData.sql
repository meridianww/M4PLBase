------------- Insert Data For Dashboard Type Table--------------------------------
INSERT INTO dbo.DashboardType (DashboardName, DashboardDisplayName)
VALUES ('Job', 'Job')
GO

------------- Insert Data For Dashboard Table--------------------------------
INSERT INTO dbo.Dashboard (DashboardTypeId, DashboardName)
VALUES (1, 'Default_Job')
GO

------------- Insert Data For Dashboard Category Table--------------------------------
INSERT INTO dbo.DashboardCategory (DashboardCategoryName, DashboardCategoryDisplayName)
VALUES ('NotScheduled', 'Not Scheduled')
GO

INSERT INTO dbo.DashboardCategory (DashboardCategoryName, DashboardCategoryDisplayName)
VALUES ('SchedulePastDue', 'Schedule Past Due')
GO

INSERT INTO dbo.DashboardCategory (DashboardCategoryName, DashboardCategoryDisplayName)
VALUES ('ScheduledForToday', 'Scheduled For Today')
GO

INSERT INTO dbo.DashboardCategory (DashboardCategoryName, DashboardCategoryDisplayName)
VALUES ('Other', 'Other')
GO

------------- Insert Data For Dashboard Sub Category Table--------------------------------
INSERT INTO dbo.DashboardSubCategory (DashboardSubCategoryName, DashboardSubCategoryDisplayName)
VALUES ('InTransit', 'In Transit')
GO

INSERT INTO dbo.DashboardSubCategory (DashboardSubCategoryName, DashboardSubCategoryDisplayName)
VALUES ('OnHand', 'On Hand')
GO

INSERT INTO dbo.DashboardSubCategory (DashboardSubCategoryName, DashboardSubCategoryDisplayName)
VALUES ('OutBound', 'OutBound')
GO

INSERT INTO dbo.DashboardSubCategory (DashboardSubCategoryName, DashboardSubCategoryDisplayName)
VALUES ('Returns', 'Returns')
GO

INSERT INTO dbo.DashboardSubCategory (DashboardSubCategoryName, DashboardSubCategoryDisplayName)
VALUES ('ProductionOrders', 'Production Orders')
GO

INSERT INTO dbo.DashboardSubCategory (DashboardSubCategoryName, DashboardSubCategoryDisplayName)
VALUES ('HubOrders', 'Hub Orders')
GO

INSERT INTO dbo.DashboardSubCategory (DashboardSubCategoryName, DashboardSubCategoryDisplayName)
VALUES ('AppointmentOrders', 'Appointment Orders')
GO

INSERT INTO dbo.DashboardSubCategory (DashboardSubCategoryName, DashboardSubCategoryDisplayName)
VALUES ('InboundOrders', 'Inbound Orders')
GO

INSERT INTO dbo.DashboardSubCategory (DashboardSubCategoryName, DashboardSubCategoryDisplayName)
VALUES ('NoPODUpload', 'No POD Upload')
GO

------------- Insert Data For Dashboard Category Relation Table--------------------------------
INSERT INTO dbo.DashboardCategoryRelation (DashboardId, DashboardCategoryId, DashboardSubCategory, CustomQuery)
VALUES (1, 1, 1, ' (Gateway.GwyGatewayCode Like ''%Transit%'' OR Gateway.GwyGatewayTitle Like ''%Transit%'') AND ISNULL(Gateway.GwyCompleted, 0) = 0 AND Gateway.GatewayTypeId <> @GatewayActionType')
GO

INSERT INTO dbo.DashboardCategoryRelation (DashboardId, DashboardCategoryId, DashboardSubCategory, CustomQuery)
VALUES (1, 1, 2, ' (Gateway.GwyGatewayCode Like ''%Hand%'' OR Gateway.GwyGatewayTitle Like ''%Hand%'') AND ISNULL(Gateway.GwyCompleted, 0) = 0 AND Gateway.GatewayTypeId <> @GatewayActionType')
GO

INSERT INTO dbo.DashboardCategoryRelation (DashboardId, DashboardCategoryId, DashboardSubCategory, CustomQuery)
VALUES (1, 1, 3, NULL)
GO

INSERT INTO dbo.DashboardCategoryRelation (DashboardId, DashboardCategoryId, DashboardSubCategory, CustomQuery)
VALUES (1, 1, 4, ' Gateway.GwyOrderType = ''Return'' AND Gateway.GatewayTypeId <> @GatewayActionType')
GO

INSERT INTO dbo.DashboardCategoryRelation (DashboardId, DashboardCategoryId, DashboardSubCategory, CustomQuery)
VALUES (1, 2, 1, ' (GwyGatewayCode Like ''%Transit%'' OR GwyGatewayTitle Like ''%Transit%'') AND ISNULL(GwyCompleted, 0) = 0 AND Gateway.GatewayTypeId = @GatewayActionType AND Gateway.GwyDDPNew IS NOT NULL AND Job.JobDeliveryDateTimePlanned < GetDate() ')
GO

INSERT INTO dbo.DashboardCategoryRelation (DashboardId, DashboardCategoryId, DashboardSubCategory, CustomQuery)
VALUES (1, 2, 2, ' (GwyGatewayCode Like ''%Hand%'' OR GwyGatewayTitle Like ''%Hand%'') AND ISNULL(GwyCompleted, 0) = 0 AND Gateway.GatewayTypeId = @GatewayActionType AND Gateway.GwyDDPNew IS NOT NULL AND Job.JobDeliveryDateTimePlanned < GetDate() ')
GO
