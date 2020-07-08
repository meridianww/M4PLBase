#region Copyright
/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved. 
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group. 
******************************************************************************/
#endregion Copyright

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace M4PL.Entities.Job
{
	public class JobAdditionalInfo
	{
		public long CustomerERPId { get; set; }
		public long VendorERPId { get; set; }
		public string JobSONumber { get; set; }
		public string JobPONumber { get; set; }
		public string JobElectronicInvoiceSONumber { get; set; }
		public string JobElectronicInvoicePONumber { get; set; }
		public string JobDeliveryAnalystContactIDName { get; set; }
		public string JobDeliveryResponsibleContactIDName { get; set; }
		public string JobQtyUnitTypeIdName { get; set; }
		public string JobCubesUnitTypeIdName { get; set; }
		public string JobWeightUnitTypeIdName { get; set; }
		public string JobOriginResponsibleContactIDName { get; set; }
		public string JobDriverIdName { get; set; }
	}
}
