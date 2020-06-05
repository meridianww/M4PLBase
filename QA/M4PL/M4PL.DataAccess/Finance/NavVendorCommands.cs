/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=============================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Prashant Aggarwal
Date Programmed:                              06/25/2019
Program Name:                                 NavVendorCommands
Purpose:                                      Contains commands to perform CRUD on NavVendor
=============================================================================================================*/

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
				new Parameter("@uttNavVendor", GetNavCustomerDT(vendor)),
				new Parameter("@changedBy", activeUser.UserName),
				new Parameter("@dateChanged", TimeUtility.GetPacificDateTime())
		   };

			return parameters;
		}

		/// <summary>
		/// GetNavCustomerDT - Method to get Vendor in a datatable
		/// </summary>
		/// <param name="vendorList">vendorList</param>
		/// <returns>DataTable</returns>
		public static DataTable GetNavCustomerDT(List<NavVendor> vendorList)
		{
			if (vendorList == null)
			{
				throw new ArgumentNullException("customer", "NavCustomerCommands.GetNavCustomerDT() - Argument null Exception");
			}

			using (var quoteRequestUTT = new DataTable("uttNavVendor"))
			{
				quoteRequestUTT.Locale = CultureInfo.InvariantCulture;
				quoteRequestUTT.Columns.Add("VendorId");
				quoteRequestUTT.Columns.Add("ERPId");

				foreach (var vendor in vendorList)
				{
					var row = quoteRequestUTT.NewRow();
					row["VendorId"] = vendor.M4PLVendorId;
					row["ERPId"] = string.IsNullOrEmpty(vendor.ERPId) ? null : vendor.ERPId;
					quoteRequestUTT.Rows.Add(row);
					quoteRequestUTT.AcceptChanges();
				}

				return quoteRequestUTT;
			}
		}
	}
}
