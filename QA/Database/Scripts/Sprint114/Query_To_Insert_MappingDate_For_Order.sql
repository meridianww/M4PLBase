Truncate Table dbo.NAV000OrderMapping 
INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES ('CustERPID', 'Sell_to_Customer_No', 'Customer', 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES ('CustTitle', 'Sell_to_Customer_Name', 'Customer', 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Quote_No', NULL, 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Sell_to_Address', NULL, 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Sell_to_Address_2', NULL, 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Sell_to_City', NULL, 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Sell_to_County', NULL, 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Sell_to_Post_Code', NULL, 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Sell_to_Contact_No', NULL, 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Sell_to_Contact', NULL, 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'No_of_Archived_Versions', NULL, 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Document_Date', NULL, 'SalesOrder', '''0001-01-01''', NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Posting_Date', NULL, 'SalesOrder', 'CAST(CAST(GETDATE() AS DATE) AS VARCHAR)', NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Order_Date', NULL, 'SalesOrder', 'CAST(CAST(GETDATE() AS DATE) AS VARCHAR)', NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Due_Date', NULL, 'SalesOrder', 'CAST(CAST(GETDATE() AS DATE) AS VARCHAR)', NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Requested_Delivery_Date', NULL, 'SalesOrder', '''0001-01-01''', NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Promised_Delivery_Date', NULL, 'SalesOrder', '''0001-01-01''', NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES ('JobCustomerSalesOrder', 'External_Document_No', 'Job', 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Salesperson_Code', NULL, 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Campaign_No', NULL, 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Opportunity_No', NULL, 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Responsibility_Center', NULL, 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Assigned_User_ID', NULL, 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Job_Queue_Status', NULL, 'SalesOrder', ' ', NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Status', NULL, 'SalesOrder', '''Open''', NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES ('CAST(Job.Id AS VARCHAR)', 'M4PL_Job_ID', 'Job', 'SalesOrder', NULL, 1)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'FSC_Calculated', NULL, 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'WorkDescription', NULL, 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Ship_from_Code', NULL, 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES ('JobOriginSiteName', 'Ship_from_Name', 'Job', 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Ship_from_Name_2', NULL, 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES ('JobOriginStreetAddress', 'Ship_from_Address', 'Job', 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Ship_from_Address_2', NULL, 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES ('JobOriginCity', 'Ship_from_City', 'Job', 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES ('JobOriginState', 'Ship_From_County', 'Job', 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES ('JobOriginPostalCode', 'Ship_From_Post_Code', 'Job', 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES ('JobOriginSitePOC', 'Ship_from_Contact', 'Job', 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES ('JobOriginSitePOCPhone', 'Ship_from_Phone', 'Job', 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES ('JobOriginSitePOCPhone2', 'Ship_from_Mobile', 'Job', 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES ('JobOriginSitePOCEmail', 'Ship_from_Email', 'Job', 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Ship_to_Code', NULL, 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES ('JobDeliverySiteName', 'Ship_to_Name', 'Job', 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES ('JobDeliveryStreetAddress', 'Ship_to_Address', 'Job', 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Ship_to_Address_2', NULL, 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES ('JobDeliveryCity', 'Ship_to_City', 'Job', 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES ('JobDeliveryState', 'Ship_to_County', 'Job', 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES ('JobDeliveryPostalCode', 'Ship_to_Post_Code', 'Job', 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES ('JobDeliverySitePOC', 'Ship_to_Contact', 'Job', 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Ship_to_UPS_Zone', NULL, 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES ('JobDeliverySitePOCPhone', 'Ship_to_Phone', 'Job', 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES ('JobDeliverySitePOCPhone2', 'Ship_to_Mobile', 'Job', 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES ('JobDeliverySitePOCEmail', 'Ship_to_Email', 'Job', 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Currency_Code', NULL, 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Payment_Terms_Code', NULL, 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Payment_Method_Code', NULL, 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Tax_Liable', NULL, 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Tax_Area_Code', NULL, 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'SelectedPayments', NULL, 'SalesOrder', '''No payment service is made available.''', NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Transaction_Type', NULL, 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Shortcut_Dimension_1_Code', NULL, 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Shortcut_Dimension_2_Code', NULL, 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Payment_Discount_Percent', NULL, 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Pmt_Discount_Date', NULL, 'SalesOrder', '''0001-01-01''', NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Pmt_Discount_DateSpecified', NULL, 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Direct_Debit_Mandate_ID', NULL, 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Shipment_Method_Code', NULL, 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Shipping_Agent_Code', NULL, 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Shipping_Agent_Service_Code', NULL, 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Package_Tracking_No', NULL, 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES ('CompTitle', 'Bill_to_Name', 'Company', 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Bill_to_Address', NULL, 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Bill_to_Address_2', NULL, 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Bill_to_City', NULL, 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Bill_to_County', NULL, 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Bill_to_Post_Code', NULL, 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Bill_to_Contact_No', NULL, 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Bill_to_Contact', NULL, 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Location_Code', NULL, 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Shipment_Date', NULL, 'SalesOrder', '''0001-01-01''', NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Shipping_Advice', NULL, 'SalesOrder', '''Partial''', NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Outbound_Whse_Handling_Time', NULL, 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Shipping_Time', NULL, 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Late_Order_Shipping', NULL, 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Transaction_Specification', NULL, 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Transport_Method', NULL, 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Exit_Point', NULL, 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Area', NULL, 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Prepayment_Percent', NULL, 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Compress_Prepayment', NULL, 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Prepmt_Payment_Terms_Code', NULL, 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Prepayment_Due_Date', NULL, 'SalesOrder', '''0001-01-01''', NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Prepmt_Payment_Discount_Percent', NULL, 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Prepmt_Pmt_Discount_Date', NULL, 'SalesOrder', '''0001-01-01''', NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Prepmt_Include_Tax', NULL, 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'EDI_Order', NULL, 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'EDI_Internal_Doc_No', NULL, 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'EDI_Ack_Generated', NULL, 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'EDI_Ack_Gen_Date', NULL, 'SalesOrder', '''0001-01-01''', NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'EDI_Released', NULL, 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'EDI_WHSE_Shp_Gen', NULL, 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'EDI_WHSE_Shp_Gen_Date', NULL, 'SalesOrder', '''0001-01-01''', NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'EDI_Transaction_Date', NULL, 'SalesOrder', '''0001-01-01''', NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'EDI_Transaction_Time', NULL, 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'EDI_Expected_Delivery_Date', NULL, 'SalesOrder', '''0001-01-01''', NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'EDI_Trade_Partner', NULL, 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'EDI_Sell_to_Code', NULL, 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'EDI_Ship_for_Code', NULL, 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'EDI_Ship_to_Code', NULL, 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'EDI_Cancel_After_Date', NULL, 'SalesOrder', '''0001-01-01''', NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'EDI_Cancellation_Request', NULL, 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'EDI_Cancellation_Date', NULL, 'SalesOrder', '''0001-01-01''', NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'EDI_Cancellation_Advice', NULL, 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'EDI_Cancellation_Advice_Date', NULL, 'SalesOrder', '''0001-01-01''', NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'EDI_Cancellation_Generated', NULL, 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Compress_PrepaymentSpecified', NULL, 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Cust_Reference_No', NULL, 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Document_DateSpecified', NULL, 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Due_DateSpecified', NULL, 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'EDI_Ack_Gen_DateSpecified', NULL, 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'EDI_Ack_GeneratedSpecified', NULL, 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'EDI_Cancel_After_DateSpecified', NULL, 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'EDI_Cancellation_Advice_DateSpecified', NULL, 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'EDI_Cancellation_AdviceSpecified', NULL, 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'EDI_Cancellation_DateSpecified', NULL, 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'EDI_Cancellation_GeneratedSpecified', NULL, 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'EDI_Cancellation_RequestSpecified', NULL, 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'EDI_Expected_Delivery_DateSpecified', NULL, 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'EDI_OrderSpecified', NULL, 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'EDI_ReleasedSpecified', NULL, 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'EDI_Transaction_DateSpecified', NULL, 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'EDI_Transaction_TimeSpecified', NULL, 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'EDI_WHSE_Shp_Gen_DateSpecified', NULL, 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'EDI_WHSE_Shp_GenSpecified', NULL, 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'FSC_CalculatedSpecified', NULL, 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Job_Queue_StatusSpecified', NULL, 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Late_Order_ShippingSpecified', NULL, 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'No', NULL, 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'No_of_Archived_VersionsSpecified', NULL, 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Order_DateSpecified', NULL, 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Payment_Discount_PercentSpecified', NULL, 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Posting_DateSpecified', NULL, 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Prepayment_Due_DateSpecified', NULL, 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Prepayment_PercentSpecified', NULL, 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Prepmt_Include_TaxSpecified', NULL, 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Prepmt_Payment_Discount_PercentSpecified', NULL, 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Prepmt_Pmt_Discount_DateSpecified', NULL, 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Promised_Delivery_DateSpecified', NULL, 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Requested_Delivery_DateSpecified', NULL, 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Shipment_DateSpecified', NULL, 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Shipping_AdviceSpecified', NULL, 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'StatusSpecified', NULL, 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Tax_LiableSpecified', NULL, 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'BillToOptions', NULL, 'SalesOrder', '''Default (Customer)''', NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'ShippingOptions', NULL, 'SalesOrder', '''Default (Sell-to Address)''', NULL)
GO


INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Document_Type', NULL, 'ShippingItem', '''Order''', NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES ('SONumber', 'Document_No', 'JobOrderMapping', 'ShippingItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Line_No', NULL, 'ShippingItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Type', NULL, 'ShippingItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'FilteredTypeField', NULL, 'ShippingItem', '''Comment''', NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'No', NULL, 'ShippingItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES ('CAST(Job.Id AS VARCHAR)', 'M4PL_Job_ID', 'Job', 'ShippingItem', NULL, 1)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Surcharge', NULL, 'ShippingItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Cross_Reference_No', NULL, 'ShippingItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'IC_Partner_Code', NULL, 'ShippingItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'IC_Partner_Ref_Type', NULL, 'ShippingItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'IC_Partner_Reference', NULL, 'ShippingItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Variant_Code', NULL, 'ShippingItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Substitution_Available', NULL, 'ShippingItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Purchasing_Code', NULL, 'ShippingItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Nonstock', NULL, 'ShippingItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'VAT_Prod_Posting_Group', NULL, 'ShippingItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Description', NULL, 'ShippingItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Net_Weight', NULL, 'ShippingItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Rate_Quoted', NULL, 'ShippingItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Drop_Shipment', NULL, 'ShippingItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Special_Order', NULL, 'ShippingItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Return_Reason_Code', NULL, 'ShippingItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Package_Tracking_No', NULL, 'ShippingItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Location_Code', NULL, 'ShippingItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Allow_Invoice_Disc', NULL, 'ShippingItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Inv_Discount_Amount', NULL, 'ShippingItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Inv_Disc_Amount_to_Invoice', NULL, 'ShippingItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES ('JobQtyActual', 'Qty_to_Ship', 'Job', 'ShippingItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Std_Pack_Qty_to_Ship', NULL, 'ShippingItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Package_Qty_to_Ship', NULL, 'ShippingItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Quantity_Shipped', NULL, 'ShippingItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES ('JobQtyActual', 'Qty_to_Invoice', 'Job', 'ShippingItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Quantity_Invoiced', NULL, 'ShippingItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Prepmt_Amt_to_Deduct', NULL, 'ShippingItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Prepmt_Amt_Deducted', NULL, 'ShippingItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Allow_Item_Charge_Assignment', NULL, 'ShippingItem', 'CAST(1 AS BIT)', NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Qty_to_Assign', NULL, 'ShippingItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Qty_Assigned', NULL, 'ShippingItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Requested_Delivery_Date', NULL, 'ShippingItem', '''0001-01-01''', NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Promised_Delivery_Date', NULL, 'ShippingItem', '''0001-01-01''', NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Planned_Delivery_Date', NULL, 'ShippingItem', 'CAST(CAST(GETDATE() AS DATE) AS VARCHAR)', NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Planned_Shipment_Date', NULL, 'ShippingItem', 'CAST(CAST(GETDATE() AS DATE) AS VARCHAR)', NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Shipment_Date', NULL, 'ShippingItem', '''0001-01-01''', NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Shipping_Agent_Code', NULL, 'ShippingItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Shipping_Agent_Service_Code', NULL, 'ShippingItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Shipping_Time', NULL, 'ShippingItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Work_Type_Code', NULL, 'ShippingItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Whse_Outstanding_Qty', NULL, 'ShippingItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Whse_Outstanding_Qty_Base', NULL, 'ShippingItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'ATO_Whse_Outstanding_Qty', NULL, 'ShippingItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'ATO_Whse_Outstd_Qty_Base', NULL, 'ShippingItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Outbound_Whse_Handling_Time', NULL, 'ShippingItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Blanket_Order_No', NULL, 'ShippingItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Blanket_Order_Line_No', NULL, 'ShippingItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'FA_Posting_Date', NULL, 'ShippingItem', '''0001-01-01''', NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Depr_until_FA_Posting_Date', NULL, 'ShippingItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Depreciation_Book_Code', NULL, 'ShippingItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Use_Duplication_List', NULL, 'ShippingItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Duplicate_in_Depreciation_Book', NULL, 'ShippingItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Appl_from_Item_Entry', NULL, 'ShippingItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Appl_to_Item_Entry', NULL, 'ShippingItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Deferral_Code', NULL, 'ShippingItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Shortcut_Dimension_1_Code', NULL, 'ShippingItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Shortcut_Dimension_2_Code', NULL, 'ShippingItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'ShortcutDimCode_x005B_3_x005D_', NULL, 'ShippingItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'ShortcutDimCode_x005B_4_x005D_', NULL, 'ShippingItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'ShortcutDimCode_x005B_5_x005D_', NULL, 'ShippingItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'ShortcutDimCode_x005B_6_x005D_', NULL, 'ShippingItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'ShortcutDimCode_x005B_7_x005D_', NULL, 'ShippingItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'ShortcutDimCode_x005B_8_x005D_', NULL, 'ShippingItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Required_Shipping_Agent_Code', NULL, 'ShippingItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Required_E_Ship_Agent_Service', NULL, 'ShippingItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Allow_Other_Ship_Agent_Serv', NULL, 'ShippingItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'TotalSalesLine_Line_Amount', NULL, 'ShippingItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Invoice_Discount_Amount', NULL, 'ShippingItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Invoice_Disc_Pct', NULL, 'ShippingItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Total_Amount_Excl_VAT', NULL, 'ShippingItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Total_VAT_Amount', NULL, 'ShippingItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Total_Amount_Incl_VAT', NULL, 'ShippingItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Bin_Code', NULL, 'ShippingItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Reserve', NULL, 'ShippingItem', '''Never''', NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES ('JobQtyActual', 'Quantity', 'Job', 'ShippingItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Qty_to_Assemble_to_Order', NULL, 'ShippingItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Std_Pack_Quantity', NULL, 'ShippingItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Reserved_Quantity', NULL, 'ShippingItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Unit_of_Measure_Code', NULL, 'ShippingItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Std_Pack_Unit_of_Measure_Code', NULL, 'ShippingItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Std_Packs_per_Package', NULL, 'ShippingItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Unit_of_Measure', NULL, 'ShippingItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Unit_Cost_LCY', NULL, 'ShippingItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'SalesPriceExist', NULL, 'ShippingItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Unit_Price', NULL, 'ShippingItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Tax_Liable', NULL, 'ShippingItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Tax_Area_Code', NULL, 'ShippingItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Tax_Group_Code', NULL, 'ShippingItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Line_Discount_Percent', NULL, 'ShippingItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Line_Amount', NULL, 'ShippingItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Amount_Including_VAT', NULL, 'ShippingItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'SalesLineDiscExists', NULL, 'ShippingItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Line_Discount_Amount', NULL, 'ShippingItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Prepayment_Percent', NULL, 'ShippingItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Prepmt_Line_Amount', NULL, 'ShippingItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Prepmt_Amt_Inv', NULL, 'ShippingItem', NULL, NULL)
GO


INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Ship_from_Code', NULL, 'PurchaseOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES ('JobOriginSiteName', 'Ship_from_Name', 'Job', 'PurchaseOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Ship_from_Name_2', NULL, 'PurchaseOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES ('JobOriginStreetAddress', 'Ship_from_Address', 'Job', 'PurchaseOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Ship_from_Address_2', NULL, 'PurchaseOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES ('JobOriginCity', 'Ship_from_City', 'Job', 'PurchaseOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Ship_From_County', 'Job', 'PurchaseOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Ship_From_Post_Code', 'Job', 'PurchaseOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES ('JobOriginSitePOC', 'Ship_from_Contact', 'Job', 'PurchaseOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES ('JobOriginSitePOCPhone', 'Ship_from_Phone', 'Job', 'PurchaseOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES ('JobOriginSitePOCPhone2', 'Ship_from_Mobile', 'Job', 'PurchaseOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES ('JobOriginSitePOCEmail', 'Ship_from_Email', 'Job', 'PurchaseOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Cust_Reference_No', NULL, 'PurchaseOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES ('VendERPID', 'Buy_from_Vendor_No', 'Vendor', 'PurchaseOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES ('VendTitle', 'Buy_from_Vendor_Name', 'Vendor', 'PurchaseOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES ('CAST(Job.Id AS VARCHAR)', 'M4PL_Job_ID', 'Job', 'PurchaseOrder', NULL, 1)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Buy_from_Address', NULL, 'PurchaseOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Buy_from_Address_2', NULL, 'PurchaseOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Buy_from_City', NULL, 'PurchaseOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Buy_from_County', NULL, 'PurchaseOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Buy_from_Post_Code', NULL, 'PurchaseOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Buy_from_Contact_No', NULL, 'PurchaseOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Buy_from_Contact', NULL, 'PurchaseOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Document_Date', NULL, 'PurchaseOrder', '''0001-01-01''', NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Posting_Date', NULL, 'PurchaseOrder', 'CAST(CAST(GETDATE() AS DATE) AS VARCHAR)', NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Due_Date', NULL, 'PurchaseOrder', 'CAST(CAST(GETDATE() AS DATE) AS VARCHAR)', NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Shipment_Date', NULL, 'PurchaseOrder', '''0001-01-01''', NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Vendor_Invoice_No', NULL, 'PurchaseOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Purchaser_Code', NULL, 'PurchaseOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'No_of_Archived_Versions', NULL, 'PurchaseOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Posting_Description', NULL, 'PurchaseOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Order_Date', NULL, 'PurchaseOrder', 'CAST(CAST(GETDATE() AS DATE) AS VARCHAR)', NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Quote_No', NULL, 'PurchaseOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Vendor_Order_No', NULL, 'PurchaseOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Vendor_Shipment_No', NULL, 'PurchaseOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Order_Address_Code', NULL, 'PurchaseOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Responsibility_Center', NULL, 'PurchaseOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Assigned_User_ID', NULL, 'PurchaseOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Status', NULL, 'PurchaseOrder', '''Open''', NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Job_Queue_Status', NULL, 'PurchaseOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Currency_Code', NULL, 'PurchaseOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Expected_Receipt_Date', NULL, 'PurchaseOrder', '''0001-01-01''', NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Payment_Terms_Code', NULL, 'PurchaseOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Transaction_Type', NULL, 'PurchaseOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Shortcut_Dimension_1_Code', NULL, 'PurchaseOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Shortcut_Dimension_2_Code', NULL, 'PurchaseOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Payment_Discount_Percent', NULL, 'PurchaseOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Pmt_Discount_Date', NULL, 'PurchaseOrder', '''0001-01-01''', NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Tax_Liable', NULL, 'PurchaseOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Tax_Area_Code', NULL, 'PurchaseOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Tax_Exemption_No', NULL, 'PurchaseOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Provincial_Tax_Area_Code', NULL, 'PurchaseOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Shipment_Method_Code', NULL, 'PurchaseOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Payment_Reference', NULL, 'PurchaseOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Creditor_No', NULL, 'PurchaseOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'On_Hold', NULL, 'PurchaseOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Inbound_Whse_Handling_Time', NULL, 'PurchaseOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Lead_Time_Calculation', NULL, 'PurchaseOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Requested_Receipt_Date', NULL, 'PurchaseOrder', '''0001-01-01''', NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Promised_Receipt_Date', NULL, 'PurchaseOrder', '''0001-01-01''', NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'IRS_1099_Code', NULL, 'PurchaseOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'ShippingOptionWithLocation', NULL, 'PurchaseOrder', '''Default (Company Address)''', NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Location_Code', NULL, 'PurchaseOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Sell_to_Customer_No', NULL, 'PurchaseOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Ship_to_Code', NULL, 'PurchaseOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Ship_to_Name', 'Job', 'PurchaseOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Ship_to_Address', 'Job', 'PurchaseOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Ship_to_Address_2', NULL, 'PurchaseOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Ship_to_City', 'Job', 'PurchaseOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Ship_to_County', 'Job', 'PurchaseOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Ship_to_Post_Code', 'Job', 'PurchaseOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Ship_to_Country_Region_Code', NULL, 'PurchaseOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Ship_to_Contact', 'Job', 'PurchaseOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Ship_to_UPS_Zone', NULL, 'PurchaseOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'PayToOptions', NULL, 'PurchaseOrder', '''Default (Vendor)''', NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Pay_to_Name', NULL, 'PurchaseOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Pay_to_Address', NULL, 'PurchaseOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Pay_to_Address_2', NULL, 'PurchaseOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Pay_to_County', NULL, 'PurchaseOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Pay_to_Contact_No', NULL, 'PurchaseOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Pay_to_Contact', NULL, 'PurchaseOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Transaction_Specification', NULL, 'PurchaseOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Transport_Method', NULL, 'PurchaseOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Entry_Point', NULL, 'PurchaseOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Area', NULL, 'PurchaseOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Prepayment_Percent', NULL, 'PurchaseOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Compress_Prepayment', NULL, 'PurchaseOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Prepmt_Payment_Terms_Code', NULL, 'PurchaseOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Prepayment_Due_Date', NULL, 'PurchaseOrder', '''0001-01-01''', NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Prepmt_Payment_Discount_Percent', NULL, 'PurchaseOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Prepmt_Pmt_Discount_Date', NULL, 'PurchaseOrder', '''0001-01-01''', NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Vendor_Cr_Memo_No', NULL, 'PurchaseOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Prepmt_Include_Tax', NULL, 'PurchaseOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Fiscal_Invoice_Number_PAC', NULL, 'PurchaseOrder', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'E_Mail_Confirmation_Handled', NULL, 'PurchaseOrder', NULL, NULL)
GO


INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'No', NULL, 'PurchaseOrderItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES ('CAST(Job.Id AS VARCHAR)', 'M4PL_Job_ID', NULL, 'PurchaseOrderItem', NULL, 1)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Cross_Reference_No', NULL, 'PurchaseOrderItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'IC_Partner_Code', NULL, 'PurchaseOrderItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'IC_Partner_Ref_Type', NULL, 'PurchaseOrderItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'IC_Partner_Ref_TypeSpecified', NULL, 'PurchaseOrderItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'IC_Partner_Reference', NULL, 'PurchaseOrderItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Variant_Code', NULL, 'PurchaseOrderItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Nonstock', NULL, 'PurchaseOrderItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'NonstockSpecified', NULL, 'PurchaseOrderItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'GST_HST', NULL, 'PurchaseOrderItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'GST_HSTSpecified', NULL, 'PurchaseOrderItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'VAT_Prod_Posting_Group', NULL, 'PurchaseOrderItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Description', NULL, 'PurchaseOrderItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Drop_Shipment', NULL, 'PurchaseOrderItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Drop_ShipmentSpecified', NULL, 'PurchaseOrderItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Return_Reason_Code', NULL, 'PurchaseOrderItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Location_Code', NULL, 'PurchaseOrderItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Bin_Code', NULL, 'PurchaseOrderItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Quantity', NULL, 'PurchaseOrderItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'QuantitySpecified', NULL, 'PurchaseOrderItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Reserved_Quantity', NULL, 'PurchaseOrderItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Reserved_QuantitySpecified', NULL, 'PurchaseOrderItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Job_Remaining_Qty', NULL, 'PurchaseOrderItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Job_Remaining_QtySpecified', NULL, 'PurchaseOrderItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Unit_of_Measure_Code', NULL, 'PurchaseOrderItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Unit_of_Measure', NULL, 'PurchaseOrderItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Direct_Unit_Cost', NULL, 'PurchaseOrderItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Direct_Unit_CostSpecified', NULL, 'PurchaseOrderItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Indirect_Cost_Percent', NULL, 'PurchaseOrderItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Indirect_Cost_PercentSpecified', NULL, 'PurchaseOrderItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Unit_Cost_LCYSpecified', NULL, 'PurchaseOrderItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Unit_Price_LCY', NULL, 'PurchaseOrderItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Unit_Price_LCYSpecified', NULL, 'PurchaseOrderItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Tax_Liable', NULL, 'PurchaseOrderItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Tax_LiableSpecified', NULL, 'PurchaseOrderItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Tax_Area_Code', NULL, 'PurchaseOrderItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Provincial_Tax_Area_Code', NULL, 'PurchaseOrderItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Tax_Group_Code', NULL, 'PurchaseOrderItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Use_Tax', NULL, 'PurchaseOrderItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Use_TaxSpecified', NULL, 'PurchaseOrderItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Line_Discount_Percent', NULL, 'PurchaseOrderItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Line_Discount_PercentSpecified', NULL, 'PurchaseOrderItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Line_Amount', NULL, 'PurchaseOrderItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Line_AmountSpecified', NULL, 'PurchaseOrderItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Line_Discount_Amount', NULL, 'PurchaseOrderItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Line_Discount_AmountSpecified', NULL, 'PurchaseOrderItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Prepayment_Percent', NULL, 'PurchaseOrderItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Prepayment_PercentSpecified', NULL, 'PurchaseOrderItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Prepmt_Line_Amount', NULL, 'PurchaseOrderItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Prepmt_Line_AmountSpecified', NULL, 'PurchaseOrderItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Prepmt_Amt_Inv', NULL, 'PurchaseOrderItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Prepmt_Amt_InvSpecified', NULL, 'PurchaseOrderItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Allow_Invoice_Disc', NULL, 'PurchaseOrderItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Allow_Invoice_DiscSpecified', NULL, 'PurchaseOrderItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Inv_Discount_Amount', NULL, 'PurchaseOrderItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Inv_Discount_AmountSpecified', NULL, 'PurchaseOrderItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Inv_Disc_Amount_to_Invoice', NULL, 'PurchaseOrderItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Inv_Disc_Amount_to_InvoiceSpecified', NULL, 'PurchaseOrderItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Qty_to_Receive', NULL, 'PurchaseOrderItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Qty_to_ReceiveSpecified', NULL, 'PurchaseOrderItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Quantity_Received', NULL, 'PurchaseOrderItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Quantity_ReceivedSpecified', NULL, 'PurchaseOrderItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Qty_to_Invoice', NULL, 'PurchaseOrderItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Qty_to_InvoiceSpecified', NULL, 'PurchaseOrderItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Quantity_Invoiced', NULL, 'PurchaseOrderItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Quantity_InvoicedSpecified', NULL, 'PurchaseOrderItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Prepmt_Amt_to_Deduct', NULL, 'PurchaseOrderItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Prepmt_Amt_to_DeductSpecified', NULL, 'PurchaseOrderItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Prepmt_Amt_Deducted', NULL, 'PurchaseOrderItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Prepmt_Amt_DeductedSpecified', NULL, 'PurchaseOrderItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Allow_Item_Charge_Assignment', NULL, 'PurchaseOrderItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Allow_Item_Charge_AssignmentSpecified', NULL, 'PurchaseOrderItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Qty_to_Assign', NULL, 'PurchaseOrderItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Qty_to_AssignSpecified', NULL, 'PurchaseOrderItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Qty_Assigned', NULL, 'PurchaseOrderItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Qty_AssignedSpecified', NULL, 'PurchaseOrderItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Job_No', NULL, 'PurchaseOrderItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Job_Task_No', NULL, 'PurchaseOrderItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Job_Planning_Line_No', NULL, 'PurchaseOrderItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Job_Planning_Line_NoSpecified', NULL, 'PurchaseOrderItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Job_Line_Type', NULL, 'PurchaseOrderItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Job_Line_TypeSpecified', NULL, 'PurchaseOrderItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Job_Unit_Price', NULL, 'PurchaseOrderItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Job_Unit_PriceSpecified', NULL, 'PurchaseOrderItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Job_Line_Amount', NULL, 'PurchaseOrderItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Job_Line_AmountSpecified', NULL, 'PurchaseOrderItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Job_Line_Discount_Amount', NULL, 'PurchaseOrderItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Job_Line_Discount_AmountSpecified', NULL, 'PurchaseOrderItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Job_Line_Discount_Percent', NULL, 'PurchaseOrderItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Job_Line_Discount_PercentSpecified', NULL, 'PurchaseOrderItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Job_Total_Price', NULL, 'PurchaseOrderItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Job_Total_PriceSpecified', NULL, 'PurchaseOrderItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Job_Unit_Price_LCY', NULL, 'PurchaseOrderItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Job_Unit_Price_LCYSpecified', NULL, 'PurchaseOrderItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Job_Total_Price_LCY', NULL, 'PurchaseOrderItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Job_Total_Price_LCYSpecified', NULL, 'PurchaseOrderItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Job_Line_Amount_LCY', NULL, 'PurchaseOrderItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Job_Line_Amount_LCYSpecified', NULL, 'PurchaseOrderItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Job_Line_Disc_Amount_LCY', NULL, 'PurchaseOrderItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Job_Line_Disc_Amount_LCYSpecified', NULL, 'PurchaseOrderItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Requested_Receipt_Date', NULL, 'PurchaseOrderItem', '''0001-01-01''', NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Requested_Receipt_DateSpecified', NULL, 'PurchaseOrderItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Promised_Receipt_Date', NULL, 'PurchaseOrderItem', '''0001-01-01''', NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Promised_Receipt_DateSpecified', NULL, 'PurchaseOrderItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Planned_Receipt_Date', NULL, 'PurchaseOrderItem', '''0001-01-01''', NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Planned_Receipt_DateSpecified', NULL, 'PurchaseOrderItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Expected_Receipt_Date', NULL, 'PurchaseOrderItem', '''0001-01-01''', NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Expected_Receipt_DateSpecified', NULL, 'PurchaseOrderItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Order_Date', NULL, 'PurchaseOrderItem', '''0001-01-01''', NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Order_DateSpecified', NULL, 'PurchaseOrderItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Lead_Time_Calculation', NULL, 'PurchaseOrderItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Planning_Flexibility', NULL, 'PurchaseOrderItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Planning_FlexibilitySpecified', NULL, 'PurchaseOrderItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Prod_Order_No', NULL, 'PurchaseOrderItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Prod_Order_Line_No', NULL, 'PurchaseOrderItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Prod_Order_Line_NoSpecified', NULL, 'PurchaseOrderItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Operation_No', NULL, 'PurchaseOrderItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Work_Center_No', NULL, 'PurchaseOrderItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Finished', NULL, 'PurchaseOrderItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'FinishedSpecified', NULL, 'PurchaseOrderItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Whse_Outstanding_Qty_Base', NULL, 'PurchaseOrderItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Whse_Outstanding_Qty_BaseSpecified', NULL, 'PurchaseOrderItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Inbound_Whse_Handling_Time', NULL, 'PurchaseOrderItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Blanket_Order_No', NULL, 'PurchaseOrderItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Blanket_Order_Line_No', NULL, 'PurchaseOrderItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Blanket_Order_Line_NoSpecified', NULL, 'PurchaseOrderItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Appl_to_Item_Entry', NULL, 'PurchaseOrderItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Appl_to_Item_EntrySpecified', NULL, 'PurchaseOrderItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Deferral_Code', NULL, 'PurchaseOrderItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Shortcut_Dimension_1_Code', NULL, 'PurchaseOrderItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Shortcut_Dimension_2_Code', NULL, 'PurchaseOrderItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'ShortcutDimCode3', NULL, 'PurchaseOrderItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'ShortcutDimCode4', NULL, 'PurchaseOrderItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'ShortcutDimCode5', NULL, 'PurchaseOrderItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'ShortcutDimCode6', NULL, 'PurchaseOrderItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'ShortcutDimCode7', NULL, 'PurchaseOrderItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'ShortcutDimCode8', NULL, 'PurchaseOrderItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'IRS_1099_Liable', NULL, 'PurchaseOrderItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'IRS_1099_LiableSpecified', NULL, 'PurchaseOrderItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Document_No', NULL, 'PurchaseOrderItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Line_No', NULL, 'PurchaseOrderItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Line_NoSpecified', NULL, 'PurchaseOrderItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Over_Receive', NULL, 'PurchaseOrderItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Over_ReceiveSpecified', NULL, 'PurchaseOrderItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Over_Receive_Verified', NULL, 'PurchaseOrderItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Over_Receive_VerifiedSpecified', NULL, 'PurchaseOrderItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'EDI_Unit_Cost', NULL, 'PurchaseOrderItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'EDI_Unit_CostSpecified', NULL, 'PurchaseOrderItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'EDI_Cost_Discrepancy', NULL, 'PurchaseOrderItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'EDI_Cost_DiscrepancySpecified', NULL, 'PurchaseOrderItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'EDI_Segment_Group', NULL, 'PurchaseOrderItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'EDI_Segment_GroupSpecified', NULL, 'PurchaseOrderItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Invoice_Discount_Amount', NULL, 'PurchaseOrderItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Invoice_Discount_AmountSpecified', NULL, 'PurchaseOrderItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Invoice_Disc_Pct', NULL, 'PurchaseOrderItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Invoice_Disc_PctSpecified', NULL, 'PurchaseOrderItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Total_Amount_Excl_VAT', NULL, 'PurchaseOrderItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Total_Amount_Excl_VATSpecified', NULL, 'PurchaseOrderItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Total_VAT_Amount', NULL, 'PurchaseOrderItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Total_VAT_AmountSpecified', NULL, 'PurchaseOrderItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Total_Amount_Incl_VAT', NULL, 'PurchaseOrderItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Total_Amount_Incl_VATSpecified', NULL, 'PurchaseOrderItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'RefreshTotals', NULL, 'PurchaseOrderItem', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Key', NULL, 'ShipSalesOrderPart', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Shipping_Agent_Code', NULL, 'ShipSalesOrderPart', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'E_Ship_Agent_Service', NULL, 'ShipSalesOrderPart', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Residential_Delivery', NULL, 'ShipSalesOrderPart', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Residential_DeliverySpecified', NULL, 'ShipSalesOrderPart', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Blind_Shipment', NULL, 'ShipSalesOrderPart', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Blind_ShipmentSpecified', NULL, 'ShipSalesOrderPart', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Double_Blind_Shipment', NULL, 'ShipSalesOrderPart', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Double_Blind_ShipmentSpecified', NULL, 'ShipSalesOrderPart', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Double_Blind_Ship_from_Cust_No', NULL, 'ShipSalesOrderPart', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Ship_for_Code', NULL, 'ShipSalesOrderPart', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'EShipValidation_SalesHeader_PackingStatus_Rec', NULL, 'ShipSalesOrderPart', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Shipping_Payment_Type', NULL, 'ShipSalesOrderPart', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Shipping_Payment_TypeSpecified', NULL, 'ShipSalesOrderPart', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Third_Party_Ship_Account_No', NULL, 'ShipSalesOrderPart', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Shipping_Insurance', NULL, 'ShipSalesOrderPart', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Shipping_InsuranceSpecified', NULL, 'ShipSalesOrderPart', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Free_Freight', NULL, 'ShipSalesOrderPart', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Free_FreightSpecified', NULL, 'ShipSalesOrderPart', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'E_Mail_Confirmation_Handled', NULL, 'ShipSalesOrderPart', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'E_Mail_Confirmation_HandledSpecified', NULL, 'ShipSalesOrderPart', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Invoice_for_Bill_of_Lading_No', NULL, 'ShipSalesOrderPart', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Invoice_for_Shipment_No', NULL, 'ShipSalesOrderPart', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Shipment_Invoice_Override', NULL, 'ShipSalesOrderPart', NULL, NULL)
GO

INSERT INTO dbo.NAV000OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Shipment_Invoice_OverrideSpecified', NULL, 'ShipSalesOrderPart', NULL, NULL)
GO









