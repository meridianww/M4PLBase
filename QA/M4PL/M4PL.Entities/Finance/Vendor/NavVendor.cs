/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
==========================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Prashant Aggarwal
Date Programmed:                              06/25/2019
Program Name:                                 NavVendor
Purpose:                                      Contains objects related to NavVendor
==========================================================================================================*/
using System.Collections.Generic;

namespace M4PL.Entities.Finance.Vendor
{
	/// <summary>
	/// Class to Store Nav Vendor Data
	/// </summary>
	public class NavVendor : BaseModel
	{
		/// <summary>
		/// Gets Or Sets ERPId
		/// </summary>
		public string ERPId { get; set; }

		/// <summary>
		/// Gets Or Sets VendorName
		/// </summary>
		public string Name { get; set; }

		/// <summary>
		/// Gets Or Sets PBS_Vendor_Code
		/// </summary>
		public string PBS_Vendor_Code { get; set; }

		/// <summary>
		/// Gets Or Sets M4PLVendorId
		/// </summary>
		public long M4PLVendorId { get; set; }

		/// <summary>
		/// Gets Or Sets MatchedVendor
		/// </summary>
		public List<MatchedVendor> MatchedVendor { get; set; }

		/// <summary>
		/// Gets Or Sets IsAlreadyProcessed
		/// </summary>
		public bool IsAlreadyProcessed { get; set; }

		/// <summary>
		/// Gets or Sets StrRoute
		/// </summary>
		public string StrRoute { get; set; }
	}

	public class MatchedVendor
	{
		/// <summary>
		/// Gets Or Sets ERPId
		/// </summary>
		public string ERPId { get; set; }

		/// <summary>
		/// Gets Or Sets VendorName
		/// </summary>
		public string VendorName { get; set; }

		/// <summary>
		/// Gets Or Sets VendorCode
		/// </summary>
		public string VendorCode { get; set; }
	}
}
