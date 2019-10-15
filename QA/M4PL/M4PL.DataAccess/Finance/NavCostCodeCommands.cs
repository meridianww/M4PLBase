/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=============================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Prashant Aggarwal
Date Programmed:                              08/01/2019
Program Name:                                 NavCostCodeCommands
Purpose:                                      Contains commands to perform CRUD on NavCostCode
=============================================================================================================*/
using M4PL.DataAccess.SQLSerializer.Serializer;
using M4PL.Entities.Finance;
using M4PL.Entities.Support;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;

namespace M4PL.DataAccess.Finance
{
	public class NavCostCodeCommands : BaseCommands<NavCostCode>
	{
		/// <summary>
		/// Updates the existing Cost Code record
		/// </summary>
		/// <param name="activeUser">activeUser</param>
		/// <param name="navCostCodeList">navCostCodeList</param>
		/// <returns></returns>
		public static NavCostCode Put(ActiveUser activeUser, List<NavCostCode> navCostCodeList)
		{
			var parameters = GetParameters(navCostCodeList, activeUser);
			return Put(activeUser, parameters, StoredProceduresConstant.UpdateNavCostCode);
		}

		/// <summary>
		/// Gets list of parameters required for the Customer Module
		/// </summary>
		/// <param name="customer"></param>
		/// <returns></returns>
		private static List<Parameter> GetParameters(List<NavCostCode> navCostCodeList, ActiveUser activeUser)
		{
			var parameters = new List<Parameter>
		   {
				new Parameter("@uttNavCostCode", GetCostCodeDT(navCostCodeList)),
				new Parameter("@changedBy", activeUser.UserName)
		   };

			return parameters;
		}

		/// <summary>
		/// GetCostCodeDT - Method to get CostCode in a datatable
		/// </summary>
		/// <param name="navCostCodeList">navCostCodeList</param>
		/// <returns>DataTable</returns>
		public static DataTable GetCostCodeDT(List<NavCostCode> navCostCodeList)
		{
			if (navCostCodeList == null)
			{
				throw new ArgumentNullException("CostCodeList", "NavCostCodeCommands.GetCostCodeDT() - Argument null Exception");
			}

			using (var costCodeUTT = new DataTable("uttNavCostCode"))
			{
				costCodeUTT.Locale = CultureInfo.InvariantCulture;
				costCodeUTT.Columns.Add("ItemId");
				costCodeUTT.Columns.Add("VendorNo");
				costCodeUTT.Columns.Add("StartDate");
				costCodeUTT.Columns.Add("CurrencyCode");
				costCodeUTT.Columns.Add("VariantCode");
				costCodeUTT.Columns.Add("MeasureCodeUnit");
				costCodeUTT.Columns.Add("MinimumQuantity");
				costCodeUTT.Columns.Add("VendNoFilterCtrl");
				costCodeUTT.Columns.Add("ItemNoFIlterCtrl");
				costCodeUTT.Columns.Add("StartingDateFilter");
				costCodeUTT.Columns.Add("DirectUnitCost");
				costCodeUTT.Columns.Add("EndingDate");

				foreach (var custCode in navCostCodeList)
				{
					var row = costCodeUTT.NewRow();
					row["ItemId"] = custCode.Item_No;
					row["VendorNo"] = custCode.Vendor_No;
					row["StartDate"] = custCode.Starting_Date;
					row["CurrencyCode"] = custCode.Currency_Code;
					row["VariantCode"] = custCode.Variant_Code;
					row["MeasureCodeUnit"] = custCode.Unit_of_Measure_Code;
					row["MinimumQuantity"] = custCode.Minimum_Quantity;
					row["VendNoFilterCtrl"] = custCode.VendNoFilterCtrl;
					row["ItemNoFIlterCtrl"] = custCode.ItemNoFIlterCtrl;
					row["StartingDateFilter"] = custCode.StartingDateFilter;
					row["DirectUnitCost"] = custCode.Direct_Unit_Cost;
					row["EndingDate"] = custCode.Ending_Date;
					costCodeUTT.Rows.Add(row);
					costCodeUTT.AcceptChanges();
				}

				return costCodeUTT;
			}
		}
	}
}
