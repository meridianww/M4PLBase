/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=============================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Prashant Aggarwal
Date Programmed:                              10/04/2019
Program Name:                                 NavSalesOrderCommands
Purpose:                                      Contains commands to call DAL logic for M4PL.DAL.Finance.NavSalesOrderCommands
=============================================================================================================*/
using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using M4PL.Entities.Support;
using _commands = M4PL.DataAccess.Finance.NavSalesOrderCommand;
using M4PL.Business.Common;
using System.Linq;
using M4PL.Entities.Finance.ShippingItem;
using M4PL.Entities.Finance.JobOrderMapping;
using M4PL.Entities.Finance.SalesOrder;
using M4PL.Business.Finance.PurchaseOrder;

namespace M4PL.Business.Finance.SalesOrder
{
	public class NavSalesOrderCommands : BaseCommands<NavSalesOrder>, INavSalesOrderCommands
	{
		public string NavAPIUrl
		{
			get { return M4PBusinessContext.ComponentSettings.NavAPIUrl; }
		}

		public string NavAPIUserName
		{
			get { return M4PBusinessContext.ComponentSettings.NavAPIUserName; }
		}

		public string NavAPIPassword
		{
			get { return M4PBusinessContext.ComponentSettings.NavAPIPassword; }
		}

		public int Delete(long id)
		{
			throw new NotImplementedException();
		}

		public IList<IdRefLangName> Delete(List<long> ids, int statusId)
		{
			throw new NotImplementedException();
		}

		public IList<NavSalesOrder> Get()
		{
			throw new NotImplementedException();
		}

		public NavSalesOrder Get(long id)
		{
			throw new NotImplementedException();
		}

		public IList<NavSalesOrder> GetPagedData(PagedDataInfo pagedDataInfo)
		{
			throw new NotImplementedException();
		}

		public NavSalesOrder Patch(NavSalesOrder entity)
		{
			return StartOrderUpdationProcessForNAV(Convert.ToInt64(entity.M4PL_Job_ID), entity.No, entity.Quote_No, NavAPIUrl, NavAPIUserName, NavAPIPassword);
		}

		public NavSalesOrder Post(NavSalesOrder entity)
		{
			return StartOrderCreationProcessForNAV(Convert.ToInt64(entity.M4PL_Job_ID), NavAPIUrl, NavAPIUserName, NavAPIPassword);
		}

		public NavSalesOrder Put(NavSalesOrder entity)
		{
			throw new NotImplementedException();
		}

		public NavSalesOrder StartOrderCreationProcessForNAV(long jobId, string navAPIUrl, string navAPIUserName, string navAPIPassword)
		{
			string dimensionCode = string.Empty;
			string divisionCode = string.Empty;
			bool allLineItemsUpdated = true;
			string proFlag = null;
			NavSalesOrderRequest navSalesOrderRequest = _commands.GetSalesOrderCreationData(ActiveUser, jobId, Entities.EntitiesAlias.SalesOrder);
			if (navSalesOrderRequest == null) { return null; }
			var dimensions = CommonCommands.GetSalesOrderDimensionValues();
			if (dimensions != null && dimensions.NavSalesOrderDimensionValues != null && dimensions.NavSalesOrderDimensionValues.Count > 0)
			{
				divisionCode = dimensions.NavSalesOrderDimensionValues.Where(x => !string.IsNullOrEmpty(x.Dimension_Code) && x.Dimension_Code.ToUpper() == "DIVISIONS" && x.ERPId == navSalesOrderRequest.Sell_to_Customer_No).Any()
					? dimensions.NavSalesOrderDimensionValues.Where(x => !string.IsNullOrEmpty(x.Dimension_Code) && x.Dimension_Code.ToUpper() == "DIVISIONS" && x.ERPId == navSalesOrderRequest.Sell_to_Customer_No).FirstOrDefault().Map_to_IC_Dimension_Value_Code
					: string.Empty;

				if (!string.IsNullOrEmpty(navSalesOrderRequest.Ship_from_City) && !string.IsNullOrEmpty(navSalesOrderRequest.Ship_from_County))
				{
					string dimensionMatchCode = navSalesOrderRequest.Ship_from_City.Length >= 3 ? string.Format("{0}{1}", navSalesOrderRequest.Ship_from_City.Substring(0, 3), navSalesOrderRequest.Ship_from_County) : string.Empty;
					if (!string.IsNullOrEmpty(dimensionMatchCode))
					{
						dimensionCode = dimensions.NavSalesOrderDimensionValues.Where(codeMatch => !string.IsNullOrEmpty(codeMatch.Code) && codeMatch.Code.Length > 4 && codeMatch.Code.Substring(codeMatch.Code.Length - 5).ToUpper() == dimensionMatchCode.ToUpper()).Any() ? 
						dimensions.NavSalesOrderDimensionValues.Where(codeMatch => !string.IsNullOrEmpty(codeMatch.Code) && codeMatch.Code.Length > 4 && codeMatch.Code.Substring(codeMatch.Code.Length - 5).ToUpper() == dimensionMatchCode.ToUpper()).FirstOrDefault().Map_to_IC_Dimension_Value_Code : dimensionCode;
					}
				}
			}

			navSalesOrderRequest.Shortcut_Dimension_2_Code = dimensionCode;
			navSalesOrderRequest.Shortcut_Dimension_1_Code = divisionCode;
			NavSalesOrder navSalesOrderResponse = NavSalesOrderHelper.GenerateSalesOrderForNAV(ActiveUser, navSalesOrderRequest, navAPIUrl, navAPIUserName, navAPIPassword);
			if (navSalesOrderResponse != null && !string.IsNullOrWhiteSpace(navSalesOrderResponse.No))
			{
				_commands.UpdateJobOrderMapping(ActiveUser, jobId, navSalesOrderResponse.No, null);
				Task.Run(() => { UpdateSalesOrderItemDetails(jobId, navAPIUrl, navAPIUserName, navAPIPassword, dimensionCode, divisionCode, ref allLineItemsUpdated, ref proFlag); });
				Task.Run(() => { NavPurchaseOrderHelper.GeneratePurchaseOrderForNAV(ActiveUser, jobId, navAPIUrl, navAPIUserName, navAPIPassword, navSalesOrderResponse.No, dimensionCode, divisionCode); });
			}

			return navSalesOrderResponse;
		}

		public NavSalesOrder StartOrderUpdationProcessForNAV(long jobId, string soNumber, string poNumber, string navAPIUrl, string navAPIUserName, string navAPIPassword)
		{
			string dimensionCode = string.Empty;
			string divisionCode = string.Empty;
			bool allLineItemsUpdated = true;
			string proFlag = null;
			NavSalesOrderRequest navSalesOrderRequest = _commands.GetSalesOrderCreationData(ActiveUser, jobId, Entities.EntitiesAlias.SalesOrder);
			if (navSalesOrderRequest == null) { return null; }
			var dimensions = CommonCommands.GetSalesOrderDimensionValues();
			if (dimensions != null && dimensions.NavSalesOrderDimensionValues != null && dimensions.NavSalesOrderDimensionValues.Count > 0)
			{
				divisionCode = dimensions.NavSalesOrderDimensionValues.Where(x => !string.IsNullOrEmpty(x.Dimension_Code) && x.Dimension_Code.ToUpper() == "DIVISIONS" && x.ERPId == navSalesOrderRequest.Sell_to_Customer_No).Any()
					? dimensions.NavSalesOrderDimensionValues.Where(x => !string.IsNullOrEmpty(x.Dimension_Code) && x.Dimension_Code.ToUpper() == "DIVISIONS" && x.ERPId == navSalesOrderRequest.Sell_to_Customer_No).FirstOrDefault().Map_to_IC_Dimension_Value_Code
					: string.Empty;

				if (!string.IsNullOrEmpty(navSalesOrderRequest.Ship_from_City) && !string.IsNullOrEmpty(navSalesOrderRequest.Ship_from_County))
				{
					string dimensionMatchCode = navSalesOrderRequest.Ship_from_City.Length >= 3 ? string.Format("{0}{1}", navSalesOrderRequest.Ship_from_City.Substring(0, 3), navSalesOrderRequest.Ship_from_County) : string.Empty;
					if (!string.IsNullOrEmpty(dimensionMatchCode))
					{
						dimensionCode = dimensions.NavSalesOrderDimensionValues.Where(codeMatch => !string.IsNullOrEmpty(codeMatch.Code) && codeMatch.Code.Length > 4 && codeMatch.Code.Substring(codeMatch.Code.Length - 5).ToUpper() == dimensionMatchCode.ToUpper()).Any() ?
						dimensions.NavSalesOrderDimensionValues.Where(codeMatch => !string.IsNullOrEmpty(codeMatch.Code) && codeMatch.Code.Length > 4 && codeMatch.Code.Substring(codeMatch.Code.Length - 5).ToUpper() == dimensionMatchCode.ToUpper()).FirstOrDefault().Map_to_IC_Dimension_Value_Code : dimensionCode;
					}
				}
			}

			navSalesOrderRequest.Shortcut_Dimension_2_Code = dimensionCode;
			navSalesOrderRequest.Shortcut_Dimension_1_Code = divisionCode;
			NavSalesOrder navSalesOrderResponse = NavSalesOrderHelper.UpdateSalesOrderForNAV(ActiveUser, navSalesOrderRequest, navAPIUrl, navAPIUserName, navAPIPassword, soNumber);
			if (navSalesOrderResponse != null && !string.IsNullOrWhiteSpace(navSalesOrderResponse.No))
			{
				Task.Run(() => { UpdateSalesOrderItemDetails(jobId, navAPIUrl, navAPIUserName, navAPIPassword, dimensionCode, divisionCode, ref allLineItemsUpdated, ref proFlag); });

				Task.Run(() =>
				{
					if (string.IsNullOrEmpty(poNumber))
					{
						NavPurchaseOrderHelper.GeneratePurchaseOrderForNAV(ActiveUser, jobId, navAPIUrl, navAPIUserName, navAPIPassword, soNumber, dimensionCode, divisionCode);
					}
					else
					{
						NavPurchaseOrderHelper.UpdatePurchaseOrderForNAV(ActiveUser, jobId, poNumber, navAPIUrl, navAPIUserName, navAPIPassword, soNumber, dimensionCode, divisionCode);
					}
				});
			}

			return navSalesOrderResponse;
		}

		private void UpdateSalesOrderItemDetails(long jobId, string navAPIUrl, string navAPIUserName, string navAPIPassword, string dimensionCode, string divisionCode, ref bool allLineItemsUpdated, ref string proFlag)
		{
			List<NavSalesOrderItemRequest> navSalesOrderItemRequest = _commands.GetSalesOrderItemCreationData(ActiveUser, jobId, Entities.EntitiesAlias.ShippingItem);
			List<JobOrderItemMapping> jobOrderItemMapping = _commands.GetJobOrderItemMapping(jobId);
			NavSalesOrderItem navSalesOrderItemResponse = null;
			string deleteProFlag = null;
			bool allLineItemsDeleted = true;
			if (navSalesOrderItemRequest != null && navSalesOrderItemRequest.Count > 0)
			{
				bool isRecordUpdated = true;
				bool isRecordDeleted = true;
				if (jobOrderItemMapping != null && jobOrderItemMapping.Count > 0)
				{
					DeleteNAVSalesOrderItem(jobId, navAPIUrl, navAPIUserName, navAPIPassword, allLineItemsUpdated, navSalesOrderItemRequest, jobOrderItemMapping, ref deleteProFlag, ref allLineItemsDeleted, ref isRecordDeleted);
				}

				foreach (var navSalesOrderItemRequestItem in navSalesOrderItemRequest)
				{
					navSalesOrderItemRequestItem.Shortcut_Dimension_2_Code = dimensionCode;
					navSalesOrderItemRequestItem.Shortcut_Dimension_1_Code = divisionCode;
					if (jobOrderItemMapping != null && jobOrderItemMapping.Count > 0 && jobOrderItemMapping.Where(x => x.EntityName == Entities.EntitiesAlias.ShippingItem.ToString() && x.LineNumber == navSalesOrderItemRequestItem.Line_No).Any())
					{
						NavSalesOrderHelper.UpdateSalesOrderItemForNAV(ActiveUser, navSalesOrderItemRequestItem, navAPIUrl, navAPIUserName, navAPIPassword, out isRecordUpdated);
					}
					else
					{
						navSalesOrderItemResponse = NavSalesOrderHelper.GenerateSalesOrderItemForNAV(ActiveUser, navSalesOrderItemRequestItem, navAPIUrl, navAPIUserName, navAPIPassword, out isRecordUpdated);
						if (navSalesOrderItemResponse != null)
						{
							_commands.UpdateJobOrderItemMapping(ActiveUser, jobId, Entities.EntitiesAlias.ShippingItem.ToString(), navSalesOrderItemRequestItem.Line_No);
						}
					}

					allLineItemsUpdated = !allLineItemsUpdated ? allLineItemsUpdated : isRecordUpdated;
					isRecordUpdated = true;
					navSalesOrderItemResponse = null;
				}

				proFlag = allLineItemsUpdated ? deleteProFlag : Entities.ProFlag.I.ToString();
				_commands.UpdateJobProFlag(ActiveUser, proFlag, jobId, Entities.EntitiesAlias.SalesOrder);
			}
		}

		private void DeleteNAVSalesOrderItem(long jobId, string navAPIUrl, string navAPIUserName, string navAPIPassword, bool allLineItemsUpdated, List<NavSalesOrderItemRequest> navSalesOrderItemRequest, List<JobOrderItemMapping> jobOrderItemMapping, ref string deleteProFlag, ref bool allLineItemsDeleted, ref bool isRecordDeleted)
		{
			var deletedItems = navSalesOrderItemRequest.Select(s => s.Line_No);
			IEnumerable<JobOrderItemMapping> deletedJobOrderItemMapping = jobOrderItemMapping.Where(t => t.EntityName == Entities.EntitiesAlias.ShippingItem.ToString() && !deletedItems.Contains(t.LineNumber));
			foreach (var deleteItem in deletedJobOrderItemMapping)
			{
				NavSalesOrderHelper.DeleteSalesOrderItemForNAV(navAPIUrl, navAPIUserName, navAPIPassword, navSalesOrderItemRequest.FirstOrDefault().Document_No, deleteItem.LineNumber, out isRecordDeleted);
				_commands.DeleteJobOrderItemMapping(ActiveUser, jobId, Entities.EntitiesAlias.ShippingItem.ToString(), deleteItem.LineNumber);
				jobOrderItemMapping.Remove(deleteItem);
				allLineItemsDeleted = !allLineItemsDeleted ? allLineItemsDeleted : isRecordDeleted;
			}

			deleteProFlag = allLineItemsUpdated ? deleteProFlag : Entities.ProFlag.D.ToString();
			_commands.UpdateJobProFlag(ActiveUser, deleteProFlag, jobId, Entities.EntitiesAlias.SalesOrder);
		}
	}
}
