using M4PL.Entities.XCBL.Electrolux.OrderRequest;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace M4PL.Business.XCBL.ElectroluxOrderMapping
{
	public class JobASNDataMapper
	{
		public Entities.Job.Job ToJobASNModel(OrderHeader orderHeader, ref Entities.Job.Job existingJobData)
		{
			if (orderHeader?.ASNdata == null) return existingJobData;
			var asnData = orderHeader.ASNdata;
			existingJobData.JobCarrierContract = asnData.VehicleId;
			existingJobData.JobBOL = asnData.BolNumber;
			existingJobData.JobShipmentDate = (!string.IsNullOrEmpty(asnData.Shipdate) && asnData.Shipdate.Length >= 8)
				? (DateTime?)Convert.ToDateTime(string.Format("{0}-{1}-{2}", asnData.Shipdate.Substring(0, 4), asnData.Shipdate.Substring(4, 2), asnData.Shipdate.Substring(6, 2)))
				: existingJobData.JobShipmentDate;

			return existingJobData;
		}

	}
}
