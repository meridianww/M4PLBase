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
	public class AWCDriverScrubReportRawData
	{
		public string QMSShippedOn { get; set; }
		public string QMSPSDisposition { get; set; }
		public string QMSStatusDescription { get; set; }
		public string FouthParty { get; set; }
		public string ThirdParty { get; set; }
		public string ActualControlId { get; set; }
		public string QMSControlId { get; set; }
		public string QRCGrouping { get; set; }
		public string QRCDescription { get; set; }
		public string ProductCategory { get; set; }
		public string ProductSubCategory { get; set; }
		public string ProductSubCategory2 { get; set; }
		public string ModelName { get; set; }
		public string CustomerBusinessType { get; set; }
		public string ChannelCD { get; set; }
		public string NationalAccountName { get; set; }
		public string CustomerName { get; set; }
		public string ShipFromLocation { get; set; }
		public string QMSRemark { get; set; }
		public string DaysToAccept { get; set; }
		public string QMSTotalUnit { get; set; }
		public string QMSTotalPrice { get; set; }
	}
}
