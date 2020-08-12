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
// Date Programmed:                              10/18/2019
// Program Name:                                 NavSalesOrderHelper
// Purpose:                                      Contains commands to call DAL logic for M4PL.DAL.Finance.NavSalesOrderHelper
//==============================================================================================================

using M4PL.Business.Common;
using M4PL.Entities.Finance.JobOrderMapping;
using M4PL.Entities.Finance.PurchaseOrder;
using M4PL.Entities.Finance.PurchaseOrderItem;
using M4PL.Entities.Support;
using M4PL.Utilities.Logger;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
using _commands = M4PL.DataAccess.Finance.NavSalesOrderCommand;
using _jobCommands = M4PL.DataAccess.Job.JobCommands;
using _logger = M4PL.DataAccess.Logger.ErrorLogger;
using _purchaseCommands = M4PL.DataAccess.Finance.NavPurchaseOrderCommands;

namespace M4PL.Business.Finance.PurchaseOrder
{
    /// <summary>
    /// Helper Class To Store the Purchase Order Related Methods
    /// </summary>
    public static class NavPurchaseOrderHelper
    {
		#region Purchase Order

		public static NavJobPurchaseOrder GetPurchaseOrderFromNavByJobId(string navAPIUrl, string navAPIUserName, string navAPIPassword, long jobId)
		{
			NavJobPurchaseOrder navJobPurchaseOrderResponse = null;
			string serviceCall = string.Format("{0}('{1}')/PurchaseOrder?$filter=M4PL_Job_ID eq '{2}'", navAPIUrl, "Meridian", jobId);
			try
			{
				NetworkCredential myCredentials = new NetworkCredential(navAPIUserName, navAPIPassword);
				HttpWebRequest request = (HttpWebRequest)WebRequest.Create(serviceCall);
				request.Credentials = myCredentials;
				request.KeepAlive = false;
				request.ContentType = "application/json";
				WebResponse response = request.GetResponse();

				using (Stream navSalesOrderResponseStream = response.GetResponseStream())
				{
					using (TextReader navSalesOrderReader = new StreamReader(navSalesOrderResponseStream))
					{
						string navSalesOrderResponseString = navSalesOrderReader.ReadToEnd();

						using (var stringReader = new StringReader(navSalesOrderResponseString))
						{
							navJobPurchaseOrderResponse = JsonConvert.DeserializeObject<NavJobPurchaseOrder>(navSalesOrderResponseString);
						}
					}
				}
			}
			catch (Exception exp)
			{
				_logger.Log(exp, string.Format("Error is occuring while Getting the Purchase order Details by JobId: Request Url is: {0}.", serviceCall), string.Format("Get the Purchase Order Information for JobId: {0}", jobId), LogType.Error);
			}

			return navJobPurchaseOrderResponse;
		}

		public static NavPurchaseOrder GetPurchaseOrderForNAV(string navAPIUrl, string navAPIUserName, string navAPIPassword, string poNumber)
        {
            NavPurchaseOrder navPurchaseOrderResponse = null;
            string serviceCall = string.Format("{0}('{1}')/PurchaseOrder('Order', '{2}')", navAPIUrl, "Meridian", poNumber);
            try
            {
                NetworkCredential myCredentials = new NetworkCredential(navAPIUserName, navAPIPassword);
                HttpWebRequest request = (HttpWebRequest)WebRequest.Create(serviceCall);
                request.Credentials = myCredentials;
                request.KeepAlive = false;
                request.ContentType = "application/json";
                WebResponse response = request.GetResponse();

                using (Stream navPurchaseOrderResponseStream = response.GetResponseStream())
                {
                    using (TextReader navPurchaseOrderReader = new StreamReader(navPurchaseOrderResponseStream))
                    {
                        string responceString = navPurchaseOrderReader.ReadToEnd();

                        using (var stringReader = new StringReader(responceString))
                        {
                            navPurchaseOrderResponse = Newtonsoft.Json.JsonConvert.DeserializeObject<NavPurchaseOrder>(responceString);
                        }
                    }
                }
            }
            catch (Exception exp)
            {
                _logger.Log(exp, string.Format("Error is occuring while Getting the purchase order: Request Url is: {0}.", serviceCall), string.Format("Get the Purchase Order Information for PONumber: {0}", poNumber), LogType.Error);
            }

            return navPurchaseOrderResponse;
        }

        public static NavPurchaseOrder GeneratePurchaseOrderForNAV(ActiveUser activeUser, List<long> jobIdList, string navAPIUrl, string navAPIUserName, string navAPIPassword, string soNumber, bool electronicInvoice, List<PurchaseOrderItem> purchaseOrderItemRequest)
        {
            NavPurchaseOrder navPurchaseOrderResponse = null;
            string navPurchaseOrderJson = string.Empty;
            string proFlag = null;
            string dimensionCode = string.Empty;
            string divisionCode = string.Empty;
            string serviceCall = string.Format("{0}('{1}')/PurchaseOrder", navAPIUrl, "Meridian");
            try
            {
                NavPurchaseOrderRequest navPurchaseOrderRequest = _purchaseCommands.GetPurchaseOrderCreationData(activeUser, jobIdList, Entities.EntitiesAlias.PurchaseOrder);
                if (navPurchaseOrderRequest == null) { return null; }
                var dimensions = CommonCommands.GetSalesOrderDimensionValues(navAPIUserName, navAPIPassword, navAPIUrl);
                if (dimensions != null && dimensions.NavSalesOrderDimensionValues != null && dimensions.NavSalesOrderDimensionValues.Count > 0)
                {
                    divisionCode = dimensions.NavSalesOrderDimensionValues.Where(x => !string.IsNullOrEmpty(x.Dimension_Code) && x.Dimension_Code.ToUpper() == "DIVISIONS" && x.ERPId == navPurchaseOrderRequest.Sell_to_Customer_No).Any()
                        ? dimensions.NavSalesOrderDimensionValues.Where(x => !string.IsNullOrEmpty(x.Dimension_Code) && x.Dimension_Code.ToUpper() == "DIVISIONS" && x.ERPId == navPurchaseOrderRequest.Sell_to_Customer_No).FirstOrDefault().Code
                        : string.Empty;

                    if (!string.IsNullOrEmpty(navPurchaseOrderRequest.Ship_from_City) && !string.IsNullOrEmpty(navPurchaseOrderRequest.Ship_from_County))
                    {
                        string dimensionMatchCode = navPurchaseOrderRequest.Ship_from_City.Length >= 3 ? string.Format("{0}{1}", navPurchaseOrderRequest.Ship_from_City.Substring(0, 3), navPurchaseOrderRequest.Ship_from_County) : string.Empty;
                        if (!string.IsNullOrEmpty(dimensionMatchCode))
                        {
                            dimensionCode = dimensions.NavSalesOrderDimensionValues.Where(codeMatch => !string.IsNullOrEmpty(codeMatch.Code) && codeMatch.Code.Length > 4 && codeMatch.Code.Substring(codeMatch.Code.Length - 5).ToUpper() == dimensionMatchCode.ToUpper()).Any() ?
                            dimensions.NavSalesOrderDimensionValues.Where(codeMatch => !string.IsNullOrEmpty(codeMatch.Code) && codeMatch.Code.Length > 4 && codeMatch.Code.Substring(codeMatch.Code.Length - 5).ToUpper() == dimensionMatchCode.ToUpper()).FirstOrDefault().Code : dimensionCode;
                        }
                    }
                }

                navPurchaseOrderRequest.Shortcut_Dimension_2_Code = dimensionCode;
                navPurchaseOrderRequest.Shortcut_Dimension_1_Code = divisionCode;
                navPurchaseOrderRequest.Electronic_Invoice = electronicInvoice;
                NetworkCredential myCredentials = new NetworkCredential(navAPIUserName, navAPIPassword);
                HttpWebRequest request = (HttpWebRequest)WebRequest.Create(serviceCall);
                request.Credentials = myCredentials;
                request.KeepAlive = false;
                request.ContentType = "application/json";
                request.Method = "POST";
                using (var streamWriter = new StreamWriter(request.GetRequestStream()))
                {
                    navPurchaseOrderJson = Newtonsoft.Json.JsonConvert.SerializeObject(navPurchaseOrderRequest);
                    streamWriter.Write(navPurchaseOrderJson);
                }

                WebResponse response = request.GetResponse();

                using (Stream navPurchaseOrderResponseStream = response.GetResponseStream())
                {
                    using (TextReader navPurchaseOrderReader = new StreamReader(navPurchaseOrderResponseStream))
                    {
                        string responceString = navPurchaseOrderReader.ReadToEnd();

                        using (var stringReader = new StringReader(responceString))
                        {
                            navPurchaseOrderResponse = Newtonsoft.Json.JsonConvert.DeserializeObject<NavPurchaseOrder>(responceString);
                        }
                    }
                }

                if (navPurchaseOrderResponse != null && !string.IsNullOrWhiteSpace(navPurchaseOrderResponse.No))
                {
                    _purchaseCommands.UpdateJobPurchaseOrderMapping(activeUser, jobIdList, soNumber, navPurchaseOrderResponse.No, electronicInvoice);
                    if (purchaseOrderItemRequest != null && purchaseOrderItemRequest.Count > 0)
                    {
                        purchaseOrderItemRequest.ForEach(x => x.Document_No = navPurchaseOrderResponse.No);
                    }

                    UpdateLineItemInformationForPurchaseOrder(activeUser, jobIdList, navAPIUrl, navAPIUserName, navAPIPassword, dimensionCode, divisionCode, navPurchaseOrderResponse.No, out proFlag, electronicInvoice, purchaseOrderItemRequest);
                }
            }
            catch (Exception exp)
            {
                proFlag = Entities.ProFlag.H.ToString();
                _logger.Log(exp, string.Format("Error is occuring while Generating the purchase order: Request Url is: {0}, Request body json was {1}", serviceCall, navPurchaseOrderJson), string.Format("Purchase order creation for JobId: {0}", Newtonsoft.Json.JsonConvert.SerializeObject(jobIdList)), LogType.Error);
            }

            _commands.UpdateJobProFlag(activeUser, proFlag, jobIdList, Entities.EntitiesAlias.PurchaseOrder);
            return navPurchaseOrderResponse;
        }

        public static NavPurchaseOrder UpdatePurchaseOrderForNAV(ActiveUser activeUser, List<long> jobIdList, string poNumer, string navAPIUrl, string navAPIUserName, string navAPIPassword, string soNumber, bool electronicInvoice, List<PurchaseOrderItem> purchaseOrderItemRequest)
        {
            string navPurchaseOrderJson = string.Empty;
            string dimensionCode = string.Empty;
            string divisionCode = string.Empty;
            NavPurchaseOrder navPurchaseOrderResponse = null;
            string proFlag = null;
            string serviceCall = string.Format("{0}('{1}')/PurchaseOrder('Order', '{2}')", navAPIUrl, "Meridian", poNumer);
            try
            {
                NavPurchaseOrder existingSalesOrderData = GetPurchaseOrderForNAV(navAPIUrl, navAPIUserName, navAPIPassword, poNumer);
                NavPurchaseOrderRequest navPurchaseOrderRequest = _purchaseCommands.GetPurchaseOrderCreationData(activeUser, jobIdList, Entities.EntitiesAlias.PurchaseOrder);
                if (navPurchaseOrderRequest == null) { return null; }
                var dimensions = CommonCommands.GetSalesOrderDimensionValues(navAPIUserName, navAPIPassword, navAPIUrl);
                if (dimensions != null && dimensions.NavSalesOrderDimensionValues != null && dimensions.NavSalesOrderDimensionValues.Count > 0)
                {
                    divisionCode = dimensions.NavSalesOrderDimensionValues.Where(x => !string.IsNullOrEmpty(x.Dimension_Code) && x.Dimension_Code.ToUpper() == "DIVISIONS" && x.ERPId == navPurchaseOrderRequest.Sell_to_Customer_No).Any()
                        ? dimensions.NavSalesOrderDimensionValues.Where(x => !string.IsNullOrEmpty(x.Dimension_Code) && x.Dimension_Code.ToUpper() == "DIVISIONS" && x.ERPId == navPurchaseOrderRequest.Sell_to_Customer_No).FirstOrDefault().Code
                        : string.Empty;

                    if (!string.IsNullOrEmpty(navPurchaseOrderRequest.Ship_from_City) && !string.IsNullOrEmpty(navPurchaseOrderRequest.Ship_from_County))
                    {
                        string dimensionMatchCode = navPurchaseOrderRequest.Ship_from_City.Length >= 3 ? string.Format("{0}{1}", navPurchaseOrderRequest.Ship_from_City.Substring(0, 3), navPurchaseOrderRequest.Ship_from_County) : string.Empty;
                        if (!string.IsNullOrEmpty(dimensionMatchCode))
                        {
                            dimensionCode = dimensions.NavSalesOrderDimensionValues.Where(codeMatch => !string.IsNullOrEmpty(codeMatch.Code) && codeMatch.Code.Length > 4 && codeMatch.Code.Substring(codeMatch.Code.Length - 5).ToUpper() == dimensionMatchCode.ToUpper()).Any() ?
                            dimensions.NavSalesOrderDimensionValues.Where(codeMatch => !string.IsNullOrEmpty(codeMatch.Code) && codeMatch.Code.Length > 4 && codeMatch.Code.Substring(codeMatch.Code.Length - 5).ToUpper() == dimensionMatchCode.ToUpper()).FirstOrDefault().Code : dimensionCode;
                        }
                    }
                }

                navPurchaseOrderRequest.Shortcut_Dimension_2_Code = dimensionCode;
                navPurchaseOrderRequest.Shortcut_Dimension_1_Code = divisionCode;
                navPurchaseOrderRequest.Electronic_Invoice = electronicInvoice;
                NetworkCredential myCredentials = new NetworkCredential(navAPIUserName, navAPIPassword);
                HttpWebRequest request = (HttpWebRequest)WebRequest.Create(serviceCall);
                request.Credentials = myCredentials;
                request.KeepAlive = false;
                request.ContentType = "application/json";
                request.Method = "PATCH";
                request.Headers.Add(HttpRequestHeader.IfMatch, existingSalesOrderData.DataETag);
                using (var streamWriter = new StreamWriter(request.GetRequestStream()))
                {
                    navPurchaseOrderJson = Newtonsoft.Json.JsonConvert.SerializeObject(navPurchaseOrderRequest);
                    streamWriter.Write(navPurchaseOrderJson);
                }

                WebResponse response = request.GetResponse();

                using (Stream navPurchaseOrderResponseStream = response.GetResponseStream())
                {
                    using (TextReader navPurchaseOrderReader = new StreamReader(navPurchaseOrderResponseStream))
                    {
                        string responceString = navPurchaseOrderReader.ReadToEnd();

                        using (var stringReader = new StringReader(responceString))
                        {
                            navPurchaseOrderResponse = Newtonsoft.Json.JsonConvert.DeserializeObject<NavPurchaseOrder>(responceString);
                        }
                    }
                }

                if (navPurchaseOrderResponse != null && !string.IsNullOrWhiteSpace(navPurchaseOrderResponse.No))
                {
                    if (purchaseOrderItemRequest != null && purchaseOrderItemRequest.Count > 0)
                    {
                        purchaseOrderItemRequest.ForEach(x => x.Document_No = navPurchaseOrderResponse.No);
                    }

                    UpdateLineItemInformationForPurchaseOrder(activeUser, jobIdList, navAPIUrl, navAPIUserName, navAPIPassword, dimensionCode, divisionCode, navPurchaseOrderResponse.No, out proFlag, electronicInvoice, purchaseOrderItemRequest);
                }
            }
            catch (Exception exp)
            {
                proFlag = Entities.ProFlag.H.ToString();
                _logger.Log(exp, string.Format("Error is occuring while Updating the purchase order: Request Url is: {0}, Request body json was {1}", serviceCall, navPurchaseOrderJson), string.Format("Purchase order updation for JobId: {0}", Newtonsoft.Json.JsonConvert.SerializeObject(jobIdList)), LogType.Error);
            }

            _commands.UpdateJobProFlag(activeUser, proFlag, jobIdList, Entities.EntitiesAlias.PurchaseOrder);
            return navPurchaseOrderResponse;
        }

        public static bool DeletePurchaseOrderForNAV(string poNumer, string navAPIUrl, string navAPIUserName, string navAPIPassword, out bool isRecordDeleted)
        {
            string serviceCall = string.Format("{0}('{1}')/PurchaseOrder('Order', '{2}')", navAPIUrl, "Meridian", poNumer);
            try
            {
                NetworkCredential myCredentials = new NetworkCredential(navAPIUserName, navAPIPassword);
                HttpWebRequest request = (HttpWebRequest)WebRequest.Create(serviceCall);
                request.Credentials = myCredentials;
                request.KeepAlive = false;
                request.ContentType = "application/json";
                request.Method = "DELETE";
                WebResponse response = request.GetResponse();
                isRecordDeleted = response != null && (response as HttpWebResponse).StatusCode == HttpStatusCode.NoContent ? true : false;
                if (isRecordDeleted)
                {
                    _commands.DeleteJobOrderMapping(poNumer, Entities.EntitiesAlias.PurchaseOrder.ToString());
                }
            }
            catch (Exception exp)
            {
                isRecordDeleted = false;
                _logger.Log(exp, string.Format("Error is occuring while Deleting the Purchase order: Request Url is: {0}", serviceCall), string.Format("Sales order item delete for Purchase Order: {0}.", poNumer), LogType.Error);
            }

            return isRecordDeleted;
        }

        #endregion

        #region Purchase Order Item

        public static NavPurchaseOrderItem GetPurchaseOrderItemForNAV(string navAPIUrl, string navAPIUserName, string navAPIPassword, string poNumber, int lineNo)
        {
            NavPurchaseOrderItem navPurchaseOrderItemResponse = null;
            string serviceCall = string.Format("{0}('{1}')/PurchaseLine('Order', '{2}', {3})", navAPIUrl, "Meridian", poNumber, lineNo);
            try
            {
                NetworkCredential myCredentials = new NetworkCredential(navAPIUserName, navAPIPassword);
                HttpWebRequest request = (HttpWebRequest)WebRequest.Create(serviceCall);
                request.Credentials = myCredentials;
                request.KeepAlive = false;
                request.ContentType = "application/json";
                WebResponse response = request.GetResponse();

                using (Stream navPurchaseOrderItemResponseStream = response.GetResponseStream())
                {
                    using (TextReader navPurchaseOrderItemReader = new StreamReader(navPurchaseOrderItemResponseStream))
                    {
                        string responceString = navPurchaseOrderItemReader.ReadToEnd();

                        using (var stringReader = new StringReader(responceString))
                        {
                            navPurchaseOrderItemResponse = Newtonsoft.Json.JsonConvert.DeserializeObject<NavPurchaseOrderItem>(responceString);
                        }
                    }
                }
            }
            catch (Exception exp)
            {
                _logger.Log(exp, string.Format("Error is occuring while Getting the purchase order item: Request Url is: {0}", serviceCall), string.Format("Purchase order item get for Purchase Order: {0} and Line number {1}.", poNumber, lineNo), LogType.Error);
            }

            return navPurchaseOrderItemResponse;
        }

        private static NavPurchaseOrderItem GeneratePurchaseOrderItemForNAV(NavPurchaseOrderItemRequest navPurchaseOrderItemRequest, string navAPIUrl, string navAPIUserName, string navAPIPassword, ActiveUser activeUser, List<long> jobIdList, out bool isRecordUpdated)
        {
            NavPurchaseOrderItem navPurchaseOrderItemResponse = null;
            string serviceCall = string.Format("{0}('{1}')/PurchaseLine", navAPIUrl, "Meridian");
            string dataToRemove = string.Format("{0}:{1},", "\"M4PLItemId\"", navPurchaseOrderItemRequest.M4PLItemId);
            string navPurchaseOrderItemJson = string.Empty;
            try
            {
                NetworkCredential myCredentials = new NetworkCredential(navAPIUserName, navAPIPassword);
                HttpWebRequest navPurchaseOrderItemrequest = (HttpWebRequest)WebRequest.Create(serviceCall);
                navPurchaseOrderItemrequest.Credentials = myCredentials;
                navPurchaseOrderItemrequest.KeepAlive = false;
                navPurchaseOrderItemrequest.ContentType = "application/json";
                navPurchaseOrderItemrequest.Method = "POST";
                using (var navPurchaseOrderItemStreamWriter = new StreamWriter(navPurchaseOrderItemrequest.GetRequestStream()))
                {
                    navPurchaseOrderItemJson = JsonConvert.SerializeObject(navPurchaseOrderItemRequest);
                    navPurchaseOrderItemJson = navPurchaseOrderItemJson.Replace(dataToRemove, string.Empty);
                    navPurchaseOrderItemStreamWriter.Write(navPurchaseOrderItemJson);
                }

                WebResponse response = navPurchaseOrderItemrequest.GetResponse();

                using (Stream navPurchaseOrderItemResponseStream = response.GetResponseStream())
                {
                    using (TextReader navSalesOrderItemSyncReader = new StreamReader(navPurchaseOrderItemResponseStream))
                    {
                        string navSalesOrderItemResponseString = navSalesOrderItemSyncReader.ReadToEnd();

                        using (var stringReader = new StringReader(navSalesOrderItemResponseString))
                        {
                            navPurchaseOrderItemResponse = Newtonsoft.Json.JsonConvert.DeserializeObject<NavPurchaseOrderItem>(navSalesOrderItemResponseString);
                        }
                    }
                }
            }
            catch (Exception exp)
            {
                _logger.Log(exp, string.Format("Error is occuring while Creating the purchase order item: Request Url is: {0}, Request body json was {1}", serviceCall, navPurchaseOrderItemJson), string.Format("Purchase order item create for JobId: {0}, Line number: {1}", navPurchaseOrderItemRequest.M4PL_Job_ID, navPurchaseOrderItemRequest.Line_No), LogType.Error);
            }

            isRecordUpdated = navPurchaseOrderItemResponse == null ? false : true;
            if (navPurchaseOrderItemResponse != null)
            {
                _commands.UpdateJobOrderItemMapping(navPurchaseOrderItemRequest.M4PLItemId, activeUser, jobIdList, Entities.EntitiesAlias.PurchaseOrderItem.ToString(), navPurchaseOrderItemRequest.Line_No, navPurchaseOrderItemRequest.Document_No);
            }

            return navPurchaseOrderItemResponse;
        }

        private static NavPurchaseOrderItem UpdatePurchaseOrderItemForNAV(NavPurchaseOrderItemRequest navPurchaseOrderItemRequest, string navAPIUrl, string navAPIUserName, string navAPIPassword, ActiveUser activeUser, List<long> jobIdList, out bool isRecordUpdated)
        {
            NavPurchaseOrderItem navPurchaseOrderItemResponse = null;
            string navPurchaseOrderItemJson = string.Empty;
            string dataToRemove = string.Format("{0}:{1},", "\"M4PLItemId\"", navPurchaseOrderItemRequest.M4PLItemId);
            string serviceCall = string.Format("{0}('{1}')/PurchaseLine('Order', '{2}', {3})", navAPIUrl, "Meridian", navPurchaseOrderItemRequest.Document_No, navPurchaseOrderItemRequest.Line_No);
            try
            {
                NavPurchaseOrderItem existingNavPurchaseOrderItem = GetPurchaseOrderItemForNAV(navAPIUrl, navAPIUserName, navAPIPassword, navPurchaseOrderItemRequest.Document_No, navPurchaseOrderItemRequest.Line_No);
                NetworkCredential myCredentials = new NetworkCredential(navAPIUserName, navAPIPassword);
                HttpWebRequest navPurchaseOrderItemrequest = (HttpWebRequest)WebRequest.Create(serviceCall);
                navPurchaseOrderItemrequest.Credentials = myCredentials;
                navPurchaseOrderItemrequest.KeepAlive = false;
                navPurchaseOrderItemrequest.ContentType = "application/json";
                navPurchaseOrderItemrequest.Method = "PATCH";
                navPurchaseOrderItemrequest.Headers.Add(HttpRequestHeader.IfMatch, existingNavPurchaseOrderItem.DataETag);
                using (var navPurchaseOrderItemStreamWriter = new StreamWriter(navPurchaseOrderItemrequest.GetRequestStream()))
                {
                    navPurchaseOrderItemJson = JsonConvert.SerializeObject(navPurchaseOrderItemRequest);
                    navPurchaseOrderItemJson = navPurchaseOrderItemJson.Replace(dataToRemove, string.Empty);
                    navPurchaseOrderItemStreamWriter.Write(navPurchaseOrderItemJson);
                }

                WebResponse response = navPurchaseOrderItemrequest.GetResponse();

                using (Stream navPurchaseOrderItemResponseStream = response.GetResponseStream())
                {
                    using (TextReader navSalesOrderItemSyncReader = new StreamReader(navPurchaseOrderItemResponseStream))
                    {
                        string navSalesOrderItemResponseString = navSalesOrderItemSyncReader.ReadToEnd();

                        using (var stringReader = new StringReader(navSalesOrderItemResponseString))
                        {
                            navPurchaseOrderItemResponse = Newtonsoft.Json.JsonConvert.DeserializeObject<NavPurchaseOrderItem>(navSalesOrderItemResponseString);
                        }
                    }
                }
            }
            catch (Exception exp)
            {
                _logger.Log(exp, string.Format("Error is occuring while Updating the purchase order item: Request Url is: {0}, Request body json was {1}", serviceCall, navPurchaseOrderItemJson), string.Format("Purchase order item update for JobId: {0}, Line number: {1}", navPurchaseOrderItemRequest.M4PL_Job_ID, navPurchaseOrderItemRequest.Line_No), LogType.Error);
            }

            isRecordUpdated = navPurchaseOrderItemResponse == null ? false : true;
            if (navPurchaseOrderItemResponse != null)
            {
                _commands.UpdateJobOrderItemMapping(navPurchaseOrderItemRequest.M4PLItemId, activeUser, jobIdList, Entities.EntitiesAlias.PurchaseOrderItem.ToString(), navPurchaseOrderItemRequest.Line_No, navPurchaseOrderItemRequest.Document_No);
            }

            return navPurchaseOrderItemResponse;
        }

        public static bool DeletePurchaseOrderItemForNAV(string navAPIUrl, string navAPIUserName, string navAPIPassword, string poNumber, int lineNo, out bool isRecordDeleted)
        {
            string serviceCall = string.Format("{0}('{1}')/PurchaseLine('Order', '{2}', {3})", navAPIUrl, "Meridian", poNumber, lineNo);
            try
            {
                NetworkCredential myCredentials = new NetworkCredential(navAPIUserName, navAPIPassword);
                HttpWebRequest request = (HttpWebRequest)WebRequest.Create(serviceCall);
                request.Credentials = myCredentials;
                request.KeepAlive = false;
                request.ContentType = "application/json";
                request.Method = "DELETE";
                WebResponse response = request.GetResponse();
                isRecordDeleted = response != null && (response as HttpWebResponse).StatusCode == HttpStatusCode.NoContent ? true : false;
            }
            catch (Exception exp)
            {
                isRecordDeleted = false;
                _logger.Log(exp, string.Format("Error is occuring while Deleting the Purchase order item: Request Url is: {0}", serviceCall), string.Format("Purchase order item delete for Purchase Order: {0} and Line number {1}.", poNumber, lineNo), LogType.Error);
            }

            return isRecordDeleted;
        }

        #endregion

        #region Helper Method

        private static void UpdateLineItemInformationForPurchaseOrder(ActiveUser activeUser, List<long> jobIdList, string navAPIUrl, string navAPIUserName, string navAPIPassword, string dimensionCode, string divisionCode, string poNumber, out string proFlag, bool isElectronicInvoice, List<PurchaseOrderItem> purchaseOrderItemRequest)
        {
            bool allLineItemsUpdated = true;
            string deleteProFlag = null;
            bool allLineItemsDeleted = true;
            List<NavPurchaseOrderItemRequest> navPurchaseOrderItemRequest = null;
            if (purchaseOrderItemRequest != null && purchaseOrderItemRequest.Count > 0)
            {
                navPurchaseOrderItemRequest = new List<NavPurchaseOrderItemRequest>();
                purchaseOrderItemRequest.ToList().ForEach(x => navPurchaseOrderItemRequest.Add(new NavPurchaseOrderItemRequest()
                {
                    No = x.No,
                    M4PLItemId = x.M4PLItemId,
                    Document_No = x.Document_No,
                    M4PL_Job_ID = x.M4PL_Job_ID,
                    Quantity = x.Quantity,
                    Qty_to_Receive = x.Qty_to_Receive,
                    Qty_to_Invoice = x.Qty_to_Invoice,
                    Promised_Receipt_Date = x.Promised_Receipt_Date,
                    Expected_Receipt_Date = x.Expected_Receipt_Date,
                    Order_Date = x.Order_Date,
                    Line_No = x.Line_No,
                    Type = x.Type,
                    FilteredTypeField = x.FilteredTypeField,
                    Shortcut_Dimension_1_Code = x.Shortcut_Dimension_1_Code,
                    Shortcut_Dimension_2_Code = x.Shortcut_Dimension_2_Code

                }));
            }

            List<JobOrderItemMapping> jobOrderItemMapping = _commands.GetJobOrderItemMapping(jobIdList, Entities.EntitiesAlias.PurchaseOrder, isElectronicInvoice);
            bool isRecordUpdated = true;
            bool isRecordDeleted = true;
            if (jobOrderItemMapping != null && jobOrderItemMapping.Count > 0)
            {
                DeleteLineItemInformationForPurchaseOrder(activeUser, jobIdList, navAPIUrl, navAPIUserName, navAPIPassword, isElectronicInvoice, allLineItemsUpdated, navPurchaseOrderItemRequest, jobOrderItemMapping, poNumber, ref deleteProFlag, ref allLineItemsDeleted, ref isRecordDeleted);
            }

            NavPurchaseOrderItem navPurchaseOrderItemResponse = null;
            if (navPurchaseOrderItemRequest != null && navPurchaseOrderItemRequest.Count > 0)
            {
                foreach (var navPurchaseOrderItemRequestItem in navPurchaseOrderItemRequest)
                {
                    navPurchaseOrderItemRequestItem.Shortcut_Dimension_2_Code = dimensionCode;
                    navPurchaseOrderItemRequestItem.Shortcut_Dimension_1_Code = divisionCode;
                    if (jobOrderItemMapping != null && jobOrderItemMapping.Count > 0 && jobOrderItemMapping.Where(x => x.EntityName == Entities.EntitiesAlias.PurchaseOrderItem.ToString() && x.LineNumber == navPurchaseOrderItemRequestItem.Line_No && x.M4PLItemId == navPurchaseOrderItemRequestItem.M4PLItemId).Any())
                    {
                        navPurchaseOrderItemResponse = UpdatePurchaseOrderItemForNAV(navPurchaseOrderItemRequestItem, navAPIUrl, navAPIUserName, navAPIPassword, activeUser, jobIdList, out isRecordUpdated);
                    }
                    else
                    {
                        navPurchaseOrderItemResponse = GeneratePurchaseOrderItemForNAV(navPurchaseOrderItemRequestItem, navAPIUrl, navAPIUserName, navAPIPassword, activeUser, jobIdList, out isRecordUpdated);
                    }

                    allLineItemsUpdated = !allLineItemsUpdated ? allLineItemsUpdated : isRecordUpdated;
                    isRecordUpdated = true;
                    navPurchaseOrderItemResponse = null;
                }
            }

            proFlag = allLineItemsUpdated ? deleteProFlag : Entities.ProFlag.I.ToString();
            _commands.UpdateJobProFlag(activeUser, proFlag, jobIdList, Entities.EntitiesAlias.PurchaseOrder);
        }

        private static void DeleteLineItemInformationForPurchaseOrder(ActiveUser activeUser, List<long> jobIdList, string navAPIUrl, string navAPIUserName, string navAPIPassword, bool isElectronicInvoice, bool allLineItemsUpdated, List<NavPurchaseOrderItemRequest> navPurchaseOrderItemRequest, List<JobOrderItemMapping> jobOrderItemMapping, string poNumber, ref string deleteProFlag, ref bool allLineItemsDeleted, ref bool isRecordDeleted)
        {
            IEnumerable<JobOrderItemMapping> deletedJobOrderItemMapping = null;
            var deletedItems = navPurchaseOrderItemRequest?.Select(s => s.Line_No);
            deletedJobOrderItemMapping = deletedItems == null ? deletedJobOrderItemMapping : jobOrderItemMapping.Where(t => t.IsElectronicInvoiced == isElectronicInvoice && !deletedItems.Contains(t.LineNumber));
            foreach (var deleteItem in deletedJobOrderItemMapping)
            {
                DeletePurchaseOrderItemForNAV(navAPIUrl, navAPIUserName, navAPIPassword, poNumber, deleteItem.LineNumber, out isRecordDeleted);
                if (isRecordDeleted)
                {
                    _commands.DeleteJobOrderItemMapping(deleteItem.JobOrderItemMappingId);
                }

                allLineItemsDeleted = !allLineItemsDeleted ? allLineItemsDeleted : isRecordDeleted;
            }

            deleteProFlag = allLineItemsUpdated ? deleteProFlag : Entities.ProFlag.D.ToString();
            _commands.UpdateJobProFlag(activeUser, deleteProFlag, jobIdList, Entities.EntitiesAlias.PurchaseOrder);
        }

        #endregion

        public static void PurchaseOrderCreationProcessForNAV(ActiveUser activeUser, List<long> jobIdList, string navAPIUrl, string navAPIUserName, string navAPIPassword, bool electronicInvoice)
        {
            bool isElectronicInvoice = false;
            bool isManualInvoice = false;
            NavPurchaseOrder manualPurchaseOrder = null;
            NavPurchaseOrder electronicPurchaseOrder = null;
            List<PurchaseOrderItem> manualPurchaseOrderItemRequest = null;
            List<PurchaseOrderItem> electronicPurchaseOrderItemRequest = null;
            List<PurchaseOrderItem> purchaseOrderItemRequest = _commands.GetPurchaseOrderItemCreationData(activeUser, jobIdList, Entities.EntitiesAlias.PurchaseOrderItem);
            if (purchaseOrderItemRequest == null || (purchaseOrderItemRequest != null && purchaseOrderItemRequest.Count == 0))
            {
                isManualInvoice = true;
                isElectronicInvoice = false;
            }
            else if (purchaseOrderItemRequest != null && purchaseOrderItemRequest.Count > 0)
            {
                isElectronicInvoice = purchaseOrderItemRequest.Where(x => x.Electronic_Invoice).Any() ? true : false;
                isManualInvoice = purchaseOrderItemRequest.Where(x => !x.Electronic_Invoice).Any() ? true : false;
                manualPurchaseOrderItemRequest = isManualInvoice ? purchaseOrderItemRequest.Where(x => !x.Electronic_Invoice).ToList() : null;
                electronicPurchaseOrderItemRequest = isElectronicInvoice ? purchaseOrderItemRequest.Where(x => x.Electronic_Invoice).ToList() : null;
            }

            if (jobIdList != null && jobIdList.Count > 0)
            {
                foreach (var currentJob in jobIdList)
                {
                    Entities.Job.Job jobData = _jobCommands.GetJobByProgram(activeUser, currentJob, 0);
                    if ((!jobData.JobElectronicInvoice ||
                        (purchaseOrderItemRequest != null && purchaseOrderItemRequest.Count > 0 && !purchaseOrderItemRequest.Where(x => x.Electronic_Invoice).Any()))
                        && !string.IsNullOrEmpty(jobData.JobElectronicInvoicePONumber))
                    {
                        bool isDeleted = false;
                        DeletePurchaseOrderForNAV(jobData.JobElectronicInvoicePONumber, navAPIUrl, navAPIUserName, navAPIPassword, out isDeleted);
                        jobData.JobElectronicInvoicePONumber = isDeleted ? string.Empty : jobData.JobElectronicInvoicePONumber;
                    }

                    if (!string.IsNullOrEmpty(jobData.JobPONumber) && ((purchaseOrderItemRequest == null || (purchaseOrderItemRequest != null && purchaseOrderItemRequest.Count == 0)) || (purchaseOrderItemRequest != null && purchaseOrderItemRequest.Count > 0 && !purchaseOrderItemRequest.Where(x => !x.Electronic_Invoice).Any())))
                    {
                        bool isDeleted = false;
                        DeletePurchaseOrderForNAV(jobData.JobPONumber, navAPIUrl, navAPIUserName, navAPIPassword, out isDeleted);
                        jobData.JobPONumber = isDeleted ? string.Empty : jobData.JobPONumber;
                    }

                    if (!jobData.JobElectronicInvoice || (jobData.JobElectronicInvoice && (purchaseOrderItemRequest == null || (purchaseOrderItemRequest != null && purchaseOrderItemRequest.Count == 0))) || (jobData.JobElectronicInvoice && purchaseOrderItemRequest != null && purchaseOrderItemRequest.Count > 0 && !purchaseOrderItemRequest.Where(x => x.Electronic_Invoice).Any()))
                    {
                        if (jobData.JobElectronicInvoice)
                        {
                            if (string.IsNullOrEmpty(jobData.JobElectronicInvoicePONumber))
                            {
                                manualPurchaseOrder = GeneratePurchaseOrderForNAV(activeUser, jobIdList, navAPIUrl, navAPIUserName, navAPIPassword,
                                    string.IsNullOrEmpty(jobData.JobElectronicInvoiceSONumber) ? jobData.JobSONumber : jobData.JobElectronicInvoiceSONumber,
                                    jobData.JobElectronicInvoice, purchaseOrderItemRequest);
                            }
                            else
                            {
                                manualPurchaseOrder = UpdatePurchaseOrderForNAV(activeUser, jobIdList,
                                    string.IsNullOrEmpty(jobData.JobElectronicInvoicePONumber) ? jobData.JobPONumber : jobData.JobElectronicInvoicePONumber,
                                    navAPIUrl, navAPIUserName, navAPIPassword, string.IsNullOrEmpty(jobData.JobElectronicInvoiceSONumber) ? jobData.JobSONumber :
                                    jobData.JobElectronicInvoiceSONumber, jobData.JobElectronicInvoice, purchaseOrderItemRequest);
                            }
                        }
                        else
                        {
                            if (string.IsNullOrEmpty(jobData.JobPONumber))
                            {
                                manualPurchaseOrder = GeneratePurchaseOrderForNAV(activeUser, jobIdList, navAPIUrl, navAPIUserName, navAPIPassword,
                                    string.IsNullOrEmpty(jobData.JobSONumber) ? jobData.JobElectronicInvoiceSONumber : jobData.JobSONumber, jobData.JobElectronicInvoice, purchaseOrderItemRequest);
                            }
                            else
                            {
                                manualPurchaseOrder = UpdatePurchaseOrderForNAV(activeUser, jobIdList,
                                    string.IsNullOrEmpty(jobData.JobPONumber) ? jobData.JobElectronicInvoicePONumber : jobData.JobPONumber, navAPIUrl, navAPIUserName, navAPIPassword,
                                    string.IsNullOrEmpty(jobData.JobSONumber) ? jobData.JobElectronicInvoiceSONumber : string.IsNullOrEmpty(jobData.JobSONumber) ? jobData.JobElectronicInvoiceSONumber : jobData.JobSONumber,
                                    jobData.JobElectronicInvoice, purchaseOrderItemRequest);
                            }
                        }
                    }
                    else
                    {
                        if (isManualInvoice)
                        {
                            if (string.IsNullOrEmpty(jobData.JobPONumber))
                            {
                                manualPurchaseOrder = GeneratePurchaseOrderForNAV(activeUser, jobIdList, navAPIUrl, navAPIUserName, navAPIPassword,
                                    string.IsNullOrEmpty(jobData.JobSONumber) ? jobData.JobElectronicInvoiceSONumber : jobData.JobSONumber, false, manualPurchaseOrderItemRequest);
                            }
                            else
                            {
                                manualPurchaseOrder = UpdatePurchaseOrderForNAV(activeUser, jobIdList, string.IsNullOrEmpty(jobData.JobPONumber) ? jobData.JobElectronicInvoicePONumber : jobData.JobPONumber, navAPIUrl, navAPIUserName, navAPIPassword,
                                string.IsNullOrEmpty(jobData.JobSONumber) ? jobData.JobElectronicInvoiceSONumber : jobData.JobSONumber, false, manualPurchaseOrderItemRequest);
                            }
                        }

                        if (isElectronicInvoice)
                        {
                            if (string.IsNullOrEmpty(jobData.JobElectronicInvoicePONumber))
                            {
                                electronicPurchaseOrder = GeneratePurchaseOrderForNAV(activeUser, jobIdList, navAPIUrl, navAPIUserName, navAPIPassword,
                                string.IsNullOrEmpty(jobData.JobElectronicInvoiceSONumber) ? jobData.JobSONumber : jobData.JobElectronicInvoiceSONumber, true, electronicPurchaseOrderItemRequest);
                            }
                            else
                            {
                                electronicPurchaseOrder = UpdatePurchaseOrderForNAV(activeUser, jobIdList, !string.IsNullOrEmpty(jobData.JobElectronicInvoicePONumber) ? jobData.JobElectronicInvoicePONumber : jobData.JobPONumber, navAPIUrl, navAPIUserName, navAPIPassword,
                                string.IsNullOrEmpty(jobData.JobElectronicInvoiceSONumber) ? jobData.JobSONumber : jobData.JobElectronicInvoiceSONumber, true, electronicPurchaseOrderItemRequest);
                            }
                        }
                    }
                }
            }
        }
    }
}
