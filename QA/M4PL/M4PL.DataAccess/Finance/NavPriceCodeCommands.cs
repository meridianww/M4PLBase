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
// Date Programmed:                              08/01/2019
// Program Name:                                 NavPriceCodeCommands
// Purpose:                                      Contains commands to perform CRUD on NavPriceCode
//=============================================================================================================
using M4PL.DataAccess.SQLSerializer.Serializer;
using M4PL.Entities.Finance.PriceCode;
using M4PL.Entities.Support;
using M4PL.Utilities;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;

namespace M4PL.DataAccess.Finance
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
				new Parameter("@changedBy", activeUser.UserName),
				new Parameter("@dateChanged", TimeUtility.GetPacificDateTime())
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
				priceCodeUTT.Columns.Add("SalesType");
				priceCodeUTT.Columns.Add("SalesCode");
				priceCodeUTT.Columns.Add("StartingDate");
				priceCodeUTT.Columns.Add("CurrencyCode");
				priceCodeUTT.Columns.Add("VariantCode");
				priceCodeUTT.Columns.Add("MeasureCodeUnit");
				priceCodeUTT.Columns.Add("MinimumQuantity");
				priceCodeUTT.Columns.Add("SalesTypeFilter");
				priceCodeUTT.Columns.Add("SalesCodeFilterCtrl");
				priceCodeUTT.Columns.Add("ItemNoFilterCtrl");
				priceCodeUTT.Columns.Add("StartingDateFilter");
				priceCodeUTT.Columns.Add("SalesCodeFilterCtrl2");
				priceCodeUTT.Columns.Add("GetFilterDescription");
				priceCodeUTT.Columns.Add("UnitPrice");
				priceCodeUTT.Columns.Add("EndingDate");
				priceCodeUTT.Columns.Add("PriceIncludesVAT");
				priceCodeUTT.Columns.Add("AllowLineDisc");
				priceCodeUTT.Columns.Add("AllowInvoiceDisc");
				priceCodeUTT.Columns.Add("VATBusPostingGrPrice");

				foreach (var priceCode in navPriceCodeList)
				{
					var row = priceCodeUTT.NewRow();
					row["ItemId"] = priceCode.Item_No;
					row["SalesType"] = priceCode.Sales_Type;
					row["SalesCode"] = priceCode.Sales_Code;
					row["StartingDate"] = priceCode.Starting_Date;
					row["CurrencyCode"] = priceCode.Currency_Code;
					row["VariantCode"] = priceCode.Variant_Code;
					row["MeasureCodeUnit"] = priceCode.Unit_of_Measure_Code;
					row["MinimumQuantity"] = priceCode.Minimum_Quantity;
					row["SalesTypeFilter"] = priceCode.SalesTypeFilter;
					row["SalesCodeFilterCtrl"] = priceCode.SalesCodeFilterCtrl;
					row["ItemNoFilterCtrl"] = priceCode.ItemNoFilterCtrl;
					row["StartingDateFilter"] = priceCode.StartingDateFilter;
					row["SalesCodeFilterCtrl2"] = priceCode.SalesCodeFilterCtrl2;
					row["GetFilterDescription"] = priceCode.GetFilterDescription;
					row["UnitPrice"] = priceCode.Unit_Price;
					row["EndingDate"] = priceCode.Ending_Date;
					row["PriceIncludesVAT"] = priceCode.Price_Includes_VAT;
					row["AllowLineDisc"] = priceCode.Allow_Line_Disc;
					row["AllowInvoiceDisc"] = priceCode.Allow_Invoice_Disc;
					row["VATBusPostingGrPrice"] = priceCode.VAT_Bus_Posting_Gr_Price;
					priceCodeUTT.Rows.Add(row);
					priceCodeUTT.AcceptChanges();
				}

				return priceCodeUTT;
			}
		}
	}
}