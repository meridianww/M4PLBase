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
		/// <summary>
		/// Gets or Sets Program Id
		/// </summary>
		public long ProgramId { get; set; }
		/// <summary>
		/// Gets or Sets Location
		/// </summary>
		public string Location { get; set; }
		/// <summary>
		/// Gets or Sets Code
		/// </summary>
		public string Code { get; set; }
		/// <summary>
		/// Gets or Sets CustomerCode
		/// </summary>
		public string CustomerCode { get; set; }
		/// <summary>
		/// Gets or Sets VendorCode
		/// </summary>
		public string VendorCode { get; set; }
		/// <summary>
		/// Gets or Sets EffectiveDate
		/// </summary>
		public string EffectiveDate { get; set; }
		/// <summary>
		/// Gets or Sets Title
		/// </summary>
		public string Title { get; set; }
		/// <summary>
		/// Gets or Sets BillableElectronicInvoice
		/// </summary>
		public string BillableElectronicInvoice { get; set; }
		/// <summary>
		/// Gets or Sets CostElectronicInvoice
		/// </summary>
		public string CostElectronicInvoice { get; set; }

		/// <summary>
		/// Gets Or Sets Category
		/// </summary>
		public string Category { get; set; }

    }
}
