INSERT INTO dbo.OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES ('CustERPID', 'Sell_to_Customer_No', 'Customer', 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Sell_to_Customer_Name', NULL, 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Quote_No', NULL, 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Sell_to_Address', NULL, 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Sell_to_Address_2', NULL, 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Sell_to_City', NULL, 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Sell_to_County', NULL, 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Sell_to_Post_Code', NULL, 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Sell_to_Contact_No', NULL, 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Sell_to_Contact', NULL, 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'No_of_Archived_Versions', NULL, 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Document_Date', NULL, 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Posting_Date', NULL, 'SalesOrder', 'CAST(CAST(GETDATE() AS DATE) AS VARCHAR)', NULL)
GO

INSERT INTO dbo.OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Order_Date', NULL, 'SalesOrder', 'CAST(CAST(GETDATE() AS DATE) AS VARCHAR)', NULL)
GO

INSERT INTO dbo.OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Due_Date', NULL, 'SalesOrder', 'CAST(CAST(GETDATE() AS DATE) AS VARCHAR)', NULL)
GO

INSERT INTO dbo.OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Requested_Delivery_Date', NULL, 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Promised_Delivery_Date', NULL, 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES ('JobCustomerSalesOrder', 'External_Document_No', 'Job', 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Salesperson_Code', NULL, 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Campaign_No', NULL, 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Opportunity_No', NULL, 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Responsibility_Center', NULL, 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Assigned_User_ID', NULL, 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Job_Queue_Status', NULL, 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Status', NULL, 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES ('CAST(Job.Id AS VARCHAR)', 'M4PL_Job_ID', 'Job', 'SalesOrder', NULL, 1)
GO

INSERT INTO dbo.OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'FSC_Calculated', NULL, 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'WorkDescription', NULL, 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Ship_from_Code', NULL, 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES ('JobOriginSiteName', 'Ship_from_Name', 'Job', 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Ship_from_Name_2', NULL, 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES ('JobOriginStreetAddress', 'Ship_from_Address', 'Job', 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Ship_from_Address_2', NULL, 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES ('JobOriginCity', 'Ship_from_City', 'Job', 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES ('JobOriginState', 'Ship_From_County', 'Job', 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES ('JobOriginPostalCode', 'Ship_From_Post_Code', 'Job', 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES ('JobOriginSitePOC', 'Ship_from_Contact', 'Job', 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES ('JobOriginSitePOCPhone', 'Ship_from_Phone', 'Job', 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES ('JobOriginSitePOCPhone2', 'Ship_from_Mobile', 'Job', 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES ('JobOriginSitePOCEmail', 'Ship_from_Email', 'Job', 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Ship_to_Code', NULL, 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES ('JobDeliverySiteName', 'Ship_to_Name', 'Job', 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES ('JobDeliveryStreetAddress', 'Ship_to_Address', 'Job', 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Ship_to_Address_2', NULL, 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES ('JobDeliveryCity', 'Ship_to_City', 'Job', 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES ('JobDeliveryState', 'Ship_to_County', 'Job', 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES ('JobDeliveryPostalCode', 'Ship_to_Post_Code', 'Job', 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES ('JobDeliverySitePOC', 'Ship_to_Contact', 'Job', 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Ship_to_UPS_Zone', NULL, 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES ('JobDeliverySitePOCPhone', 'Ship_to_Phone', 'Job', 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES ('JobDeliverySitePOCPhone2', 'Ship_to_Mobile', 'Job', 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES ('JobDeliverySitePOCEmail', 'Ship_to_Email', 'Job', 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Currency_Code', NULL, 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Payment_Terms_Code', NULL, 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Payment_Method_Code', NULL, 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Tax_Liable', NULL, 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Tax_Area_Code', NULL, 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'SelectedPayments', NULL, 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Transaction_Type', NULL, 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Shortcut_Dimension_1_Code', NULL, 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Shortcut_Dimension_2_Code', NULL, 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Payment_Discount_Percent', NULL, 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Pmt_Discount_Date', NULL, 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Pmt_Discount_DateSpecified', NULL, 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Direct_Debit_Mandate_ID', NULL, 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Shipment_Method_Code', NULL, 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Shipping_Agent_Code', NULL, 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Shipping_Agent_Service_Code', NULL, 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Package_Tracking_No', NULL, 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Bill_to_Name', NULL, 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Bill_to_Address', NULL, 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Bill_to_Address_2', NULL, 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Bill_to_City', NULL, 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Bill_to_County', NULL, 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Bill_to_Post_Code', NULL, 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Bill_to_Contact_No', NULL, 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Bill_to_Contact', NULL, 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Location_Code', NULL, 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Shipment_Date', NULL, 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Shipping_Advice', NULL, 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Outbound_Whse_Handling_Time', NULL, 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Shipping_Time', NULL, 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Late_Order_Shipping', NULL, 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Transaction_Specification', NULL, 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Transport_Method', NULL, 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Exit_Point', NULL, 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Area', NULL, 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Prepayment_Percent', NULL, 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Compress_Prepayment', NULL, 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Prepmt_Payment_Terms_Code', NULL, 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Prepayment_Due_Date', NULL, 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Prepmt_Payment_Discount_Percent', NULL, 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Prepmt_Pmt_Discount_Date', NULL, 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Prepmt_Include_Tax', NULL, 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'EDI_Order', NULL, 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'EDI_Internal_Doc_No', NULL, 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'EDI_Ack_Generated', NULL, 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'EDI_Ack_Gen_Date', NULL, 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'EDI_Released', NULL, 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'EDI_WHSE_Shp_Gen', NULL, 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'EDI_WHSE_Shp_Gen_Date', NULL, 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'EDI_Transaction_Date', NULL, 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'EDI_Transaction_Time', NULL, 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'EDI_Expected_Delivery_Date', NULL, 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'EDI_Trade_Partner', NULL, 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'EDI_Sell_to_Code', NULL, 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'EDI_Ship_for_Code', NULL, 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'EDI_Ship_to_Code', NULL, 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'EDI_Cancel_After_Date', NULL, 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'EDI_Cancellation_Request', NULL, 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'EDI_Cancellation_Date', NULL, 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'EDI_Cancellation_Advice', NULL, 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'EDI_Cancellation_Advice_Date', NULL, 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'EDI_Cancellation_Generated', NULL, 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Date_Filter', NULL, 'SalesOrder', NULL, NULL)
GO

INSERT INTO dbo.OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES ('CAST(Job.Id AS VARCHAR)', 'M4PL_Job_ID', 'Job', 'ShippingItem', NULL, 1)
GO

INSERT INTO dbo.OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Description', NULL, 'ShippingItem', NULL, NULL)
GO

INSERT INTO dbo.OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Net_Weight', NULL, 'ShippingItem', NULL, NULL)
GO

INSERT INTO dbo.OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Location_Code', NULL, 'ShippingItem', NULL, NULL)
GO

INSERT INTO dbo.OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES ('JobQtyActual', 'Quantity', 'Job', 'ShippingItem', NULL, NULL)
GO

INSERT INTO dbo.OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Unit_Price', NULL, 'ShippingItem', NULL, NULL)
GO

INSERT INTO dbo.OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Tax_Group_Code', NULL, 'ShippingItem', NULL, NULL)
GO

INSERT INTO dbo.OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Line_Discount_Amount', NULL, 'ShippingItem', NULL, NULL)
GO

INSERT INTO dbo.OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES ('JobQtyActual', 'Qty_to_Ship', 'Job', 'ShippingItem', NULL, NULL)
GO

INSERT INTO dbo.OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES ('JobQtyActual', 'Qty_to_Invoice', 'Job', 'ShippingItem', NULL, NULL)
GO

INSERT INTO dbo.OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Shipment_Date', NULL, 'ShippingItem', 'CAST(CAST(GETDATE() AS DATE) AS VARCHAR)', NULL)
GO

INSERT INTO dbo.OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Planned_Shipment_Date', NULL, 'ShippingItem', 'CAST(CAST(GETDATE() AS DATE) AS VARCHAR)', NULL)
GO

INSERT INTO dbo.OrderMapping (M4PLColumn, NavColumn, TableName, EntityName, DefaultValue, SpecialHandling)
VALUES (NULL, 'Planned_Delivery_Date', NULL, 'ShippingItem', 'CAST(CAST(GETDATE() AS DATE) AS VARCHAR)', NULL)
GO

