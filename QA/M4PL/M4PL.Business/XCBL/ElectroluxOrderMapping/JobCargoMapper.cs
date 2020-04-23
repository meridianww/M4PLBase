using M4PL.Entities.Job;
using M4PL.Entities.XCBL.Electrolux.OrderRequest;
using M4PL.Utilities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace M4PL.Business.XCBL.ElectroluxOrderMapping
{
    public class JobCargoMapper
    {
        public List<JobCargo> ToJobCargoMapper(IEnumerable<OrderLineDetail> orderLineDetail)
        {
            if (orderLineDetail == null)
            {
                return null;
            }

            var jobCargos = new List<JobCargo>();

            jobCargos.AddRange(orderLineDetail.Select(cargoitem => new JobCargo
            {
                CgoLineItem = cargoitem.LineNumber.ToInt(), //Nathan will ask to Electrolux,
                CgoPartNumCode = cargoitem.ItemID,
                CgoTitle = cargoitem.ItemDescription,
                CgoSerialNumber = cargoitem.SerialNumber,
                CgoWeight = cargoitem.Weight,
                CgoCubes = cargoitem.Volume.ToDecimal(),
                CgoQtyOrdered = cargoitem.ShipQuantity
            }));

            return jobCargos;
        }
    }
}
