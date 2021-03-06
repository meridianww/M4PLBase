﻿#region Copyright

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
// Program Name:                                 NavCustomerCommands
// Purpose:                                      Contains commands to perform CRUD on NavCustomer
//=============================================================================================================

using M4PL.DataAccess.SQLSerializer.Serializer;
using M4PL.Entities.Finance.Customer;
using M4PL.Entities.Support;
using M4PL.Utilities;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;

namespace M4PL.DataAccess.Finance
{
	public class NavCustomerCommands : BaseCommands<NavCustomer>
	{
		/// <summary>
		/// Updates the existing Customer record
		/// </summary>
		/// <param name="activeUser"></param>
		/// <param name="customer"></param>
		/// <returns></returns>
		public static NavCustomer Put(ActiveUser activeUser, List<NavCustomer> navCustomer)
		{
			var parameters = GetParameters(navCustomer, activeUser);
			return Put(activeUser, parameters, StoredProceduresConstant.UpdateERPIdCustomer);
		}

		/// <summary>
		/// Gets list of parameters required for the Customer Module
		/// </summary>
		/// <param name="customer"></param>
		/// <returns></returns>

		private static List<Parameter> GetParameters(List<NavCustomer> customer, ActiveUser activeUser)
		{
			var parameters = new List<Parameter>
		   {
				new Parameter("@uttNavCustomer", GetNavCustomerDT(customer)),
				new Parameter("@changedBy", activeUser.UserName),
				new Parameter("@dateChanged", TimeUtility.GetPacificDateTime())
		   };

			return parameters;
		}

		public static DataTable GetNavCustomerDT(List<NavCustomer> customerList)
		{
			if (customerList == null)
			{
				throw new ArgumentNullException("customer", "NavCustomerCommands.GetNavCustomerDT() - Argument null Exception");
			}

			using (var uttNavCustomerUTT = new DataTable("uttNavCustomer"))
			{
				uttNavCustomerUTT.Locale = CultureInfo.InvariantCulture;
				uttNavCustomerUTT.Columns.Add("CustomerId");
				uttNavCustomerUTT.Columns.Add("ERPId");
				uttNavCustomerUTT.Columns.Add("DivisonCode");

				foreach (var customer in customerList)
				{
					var row = uttNavCustomerUTT.NewRow();
					row["CustomerId"] = customer.M4PLCustomerId;
					row["ERPId"] = string.IsNullOrEmpty(customer.ERPId) ? null : customer.ERPId;
					row["DivisonCode"] = string.IsNullOrEmpty(customer.DivisonCode) ? null : customer.DivisonCode;
					uttNavCustomerUTT.Rows.Add(row);
					uttNavCustomerUTT.AcceptChanges();
				}

				return uttNavCustomerUTT;
			}
		}
	}
}