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
			List<long> jobIdList = new List<long>();
			jobIdList.Add(Convert.ToInt64(entity.M4PL_Job_ID));
			return StartOrderUpdationProcessForNAV(jobIdList, entity.No, entity.Quote_No, NavAPIUrl, NavAPIUserName, NavAPIPassword, entity.VendorNo);
		}

		public NavSalesOrder Post(NavSalesOrder entity)
		{
			List<long> jobIdList = new List<long>();
			jobIdList.Add(Convert.ToInt64(entity.M4PL_Job_ID));
			return StartOrderCreationProcessForNAV(jobIdList, NavAPIUrl, NavAPIUserName, NavAPIPassword, entity.VendorNo);
		}

		public NavSalesOrder Put(NavSalesOrder entity)
		{
			throw new NotImplementedException();
		}

		public NavSalesOrder StartOrderCreationProcessForNAV(List<long> jobIdList, string navAPIUrl, string navAPIUserName, string navAPIPassword, long vendorNo)
		{
			string dimensionCode = string.Empty;
			string divisionCode = string.Empty;
			bool allLineItemsUpdated = true;
			string proFlag = null;
			NavSalesOrderRequest navSalesOrderRequest = _commands.GetSalesOrderCreationData(ActiveUser, jobIdList, Entities.EntitiesAlias.SalesOrder);
			if (navSalesOrderRequest == null) { return null; }
			var dimensions = CommonCommands.GetSalesOrderDimensionValues();
			if (dimensions != null && dimensions.NavSalesOrderDimensionValues != null && dimensions.NavSalesOrderDimensionValues.Count > 0)
			{
				divisionCode = dimensions.NavSalesOrderDimensionValues.Where(x => !string.IsNullOrEmpty(x.Dimension_Code) && x.Dimension_Code.ToUpper() == "DIVISIONS" && x.ERPId == navSalesOrderRequest.Sell_to_Customer_No).Any()
					? dimensions.NavSalesOrderDimensionValues.Where(x => !string.IsNullOrEmpty(x.Dimension_Code) && x.Dimension_Code.ToUpper() == "DIVISIONS" && x.ERPId == navSalesOrderRequest.Sell_to_Customer_No).FirstOrDefault().Code
					: string.Empty;

				if (!string.IsNullOrEmpty(navSalesOrderRequest.Ship_from_City) && !string.IsNullOrEmpty(navSalesOrderRequest.Ship_from_County))
				{
					string dimensionMatchCode = navSalesOrderRequest.Ship_from_City.Length >= 3 ? string.Format("{0}{1}", navSalesOrderRequest.Ship_from_City.Substring(0, 3), navSalesOrderRequest.Ship_from_County) : string.Empty;
					if (!string.IsNullOrEmpty(dimensionMatchCode))
					{
						dimensionCode = dimensions.NavSalesOrderDimensionValues.Where(codeMatch => !string.IsNullOrEmpty(codeMatch.Code) && codeMatch.Code.Length > 4 && codeMatch.Code.Substring(codeMatch.Code.Length - 5).ToUpper() == dimensionMatchCode.ToUpper()).Any() ? 
						dimensions.NavSalesOrderDimensionValues.Where(codeMatch => !string.IsNullOrEmpty(codeMatch.Code) && codeMatch.Code.Length > 4 && codeMatch.Code.Substring(codeMatch.Code.Length - 5).ToUpper() == dimensionMatchCode.ToUpper()).FirstOrDefault().Code : dimensionCode;
					}
				}
			}

			navSalesOrderRequest.Shortcut_Dimension_2_Code = dimensionCode;
			navSalesOrderRequest.Shortcut_Dimension_1_Code = divisionCode;
			NavSalesOrder navSalesOrderResponse = NavSalesOrderHelper.GenerateSalesOrderForNAV(ActiveUser, navSalesOrderRequest, navAPIUrl, navAPIUserName, navAPIPassword);
			if (navSalesOrderResponse != null && !string.IsNullOrWhiteSpace(navSalesOrderResponse.No))
			{
				_commands.UpdateJobOrderMapping(ActiveUser, jobIdList, navSalesOrderResponse.No, null);
				Task.Run(() => { UpdateSalesOrderItemDetails(jobIdList, navAPIUrl, navAPIUserName, navAPIPassword, dimensionCode, divisionCode, navSalesOrderResponse.No, ref allLineItemsUpdated, ref proFlag); });
				if (vendorNo > 0)
				{
					Task.Run(() => { NavPurchaseOrderHelper.GeneratePurchaseOrderForNAV(ActiveUser, jobIdList, navAPIUrl, navAPIUserName, navAPIPassword, navSalesOrderResponse.No, dimensionCode, divisionCode); });
				}
			}

			return navSalesOrderResponse;
		}

		public NavSalesOrder StartOrderUpdationProcessForNAV(List<long> jobIdList, string soNumber, string poNumber, string navAPIUrl, string navAPIUserName, string navAPIPassword, long vendorNo)
		{
			string dimensionCode = string.Empty;
			string divisionCode = string.Empty;
			bool allLineItemsUpdated = true;
			string proFlag = null;
			NavSalesOrderRequest navSalesOrderRequest = _commands.GetSalesOrderCreationData(ActiveUser, jobIdList, Entities.EntitiesAlias.SalesOrder);
			if (navSalesOrderRequest == null) { return null; }
			var dimensions = CommonCommands.GetSalesOrderDimensionValues();
			if (dimensions != null && dimensions.NavSalesOrderDimensionValues != null && dimensions.NavSalesOrderDimensionValues.Count > 0)
			{
				divisionCode = dimensions.NavSalesOrderDimensionValues.Where(x => !string.IsNullOrEmpty(x.Dimension_Code) && x.Dimension_Code.ToUpper() == "DIVISIONS" && x.ERPId == navSalesOrderRequest.Sell_to_Customer_No).Any()
					? dimensions.NavSalesOrderDimensionValues.Where(x => !string.IsNullOrEmpty(x.Dimension_Code) && x.Dimension_Code.ToUpper() == "DIVISIONS" && x.ERPId == navSalesOrderRequest.Sell_to_Customer_No).FirstOrDefault().Code
					: string.Empty;

				if (!string.IsNullOrEmpty(navSalesOrderRequest.Ship_from_City) && !string.IsNullOrEmpty(navSalesOrderRequest.Ship_from_County))
				{
					string dimensionMatchCode = navSalesOrderRequest.Ship_from_City.Length >= 3 ? string.Format("{0}{1}", navSalesOrderRequest.Ship_from_City.Substring(0, 3), navSalesOrderRequest.Ship_from_County) : string.Empty;
					if (!string.IsNullOrEmpty(dimensionMatchCode))
					{
						dimensionCode = dimensions.NavSalesOrderDimensionValues.Where(codeMatch => !string.IsNullOrEmpty(codeMatch.Code) && codeMatch.Code.Length > 4 && codeMatch.Code.Substring(codeMatch.Code.Length - 5).ToUpper() == dimensionMatchCode.ToUpper()).Any() ?
						dimensions.NavSalesOrderDimensionValues.Where(codeMatch => !string.IsNullOrEmpty(codeMatch.Code) && codeMatch.Code.Length > 4 && codeMatch.Code.Substring(codeMatch.Code.Length - 5).ToUpper() == dimensionMatchCode.ToUpper()).FirstOrDefault().Code : dimensionCode;
					}
				}
			}

			navSalesOrderRequest.Shortcut_Dimension_2_Code = dimensionCode;
			navSalesOrderRequest.Shortcut_Dimension_1_Code = divisionCode;
			NavSalesOrder navSalesOrderResponse = NavSalesOrderHelper.UpdateSalesOrderForNAV(ActiveUser, navSalesOrderRequest, navAPIUrl, navAPIUserName, navAPIPassword, soNumber);
			if (navSalesOrderResponse != null && !string.IsNullOrWhiteSpace(navSalesOrderResponse.No))
			{
				Task.Run(() => { UpdateSalesOrderItemDetails(jobIdList, navAPIUrl, navAPIUserName, navAPIPassword, dimensionCode, divisionCode, navSalesOrderResponse.No, ref allLineItemsUpdated, ref proFlag); });
				if (vendorNo > 0)
				{
					Task.Run(() =>
					{
						if (string.IsNullOrEmpty(poNumber))
						{

							NavPurchaseOrderHelper.GeneratePurchaseOrderForNAV(ActiveUser, jobIdList, navAPIUrl, navAPIUserName, navAPIPassword, soNumber, dimensionCode, divisionCode);
						}
						else
						{
							NavPurchaseOrderHelper.UpdatePurchaseOrderForNAV(ActiveUser, jobIdList, poNumber, navAPIUrl, navAPIUserName, navAPIPassword, soNumber, dimensionCode, divisionCode);
						}
					});
				}
			}

			return navSalesOrderResponse;
		}

		private void UpdateSalesOrderItemDetails(List<long> jobIdList, string navAPIUrl, string navAPIUserName, string navAPIPassword, string dimensionCode, string divisionCode, string soNumber, ref bool allLineItemsUpdated, ref string proFlag)
		{
			List<NavSalesOrderItemRequest> navSalesOrderItemRequest = _commands.GetSalesOrderItemCreationData(ActiveUser, jobIdList, Entities.EntitiesAlias.ShippingItem);
			List<JobOrderItemMapping> jobOrderItemMapping = _commands.GetJobOrderItemMapping(jobIdList);
			NavSalesOrderItem navSalesOrderItemResponse = null;
			string deleteProFlag = null;
			bool allLineItemsDeleted = true;
			bool isRecordUpdated = true;
			bool isRecordDeleted = true;
			if (jobOrderItemMapping != null && jobOrderItemMapping.Count > 0)
			{
				DeleteNAVSalesOrderItem(jobIdList, navAPIUrl, navAPIUserName, navAPIPassword, allLineItemsUpdated, navSalesOrderItemRequest, jobOrderItemMapping, soNumber, ref deleteProFlag, ref allLineItemsDeleted, ref isRecordDeleted);
			}

			if (navSalesOrderItemRequest != null && navSalesOrderItemRequest.Count > 0)
			{
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
							_commands.UpdateJobOrderItemMapping(navSalesOrderItemRequestItem.M4PLItemId, ActiveUser, jobIdList, Entities.EntitiesAlias.ShippingItem.ToString(), navSalesOrderItemRequestItem.Line_No);
						}
					}

					allLineItemsUpdated = !allLineItemsUpdated ? allLineItemsUpdated : isRecordUpdated;
					isRecordUpdated = true;
					navSalesOrderItemResponse = null;
				}

				proFlag = allLineItemsUpdated ? deleteProFlag : Entities.ProFlag.I.ToString();
				_commands.UpdateJobProFlag(ActiveUser, proFlag, jobIdList, Entities.EntitiesAlias.SalesOrder);
			}
		}

		private void DeleteNAVSalesOrderItem(List<long> jobIdList, string navAPIUrl, string navAPIUserName, string navAPIPassword, bool allLineItemsUpdated, List<NavSalesOrderItemRequest> navSalesOrderItemRequest, List<JobOrderItemMapping> jobOrderItemMapping, string soNumber, ref string deleteProFlag, ref bool allLineItemsDeleted, ref bool isRecordDeleted)
		{
			IEnumerable<JobOrderItemMapping> deletedJobOrderItemMapping = null;
			var deletedItems = navSalesOrderItemRequest?.Select(s => s.Line_No);
			deletedJobOrderItemMapping = deletedItems == null ? deletedJobOrderItemMapping : jobOrderItemMapping.Where(t => t.EntityName == Entities.EntitiesAlias.ShippingItem.ToString() && !deletedItems.Contains(t.LineNumber));
			foreach (var deleteItem in deletedJobOrderItemMapping)
			{
				NavSalesOrderHelper.DeleteSalesOrderItemForNAV(navAPIUrl, navAPIUserName, navAPIPassword, soNumber, deleteItem.LineNumber, out isRecordDeleted);
				if (isRecordDeleted)
				{
					_commands.DeleteJobOrderItemMapping(deleteItem.M4PLItemId, ActiveUser, jobIdList, Entities.EntitiesAlias.ShippingItem.ToString(), deleteItem.LineNumber);
				}

				allLineItemsDeleted = !allLineItemsDeleted ? allLineItemsDeleted : isRecordDeleted;
			}

			deleteProFlag = allLineItemsUpdated ? deleteProFlag : Entities.ProFlag.D.ToString();
			_commands.UpdateJobProFlag(ActiveUser, deleteProFlag, jobIdList, Entities.EntitiesAlias.SalesOrder);
		}
	}
}
