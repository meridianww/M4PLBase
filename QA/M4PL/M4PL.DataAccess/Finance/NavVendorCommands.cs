#region Copyright

/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved.
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group.
******************************************************************************/

#endregion Copyright

//=============================================================================================================
// Program Title:                                Meridian 4th Party Logistics(M4PL)
// Programmer:                                   Prashant Aggarwal
// Date Programmed:                              06/25/2019
// Program Name:                                 NavVendorCommands
// Purpose:                                      Contains commands to perform CRUD on NavVendor
//=============================================================================================================

using M4PL.DataAccess.SQLSerializer.Serializer;
using M4PL.Entities.Finance.Vendor;
using M4PL.Entities.Support;
using M4PL.Utilities;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;

namespace M4PL.DataAccess.Finance
{
	public class NavVendorCommands : BaseCommands<NavVendor>
	{
		/// <summary>
		/// Updates the existing Vendor record
		/// </summary>
		/// <param name="activeUser">activeUser</param>
		/// <param name="navVendor">navVendor</param>
		/// <returns></returns>
		public static NavVendor Put(ActiveUser activeUser, List<NavVendor> navVendor)
		{
			var parameters = GetParameters(navVendor, activeUser);
			return Put(activeUser, parameters, StoredProceduresConstant.UpdateERPIdVendor);
		}

		/// <summary>
		/// Gets list of parameters required for the Vendor Module
		/// </summary>
		/// <param name="vendor"></param>
		/// <param name="activeUser">activeUser</param>
		/// <returns></returns>
		private static List<Parameter> GetParameters(List<NavVendor> vendor, ActiveUser activeUser)
		{
			var parameters = new List<Parameter>
		   {
				new Parameter("@uttNavVendor", GetNavVendorDT(vendor)),
				new Parameter("@changedBy", activeUser.UserName),
				new Parameter("@dateChanged", TimeUtility.GetPacificDateTime())
		   };

			return parameters;
		}

		public static DataTable GetNavVendorDT(List<NavVendor> vendorList)
		{
			if (vendorList == null)
			{
				throw new ArgumentNullException("customer", "NavVendorCommands.GetNavVendorDT() - Argument null Exception");
			}

			using (var uttNavVendor = new DataTable("uttNavVendor"))
			{
				uttNavVendor.Locale = CultureInfo.InvariantCulture;
				uttNavVendor.Columns.Add("VendorId");
				uttNavVendor.Columns.Add("ERPId");

				foreach (var vendor in vendorList)
				{
					var row = uttNavVendor.NewRow();
					row["VendorId"] = vendor.M4PLVendorId;
					row["ERPId"] = string.IsNullOrEmpty(vendor.ERPId) ? null : vendor.ERPId;
					uttNavVendor.Rows.Add(row);
					uttNavVendor.AcceptChanges();
				}

				return uttNavVendor;
			}
		}
	}
}