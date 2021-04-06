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
using System.Threading.Tasks;

namespace M4PL.DataAccess.Finance
{
	public class VendorProfileCommands
	{
		public static StatusModel ImportVendorProfile(List<Entities.Finance.VendorProfile.VendorProfile> vendorProfiles, ActiveUser activeUser)
		{
			StatusModel statusModel = null;
			int? count = vendorProfiles?.Count;
			int startCount = 2000;
			List<Parameter> parameters = null;
			List<Task> tasks = new List<Task>();
			try
			{
				if (count.HasValue)
				{
					List<Entities.Finance.VendorProfile.VendorProfile> distinctVendorProfile = vendorProfiles.Distinct().ToList();
					int totalIterations = (distinctVendorProfile.Count.ToInt() / startCount) + 1;
					for (int i = 0; i < totalIterations; i++)
					{
						var currentRecords = distinctVendorProfile.Skip(i * startCount).Take(startCount).ToList();
						if (currentRecords != null && currentRecords.Count > 0)
						{
							if (i > 0)
							{
								tasks.Add(Task.Factory.StartNew(() =>
								{

									parameters = new List<Parameter> { new Parameter("@uttVendorProfile", GetVendorProfileListDT(currentRecords, activeUser)) };
									SqlSerializer.Default.Execute(StoredProceduresConstant.ImportVendorProfile, parameters.ToArray(), true);
								}));
							}
							else
                            {
								parameters = new List<Parameter> { 
									new Parameter("@uttVendorProfile", GetVendorProfileListDT(currentRecords, activeUser)), 
								    new Parameter("@isDataStatusUpdate", true) 
								};

								SqlSerializer.Default.Execute(StoredProceduresConstant.ImportVendorProfile, parameters.ToArray(), true);
							}
						}
					}

					if (tasks.Count > 0) { Task.WaitAll(tasks.ToArray()); }
				}

				statusModel = new StatusModel() { Status = "Success", AdditionalDetail = "", StatusCode = 200 };
			}
			catch (Exception exp)
			{
				Logger.ErrorLogger.Log(exp, "Error is occuring while importing the Vendor Profile Data.", "ImportVendorProfile", Utilities.Logger.LogType.Error);
				statusModel = new StatusModel() { Status = "Failure", StatusCode = 500, AdditionalDetail = exp.Message };
			}

			return statusModel;
		}

		public static Entities.Finance.VendorProfile.VendorProfileResponse GetVendorProfile(string locationCode, string postalCode)
		{
			Entities.Finance.VendorProfile.VendorProfileResponse vendorProfileResult = null;
			var parameters = new List<Parameter> { new Parameter("@locationCode", locationCode), new Parameter("@postalCode", postalCode) };
			try
			{
				vendorProfileResult = SqlSerializer.Default.DeserializeSingleRecord<Entities.Finance.VendorProfile.VendorProfileResponse>(StoredProceduresConstant.GetVendorProfile, parameters.ToArray(), false, true);
			}
			catch (Exception exp)
			{
				Logger.ErrorLogger.Log(exp, "Error is occuring while Getting the Vendor Profile Data.", "GetVendorProfile", Utilities.Logger.LogType.Error);
			}

			return vendorProfileResult;
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
						row["Sunday"] = vendorProfile.Sunday.ToBoolean();
						row["Monday"] = vendorProfile.Monday.ToBoolean();
						row["Tuesday"] = vendorProfile.Tuesday.ToBoolean();
						row["Wednesday"] = vendorProfile.Wednesday.ToBoolean();
						row["Thursday"] = vendorProfile.Thursday.ToBoolean();
						row["Friday"] = vendorProfile.Friday.ToBoolean();
						row["Saturday"] = vendorProfile.Saturday.ToBoolean();
						row["FanRun"] = vendorProfile.FanRun.ToBoolean();
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