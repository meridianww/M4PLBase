#region Copyright

/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved.
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group.
******************************************************************************/

#endregion Copyright

using M4PL.DataAccess.SQLSerializer.Serializer;
using M4PL.Entities;
using M4PL.Entities.Administration;
using M4PL.Entities.Support;
using M4PL.Utilities;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;

namespace M4PL.DataAccess.Finance
{
	public class VendorProfileCommands
	{
		public static StatusModel ImportVendorProfile(List<Entities.Finance.VendorProfile.VendorProfile> vendorProfiles, ActiveUser activeUser)
		{
			StatusModel statusModel = null;
			try
			{
				SqlSerializer.Default.Execute(StoredProceduresConstant.ImportVendorProfile, new Parameter("@uttVendorProfile", GetVendorProfileListDT(vendorProfiles, activeUser)), true);
				statusModel = new StatusModel() { Status = "Success", AdditionalDetail = "", StatusCode = 200 };
			}
			catch (Exception exp)
			{
				Logger.ErrorLogger.Log(exp, "Error is occuring while importing the Vendor Profile Data.", "ImportVendorProfile", Utilities.Logger.LogType.Error);
				statusModel = new StatusModel() { Status = "Failure", StatusCode = 500, AdditionalDetail = exp.Message };
			}

			return statusModel;
		}

		private static DataTable GetVendorProfileListDT(List<Entities.Finance.VendorProfile.VendorProfile> vendorProfiles, ActiveUser activeUser)
		{
			if (vendorProfiles == null || (vendorProfiles != null && vendorProfiles.Count == 0))
			{
				throw new ArgumentNullException("vendorProfiles", "VendorProfileCommands.GetVendorProfileListDT() - Argument null Exception");
			}

			using (var vendorProfileUTT = new DataTable("uttVendorProfile"))
			{
				vendorProfileUTT.Locale = CultureInfo.InvariantCulture;
				vendorProfileUTT.Columns.Add("PostalCode");
				vendorProfileUTT.Columns.Add("Sunday");
				vendorProfileUTT.Columns.Add("Monday");
				vendorProfileUTT.Columns.Add("Tuesday");
				vendorProfileUTT.Columns.Add("Wednesday");
				vendorProfileUTT.Columns.Add("Thursday");
				vendorProfileUTT.Columns.Add("Friday");
				vendorProfileUTT.Columns.Add("Saturday");
				vendorProfileUTT.Columns.Add("FanRun");
				vendorProfileUTT.Columns.Add("VendorCode");
				vendorProfileUTT.Columns.Add("StatusId");
				vendorProfileUTT.Columns.Add("EnteredBy");
				vendorProfileUTT.Columns.Add("EnteredDate");
				if (vendorProfiles.Count > 0)
				{
					foreach (var vendorProfile in vendorProfiles)
					{
						var row = vendorProfileUTT.NewRow();
						row["PostalCode"] = vendorProfile.PostalCode;
						row["Sunday"] = vendorProfile.Sunday;
						row["Monday"] = vendorProfile.Monday;
						row["Tuesday"] = vendorProfile.Tuesday;
						row["Wednesday"] = vendorProfile.Wednesday;
						row["Thursday"] = vendorProfile.Thursday;
						row["Friday"] = vendorProfile.Friday;
						row["Saturday"] = vendorProfile.Saturday;
						row["FanRun"] = vendorProfile.FanRun;
						row["VendorCode"] = vendorProfile.VendorCode;
						row["StatusId"] = 1;
						row["EnteredBy"] = activeUser.UserName;
						row["EnteredDate"] = TimeUtility.GetPacificDateTime();
						vendorProfileUTT.Rows.Add(row);
						vendorProfileUTT.AcceptChanges();
					}
				}

				return vendorProfileUTT;
			}
		}
	}
}