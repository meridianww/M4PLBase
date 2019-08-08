/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=============================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Prashant Aggarwal
Date Programmed:                              08/01/2019
Program Name:                                 NavPriceCodeCommands
Purpose:                                      Contains commands to perform CRUD on NavPriceCode
=============================================================================================================*/
using M4PL.DataAccess.SQLSerializer.Serializer;
using M4PL.Entities.Administration;
using M4PL.Entities.Support;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;

namespace M4PL.DataAccess.Administration
{
	public class NavPriceCodeCommands : BaseCommands<NavPriceCode>
	{
		/// <summary>
		/// Updates the existing Cost Code record
		/// </summary>
		/// <param name="activeUser">activeUser</param>
		/// <param name="navPriceCodeList">navPriceCodeList</param>
		/// <returns></returns>
		public static NavPriceCode Put(ActiveUser activeUser, List<NavPriceCode> navPriceCodeList)
		{
			var parameters = GetParameters(navPriceCodeList, activeUser);
			return Put(activeUser, parameters, StoredProceduresConstant.UpdateNavPriceCode);
		}

		/// <summary>
		/// Gets list of parameters required for the Customer Module
		/// </summary>
		/// <param name="navPriceCodeList">navPriceCodeList</param>
		/// <returns></returns>
		private static List<Parameter> GetParameters(List<NavPriceCode> navPriceCodeList, ActiveUser activeUser)
		{
			var parameters = new List<Parameter>
		   {
				new Parameter("@uttNavPriceCode", GetPriceCodeDT(navPriceCodeList)),
				new Parameter("@changedBy", activeUser.UserName)
		   };

			return parameters;
		}

		/// <summary>
		/// GetCostCodeDT - Method to get GetPriceCodeDT in a datatable
		/// </summary>
		/// <param name="navPriceCodeList">navPriceCodeList</param>
		/// <returns>DataTable</returns>
		public static DataTable GetPriceCodeDT(List<NavPriceCode> navPriceCodeList)
		{
			if (navPriceCodeList == null)
			{
				throw new ArgumentNullException("CostCodeList", "NavCostCodeCommands.GetPriceCodeDT() - Argument null Exception");
			}

			using (var priceCodeUTT = new DataTable("uttNavPriceCode"))
			{
				priceCodeUTT.Locale = CultureInfo.InvariantCulture;
				priceCodeUTT.Columns.Add("ItemId");
				priceCodeUTT.Columns.Add("VendorNo");
				priceCodeUTT.Columns.Add("StartDate");
				priceCodeUTT.Columns.Add("CurrencyCode");
				priceCodeUTT.Columns.Add("VariantCode");
				priceCodeUTT.Columns.Add("MeasureCodeUnit");
				priceCodeUTT.Columns.Add("MinimumQuantity");
				priceCodeUTT.Columns.Add("VendNoFilterCtrl");
				priceCodeUTT.Columns.Add("ItemNoFIlterCtrl");
				priceCodeUTT.Columns.Add("StartingDateFilter");
				priceCodeUTT.Columns.Add("DirectUnitCost");
				priceCodeUTT.Columns.Add("EndingDate");

				foreach (var priceCode in navPriceCodeList)
				{
					var row = priceCodeUTT.NewRow();
					row["ItemId"] = priceCode.Item_No;
					row["VendorNo"] = priceCode.Vendor_No;
					row["StartDate"] = priceCode.Starting_Date;
					row["CurrencyCode"] = priceCode.Currency_Code;
					row["VariantCode"] = priceCode.Variant_Code;
					row["MeasureCodeUnit"] = priceCode.Unit_of_Measure_Code;
					row["MinimumQuantity"] = priceCode.Minimum_Quantity;
					row["VendNoFilterCtrl"] = priceCode.VendNoFilterCtrl;
					row["ItemNoFIlterCtrl"] = priceCode.ItemNoFIlterCtrl;
					row["StartingDateFilter"] = priceCode.StartingDateFilter;
					row["DirectUnitCost"] = priceCode.Direct_Unit_Cost;
					row["EndingDate"] = priceCode.Ending_Date;
					priceCodeUTT.Rows.Add(row);
					priceCodeUTT.AcceptChanges();
				}

				return priceCodeUTT;
			}
		}
	}
}
