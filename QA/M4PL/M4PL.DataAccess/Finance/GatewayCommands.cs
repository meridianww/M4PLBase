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
using M4PL.Entities.Support;
using M4PL.Utilities;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;

namespace M4PL.DataAccess.Finance
{
	public class GatewayCommands
	{
		public static StatusModel GenerateProgramGateway(List<Entities.Finance.Customer.Gateway> gatewayList, ActiveUser activeUser)
		{
			StatusModel statusModel = null;
			try
			{
				var parameters = new List<Parameter>
		   {
				new Parameter("@uttGateway", GetGatewayListDT(gatewayList)),
				new Parameter("@programId", gatewayList.First().ProgramId),
				new Parameter("@changedBy", activeUser.UserName),
				new Parameter("@dateChanged", TimeUtility.GetPacificDateTime())
		   };

				SqlSerializer.Default.Execute(StoredProceduresConstant.ImportGatewayActionForProgram, parameters.ToArray(), true);
				statusModel = new StatusModel() { Status = "Success", AdditionalDetail = "", StatusCode = 200 };
			}
			catch (Exception exp)
			{
				Logger.ErrorLogger.Log(exp, "Error is occuring while importing the Gateway/Action Data.", "GenerateProgramGateway", Utilities.Logger.LogType.Error);
				statusModel = new StatusModel() { Status = "Failure", StatusCode = 500, AdditionalDetail = exp.Message };
			}

			return statusModel;
		}

		private static DataTable GetGatewayListDT(List<Entities.Finance.Customer.Gateway> gatewayList)
		{
			if (gatewayList == null || (gatewayList != null && gatewayList.Count == 0))
			{
				throw new ArgumentNullException("navRateList", "GatewayCommands.GetGatewayListDT() - Argument null Exception");
			}

			var distinctgateways = gatewayList.Distinct().ToList();
			using (var gatewayUTT = new DataTable("uttGateway"))
			{
				gatewayUTT.Locale = CultureInfo.InvariantCulture;
				gatewayUTT.Columns.Add("Code");
				gatewayUTT.Columns.Add("Title");
				gatewayUTT.Columns.Add("Units");
				gatewayUTT.Columns.Add("Default");
				gatewayUTT.Columns.Add("Type");
				gatewayUTT.Columns.Add("DateReference");
				gatewayUTT.Columns.Add("StatusReasonCode");
				gatewayUTT.Columns.Add("AppointmentReasonCode");
				gatewayUTT.Columns.Add("OrderType");
				gatewayUTT.Columns.Add("ShipmenType");
				gatewayUTT.Columns.Add("GatewayStatusCode");
				gatewayUTT.Columns.Add("NextGateway");
				gatewayUTT.Columns.Add("IsDefaultComplete");
				gatewayUTT.Columns.Add("InstallStatus");
				gatewayUTT.Columns.Add("TransitionStatus");
				gatewayUTT.Columns.Add("IsStartGateway");
				if (distinctgateways.Count > 0)
				{
					foreach (var currentGateway in distinctgateways)
					{
						var row = gatewayUTT.NewRow();
						row["Code"] = currentGateway.Code;
						row["Title"] = currentGateway.Title;
						row["Units"] = currentGateway.Units;
						row["Default"] = currentGateway.Default.ToBoolean();
						row["Type"] = currentGateway.Type;
						row["DateReference"] = currentGateway.DateReference;
						row["StatusReasonCode"] = currentGateway.StatusReasonCode;
						row["AppointmentReasonCode"] = currentGateway.AppointmentReasonCode;
						row["OrderType"] = currentGateway.OrderType;
						row["ShipmenType"] = currentGateway.ShipmenType;
						row["GatewayStatusCode"] = currentGateway.GatewayStatusCode;
						row["NextGateway"] = currentGateway.NextGateway;
						row["IsDefaultComplete"] = currentGateway.IsDefaultComplete.ToBoolean();
						row["InstallStatus"] = currentGateway.InstallStatus;
						row["TransitionStatus"] = currentGateway.TransitionStatus;
						row["IsStartGateway"] = currentGateway.IsStartGateway.ToBoolean();
						gatewayUTT.Rows.Add(row);
						gatewayUTT.AcceptChanges();
					}
				}

				return gatewayUTT;
			}
		}
	}
}
