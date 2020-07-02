#region Copyright
/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved. 
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group. 
******************************************************************************/
#endregion Copyright

using M4PL.Entities.Administration;
using M4PL.Entities.Job;
using M4PL.Entities.XCBL.Electrolux.OrderRequest;
using M4PL.Utilities;
using System;
using System.Collections.Generic;
using System.Linq;

namespace M4PL.Business.XCBL.ElectroluxOrderMapping
{
    public class JobCargoMapper
    {
        public List<JobCargo> ToJobCargoMapper(IEnumerable<OrderLineDetail> orderLineDetail, long jobId, List<SystemReference> systemOptionList)
        {
            if (orderLineDetail == null)
            {
                return null;
            }

            var jobCargos = new List<JobCargo>();
            int applienceId = (int)systemOptionList?.
                Where(x => x.SysLookupCode.Equals("PackagingCode", StringComparison.OrdinalIgnoreCase))?.
                Where(y => y.SysOptionName.Equals("Appliance", StringComparison.OrdinalIgnoreCase))?.
                FirstOrDefault().Id;
            int accessoryId = (int)systemOptionList?.
                Where(x => x.SysLookupCode.Equals("PackagingCode", StringComparison.OrdinalIgnoreCase))?.
                Where(y => y.SysOptionName.Equals("Accessory", StringComparison.OrdinalIgnoreCase))?.
                FirstOrDefault().Id;
            int serviceId = (int)systemOptionList?.
                Where(x => x.SysLookupCode.Equals("PackagingCode", StringComparison.OrdinalIgnoreCase))?.
                Where(y => y.SysOptionName.Equals("Service", StringComparison.OrdinalIgnoreCase))?.
                FirstOrDefault().Id;

            jobCargos.AddRange(orderLineDetail.Select(cargoitem => new JobCargo
            {
                JobID = jobId,
                CgoLineItem = cargoitem.LineNumber.ToInt(), //Nathan will ask to Electrolux,
                CgoPartNumCode = cargoitem.ItemID,
                CgoTitle = (!string.IsNullOrEmpty(cargoitem.ItemDescription) && cargoitem.ItemDescription.Contains(cargoitem.ItemID)) ? cargoitem.ItemDescription.Replace(cargoitem.ItemID, string.Empty) : cargoitem.ItemDescription,
                CgoSerialNumber = cargoitem.SerialNumber,
                CgoPackagingTypeIdName = cargoitem.MaterialType,
                CgoWeight = cargoitem.Weight,
                CgoWeightUnitsIdName = cargoitem.WeightUnitOfMeasure?.ToUpper() == "KGM" ? "KG" : "LB",
                CgoCubes = cargoitem.Volume.ToDecimal(),
                CgoVolumeUnitsIdName = cargoitem.VolumeUnitOfMeasure?.ToUpper() == "MTQ" ? "Meters" : "Cubic Feet",
                CgoQtyOrdered = cargoitem.ShipQuantity,
                CgoQtyUnitsIdName = "EA",
                CgoQtyUnitsId = systemOptionList?.
                Where(x => x.SysLookupCode.Equals("CargoUnit", StringComparison.OrdinalIgnoreCase))?.
                Where(y => y.SysOptionName.Equals("Each", StringComparison.OrdinalIgnoreCase))?.
                FirstOrDefault().Id,
                CgoPackagingTypeId = cargoitem.MaterialType.Equals("ACCESSORY", StringComparison.OrdinalIgnoreCase) ? accessoryId
                : (cargoitem.MaterialType.Equals("SERVICES", StringComparison.OrdinalIgnoreCase) || cargoitem.MaterialType.Equals("SERVICE", StringComparison.OrdinalIgnoreCase))
                ? serviceId : applienceId,
                StatusId = (int)Entities.StatusType.Active
            }));

            return jobCargos;
        }
    }
}
