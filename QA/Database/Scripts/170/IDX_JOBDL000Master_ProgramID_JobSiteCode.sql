
CREATE NONCLUSTERED INDEX [IDX_JOBDL000Master_ProgramID_JobSiteCode]
ON [dbo].[JOBDL000Master] ([ProgramID])
INCLUDE ([JobSiteCode],[JobCustomerSalesOrder],[JobBOL],[JobCustomerPurchaseOrder],[JobCarrierContract],[JobServiceMode],[JobChannel],[JobProductType],[JobGatewayStatus],[StatusId],[PlantIDCode],[JobDeliverySitePOC],[JobDeliverySitePOCPhone],[JobDeliverySitePOCEmail],[JobDeliverySiteName],[JobDeliveryStreetAddress],[JobDeliveryStreetAddress2],[JobDeliveryCity],[JobDeliveryState],[JobDeliveryPostalCode],[JobDeliveryDateTimePlanned],[JobDeliveryDateTimeActual],[JobOriginDateTimePlanned],[JobOriginDateTimeActual],[JobDeliverySitePOCPhone2],[JobSellerSitePOCEmail],[JobSellerSiteName],[DateEntered],[JobOrderedDate],[JobMileage])

