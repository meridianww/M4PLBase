#region Copyright

/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved.
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group.
******************************************************************************/

#endregion Copyright

using M4PL.Entities.XCBL.Electrolux.OrderRequest;
using M4PL.Utilities;

namespace M4PL.Business.XCBL.ElectroluxOrderMapping
{
	public class JobASNDataMapper
	{
		public Entities.Job.Job ToJobASNModel(OrderHeader orderHeader, ref Entities.Job.Job existingJobData)
		{
			if (orderHeader?.ASNdata == null) return existingJobData;
			var asnData = orderHeader.ASNdata;
			existingJobData.CarrierID = asnData.VehicleId;
			existingJobData.JobBOL = asnData.BolNumber;
			existingJobData.JobManifestNo = asnData.BolNumber;
			existingJobData.ProFlags12 = "S";
			existingJobData.JobShipmentDate = (!string.IsNullOrEmpty(asnData.Shipdate) && asnData.Shipdate.Length >= 8)
				? string.Format(format: "{0}-{1}-{2}", arg0: asnData.Shipdate.Substring(0, 4), arg1: asnData.Shipdate.Substring(4, 2), arg2: asnData.Shipdate.Substring(6, 2)).ToDate()
				: existingJobData.JobShipmentDate;

			return existingJobData;
		}
	}
}