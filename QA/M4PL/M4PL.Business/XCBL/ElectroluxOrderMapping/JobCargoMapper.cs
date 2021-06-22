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
using M4PL.Entities.XCBL.FarEye.Order;
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
			int weightUnitKg = (int)systemOptionList?.
				Where(x => x.SysLookupCode.Equals("UnitWeight", StringComparison.OrdinalIgnoreCase))?.
				Where(y => y.SysOptionName.Equals("KGs", StringComparison.OrdinalIgnoreCase))?.
				FirstOrDefault().Id;
			int weightUnitLbs = (int)systemOptionList?.
				Where(x => x.SysLookupCode.Equals("UnitWeight", StringComparison.OrdinalIgnoreCase))?.
				Where(y => y.SysOptionName.Equals("Lbs", StringComparison.OrdinalIgnoreCase))?.
				FirstOrDefault().Id;
			int volumeUnitFeet = (int)systemOptionList?.
				Where(x => x.SysLookupCode.Equals("UnitVolume", StringComparison.OrdinalIgnoreCase))?.
				Where(y => y.SysOptionName.Equals("Cubic Feet", StringComparison.OrdinalIgnoreCase))?.
				FirstOrDefault().Id;
			int volumeUnitMeters = (int)systemOptionList?.
			Where(x => x.SysLookupCode.Equals("UnitVolume", StringComparison.OrdinalIgnoreCase))?.
			Where(y => y.SysOptionName.Equals("Meters", StringComparison.OrdinalIgnoreCase))?.
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
				CgoWeightUnitsId = cargoitem.WeightUnitOfMeasure?.ToUpper() == "KGM" ? weightUnitKg : weightUnitLbs,
				CgoCubes = cargoitem.Volume.ToDecimal(),
				CgoVolumeUnitsId = cargoitem.VolumeUnitOfMeasure?.ToUpper() == "MTQ" ? volumeUnitMeters : volumeUnitFeet,
				CgoWeightUnitsIdName = cargoitem.WeightUnitOfMeasure?.ToUpper() == "KGM" ? "KGs" : "Lbs",
				CgoVolumeUnitsIdName = cargoitem.VolumeUnitOfMeasure?.ToUpper() == "MTQ" ? "Meters" : "Cubic Feet",
				CgoQtyOrdered = cargoitem.ShipQuantity <= 0 ? 1 : cargoitem.ShipQuantity,
				CgoQtyUnitsIdName = "EA",
				CgoQtyUnitsId = systemOptionList?.
				Where(x => x.SysLookupCode.Equals("CargoUnit", StringComparison.OrdinalIgnoreCase))?.
				Where(y => y.SysOptionName.Equals("Each", StringComparison.OrdinalIgnoreCase))?.
				FirstOrDefault().Id,
				CgoPackagingTypeId = cargoitem.MaterialType.Equals("ACCESSORY", StringComparison.OrdinalIgnoreCase) ? accessoryId
				: (cargoitem.MaterialType.Equals("SERVICES", StringComparison.OrdinalIgnoreCase) || cargoitem.MaterialType.Equals("SERVICE", StringComparison.OrdinalIgnoreCase))
				? serviceId : applienceId,
				StatusId = (int)Entities.StatusType.Active,
				CgoSerialBarcode = cargoitem?.LineDescriptionDetails?.LineDescription?.BillOfLadingIndicator,
				CgoLineNumber = cargoitem.LineNumber
			}));

			return jobCargos;
		}

		public List<JobCargo> ToJobCargoMapperFromFarEye(FarEyeOrderDetails farEyeOrderDetails, long jobId, List<SystemReference> systemOptionList)
		{
			if (farEyeOrderDetails.item_list == null)
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
			int weightUnitKg = (int)systemOptionList?.
				Where(x => x.SysLookupCode.Equals("UnitWeight", StringComparison.OrdinalIgnoreCase))?.
				Where(y => y.SysOptionName.Equals("KGs", StringComparison.OrdinalIgnoreCase))?.
				FirstOrDefault().Id;
			int weightUnitLbs = (int)systemOptionList?.
				Where(x => x.SysLookupCode.Equals("UnitWeight", StringComparison.OrdinalIgnoreCase))?.
				Where(y => y.SysOptionName.Equals("Lbs", StringComparison.OrdinalIgnoreCase))?.
				FirstOrDefault().Id;
			int volumeUnitFeet = (int)systemOptionList?.
				Where(x => x.SysLookupCode.Equals("UnitVolume", StringComparison.OrdinalIgnoreCase))?.
				Where(y => y.SysOptionName.Equals("Cubic Feet", StringComparison.OrdinalIgnoreCase))?.
				FirstOrDefault().Id;
			int volumeUnitMeters = (int)systemOptionList?.
			Where(x => x.SysLookupCode.Equals("UnitVolume", StringComparison.OrdinalIgnoreCase))?.
			Where(y => y.SysOptionName.Equals("Meters", StringComparison.OrdinalIgnoreCase))?.
			FirstOrDefault().Id;

			jobCargos.AddRange(farEyeOrderDetails.item_list.Select(cargoitem => new JobCargo
			{
				JobID = jobId,
				CgoLineItem = cargoitem.item_reference_number.ToInt(), //Nathan will ask to Electrolux,
				CgoPartNumCode = cargoitem.edc_material_id,
				CgoTitle = (!string.IsNullOrEmpty(cargoitem.item_material_descritpion) && cargoitem.item_material_descritpion.Contains(cargoitem.item_code)) ? cargoitem.item_material_descritpion.Replace(cargoitem.item_code, string.Empty) : cargoitem.item_material_descritpion,
				CgoSerialNumber = cargoitem.item_serial_number,
				CgoPackagingTypeIdName = cargoitem.item_material_type,
				CgoWeight = cargoitem.item_weight.ToDecimal(),
				CgoWeightUnitsId = cargoitem.item_weight_uom?.ToUpper() == "KGM" ? weightUnitKg : weightUnitLbs,
				CgoCubes = cargoitem.item_volumn.ToDecimal(),
				CgoVolumeUnitsId = cargoitem.item_volumn_uom?.ToUpper() == "MTQ" ? volumeUnitMeters : volumeUnitFeet,
				CgoWeightUnitsIdName = cargoitem.item_weight_uom?.ToUpper() == "KGM" ? "KGs" : "Lbs",
				CgoVolumeUnitsIdName = cargoitem.item_volumn_uom?.ToUpper() == "MTQ" ? "Meters" : "Cubic Feet",
				CgoQtyOrdered = cargoitem.item_quantity <= 0 ? 1 : cargoitem.item_quantity,
				CgoQtyUnitsIdName = "EA",
				CgoQtyUnitsId = systemOptionList?.
				Where(x => x.SysLookupCode.Equals("CargoUnit", StringComparison.OrdinalIgnoreCase))?.
				Where(y => y.SysOptionName.Equals("Each", StringComparison.OrdinalIgnoreCase))?.
				FirstOrDefault().Id,
				CgoPackagingTypeId = !string.IsNullOrEmpty(cargoitem.item_material_type) && cargoitem.item_material_type.Equals("ACCESSORY", StringComparison.OrdinalIgnoreCase) ? accessoryId
				: !string.IsNullOrEmpty(cargoitem.item_material_type) && (cargoitem.item_material_type.Equals("SERVICES", StringComparison.OrdinalIgnoreCase) || cargoitem.item_material_type.Equals("SERVICE", StringComparison.OrdinalIgnoreCase))
				? serviceId : applienceId,
				StatusId = (int)Entities.StatusType.Active,
				CgoSerialBarcode = cargoitem.item_serial_number,
				CgoLineNumber = cargoitem.item_reference_number
			}));

			return jobCargos;
		}
	}
}