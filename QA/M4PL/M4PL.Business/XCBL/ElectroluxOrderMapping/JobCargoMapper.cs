using M4PL.Entities.Administration;
using M4PL.Entities.Job;
using M4PL.Entities.XCBL.Electrolux.OrderRequest;
using M4PL.Utilities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Linq;

namespace M4PL.Business.XCBL.ElectroluxOrderMapping
{
    public class JobCargoMapper
    {
        public List<JobCargo> ToJobCargoMapper(IEnumerable<OrderLineDetail> orderLineDetail, long jobId)
        {
            if (orderLineDetail == null)
            {
                return null;
            }

            var jobCargos = new List<JobCargo>();
            jobCargos.AddRange(orderLineDetail.Select(cargoitem => new JobCargo
            {
                JobID = jobId,
                CgoLineItem = cargoitem.LineNumber.ToInt(), //Nathan will ask to Electrolux,
                CgoPartNumCode = cargoitem.ItemID,
                CgoTitle = (!string.IsNullOrEmpty(cargoitem.ItemDescription) && cargoitem.ItemDescription.Contains(cargoitem.ItemID)) ? cargoitem.ItemDescription.Replace(cargoitem.ItemID,string.Empty) : cargoitem.ItemDescription,
                CgoSerialNumber = cargoitem.SerialNumber,
                CgoPackagingTypeIdName = cargoitem.MaterialType,
                CgoWeight = cargoitem.Weight,
                CgoWeightUnitsIdName = cargoitem.WeightUnitOfMeasure?.ToUpper() == "KGM" ? "KG" : "LB",
                CgoCubes = cargoitem.Volume.ToDecimal(),
                CgoVolumeUnitsIdName = cargoitem.VolumeUnitOfMeasure?.ToUpper() == "MTQ" ? "Meters" : "Cubic Feet",
                CgoQtyOrdered = cargoitem.ShipQuantity,
                CgoQtyUnitsIdName = "EA",
				StatusId = (int)Entities.StatusType.Active
            }));

            return jobCargos;
        }
    }
}
