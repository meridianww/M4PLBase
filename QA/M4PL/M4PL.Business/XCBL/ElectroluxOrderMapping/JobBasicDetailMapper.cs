#region Copyright

/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved.
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group.
******************************************************************************/

#endregion Copyright

using M4PL.Entities;
using M4PL.Entities.Administration;
using M4PL.Entities.XCBL.Electrolux.OrderRequest;
using M4PL.Entities.XCBL.FarEye.Order;
using M4PL.Utilities;
using System;
using System.Collections.Generic;
using System.Linq;

namespace M4PL.Business.XCBL.ElectroluxOrderMapping
{
    public class JobBasicDetailMapper
    {
        public Entities.Job.Job ToJobBasicDetailModel(OrderHeader orderHeader, ref Entities.Job.Job jobDatatoUpdate, long programId, OrderLineDetailList orderLineDetailList, bool isASNRequest, List<SystemReference> systemOptionList)
        {
            if (orderHeader == null) return jobDatatoUpdate;

            DateTime? asnShipDate = !string.IsNullOrEmpty(orderHeader?.ASNdata?.Shipdate) && orderHeader?.ASNdata?.Shipdate.Length >= 8 ?
                string.Format("{0}-{1}-{2}", orderHeader?.ASNdata?.Shipdate.Substring(0, 4), orderHeader?.ASNdata?.Shipdate.Substring(4, 2), orderHeader?.ASNdata?.Shipdate.Substring(6, 2)).ToDate()
                : null;
            jobDatatoUpdate = jobDatatoUpdate != null ? jobDatatoUpdate : new Entities.Job.Job();
            jobDatatoUpdate.JobQtyUnitTypeId = systemOptionList?.
                Where(x => x.SysLookupCode.Equals("CargoUnit", StringComparison.OrdinalIgnoreCase))?.
                Where(y => y.SysOptionName.Equals("Each", StringComparison.OrdinalIgnoreCase))?.
                FirstOrDefault().Id;
            jobDatatoUpdate.JobPONumber = orderHeader.CustomerPO;
            jobDatatoUpdate.JobServiceMode = orderHeader.OriginalOrderNumber;
            jobDatatoUpdate.JobCustomerPurchaseOrder = orderHeader.CustomerPO;
            jobDatatoUpdate.JobCustomerSalesOrder = orderHeader.OrderNumber;
            jobDatatoUpdate.PlantIDCode = (orderHeader.ShipFrom != null && !string.IsNullOrEmpty(orderHeader.ShipFrom.LocationID)) ? orderHeader.ShipFrom.LocationID : jobDatatoUpdate.PlantIDCode;
            jobDatatoUpdate.StatusId = (int)StatusType.Active;
            jobDatatoUpdate.ProgramID = programId;
            jobDatatoUpdate.JobType = "Original";
            jobDatatoUpdate.ShipmentType = "Cross-Dock Shipment";
            jobDatatoUpdate.JobSiteCode = !string.IsNullOrEmpty(orderHeader?.ShipTo.LocationName) && orderHeader?.ShipTo.LocationName.Length >= 4 ? orderHeader.ShipTo.LocationName.Substring(orderHeader.ShipTo.LocationName.Length - 4) : null;
            jobDatatoUpdate.JobElectronicInvoice = true;
            jobDatatoUpdate.JobOrderedDate = !string.IsNullOrEmpty(orderHeader.OrderDate) ? Convert.ToDateTime(Convert.ToDateTime(orderHeader.OrderDate).ToShortDateString()) : (DateTime?)null;
            ////jobDatatoUpdate.JobDeliveryDateTimePlanned = !string.IsNullOrEmpty(orderHeader.DeliveryDate)
            ////        ? Convert.ToDateTime(orderHeader.DeliveryDate) : (DateTime?)null;
            jobDatatoUpdate.JobTotalWeight = (orderLineDetailList != null && orderLineDetailList.OrderLineDetail?.Count > 0) ?
                orderLineDetailList.OrderLineDetail.Sum(x => x.Weight) : jobDatatoUpdate.JobTotalWeight;
            jobDatatoUpdate.JobTotalCubes = (orderLineDetailList != null && orderLineDetailList.OrderLineDetail?.Count > 0) ?
                orderLineDetailList.OrderLineDetail.Sum(x => x.Volume.ToDecimal()) : jobDatatoUpdate.JobTotalCubes;
            jobDatatoUpdate.JobWeightUnitTypeId = systemOptionList.Where(x => x.SysLookupCode == "WeightUnitType" && x.SysOptionName == "L")?.FirstOrDefault().Id;
            jobDatatoUpdate.JobWeightUnitTypeIdName = "L";
            jobDatatoUpdate.JobCubesUnitTypeId = systemOptionList.Where(x => x.SysLookupCode == "CubesUnitType" && x.SysOptionName == "E")?.FirstOrDefault().Id;
            jobDatatoUpdate.JobCubesUnitTypeIdName = "E";
            jobDatatoUpdate.JobDeliveryDateTimeBaseline = !string.IsNullOrEmpty(orderHeader.DeliveryDate) ? Convert.ToDateTime(orderHeader.DeliveryDate) : (DateTime?)null;
            if (isASNRequest)
            {
                int? qtyActual = orderLineDetailList?.OrderLineDetail?.Where(x => x.MaterialType.Equals("PRODUCT", StringComparison.OrdinalIgnoreCase))?.Sum(x => x.ShipQuantity);
                int? jobPartsOrdered = orderLineDetailList?.OrderLineDetail?.Where(x => x.MaterialType.Equals("ACCESSORY", StringComparison.OrdinalIgnoreCase))?.Sum(x => x.ShipQuantity);
                int? jobServiceActual = orderLineDetailList?.OrderLineDetail?.Where(x => x.MaterialType.Equals("SERVICES", StringComparison.OrdinalIgnoreCase) || x.MaterialType.Equals("SERVICE", StringComparison.OrdinalIgnoreCase))?.Sum(x => x.ShipQuantity);

                jobDatatoUpdate.JobQtyActual = qtyActual == 0 ? null : qtyActual;
                jobDatatoUpdate.JobPartsActual = jobPartsOrdered == 0 ? null : jobPartsOrdered;
                jobDatatoUpdate.JobServiceActual = jobServiceActual == 0 ? null : jobServiceActual;
                jobDatatoUpdate.JobOriginDateTimeBaseline = asnShipDate.HasValue ? asnShipDate.ToDateTime() : jobDatatoUpdate.JobOriginDateTimeBaseline;
                jobDatatoUpdate.JobOriginDateTimePlanned = asnShipDate.HasValue ? asnShipDate.ToDateTime() : jobDatatoUpdate.JobOriginDateTimePlanned;
                jobDatatoUpdate.JobShipmentDate = asnShipDate.HasValue ? asnShipDate.ToDateTime() : jobDatatoUpdate.JobOriginDateTimePlanned;
            }
            else
            {
                int? partsOrderedCount = orderLineDetailList?.OrderLineDetail?.Where(x => x.MaterialType.Equals("ACCESSORY", StringComparison.OrdinalIgnoreCase))?.Sum(x => x.ShipQuantity);
                int? qtyOrderedCount = orderLineDetailList?.OrderLineDetail?.Where(x => x.MaterialType.Equals("PRODUCT", StringComparison.OrdinalIgnoreCase))?.Sum(x => x.ShipQuantity);
                int? jobServiceOrderCount = orderLineDetailList?.OrderLineDetail?.Where(x => x.MaterialType.Equals("SERVICES", StringComparison.OrdinalIgnoreCase) || x.MaterialType.Equals("SERVICE", StringComparison.OrdinalIgnoreCase))?.Sum(x => x.ShipQuantity);

                jobDatatoUpdate.JobQtyOrdered = qtyOrderedCount == 0 ? null : qtyOrderedCount;
                jobDatatoUpdate.JobPartsOrdered = partsOrderedCount == 0 ? null : partsOrderedCount;
                jobDatatoUpdate.JobServiceOrder = jobServiceOrderCount == 0 ? null : jobServiceOrderCount;
            }

            return jobDatatoUpdate;
        }

        public Entities.Job.Job ToJobBasicDetailModelFromFarEyeData(FarEyeOrderDetails orderDetails, ref Entities.Job.Job jobDatatoUpdate, long programId, bool isASNRequest, List<SystemReference> systemOptionList)
        {
            if (orderDetails == null) return jobDatatoUpdate;
            var holdStatus = systemOptionList.FirstOrDefault(x => x.SysLookupCode.Equals("Status", StringComparison.OrdinalIgnoreCase) && x.SysOptionName.Equals("Hold", StringComparison.OrdinalIgnoreCase));
            jobDatatoUpdate = jobDatatoUpdate != null ? jobDatatoUpdate : new Entities.Job.Job();
            DateTime? asnShipDate = null;
            if (orderDetails.info != null)
            {
                asnShipDate = !string.IsNullOrEmpty(orderDetails?.info?.good_issue_date) && orderDetails?.info?.good_issue_date.Length >= 8 ?
               string.Format("{0}-{1}-{2}", orderDetails?.info?.good_issue_date.Substring(0, 4), orderDetails?.info?.good_issue_date.Substring(4, 2), orderDetails?.info?.good_issue_date.Substring(6, 2)).ToDate()
               : null;
                jobDatatoUpdate.JobPONumber = orderDetails.info.customer_po;
                jobDatatoUpdate.JobCustomerPurchaseOrder = orderDetails.info.customer_po;
                jobDatatoUpdate.JobOrderedDate = DateTime.Now;
                jobDatatoUpdate.JobDeliveryDateTimeBaseline = !string.IsNullOrEmpty(orderDetails.info.install_date) ? Convert.ToDateTime(Convert.ToDateTime(orderDetails.info.install_date).ToShortDateString()) : (DateTime?)null;
                jobDatatoUpdate.JobOriginDateTimeBaseline = !string.IsNullOrEmpty(orderDetails.info.requested_delivery_date) ? Convert.ToDateTime(Convert.ToDateTime(orderDetails.info.requested_delivery_date).ToShortDateString()) : (DateTime?)null;
                jobDatatoUpdate.JobOriginDateTimePlanned = !string.IsNullOrEmpty(orderDetails.info.requested_delivery_date) ? Convert.ToDateTime(Convert.ToDateTime(orderDetails.info.requested_delivery_date).ToShortDateString()) : (DateTime?)null;
                jobDatatoUpdate.JobDeliveryDateTimePlanned = orderDetails.non_executable ? new DateTime(2049, 12, 31, 0, 0,0) : jobDatatoUpdate.JobDeliveryDateTimePlanned != null ? jobDatatoUpdate.JobDeliveryDateTimePlanned : (DateTime?)null;
                //!string.IsNullOrEmpty(orderDetails.info.install_date) ? Convert.ToDateTime(Convert.ToDateTime(orderDetails.info.install_date).ToShortDateString()) : (DateTime?)null;
                ////jobDatatoUpdate.JobDeliveryDateTimePlanned = !string.IsNullOrEmpty(orderDetails.info.outbound_delivery_date)
                ////        ? Convert.ToDateTime(orderDetails.info.outbound_delivery_date) : (DateTime?)null;
            }

            jobDatatoUpdate = jobDatatoUpdate != null ? jobDatatoUpdate : new Entities.Job.Job();
            jobDatatoUpdate.JobQtyUnitTypeId = systemOptionList?.
                Where(x => x.SysLookupCode.Equals("CargoUnit", StringComparison.OrdinalIgnoreCase))?.
                Where(y => y.SysOptionName.Equals("Each", StringComparison.OrdinalIgnoreCase))?.
                FirstOrDefault().Id;
            
            jobDatatoUpdate.JobBOLMaster = orderDetails.order_number;
            jobDatatoUpdate.JobCustomerSalesOrder = orderDetails.tracking_number;
            jobDatatoUpdate.PlantIDCode = !string.IsNullOrEmpty(orderDetails.origin_code) ? orderDetails.origin_code : jobDatatoUpdate.PlantIDCode;
            //jobDatatoUpdate.StatusId = holdStatus != null && orderDetails.non_executable ?  holdStatus.Id : (int)StatusType.Active;
            jobDatatoUpdate.JobDeliveryCommentText = orderDetails.non_executable_reason;
            //jobDatatoUpdate.JobBOLMaster = orderDetails.original_order_number; // Decided to use BOL Master (Parent) for Electrolux internal order number as the original order number is not mandatory
            jobDatatoUpdate.JobBOLChild = orderDetails.rl_number;
            jobDatatoUpdate.JobChannel = orderDetails.scac_code;
            jobDatatoUpdate.CarrierID = orderDetails.rush_order;
            jobDatatoUpdate.ProgramID = programId;
            jobDatatoUpdate.JobType = orderDetails.type_of_order.Equals("Reverse", StringComparison.OrdinalIgnoreCase) ? "Return" : "Original";
            jobDatatoUpdate.ShipmentType = "Cross-Dock Shipment";
            jobDatatoUpdate.JobSiteCode = !string.IsNullOrEmpty(orderDetails.destination_name) && orderDetails.destination_name.Length >= 4 ? orderDetails.destination_name.Substring(orderDetails.destination_name.Length - 4) : null;
            jobDatatoUpdate.JobElectronicInvoice = true;
            //jobDatatoUpdate.JobDeliveryDateTimeBaseline = orderDetails.info != null && !string.IsNullOrEmpty(orderDetails.info.outbound_delivery_date) ? Convert.ToDateTime(orderDetails.info.outbound_delivery_date) : (DateTime?)null;
            if (orderDetails.item_list != null && orderDetails.item_list.Count > 0)
            {
                jobDatatoUpdate.JobTotalWeight = orderDetails.item_list.Sum(x => x.item_weight.ToDecimal());
                jobDatatoUpdate.JobTotalCubes = orderDetails.item_list.Sum(x => x.item_volumn.ToDecimal());
                jobDatatoUpdate.JobWeightUnitTypeId = systemOptionList.Where(x => x.SysLookupCode == "WeightUnitType" && x.SysOptionName == "L")?.FirstOrDefault().Id;
                jobDatatoUpdate.JobWeightUnitTypeIdName = "L";
                jobDatatoUpdate.JobCubesUnitTypeId = systemOptionList.Where(x => x.SysLookupCode == "CubesUnitType" && x.SysOptionName == "E")?.FirstOrDefault().Id;
                jobDatatoUpdate.JobCubesUnitTypeIdName = "E";
                if (isASNRequest)
                {
                    int? qtyActual = orderDetails.item_list.Where(x => x.item_material_type.Equals("PRODUCT", StringComparison.OrdinalIgnoreCase))?.Sum(x => x.item_quantity);
                    int? jobPartsOrdered = orderDetails.item_list.Where(x => x.item_material_type.Equals("ACCESSORY", StringComparison.OrdinalIgnoreCase))?.Sum(x => x.item_quantity);
                    int? jobServiceActual = orderDetails.item_list.Where(x => x.item_material_type.Equals("SERVICES", StringComparison.OrdinalIgnoreCase) || x.item_material_type.Equals("SERVICE", StringComparison.OrdinalIgnoreCase))?.Sum(x => x.item_quantity);

                    jobDatatoUpdate.JobQtyActual = qtyActual == 0 ? null : qtyActual;
                    jobDatatoUpdate.JobPartsActual = jobPartsOrdered == 0 ? null : jobPartsOrdered;
                    jobDatatoUpdate.JobServiceActual = jobServiceActual == 0 ? null : jobServiceActual;
                }
                else
                {
                    int? partsOrderedCount = orderDetails.item_list.Where(x => x.item_material_type.Equals("ACCESSORY", StringComparison.OrdinalIgnoreCase))?.Sum(x => x.item_quantity);
                    int? qtyOrderedCount = orderDetails.item_list.Where(x => x.item_material_type.Equals("PRODUCT", StringComparison.OrdinalIgnoreCase))?.Sum(x => x.item_quantity);
                    int? jobServiceOrderCount = orderDetails.item_list.Where(x => x.item_material_type.Equals("SERVICES", StringComparison.OrdinalIgnoreCase) || x.item_material_type.Equals("SERVICE", StringComparison.OrdinalIgnoreCase))?.Sum(x => x.item_quantity);

                    jobDatatoUpdate.JobQtyOrdered = qtyOrderedCount == 0 ? null : qtyOrderedCount;
                    jobDatatoUpdate.JobPartsOrdered = partsOrderedCount == 0 ? null : partsOrderedCount;
                    jobDatatoUpdate.JobServiceOrder = jobServiceOrderCount == 0 ? null : jobServiceOrderCount;
                }
            }

            if (isASNRequest)
            {
                jobDatatoUpdate.JobOriginDateTimeBaseline = asnShipDate.HasValue ? asnShipDate.ToDateTime() : jobDatatoUpdate.JobOriginDateTimeBaseline;
                jobDatatoUpdate.JobOriginDateTimePlanned = asnShipDate.HasValue ? asnShipDate.ToDateTime() : jobDatatoUpdate.JobOriginDateTimePlanned;
                jobDatatoUpdate.JobShipmentDate = asnShipDate.HasValue ? asnShipDate.ToDateTime() : jobDatatoUpdate.JobOriginDateTimePlanned;
            }

            return jobDatatoUpdate;
        }
    }
}