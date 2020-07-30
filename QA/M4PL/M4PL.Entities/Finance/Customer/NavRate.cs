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

namespace M4PL.Entities.Finance.Customer
{
	public class NavRate : BaseModel
	{
		public long ProgramId { get; set; }
		public string Location { get; set; }
		public string Code { get; set; }
		public string CustomerCode { get; set; }
		public string VendorCode { get; set; }
		public string EffectiveDate { get; set; }
		public string Title { get; set; }
		////public string BillablePrice { get; set; }
		////public string CostRate { get; set; }
		public string BillableElectronicInvoice { get; set; }
		public string CostElectronicInvoice { get; set; }
	}
}
