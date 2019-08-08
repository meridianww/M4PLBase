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
using M4PL.Entities.Administration;
using M4PL.Entities.Support;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;

namespace M4PL.DataAccess.Administration
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
				costCodeUTT.Columns.Add("SalesType");
				costCodeUTT.Columns.Add("SalesCode");
				costCodeUTT.Columns.Add("StartingDate");
				costCodeUTT.Columns.Add("CurrencyCode");
				costCodeUTT.Columns.Add("VariantCode");
				costCodeUTT.Columns.Add("MeasureCodeUnit");
				costCodeUTT.Columns.Add("MinimumQuantity");
				costCodeUTT.Columns.Add("SalesTypeFilter");
				costCodeUTT.Columns.Add("SalesCodeFilterCtrl");
				costCodeUTT.Columns.Add("ItemNoFilterCtrl");
				costCodeUTT.Columns.Add("StartingDateFilter");
				costCodeUTT.Columns.Add("SalesCodeFilterCtrl2");
				costCodeUTT.Columns.Add("GetFilterDescription");
				costCodeUTT.Columns.Add("UnitPrice");
				costCodeUTT.Columns.Add("EndingDate");
				costCodeUTT.Columns.Add("PriceIncludesVAT");
				costCodeUTT.Columns.Add("AllowLineDisc");
				costCodeUTT.Columns.Add("AllowInvoiceDisc");
				costCodeUTT.Columns.Add("VATBusPostingGrPrice");

				foreach (var custCode in navCostCodeList)
				{
					var row = costCodeUTT.NewRow();
					row["ItemId"] = custCode.Item_No;
					row["SalesType"] = custCode.Sales_Type;
					row["SalesCode"] = custCode.Sales_Code;
					row["StartingDate"] = custCode.Starting_Date;
					row["CurrencyCode"] = custCode.Currency_Code;
					row["VariantCode"] = custCode.Variant_Code;
					row["MeasureCodeUnit"] = custCode.Unit_of_Measure_Code;
					row["MinimumQuantity"] = custCode.Minimum_Quantity;
					row["SalesTypeFilter"] = custCode.SalesTypeFilter;
					row["SalesCodeFilterCtrl"] = custCode.SalesCodeFilterCtrl;
					row["ItemNoFilterCtrl"] = custCode.ItemNoFilterCtrl;
					row["StartingDateFilter"] = custCode.StartingDateFilter;
					row["SalesCodeFilterCtrl2"] = custCode.SalesCodeFilterCtrl2;
					row["GetFilterDescription"] = custCode.GetFilterDescription;
					row["UnitPrice"] = custCode.Unit_Price;
					row["EndingDate"] = custCode.Ending_Date;
					row["PriceIncludesVAT"] = custCode.Price_Includes_VAT;
					row["AllowLineDisc"] = custCode.Allow_Line_Disc;
					row["AllowInvoiceDisc"] = custCode.Allow_Invoice_Disc;
					row["VATBusPostingGrPrice"] = custCode.VAT_Bus_Posting_Gr_Price;
					costCodeUTT.Rows.Add(row);
					costCodeUTT.AcceptChanges();
				}

				return costCodeUTT;
			}
		}
	}
}
