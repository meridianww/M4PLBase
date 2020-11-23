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
	/// <summary>
	/// Model class for AWC Driver Scrub Report Raw Data
	/// </summary>
	public class AWCDriverScrubReportRawData
	{
		/// <summary>
		/// Gets or Sets QMS Shipped On
		/// </summary>
		public string QMSShippedOn { get; set; }
		/// <summary>
		/// Gets or Sets QMS PS Disposition
		/// </summary>
		public string QMSPSDisposition { get; set; }
		/// <summary>
		/// Gets or Sets QMS Status Description
		/// </summary>
		public string QMSStatusDescription { get; set; }
		/// <summary>
		/// Gets or Sets Fourth Party
		/// </summary>
		public string FouthParty { get; set; }
		/// <summary>
		/// Gets or Sets Third Party
		/// </summary>
		public string ThirdParty { get; set; }
		/// <summary>
		/// Gets or Sets Actual ControlId
		/// </summary>
		public string ActualControlId { get; set; }
		/// <summary>
		/// Gets or Sets QM SControlId
		/// </summary>
		public string QMSControlId { get; set; }
		/// <summary>
		/// Gets or Sets QRC Grouping
		/// </summary>
		public string QRCGrouping { get; set; }
		/// <summary>
		/// Gets or Sets QRC Description
		/// </summary>
		public string QRCDescription { get; set; }
		/// <summary>
		/// Gets or Sets Product Category
		/// </summary>
		public string ProductCategory { get; set; }
		/// <summary>
		/// Gets or Sets Product SubCategory
		/// </summary>
		public string ProductSubCategory { get; set; }
		/// <summary>
		/// Gets or Sets Product SubCategory2
		/// </summary>
		public string ProductSubCategory2 { get; set; }
		/// <summary>
		/// Gets or Sets Model Name
		/// </summary>
		public string ModelName { get; set; }
		/// <summary>
		/// Gets or Sets Customer Business Type
		/// </summary>
		public string CustomerBusinessType { get; set; }
		/// <summary>
		/// Gets or Sets Channel CD
		/// </summary>
		public string ChannelCD { get; set; }
		/// <summary>
		/// Gets or Sets National Account Name
		/// </summary>
		public string NationalAccountName { get; set; }
		/// <summary>
		/// Gets or Sets Customer Name
		/// </summary>
		public string CustomerName { get; set; }
		/// <summary>
		/// Gets or Sets Ship From Location
		/// </summary>
		public string ShipFromLocation { get; set; }
		/// <summary>
		/// Gets or Sets QMS Remark
		/// </summary>
		public string QMSRemark { get; set; }
		/// <summary>
		/// Gets or Sets Days To Accept
		/// </summary>
		public string DaysToAccept { get; set; }
		/// <summary>
		/// Gets or Sets QMS Total Unit
		/// </summary>
		public string QMSTotalUnit { get; set; }
		/// <summary>
		/// Gets or Sets QMS Total Price
		/// </summary>
		public string QMSTotalPrice { get; set; }

	}
}
